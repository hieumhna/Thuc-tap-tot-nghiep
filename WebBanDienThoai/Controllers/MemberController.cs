using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebBanDienThoai.Models;

namespace WebBanDienThoai.Controllers
{
    public class MemberController : Controller
    {
        // GET: Member

        Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities();

        public ActionResult ViewInformation()
        {
            if (Session["member"] == null)
            {
                return RedirectToAction("Login", "Login");
            }

            THANHVIEN member = Session["member"] as THANHVIEN;

            return View(member);
        }

        [HttpPost]
        public ActionResult UpdateInformation(THANHVIEN member, HttpPostedFileBase avartar)
        {
            if (member == null)
            {
                return RedirectToAction("Index", "Home");
            }

            THANHVIEN memberUpdate = db.THANHVIENs.Where(row => row.MaTV == member.MaTV).SingleOrDefault();

            if (memberUpdate == null)
            {
                return HttpNotFound();
            }

            memberUpdate.HoTen = member.HoTen;
            memberUpdate.Email = member.Email;
            memberUpdate.SoDienThoai = member.SoDienThoai;
            memberUpdate.DiaChi = member.DiaChi;

            try
            {
                if (avartar.ContentLength > 0)
                {
                    var fileName = Path.GetFileName(avartar.FileName);

                    var path = Path.Combine(Server.MapPath("~/Content/Images/Members"), fileName);

                    avartar.SaveAs(path);

                    memberUpdate.HinhDaiDien = fileName;
                }
            }
            catch { }

            Session["member"] = memberUpdate;

            db.SaveChanges();

            TempData["UpdateSuccess"] = true;

            return RedirectToAction("ViewInformation", "Member");
        }

        [HttpGet]
        public ActionResult ChangePassword()
        {
            THANHVIEN member = Session["member"] as THANHVIEN;

            if (member == null)
            {
                return RedirectToAction("Login", "Login");
            }

            return View(member);
        }

        [HttpPost]
        public ActionResult ChangePassword(THANHVIEN member, string oldPassword, string newPassword, string confirmPassword)
        {
            if (member == null)
            {
                return HttpNotFound();
            }

            if (member.MatKhau != oldPassword)
            {
                return Json(new { message = "Mật khẩu hiện tại không đúng." });

            }

            if (oldPassword == newPassword)
            {
                return Json(new { message = "Mật khẩu mới không được trùng với mật khẩu cũ." });
            }

            if (newPassword != confirmPassword)
            {
                return Json(new { message = "Xác nhận mật khẩu không trùng khớp" });
            }

            THANHVIEN memberUpdate = db.THANHVIENs.Where(row => row.MaTV == member.MaTV).SingleOrDefault();

            if (memberUpdate == null)
            {
                return HttpNotFound();
            }

            memberUpdate.MatKhau = newPassword;

            db.SaveChanges();

            return Json(new { message = "Đổi mật khẩu thành công." });
        }

        public ActionResult SidebarMember()
        {
            return PartialView();
        }
    }
}