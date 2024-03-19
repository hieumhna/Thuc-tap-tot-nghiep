using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Runtime.Serialization;

namespace WebBanDienThoai.Models
{
    [DataContract]  
    public class Product
    {
        [DataMember]
        public int ProductId { get; set; }
        [DataMember]
        public string ProductName { get; set; }
        [DataMember]
        public string MoTa { get; set; }
        [DataMember]
        public string HinhAnh { get; set; }
        [DataMember]
        public string HinhAnh2 { get; set; }
        [DataMember]
        public string HinhAnh3 { get; set; }

        public Product(int id, string name, string description, string img, string img2, string img3)
        {
            this.ProductId = id;
            this.ProductName = name;
            this.MoTa = description;
            this.HinhAnh = img;
            this.HinhAnh2 = img2;
            this.HinhAnh3 = img3;
        }
    }
}