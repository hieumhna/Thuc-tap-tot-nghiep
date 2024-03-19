using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WebBanDienThoai.Models // phải trùng namespace
{
    [MetadataTypeAttribute(typeof(THANHVIENMetadata))]
    public partial class THANHVIEN
    {
        internal sealed class THANHVIENMetadata
        {
            [DisplayName("Mã thành viên")]
            public int MaTV { get; set; }

            [DisplayName("Mã loại thành viên")]
            public int? MaLoaiTV { get; set; }

            [DisplayName("Tài khoản")]
            [Required(ErrorMessage = "Tài khoản không được để trống.")]
            public string TaiKhoan { get; set; }

            [DisplayName("Mật khẩu")]
            [Required(ErrorMessage = "Mật khẩu không được để trống.")]
            [MinLength(6, ErrorMessage = "Mật khẩu phải có ít nhất 6 ký tự.")]
            public string MatKhau { get; set; }

            [DisplayName("Họ và tên")]
            [Required(ErrorMessage = "Họ và tên không được để trống.")]
            public string HoTen { get; set; }

            [DisplayName("Địa chỉ")]
            public string DiaChi { get; set; }

            [DisplayName("Email")]
            [Required(ErrorMessage = "Email không được để trống.")]
            [EmailAddress(ErrorMessage = "Email không hợp lệ.")]
            public string Email { get; set; }

            [DisplayName("Số điện thoại")]
            [Required(ErrorMessage = "Số điện thoại không được để trống.")]
            [RegularExpression(@"^\d{10,}$", ErrorMessage = "Số điện thoại phải chứa ít nhất 10 chữ số.")]
            public string SoDienThoai { get; set; }

            [DisplayName("Câu hỏi")]
            public string CauHoi { get; set; }

            [DisplayName("Câu trả lời")]
            public string CauTraLoi { get; set; }

        }
    }
}