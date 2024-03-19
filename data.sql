
CREATE DATABASE Web_BanDienThoai_TCShop
GO

USE Web_BanDienThoai_TCShop
GO

CREATE TABLE NHASANXUAT
(
    MaNSX INT IDENTITY NOT NULL,
    TenNSX NVARCHAR(100) NOT NULL, 
    ThongTin NVARCHAR(MAX) NULL,
    Logo NVARCHAR(MAX) NULL,
   
    CONSTRAINT PK_NSX PRIMARY KEY(MaNSX)
)
GO

CREATE TABLE NHACUNGCAP
(
   MaNCC INT IDENTITY NOT NULL,
   TenNCC NVARCHAR(100) NOT NULL,
   DiaChi NVARCHAR(255) NOT NULL,
   Email NVARCHAR(100) NOT NULL,
   SoDienThoai VARCHAR(12) NOT NULL,
   Fax NVARCHAR(50) NULL,

   CONSTRAINT PK_NCC PRIMARY KEY (MaNCC)
)
GO

CREATE TABLE PHIEUNHAP
(
    MaPN INT IDENTITY NOT NULL,
    MaNCC INT NOT NULL,
    NgayNhap DATETIME NOT NULL,
    DaXoa BIT NOT NULL,
        
    CONSTRAINT PK_PN PRIMARY KEY (MaPN),
    CONSTRAINT FK_PN_NCC FOREIGN KEY (MaNCC) REFERENCES NHACUNGCAP(MaNCC) ON DELETE CASCADE
)
GO

CREATE TABLE LOAITHANHVIEN
(
    MaLoaiTV INT IDENTITY NOT NULL,
    TenLoai NVARCHAR(50) NOT NULL,
    UuDai INT NULL,

    CONSTRAINT PK_LTV PRIMARY KEY (MaLoaiTV)
)
GO

CREATE TABLE THANHVIEN
(
    MaTV INT IDENTITY NOT NULL,
    MaLoaiTV INT NULL,
    TaiKhoan NVARCHAR(100) NOT NULL,
    MatKhau NVARCHAR(100) NOT NULL,
    HoTen NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255) NULL,
    Email NVARCHAR(255) NULL,
    SoDienThoai VARCHAR(12) NULL,
    CauHoi NVARCHAR(MAX) NULL,
    CauTraLoi NVARCHAR(MAX) NULL,
    HinhDaiDien NVARCHAR(MAX) DEFAULT ('default.png') NULL,
    MaToken NVARCHAR(50) NULL,
    ThoiGianMaToken DATETIME NULL,

    CONSTRAINT PK_TV PRIMARY KEY (MaTV),
    CONSTRAINT FK_TV_LTV FOREIGN KEY(MaLoaiTV) REFERENCES LOAITHANHVIEN(MaLoaiTV) ON DELETE CASCADE
)
GO

CREATE TABLE KHACHHANG
(
    MaKH INT IDENTITY NOT NULL,
    MaTV INT NULL,
    TenKH NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255) NULL,
    Email NVARCHAR(255) NULL,
    SoDienThoai VARCHAR(12) NULL,

    CONSTRAINT PK_KH PRIMARY KEY(MaKH),
    CONSTRAINT FK_KH_TV FOREIGN KEY(MaTV) REFERENCES THANHVIEN(MaTV) ON DELETE CASCADE
)
GO

CREATE TABLE DANHMUC
(
    MaDanhMuc INT IDENTITY NOT NULL,
    TenDanhMuc NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_DM PRIMARY KEY(MaDanhMuc)
)
GO

CREATE TABLE LOAISANPHAM
(
    MaLoaiSP INT IDENTITY NOT NULL,
    MaDanhMuc INT NOT NULL,
    TenLoaiSP NVARCHAR(100) NOT NULL,
    Icon NVARCHAR(MAX) NULL,
    BiDanh NVARCHAR(50) NULL,

    CONSTRAINT PK_LSP PRIMARY KEY(MaLoaiSP),
    CONSTRAINT FK_LSP_DM FOREIGN KEY(MaDanhMuc) REFERENCES DANHMUC(MaDanhMuc)
)
GO

CREATE TABLE KHUYENMAI
(
    MaKhuyenMai INT IDENTITY NOT NULL,
    TenKhuyenMai NVARCHAR(255) NOT NULL,
    MoTa NVARCHAR(MAX) NULL,
    PhanTramGiamGia INT NOT NULL,
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,

    CONSTRAINT PK_KhuyenMai PRIMARY KEY(MaKhuyenMai)
)
GO

CREATE TABLE SANPHAM
(
    MaSP INT IDENTITY NOT NULL,
    MaNCC INT NOT NULL,
    MaNSX INT NOT NULL,
    MaLoaiSP INT NOT NULL,
	MaKhuyenMai  INT NULL,

    TenSP NVARCHAR(255) NOT NULL,
    DonGia DECIMAL(18,0) NULL,
    NgayCapNhat DATETIME NULL,
    MoTa NVARCHAR(MAX) NULL,
    HinhAnh NVARCHAR(MAX) NULL,
    HinhAnh2 NVARCHAR(MAX) NULL,
    HinhAnh3 NVARCHAR(MAX) NULL,
    SoLuongTon INT NOT NULL,
    LuotXem INT NULL,
    LuotBinhChon INT NULL,
    LuotBinhLuan INT NULL,
    SoLanMua INT NULL,
    Moi BIT NOT NULL,
    DaXoa BIT NOT NULL,

    CONSTRAINT PK_SP PRIMARY KEY(MaSP), 
    CONSTRAINT FK_SP_LSP FOREIGN KEY(MaLoaiSP) REFERENCES LOAISANPHAM(MaLoaiSP),
    CONSTRAINT FK_SP_NSX FOREIGN KEY(MaNSX) REFERENCES NHASANXUAT(MaNSX),
    CONSTRAINT FK_SP_NCC FOREIGN KEY(MaNCC) REFERENCES NHACUNGCAP(MaNCC),
	CONSTRAINT FK_SP_KM FOREIGN KEY(MaKhuyenMai) REFERENCES KHUYENMAI(MaKhuyenMai)
)
GO

CREATE TABLE CHITIETPHIEUNHAP
(
    MaCTPN INT IDENTITY NOT NULL,
    MaPN INT NOT NULL,
    MaSP INT NOT NULL,
    DonGiaNhap DECIMAL(18,0) NOT NULL,
    SoLuongNhap INT NOT NULL,

    CONSTRAINT PK_CTPN PRIMARY KEY (MaCTPN),
    CONSTRAINT FK_CTPN_PN FOREIGN KEY(MaPN) REFERENCES PHIEUNHAP(MaPN),
    CONSTRAINT FK_CTPN_SP FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO

CREATE TABLE DONDATHANG
(
    MaDDH INT IDENTITY NOT NULL,
    MaKH INT NULL,
    NgayDatHang DATETIME NOT NULL,
    NgayGiao DATETIME NULL,
    DaThanhToan BIT NOT NULL,
    QuaTang NVARCHAR(255) NULL,
    TinhTrang NVARCHAR(50) NULL,
    DaXoa BIT DEFAULT(0) NULL,

    CONSTRAINT PK_DDH PRIMARY KEY(MaDDH),
    CONSTRAINT FK_DDH_KH FOREIGN KEY(MaKH) REFERENCES KHACHHANG(MaKH) ON DELETE CASCADE
)
GO

CREATE TABLE CHITIETDONDATHANG
(
    MaChiTietDDH INT IDENTITY NOT NULL,
    MaDDH INT NOT NULL,
    MaSP INT NOT NULL,
    TenSP NVARCHAR(255) NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,0) NOT NULL,

    CONSTRAINT PK_CTDDH PRIMARY KEY(MaChiTietDDH),
    CONSTRAINT FK_CTDDH_DDH FOREIGN KEY(MaDDH) REFERENCES DONDATHANG(MaDDH),
    CONSTRAINT FK_CTDDH_SP FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO

CREATE TABLE BINHLUAN
(
    MaBinhLuan INT IDENTITY NOT NULL,
    MaTV INT NOT NULL,
    MaSP INT NOT NULL,
    NoiDungBL NVARCHAR(MAX) NULL,

    CONSTRAINT PK_BL PRIMARY KEY(MaBinhLuan),
    CONSTRAINT FK_BL_TV FOREIGN KEY(MaTV) REFERENCES THANHVIEN(MaTV),
    CONSTRAINT FK_BL_SP FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO

CREATE TABLE CHITIETPHUKIENSACDUPHONG
(
    MaCTPKSac INT IDENTITY NOT NULL,
    MaSP INT NOT NULL,

    HIEUSUAT NVARCHAR(50) NULL,
    DUNGLUONGPIN NVARCHAR(50) NULL,
    THOIGIANSAC NVARCHAR(50) NULL,
    NGUONVAO NVARCHAR(50) NULL,
    NGUONRA NVARCHAR(50) NULL,
    CONGNGHE NVARCHAR(50) NULL,
    KICHTHUOC NVARCHAR(50) NULL,
    BAOHANH INT NULL,
    KHOILUONG NVARCHAR(50) NULL,

    CONSTRAINT PK_CTPKSACDUPHONG PRIMARY KEY(MACTPKSAC),
    CONSTRAINT FK_CTPKSAC_SANPHAM FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO

CREATE TABLE CHITIETPHUKIENTAINGHE
(
    MaPKTaiNghe INT IDENTITY NOT NULL,
    MaSP INT NOT NULL,

    DUNGLUONGPIN NVARCHAR(50) NULL,
    THOILUONGSAC NVARCHAR(50) NULL,
    CONGSAC NVARCHAR(50) NULL,
    CONGNGHEAMTHANH NVARCHAR(50) NULL,
    TIENICH NVARCHAR(100) NULL,
    TUONGTHICH NVARCHAR(50) NULL,
    CONGNGHEKETNOT NVARCHAR(50) NULL,
    PHIMDIEUKHIEN NVARCHAR(255) NULL,
    KICHTHUOC NVARCHAR(50) NULL,
    BAOHANH INT NULL, 
    KHOILUONG NVARCHAR(50) NULL, 

    CONSTRAINT PK_CTPKTAINGHE PRIMARY KEY(MaPKTaiNghe),
    CONSTRAINT FK_CTPKTAINGHE_SANPHAM FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO

CREATE TABLE CHITIETSANPHAM
(
    MaChiTietSP INT IDENTITY NOT NULL,
    MaSP INT NOT NULL,

    KICHTHUOCMANHINH NVARCHAR(50) NULL,
    CONGNGHEMANHINH NVARCHAR(100) NULL,
    DOPHANGIAI NVARCHAR(100) NULL,
    TINHNANGMANGHINH NVARCHAR(MAX) NULL,
    TANSOQUET NVARCHAR(50) NULL,
    CAMERASAU NVARCHAR(255) NULL, 
    QUAYPHIM NVARCHAR(255) NULL,
    CAMERATRUOC NVARCHAR(255) NULL,
    TINHNANGCAMERA NVARCHAR(MAX) NULL,
    HEDIEUHANH NVARCHAR(50) NULL,
    CHIP NVARCHAR(100) NULL,
    TOCDOCPU NVARCHAR(50) NULL,
    CHIPDOHOA NVARCHAR(50) NULL,
    RAM NVARCHAR(20) NULL,
    DUNGLUONG NVARCHAR(20) NULL,
    MANGDIDONG NVARCHAR(20) NULL,
    SIM NVARCHAR(100) NULL,
    WIFI NVARCHAR(255) NULL,
    CONGKETNOI NVARCHAR(50) NULL,
    DUNGLUONGPIN NVARCHAR(20) NULL,
    LOAIPIN NVARCHAR(20) NULL,
    HOTROSAC NVARCHAR(20) NULL,
    BAOMAT NVARCHAR(50) NULL,
    TINHNANGDACBIET NVARCHAR(MAX) NULL,
    KHANGNUOC NVARCHAR(50) NULL,
    THIETKE NVARCHAR(50) NULL,
    CHATLIEU NVARCHAR(255) NULL,
    KICHTHUOC NVARCHAR(255) NULL,
    BAOHANH INT NULL,
    RAMAT DATE NULL,

    CONSTRAINT PK_CHITIETSP PRIMARY KEY(MaChiTietSP),
    CONSTRAINT FK_CTSP_SANPHAM FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO

CREATE TABLE MAU
(
    MaMau INT IDENTITY NOT NULL,
    TenMau NVARCHAR(50) NULL,

    CONSTRAINT PK_MAU PRIMARY KEY(MaMau)
)
GO

CREATE TABLE SANPHAM_MAU
(
     MaSP_Mau INT IDENTITY NOT NULL,
     MaSP INT  NOT NULL,
     MaMau INT NOT NULL,

     CONSTRAINT PK_SP_MAU PRIMARY KEY(MaSP_Mau),
     CONSTRAINT FK_SPMAU_SP FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP),
     CONSTRAINT FK_SPMAU_MAU FOREIGN KEY(MaMau) REFERENCES MAU(MaMau)
)
GO

CREATE TABLE CONGNO
(
    MaCongNo INT IDENTITY NOT NULL,
    MaNCC INT NOT NULL,
    SoTienNo DECIMAL(18, 0) NOT NULL,
    NgayCongNo DATE NOT NULL,

    CONSTRAINT PK_CongNo PRIMARY KEY (MaCongNo),
    CONSTRAINT FK_CongNo_NCC FOREIGN KEY (MaNCC) REFERENCES NHACUNGCAP(MaNCC) ON DELETE CASCADE
)
GO

CREATE TABLE GIOHANG
(
    MaGioHang INT IDENTITY NOT NULL,
    MaTV INT NULL,

    CONSTRAINT PK_GIOHANG PRIMARY KEY(MaGioHang),
    CONSTRAINT FK_GIOHANG_TV FOREIGN KEY(MaTV) REFERENCES THANHVIEN(MaTV) ON DELETE CASCADE
)
GO

CREATE TABLE CHITIETGIOHANG
(
    MaChiTietGH INT IDENTITY NOT NULL,
    MaGioHang INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,0) NOT NULL,
    MaMau INT NOT NULL,

    CONSTRAINT PK_CTGH PRIMARY KEY(MaChiTietGH),
    CONSTRAINT FK_CTGH_GH FOREIGN KEY(MaGioHang) REFERENCES GIOHANG(MaGioHang),
    CONSTRAINT FK_CTGH_SP FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
)
GO

CREATE TABLE QUYEN
(
    MaQuyen NVARCHAR(50) NOT NULL,
    TenQuyen NVARCHAR(50),
    
    CONSTRAINT PK_QUYEN PRIMARY KEY(MaQuyen)
)
GO

CREATE TABLE LOAITHANHVIEN_QUYEN
(
    MaLoaiTV INT NOT NULL,
    MaQuyen NVARCHAR(50) NOT NULL,
    GhiChu NVARCHAR(100),

    CONSTRAINT PK_LTV_QUYEN PRIMARY KEY(MaLoaiTV, MaQuyen),
    CONSTRAINT FK_LTVQ_Q FOREIGN KEY (MaQuyen) REFERENCES QUYEN(MaQuyen),
    CONSTRAINT FK_LTVQ_TV FOREIGN KEY (MaLoaiTV) REFERENCES LoaiThanhVien(MaLoaiTV),
)
GO

INSERT INTO LOAITHANHVIEN(TenLoai, UuDai) VALUES
(N'Admin', null),
(N'Thường', null),
(N'Member', null),
(N'VIP', null)
GO

INSERT INTO QUYEN(MaQuyen, TenQuyen) VALUES
('Admin', N'Quản trị'),
('Product', N'Sản phẩm')
GO

INSERT INTO LOAITHANHVIEN_QUYEN(MaLoaiTV, MaQuyen, GhiChu) VALUES
(1, 'Admin', null),
(2, 'Product', null)
GO

--Insert THANHVIEN
--MaTV INT IDENTITY NOT NULL,
--MaLoaiTV INT NOT NULL,
--TaiKhoan NVARCHAR(100) NOT NULL,
--MatKhau NVARCHAR(100) NOT NULL,
--HoTen NVARCHAR(100) NOT NULL,
--DiaChi NVARCHAR(255) NULL,
--Email NVARCHAR(255) NULL,
--SoDienThoai VARCHAR(12) NULL,
--CauHoi NVARCHAR(MAX) NULL,
--CauTraLoi NVARCHAR(MAX) NULL

INSERT INTO THANHVIEN(MaLoaiTV, TaiKhoan, MatKhau, HoTen, DiaChi, Email, SoDienThoai, CauHoi, CauTraLoi) VALUES
(1, N'CongCao', N'123456', N'Cao Tấn Công', N'Số 94 đường Xuân Thủy, Phường Thảo Điền, Thành phố Thủ Đức, Thành phố Hồ Chí Minh', N'caotancong2003@gmail.com', '0362111265', null, null),
(1, N'TaiLe', N'123456', N'Lê Hữu Tài', N'A8/22L/2T Ấp 1, Xã Vĩnh Lộc B, Huyện Bình Chánh, Thành phố Hồ Chí Minh', N'lehuutai09@gmail.com', '0324195842', null, null),
(2, N'ThanhThao', N'123456', N'Nguyễn Thị Thanh Thảo', N'212/321/17 Nguyễn Văn Nguyễn, Phường Tân Định, Quận 1, Thành phố Hồ Chí Minh', N'thanhthaonopro@gamil.com', '0342594124', null, null),
(2, N'CongHuy', N'123456', N'Huỳnh Công Huy', N'1028/39 Tân Kỳ Tân Quý, Phường Bình Hưng Hòa, Quận Bình Tân, Thành phố Hồ Chí Minh', N'conghuyhuynh1610@gmail.com', '0942943054', null, null)
GO

--INSERT KHACHHANG
--MaKH INT IDENTITY NOT NULL,
--MaTV INT NULL,
--TenKH NVARCHAR(100) NOT NULL,
--DiaChi NVARCHAR(255) NULL,
--Email NVARCHAR(255) NULL,
--SoDienThoai VARCHAR(12) NULL

INSERT INTO KHACHHANG(MaTV, TenKH, DiaChi, Email, SoDienThoai) VALUES
(1, N'Cao Tấn Công', N'Số 94 đường Xuân Thủy, Phường Thảo Điền, Thành phố Thủ Đức, Thành phố Hồ Chí Minh', N'caotancong2003@gmail.com', 0362111265),
(2, N'Lê Hữu Tài', N'A8/22L/2T Ấp 1, Xã Vĩnh Lộc B, Huyện Bình Chánh, Thành phố Hồ Chí Minh', N'lehuutai09@gmail.com', 0324195842),
(null, N'Lê Trí Cường', null, null, null),
(null, N'Nguyễn Quốc Tiến', null, null, null)
GO

--INSERT DONDATHANG
--MaDDH INT IDENTITY NOT NULL,
--MaKH INT NOT NULL,
--NgayDatHang DATETIME NOT NULL,
--TinhTrang BIT NOT NULL, 1: Đã giao; 0: Chưa giao
--NgayGiao DATETIME NULL,
--DaThanhToan BIT NOT NULL, 1: Đã thanh toán; 0: Chưa thanh toán
--UuDai INT NULL Đơn vị %



--INSERT NHACUNGCAP
--MaNCC INT IDENTITY NOT NULL,
--TenNCC NVARCHAR(100) NOT NULL,
--DiaChi NVARCHAR(255) NOT NULL,
--Email NVARCHAR(100) NOT NULL,
--SoDienThoai VARCHAR(12) NOT NULL,
--Fax NVARCHAR(50) NULL

INSERT INTO NHACUNGCAP(TenNCC, DiaChi, Email, SoDienThoai, Fax) VALUES
(N'Nguyễn Văn Hùng', N'66-68 Nguyễn Tất Thành, Phường 13, Quận 4, Thành phố Hồ Chí Minh', N'nguyenvanhung@gmail.com', N'0362156365', null),
(N'Bùi Thanh Tân', N'163/23 Nơ Trang Long, Phường 11, Quận Bình Thạnh, Thành phố Hồ Chí Minh', N'buithanhtan2020@gmail.com', N'03623141265', null), 
(N'Đinh Văn Dũng', N'15/48A Đoàn Như Hài, Phường 13, Quận 4, Thành phố Hồ Chí Minh', N'vandungdungvan@gmail.com', N'0309735176', null), 
(N'Nguyễn Thị Thanh Nhàn', N'533/32 Huỳnh Văn Bánh, Phường 13, Quận Phú Nhuận, Thành phố Hồ Chí Minh', N'thanhnhan@gmail.com', N'0309346376', null),
(N'Vũ Quang Vinh', N'67 Mai Văn Ngọc, Phường 11, Quận Phú Nhuận, Thành phố Hồ Chí Minh', N'quangvinh@gmail.com', N'0987535143', null),
(N'Nguyễn Hồng Sơn', N'265/10 Nơ Trang Long, Phường 11, Quận Bình Thạnh, Thành phố Hồ Chí Minh', N'hongson@gmail.com', N'0989734211', null),
(N'Võ Thị Hồng Như', N'DV.1.08 Tầng 1, Dự án The Everrich Infinity – 290 An Dương Vương, Phường 04, Quận 5, Thành phố Hồ Chí Minh', N'hongnhu@gmail.com', N'0409545113', null)
GO

INSERT INTO DANHMUC (TenDanhMuc) VALUES
(N'Điện thoại'),
(N'Phụ kiện')
GO

--INSERT LOAISANPHAM
--MaLoaiSP INT IDENTITY NOT NULL,
--TenLoaiSP NVARCHAR(100) NOT NULL,
--Icon NVARCHAR(MAX) NULL,
--BiDanh NVARCHAR(50) NULL

INSERT INTO LOAISANPHAM(MaDanhMuc, TenLoaiSP, Icon, BiDanh) VALUES
(1, N'Iphone', N'logo-iphone-220x48.png', null),
(1, N'Oppo', N'OPPO42-b_5.jpg', null),
(1, N'Vivo', N'vivo-logo-220-220x48-3.png', null),
(1, N'Samsung', N'samsungnew-220x48-1.png', null),
(1, N'Xiaomi', N'logo-xiaomi-220x48-5.png', null),
(2, N'Sạc dự phòng', null, null),
(2, N'Tai nghe', null, null)
GO

--INSERT NHASANXUAT
--MaNSX INT IDENTITY NOT NULL,
--TenNSX NVARCHAR(100) NOT NULL, 
--ThongTin NVARCHAR(255) NULL,
--Logo NVARCHAR(MAX) NULL

INSERT INTO NHASANXUAT(TenNSX, ThongTin, Logo) VALUES
(N'Apple', N'Apple Inc. là một tập đoàn công nghệ có trụ sở tại Cupertino, California, Mỹ. Họ nổi tiếng với việc sản xuất các sản phẩm công nghệ như iPhone, iPad, Macbook, và nhiều sản phẩm khác. Apple được thành lập vào năm 1976 bởi Steve Jobs, Steve Wozniak và Ronald Wayne. Hãng có một lịch sử dài về đổi mới và thiết kế đẹp, và họ luôn nằm trong số những công ty công nghệ hàng đầu thế giới.', N'Iphone.png'),
(N'OPPO ', N'OPPO là một công ty điện tử tiêu dùng và điện thoại di động có trụ sở tại Đông Quan, Quảng Đông, Trung Quốc. OPPO được thành lập vào năm 2001 và nhanh chóng trở thành một trong những thương hiệu điện thoại di động phổ biến trên toàn thế giới. Họ nổi tiếng với việc sản xuất các smartphone chất lượng cao và camera mạnh mẽ.', N'oppo.png'),
(N'Vivo', N'Vivo là một công ty điện tử tiêu dùng và điện thoại di động có trụ sở tại Đông Quan, Quảng Đông, Trung Quốc. Họ được thành lập vào năm 2009 và cũng là một thương hiệu nổi tiếng trong ngành công nghệ di động. Vivo tập trung vào việc cung cấp các sản phẩm có hiệu năng mạnh mẽ và tính năng camera tiên tiến.', N'vivo.png'),
(N'Samsung', N'Samsung là một tập đoàn đa quốc gia có trụ sở tại Seoul, Hàn Quốc. Họ là một trong những công ty điện tử lớn nhất thế giới và sản xuất nhiều loại sản phẩm khác nhau, bao gồm điện thoại di động, TV, máy lạnh, và nhiều sản phẩm khác. Samsung được thành lập vào năm 1938 và có một lịch sử dài về đổi mới và phát triển công nghệ.', N'samsung.png'),
(N'Xiaomi', N'Xiaomi là một công ty công nghệ có trụ sở tại Bắc Kinh, Trung Quốc. Họ được thành lập vào năm 2010 và nhanh chóng trở thành một trong những thương hiệu điện thoại di động phổ biến và giá cả phải chăng trên toàn thế giới. Xiaomi cũng sản xuất các sản phẩm khác như máy tính bảng, điện tử gia đình và các sản phẩm thông minh.', N'xiaomi.png'),
(N'AVA', N'AVA là một công ty chuyên sản xuất và phân phối các sản phẩm điện tử tiêu dùng, bao gồm tai nghe, loa, và các thiết bị âm thanh. Họ được biết đến với chất lượng âm thanh cao cấp và thiết kế đẹp mắt. AVA đã hoạt động trong ngành công nghiệp âm thanh từ nhiều năm và có mạng lưới phân phối rộng khắp thế giới.', N'ava.png'),
(N'HAVIT', N'HAVIT là một thương hiệu nổi tiếng trong lĩnh vực sản xuất các sản phẩm công nghệ tiêu dùng, bao gồm bàn phím, chuột, tai nghe, và các phụ kiện máy tính. HAVIT chú trọng vào việc cung cấp sản phẩm có chất lượng và giá cả hợp lý cho người tiêu dùng. Họ có một loạt sản phẩm đa dạng để đáp ứng nhu cầu của khách hàng trên toàn thế giới.', N'havit.png')
GO

--INSERT PHIEUNHAP
--MaPN INT IDENTITY NOT NULL,
--MaNCC INT NOT NULL,
--NgayNhap DATETIME NOT NULL,
--DaXoa BIT NOT NULL 1: Đã xóa; 0: Chưa xóa

INSERT INTO PHIEUNHAP(MaNCC, NgayNhap, DaXoa) VALUES
(1, '2023-08-01', 0),
(2, '2022-12-01', 0),
(3, '2022-10-01', 0), 
(4, '2022-11-01', 0), 
(5, '2022-01-01', 0), 
(6, '2022-05-01', 0),
(7, '2022-06-01', 0)
GO

--INSERT KHUYENMAI
--MaKhuyenMai INT IDENTITY NOT NULL,
--TenKhuyenMai NVARCHAR(255) NOT NULL,
--MoTa NVARCHAR(MAX) NULL,
--PhanTramGiamGia INT NOT NULL,
--NgayBatDau DATE NOT NULL,
--NgayKetThuc DATE NOT NULL

INSERT INTO KHUYENMAI(TenKhuyenMai, MoTa, PhanTramGiamGia, NgayBatDau, NgayKetThuc) VALUES
(N'Khuyễn mãi đợt 1 cho iPhone', N'Khuyến mãi 5% cho Iphone', 5, '2023-09-20', '2023-09-30'),
(N'Khuyến mãi đợt 2 cho Samsung', N'Khuyến mãi 10% cho Samsung', 10, '2023-09-20', '2023-09-30'),
(N'Khuyến mãi đợt 3 cho tai nghe', N'Khuyến mãi 15% cho tai nghe', 15, '2023-09-20', '2023-09-30'),
(N'Khuyến mãi đợt 4 cho sạc dự phòng', N'Khuyến mãi 20% cho tai nghe', 20, '2023-01-20', '2023-03-30')
GO

--INSERT SANPHAM
--MaSP INT IDENTITY NOT NULL,
--MaNCC INT NOT NULL,
--MaNSX INT NOT NULL,
--MaLoaiSP INT NOT NULL,

--TenSP NVARCHAR(255) NOT NULL,
--DonGia DECIMAL(18,0) NOT NULL,
--NgayCapNhat DATETIME NULL,
--MoTa NVARCHAR(MAX) NULL,
--HinhAnh NVARCHAR(MAX) NULL,
--HinhAnh2 NVARCHAR(MAX) NULL,
--HinhAnh3 NVARCHAR(MAX) NULL,
--SoLuongTon INT NOT NULL,
--LuotXem INT NULL,
--LuotBinhChon INT NULL,
--LuotBinhLuan INT NULL,
--SoLanMua INT NULL,
--Moi BIT NOT NULL,
--DaXoa BIT NOT NULL
INSERT INTO SANPHAM(MaNCC, MaNSX, MaLoaiSP, MaKhuyenMai, TenSP, DonGia, NgayCapNhat, MoTa, HinhAnh, HinhAnh2, HinhAnh3, SoLuongTon, LuotXem, LuotBinhChon, LuotBinhLuan, SoLanMua, Moi, DaXoa) VALUES
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 128GB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 256GB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 512GB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 1TB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 13 Pro Max 123GB', NULL, '2023-08-01', N'Điện thoại iPhone 13 Pro Max 128 GB - siêu phẩm được mong chờ nhất ở nửa cuối năm 2021 đến từ Apple. Máy có thiết kế không mấy đột phá khi so với người tiền nhiệm, bên trong đây vẫn là một sản phẩm có màn hình siêu đẹp, tần số quét được nâng cấp lên 120 Hz mượt mà, cảm biến camera có kích thước lớn hơn, cùng hiệu năng mạnh mẽ với sức mạnh đến từ Apple A15 Bionic, sẵn sàng cùng bạn chinh phục mọi thử thách.', N'iphone-13-pro-max-1-1.jpg', N'iphone-13-pro-max-1.jpg', N'iphone-13-pro-max-n-2.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 13 Pro Max 256GB', NULL, '2023-08-01', N'Điện thoại iPhone 13 Pro Max 256 GB - siêu phẩm được mong chờ nhất ở nửa cuối năm 2021 đến từ Apple. Máy có thiết kế không mấy đột phá khi so với người tiền nhiệm, bên trong đây vẫn là một sản phẩm có màn hình siêu đẹp, tần số quét được nâng cấp lên 120 Hz mượt mà, cảm biến camera có kích thước lớn hơn, cùng hiệu năng mạnh mẽ với sức mạnh đến từ Apple A15 Bionic, sẵn sàng cùng bạn chinh phục mọi thử thách.', N'iphone-13-pro-max-1-1.jpg', N'iphone-13-pro-max-1.jpg', N'iphone-13-pro-max-n-2.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 13 Pro Max 512GB', NULL, '2023-08-01', N'Điện thoại iPhone 13 Pro Max 512 GB - siêu phẩm được mong chờ nhất ở nửa cuối năm 2021 đến từ Apple. Máy có thiết kế không mấy đột phá khi so với người tiền nhiệm, bên trong đây vẫn là một sản phẩm có màn hình siêu đẹp, tần số quét được nâng cấp lên 120 Hz mượt mà, cảm biến camera có kích thước lớn hơn, cùng hiệu năng mạnh mẽ với sức mạnh đến từ Apple A15 Bionic, sẵn sàng cùng bạn chinh phục mọi thử thách.', N'iphone-13-pro-max-1-1.jpg', N'iphone-13-pro-max-1.jpg', N'iphone-13-pro-max-n-2.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 12 Pro Max 128GB', NULL, '2023-08-01', N'iPhone 12 Pro Max 128 GB một siêu phẩm smartphone đến từ Apple. Máy có một hiệu năng hoàn toàn mạnh mẽ đáp ứng tốt nhiều nhu cầu đến từ người dùng và mang trong mình một thiết kế đầy vuông vức, sang trọng.', N'iphone-12-pro-max-512gb-1-org.jpg', N'iphone-12-pro-max-512gb-bac-1-org.jpg', N'iphone-12-pro-max-512gb-note-2.jpg', 10, null, null, null, 0, 0, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 12 Pro Max 256GB', NULL, '2023-08-01', N'iPhone 12 Pro Max 256 GB một siêu phẩm smartphone đến từ Apple. Máy có một hiệu năng hoàn toàn mạnh mẽ đáp ứng tốt nhiều nhu cầu đến từ người dùng và mang trong mình một thiết kế đầy vuông vức, sang trọng.', N'iphone-12-pro-max-512gb-1-org.jpg', N'iphone-12-pro-max-512gb-bac-1-org.jpg', N'iphone-12-pro-max-512gb-note-2.jpg', 10, null, null, null, 0, 0, 0),
(2, 2, 2, null, N'Điện thoại OPPO Find N2 Flip 5G', NULL, '2023-08-01', N'OPPO Find N2 Flip 5G - chiếc điện thoại gập đầu tiên của OPPO đã được giới thiệu chính thức tại Việt Nam vào tháng 03/2023. Sở hữu cấu hình mạnh mẽ cùng thiết kế siêu nhỏ gọn giúp tối ưu kích thước, chiếc điện thoại sẽ cùng bạn nổi bật trong mọi không gian với vẻ ngoài đầy cá tính.', N'oppo-n2-flip-tim-1-1.jpg', N'oppo-n2-flip-den-1.jpg', N'oppo-n2-flip-tim-note.jpg', 10, null, null, null, 0, 1, 0),
(2, 2, 2, null, N'Điện thoại OPPO Reno10 Pro 5G', NULL, '2023-08-01', N'OPPO Reno10 Pro 5G là một trong những sản phẩm của OPPO được ra mắt trong 2023. Với thiết kế đẹp mắt, màn hình lớn và hiệu năng mạnh mẽ, Reno10 Pro chắc chắn sẽ là lựa chọn đáng cân nhắc dành cho những ai đang tìm kiếm chiếc máy tầm trung để phục vụ tốt mọi nhu cầu.', N'oppo-reno10-pro-xam-1-1.jpg', N'oppo-reno10-pro-tim-1-2.jpg', N'oppo-reno10-pro-note.jpg', 10, null, null, null, 0, 1, 0),
(2, 2, 2, null, N'Điện thoại OPPO A77s', NULL, '2023-08-01', N'OPPO vừa cho ra mắt mẫu điện thoại tầm trung mới với tên gọi OPPO A77s, máy sở hữu màn hình lớn, thiết kế đẹp mắt, hiệu năng ổn định cùng khả năng mở rộng RAM lên đến 8 GB vô cùng nổi bật trong phân khúc.', N'oppo-a77s-den-1.jpg', N'oppo-a77s-xanh-1.jpg', N'oppo-a77s-note-2.jpg', 10, null, null, null, 0, 1, 0),
(3, 3, 3, null, N'Điện thoại vivo V25 Pro 5G', NULL, '2023-08-01', N'VIVO V25 Pro 5G vừa được ra mắt với một mức giá bán cực kỳ hấp dẫn, thế mạnh của máy thuộc về phần hiệu năng nhờ trang bị con chip MediaTek Dimensity 1300 và cụm camera sắc nét 64 MP, hứa hẹn mang lại cho người dùng những trải nghiệm ổn định trong suốt quá trình sử dụng.', N'vivo-v25-pro-5g-sld-xanh-1.jpg', N'vivo-v25-pro-5g-den-1.jpg', N'vivo-v25-pro-5g-note-2.jpg', 10, null, null, null, 0, 1, 0),
(3, 3, 3, null, N'Điện thoại vivo Y02A', NULL, '2023-08-01', N'VIVO Y02A mẫu điện thoại được nhà vivo cho ra mắt hướng đến nhóm người dùng yêu thích sự đơn giản trong thiết kế, hiệu năng tốt có thể xử lý các tác vụ thường ngày và một viên pin lớn đáp ứng được nhu cầu sử dụng lâu dài.', N'vivo-y02-den-1.jpg', N'vivo-y02-tim-1.jpg', N'vivo-y02-note.jpg', 10, null, null, null, 0, 1, 0),
(3, 3, 3, null, N'Điện thoại vivo V27e', NULL, '2023-08-01', N'vivo V27e một trong những chiếc điện thoại tầm trung nổi bật của vivo trong năm 2023. Với thiết kế độc đáo và khả năng chụp ảnh - quay phim ấn tượng, vì thế máy đã mang lại cho vivo nhiều niềm tự hào khi ra mắt tại thị trường Việt Nam, hứa hẹn mang đến trải nghiệm tuyệt vời đến với người dùng.', N'vivo-v27e-tim-1-1.jpg', N'vivo-v27e-den-1.jpg', N'vivo-v27e-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Fold5 5G 256GB ', NULL, '2023-08-01', N'Samsung Galaxy Z Fold5 là mẫu điện thoại cao cấp được ra mắt vào tháng 07/2023 với nhiều điểm đáng chú ý như thiết kế gập độc đáo, hiệu năng mạnh mẽ cùng camera quay chụp tốt, điều này giúp cho máy thu hút được nhiều sự quan tâm của đông đảo người dùng yêu công nghệ hiện nay.', N'samsung-galaxy-zfold5-xanh-256gb-1-1.jpg', N'samsung-galaxy-zfold5-den-256gb-1.jpg', N'samsung-galaxy-zfold5-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Fold5 5G 512GB ', NULL, '2023-08-01', N'Samsung Galaxy Z Fold5 là mẫu điện thoại cao cấp được ra mắt vào tháng 07/2023 với nhiều điểm đáng chú ý như thiết kế gập độc đáo, hiệu năng mạnh mẽ cùng camera quay chụp tốt, điều này giúp cho máy thu hút được nhiều sự quan tâm của đông đảo người dùng yêu công nghệ hiện nay.', N'samsung-galaxy-zfold5-xanh-256gb-1-1.jpg', N'samsung-galaxy-zfold5-den-256gb-1.jpg', N'samsung-galaxy-zfold5-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Fold5 5G 1TB', NULL, '2023-08-01', N'Samsung Galaxy Z Fold5 là mẫu điện thoại cao cấp được ra mắt vào tháng 07/2023 với nhiều điểm đáng chú ý như thiết kế gập độc đáo, hiệu năng mạnh mẽ cùng camera quay chụp tốt, điều này giúp cho máy thu hút được nhiều sự quan tâm của đông đảo người dùng yêu công nghệ hiện nay.', N'samsung-galaxy-zfold5-xanh-256gb-1-1.jpg', N'samsung-galaxy-zfold5-den-256gb-1.jpg', N'samsung-galaxy-zfold5-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Flip4 5G 128GB', NULL, '2023-08-01', N'Samsung Galaxy Z Flip4 128GB đã chính thức ra mắt thị trường công nghệ, đánh dấu sự trở lại của Samsung trên con đường định hướng người dùng về sự tiện lợi trên những chiếc điện thoại gập. Với độ bền được gia tăng cùng kiểu thiết kế đẹp mắt giúp Flip4 trở thành một trong những tâm điểm sáng giá cho nửa cuối năm 2022.', N'samsung-galaxy-flip4-glr-tim-1.jpg', N'samsung-galaxy-flip-den-1.jpg', N'samsung-galaxy-z-flip4-note-1-1.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Flip4 5G 256GB', NULL, '2023-08-01', N'Samsung Galaxy Z Flip4 256GB đã chính thức ra mắt thị trường công nghệ, đánh dấu sự trở lại của Samsung trên con đường định hướng người dùng về sự tiện lợi trên những chiếc điện thoại gập. Với độ bền được gia tăng cùng kiểu thiết kế đẹp mắt giúp Flip4 trở thành một trong những tâm điểm sáng giá cho nửa cuối năm 2022.', N'samsung-galaxy-flip4-glr-tim-1.jpg', N'samsung-galaxy-flip-den-1.jpg', N'samsung-galaxy-z-flip4-note-1-1.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Flip4 5G 512GB', NULL, '2023-08-01', N'Samsung Galaxy Z Flip4 512GB đã chính thức ra mắt thị trường công nghệ, đánh dấu sự trở lại của Samsung trên con đường định hướng người dùng về sự tiện lợi trên những chiếc điện thoại gập. Với độ bền được gia tăng cùng kiểu thiết kế đẹp mắt giúp Flip4 trở thành một trong những tâm điểm sáng giá cho nửa cuối năm 2022.', N'samsung-galaxy-flip4-glr-tim-1.jpg', N'samsung-galaxy-flip-den-1.jpg', N'samsung-galaxy-z-flip4-note-1-1.jpg', 10, null, null, null, 0, 1, 0),
(5, 5, 5, null, N'Điện thoại Xiaomi 12 5G', NULL, '2023-08-01', N'Điện thoại Xiaomi đang dần khẳng định chỗ đứng của mình trong phân khúc flagship bằng việc ra mắt Xiaomi 12 với bộ thông số ấn tượng, máy có một thiết kế gọn gàng, hiệu năng mạnh mẽ, màn hình hiển thị chi tiết cùng khả năng chụp ảnh sắc nét nhờ trang bị ống kính đến từ Sony.', N'xiaomi-mi-12-1-1.jpg', N'xiaomi-mi-12-1.jpg', N'xiaomi-mi-12-note.jpg', 10, null, null, null, 0, 1, 0),
(5, 5, 5, null, N'Điện thoại Xiaomi Redmi Note 12S', NULL, '2023-08-01', N'Xiaomi Redmi Note 12S sẽ là chiếc điện thoại tiếp theo được nhà Xiaomi tung ra thị trường Việt Nam trong thời gian tới (05/2023). Điện thoại sở hữu một lối thiết kế hiện đại, màn hình hiển thị chi tiết đi cùng với đó là một hiệu năng mượt mà xử lý tốt các tác vụ.', N'xiaomi-redmi-note-12s-1-1.jpg', N'xiaomi-redmi-note-12s-xanh-1.jpg', N'xiaomi-redmi-note-12s-note.jpg', 10, null, null, null, 0, 1, 0),
(5, 5, 5, null, N'Điện thoại Xiaomi Redmi Note 12 Pro 128GB', NULL, '2023-08-01', N'Xiaomi Redmi Note 12 Pro 4G tiếp tục sẽ là mẫu điện thoại tầm trung được nhà Xiaomi giới thiệu đến thị trường Việt Nam trong năm 2023, máy nổi bật với camera 108 MP chất lượng, thiết kế viền mỏng cùng hiệu năng đột phá nhờ trang bị chip Snapdragon 732G.', N'xiami-redmi-12-pro-xam-1.jpg', N'xiaomi-redmi-12-pro-4g-xanh-duong-1.jpg', N'xiaomi-redmi-12-note-2.jpg', 10, null, null, null, 0, 1, 0),
(6, 6, 6, 3, N'Pin sạc dự phòng Polymer 10000mAh Type C 15W AVA+ JP399', NULL, '2023-08-01', N'Pin sạc dự phòng Polymer 10000mAh Type C 15W AVA+ JP399 mang đến cho người dùng 1 thiết kế nhỏ gọn, trang bị gam màu sang trọng và kiểu dáng tối giản, dung lượng 10000mAh và hiệu suất 64%, pin sạc dự phòng cung cấp pin cho thiết bị tối ưu.', N'pin-sac-du-phong-polymer-10000mah-type-c-15w-ava-jp399-xanh-1-1.jpg', N'pin-sac-du-phong-polymer-10000mah-type-c-15w-ava-jp399-hong-1.jpg', N'pin-sac-du-phong-polymer-10000mah-type-c-15w-ava-jp399-hong-12.jpg', 10, null, null, null, 0, 1, 0),
(6, 6, 6, 3, N'Pin sạc dự phòng Polymer 10000mAh 12W AVA+ JP299', NULL, '2023-08-01', N'Pin sạc dự phòng Polymer 10000mAh 12W AVA+ JP299 mang đến cho khách hàng 1 thiết kế đẹp mắt, nhờ sở hữu gam màu sang trọng và kiểu dáng tối giản. Sở hữu dung lượng 10000mAh và hiệu suất 64%, pin sạc dự phòng cung cấp năng lượng cho thiết bị tối ưu.', N'pin-sac-du-phong-polymer-10000mah-ava-jp299-den-1.jpg', N'pin-sac-du-phong-polymer-10000mah-ava-jp299-trang-1.jpg', N'pin-sac-du-phong-polymer-10000mah-ava-jp299-trang-8.jpg', 10, null, null, null, 0, 1, 0),
(6, 6, 6, 3, N'Pin sạc dự phòng Polymer 10000mAh Type C 10W AVA+ PB100S', NULL, '2023-08-01', N'Sạc điện thoại của bạn nhiều lần với dung lượng sạc dự phòng 10Pin sạc dự phòng Polymer 10000mAh 12W AVA+ JP299 mang đến cho khách hàng 1 thiết kế đẹp mắt, nhờ sở hữu gam màu sang trọng và kiểu dáng tối giản. Sở hữu dung lượng 10000 mAh và hiệu suất 64%, pin sạc dự phòng cung cấp năng lượng cho thiết bị tối ưu.000 mAh', N'pin-polymer-10000mah-type-c-ava-pb100s-trang-3.jpg', N'pin-polymer-10000mah-type-c-ava-pb100s-den-3.jpg', N'pin-polymer-10000mah-type-c-ava-pb100s-den-13-1.jpg', 10, null, null, null, 0, 1, 0),
(7, 7, 7, 4, N'Tai nghe Bluetooth True Wireless HAVIT TW945', NULL, '2023-08-01', N'Tai nghe Bluetooth True Wireless HAVIT TW945 mang đến thiết kế sang trọng với kiểu dáng tối giản và màu sắc đa dạng, âm thanh đầy đủ và rõ ràng, tích hợp nhiều tính năng và tiện ích khác, phục vụ tốt nhu cầu sử dụng cơ bản hàng ngày của đa số người dùng.', N'tai-nghe-bluetooth-true-wireless-havit-tw945-den-2.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw945-cam-2.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw945-tim-note.jpg', 10, null, null, null, 0, 1, 0),
(7, 7, 7, 4, N'Tai nghe Bluetooth True Wireless HAVIT TW971', NULL, '2023-08-01', N'Tai nghe Bluetooth True Wireless HAVIT TW971 mang đến một thiết kế trong suốt, âm thanh rõ ràng và sống động, cùng với nhiều công nghệ tiện ích được tích hợp, hứa hẹn đáp ứng nhu cầu nghe nhạc hay gọi thoại cơ bản hằng ngày cho người dùng.', N'tai-nghe-bluetooth-true-wireless-havit-tw971-11.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw971-1.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw971-7.jpg', 10, null, null, null, 0, 1, 0),
(7, 7, 7, 4, N'Tai nghe Bluetooth True Wireless HAVIT TW967', NULL, '2023-08-01', N'Tai nghe Bluetooth True Wireless HAVIT TW967 được thiết kế với phong cách năng động, màu sắc đẹp mắt, âm thanh sống động, trang bị kết nối không dây gọn gàng, mang đến cho bạn những trải nghiệm tối ưu.', N'tai-nghe-bluetooth-true-wireless-havit-tw967-trang-2.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw967-den-1.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw967-notecopy.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 128GB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 256GB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 512GB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 1TB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 13 Pro Max 123GB', NULL, '2023-08-01', N'Điện thoại iPhone 13 Pro Max 128 GB - siêu phẩm được mong chờ nhất ở nửa cuối năm 2021 đến từ Apple. Máy có thiết kế không mấy đột phá khi so với người tiền nhiệm, bên trong đây vẫn là một sản phẩm có màn hình siêu đẹp, tần số quét được nâng cấp lên 120 Hz mượt mà, cảm biến camera có kích thước lớn hơn, cùng hiệu năng mạnh mẽ với sức mạnh đến từ Apple A15 Bionic, sẵn sàng cùng bạn chinh phục mọi thử thách.', N'iphone-13-pro-max-1-1.jpg', N'iphone-13-pro-max-1.jpg', N'iphone-13-pro-max-n-2.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 13 Pro Max 256GB', NULL, '2023-08-01', N'Điện thoại iPhone 13 Pro Max 256 GB - siêu phẩm được mong chờ nhất ở nửa cuối năm 2021 đến từ Apple. Máy có thiết kế không mấy đột phá khi so với người tiền nhiệm, bên trong đây vẫn là một sản phẩm có màn hình siêu đẹp, tần số quét được nâng cấp lên 120 Hz mượt mà, cảm biến camera có kích thước lớn hơn, cùng hiệu năng mạnh mẽ với sức mạnh đến từ Apple A15 Bionic, sẵn sàng cùng bạn chinh phục mọi thử thách.', N'iphone-13-pro-max-1-1.jpg', N'iphone-13-pro-max-1.jpg', N'iphone-13-pro-max-n-2.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 13 Pro Max 512GB', NULL, '2023-08-01', N'Điện thoại iPhone 13 Pro Max 512 GB - siêu phẩm được mong chờ nhất ở nửa cuối năm 2021 đến từ Apple. Máy có thiết kế không mấy đột phá khi so với người tiền nhiệm, bên trong đây vẫn là một sản phẩm có màn hình siêu đẹp, tần số quét được nâng cấp lên 120 Hz mượt mà, cảm biến camera có kích thước lớn hơn, cùng hiệu năng mạnh mẽ với sức mạnh đến từ Apple A15 Bionic, sẵn sàng cùng bạn chinh phục mọi thử thách.', N'iphone-13-pro-max-1-1.jpg', N'iphone-13-pro-max-1.jpg', N'iphone-13-pro-max-n-2.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 12 Pro Max 128GB', NULL, '2023-08-01', N'iPhone 12 Pro Max 128 GB một siêu phẩm smartphone đến từ Apple. Máy có một hiệu năng hoàn toàn mạnh mẽ đáp ứng tốt nhiều nhu cầu đến từ người dùng và mang trong mình một thiết kế đầy vuông vức, sang trọng.', N'iphone-12-pro-max-512gb-1-org.jpg', N'iphone-12-pro-max-512gb-bac-1-org.jpg', N'iphone-12-pro-max-512gb-note-2.jpg', 10, null, null, null, 0, 0, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 12 Pro Max 256GB', NULL, '2023-08-01', N'iPhone 12 Pro Max 256 GB một siêu phẩm smartphone đến từ Apple. Máy có một hiệu năng hoàn toàn mạnh mẽ đáp ứng tốt nhiều nhu cầu đến từ người dùng và mang trong mình một thiết kế đầy vuông vức, sang trọng.', N'iphone-12-pro-max-512gb-1-org.jpg', N'iphone-12-pro-max-512gb-bac-1-org.jpg', N'iphone-12-pro-max-512gb-note-2.jpg', 10, null, null, null, 0, 0, 0),
(2, 2, 2, null, N'Điện thoại OPPO Find N2 Flip 5G', NULL, '2023-08-01', N'OPPO Find N2 Flip 5G - chiếc điện thoại gập đầu tiên của OPPO đã được giới thiệu chính thức tại Việt Nam vào tháng 03/2023. Sở hữu cấu hình mạnh mẽ cùng thiết kế siêu nhỏ gọn giúp tối ưu kích thước, chiếc điện thoại sẽ cùng bạn nổi bật trong mọi không gian với vẻ ngoài đầy cá tính.', N'oppo-n2-flip-tim-1-1.jpg', N'oppo-n2-flip-den-1.jpg', N'oppo-n2-flip-tim-note.jpg', 10, null, null, null, 0, 1, 0),
(2, 2, 2, null, N'Điện thoại OPPO Reno10 Pro 5G', NULL, '2023-08-01', N'OPPO Reno10 Pro 5G là một trong những sản phẩm của OPPO được ra mắt trong 2023. Với thiết kế đẹp mắt, màn hình lớn và hiệu năng mạnh mẽ, Reno10 Pro chắc chắn sẽ là lựa chọn đáng cân nhắc dành cho những ai đang tìm kiếm chiếc máy tầm trung để phục vụ tốt mọi nhu cầu.', N'oppo-reno10-pro-xam-1-1.jpg', N'oppo-reno10-pro-tim-1-2.jpg', N'oppo-reno10-pro-note.jpg', 10, null, null, null, 0, 1, 0),
(2, 2, 2, null, N'Điện thoại OPPO A77s', NULL, '2023-08-01', N'OPPO vừa cho ra mắt mẫu điện thoại tầm trung mới với tên gọi OPPO A77s, máy sở hữu màn hình lớn, thiết kế đẹp mắt, hiệu năng ổn định cùng khả năng mở rộng RAM lên đến 8 GB vô cùng nổi bật trong phân khúc.', N'oppo-a77s-den-1.jpg', N'oppo-a77s-xanh-1.jpg', N'oppo-a77s-note-2.jpg', 10, null, null, null, 0, 1, 0),
(3, 3, 3, null, N'Điện thoại vivo V25 Pro 5G', NULL, '2023-08-01', N'VIVO V25 Pro 5G vừa được ra mắt với một mức giá bán cực kỳ hấp dẫn, thế mạnh của máy thuộc về phần hiệu năng nhờ trang bị con chip MediaTek Dimensity 1300 và cụm camera sắc nét 64 MP, hứa hẹn mang lại cho người dùng những trải nghiệm ổn định trong suốt quá trình sử dụng.', N'vivo-v25-pro-5g-sld-xanh-1.jpg', N'vivo-v25-pro-5g-den-1.jpg', N'vivo-v25-pro-5g-note-2.jpg', 10, null, null, null, 0, 1, 0),
(3, 3, 3, null, N'Điện thoại vivo Y02A', NULL, '2023-08-01', N'VIVO Y02A mẫu điện thoại được nhà vivo cho ra mắt hướng đến nhóm người dùng yêu thích sự đơn giản trong thiết kế, hiệu năng tốt có thể xử lý các tác vụ thường ngày và một viên pin lớn đáp ứng được nhu cầu sử dụng lâu dài.', N'vivo-y02-den-1.jpg', N'vivo-y02-tim-1.jpg', N'vivo-y02-note.jpg', 10, null, null, null, 0, 1, 0),
(3, 3, 3, null, N'Điện thoại vivo V27e', NULL, '2023-08-01', N'vivo V27e một trong những chiếc điện thoại tầm trung nổi bật của vivo trong năm 2023. Với thiết kế độc đáo và khả năng chụp ảnh - quay phim ấn tượng, vì thế máy đã mang lại cho vivo nhiều niềm tự hào khi ra mắt tại thị trường Việt Nam, hứa hẹn mang đến trải nghiệm tuyệt vời đến với người dùng.', N'vivo-v27e-tim-1-1.jpg', N'vivo-v27e-den-1.jpg', N'vivo-v27e-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Fold5 5G 256GB ', NULL, '2023-08-01', N'Samsung Galaxy Z Fold5 là mẫu điện thoại cao cấp được ra mắt vào tháng 07/2023 với nhiều điểm đáng chú ý như thiết kế gập độc đáo, hiệu năng mạnh mẽ cùng camera quay chụp tốt, điều này giúp cho máy thu hút được nhiều sự quan tâm của đông đảo người dùng yêu công nghệ hiện nay.', N'samsung-galaxy-zfold5-xanh-256gb-1-1.jpg', N'samsung-galaxy-zfold5-den-256gb-1.jpg', N'samsung-galaxy-zfold5-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Fold5 5G 512GB ', NULL, '2023-08-01', N'Samsung Galaxy Z Fold5 là mẫu điện thoại cao cấp được ra mắt vào tháng 07/2023 với nhiều điểm đáng chú ý như thiết kế gập độc đáo, hiệu năng mạnh mẽ cùng camera quay chụp tốt, điều này giúp cho máy thu hút được nhiều sự quan tâm của đông đảo người dùng yêu công nghệ hiện nay.', N'samsung-galaxy-zfold5-xanh-256gb-1-1.jpg', N'samsung-galaxy-zfold5-den-256gb-1.jpg', N'samsung-galaxy-zfold5-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Fold5 5G 1TB', NULL, '2023-08-01', N'Samsung Galaxy Z Fold5 là mẫu điện thoại cao cấp được ra mắt vào tháng 07/2023 với nhiều điểm đáng chú ý như thiết kế gập độc đáo, hiệu năng mạnh mẽ cùng camera quay chụp tốt, điều này giúp cho máy thu hút được nhiều sự quan tâm của đông đảo người dùng yêu công nghệ hiện nay.', N'samsung-galaxy-zfold5-xanh-256gb-1-1.jpg', N'samsung-galaxy-zfold5-den-256gb-1.jpg', N'samsung-galaxy-zfold5-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Flip4 5G 128GB', NULL, '2023-08-01', N'Samsung Galaxy Z Flip4 128GB đã chính thức ra mắt thị trường công nghệ, đánh dấu sự trở lại của Samsung trên con đường định hướng người dùng về sự tiện lợi trên những chiếc điện thoại gập. Với độ bền được gia tăng cùng kiểu thiết kế đẹp mắt giúp Flip4 trở thành một trong những tâm điểm sáng giá cho nửa cuối năm 2022.', N'samsung-galaxy-flip4-glr-tim-1.jpg', N'samsung-galaxy-flip-den-1.jpg', N'samsung-galaxy-z-flip4-note-1-1.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Flip4 5G 256GB', NULL, '2023-08-01', N'Samsung Galaxy Z Flip4 256GB đã chính thức ra mắt thị trường công nghệ, đánh dấu sự trở lại của Samsung trên con đường định hướng người dùng về sự tiện lợi trên những chiếc điện thoại gập. Với độ bền được gia tăng cùng kiểu thiết kế đẹp mắt giúp Flip4 trở thành một trong những tâm điểm sáng giá cho nửa cuối năm 2022.', N'samsung-galaxy-flip4-glr-tim-1.jpg', N'samsung-galaxy-flip-den-1.jpg', N'samsung-galaxy-z-flip4-note-1-1.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Flip4 5G 512GB', NULL, '2023-08-01', N'Samsung Galaxy Z Flip4 512GB đã chính thức ra mắt thị trường công nghệ, đánh dấu sự trở lại của Samsung trên con đường định hướng người dùng về sự tiện lợi trên những chiếc điện thoại gập. Với độ bền được gia tăng cùng kiểu thiết kế đẹp mắt giúp Flip4 trở thành một trong những tâm điểm sáng giá cho nửa cuối năm 2022.', N'samsung-galaxy-flip4-glr-tim-1.jpg', N'samsung-galaxy-flip-den-1.jpg', N'samsung-galaxy-z-flip4-note-1-1.jpg', 10, null, null, null, 0, 1, 0),
(5, 5, 5, null, N'Điện thoại Xiaomi 12 5G', NULL, '2023-08-01', N'Điện thoại Xiaomi đang dần khẳng định chỗ đứng của mình trong phân khúc flagship bằng việc ra mắt Xiaomi 12 với bộ thông số ấn tượng, máy có một thiết kế gọn gàng, hiệu năng mạnh mẽ, màn hình hiển thị chi tiết cùng khả năng chụp ảnh sắc nét nhờ trang bị ống kính đến từ Sony.', N'xiaomi-mi-12-1-1.jpg', N'xiaomi-mi-12-1.jpg', N'xiaomi-mi-12-note.jpg', 10, null, null, null, 0, 1, 0),
(5, 5, 5, null, N'Điện thoại Xiaomi Redmi Note 12S', NULL, '2023-08-01', N'Xiaomi Redmi Note 12S sẽ là chiếc điện thoại tiếp theo được nhà Xiaomi tung ra thị trường Việt Nam trong thời gian tới (05/2023). Điện thoại sở hữu một lối thiết kế hiện đại, màn hình hiển thị chi tiết đi cùng với đó là một hiệu năng mượt mà xử lý tốt các tác vụ.', N'xiaomi-redmi-note-12s-1-1.jpg', N'xiaomi-redmi-note-12s-xanh-1.jpg', N'xiaomi-redmi-note-12s-note.jpg', 10, null, null, null, 0, 1, 0),
(5, 5, 5, null, N'Điện thoại Xiaomi Redmi Note 12 Pro 128GB', NULL, '2023-08-01', N'Xiaomi Redmi Note 12 Pro 4G tiếp tục sẽ là mẫu điện thoại tầm trung được nhà Xiaomi giới thiệu đến thị trường Việt Nam trong năm 2023, máy nổi bật với camera 108 MP chất lượng, thiết kế viền mỏng cùng hiệu năng đột phá nhờ trang bị chip Snapdragon 732G.', N'xiami-redmi-12-pro-xam-1.jpg', N'xiaomi-redmi-12-pro-4g-xanh-duong-1.jpg', N'xiaomi-redmi-12-note-2.jpg', 10, null, null, null, 0, 1, 0),
(6, 6, 6, 3, N'Pin sạc dự phòng Polymer 10000mAh Type C 15W AVA+ JP399', NULL, '2023-08-01', N'Pin sạc dự phòng Polymer 10000mAh Type C 15W AVA+ JP399 mang đến cho người dùng 1 thiết kế nhỏ gọn, trang bị gam màu sang trọng và kiểu dáng tối giản, dung lượng 10000mAh và hiệu suất 64%, pin sạc dự phòng cung cấp pin cho thiết bị tối ưu.', N'pin-sac-du-phong-polymer-10000mah-type-c-15w-ava-jp399-xanh-1-1.jpg', N'pin-sac-du-phong-polymer-10000mah-type-c-15w-ava-jp399-hong-1.jpg', N'pin-sac-du-phong-polymer-10000mah-type-c-15w-ava-jp399-hong-12.jpg', 10, null, null, null, 0, 1, 0),
(6, 6, 6, 3, N'Pin sạc dự phòng Polymer 10000mAh 12W AVA+ JP299', NULL, '2023-08-01', N'Pin sạc dự phòng Polymer 10000mAh 12W AVA+ JP299 mang đến cho khách hàng 1 thiết kế đẹp mắt, nhờ sở hữu gam màu sang trọng và kiểu dáng tối giản. Sở hữu dung lượng 10000mAh và hiệu suất 64%, pin sạc dự phòng cung cấp năng lượng cho thiết bị tối ưu.', N'pin-sac-du-phong-polymer-10000mah-ava-jp299-den-1.jpg', N'pin-sac-du-phong-polymer-10000mah-ava-jp299-trang-1.jpg', N'pin-sac-du-phong-polymer-10000mah-ava-jp299-trang-8.jpg', 10, null, null, null, 0, 1, 0),
(6, 6, 6, 3, N'Pin sạc dự phòng Polymer 10000mAh Type C 10W AVA+ PB100S', NULL, '2023-08-01', N'Sạc điện thoại của bạn nhiều lần với dung lượng sạc dự phòng 10Pin sạc dự phòng Polymer 10000mAh 12W AVA+ JP299 mang đến cho khách hàng 1 thiết kế đẹp mắt, nhờ sở hữu gam màu sang trọng và kiểu dáng tối giản. Sở hữu dung lượng 10000 mAh và hiệu suất 64%, pin sạc dự phòng cung cấp năng lượng cho thiết bị tối ưu.000 mAh', N'pin-polymer-10000mah-type-c-ava-pb100s-trang-3.jpg', N'pin-polymer-10000mah-type-c-ava-pb100s-den-3.jpg', N'pin-polymer-10000mah-type-c-ava-pb100s-den-13-1.jpg', 10, null, null, null, 0, 1, 0),
(7, 7, 7, 4, N'Tai nghe Bluetooth True Wireless HAVIT TW945', NULL, '2023-08-01', N'Tai nghe Bluetooth True Wireless HAVIT TW945 mang đến thiết kế sang trọng với kiểu dáng tối giản và màu sắc đa dạng, âm thanh đầy đủ và rõ ràng, tích hợp nhiều tính năng và tiện ích khác, phục vụ tốt nhu cầu sử dụng cơ bản hàng ngày của đa số người dùng.', N'tai-nghe-bluetooth-true-wireless-havit-tw945-den-2.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw945-cam-2.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw945-tim-note.jpg', 10, null, null, null, 0, 1, 0),
(7, 7, 7, 4, N'Tai nghe Bluetooth True Wireless HAVIT TW971', NULL, '2023-08-01', N'Tai nghe Bluetooth True Wireless HAVIT TW971 mang đến một thiết kế trong suốt, âm thanh rõ ràng và sống động, cùng với nhiều công nghệ tiện ích được tích hợp, hứa hẹn đáp ứng nhu cầu nghe nhạc hay gọi thoại cơ bản hằng ngày cho người dùng.', N'tai-nghe-bluetooth-true-wireless-havit-tw971-11.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw971-1.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw971-7.jpg', 10, null, null, null, 0, 1, 0),
(7, 7, 7, 4, N'Tai nghe Bluetooth True Wireless HAVIT TW967', NULL, '2023-08-01', N'Tai nghe Bluetooth True Wireless HAVIT TW967 được thiết kế với phong cách năng động, màu sắc đẹp mắt, âm thanh sống động, trang bị kết nối không dây gọn gàng, mang đến cho bạn những trải nghiệm tối ưu.', N'tai-nghe-bluetooth-true-wireless-havit-tw967-trang-2.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw967-den-1.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw967-notecopy.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 128GB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 256GB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 512GB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 14 Pro Max 1TB', NULL, '2023-08-01', N'iPhone 14 Pro Max một siêu phẩm trong giới smartphone được nhà Táo tung ra thị trường vào tháng 09/2022. Máy trang bị con chip Apple A16 Bionic vô cùng mạnh mẽ, đi kèm theo đó là thiết kế hình màn hình mới, hứa hẹn mang lại những trải nghiệm đầy mới mẻ cho người dùng iPhone.', N'iphone-14-pro-max-purple-1.jpg', N'iphone-14-pro-max-vang-1.jpg', N'iphone-14-pro-max-note.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 13 Pro Max 123GB', NULL, '2023-08-01', N'Điện thoại iPhone 13 Pro Max 128 GB - siêu phẩm được mong chờ nhất ở nửa cuối năm 2021 đến từ Apple. Máy có thiết kế không mấy đột phá khi so với người tiền nhiệm, bên trong đây vẫn là một sản phẩm có màn hình siêu đẹp, tần số quét được nâng cấp lên 120 Hz mượt mà, cảm biến camera có kích thước lớn hơn, cùng hiệu năng mạnh mẽ với sức mạnh đến từ Apple A15 Bionic, sẵn sàng cùng bạn chinh phục mọi thử thách.', N'iphone-13-pro-max-1-1.jpg', N'iphone-13-pro-max-1.jpg', N'iphone-13-pro-max-n-2.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 13 Pro Max 256GB', NULL, '2023-08-01', N'Điện thoại iPhone 13 Pro Max 256 GB - siêu phẩm được mong chờ nhất ở nửa cuối năm 2021 đến từ Apple. Máy có thiết kế không mấy đột phá khi so với người tiền nhiệm, bên trong đây vẫn là một sản phẩm có màn hình siêu đẹp, tần số quét được nâng cấp lên 120 Hz mượt mà, cảm biến camera có kích thước lớn hơn, cùng hiệu năng mạnh mẽ với sức mạnh đến từ Apple A15 Bionic, sẵn sàng cùng bạn chinh phục mọi thử thách.', N'iphone-13-pro-max-1-1.jpg', N'iphone-13-pro-max-1.jpg', N'iphone-13-pro-max-n-2.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 13 Pro Max 512GB', NULL, '2023-08-01', N'Điện thoại iPhone 13 Pro Max 512 GB - siêu phẩm được mong chờ nhất ở nửa cuối năm 2021 đến từ Apple. Máy có thiết kế không mấy đột phá khi so với người tiền nhiệm, bên trong đây vẫn là một sản phẩm có màn hình siêu đẹp, tần số quét được nâng cấp lên 120 Hz mượt mà, cảm biến camera có kích thước lớn hơn, cùng hiệu năng mạnh mẽ với sức mạnh đến từ Apple A15 Bionic, sẵn sàng cùng bạn chinh phục mọi thử thách.', N'iphone-13-pro-max-1-1.jpg', N'iphone-13-pro-max-1.jpg', N'iphone-13-pro-max-n-2.jpg', 10, null, null, null, 0, 1, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 12 Pro Max 128GB', NULL, '2023-08-01', N'iPhone 12 Pro Max 128 GB một siêu phẩm smartphone đến từ Apple. Máy có một hiệu năng hoàn toàn mạnh mẽ đáp ứng tốt nhiều nhu cầu đến từ người dùng và mang trong mình một thiết kế đầy vuông vức, sang trọng.', N'iphone-12-pro-max-512gb-1-org.jpg', N'iphone-12-pro-max-512gb-bac-1-org.jpg', N'iphone-12-pro-max-512gb-note-2.jpg', 10, null, null, null, 0, 0, 0),
(1, 1, 1, 1, N'Điện thoại iPhone 12 Pro Max 256GB', NULL, '2023-08-01', N'iPhone 12 Pro Max 256 GB một siêu phẩm smartphone đến từ Apple. Máy có một hiệu năng hoàn toàn mạnh mẽ đáp ứng tốt nhiều nhu cầu đến từ người dùng và mang trong mình một thiết kế đầy vuông vức, sang trọng.', N'iphone-12-pro-max-512gb-1-org.jpg', N'iphone-12-pro-max-512gb-bac-1-org.jpg', N'iphone-12-pro-max-512gb-note-2.jpg', 10, null, null, null, 0, 0, 0),
(2, 2, 2, null, N'Điện thoại OPPO Find N2 Flip 5G', NULL, '2023-08-01', N'OPPO Find N2 Flip 5G - chiếc điện thoại gập đầu tiên của OPPO đã được giới thiệu chính thức tại Việt Nam vào tháng 03/2023. Sở hữu cấu hình mạnh mẽ cùng thiết kế siêu nhỏ gọn giúp tối ưu kích thước, chiếc điện thoại sẽ cùng bạn nổi bật trong mọi không gian với vẻ ngoài đầy cá tính.', N'oppo-n2-flip-tim-1-1.jpg', N'oppo-n2-flip-den-1.jpg', N'oppo-n2-flip-tim-note.jpg', 10, null, null, null, 0, 1, 0),
(2, 2, 2, null, N'Điện thoại OPPO Reno10 Pro 5G', NULL, '2023-08-01', N'OPPO Reno10 Pro 5G là một trong những sản phẩm của OPPO được ra mắt trong 2023. Với thiết kế đẹp mắt, màn hình lớn và hiệu năng mạnh mẽ, Reno10 Pro chắc chắn sẽ là lựa chọn đáng cân nhắc dành cho những ai đang tìm kiếm chiếc máy tầm trung để phục vụ tốt mọi nhu cầu.', N'oppo-reno10-pro-xam-1-1.jpg', N'oppo-reno10-pro-tim-1-2.jpg', N'oppo-reno10-pro-note.jpg', 10, null, null, null, 0, 1, 0),
(2, 2, 2, null, N'Điện thoại OPPO A77s', NULL, '2023-08-01', N'OPPO vừa cho ra mắt mẫu điện thoại tầm trung mới với tên gọi OPPO A77s, máy sở hữu màn hình lớn, thiết kế đẹp mắt, hiệu năng ổn định cùng khả năng mở rộng RAM lên đến 8 GB vô cùng nổi bật trong phân khúc.', N'oppo-a77s-den-1.jpg', N'oppo-a77s-xanh-1.jpg', N'oppo-a77s-note-2.jpg', 10, null, null, null, 0, 1, 0),
(3, 3, 3, null, N'Điện thoại vivo V25 Pro 5G', NULL, '2023-08-01', N'VIVO V25 Pro 5G vừa được ra mắt với một mức giá bán cực kỳ hấp dẫn, thế mạnh của máy thuộc về phần hiệu năng nhờ trang bị con chip MediaTek Dimensity 1300 và cụm camera sắc nét 64 MP, hứa hẹn mang lại cho người dùng những trải nghiệm ổn định trong suốt quá trình sử dụng.', N'vivo-v25-pro-5g-sld-xanh-1.jpg', N'vivo-v25-pro-5g-den-1.jpg', N'vivo-v25-pro-5g-note-2.jpg', 10, null, null, null, 0, 1, 0),
(3, 3, 3, null, N'Điện thoại vivo Y02A', NULL, '2023-08-01', N'VIVO Y02A mẫu điện thoại được nhà vivo cho ra mắt hướng đến nhóm người dùng yêu thích sự đơn giản trong thiết kế, hiệu năng tốt có thể xử lý các tác vụ thường ngày và một viên pin lớn đáp ứng được nhu cầu sử dụng lâu dài.', N'vivo-y02-den-1.jpg', N'vivo-y02-tim-1.jpg', N'vivo-y02-note.jpg', 10, null, null, null, 0, 1, 0),
(3, 3, 3, null, N'Điện thoại vivo V27e', NULL, '2023-08-01', N'vivo V27e một trong những chiếc điện thoại tầm trung nổi bật của vivo trong năm 2023. Với thiết kế độc đáo và khả năng chụp ảnh - quay phim ấn tượng, vì thế máy đã mang lại cho vivo nhiều niềm tự hào khi ra mắt tại thị trường Việt Nam, hứa hẹn mang đến trải nghiệm tuyệt vời đến với người dùng.', N'vivo-v27e-tim-1-1.jpg', N'vivo-v27e-den-1.jpg', N'vivo-v27e-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Fold5 5G 256GB ', NULL, '2023-08-01', N'Samsung Galaxy Z Fold5 là mẫu điện thoại cao cấp được ra mắt vào tháng 07/2023 với nhiều điểm đáng chú ý như thiết kế gập độc đáo, hiệu năng mạnh mẽ cùng camera quay chụp tốt, điều này giúp cho máy thu hút được nhiều sự quan tâm của đông đảo người dùng yêu công nghệ hiện nay.', N'samsung-galaxy-zfold5-xanh-256gb-1-1.jpg', N'samsung-galaxy-zfold5-den-256gb-1.jpg', N'samsung-galaxy-zfold5-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Fold5 5G 512GB ', NULL, '2023-08-01', N'Samsung Galaxy Z Fold5 là mẫu điện thoại cao cấp được ra mắt vào tháng 07/2023 với nhiều điểm đáng chú ý như thiết kế gập độc đáo, hiệu năng mạnh mẽ cùng camera quay chụp tốt, điều này giúp cho máy thu hút được nhiều sự quan tâm của đông đảo người dùng yêu công nghệ hiện nay.', N'samsung-galaxy-zfold5-xanh-256gb-1-1.jpg', N'samsung-galaxy-zfold5-den-256gb-1.jpg', N'samsung-galaxy-zfold5-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Fold5 5G 1TB', NULL, '2023-08-01', N'Samsung Galaxy Z Fold5 là mẫu điện thoại cao cấp được ra mắt vào tháng 07/2023 với nhiều điểm đáng chú ý như thiết kế gập độc đáo, hiệu năng mạnh mẽ cùng camera quay chụp tốt, điều này giúp cho máy thu hút được nhiều sự quan tâm của đông đảo người dùng yêu công nghệ hiện nay.', N'samsung-galaxy-zfold5-xanh-256gb-1-1.jpg', N'samsung-galaxy-zfold5-den-256gb-1.jpg', N'samsung-galaxy-zfold5-note.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Flip4 5G 128GB', NULL, '2023-08-01', N'Samsung Galaxy Z Flip4 128GB đã chính thức ra mắt thị trường công nghệ, đánh dấu sự trở lại của Samsung trên con đường định hướng người dùng về sự tiện lợi trên những chiếc điện thoại gập. Với độ bền được gia tăng cùng kiểu thiết kế đẹp mắt giúp Flip4 trở thành một trong những tâm điểm sáng giá cho nửa cuối năm 2022.', N'samsung-galaxy-flip4-glr-tim-1.jpg', N'samsung-galaxy-flip-den-1.jpg', N'samsung-galaxy-z-flip4-note-1-1.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Flip4 5G 256GB', NULL, '2023-08-01', N'Samsung Galaxy Z Flip4 256GB đã chính thức ra mắt thị trường công nghệ, đánh dấu sự trở lại của Samsung trên con đường định hướng người dùng về sự tiện lợi trên những chiếc điện thoại gập. Với độ bền được gia tăng cùng kiểu thiết kế đẹp mắt giúp Flip4 trở thành một trong những tâm điểm sáng giá cho nửa cuối năm 2022.', N'samsung-galaxy-flip4-glr-tim-1.jpg', N'samsung-galaxy-flip-den-1.jpg', N'samsung-galaxy-z-flip4-note-1-1.jpg', 10, null, null, null, 0, 1, 0),
(4, 4, 4, 2, N'Điện thoại Samsung Galaxy Z Flip4 5G 512GB', NULL, '2023-08-01', N'Samsung Galaxy Z Flip4 512GB đã chính thức ra mắt thị trường công nghệ, đánh dấu sự trở lại của Samsung trên con đường định hướng người dùng về sự tiện lợi trên những chiếc điện thoại gập. Với độ bền được gia tăng cùng kiểu thiết kế đẹp mắt giúp Flip4 trở thành một trong những tâm điểm sáng giá cho nửa cuối năm 2022.', N'samsung-galaxy-flip4-glr-tim-1.jpg', N'samsung-galaxy-flip-den-1.jpg', N'samsung-galaxy-z-flip4-note-1-1.jpg', 10, null, null, null, 0, 1, 0),
(5, 5, 5, null, N'Điện thoại Xiaomi 12 5G', NULL, '2023-08-01', N'Điện thoại Xiaomi đang dần khẳng định chỗ đứng của mình trong phân khúc flagship bằng việc ra mắt Xiaomi 12 với bộ thông số ấn tượng, máy có một thiết kế gọn gàng, hiệu năng mạnh mẽ, màn hình hiển thị chi tiết cùng khả năng chụp ảnh sắc nét nhờ trang bị ống kính đến từ Sony.', N'xiaomi-mi-12-1-1.jpg', N'xiaomi-mi-12-1.jpg', N'xiaomi-mi-12-note.jpg', 10, null, null, null, 0, 1, 0),
(5, 5, 5, null, N'Điện thoại Xiaomi Redmi Note 12S', NULL, '2023-08-01', N'Xiaomi Redmi Note 12S sẽ là chiếc điện thoại tiếp theo được nhà Xiaomi tung ra thị trường Việt Nam trong thời gian tới (05/2023). Điện thoại sở hữu một lối thiết kế hiện đại, màn hình hiển thị chi tiết đi cùng với đó là một hiệu năng mượt mà xử lý tốt các tác vụ.', N'xiaomi-redmi-note-12s-1-1.jpg', N'xiaomi-redmi-note-12s-xanh-1.jpg', N'xiaomi-redmi-note-12s-note.jpg', 10, null, null, null, 0, 1, 0),
(5, 5, 5, null, N'Điện thoại Xiaomi Redmi Note 12 Pro 128GB', NULL, '2023-08-01', N'Xiaomi Redmi Note 12 Pro 4G tiếp tục sẽ là mẫu điện thoại tầm trung được nhà Xiaomi giới thiệu đến thị trường Việt Nam trong năm 2023, máy nổi bật với camera 108 MP chất lượng, thiết kế viền mỏng cùng hiệu năng đột phá nhờ trang bị chip Snapdragon 732G.', N'xiami-redmi-12-pro-xam-1.jpg', N'xiaomi-redmi-12-pro-4g-xanh-duong-1.jpg', N'xiaomi-redmi-12-note-2.jpg', 10, null, null, null, 0, 1, 0),
(6, 6, 6, 3, N'Pin sạc dự phòng Polymer 10000mAh Type C 15W AVA+ JP399', NULL, '2023-08-01', N'Pin sạc dự phòng Polymer 10000mAh Type C 15W AVA+ JP399 mang đến cho người dùng 1 thiết kế nhỏ gọn, trang bị gam màu sang trọng và kiểu dáng tối giản, dung lượng 10000mAh và hiệu suất 64%, pin sạc dự phòng cung cấp pin cho thiết bị tối ưu.', N'pin-sac-du-phong-polymer-10000mah-type-c-15w-ava-jp399-xanh-1-1.jpg', N'pin-sac-du-phong-polymer-10000mah-type-c-15w-ava-jp399-hong-1.jpg', N'pin-sac-du-phong-polymer-10000mah-type-c-15w-ava-jp399-hong-12.jpg', 10, null, null, null, 0, 1, 0),
(6, 6, 6, 3, N'Pin sạc dự phòng Polymer 10000mAh 12W AVA+ JP299', NULL, '2023-08-01', N'Pin sạc dự phòng Polymer 10000mAh 12W AVA+ JP299 mang đến cho khách hàng 1 thiết kế đẹp mắt, nhờ sở hữu gam màu sang trọng và kiểu dáng tối giản. Sở hữu dung lượng 10000mAh và hiệu suất 64%, pin sạc dự phòng cung cấp năng lượng cho thiết bị tối ưu.', N'pin-sac-du-phong-polymer-10000mah-ava-jp299-den-1.jpg', N'pin-sac-du-phong-polymer-10000mah-ava-jp299-trang-1.jpg', N'pin-sac-du-phong-polymer-10000mah-ava-jp299-trang-8.jpg', 10, null, null, null, 0, 1, 0),
(6, 6, 6, 3, N'Pin sạc dự phòng Polymer 10000mAh Type C 10W AVA+ PB100S', NULL, '2023-08-01', N'Sạc điện thoại của bạn nhiều lần với dung lượng sạc dự phòng 10Pin sạc dự phòng Polymer 10000mAh 12W AVA+ JP299 mang đến cho khách hàng 1 thiết kế đẹp mắt, nhờ sở hữu gam màu sang trọng và kiểu dáng tối giản. Sở hữu dung lượng 10000 mAh và hiệu suất 64%, pin sạc dự phòng cung cấp năng lượng cho thiết bị tối ưu.000 mAh', N'pin-polymer-10000mah-type-c-ava-pb100s-trang-3.jpg', N'pin-polymer-10000mah-type-c-ava-pb100s-den-3.jpg', N'pin-polymer-10000mah-type-c-ava-pb100s-den-13-1.jpg', 10, null, null, null, 0, 1, 0),
(7, 7, 7, 4, N'Tai nghe Bluetooth True Wireless HAVIT TW945', NULL, '2023-08-01', N'Tai nghe Bluetooth True Wireless HAVIT TW945 mang đến thiết kế sang trọng với kiểu dáng tối giản và màu sắc đa dạng, âm thanh đầy đủ và rõ ràng, tích hợp nhiều tính năng và tiện ích khác, phục vụ tốt nhu cầu sử dụng cơ bản hàng ngày của đa số người dùng.', N'tai-nghe-bluetooth-true-wireless-havit-tw945-den-2.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw945-cam-2.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw945-tim-note.jpg', 10, null, null, null, 0, 1, 0),
(7, 7, 7, 4, N'Tai nghe Bluetooth True Wireless HAVIT TW971', NULL, '2023-08-01', N'Tai nghe Bluetooth True Wireless HAVIT TW971 mang đến một thiết kế trong suốt, âm thanh rõ ràng và sống động, cùng với nhiều công nghệ tiện ích được tích hợp, hứa hẹn đáp ứng nhu cầu nghe nhạc hay gọi thoại cơ bản hằng ngày cho người dùng.', N'tai-nghe-bluetooth-true-wireless-havit-tw971-11.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw971-1.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw971-7.jpg', 10, null, null, null, 0, 1, 0),
(7, 7, 7, 4, N'Tai nghe Bluetooth True Wireless HAVIT TW967', NULL, '2023-08-01', N'Tai nghe Bluetooth True Wireless HAVIT TW967 được thiết kế với phong cách năng động, màu sắc đẹp mắt, âm thanh sống động, trang bị kết nối không dây gọn gàng, mang đến cho bạn những trải nghiệm tối ưu.', N'tai-nghe-bluetooth-true-wireless-havit-tw967-trang-2.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw967-den-1.jpg', N'tai-nghe-bluetooth-true-wireless-havit-tw967-notecopy.jpg', 10, null, null, null, 0, 1, 0)
GO
--INSERT CHITIETSANPHAM
--MaChiTietSP INT IDENTITY NOT NULL,
--MaSP INT NOT NULL,

--KICHTHUOCMANHINH NVARCHAR(50) NULL,
--CONGNGHEMANHINH NVARCHAR(100) NULL,
--DOPHANGIAI NVARCHAR(50) NULL,
--TINHNANGMANGHINH NVARCHAR(100) NULL,
--TANSOQUET NVARCHAR(10) NULL,
--CAMERASAU NVARCHAR(255) NULL, 
--QUAYPHIM NVARCHAR(255) NULL,
--CAMERATRUOC NVARCHAR(255) NULL,
--TINHNANGCAMERA NVARCHAR(255) NULL,
--HEDIEUHANH NVARCHAR(50) NULL,
--CHIP NVARCHAR(100) NULL,
--TOCDOCPU NVARCHAR(20) NULL,
--CHIPDOHOA NVARCHAR(50) NULL,
--RAM NVARCHAR(20) NULL,
--DUNGLUONG NVARCHAR(20) NULL,
--MANGDIDONG NVARCHAR(20) NULL,
--SIM NVARCHAR(100) NULL,
--WIFI NVARCHAR(50) NULL,
--CONGKETNOI NVARCHAR(50) NULL,
--DUNGLUONGPIN NVARCHAR(20) NULL,
--LOAIPIN NVARCHAR(20) NULL,
--HOTROSAC NVARCHAR(20) NULL,
--BAOMAT NVARCHAR(50) NULL,
--TINHNANGDACBIET NVARCHAR(255) NULL,
--KHANGNUOC NVARCHAR(50) NULL,
--THIETKE NVARCHAR(50) NULL,
--CHATLIEU NVARCHAR(255) NULL,
--KICHTHUOC NVARCHAR(255) NULL,
--RAMAT DATE NULL

INSERT INTO CHITIETSANPHAM(MaSP, KICHTHUOCMANHINH, CONGNGHEMANHINH, DOPHANGIAI, TINHNANGMANGHINH, TANSOQUET, CAMERASAU, QUAYPHIM, CAMERATRUOC, TINHNANGCAMERA, HEDIEUHANH, CHIP, TOCDOCPU, CHIPDOHOA, RAM, DUNGLUONG, MANGDIDONG, SIM, WIFI, CONGKETNOI, DUNGLUONGPIN, LOAIPIN, HOTROSAC, BAOMAT, TINHNANGDACBIET, KHANGNUOC, THIETKE, CHATLIEU, KICHTHUOC, BAOHANH, RAMAT) VALUES
(1, N'6.7"', N'OLED', N'Super Retina XDR (1290 x 2796 Pixels)', N'Kính cường lực Ceramic Shield', N'120 Hz', N'Chính 48 MP & Phụ 12 MP, 12 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps', N'12 MP', N'Chế độ hành động (Action Mode), Dolby Vision HDR, Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Cinematic, Quay chậm (Slow Motion), Xóa phông, Deep Fusion, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Zoom quang học Siêu cận (Macro), Live Photo, Bộ lọc màu, Smart HDR 4', N'iOS 16', N'Apple A16 Bionic 6 nhân', N'3.46 GHz', N'Apple GPU 5 nhân', N'6 GB', N'128GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Lightning', N'4323 mAh', N'Li-Ion', N'20 W', N'Mở khoá khuôn mặt Face ID', N'Phát hiện va chạm (Crash Detection), Màn hình luôn hiển thị AOD, Chạm 2 lần sáng màn hình, Apple Pay, Loa kép', N'IP68', N'Nguyên khối', N'Khung thép không gỉ & Mặt lưng kính cường lực', N'Dài 160.7 mm - Ngang 77.6 mm - Dày 7.85 mm - Nặng 240 g',12, '2022-09-01'),
(2, N'6.7"', N'OLED', N'Super Retina XDR (1290 x 2796 Pixels)', N'Kính cường lực Ceramic Shield', N'120 Hz', N'Chính 48 MP & Phụ 12 MP, 12 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps', N'12 MP', N'Chế độ hành động (Action Mode), Dolby Vision HDR, Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Cinematic, Quay chậm (Slow Motion), Xóa phông, Deep Fusion, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Zoom quang học Siêu cận (Macro), Live Photo, Bộ lọc màu, Smart HDR 4', N'iOS 16', N'Apple A16 Bionic 6 nhân', N'3.46 GHz', N'Apple GPU 5 nhân', N'6 GB', N'256GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Lightning', N'4323 mAh', N'Li-Ion', N'20 W', N'Mở khoá khuôn mặt Face ID', N'Phát hiện va chạm (Crash Detection), Màn hình luôn hiển thị AOD, Chạm 2 lần sáng màn hình, Apple Pay, Loa kép', N'IP68', N'Nguyên khối', N'Khung thép không gỉ & Mặt lưng kính cường lực', N'Dài 160.7 mm - Ngang 77.6 mm - Dày 7.85 mm - Nặng 240 g', 12, '2022-09-01'),
(3, N'6.7"', N'OLED', N'Super Retina XDR (1290 x 2796 Pixels)', N'Kính cường lực Ceramic Shield', N'120 Hz', N'Chính 48 MP & Phụ 12 MP, 12 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps', N'12 MP', N'Chế độ hành động (Action Mode), Dolby Vision HDR, Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Cinematic, Quay chậm (Slow Motion), Xóa phông, Deep Fusion, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Zoom quang học Siêu cận (Macro), Live Photo, Bộ lọc màu, Smart HDR 4', N'iOS 16', N'Apple A16 Bionic 6 nhân', N'3.46 GHz', N'Apple GPU 5 nhân', N'6 GB', N'512GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Lightning', N'4323 mAh', N'Li-Ion', N'20 W', N'Mở khoá khuôn mặt Face ID', N'Phát hiện va chạm (Crash Detection), Màn hình luôn hiển thị AOD, Chạm 2 lần sáng màn hình, Apple Pay, Loa kép', N'IP68', N'Nguyên khối', N'Khung thép không gỉ & Mặt lưng kính cường lực', N'Dài 160.7 mm - Ngang 77.6 mm - Dày 7.85 mm - Nặng 240 g', 12, '2022-09-01'),
(4, N'6.7"', N'OLED', N'Super Retina XDR (1290 x 2796 Pixels)', N'Kính cường lực Ceramic Shield', N'120 Hz', N'Chính 48 MP & Phụ 12 MP, 12 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps', N'12 MP', N'Chế độ hành động (Action Mode), Dolby Vision HDR, Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Cinematic, Quay chậm (Slow Motion), Xóa phông, Deep Fusion, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Zoom quang học Siêu cận (Macro), Live Photo, Bộ lọc màu, Smart HDR 4', N'iOS 16', N'Apple A16 Bionic 6 nhân', N'3.46 GHz', N'Apple GPU 5 nhân', N'6 GB', N'1TB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Lightning', N'4323 mAh', N'Li-Ion', N'20 W', N'Mở khoá khuôn mặt Face ID', N'Phát hiện va chạm (Crash Detection), Màn hình luôn hiển thị AOD, Chạm 2 lần sáng màn hình, Apple Pay, Loa kép', N'IP68', N'Nguyên khối', N'Khung thép không gỉ & Mặt lưng kính cường lực', N'Dài 160.7 mm - Ngang 77.6 mm - Dày 7.85 mm - Nặng 240 g', 12, '2022-09-01'),
(5, N'6.7"', N'OLED', N'Super Retina XDR (1284 x 2778 Pixels)', N'Kính cường lực Ceramic Shield', N'120 Hz', N'3 camera 12 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps', N'12 MP', N'Deep Fusion, Toàn cảnh (Panorama), Chống rung quang học (OIS), Tự động lấy nét (AF), Nhận diện khuôn mặt, Ảnh Raw, Ban đêm (Night Mode), Chạm lấy nét, Zoom quang học, Siêu cận (Macro), Smart HDR 4', N'iOS 15', N'Apple A15 Bionic 6 nhân', N'3.22 GHz', N'Apple GPU 5 nhân', N'6 GB', N'128GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Lightning', N'4352 mAh', N'Li-Ion', N'20 W', N'Mở khoá khuôn mặt Face ID', N'Phát hiện va chạm (Crash Detection), Màn hình luôn hiển thị AOD, Chạm 2 lần sáng màn hình, Apple Pay, Loa kép', N'IP68', N'Nguyên khối', N'Khung thép không gỉ & Mặt lưng kính cường lực', N'Dài 160.8 mm - Ngang 78.1 mm - Dày 7.65 mm - Nặng 240 g', 12, '2021-09-01'),
(6, N'6.7"', N'OLED', N'Super Retina XDR (1284 x 2778 Pixels)', N'Kính cường lực Ceramic Shield', N'120 Hz', N'3 camera 12 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps', N'12 MP', N'Deep Fusion, Toàn cảnh (Panorama), Chống rung quang học (OIS), Tự động lấy nét (AF), Nhận diện khuôn mặt, Ảnh Raw, Ban đêm (Night Mode), Chạm lấy nét, Zoom quang học, Siêu cận (Macro), Smart HDR 4', N'iOS 15', N'Apple A15 Bionic 6 nhân', N'3.22 GHz', N'Apple GPU 5 nhân', N'6 GB', N'256GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Lightning', N'4352 mAh', N'Li-Ion', N'20 W', N'Mở khoá khuôn mặt Face ID', N'Phát hiện va chạm (Crash Detection), Màn hình luôn hiển thị AOD, Chạm 2 lần sáng màn hình, Apple Pay, Loa kép', N'IP68', N'Nguyên khối', N'Khung thép không gỉ & Mặt lưng kính cường lực', N'Dài 160.8 mm - Ngang 78.1 mm - Dày 7.65 mm - Nặng 240 g', 12, '2021-09-01'),
(7, N'6.7"', N'OLED', N'Super Retina XDR (1284 x 2778 Pixels)', N'Kính cường lực Ceramic Shield', N'120 Hz', N'3 camera 12 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps', N'12 MP', N'Deep Fusion, Toàn cảnh (Panorama), Chống rung quang học (OIS), Tự động lấy nét (AF), Nhận diện khuôn mặt, Ảnh Raw, Ban đêm (Night Mode), Chạm lấy nét, Zoom quang học, Siêu cận (Macro), Smart HDR 4', N'iOS 15', N'Apple A15 Bionic 6 nhân', N'3.22 GHz', N'Apple GPU 5 nhân', N'6 GB', N'512GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Lightning', N'4352 mAh', N'Li-Ion', N'20 W', N'Mở khoá khuôn mặt Face ID', N'Phát hiện va chạm (Crash Detection), Màn hình luôn hiển thị AOD, Chạm 2 lần sáng màn hình, Apple Pay, Loa kép', N'IP68', N'Nguyên khối', N'Khung thép không gỉ & Mặt lưng kính cường lực', N'Dài 160.8 mm - Ngang 78.1 mm - Dày 7.65 mm - Nặng 240 g', 12, '2021-09-01'),
(8, N'6.7"', N'OLED', N'Super Retina XDR (1284 x 2778 Pixels)', N'Kính cường lực Ceramic Shield', N'60 Hz', N'3 camera 12 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps', N'12 MP', N'Deep Fusion, Toàn cảnh (Panorama), Chống rung quang học (OIS), Tự động lấy nét (AF), Nhận diện khuôn mặt, Ban đêm (Night Mode), Zoom quang học, Siêu cận (Macro), Smart HDR 4', N'iOS 15', N'Apple A14 Bionic 6 nhân', N'2 nhân 3.1 GHz & 4 nhân 1.8 GHz', N'Apple GPU 4 nhân', N'6 GB', N'128GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Lightning', N'3687 mAh', N'Li-Ion', N'20 W', N'Mở khoá khuôn mặt Face ID', N'Phát hiện va chạm (Crash Detection), Màn hình luôn hiển thị AOD, Chạm 2 lần sáng màn hình', N'IP68', N'Nguyên khối', N'Khung thép không gỉ & Mặt lưng kính cường lực', N'Dài 160.8 mm - Ngang 78.1 mm - Dày 7.4 mm - Nặng 228 g', 12, '2020-10-01'),
(9, N'6.7"', N'OLED', N'Super Retina XDR (1284 x 2778 Pixels)', N'Kính cường lực Ceramic Shield', N'60 Hz', N'3 camera 12 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps', N'12 MP', N'Deep Fusion, Toàn cảnh (Panorama), Chống rung quang học (OIS), Tự động lấy nét (AF), Nhận diện khuôn mặt, Ban đêm (Night Mode), Zoom quang học, Siêu cận (Macro), Smart HDR 4', N'iOS 15', N'Apple A14 Bionic 6 nhân', N'2 nhân 3.1 GHz & 4 nhân 1.8 GHz', N'Apple GPU 4 nhân', N'6 GB', N'256GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Lightning', N'3687 mAh', N'Li-Ion', N'20 W', N'Mở khoá khuôn mặt Face ID', N'Phát hiện va chạm (Crash Detection), Màn hình luôn hiển thị AOD, Chạm 2 lần sáng màn hình', N'IP68', N'Nguyên khối', N'Khung thép không gỉ & Mặt lưng kính cường lực', N'Dài 160.8 mm - Ngang 78.1 mm - Dày 7.4 mm - Nặng 228 g', 12, '2020-10-01'),
(10, N'Chính 6.8" & Phụ 3.26"', N'AMOLED', N'Chính: FHD+ (2520 x 1080 Pixels) & Phụ: (720 x 382 Pixels)', N'Kính siêu mỏng Ultra Thin Glass (UTG)', N'120 Hz & 60 Hz', N'Chính 50 MP & Phụ 8 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps', N'32 MP', N'Trôi nhanh thời gian (Time Lapse), Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Zoom quang học, Siêu độ phân giải, AI Camera, Làm đẹp, Nhãn dán (AR Stickers), Bộ lọc màu', N'Android 13', N'MediaTek Dimensity 9000+ 8 nhân', N'3.2 GHz', N'Mali-G710 MC10', N'8 GB', N'256GB', N'Hỗ trợ 5G', N'2 Nano SIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'4300 mAh', N'Li-Po', N'44 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Cử chỉ thông minh, Mở rộng bộ nhớ RAM, Ứng dụng kép (Nhân bản ứng dụng), Thu nhỏ màn hình sử dụng một tay, Đa cửa sổ (chia đôi màn hình), Chế độ trẻ em (Không gian trẻ em)', N'IPX4', N'Nguyên khối', N'Khung hợp kim & Mặt lưng kính cường lực Gorilla Glass 5', N'Dài 166.2 mm - Ngang 75.2 mm - Dày 7.45 mm - Nặng 191 g', 12, '2023-04-01'),
(11, N'6.7"', N'AMOLED', N'Full HD+ (1080 x 2412 Pixels)', N'Kính cường lực AGC DT-Star2', N'120 Hz', N'Chính 50 MP & Phụ 32 MP, 8 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@24fps, 4K 2160p@30fps', N'32 MP', N'Trôi nhanh thời gian (Time Lapse), Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Zoom quang học, Siêu độ phân giải, AI Camera, Làm đẹp, Nhãn dán (AR Stickers), Bộ lọc màu', N'Android 13', N'Snapdragon 778G 5G 8 nhân', N'2.4 GHz', N'Adreno 642L', N'12 GB', N'256GB', N'Hỗ trợ 5G', N'2 Nano SIM', N'Wi-Fi MIMO, Wi-Fi hotspot, Wi-Fi 6', N'Type-C', N'4600 mAh', N'Li-Po', N'80 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Cử chỉ thông minh, Mở rộng bộ nhớ RAM, Ứng dụng kép (Nhân bản ứng dụng), Thu nhỏ màn hình sử dụng một tay, Đa cửa sổ (chia đôi màn hình), Chế độ trẻ em (Không gian trẻ em)', N'IP54', N'Nguyên khối', N'Khung nhựa & Mặt lưng kính', N'Dài 162.3 mm - Ngang 74.2 mm - Dày 7.89 mm - Nặng 185 g', 12, '2023-08-01'),
(12, N'6.56"', N'IPS LCD', N'HD+ (720 x 1612 Pixels)', N'Kính cường lực Panda', N'90 Hz', N'Chính 50 MP & Phụ 2 MP', N'HD 720p@30fps, FullHD 1080p@30fps', N'8 MP', N'Trôi nhanh thời gian (Time Lapse), Xóa phông, Toàn cảnh (Panorama), Ban đêm (Night Mode), HDR, Zoom quang học, Siêu độ phân giải, Làm đẹp, Bộ lọc màu', N'Android 12', N'Snapdragon 680 8 nhân', N'2.4 GHz', N'Adreno 610', N'8 GB', N'128GB', N'Hỗ trợ 4G', N'2 Nano SIM', N'Wi-Fi 802.11 a/b/g/n/ac, Dual-band (2.4 GHz/5 GHz)', N'Type-C', N'5000 mAh', N'Li-Po', N'33 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Cử chỉ thông minh, Mở rộng bộ nhớ RAM, Ứng dụng kép (Nhân bản ứng dụng), Thu nhỏ màn hình sử dụng một tay, Đa cửa sổ (chia đôi màn hình), Chế độ trẻ em (Không gian trẻ em)', N'IPX4', N'Nguyên khối', N'Khung nhựa & Mặt lưng thuỷ tinh hữu cơ', N'Dài 163.74 mm - Ngang 75.03 mm - Dày 7.99 mm - Nặng 187 g', 12, '2022-10-01'),
(13, N'6.56"', N'AMOLED', N'Full HD+ (1080 x 2376 Pixels)', N'Kính cường lực Schott Xensation UP', N'120 Hz', N'Chính 64 MP & Phụ 8 MP, 2 MP', N'HD 720p@30fps, FullHD 1080p@60fps, FullHD 1080p@30fps, 4K 2160p@30fps, 4K 2160p@60fps, HD 720p@60fps', N'32 MP', N'Quay video hiển thị kép, Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Tự động lấy nét (AF), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Siêu độ phân giải, AI Camera, Làm đẹp, Siêu cận (Macro), Hiệu ứng Bokeh, Bộ lọc màu', N'Android 12', N'MediaTek Dimensity 1300 8 nhân', N'1 nhân 3 GHz, 3 nhân 2.6 GHz & 4 nhân 2 GHz', N'Mali-G77', N'8 GB', N'128GB', N'Hỗ trợ 5G', N'2 Nano SIM', N'Wi-Fi Direct, Wi-Fi 802.11 a/b/g/n/ac, Dual-band (2.4 GHz/5 GHz)', N'Type-C', N'4830 mAh', N'Li-Po', N'66 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Cử chỉ thông minh, Mở rộng bộ nhớ RAM, Ứng dụng kép (Nhân bản ứng dụng), Thu nhỏ màn hình sử dụng một tay, Đa cửa sổ (chia đôi màn hình), Chế độ trẻ em (Không gian trẻ em)', N'IPX4', N'Nguyên khối', N'Khung kim loại & Mặt lưng kính', N'Dài 158.9 mm - Ngang 73.52 mm - Dày 8.62 mm - Nặng 190 g', 12, '2022-11-01'),
(14, N'6.51"', N'IPS LCD', N'HD+ (720 x 1600 Pixels)', N'Kính cường lực Panda', N'60 Hz', N'8 MP', N'HD 720p@30fps, FullHD 1080p@30fps', N'5 MP', N'Trôi nhanh thời gian (Time Lapse), Xóa phông, Làm đẹp', N'Android 12', N'MediaTek Helio P35 8 nhân', N'4 nhân 2.3 GHz & 4 nhân 1.8 GHz', N'IMG PowerVR GE8320', N'3 GB', N'32 GB', N'Hỗ trợ 4G', N'2 Nano SIM', N'Dual-band (2.4 GHz/5 GHz)', N'Micro USB', N'5000 mAh', N'Li-Po', N'10 W', N'Mở khoá khuôn mặt', N'Chế độ đơn giản (Giao diện đơn giản), Chặn cuộc gọi, Chặn tin nhắn, Chạm 2 lần tắt/sáng màn hình, Trợ lý ảo Google Assistant', N'IP52', N'Nguyên khối', N'Khung & Mặt lưng nhựa Polymer cao cấp', N'Dài 163.99 mm - Ngang 75.63 mm - Dày 8.49 mm - Nặng 186 g', 12, '2023-03-01'),
(15, N'6.62"', N'AMOLED', N'Full HD+ (1080 x 2400 Pixels)', N'Kính cường lực Schott Xensation UP', N'120 Hz', N'Chính 64 MP & Phụ 2 MP, 2 MP', N'HD 720p@30fps, FullHD 1080p@30fps, HD 720p@60fps', N'32 MP', N'Quay video hiển thị kép, Phơi sáng kép, Trôi nhanh thời gian (Time Lapse), Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Tự động lấy nét (AF), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Siêu độ phân giải, Làm đẹp, Siêu cận (Macro), Live Photo, Bộ lọc màu', N'Android 13', N'MediaTek Helio G99 8 nhân', N'2 nhân 2.2 GHz & 6 nhân 2.0 GHz', N'Mali-G57', N'8 GB', N'256 GB', N'Hỗ trợ 4G', N'2 Nano SIM', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi Direct', N'Type-C', N'4600 mAh', N'Li-Po', N'66 W', N'Mở khoá vân tay dưới màn hình, Mở khoá khuôn mặt', N'Chế độ đơn giản (Giao diện đơn giản), Chặn cuộc gọi, Chặn tin nhắn, Chạm 2 lần tắt/sáng màn hình, Trợ lý ảo Google Assistant', N'IP54', N'Nguyên khối', N'Khung & Mặt lưng nhựa', N'Dài 162.51 mm - Ngang 75.81 mm - Dày 7.8 mm - Nặng 186 g', 12, '2023-05-01'),
(16, N'Chính 7.6" & Phụ 6.2"', N'Dynamic AMOLED 2X', N'Chính: QXGA+ (2176 x 1812 Pixels) & Phụ: HD+ (2316 x 904 Pixels)', N'Chính: Ultra Thin Glass & Phụ: Corning Gorilla Glass Victus 2', N'120 Hz', N'Chính 50 MP & Phụ 12 MP, 10 MP', N'HD 720p@30fps, FullHD 1080p@30fps, HD 720p@60fps, 4K 2160p@30fps, 4K 2160p@60fps, 8K 4320p@30fps', N'10 MP & 4 MPP', N'Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Góc rộng (Wide), FlexCam, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Zoom quang học, Quay Siêu chậm (Super Slow Motion), Làm đẹp, Hiệu ứng Bokeh, Bộ lọc màu', N'Android 13', N'Snapdragon 8 Gen 2 for Galaxy', N'1 nhân 3.36 GHz, 4 nhân 2.8 GHz & 3 nhân 2 GHz', N'Adreno 740', N'12 GB', N'256 GB', N'Hỗ trợ 5G', N'2 Nano SIM hoặc 1 Nano SIM + 1 eSIM', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi MIMO, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'4400 mAh', N'Li-Po', N'25 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Chế độ đơn giản (Giao diện đơn giản), Chặn cuộc gọi, Chặn tin nhắn, Chạm 2 lần tắt/sáng màn hình, Trợ lý ảo Google Assistant', N'IPX8', N'Nguyên khối', N'Khung nhôm & Mặt lưng kính cường lực', N'Dài 154.9 mm - Ngang 129.9 mm - Dày 6.1 mm - Nặng 253 g', 18, '2023-07-01'),
(17, N'Chính 7.6" & Phụ 6.2"', N'Dynamic AMOLED 2X', N'Chính: QXGA+ (2176 x 1812 Pixels) & Phụ: HD+ (2316 x 904 Pixels)', N'Chính: Ultra Thin Glass & Phụ: Corning Gorilla Glass Victus 2', N'120 Hz', N'Chính 50 MP & Phụ 12 MP, 10 MP', N'HD 720p@30fps, FullHD 1080p@30fps, HD 720p@60fps, 4K 2160p@30fps, 4K 2160p@60fps, 8K 4320p@30fps', N'10 MP & 4 MPP', N'Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Góc rộng (Wide), FlexCam, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Zoom quang học, Quay Siêu chậm (Super Slow Motion), Làm đẹp, Hiệu ứng Bokeh, Bộ lọc màu', N'Android 13', N'Snapdragon 8 Gen 2 for Galaxy', N'1 nhân 3.36 GHz, 4 nhân 2.8 GHz & 3 nhân 2 GHz', N'Adreno 740', N'12 GB', N'512 GB', N'Hỗ trợ 5G', N'2 Nano SIM hoặc 1 Nano SIM + 1 eSIM', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi MIMO, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'4400 mAh', N'Li-Po', N'25 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Chế độ đơn giản (Giao diện đơn giản), Chặn cuộc gọi, Chặn tin nhắn, Chạm 2 lần tắt/sáng màn hình, Trợ lý ảo Google Assistant', N'IPX8', N'Nguyên khối', N'Khung nhôm & Mặt lưng kính cường lực', N'Dài 154.9 mm - Ngang 129.9 mm - Dày 6.1 mm - Nặng 253 g', 18, '2023-07-01'),
(18, N'Chính 7.6" & Phụ 6.2"', N'Dynamic AMOLED 2X', N'Chính: QXGA+ (2176 x 1812 Pixels) & Phụ: HD+ (2316 x 904 Pixels)', N'Chính: Ultra Thin Glass & Phụ: Corning Gorilla Glass Victus 2', N'120 Hz', N'Chính 50 MP & Phụ 12 MP, 10 MP', N'HD 720p@30fps, FullHD 1080p@30fps, HD 720p@60fps, 4K 2160p@30fps, 4K 2160p@60fps, 8K 4320p@30fps', N'10 MP & 4 MPP', N'Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Góc rộng (Wide), FlexCam, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Zoom quang học, Quay Siêu chậm (Super Slow Motion), Làm đẹp, Hiệu ứng Bokeh, Bộ lọc màu', N'Android 13', N'Snapdragon 8 Gen 2 for Galaxy', N'1 nhân 3.36 GHz, 4 nhân 2.8 GHz & 3 nhân 2 GHz', N'Adreno 740', N'12 GB', N'1TB', N'Hỗ trợ 5G', N'2 Nano SIM hoặc 1 Nano SIM + 1 eSIM', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi MIMO, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'4400 mAh', N'Li-Po', N'25 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Chế độ đơn giản (Giao diện đơn giản), Chặn cuộc gọi, Chặn tin nhắn, Chạm 2 lần tắt/sáng màn hình, Trợ lý ảo Google Assistant', N'IPX8', N'Nguyên khối', N'Khung nhôm & Mặt lưng kính cường lực', N'Dài 154.9 mm - Ngang 129.9 mm - Dày 6.1 mm - Nặng 253 g', 18, '2023-07-01'),
(19, N'Chính 6.7" & Phụ 1.9"', N'Chính: Dynamic AMOLED 2X, Phụ: Super AMOLED', N'Chính: FHD+ (2640 x 1080 Pixels) x Phụ: (260 x 512 Pixels)', N'Chính: Ultra Thin Glass & Phụ: Corning Gorilla Glass Victus+', N'120 Hz', N'2 camera 12 MP', N'HD 720p@30fps, FullHD 1080p@30fps, HD 720p@60fps, 4K 2160p@30fps, 4K 2160p@60fps', N'10 MP', N'Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Góc rộng (Wide), FlexCam, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Zoom quang học, Quay Siêu chậm (Super Slow Motion), Làm đẹp, Hiệu ứng Bokeh, Bộ lọc màu', N'Android 12', N'Snapdragon 8+ Gen 1 8 nhân', N'1 nhân 3.18 GHz, 3 nhân 2.7 GHz & 4 nhân 2 GHz', N'Adreno 670', N'8 GB', N'128 GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi MIMO, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'3700 mAh', N'Li-Ion', N'25 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Chế độ đơn giản (Giao diện đơn giản), Chặn cuộc gọi, Chặn tin nhắn, Chạm 2 lần tắt/sáng màn hình, Trợ lý ảo Google Assistant', N'IPX8', N'Nguyên khối', N'Khung nhôm & Mặt lưng kính cường lực', N'Dài 165.2 mm - Ngang 71.9 mm - Dày 6.9 mm - Nặng 187 g', 12, '2022-08-01'),
(20, N'Chính 6.7" & Phụ 1.9"', N'Chính: Dynamic AMOLED 2X, Phụ: Super AMOLED', N'Chính: FHD+ (2640 x 1080 Pixels) x Phụ: (260 x 512 Pixels)', N'Chính: Ultra Thin Glass & Phụ: Corning Gorilla Glass Victus+', N'120 Hz', N'2 camera 12 MP', N'HD 720p@30fps, FullHD 1080p@30fps, HD 720p@60fps, 4K 2160p@30fps, 4K 2160p@60fps', N'10 MP', N'Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Góc rộng (Wide), FlexCam, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Zoom quang học, Quay Siêu chậm (Super Slow Motion), Làm đẹp, Hiệu ứng Bokeh, Bộ lọc màu', N'Android 12', N'Snapdragon 8+ Gen 1 8 nhân', N'1 nhân 3.18 GHz, 3 nhân 2.7 GHz & 4 nhân 2 GHz', N'Adreno 670', N'8 GB', N'256 GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi MIMO, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'3700 mAh', N'Li-Ion', N'25 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Chế độ đơn giản (Giao diện đơn giản), Chặn cuộc gọi, Chặn tin nhắn, Chạm 2 lần tắt/sáng màn hình, Trợ lý ảo Google Assistant', N'IPX8', N'Nguyên khối', N'Khung nhôm & Mặt lưng kính cường lực', N'Dài 165.2 mm - Ngang 71.9 mm - Dày 6.9 mm - Nặng 187 g', 12, '2022-08-01'),
(21, N'Chính 6.7" & Phụ 1.9"', N'Chính: Dynamic AMOLED 2X, Phụ: Super AMOLED', N'Chính: FHD+ (2640 x 1080 Pixels) x Phụ: (260 x 512 Pixels)', N'Chính: Ultra Thin Glass & Phụ: Corning Gorilla Glass Victus+', N'120 Hz', N'2 camera 12 MP', N'HD 720p@30fps, FullHD 1080p@30fps, HD 720p@60fps, 4K 2160p@30fps, 4K 2160p@60fps', N'10 MP', N'Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Góc rộng (Wide), FlexCam, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Zoom quang học, Quay Siêu chậm (Super Slow Motion), Làm đẹp, Hiệu ứng Bokeh, Bộ lọc màu', N'Android 12', N'Snapdragon 8+ Gen 1 8 nhân', N'1 nhân 3.18 GHz, 3 nhân 2.7 GHz & 4 nhân 2 GHz', N'Adreno 670', N'8 GB', N'512 GB', N'Hỗ trợ 5G', N'1 Nano SIM & 1 eSIM', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi MIMO, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'3700 mAh', N'Li-Ion', N'25 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Chế độ đơn giản (Giao diện đơn giản), Chặn cuộc gọi, Chặn tin nhắn, Chạm 2 lần tắt/sáng màn hình, Trợ lý ảo Google Assistant', N'IPX8', N'Nguyên khối', N'Khung nhôm & Mặt lưng kính cường lực', N'Dài 165.2 mm - Ngang 71.9 mm - Dày 6.9 mm - Nặng 187 g', 12, '2022-08-01'),
(22, N'6.28"', N'AMOLED', N'Full HD+ (1080 x 2400 Pixels)', N'Kính cường lực Corning Gorilla Glass Victus', N'120 Hz', N'Chính 50 MP & Phụ 13 MP, 5 MP', N'HD 720p@30fps, FullHD 1080p@30fps, HD 720p@60fps, 4K 2160p@30fps, 4K 2160p@60fps, 8K 4320p@24fps', N'32 MP', N'Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Góc rộng (Wide), FlexCam, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Chuyên nghiệp (Pro), HDR, Zoom quang học, Quay Siêu chậm (Super Slow Motion), Làm đẹp, Hiệu ứng Bokeh, Bộ lọc màu', N'Android 12', N'Snapdragon 8+ Gen 1 8 nhân', N'1 nhân 3 GHz, 3 nhân 2.5 GHz & 4 nhân 1.79 GHz', N'Adreno 730', N'8 GB', N'256 GB', N'Hỗ trợ 5G', N'2 Nano SIM', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi MIMO, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'4500 mAh', N'Li-Ion', N'67 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Công nghệ tản nhiệt LiquidCool, Màn hình luôn hiển thị AOD, Âm thanh Dolby Atmos, Chạm 2 lần tắt/sáng màn hình, Đa cửa sổ (chia đôi màn hình), Âm thanh bởi Harman Kardon, Loa kép', N'Không có', N'Nguyên khối', N'Khung kim loại & Mặt lưng kính', N'Dài 152.7 mm - Ngang 69.9 mm - Dày 8.2 mm - Nặng 180 g', 12, '2022-03-01'),
(23, N'6.43"', N'AMOLED', N'Full HD+ (1080 x 2400 Pixels)', N'Kính cường lực Corning Gorilla Glass 3', N'90 Hz', N'Chính 108 MP & Phụ 8 MP, 2 MP', N'HD 720p@30fpsFullHD 1080p@30fps', N'16 MP', N'Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Góc rộng (Wide), FlexCam, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Quay Siêu chậm (Super Slow Motion), Làm đẹp, Hiệu ứng Bokeh, Bộ lọc màu', N'Android 13', N'MediaTek Helio G96 8 nhân', N'2 nhân 2.05 GHz & 6 nhân 2.0 GHz', N'Mali-G57 MC2', N'8 GB', N'256 GB', N'Hỗ trợ 4G', N'2 Nano SIM', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi MIMO, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'5000 mAh', N'Li-Po', N'33 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Công nghệ tản nhiệt LiquidCool, Màn hình luôn hiển thị AOD, Âm thanh Dolby Atmos, Chạm 2 lần tắt/sáng màn hình, Đa cửa sổ (chia đôi màn hình), Âm thanh bởi Harman Kardon, Loa kép', N'Không có', N'Nguyên khối', N'Khung nhựa & Mặt lưng kính', N'Dài 159.87 mm - Ngang 73.87 mm - Dày 8.09 mm - Nặng 176 g', 12, '2023-05-01'),
(24, N'6.67"', N'AMOLED', N'Full HD+ (1080 x 2400 Pixels)', N'Kính cường lực Corning Gorilla Glass 5', N'120 Hz', N'Chính 108 MP & Phụ 8 MP, 2 MP, 2 MP', N'HD 720p@30fpsFullHD 1080p@30fps, 4K 2160p@30fps', N'16 MP', N'Trôi nhanh thời gian (Time Lapse), Góc siêu rộng (Ultrawide), Zoom kỹ thuật số, Góc rộng (Wide), FlexCam, Quay chậm (Slow Motion), Xóa phông, Toàn cảnh (Panorama), Chống rung quang học (OIS), Ban đêm (Night Mode), Quay Siêu chậm (Super Slow Motion), Làm đẹp, Hiệu ứng Bokeh, Bộ lọc màu', N'Android 11', N'Snapdragon 732G 8 nhân', N'2.3 GHz', N'Adreno 618', N'8 GB', N'128 GB', N'Hỗ trợ 4G', N'2 Nano SIM (SIM 2 chung khe thẻ nhớ)', N'Dual-band (2.4 GHz/5 GHz), Wi-Fi MIMO, Wi-Fi 802.11 a/b/g/n/ac/ax', N'Type-C', N'5000 mAh', N'Li-Po', N'67 W', N'Mở khoá vân tay cạnh viền, Mở khoá khuôn mặt', N'Công nghệ tản nhiệt LiquidCool, Màn hình luôn hiển thị AOD, Âm thanh Dolby Atmos, Chạm 2 lần tắt/sáng màn hình, Đa cửa sổ (chia đôi màn hình), Âm thanh bởi Harman Kardon, Loa kép', N'IP53', N'Nguyên khối', N'Khung nhựa & Mặt lưng kính', N'Dài 164.2 mm - Ngang 76.1 mm - Dày 8.12 mm - Nặng 201.8 g', 12, '2023-05-01')
GO

--INSERT CHITIETPHUKIENSACDUPHONG
--MaCTPKSac INT IDENTITY NOT NULL,
--MaSP INT NOT NULL,

--HIEUSUAT NVARCHAR(50) NULL,
--DUNGLUONGPIN NVARCHAR(50) NULL,
--THOIGIANSAC NVARCHAR(50) NULL,
--NGUONVAO NVARCHAR(50) NULL,
--NGUONRA NVARCHAR(50) NULL,
--CONGNGHE NVARCHAR(50) NULL,
--KICHTHUOC NVARCHAR(50) NULL,
--KHOILUONG NVARCHAR(50) NULL

INSERT INTO CHITIETPHUKIENSACDUPHONG(MaSP, HIEUSUAT, DUNGLUONGPIN, THOIGIANSAC, NGUONVAO, NGUONRA, CONGNGHE, KICHTHUOC, BAOHANH, KHOILUONG) VALUES
(25, N'64%', N'10000 mAh', N'5 - 6 giờ (dùng Adapter 2A)', N'Type C: 5V - 3A, Micro USB: 5V - 2A', N'Type-C: 5V - 3, AUSB: 5V - 2.4A', N'Đèn LED báo hiệu', N'Dài 9.2 cm - 6.3 cm - Dày 1.9 cm', 12, N'190 g'),
(26, N'64%', N'10000 mAh', N'5 - 6 giờ (dùng Adapter 2A)', N'Micro USB: 5V - 2A', N'USB 1: 5V - 2.4, AUSB 2: 5V - 2.4A', N'Đèn LED báo hiệu', N'Dày 2.2 cm - Rộng 6.1 cm - Dài 8.9 cm', 12, N'186.2 g'),
(27, N'65%', N'10000 mAh', N'5 - 6 giờ (dùng Adapter 2A)', N'Micro USB/Type-C: 5V - 2A', N'Type-C: 5V - 2, AUSB: 5V - 2A', N'Đèn LED báo hiệu', N'Dày 1.5 cm - Rộng 6.9 cm - Dài 14.6 cm', 12, N'230 g')
GO

--INSERT CHITIETPHUKIENTAINGHE 
--MaPKTaiNghe INT IDENTITY NOT NULL,
--MaSP INT NOT NULL,

--DUNGLUONGPIN NVARCHAR(50) NULL,
--THOILUONGSAC NVARCHAR(50) NULL,
--CONGSAC NVARCHAR(50) NULL,
--CONGNGHEAMTHANH NVARCHAR(50) NULL,
--TIENICH NVARCHAR(100) NULL,
--TUONGTHICH NVARCHAR(50) NULL,
--CONGNGHEKETNOT NVARCHAR(50) NULL,
--PHIMDIEUKHIEN NVARCHAR(255) NULL,
--KICHTHUOC NVARCHAR(50) NULL,
--KHOILUONG NVARCHAR(50) NULL

INSERT INTO CHITIETPHUKIENTAINGHE(MaSP, DUNGLUONGPIN, THOILUONGSAC, CONGSAC, CONGNGHEAMTHANH, TIENICH, TUONGTHICH, CONGNGHEKETNOT, PHIMDIEUKHIEN, KICHTHUOC, BAOHANH, KHOILUONG) VALUES
(28, N'Dùng 18 giờ', N'Sạc 2 giờ', N'Type-C', N'Màng loa 13 mm', N'Game Mode, Sử dụng độc lập 1 bên tai nghe, Có mic thoại, Tương thích trợ lý ảo', N'MacOSAndroid, iOS, Windows', N'Bluetooth 5.3', N'Phát/dừng chơi nhạc, Chuyển bài hát, Từ chối cuộc gọi, Bật trợ lí ảo, Bật/tắt game mode, Nhận/Ngắt cuộc gọi', N'Dài 3.3 cm - Rộng 1.9 cm - Cao 1.6 cm', 12, N'4 g'),
(29, N'Dùng 18 giờ', N'Sạc 2 giờ', N'Type-C', N'Không có', N'Có mic thoại, Tương thích trợ lý ảo', N'MacOSAndroid, iOS, Windows', N'Bluetooth 5.3', N'Phát/dừng chơi nhạc, Chuyển bài hát, Từ chối cuộc gọi, Bật trợ lí ảo, Nhận/Ngắt cuộc gọi', N'Dài 3.3 cm - Rộng 2.9 cm - Cao 1.7 cm', 12, N'3.9 g'),
(30, N'Dùng 18 giờ', N'Sạc 2 giờ', N'Type-C', N'Không có', N'Sử dụng độc lập 1 bên tai nghe, Có mic thoại', N'MacOSAndroid, iOS, Windows', N'Bluetooth 5.1', N'Phát/dừng chơi nhạc, Chuyển bài hát, Từ chối cuộc gọi, Bật trợ lí ảo, Nhận/Ngắt cuộc gọi, Từ chối cuộc gọi', N'Dài 3.3 cm - Rộng 2.3 cm - Cao 2.2 cm', 12, N'4 g')
GO

--INSERT BINHLUAN
--MaBinhLuan INT IDENTITY NOT NULL,
--MaTV INT NOT NULL,
--MaSP INT NOT NULL,
--NoiDungBL NVARCHAR(MAX) NULL

--INSERT INTO BINHLUAN(MaTV, MaSP, NoiDungBL) VALUES
--(1, 1, N'Sản phẩm chất lượng.'),
--(2, 2, N'Cảm thấy không như mong muốn của tôi.')
--GO

--INSERT CHITIETPHIEUNHAP
--MaCTPN INT IDENTITY NOT NULL,
--MaPN INT NOT NULL,
--MaSP INT NOT NULL,
--DonGiaNhap DECIMAL(18,0) NOT NULL,
--SoLuongNhap INT NOT NULL
INSERT INTO CHITIETPHIEUNHAP(MaPN, MaSP, DonGiaNhap, SoLuongNhap) VALUES
(1, 1, 23900000, 10),
(1, 2, 25900000, 10),
(1, 3, 30900000, 10),
(1, 4, 37900000, 10),
(1, 5, 20900000, 10),
(1, 6, 22900000, 10),
(1, 7, 25900000, 10),
(1, 8, 11900000, 10),
(1, 9, 12900000, 10),
(2, 10, 15900000, 10),
(2, 11, 10900000, 10),
(2, 12, 3990000, 10),
(3, 13, 7090000, 10),
(3, 14, 1590000, 10),
(3, 15, 6990000, 10),
(4, 16, 30990000, 10),
(4, 17, 33990000, 10),
(4, 18, 40900000, 10),
(4, 19, 11990000, 10),
(4, 20, 12990000, 10),
(4, 21, 13990000, 10),
(5, 22, 9990000, 10),
(5, 23, 3990000, 10),
(5, 24, 4990000, 10),
(6, 25, 239000, 10),
(6, 26, 139000, 10),
(6, 27, 209000, 10),
(7, 28, 289000, 10),
(7, 29, 289000, 10),
(7, 30, 239000, 10)
GO
--INSERT MAU
--MaMau INT IDENTITY NOT NULL,
--TenMau NVARCHAR(50) NULL

INSERT INTO MAU(TenMau) VALUES
(N'Vàng'),
(N'Bạc'),
(N'Đen'),
(N'Trắng'),
(N'Tím'),
(N'Đỏ'),
(N'Xanh'),
(N'Xám'), 
(N'Hồng'),
(N'Cam')
GO

--INSERT SANPHAM_MAU
--MaSP INT  NOT NULL
--MaMau INT NOT NULL,

INSERT INTO SANPHAM_MAU(MaSP, MaMau) VALUES
(1, 5), 
(1, 1),
(2, 5),
(2, 1),
(3, 5),
(3, 1),
(4, 5),
(4, 1),
(5, 1),
(5, 4),
(6, 1),
(6, 4),
(7, 1),
(7, 4),
(8, 1),
(8, 2),
(9, 1),
(9, 2),
(10, 5),
(10, 3),
(11, 8),
(11, 5),
(12, 3),
(12, 7),
(13, 7),
(13, 3),
(14, 3),
(14, 5),
(15, 5),
(15, 3),
(16, 7),
(16, 3),
(17, 7),
(17, 3),
(18, 7),
(18, 3),
(19, 5),
(19, 3),
(20, 5),
(20, 3),
(21, 5),
(21, 3),
(22, 8),
(22, 5),
(23, 3),
(23, 7),
(24, 8),
(24, 7),
(25, 7),
(25, 9),
(26, 3),
(26, 4),
(27, 4), 
(27, 3),
(28, 3), 
(28, 10),
(29, 4),
(29, 3),
(30, 4),
(30, 3)
GO