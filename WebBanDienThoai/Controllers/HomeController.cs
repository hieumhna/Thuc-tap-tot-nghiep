using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebBanDienThoai.Models;

namespace WebBanDienThoai.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home

        Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities();

        public ActionResult Index()
        {
            List<SANPHAM> newIphoneProducts = db.SANPHAMs.Where(product => product.LOAISANPHAM.TenLoaiSP == "Iphone" && product.Moi == true && product.DaXoa == false && product.DonGia != null && (product.CHITIETSANPHAM.Count > 0 || product.CHITIETPHUKIENTAINGHE.Count > 0 || product.CHITIETPHUKIENSACDUPHONG.Count > 0)).Take(3).ToList();
            ViewBag.IphoneProducts = newIphoneProducts;

            List<SANPHAM> newSamsungProducts = db.SANPHAMs.Where(product => product.LOAISANPHAM.TenLoaiSP == "Samsung" && product.Moi == true && product.DaXoa == false && product.DonGia != null && (product.CHITIETSANPHAM.Count > 0 || product.CHITIETPHUKIENTAINGHE.Count > 0 || product.CHITIETPHUKIENSACDUPHONG.Count > 0)).Take(3).ToList();
            ViewBag.SamsungProducts = newSamsungProducts;

            List<SANPHAM> newHeadphoneProducts = db.SANPHAMs.Where(product => product.LOAISANPHAM.TenLoaiSP == "Tai nghe" && product.Moi == true && product.DaXoa == false && product.DonGia != null && (product.CHITIETSANPHAM.Count > 0 || product.CHITIETPHUKIENTAINGHE.Count > 0 || product.CHITIETPHUKIENSACDUPHONG.Count > 0)).Take(3).ToList();
            ViewBag.HeadphoneProducts = newHeadphoneProducts;

            return View();
        }

        public ActionResult NoAccessPermissions()
        {
            return View();
        }

        [ChildActionOnly]
        public ActionResult Banner()
        {

            ViewBag.iPhone = db.LOAISANPHAMs.Where(row => row.TenLoaiSP == "Iphone").Select(row => row.MaLoaiSP).SingleOrDefault();
            ViewBag.Samsung = db.LOAISANPHAMs.Where(row => row.TenLoaiSP == "Samsung").Select(row => row.MaLoaiSP).SingleOrDefault();
            ViewBag.Oppo = db.LOAISANPHAMs.Where(row => row.TenLoaiSP == "Oppo").Select(row => row.MaLoaiSP).SingleOrDefault();
            ViewBag.Headphone = db.LOAISANPHAMs.Where(row => row.TenLoaiSP == "Tai nghe").Select(row => row.MaLoaiSP).SingleOrDefault();

            return PartialView();
        }

        [ChildActionOnly]
        public ActionResult ProductCategories()
        {
            List<LOAISANPHAM> productCategories = db.LOAISANPHAMs.ToList();

            return PartialView(productCategories);
        }

        [ChildActionOnly]
        public ActionResult NavLinks()
        {
            List<LOAISANPHAM> productCategories = db.LOAISANPHAMs.ToList();

            return PartialView(productCategories);
        }

        [ChildActionOnly]
        public ActionResult FooterCategories()
        {
            List<LOAISANPHAM> productCategories = db.LOAISANPHAMs.ToList();

            return PartialView(productCategories);
        }

        [ChildActionOnly]
        public ActionResult SideBarHome()
        {
            List<SANPHAM> products = new List<SANPHAM>();

            products.Add(db.SANPHAMs.Where(row => row.LOAISANPHAM.TenLoaiSP == "Iphone" && row.DaXoa == false && row.DonGia != null && (row.CHITIETSANPHAM.Count > 0 || row.CHITIETPHUKIENTAINGHE.Count > 0 || row.CHITIETPHUKIENSACDUPHONG.Count > 0)).FirstOrDefault());
            products.Add(db.SANPHAMs.Where(row => row.LOAISANPHAM.TenLoaiSP == "Samsung" && row.DaXoa == false && row.DonGia != null && (row.CHITIETSANPHAM.Count > 0 || row.CHITIETPHUKIENTAINGHE.Count > 0 || row.CHITIETPHUKIENSACDUPHONG.Count > 0)).FirstOrDefault());
            products.Add(db.SANPHAMs.Where(row => row.LOAISANPHAM.TenLoaiSP == "Sạc dự phòng" && row.DaXoa == false && row.DonGia != null && (row.CHITIETSANPHAM.Count > 0 || row.CHITIETPHUKIENTAINGHE.Count > 0 || row.CHITIETPHUKIENSACDUPHONG.Count > 0)).FirstOrDefault());

            return PartialView(products);
        }

        [ChildActionOnly]
        public ActionResult HeaderBot()
        {
            if (Request.Cookies["RememberMeCookie"] != null && !string.IsNullOrEmpty(Request.Cookies["RememberMeCookie"]["TaiKhoan"]))
            {
                string username = Request.Cookies["RememberMeCookie"]["TaiKhoan"].ToString();
                THANHVIEN member = db.THANHVIENs.Where(row => row.TaiKhoan == username).SingleOrDefault();

                if (member != null)
                {
                    Session["member"] = member;
                }
            }

            return PartialView();
        }        
    }
}