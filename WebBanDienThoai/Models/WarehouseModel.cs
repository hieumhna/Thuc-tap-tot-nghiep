using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebBanDienThoai.Models
{
    public class WarehouseModel
    {
        public int MaPN { get; set; }
        public string TenNCC { get; set; }
        public string TenSP { get; set; }
        public DateTime NgayNhap { get; set; }
        public decimal DonGiaNhap { get; set; }
        public int SoLuong { get; set; }
    }
}