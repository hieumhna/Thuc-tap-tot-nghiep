using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using WebBanDienThoai.Models;
using PagedList;
using System.Web.Configuration;
using WebBanDienThoai.ApiControllers;
using System.Threading.Tasks;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;

namespace WebBanDienThoai.Controllers
{
    public class ProductsController : Controller
    {
        // GET: Products

        Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities();

        [ChildActionOnly]
        public ActionResult FirstStyleProducts()
        {
            return PartialView();
        }

        [ChildActionOnly]
        public ActionResult SecondStyleProducts()
        {
            Random random = new Random();

            // API GetProducts 

            ApiControllers.ProductController productControllerApi = new ApiControllers.ProductController();

            List<SANPHAM> products = new List<SANPHAM>();

            foreach (var item in productControllerApi.GetProducts())
            {
                products.Add(db.SANPHAMs.Where(row => row.MaSP == item.ProductId).SingleOrDefault());
            }

            List<SANPHAM>  productsCheck = products.Where(row => row.DonGia != null && row.DaXoa == false && (row.CHITIETSANPHAM.Count > 0 || row.CHITIETPHUKIENTAINGHE.Count > 0 || row.CHITIETPHUKIENSACDUPHONG.Count > 0)).ToList();
            List<SANPHAM> randomProducts = productsCheck.OrderBy(row => random.Next()).ToList();
            List<SANPHAM> newProducts = randomProducts.Take(6).ToList();

            return PartialView(newProducts);
        }

        public ActionResult Products(int? page, int? MaLoaiSP = null, string keyWord = null, decimal? minPrice = null, decimal? maxPrice = null, bool? sort = null)
        {
            if (MaLoaiSP == null && keyWord == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            decimal? MinPrice = minPrice ?? 0;
            decimal? MaxPrice = maxPrice ?? db.SANPHAMs.Max(row => row.DonGia);

            List<SANPHAM> products = new List<SANPHAM>();

            List<SANPHAM> checkProducts = new List<SANPHAM>();
            if (MaLoaiSP != null)
            {
                checkProducts = db.SANPHAMs.Where(product => product.MaLoaiSP == MaLoaiSP && product.DaXoa == false && (product.CHITIETSANPHAM.Count > 0 || product.CHITIETPHUKIENTAINGHE.Count > 0 || product.CHITIETPHUKIENSACDUPHONG.Count > 0)).ToList();
            }
            else
            {
                if (keyWord != null)
                {
                    checkProducts = db.SANPHAMs.Where(row => row.TenSP.Contains(keyWord) && row.DaXoa == false && (row.CHITIETSANPHAM.Count > 0 || row.CHITIETPHUKIENTAINGHE.Count > 0 || row.CHITIETPHUKIENSACDUPHONG.Count > 0)).ToList();
                }
            }

            foreach(var product in checkProducts)
            {
                decimal? deal = product.DonGia;
                decimal percent = 0;

                if (product.MaKhuyenMai != null)
                {
                    if (DateTime.Now >= product.KHUYENMAI.NgayBatDau && DateTime.Now <= product.KHUYENMAI.NgayKetThuc)
                    {
                        percent = product.KHUYENMAI.PhanTramGiamGia;
                    }
                }

                decimal? price = deal - (deal * (percent / 100));

                if (price >= MinPrice &&  price <= MaxPrice)
                {
                    products.Add(product);
                }
            }

            ViewBag.MinPriceSelect = MinPrice;
            ViewBag.MaxPriceSelect = MaxPrice;
            ViewBag.MinPrice = 0;
            ViewBag.MaxPrice = db.SANPHAMs.Max(row => row.DonGia);

            if (MaLoaiSP != null)
            {
                ViewBag.CategoryName = db.LOAISANPHAMs.Where(category => category.MaLoaiSP == MaLoaiSP).Select(category => category.TenLoaiSP).FirstOrDefault();
                ViewBag.ProductTypeId = MaLoaiSP;
            }
            else
            {
                if (keyWord != null)
                {
                    ViewBag.KeyWord = keyWord;
                    ViewBag.ProductCount = products.Count;
                }
            }

            if (Request.HttpMethod != "GET")
            {
                page = 1;
            }

            int pageSize = 12;
            int pageNumber = page ?? 1;

            ViewBag.Sort = sort;

            if (sort == null)
            {
                return View(products.OrderBy(row => row.TenSP).ToPagedList(pageNumber, pageSize));
            }
            else
            {
                if (sort == true)
                {
                    return View(products.OrderBy(row => row.DonGia).ToPagedList(pageNumber, pageSize));
                }
                else
                {
                    return View(products.OrderByDescending(row => row.DonGia).ToPagedList(pageNumber, pageSize));
                }
            }
        }

        [HttpPost]
        public ActionResult GetKeyWord(string keyWord)
        {
            return RedirectToAction("Products", "Products", new { @keyWord = keyWord });
        }

        public ActionResult ProductDetails(int? MaSP)
        {
            if (MaSP == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == MaSP && row.DaXoa == false).SingleOrDefault();

            if (product == null)
            {
                return HttpNotFound();
            }

            int categoryId = product.MaLoaiSP;
            int listId = db.LOAISANPHAMs.Where(row => row.MaLoaiSP == categoryId).Select(row => row.MaDanhMuc).FirstOrDefault();
            int producerId = product.MaNSX;

            ViewBag.NameList = db.DANHMUCs.Where(row => row.MaDanhMuc == listId).Select(row => row.TenDanhMuc).FirstOrDefault();
            ViewBag.Producer = db.NHASANXUATs.Where(row => row.MaNSX == producerId).Select(row => row.TenNSX).FirstOrDefault();
            ViewBag.Describe = product.MoTa.Split('.');

            if (listId == db.DANHMUCs.Where(row => row.TenDanhMuc == "Điện thoại").Select(row => row.MaDanhMuc).SingleOrDefault())
            {
                ViewBag.Type = "Phone";
                ViewBag.Guarantee = db.CHITIETSANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.BAOHANH).SingleOrDefault();
            }
            else
            {
                if (categoryId == db.LOAISANPHAMs.Where(row => row.TenLoaiSP == "Sạc dự phòng").Select(row => row.MaLoaiSP).SingleOrDefault())
                {
                    ViewBag.Type = "BackupCharger";
                    ViewBag.Guarantee = db.CHITIETPHUKIENSACDUPHONGs.Where(row => row.MaSP == MaSP).Select(row => row.BAOHANH).SingleOrDefault();
                }
                else
                {
                    if (categoryId == db.LOAISANPHAMs.Where(row => row.TenLoaiSP == "Tai nghe").Select(row => row.MaLoaiSP).SingleOrDefault())
                    {
                        ViewBag.Type = "HeadPhone";
                        ViewBag.Guarantee = db.CHITIETPHUKIENTAINGHEs.Where(row => row.MaSP == MaSP).Select(row => row.BAOHANH).SingleOrDefault();
                    }
                }
            }

            List<int> corlorIds = db.SANPHAM_MAUs.Where(row => row.MaSP == MaSP).Select(row => row.MaMau).ToList();
            List<MAU> productColors = db.MAUs.Where(row => corlorIds.Contains(row.MaMau)).ToList();
            ViewBag.ProductColors = productColors;

            return View(product);
        }

        [ChildActionOnly]
        public ActionResult PhoneProductDetails(int? MaSP)
        {
            CHITIETSANPHAM productDetails = db.CHITIETSANPHAMs.Where(row => row.MaSP == MaSP).SingleOrDefault();

            return PartialView(productDetails);
        }

        [ChildActionOnly]
        public ActionResult HeadPhoneProductDetails(int? MaSP)
        {
            CHITIETPHUKIENTAINGHE productDetails = db.CHITIETPHUKIENTAINGHEs.Where(row => row.MaSP == MaSP).SingleOrDefault();

            return PartialView(productDetails);
        }

        [ChildActionOnly]
        public ActionResult BackupChargerProductDetails(int? MaSP)
        {
            CHITIETPHUKIENSACDUPHONG productDetails = db.CHITIETPHUKIENSACDUPHONGs.Where(row => row.MaSP == MaSP).SingleOrDefault();

            return PartialView(productDetails);
        }

        public ActionResult SidebarProducts(int? MaLoaiSP, string keyWord, decimal? minPrice = null, decimal? maxPrice = null)
        {
            List<SANPHAM> products = new List<SANPHAM>();

            products.Add(db.SANPHAMs.Where(row => row.LOAISANPHAM.TenLoaiSP == "Iphone" && row.DaXoa == false && row.DonGia != null && (row.CHITIETSANPHAM.Count > 0 || row.CHITIETPHUKIENTAINGHE.Count > 0 || row.CHITIETPHUKIENSACDUPHONG.Count > 0)).FirstOrDefault());
            products.Add(db.SANPHAMs.Where(row => row.LOAISANPHAM.TenLoaiSP == "Samsung" && row.DaXoa == false && row.DonGia != null && (row.CHITIETSANPHAM.Count > 0 || row.CHITIETPHUKIENTAINGHE.Count > 0 || row.CHITIETPHUKIENSACDUPHONG.Count > 0)).FirstOrDefault());
            products.Add(db.SANPHAMs.Where(row => row.LOAISANPHAM.TenLoaiSP == "Sạc dự phòng" && row.DaXoa == false && row.DonGia != null && (row.CHITIETSANPHAM.Count > 0 || row.CHITIETPHUKIENTAINGHE.Count > 0 || row.CHITIETPHUKIENSACDUPHONG.Count > 0)).FirstOrDefault());

            ViewBag.CategoryId = MaLoaiSP;
            ViewBag.KeyWord = keyWord;
            ViewBag.MinPriceSelect = minPrice;
            ViewBag.MaxPriceSelect = maxPrice;

            return PartialView(products);
        }
    }
}