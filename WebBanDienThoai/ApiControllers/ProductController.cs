using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Razor.Tokenizer.Symbols;
using WebBanDienThoai.Models;
using System.Data.Entity;

namespace WebBanDienThoai.ApiControllers
{
    public class ProductController : ApiController
    {
        Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities();

        public List<Product> GetProducts()
        {
            List<SANPHAM> listProducts = db.SANPHAMs.ToList();

            if (listProducts == null)
            {
                return null;
            }    

            List<Product> productsApi = new List<Product>();

            foreach(var product in listProducts)
            {
                productsApi.Add(new Product(product.MaSP, product.TenSP, product.MoTa, product.HinhAnh, product.HinhAnh2, product.HinhAnh3));
            }

            return productsApi;
        }
    }
}
