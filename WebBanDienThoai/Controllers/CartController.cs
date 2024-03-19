using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Linq;
using System.Net.Http;
using System.Runtime.InteropServices.ComTypes;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using WebBanDienThoai.Models;

namespace WebBanDienThoai.Controllers
{
    public class CartController : Controller
    {
        // GET: Cart

        Web_BanDienThoai_TCShopEntities db = new Web_BanDienThoai_TCShopEntities();

        public List<CartItem> GetCart()
        {
            if (Session["member"] == null)
            {
                return null;
            }

            THANHVIEN member = Session["member"] as THANHVIEN;

            if (db.GIOHANGs.Any(row => row.MaTV == member.MaTV))
            {
                List<CartItem> listCart = new List<CartItem>();

                int cartId = db.GIOHANGs.Where(row => row.MaTV == member.MaTV).Select(row => row.MaGioHang).SingleOrDefault();

                List<CHITIETGIOHANG> listCartDetail = db.CHITIETGIOHANGs.Where(row => row.MaGioHang == cartId).ToList();

                foreach (CHITIETGIOHANG cartDetail in listCartDetail)
                {
                    CartItem cartItem = new CartItem(cartDetail.MaSP, cartDetail.DonGia, cartDetail.SoLuong, cartDetail.MaMau);

                    listCart.Add(cartItem);
                }

                return listCart;
            }
            else
            {
                return null;
            }
        }

        public ActionResult AddCart(int MaSP, decimal GiaBan, int SoLuong, int MaMau, string Url)
        {
            Session["QuantityExceeded"] = null;

            SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == MaSP).SingleOrDefault();

            if (product == null)
            {
                Response.StatusCode = 404;
                return null;
            }

            THANHVIEN member = Session["member"] as THANHVIEN;

            List<CartItem> listCart = GetCart();

            if (listCart == null)
            {
                GIOHANG cart = new GIOHANG();

                cart.MaTV = member.MaTV;

                db.GIOHANGs.Add(cart);
                db.SaveChanges();

                listCart = new List<CartItem>();
            }

            int cartId = db.GIOHANGs.Where(row => row.MaTV == member.MaTV).Select(row => row.MaGioHang).SingleOrDefault();

            CartItem productCheck = listCart.Where(row => row.MaSP == MaSP && row.MaMau == MaMau).SingleOrDefault();

            if (productCheck != null)
            {
                if (productCheck.SoLuong + SoLuong > 5)
                {
                    Session["QuantityExceeded"] = true;

                    return Redirect(Url);
                }

                if (productCheck.SoLuong + SoLuong <= product.SoLuongTon)
                {
                    productCheck.SoLuong += SoLuong;
                    productCheck.ThanhTien = productCheck.SoLuong * productCheck.DonGia;

                    CHITIETGIOHANG cartDetail = db.CHITIETGIOHANGs.Where(row => row.MaSP == MaSP && row.MaMau == MaMau && row.MaGioHang == cartId).SingleOrDefault();

                    cartDetail.SoLuong = productCheck.SoLuong;

                    db.SaveChanges();

                    return Redirect(Url);
                }
                else
                {
                    return RedirectToAction("ProductOutOfStock", "Cart");
                }
            }
            else
            {
                if (SoLuong <= product.SoLuongTon)
                {
                    CartItem cartItem = new CartItem(MaSP, GiaBan, SoLuong, MaMau);
                    listCart.Add(cartItem);

                    CHITIETGIOHANG cartDetail = new CHITIETGIOHANG();

                    cartDetail.MaGioHang = cartId;
                    cartDetail.MaSP = MaSP;
                    cartDetail.SoLuong = SoLuong;
                    cartDetail.DonGia = GiaBan;
                    cartDetail.MaMau = MaMau;

                    db.CHITIETGIOHANGs.Add(cartDetail);
                    db.SaveChanges();

                    return Redirect(Url);
                }
                else
                {
                    return RedirectToAction("ProductOutOfStock", "Cart");
                }
            }
        }

        public double CalculateTotalQuantity()
        {
            List<CartItem> listCart = GetCart();

            if (listCart == null)
            {
                return 0;
            }

            return listCart.Sum(row => row.SoLuong);
        }

        public decimal CalculateTheTotalAmount()
        {
            List<CartItem> listCart = GetCart();

            if (listCart == null)
            {
                return 0;
            }

            return listCart.Sum(row => row.ThanhTien);
        }

        public List<City> GetCityList()
        {
            string jsonFilePath = Server.MapPath("~/Content/Json/vietnam.json");

            string jsonData = System.IO.File.ReadAllText(jsonFilePath);

            List<City> cities = Newtonsoft.Json.JsonConvert.DeserializeObject<List<City>>(jsonData);

            return cities;
        }

        [HttpGet]
        public ActionResult GetDistrictsByCity(int cityCode)
        {
            List<City> cities = GetCityList();
            var city = cities.FirstOrDefault(row => row.Code == cityCode);
            return Json(city?.Districts, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult GetWardsByDistrict(int districtCode)
        {
            List<City> cities = GetCityList();
            var district = cities.SelectMany(row => row.Districts).FirstOrDefault(row => row.Code == districtCode);
            return Json(district?.Wards, JsonRequestBehavior.AllowGet);
        }

        [ChildActionOnly]
        public ActionResult CustomerInformation()
        {
            THANHVIEN member = Session["member"] as THANHVIEN;

            KHACHHANG custommer = new KHACHHANG();

            custommer.TenKH = member.HoTen;
            custommer.SoDienThoai = member.SoDienThoai;
            custommer.DiaChi = member.DiaChi;

            ViewBag.ListCites = GetCityList();

            return PartialView(custommer);
        }

        public ActionResult ViewCart()
        {
            List<CartItem> listCart = GetCart();

            ViewBag.Count = CalculateTotalQuantity();

            return View(listCart);
        }

        [HttpPost]
        public ActionResult UpdateCart(int MaSP, int MaMau, int SoLuong)
        {
            if (GetCart() == null)
            {
                return RedirectToAction("Index", "Home");
            }

            SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == MaSP).SingleOrDefault();

            if (product == null)
            {
                Response.StatusCode = 404;
                return null;
            }

            if (SoLuong > product.SoLuongTon)
            {
                return RedirectToAction("ProductOutOfStock", "Cart");
            }

            List<CartItem> listCart = GetCart();

            CartItem productUpdate = listCart.Where(row => row.MaSP == MaSP && row.MaMau == MaMau).SingleOrDefault();

            if (productUpdate == null)
            {
                return RedirectToAction("Index", "Home");
            }

            productUpdate.SoLuong = SoLuong;
            productUpdate.ThanhTien = productUpdate.SoLuong * productUpdate.DonGia;

            THANHVIEN member = Session["member"] as THANHVIEN;

            int cartId = db.GIOHANGs.Where(row => row.MaTV == member.MaTV).Select(row => row.MaGioHang).SingleOrDefault();

            CHITIETGIOHANG cartDetail = db.CHITIETGIOHANGs.Where(row => row.MaSP == MaSP && row.MaMau == MaMau && row.MaGioHang == cartId).SingleOrDefault();

            cartDetail.SoLuong = productUpdate.SoLuong;

            db.SaveChanges();

            string newProductTotal = string.Format("{0:N0} \u20ab", productUpdate.ThanhTien);
            string newTotalAmount = string.Format("{0:N0} \u20ab", listCart.Sum(cart => cart.ThanhTien));
            string itemCount = CalculateTotalQuantity().ToString();

            return Json(new { success = true, newProductTotal = newProductTotal, newTotalAmount = newTotalAmount, itemCount = itemCount });
        }

        [HttpPost]
        public ActionResult DeleteCart(int MaSP, int MaMau)
        {
            if (GetCart() == null)
            {
                return RedirectToAction("Index", "Home");
            }

            SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == MaSP).SingleOrDefault();

            if (product == null)
            {
                Response.StatusCode = 404;
                return null;
            }

            List<CartItem> listCart = GetCart();

            CartItem productDelete = listCart.Where(row => row.MaSP == MaSP && row.MaMau == MaMau).SingleOrDefault();

            if (productDelete == null)
            {
                return RedirectToAction("Index", "Home");
            }

            listCart.Remove(productDelete);

            THANHVIEN member = Session["member"] as THANHVIEN;

            int cartId = db.GIOHANGs.Where(row => row.MaTV == member.MaTV).Select(row => row.MaGioHang).SingleOrDefault();

            CHITIETGIOHANG cartDetail = db.CHITIETGIOHANGs.Where(row => row.MaSP == MaSP && row.MaMau == MaMau && row.MaGioHang == cartId).SingleOrDefault();

            db.CHITIETGIOHANGs.Remove(cartDetail);

            db.SaveChanges();

            string newTotalAmount = string.Format("{0:N0} \u20ab", listCart.Sum(cart => cart.ThanhTien));
            string itemCount = CalculateTotalQuantity().ToString();

            return Json(new { success = true, newTotalAmount = newTotalAmount, itemCount = itemCount });
        }

        [ChildActionOnly]
        public ActionResult Cart()
        {
            if (CalculateTotalQuantity() == 0)
            {
                ViewBag.Count = 0;

                return PartialView();
            }

            ViewBag.Count = CalculateTotalQuantity();

            return PartialView();
        }

        public ActionResult ProductOutOfStock()
        {
            return View();
        }

        [HttpPost]
        public ActionResult SelectPayment(KHACHHANG customer, string specificAddress, string selectedCityName, string selectedDistrictName, string selectedWardName, string addressStyle)
        {
            if (GetCart() == null)
            {
                return RedirectToAction("Index", "Home");
            }

            customer.DiaChi = string.Format("Địa chỉ cụ thể: {0}, Phường/Xã: {1}, Quận/Huyện: {2}, Tỉnh/Thành phố: {3}, Loại địa chỉ: {4}", specificAddress, selectedWardName, selectedDistrictName, selectedCityName, addressStyle);

            Session["Customer"] = customer;

            return View();
        }

        public ActionResult Order()
        {
            if (GetCart() == null)
            {
                return RedirectToAction("Index", "Home");
            }

            THANHVIEN member = Session["member"] as THANHVIEN;

            KHACHHANG customer = Session["Customer"] as KHACHHANG;

            KHACHHANG newCustomer = new KHACHHANG();

            newCustomer.MaTV = member.MaTV;
            newCustomer.TenKH = customer.TenKH;
            newCustomer.DiaChi = customer.DiaChi;
            newCustomer.Email = member.Email;
            newCustomer.SoDienThoai = customer.SoDienThoai;

            db.KHACHHANGs.Add(newCustomer);
            db.SaveChanges();

            DONDATHANG theOrder = new DONDATHANG();

            theOrder.MaKH = newCustomer.MaKH;
            theOrder.NgayDatHang = DateTime.Now;
            theOrder.TinhTrang = "Chưa duyệt";
            theOrder.DaThanhToan = false;
            theOrder.DaXoa = false;

            db.DONDATHANGs.Add(theOrder);
            db.SaveChanges();

            List<CartItem> listCart = GetCart();

            foreach (var item in listCart)
            {
                CHITIETDONDATHANG orderDetails = new CHITIETDONDATHANG();

                orderDetails.MaDDH = theOrder.MaDDH;
                orderDetails.MaSP = item.MaSP;
                orderDetails.TenSP = item.TenSP;
                orderDetails.SoLuong = item.SoLuong;
                orderDetails.DonGia = item.DonGia;

                SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == item.MaSP).SingleOrDefault();

                product.SoLuongTon -= item.SoLuong;

                db.SaveChanges();

                db.CHITIETDONDATHANGs.Add(orderDetails);
            }
            db.SaveChanges();

            int cartId = db.GIOHANGs.Where(row => row.MaTV == member.MaTV).Select(row => row.MaGioHang).SingleOrDefault();

            List<CHITIETGIOHANG> listCartDetail = db.CHITIETGIOHANGs.Where(row => row.MaGioHang == cartId).ToList();

            foreach (var item in listCartDetail)
            {
                db.CHITIETGIOHANGs.Remove(item);
            }

            db.SaveChanges();

            GIOHANG cart = db.GIOHANGs.Where(row => row.MaGioHang == cartId).SingleOrDefault();

            db.GIOHANGs.Remove(cart);
            db.SaveChanges();

            Session["Customer"] = null;

            return RedirectToAction("ViewCart", "Cart");
        }

        [ChildActionOnly]
        public ActionResult TotalMoney()
        {
            if (GetCart() == null)
            {
                return RedirectToAction("Index", "Home");
            }

            List<CartItem> listCart = GetCart();

            ViewBag.TotalMoney = listCart.Sum(cart => cart.ThanhTien);

            return PartialView();
        }

        public ActionResult OrderStatus()
        {
            if (Session["member"] == null)
            {
                return RedirectToAction("Login", "Login");
            }

            THANHVIEN member = Session["member"] as THANHVIEN;

            // Lấy danh sách đơn đặt hàng theo tài khoản
            List<DONDATHANG> orthers = db.KHACHHANGs.Where(n => n.MaTV == member.MaTV).SelectMany(m => db.DONDATHANGs.Where(order => order.MaKH == m.MaKH && order.DaXoa == false && order.TinhTrang != "Đã giao")).ToList();

            return View(orthers);
        }

        public ActionResult OrderStatusItem(DONDATHANG order)
        {
            if (order == null)
            {
                return RedirectToAction("Index", "Home");
            }

            List<CHITIETDONDATHANG> detailOrders = db.CHITIETDONDATHANGs.Where(row => row.MaDDH == order.MaDDH).ToList();

            List<CartItem> cartItems = new List<CartItem>();

            foreach (var detailOrder in detailOrders)
            {
                CartItem cartItem = new CartItem(detailOrder.TenSP, detailOrder.MaSP, detailOrder.DonGia, detailOrder.SoLuong);

                cartItems.Add(cartItem);
            }

            ViewBag.Count = cartItems.Sum(row => row.SoLuong);
            ViewBag.OrderStatus = order.TinhTrang;
            ViewBag.OrderId = order.MaDDH;

            return PartialView(cartItems);
        }

        public ActionResult CancelOrder(int orderId)
        {
            DONDATHANG order = db.DONDATHANGs.Where(row => row.MaDDH == orderId).SingleOrDefault();

            if (order == null)
            {
                return HttpNotFound();
            }

            order.DaXoa = true;

            db.SaveChanges();

            List<CHITIETDONDATHANG> orderDetails = db.CHITIETDONDATHANGs.Where(row => row.MaDDH == order.MaDDH).ToList();

            foreach (var item in orderDetails)
            {
                SANPHAM product = db.SANPHAMs.Where(row => row.MaSP == item.MaSP).SingleOrDefault();

                product.SoLuongTon += item.SoLuong;

                db.SaveChanges();
            }

            return RedirectToAction("OrderStatus", "Cart");
        }

        public ActionResult PurchaseHistory()
        {
            if (Session["member"] == null)
            {   
                return RedirectToAction("Login", "Login");
            }

            THANHVIEN member = Session["member"] as THANHVIEN;

            List<List<CartItem>> listOrther = new List<List<CartItem>>();

            // Lấy danh sách đơn đặt hàng theo tài khoản
            List<DONDATHANG> orthers = db.KHACHHANGs.Where(n => n.MaTV == member.MaTV).SelectMany(m => db.DONDATHANGs.Where(order => order.MaKH == m.MaKH && order.DaXoa == false && order.TinhTrang == "Đã giao")).ToList();

            return View(orthers);
        }

        public ActionResult PurchaseHistoryItem(DONDATHANG order)
        {
            if (order == null)
            {
                return RedirectToAction("Index", "Home");
            }

            List<CHITIETDONDATHANG> detailOrders = db.CHITIETDONDATHANGs.Where(row => row.MaDDH == order.MaDDH).ToList();

            List<CartItem> cartItems = new List<CartItem>();

            foreach (var detailOrder in detailOrders)
            {
                CartItem cartItem = new CartItem(detailOrder.TenSP, detailOrder.MaSP, detailOrder.DonGia, detailOrder.SoLuong);

                cartItems.Add(cartItem);
            }

            ViewBag.Count = cartItems.Sum(row => row.SoLuong);
            ViewBag.OrderStatus = order.TinhTrang;
            ViewBag.OrderId = order.MaDDH;

            return PartialView(cartItems);
        }
    }
}