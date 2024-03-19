using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebBanDienThoai.Models;
using System.Web.Mvc;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using System.Web.UI.WebControls;
using CaptchaMvc.HtmlHelpers;
using System.Configuration;
using System.Net.Mail;
using System.Net;
using System.Web.Security;

namespace WebBanDienThoai.Controllers
{
    public class LoginController : Controller
    {
        // GET: Login

        Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities();

        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(THANHVIEN account, bool RememberMe = false)
        {
            THANHVIEN member = db.THANHVIENs.Where(row => row.TaiKhoan == account.TaiKhoan && row.MatKhau == account.MatKhau).SingleOrDefault();

            if (member != null)
            {
                Session["member"] = member;

                if (RememberMe)
                {
                    HttpCookie cookie = new HttpCookie("RememberMeCookie");
                    cookie.Values["TaiKhoan"] = member.TaiKhoan;
                    cookie.Expires = DateTime.Now.AddDays(7);
                    Response.Cookies.Add(cookie);
                }
                else
                {
                    if (Request.Cookies["RememberMeCookie"] != null)
                    {
                        Response.Cookies.Remove("RememberMeCookie");
                        Response.Cookies["RememberMeCookie"].Expires = DateTime.Now.AddYears(-1);
                    }
                }

                IEnumerable<LOAITHANHVIEN_QUYEN> lstPermission = db.LOAITHANHVIEN_QUYENs.Where(row => row.MaLoaiTV == member.MaLoaiTV);
                string Permission = "";
                foreach (var item in lstPermission)
                {
                    Permission += item.QUYEN.MaQuyen + ",";
                }
                Permission = Permission.Substring(0, Permission.Length - 1);
                GrantPermissions(member.TaiKhoan, Permission);

                if (Permission.Contains("Admin"))
                {
                    string script = "<script>window.location.href = '" + Url.Action("Index", "Admin") + "';</script>";
                    return Content(script);
                }
                else
                {
                    string script = "<script>window.location.href = '" + Url.Action("Index", "Home") + "';</script>";
                    return Content(script);
                }
            }

            return Content("Tài khoản hoặc mật khẩu không đúng.");
        }

        //Phân quyền
        public void GrantPermissions(string username, string permission)
        {
            FormsAuthentication.Initialize();

            var ticket = new FormsAuthenticationTicket(1, username, DateTime.Now, DateTime.Now.AddHours(3), false, permission, FormsAuthentication.FormsCookiePath);

            var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, FormsAuthentication.Encrypt(ticket));
            if (ticket.IsPersistent) cookie.Expires = ticket.Expiration;

            Response.Cookies.Add(cookie);
        }

        public ActionResult Logout()
        {
            Session["member"] = null;
            FormsAuthentication.SignOut();
            if (Request.Cookies["RememberMeCookie"] != null)
            {
                Response.Cookies.Remove("RememberMeCookie");
                Response.Cookies["RememberMeCookie"].Expires = DateTime.Now.AddYears(-1);
            }

            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public ActionResult ForgotPassword()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ForgotPassword(string email)
        {
            if (this.IsCaptchaValid("Mã bảo vệ không hợp lệ."))
            {
                THANHVIEN member = db.THANHVIENs.Where(row => row.Email == email).SingleOrDefault();

                if (member == null)
                {
                    ViewBag.NotFoundAccount = "Không tìm thấy tài khoản!";
                    return View();
                }

                Random random = new Random();

                string resetToken = random.Next(10000, 99999).ToString();

                member.MaToken = resetToken;
                member.ThoiGianMaToken = DateTime.Now.AddMinutes(5);

                db.SaveChanges();

                SendResetPasswordEmail(email, resetToken);

                return RedirectToAction("ResetPassword", "Login", new { @email = email });
            }

            return View();
        }

        public void SendResetPasswordEmail(string email, string resetToken)
        {
            string smtpServer = ConfigurationManager.AppSettings["SmtpServer"];
            int smtpPort = int.Parse(ConfigurationManager.AppSettings["SmtpPort"]);
            string smtpUsername = ConfigurationManager.AppSettings["SmtpUsername"];
            string smtpPassword = ConfigurationManager.AppSettings["SmtpPassword"];

            string subject = "Đặt lại mật khẩu của bạn";
            string body = $@"
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
        <p>Hi {email}</p>
        <p>Chúng tôi đã nhận được yêu cầu của bạn về mã xác nhận để thay đổi mật khẩu của bạn.</p>
        <p>Mã của bạn là: {resetToken}</p>
        <p>Mã sẽ hết hạn sau 5 phút</p>
        <p>Nếu bạn không yêu cầu mã này, bạn có thể yên tâm bỏ qua email này. Người khác có thể đã gõ nhầm địa chỉ email của bạn.</p>
        <p>Trân trọng</p>
        <p>Đội ngũ Mai Nguyen</p>
    </body>
    </html>
";

            using (MailMessage mailMessage = new MailMessage(smtpUsername, email, subject, body))
            {
                mailMessage.IsBodyHtml = true;

                using (SmtpClient smtpClient = new SmtpClient(smtpServer))
                {
                    smtpClient.Credentials = new NetworkCredential(smtpUsername, smtpPassword);
                    smtpClient.EnableSsl = true;
                    smtpClient.Port = smtpPort;

                    smtpClient.Send(mailMessage);
                }
            }
        }

        [HttpGet]
        public ActionResult ResetPassword(string email)
        {
            ViewBag.Email = email;

            return View();
        }

        [HttpPost]
        public ActionResult ResetPassword(string token, string email)
        {

            THANHVIEN member = db.THANHVIENs.Where(row => row.MaToken == token && row.ThoiGianMaToken >= DateTime.Now && row.Email == email).SingleOrDefault();

            if (member == null)
            {
                ViewBag.Wrong = "Mã đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.";
                ViewBag.Email = email;
                return View();
            }

            return RedirectToAction("UpdatePassword", "Login", new { email = email });
        }

        [HttpGet]
        public ActionResult UpdatePassword(string email)
        {   
            THANHVIEN member = db.THANHVIENs.Where(row => row.Email == email).SingleOrDefault();    

            if (member == null)
            {
                return HttpNotFound();
            }

            return View(member);
        }

        [HttpPost]
        public ActionResult UpdatePassword(THANHVIEN member, string newPassword, string confirmPassword)
        {
            if (member == null)
            {
                return HttpNotFound();
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
            memberUpdate.MaToken = null;
            memberUpdate.ThoiGianMaToken = null;

            db.SaveChanges();

            return Json(new { message = "Cập nhật khẩu thành công." });
        }

        public ActionResult ResendTheCode(string email)
        {
            THANHVIEN member = db.THANHVIENs.Where(row => row.Email == email).SingleOrDefault();

            if (member == null)
            {
                return HttpNotFound();
            }

            Random random = new Random();

            string resetToken = random.Next(10000, 99999).ToString();

            member.MaToken = resetToken;
            member.ThoiGianMaToken = DateTime.Now.AddMinutes(5);

            db.SaveChanges();

            SendResetPasswordEmail(email, resetToken);

            return RedirectToAction("ResetPassword", "Login", new { @email = email });
        }
    }
}