using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Common.CommandTrees;
using System.Linq;
using System.Web;

namespace WebBanDienThoai.Models
{
    public class CartItem
    {
        public int MaSP { get; set; }
        public string TenSP { get; set; }
        public int MaMau { get; set; }
        public string TenMau { get; set; }
        public int SoLuong { get; set; }
        public decimal DonGia { get; set; }
        public decimal ThanhTien { get; set; }
        public string HinhAnh { get; set; }

        public CartItem(int MaSP, decimal DonGia, int SoLuong, int MaMau)
        {
            using (Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities())
            {
                this.MaSP = MaSP;
                this.MaMau = MaMau;

                SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == MaSP).SingleOrDefault();

                MAU color = db.MAUs.Where(row => row.MaMau == MaMau).SingleOrDefault();

                this.TenMau = color.TenMau;
                this.TenSP = product.TenSP + " - " + this.TenMau;

                this.SoLuong = SoLuong;
                this.DonGia = DonGia;
                this.ThanhTien = this.SoLuong * this.DonGia;
                this.HinhAnh = product.HinhAnh;
            }
        }

        public CartItem(int MaSP, decimal DonGia, int SoLuong)
        {
            using (Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities())
            {
                this.MaSP = MaSP;

                SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == MaSP).SingleOrDefault();

                this.TenSP = product.TenSP;

                this.SoLuong = SoLuong;
                this.DonGia = DonGia;
                this.ThanhTien = this.SoLuong * this.DonGia;
                this.HinhAnh = product.HinhAnh;
            }
        }

        public CartItem(string TenSP, int MaSP, decimal DonGia, int SoLuong)
        {
            using (Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities())
            {
                this.MaSP = MaSP;

                SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == MaSP).SingleOrDefault();

                this.TenSP = TenSP;

                this.SoLuong = SoLuong;
                this.DonGia = DonGia;
                this.ThanhTien = this.SoLuong * this.DonGia;
                this.HinhAnh = product.HinhAnh;
            }
        }
    }
}