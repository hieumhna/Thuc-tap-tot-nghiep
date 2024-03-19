using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Entity;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Data.Entity.Migrations;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Runtime.Remoting.Contexts;
using System.Web;
using System.Web.Mvc;
using System.Web.Services.Description;
using WebBanDienThoai.Models;
using PagedList;
using System.Web.UI;
using System.Text.RegularExpressions;
using System.Net.Mail;
using System.Net;
using System.Threading.Tasks;
using System.Web.Security;

namespace WebBanDienThoai.Controllers
{
    [Authorize(Roles = "Admin")]
    public class AdminController : Controller
    {
        Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities();
        // GET: Admin
        public ActionResult Index(int page = 1)
        {
            ViewBag.VisitorNumberPage = HttpContext.Application["PageView"].ToString(); //Lấy số lượng truy cập từ aplication đã được tạo
            ViewBag.NumberOfPeopleOnline = HttpContext.Application["Online"].ToString();

            if (TotalRevenueStatistics() == 0)
            {
                ViewBag.TotalRevenueStatistics = 0;
            }
            else
            {
                ViewBag.TotalRevenueStatistics = TotalRevenueStatistics();
            }

            // Lấy tháng và năm hiện tại
            DateTime currentDate = DateTime.Now;
            int currentMonth = currentDate.Month;
            int currentYear = currentDate.Year;
            if (TotalRevenueStatisticsByMonthAndYear(currentMonth, currentYear) == 0)
            {
                ViewBag.TotalRevenueStatisticsByMonthAndYear = 0;
            }
            else
            {
                ViewBag.TotalRevenueStatisticsByMonthAndYear = TotalRevenueStatisticsByMonthAndYear(currentMonth, currentYear);
            }
            if (StatisticBill() == 0)
            {
                ViewBag.StatisticBill = 0;
            }
            else
            {
                ViewBag.StatisticBill = StatisticBill();
            }

            List<DONDATHANG> listBill = db.DONDATHANGs.Where(row => row.TinhTrang == "Đã giao" && row.DaThanhToan == true).Include(row => row.KHACHHANG).Include(row => row.CHITIETDONDATHANG).ToList();

            //paging
            int NoOfRecorPerPage = 6;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(listBill.Count) / Convert.ToDouble(NoOfRecorPerPage)));// Đếm trang //Ceiling: làm tròn
            int NoOOfRecorddToSkip = (page - 1) * NoOfRecorPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            listBill = listBill.Skip(NoOOfRecorddToSkip).Take(NoOfRecorPerPage).ToList();

            return View(listBill);
        }

        [ChildActionOnly]
        public ActionResult Hearder_Starts() // Header
        {
            return PartialView();
        }

        [ChildActionOnly]
        public ActionResult Admin_Sidebar() // Sidebar-left
        {
            List<LOAISANPHAM> productCategories = db.LOAISANPHAMs.ToList();
            return PartialView(productCategories);
        }

        #region Products       

        //Show danh sách sản phẩm
        [HttpGet]
        public ActionResult Admin_Product(int? MaLoaiSP, string search = "", int page = 1)
        {
            List<SANPHAM> products = db.SANPHAMs.Where(row => row.MaLoaiSP == MaLoaiSP && row.TenSP.Contains(search) && row.DaXoa == false).ToList(); //Sort
            ViewBag.CategoryName = db.LOAISANPHAMs.Where(row => row.MaLoaiSP == MaLoaiSP).Select(row => row.TenLoaiSP).SingleOrDefault();
            ViewBag.CategoryID = db.LOAISANPHAMs.Where(row => row.MaLoaiSP == MaLoaiSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            ViewBag.Search = search;

            //paging
            int NoOfRecorPerPage = 6;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(products.Count) / Convert.ToDouble(NoOfRecorPerPage)));// Đếm trang //Ceiling: làm tròn
            int NoOOfRecorddToSkip = (page - 1) * NoOfRecorPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            products = products.Skip(NoOOfRecorddToSkip).Take(NoOfRecorPerPage).ToList();

            return View(products);
        }

        //Thên chương trình khuyến mãi
        [HttpGet]
        public ActionResult ImportPromotion(int MaSP)
        {
            ViewBag.ProductName = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.TenSP).SingleOrDefault();
            ViewBag.ProductID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaSP).SingleOrDefault();
            ViewBag.ListPromition = db.KHUYENMAIs;
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.LOAISANPHAM.MaLoaiSP).FirstOrDefault();
            return View();
        }
        [HttpPost]
        public ActionResult ImportPromotion(SANPHAM pro, int MaSP, int MaKhuyenMai)
        {
            ViewBag.ProductName = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.TenSP).SingleOrDefault();
            ViewBag.ProductID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaSP).SingleOrDefault();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.LOAISANPHAM.MaLoaiSP).FirstOrDefault();
            ViewBag.ListPromotion = db.KHUYENMAIs;

            // Find the product by MaSP
            var product = db.SANPHAMs.FirstOrDefault(p => p.MaSP == MaSP);

            if (product != null)
            {
                // Update the MaKhuyenMai property with the selected MaKhuyenMai value
                product.MaKhuyenMai = MaKhuyenMai;

                // Update the product entity
                db.Entry(product).State = EntityState.Modified;
                db.SaveChanges();
            }

            return RedirectToAction("Admin_Product", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }
        //Thêm màu cho sản phẩm
        [HttpGet]
        public ActionResult CreateColorProduct(int? id)
        {
            ViewBag.ListColor = db.MAUs;
            ViewBag.TenSP = db.SANPHAMs.Where(row => row.MaSP == id).Select(row => row.TenSP).SingleOrDefault();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == id).Select(row => row.LOAISANPHAM.MaLoaiSP).FirstOrDefault();
            ViewBag.GetImages = db.SANPHAMs.Where(row => row.MaSP == id).SingleOrDefault();
            return View();
        }

        [HttpPost]
        public ActionResult CreateColorProduct(IEnumerable<int> MaMau, int id)
        {
            ViewBag.ListColor = db.MAUs;
            ViewBag.TenSP = db.SANPHAMs.Where(row => row.MaSP == id).Select(row => row.TenSP).SingleOrDefault();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == id).Select(row => row.LOAISANPHAM.MaLoaiSP).FirstOrDefault();
            ViewBag.GetImages = db.SANPHAMs.Where(row => row.MaSP == id).SingleOrDefault();

            foreach (var mau in MaMau)
            {
                var sanphammau = new SANPHAM_MAU
                {
                    MaSP = id,
                    MaMau = mau
                };
                db.SANPHAM_MAUs.Add(sanphammau);
            }

            db.SaveChanges();
            return RedirectToAction("Admin_Product", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }
        //Thêm sản phẩm
        public ActionResult CreatePhoneProducts()
        {
            ViewBag.MaNCC = new SelectList(db.NHACUNGCAPs.OrderBy(row => row.MaNCC), "MaNCC", "TenNCC");
            ViewBag.MaNSX = new SelectList(db.NHASANXUATs.OrderBy(row => row.MaNSX), "MaNSX", "TenNSX");
            ViewBag.MaLoaiSP = new SelectList(db.LOAISANPHAMs.OrderBy(row => row.MaLoaiSP), "MaLoaiSP", "TenLoaiSP");

            return View();
        }
        [ValidateInput(false)]
        [HttpPost]
        public ActionResult CreatePhoneProducts(SANPHAM products, HttpPostedFileBase HinhAnh, HttpPostedFileBase HinhAnh2, HttpPostedFileBase HinhAnh3)
        {
            ViewBag.MaNCC = new SelectList(db.NHACUNGCAPs.OrderBy(row => row.MaNCC), "MaNCC", "TenNCC");
            ViewBag.MaNSX = new SelectList(db.NHASANXUATs.OrderBy(row => row.MaNSX), "MaNSX", "TenNSX");
            ViewBag.MaLoaiSP = new SelectList(db.LOAISANPHAMs.OrderBy(row => row.MaLoaiSP), "MaLoaiSP", "TenLoaiSP");

            try
            {
                if (HinhAnh.ContentLength > 0)
                {
                    //Lấy tên hình ảnh
                    var fileName = Path.GetFileName(HinhAnh.FileName);
                    //
                    var path = Path.Combine(Server.MapPath("~/Content/Images/Products"), fileName);

                    //Lấy hình đưa vào thư mục
                    HinhAnh.SaveAs(path);
                    products.HinhAnh = fileName;
                }
                if (HinhAnh2.ContentLength > 0)
                {
                    //Lấy tên hình ảnh
                    var fileName = Path.GetFileName(HinhAnh2.FileName);
                    //
                    var path = Path.Combine(Server.MapPath("~/Content/Images/Products"), fileName);

                    //Lấy hình đưa vào thư mục
                    HinhAnh2.SaveAs(path);
                    products.HinhAnh2 = fileName;
                }
                if (HinhAnh3.ContentLength > 0)
                {
                    //Lấy tên hình ảnh
                    var fileName = Path.GetFileName(HinhAnh3.FileName);
                    //
                    var path = Path.Combine(Server.MapPath("~/Content/Images/Products"), fileName);

                    //Lấy hình đưa vào thư mục
                    HinhAnh3.SaveAs(path);
                    products.HinhAnh3 = fileName;
                }
            }
            catch { }
            products.SoLanMua = 0;
            db.SANPHAMs.Add(products);
            db.SaveChanges();

            return RedirectToAction("Admin_Product", new { MaLoaiSP = products.MaLoaiSP });
        }

        //Sửa sản phẩm
        public ActionResult EditPhoneProducts(int? MaSP)
        {
            //Select option
            //ViewBag.SupplierName = db.NHACUNGCAPs.ToList();
            //ViewBag.ProducerName = db.NHASANXUATs.ToList();
            //ViewBag.CategoryName = db.LOAISANPHAMs.ToList();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            if (MaSP == null)
            {
                Response.StatusCode = 404;
                return null;
            }

            SANPHAM products = db.SANPHAMs.SingleOrDefault(row => row.MaSP == MaSP);

            if (products == null)
            {
                return HttpNotFound();
            }

            ViewBag.MaNCC = new SelectList(db.NHACUNGCAPs.OrderBy(row => row.MaNCC), "MaNCC", "TenNCC", products.MaNCC);
            ViewBag.MaNSX = new SelectList(db.NHASANXUATs.OrderBy(row => row.MaNSX), "MaNSX", "TenNSX", products.MaNSX);
            ViewBag.MaLoaiSP = new SelectList(db.LOAISANPHAMs.OrderBy(row => row.MaLoaiSP), "MaLoaiSP", "TenLoaiSP", products.MaLoaiSP);

            return View(products);
        }
        [HttpPost]
        public ActionResult EditPhoneProducts(SANPHAM model, HttpPostedFileBase HinhAnh, HttpPostedFileBase HinhAnh2, HttpPostedFileBase HinhAnh3)
        {
            ViewBag.MaNCC = new SelectList(db.NHACUNGCAPs.OrderBy(row => row.MaNCC), "MaNCC", "TenNCC", model.MaNCC);
            ViewBag.MaNSX = new SelectList(db.NHASANXUATs.OrderBy(row => row.MaNSX), "MaNSX", "TenNSX", model.MaNSX);
            ViewBag.MaLoaiSP = new SelectList(db.LOAISANPHAMs.OrderBy(row => row.MaLoaiSP), "MaLoaiSP", "TenLoaiSP", model.MaLoaiSP);

            SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == model.MaSP).SingleOrDefault();

            product.MaNCC = model.MaNCC;
            product.MaNSX = model.MaNSX;
            product.MaLoaiSP = model.MaLoaiSP;
            product.TenSP = model.TenSP;
            product.NgayCapNhat = model.NgayCapNhat;
            product.MoTa = model.MoTa;
            product.Moi = model.Moi;
            product.DaXoa = model.DaXoa;

            try
            {
                if (HinhAnh.ContentLength > 0)
                {
                    //Lấy tên hình ảnh
                    var fileName = Path.GetFileName(HinhAnh.FileName);
                    //
                    var path = Path.Combine(Server.MapPath("~/Content/Images/Products"), fileName);

                    //Lấy hình đưa vào thư mục
                    HinhAnh.SaveAs(path);
                    product.HinhAnh = fileName;
                }
                if (HinhAnh2.ContentLength > 0)
                {
                    //Lấy tên hình ảnh
                    var fileName = Path.GetFileName(HinhAnh2.FileName);
                    //
                    var path = Path.Combine(Server.MapPath("~/Content/Images/Products"), fileName);

                    //Lấy hình đưa vào thư mục
                    HinhAnh2.SaveAs(path);
                    product.HinhAnh2 = fileName;
                }
                if (HinhAnh3.ContentLength > 0)
                {
                    //Lấy tên hình ảnh
                    var fileName = Path.GetFileName(HinhAnh3.FileName);
                    //
                    var path = Path.Combine(Server.MapPath("~/Content/Images/Products"), fileName);

                    //Lấy hình đưa vào thư mục
                    HinhAnh3.SaveAs(path);
                    product.HinhAnh3 = fileName;
                }
            }
            catch { }

            // Nếu có thay đổi hình ảnh, cập nhật dữ liệu trong CSDL
            db.Entry(product).State = EntityState.Modified;
            db.SaveChanges();
            return RedirectToAction("Admin_Product", "Admin", new { MaLoaiSP = model.MaLoaiSP });
        }

        //Xóa sản phẩm
        [HttpGet]
        public ActionResult DeletePhoneProducts(int? MaSP)
        {
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            if (MaSP == null)
            {
                Response.StatusCode = 404;
                return null;
            }

            SANPHAM products = db.SANPHAMs.SingleOrDefault(row => row.MaSP == MaSP);

            if (products == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaNCC = new SelectList(db.NHACUNGCAPs.OrderBy(row => row.MaNCC), "MaNCC", "TenNCC", products.MaNCC);
            ViewBag.MaNSX = new SelectList(db.NHASANXUATs.OrderBy(row => row.MaNSX), "MaNSX", "TenNSX", products.MaNSX);
            ViewBag.MaLoaiSP = new SelectList(db.LOAISANPHAMs.OrderBy(row => row.MaLoaiSP), "MaLoaiSP", "TenLoaiSP", products.MaLoaiSP);
            return View(products);
        }
        [HttpPost]
        public ActionResult DeletePhoneProducts(int MaSP)
        {
            //ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == id).Select(row => row.MaLoaiSP).FirstOrDefault();

            SANPHAM products = db.SANPHAMs.SingleOrDefault(row => row.MaSP == MaSP);

            if (products == null)
            {
                return HttpNotFound();
            }

            products.DaXoa = true;

            //List<CHITIETPHIEUNHAP> ctpn = db.CHITIETPHIEUNHAPs.Where(row => row.MaSP == MaSP).ToList();
            //db.CHITIETPHIEUNHAPs.RemoveRange(ctpn);
            //db.SaveChanges();

            //List<SANPHAM_MAU> sp_mau = db.SANPHAM_MAUs.Where(row => row.MaSP == MaSP).ToList();
            //db.SANPHAM_MAUs.RemoveRange(sp_mau);
            //db.SaveChanges();

            db.SANPHAMs.AddOrUpdate(products);
            db.SaveChanges();

            return RedirectToAction("Admin_Product", "Admin", new { MaLoaiSP = products.MaLoaiSP });
        }
        #endregion Products

        #region ProductsDetails

        //Show chi tiết sản phẩm
        public ActionResult Admin_ProductDetails(int? MaSP)
        {
            ViewBag.ProductName = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.TenSP).SingleOrDefault(); //Lấy tên SP
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault(); //Lấy mã loại SP    
            if (ViewBag.CategoryID == 1 || ViewBag.CategoryID == 2 || ViewBag.CategoryID == 3 || ViewBag.CategoryID == 4 || ViewBag.CategoryID == 5)
            {
                ViewBag.Phone = db.CHITIETSANPHAMs.Where(row => row.MaSP == MaSP).FirstOrDefault();
                if (ViewBag.Phone == null)
                {
                    return RedirectToAction("CreatePhoneProductDetails", "Admin", new { MaSP = MaSP });
                }
                else
                {
                    CHITIETSANPHAM productDetails = db.CHITIETSANPHAMs.Where(row => row.MaSP == MaSP).FirstOrDefault();
                    return View(productDetails);
                }
            }
            else
            {
                if (ViewBag.CategoryID == 6)
                {
                    ViewBag.Backupcharger = db.CHITIETPHUKIENSACDUPHONGs.Where(row => row.MaSP == MaSP).FirstOrDefault();
                    if (ViewBag.Backupcharger == null)
                    {
                        return RedirectToAction("CreateBackupchargerProductDetails", "Admin", new { MaSP = MaSP });
                    }
                    else
                    {
                        CHITIETPHUKIENSACDUPHONG productDetails = db.CHITIETPHUKIENSACDUPHONGs.Where(row => row.MaSP == MaSP).FirstOrDefault();
                        return View(productDetails);
                    }
                }
                else
                {
                    if (ViewBag.CategoryID == 7)
                    {
                        ViewBag.Earphone = db.CHITIETPHUKIENTAINGHEs.Where(row => row.MaSP == MaSP).FirstOrDefault();
                        if (ViewBag.Earphone == null)
                        {
                            return RedirectToAction("CreateEarPhoneProductDetails", "Admin", new { MaSP = MaSP });
                        }
                        else
                        {
                            CHITIETPHUKIENTAINGHE productDetails = db.CHITIETPHUKIENTAINGHEs.Where(row => row.MaSP == MaSP).FirstOrDefault();
                            return View(productDetails);
                        }
                    }
                }
            }
            return RedirectToAction("Index", "Admin");
        }

        //Show danh sách chi tiết sản phẩm
        public ActionResult Admin_ListProductDetails(int? MaLoaiSP, int page = 1)
        {
            ViewBag.CategoryName = db.LOAISANPHAMs.Where(row => row.MaLoaiSP == MaLoaiSP).Select(row => row.TenLoaiSP).SingleOrDefault();
            ViewBag.CategoryID = db.LOAISANPHAMs.Where(row => row.MaLoaiSP == MaLoaiSP).Select(row => row.MaLoaiSP).SingleOrDefault(); //Lấy mã loại SP    

            if (ViewBag.CategoryID == 1 || ViewBag.CategoryID == 2 || ViewBag.CategoryID == 3 || ViewBag.CategoryID == 4 || ViewBag.CategoryID == 5)
            {
                ViewBag.Phone = db.CHITIETSANPHAMs.Where(row => row.SANPHAM.LOAISANPHAM.MaLoaiSP == MaLoaiSP).ToList();
                return View();
            }
            else
            {
                if (ViewBag.CategoryID == 6)
                {
                    ViewBag.Backupcharger = db.CHITIETPHUKIENSACDUPHONGs.Where(row => row.SANPHAM.LOAISANPHAM.MaLoaiSP == MaLoaiSP).ToList();
                    return View();
                }
                else
                {
                    if (ViewBag.CategoryID == 7)
                    {
                        ViewBag.Earphone = db.CHITIETPHUKIENTAINGHEs.Where(row => row.SANPHAM.LOAISANPHAM.MaLoaiSP == MaLoaiSP).ToList();
                        return View();
                    }
                }
            }
            return RedirectToAction("Index", "Admin");
        }

        //Thêm chi tiết điện thoại
        public ActionResult CreatePhoneProductDetails(int? MaSP)
        {
            ViewBag.ProductsName = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.TenSP).SingleOrDefault();
            ViewBag.ProductsID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaSP).SingleOrDefault();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.LOAISANPHAM.MaLoaiSP).FirstOrDefault();

            CHITIETSANPHAM ProductPhoneDetails = db.CHITIETSANPHAMs.Where(row => row.MaSP == MaSP).SingleOrDefault();
            return View(ProductPhoneDetails);
        }
        [HttpPost]
        public ActionResult CreatePhoneProductDetails(CHITIETSANPHAM PhoneProductsDetail, int? MaSP)
        {
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            db.CHITIETSANPHAMs.Add(PhoneProductsDetail);
            db.SaveChanges();
            return RedirectToAction("Admin_Product", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }

        //Thêm chi tiết sạc dự phòng
        public ActionResult CreateBackupchargerProductDetails(int? MaSP)
        {
            ViewBag.ProductsName = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.TenSP).SingleOrDefault();
            ViewBag.ProductsID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaSP).SingleOrDefault();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.LOAISANPHAM.MaLoaiSP).FirstOrDefault();

            CHITIETPHUKIENSACDUPHONG ProductBackupchargerDetails = db.CHITIETPHUKIENSACDUPHONGs.Where(row => row.MaSP == MaSP).SingleOrDefault();
            return View(ProductBackupchargerDetails);
        }
        [HttpPost]
        public ActionResult CreateBackupchargerProductDetails(CHITIETPHUKIENSACDUPHONG BackupchargerProductDetail, int? MaSP)
        {
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            db.CHITIETPHUKIENSACDUPHONGs.Add(BackupchargerProductDetail);
            db.SaveChanges();
            return RedirectToAction("Admin_Product", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }

        //Thêm chi tiết tai nghe
        public ActionResult CreateEarPhoneProductDetails(int? MaSP)
        {
            ViewBag.ProductsName = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.TenSP).SingleOrDefault();
            ViewBag.ProductsID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaSP).SingleOrDefault();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.LOAISANPHAM.MaLoaiSP).FirstOrDefault();

            CHITIETPHUKIENTAINGHE ProductEarPhoneDetails = db.CHITIETPHUKIENTAINGHEs.Where(row => row.MaSP == MaSP).SingleOrDefault();
            return View(ProductEarPhoneDetails);
        }
        [HttpPost]
        public ActionResult CreateEarPhoneProductDetails(CHITIETPHUKIENTAINGHE EarPhoneProductDetail, int? MaSP)
        {
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            db.CHITIETPHUKIENTAINGHEs.Add(EarPhoneProductDetail);
            db.SaveChanges();
            return RedirectToAction("Admin_Product", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }

        //Sửa chi tiết điện thoại
        public ActionResult EditPhoneProductDetails(int? MaSP)
        {
            ViewBag.ProductsID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaSP).SingleOrDefault();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            if (MaSP == null)
            {
                Response.StatusCode = 404;
                return null;
            }

            CHITIETSANPHAM PhoneProductDetails = db.CHITIETSANPHAMs.SingleOrDefault(row => row.MaSP == MaSP);

            if (PhoneProductDetails == null)
            {
                return HttpNotFound();
            }
            return View(PhoneProductDetails);
        }
        [HttpPost]
        public ActionResult EditPhoneProductDetails(CHITIETSANPHAM PhoneProductDetails, int? MaSP)
        {
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            db.CHITIETSANPHAMs.AddOrUpdate(PhoneProductDetails);
            db.SaveChanges();
            return RedirectToAction("Admin_ListProductDetails", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }

        //Sửa chi tiết sạc dự phòng
        public ActionResult EditBackupchargerProductDetails(int? MaSP)
        {
            ViewBag.ProductsID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaSP).SingleOrDefault();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            if (MaSP == null)
            {
                Response.StatusCode = 404;
                return null;
            }

            CHITIETPHUKIENSACDUPHONG BackupchargerProductDetails = db.CHITIETPHUKIENSACDUPHONGs.SingleOrDefault(row => row.MaSP == MaSP);

            if (BackupchargerProductDetails == null)
            {
                return HttpNotFound();
            }
            return View(BackupchargerProductDetails);
        }
        [HttpPost]
        public ActionResult EditBackupchargerProductDetails(CHITIETPHUKIENSACDUPHONG BackupchargerProductDetails, int? MaSP)
        {
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            db.CHITIETPHUKIENSACDUPHONGs.AddOrUpdate(BackupchargerProductDetails);
            db.SaveChanges();
            return RedirectToAction("Admin_ListProductDetails", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }

        //Sửa chi tiết tai nghe
        public ActionResult EditEarPhoneProductDetails(int? MaSP)
        {
            ViewBag.ProductsID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaSP).SingleOrDefault();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            if (MaSP == null)
            {
                Response.StatusCode = 404;
                return null;
            }

            CHITIETPHUKIENTAINGHE EarPhoneProductDetails = db.CHITIETPHUKIENTAINGHEs.SingleOrDefault(row => row.MaSP == MaSP);

            if (EarPhoneProductDetails == null)
            {
                return HttpNotFound();
            }
            return View(EarPhoneProductDetails);
        }
        [HttpPost]
        public ActionResult EditEarPhoneProductDetails(CHITIETPHUKIENTAINGHE EarPhoneProductDetails, int? MaSP)
        {
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaLoaiSP).FirstOrDefault();
            db.CHITIETPHUKIENTAINGHEs.AddOrUpdate(EarPhoneProductDetails);
            db.SaveChanges();
            return RedirectToAction("Admin_ListProductDetails", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }

        //Xóa chi tiết sản phẩm
        [HttpGet]
        public ActionResult DeletePhoneProductDetails(int? MaChiTietSP)
        {
            ViewBag.ProductName = db.CHITIETSANPHAMs.Where(row => row.MaChiTietSP == MaChiTietSP).Select(row => row.SANPHAM.TenSP).SingleOrDefault();
            ViewBag.CategoryID = db.CHITIETSANPHAMs.Where(row => row.MaChiTietSP == MaChiTietSP).Select(row => row.SANPHAM.MaLoaiSP).FirstOrDefault();
            if (MaChiTietSP == null)
            {
                Response.StatusCode = 404;
                return null;
            }
            CHITIETSANPHAM PhoneProductDetails = db.CHITIETSANPHAMs.SingleOrDefault(row => row.MaChiTietSP == MaChiTietSP);
            if (PhoneProductDetails == null)
            {
                return HttpNotFound();
            }

            return View(PhoneProductDetails);
        }
        [HttpPost]
        public ActionResult DeletePhoneProductDetails(int MaChiTietSP)
        {
            CHITIETSANPHAM PhoneProductDetails = db.CHITIETSANPHAMs.SingleOrDefault(row => row.MaChiTietSP == MaChiTietSP);
            ViewBag.CategoryID = db.CHITIETSANPHAMs.Where(row => row.MaChiTietSP == MaChiTietSP).Select(row => row.SANPHAM.MaLoaiSP).FirstOrDefault();
            if (PhoneProductDetails == null)
            {
                return HttpNotFound();
            }

            db.CHITIETSANPHAMs.Remove(PhoneProductDetails);
            db.SaveChanges();
            return RedirectToAction("Admin_ListProductDetails", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }

        //Xóa chi tiết sạc dự phòng
        [HttpGet]
        public ActionResult DeleteBackupchargerProductDetails(int? MaCTPKSac)
        {
            ViewBag.ProductName = db.CHITIETPHUKIENSACDUPHONGs.Where(row => row.MaCTPKSac == MaCTPKSac).Select(row => row.SANPHAM.TenSP).SingleOrDefault();
            ViewBag.CategoryID = db.CHITIETPHUKIENSACDUPHONGs.Where(row => row.MaCTPKSac == MaCTPKSac).Select(row => row.SANPHAM.MaLoaiSP).FirstOrDefault();
            if (MaCTPKSac == null)
            {
                Response.StatusCode = 404;
                return null;
            }
            CHITIETPHUKIENSACDUPHONG BackupchargerProductDetails = db.CHITIETPHUKIENSACDUPHONGs.SingleOrDefault(row => row.MaCTPKSac == MaCTPKSac);
            if (BackupchargerProductDetails == null)
            {
                return HttpNotFound();
            }

            return View(BackupchargerProductDetails);
        }
        [HttpPost]
        public ActionResult DeleteBackupchargerProductDetails(int MaCTPKSac)
        {
            CHITIETPHUKIENSACDUPHONG BackupchargerProductDetails = db.CHITIETPHUKIENSACDUPHONGs.SingleOrDefault(row => row.MaCTPKSac == MaCTPKSac);
            ViewBag.CategoryID = db.CHITIETPHUKIENSACDUPHONGs.Where(row => row.MaCTPKSac == MaCTPKSac).Select(row => row.SANPHAM.MaLoaiSP).FirstOrDefault();
            if (BackupchargerProductDetails == null)
            {
                return HttpNotFound();
            }

            db.CHITIETPHUKIENSACDUPHONGs.Remove(BackupchargerProductDetails);
            db.SaveChanges();
            return RedirectToAction("Admin_ListProductDetails", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }

        //Xóa chi tiết tai nghe
        [HttpGet]
        public ActionResult DeleteEarPhoneProductDetails(int? MaPKTaiNghe)
        {
            ViewBag.ProductName = db.CHITIETPHUKIENTAINGHEs.Where(row => row.MaPKTaiNghe == MaPKTaiNghe).Select(row => row.SANPHAM.TenSP).SingleOrDefault();
            ViewBag.CategoryID = db.CHITIETPHUKIENTAINGHEs.Where(row => row.MaPKTaiNghe == MaPKTaiNghe).Select(row => row.SANPHAM.MaLoaiSP).FirstOrDefault();
            if (MaPKTaiNghe == null)
            {
                Response.StatusCode = 404;
                return null;
            }
            CHITIETPHUKIENTAINGHE EarPhoneProductDetails = db.CHITIETPHUKIENTAINGHEs.SingleOrDefault(row => row.MaPKTaiNghe == MaPKTaiNghe);
            if (EarPhoneProductDetails == null)
            {
                return HttpNotFound();
            }

            return View(EarPhoneProductDetails);
        }
        [HttpPost]
        public ActionResult DeleteEarPhoneProductDetails(int MaPKTaiNghe)
        {
            CHITIETPHUKIENTAINGHE EarPhoneProductDetails = db.CHITIETPHUKIENTAINGHEs.SingleOrDefault(row => row.MaPKTaiNghe == MaPKTaiNghe);
            ViewBag.CategoryID = db.CHITIETPHUKIENTAINGHEs.Where(row => row.MaPKTaiNghe == MaPKTaiNghe).Select(row => row.SANPHAM.MaLoaiSP).FirstOrDefault();
            if (EarPhoneProductDetails == null)
            {
                return HttpNotFound();
            }

            db.CHITIETPHUKIENTAINGHEs.Remove(EarPhoneProductDetails);
            db.SaveChanges();
            return RedirectToAction("Admin_ListProductDetails", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }
        #endregion ProductSDetails

        #region Import Product

        //Nhập một sản phẩm 
        [HttpGet]
        public ActionResult ImportProduct(int? MaSP)
        {
            ViewBag.TenSP = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.TenSP).SingleOrDefault();
            int mancc = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaNCC).SingleOrDefault();
            ViewBag.ListNCC = db.NHACUNGCAPs.Where(row => row.MaNCC == mancc).ToList();
            ViewBag.ListSanPham = db.SANPHAMs.Where(row => row.MaSP == MaSP).ToList();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.LOAISANPHAM.MaLoaiSP).FirstOrDefault();
            return View();
        }

        [HttpPost]
        public ActionResult ImportProduct(PHIEUNHAP model, CHITIETPHIEUNHAP ctpn, int? MaSP)
        {
            ViewBag.TenSP = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.TenSP).SingleOrDefault();
            int mancc = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.MaNCC).SingleOrDefault();
            ViewBag.ListNCC = db.NHACUNGCAPs.Where(row => row.MaNCC == mancc).ToList();
            ViewBag.ListSanPham = db.SANPHAMs.Where(row => row.MaSP == MaSP).ToList();
            ViewBag.CategoryID = db.SANPHAMs.Where(row => row.MaSP == MaSP).Select(row => row.LOAISANPHAM.MaLoaiSP).FirstOrDefault();

            model.DaXoa = false;
            db.PHIEUNHAPs.Add(model);
            db.SaveChanges();

            ctpn.MaPN = model.MaPN;
            SANPHAM Product = db.SANPHAMs.Single(row => row.MaSP == ctpn.MaSP);
            Product.SoLuongTon += ctpn.SoLuongNhap;
            Product.DonGia = ctpn.DonGiaNhap * 1.5m;

            db.CHITIETPHIEUNHAPs.Add(ctpn);
            db.SaveChanges();
            return RedirectToAction("Admin_Product", "Admin", new { MaLoaiSP = ViewBag.CategoryID });
        }

        //Nhập danh sách sản phẩm
        [HttpGet]
        public ActionResult ImportListProduct()
        {
            //ViewBag.MaNCC = new SelectList(db.NHACUNGCAPs.OrderBy(row => row.MaNCC), "MaNCC", "TenNCC");
            ViewBag.ListNCC = db.NHACUNGCAPs;
            ViewBag.ListSanPham = db.SANPHAMs;
            return View();
        }

        [HttpPost]
        public ActionResult ImportListProduct(PHIEUNHAP model, IEnumerable<CHITIETPHIEUNHAP> lstModel)
        {
            ViewBag.ListNCC = db.NHACUNGCAPs;
            ViewBag.ListSanPham = db.SANPHAMs;

            model.DaXoa = false;
            db.PHIEUNHAPs.Add(model);
            db.SaveChanges();
            //Save changes để lấy mã phiếu nhập gán cho lstChiTietPhieuNhap
            SANPHAM Product;
            foreach (var item in lstModel)
            {
                //Cập nhật số lượng tồn
                Product = db.SANPHAMs.Single(row => row.MaSP == item.MaSP);
                Product.SoLuongTon += item.SoLuongNhap;
                Product.DonGia = item.DonGiaNhap * 1.5m;
                //Gán mã phiếu nhập vào chi tiết phiếu nhập
                item.MaPN = model.MaPN;
            }
            db.CHITIETPHIEUNHAPs.AddRange(lstModel);
            db.SaveChanges();
            return RedirectToAction("Admin_Product", "Admin", new { MaLoaiSP = 1 });
        }

        //Xử lý chọn nhà cung cấp
        public JsonResult GetProductsBySupplier(int maNCC)
        {
            // Thực hiện truy vấn cơ sở dữ liệu để lấy danh sách sản phẩm tương ứng với maNCC
            var products = db.SANPHAMs.Where(sp => sp.MaNCC == maNCC).Select(sp => new
            {
                MaSP = sp.MaSP,
                TenSP = sp.TenSP
            }).ToList();

            // Trả về danh sách sản phẩm dưới dạng JSON
            return Json(products, JsonRequestBehavior.AllowGet);
        }

        //Danh sách phiếu nhập
        [HttpGet]
        public ActionResult Admin_WarehouseImportList(string searchName = "", int page = 1)
        {
            var importList = (from pn in db.PHIEUNHAPs
                              join ctpn in db.CHITIETPHIEUNHAPs on pn.MaPN equals ctpn.MaPN
                              join sp in db.SANPHAMs on ctpn.MaSP equals sp.MaSP
                              join ncc in db.NHACUNGCAPs on sp.MaNCC equals ncc.MaNCC
                              where string.IsNullOrEmpty(searchName) || sp.TenSP.Contains(searchName) || ncc.TenNCC.Contains(searchName)
                              select new WarehouseModel
                              {
                                  MaPN = pn.MaPN,
                                  TenNCC = ncc.TenNCC,
                                  TenSP = sp.TenSP,
                                  NgayNhap = pn.NgayNhap,
                                  DonGiaNhap = ctpn.DonGiaNhap,
                                  SoLuong = ctpn.SoLuongNhap
                              }).ToList();


            //paging
            int NoOfRecorPerPage = 12;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(importList.Count) / Convert.ToDouble(NoOfRecorPerPage)));// Đếm trang //Ceiling: làm tròn
            int NoOOfRecorddToSkip = (page - 1) * NoOfRecorPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            importList = importList.Skip(NoOOfRecorddToSkip).Take(NoOfRecorPerPage).ToList();

            return View(importList);
        }

        #endregion Import Product

        #region Promotion

        public ActionResult Promotion(int page = 1)
        {
            List<KHUYENMAI> promo = db.KHUYENMAIs.ToList();
            //paging
            int NoOfRecorPerPage = 6;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(promo.Count) / Convert.ToDouble(NoOfRecorPerPage)));// Đếm trang //Ceiling: làm tròn
            int NoOOfRecorddToSkip = (page - 1) * NoOfRecorPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            promo = promo.Skip(NoOOfRecorddToSkip).Take(NoOfRecorPerPage).ToList();

            return View(promo);
        }

        [HttpGet]
        public ActionResult CreatePromotion()
        {
            return View();
        }

        [HttpPost]
        public ActionResult CreatePromotion(KHUYENMAI promotion)
        {
            db.KHUYENMAIs.Add(promotion);
            db.SaveChanges();
            return RedirectToAction("Promotion", "Admin");
        }

        [HttpPost]
        public ActionResult CheckDuplicatePromotion(string tenKhuyenMai)
        {
            // Kiểm tra xem tên chương trình đã tồn tại trong cơ sở dữ liệu hay chưa
            bool isDuplicate = db.KHUYENMAIs.Any(k => k.TenKhuyenMai == tenKhuyenMai);
            return Json(isDuplicate);
        }
        #endregion Promotion

        #region AproveOrders
        public ActionResult BrowseOrders()
        {
            return View();
        }

        //Chưa thanh toán
        public ActionResult Unpaid()
        {
            List<DONDATHANG> listUnpaid = db.DONDATHANGs.Where(row => row.TinhTrang == "Chưa duyệt" && row.DaXoa == false).OrderBy(row => row.NgayDatHang).Include(row => row.KHACHHANG).ToList();

            return PartialView(listUnpaid);
        }

        //Chưa giao hàng
        public ActionResult NotDelivery(int page = 1)
        {
            List<DONDATHANG> listNotDelivery = db.DONDATHANGs.Where(row => row.TinhTrang == "Đã duyệt" && row.DaThanhToan == true && row.DaXoa == false).OrderBy(row => row.NgayGiao).Include(row => row.KHACHHANG).ToList();

            //paging
            int NoOfRecorPerPage = 10;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(listNotDelivery.Count) / Convert.ToDouble(NoOfRecorPerPage)));// Đếm trang //Ceiling: làm tròn
            int NoOOfRecorddToSkip = (page - 1) * NoOfRecorPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            listNotDelivery = listNotDelivery.Skip(NoOOfRecorddToSkip).Take(NoOfRecorPerPage).ToList();

            return PartialView(listNotDelivery);
        }

        //Đã giao đã thanh toán đã giao hàng
        public ActionResult DelivereAndPaid()
        {
            List<DONDATHANG> listDelivereAndPaid = db.DONDATHANGs.Where(row => row.TinhTrang == "Đã giao" && row.DaThanhToan == true && row.DaXoa == false).Include(row => row.KHACHHANG).ToList();

            return PartialView(listDelivereAndPaid);
        }

        //Duyệt đơn hàng
        [HttpGet]
        public ActionResult AproveOrders(int MaDDH)
        {
            ViewBag.Infomation = db.DONDATHANGs.Where(row => row.MaDDH == MaDDH).Include(row => row.KHACHHANG).FirstOrDefault();

            List<CHITIETDONDATHANG> listBillDetails = db.CHITIETDONDATHANGs.Where(row => row.MaDDH == MaDDH).ToList();

            ViewBag.SumQuanlity = listBillDetails.Sum(row => row.SoLuong);
            ViewBag.TotalPrice = listBillDetails.Sum(row => row.DonGia);

            return View(listBillDetails);
        }

        [HttpPost]
        public ActionResult AproveOrders(DONDATHANG bill, int MaDDH)
        {
            DONDATHANG billUpdate = db.DONDATHANGs.SingleOrDefault(row => row.MaDDH == bill.MaDDH);

            billUpdate.DaThanhToan = bill.DaThanhToan;
            billUpdate.TinhTrang = bill.TinhTrang;
            billUpdate.NgayGiao = bill.NgayGiao;

            db.SaveChanges();

            //Gửi mail xác nhận
            string email = billUpdate.KHACHHANG.Email.ToString();
            string date = billUpdate.NgayGiao.ToString();
            string message = $@"
    <html>
    <head>
        <style>
            body {{
                font-family: Tahoma, sans-serif;
                color: #333;
            }}
        </style>
    </head>
    <body>
        <p>Xin chào {email}</p>
        <p>Đơn hàng của bạn đã được xác nhận.</p>
        <p>Đơn hàng của bạn sẽ được giao trước ngày {date}</p>
        <p>Trân trọng cảm ơn</p>
        <p>Đội ngũ Mai Nguyen</p>
    </body>
    </html>
";

            SendToMail("Đơn hàng của bạn đã được xác nhận!", email, "tcshoptelephone@gmail.com", "skec vhyv yslu hecy", message);

            return RedirectToAction("BrowseOrders", "Admin");
        }

        [HttpGet]
        public ActionResult InBill(int MaDDH)
        {
            ViewBag.Infomation = db.DONDATHANGs.Where(row => row.MaDDH == MaDDH).Include(row => row.KHACHHANG).FirstOrDefault();

            List<CHITIETDONDATHANG> listBillDetails = db.CHITIETDONDATHANGs.Where(row => row.MaDDH == MaDDH).ToList();

            ViewBag.SumQuanlity = listBillDetails.Sum(row => row.SoLuong);
            ViewBag.TotalPrice = listBillDetails.Sum(row => row.DonGia);

            return View(listBillDetails);
        }
        [HttpPost]
        public ActionResult InBill(DONDATHANG bill, int MaDDH)
        {
            DONDATHANG billUpdate = db.DONDATHANGs.SingleOrDefault(row => row.MaDDH == bill.MaDDH);
            billUpdate.TinhTrang = bill.TinhTrang;
            db.SaveChanges();

            return RedirectToAction("BrowseOrders", "Admin");
        }

        public void SendToMail(string title, string tomail, string frommail, string password, string content)
        {
            //Gọi maill
            MailMessage mail = new MailMessage();
            mail.To.Add(tomail); //Địa chỉ nhận
            mail.From = new MailAddress(frommail); //Địa chỉ gửi
            mail.Subject = title; //Tiêu đề
            mail.Body = content; //Nội dung
            mail.IsBodyHtml = true;
            SmtpClient smtp = new SmtpClient();
            smtp.Host = "smtp.gmail.com"; //Host gửi của mail
            smtp.Port = 587; //Port gửi mail
            smtp.UseDefaultCredentials = false;
            smtp.Credentials = new System.Net.NetworkCredential(frommail, password); //Tài khoản password người gửi
            smtp.EnableSsl = true; //Kích hoạt giao tiếp an toàn SSL
            smtp.Send(mail); //Gửi mail đi           
        }
        #endregion AproveOrders

        #region Statistics
        //Thống kê tổng doanh thu
        public double TotalRevenueStatistics()
        {
            var listRevenue = db.DONDATHANGs.Where(row => row.TinhTrang == "Đã giao" && row.DaThanhToan == true);

            double total = 0;
            foreach (var item in listRevenue)
            {
                total += double.Parse(item.CHITIETDONDATHANG.Sum(row => row.SoLuong * row.DonGia).ToString());
            }
            return total;
        }

        //Thống kê tổng doanh thu theo tháng
        public double TotalRevenueStatisticsByMonthAndYear(int month, int year)
        {
            var listRevenue = db.DONDATHANGs.Where(row => row.TinhTrang == "Đã giao" && row.DaThanhToan == true && row.NgayDatHang.Month == month && row.NgayDatHang.Year == year);

            double total = 0;
            foreach (var item in listRevenue)
            {
                total += double.Parse(item.CHITIETDONDATHANG.Sum(row => row.SoLuong * row.DonGia).ToString());
            }
            return total;
        }

        public double StatisticBill()
        {
            int bill = 0;
            var listBill = db.DONDATHANGs.Where(row => row.TinhTrang == "Đã giao" && row.DaThanhToan == true);
            if (listBill.Count() > 0)
            {
                bill = listBill.Count();
            }
            return bill;
        }

        #endregion Statistics

        #region Roles
        public ActionResult Member(int page = 1)
        {
            THANHVIEN member = Session["member"] as THANHVIEN;
            int currentMemberId = member.MaTV;
            ViewBag.Member = member.MaTV;
            List<THANHVIEN> listMember = db.THANHVIENs.ToList();

            //paging
            int NoOfRecorPerPage = 6;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(listMember.Count) / Convert.ToDouble(NoOfRecorPerPage)));// Đếm trang //Ceiling: làm tròn
            int NoOOfRecorddToSkip = (page - 1) * NoOfRecorPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            listMember = listMember.Skip(NoOOfRecorddToSkip).Take(NoOfRecorPerPage).ToList();

            return View(listMember);
        }

        public ActionResult GrantPermissions(int MaTV)
        {
            ViewBag.Member = db.THANHVIENs.Where(row => row.MaTV == MaTV).SingleOrDefault();

            return View();
        }

        [HttpPost]
        public ActionResult GrantPermissions(THANHVIEN member)
        {
            THANHVIEN MemberUpdate = db.THANHVIENs.SingleOrDefault(row => row.MaTV == member.MaTV);

            MemberUpdate.MaLoaiTV = member.MaLoaiTV;
            db.SaveChanges();
            return RedirectToAction("Member", "Admin");
        }
        public ActionResult Logout()
        {
            Session["member"] = null;
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Home");
        }
        #endregion Roles       
    }
}