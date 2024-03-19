using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.Mvc;
using System.Web.WebPages.Html;
using WebBanDienThoai.Models;
using CaptchaMvc.HtmlHelpers;
using CaptchaMvc;
using WebBanDienThoai.ApiControllers;

namespace WebBanDienThoai.Controllers
{
    public class RegisterController : Controller
    {
        // GET: Register

        Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities();

        // Sửa thuộc tính MaLoaiTV trong THANHVIEN thành int? (đổi thuộc tính trong thành NULL)

        [HttpGet]
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Register(THANHVIEN member)
        {
            if (this.IsCaptchaValid("Mã captcha không đúng."))
            {
                if (ModelState.IsValid)
                {
                    db.THANHVIENs.Add(member);
                    db.SaveChanges();

                    return RedirectToAction("Login", "Login");
                }
            }

            return View();
        }

        public JsonResult CheckAccount(string username)
        {
            bool isAccountExists = db.THANHVIENs.Any(row => row.TaiKhoan == username);
            return Json(isAccountExists, JsonRequestBehavior.AllowGet);
        }

        public JsonResult CheckEmail(string email)
        {
            bool isEmailExists = db.THANHVIENs.Any(row => row.Email == email);
            return Json(isEmailExists, JsonRequestBehavior.AllowGet);
        }
    }
}