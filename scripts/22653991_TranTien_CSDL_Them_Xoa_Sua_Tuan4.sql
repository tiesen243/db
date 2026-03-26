/*
Họ tên: Trần Tiến
MSSV: 22653991

Bài tập tuần 4
*/

USE master;
DROP DATABASE qlbh;

CREATE DATABASE qlbh
ON (
  NAME = qlbh_data,
  FILENAME = 'T:\22653991-Tran_Tien\data\qlbh_data.mdf',
  SIZE = 20MB,
  MAXSIZE = 40MB,
  FILEGROWTH = 1MB
)
LOG ON (
  NAME = qlbh_log,
  FILENAME = 'T:\22653991-Tran_Tien\data\qlbh_log.ldf',
  SIZE = 6MB,
  MAXSIZE = 8MB,
  FILEGROWTH = 1MB
);

USE qlbh;

-- Bảng nhóm sản phẩm
CREATE TABLE nhom_san_pham
(
  ma_nhom INT NOT NULL,
  ten_nhom NVARCHAR(15)
);

-- Bảng sản phẩm
CREATE TABLE san_pham
(
  ma_sp INT NOT NULL,
  ma_ncc INT,
  ma_nhom INT,
  ten_sp NVARCHAR(40) NOT NULL,
  mo_ta NVARCHAR(50),
  don_vi_tinh NVARCHAR(20),
  gia_goc MONEY,
  sl_ton INT
);

-- Bảng hóa đơn
CREATE TABLE hoa_don
(
  ma_hd INT NOT NULL,
  ma_kh CHAR(5),
  ngay_lap_hd DATETIME,
  ngay_giao DATETIME,
  noi_chuyen NVARCHAR(60) NOT NULL
);

-- Bảng chi tiết hóa đơn
CREATE TABLE ct_hoa_don
(
  ma_hd INT NOT NULL,
  ma_sp INT NOT NULL,
  so_luong SMALLINT,
  don_gia MONEY,
  chiet_khau MONEY
);

-- Bảng nhà cung cấp
CREATE TABLE nha_cung_cap
(
  ma_ncc INT NOT NULL,
  ten_ncc NVARCHAR(40) NOT NULL,
  dia_chi NVARCHAR(60),
  phone NVARCHAR(24),
  so_fax NVARCHAR(24),
  dc_mail NVARCHAR(50)
);

-- Bảng khách hàng
CREATE TABLE khach_hang
(
  ma_kh CHAR(5) NOT NULL,
  ten_kh NVARCHAR(40) NOT NULL,
  loai_kh NVARCHAR(3),
  dia_chi NVARCHAR(60),
  phone NVARCHAR(24),
  dc_mail NVARCHAR(50),
  diem_tl INT
);

-- Thêm ràng buộc khóa chính --

-- Bảng nhóm sản phẩm
ALTER TABLE nhom_san_pham
ADD CONSTRAINT nhom_san_pham_pk PRIMARY KEY (ma_nhom);

-- Bảng sản phẩm
ALTER TABLE san_pham
ADD CONSTRAINT san_pham_pk PRIMARY KEY (ma_sp);

-- Bảng hóa đơn
ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_pk PRIMARY KEY (ma_hd);

-- Bảng chi tiết hóa đơn
ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_pk PRIMARY KEY (ma_hd, ma_sp);

-- Bảng nhà cung cấp
ALTER TABLE nha_cung_cap
ADD CONSTRAINT nha_cung_cap_pk PRIMARY KEY (ma_ncc);

-- Bảng khách hàng
ALTER TABLE khach_hang
ADD CONSTRAINT khach_hang_pk PRIMARY KEY (ma_kh);

-- Thêm ràng buộc khóa ngoại --

-- Bảng sản phẩm

ALTER TABLE san_pham
ADD CONSTRAINT san_pham_ma_ncc_fk FOREIGN KEY (ma_ncc)
REFERENCES nha_cung_cap (ma_ncc);

ALTER TABLE san_pham
ADD CONSTRAINT san_pham_ma_nhom_fk FOREIGN KEY (ma_nhom)
REFERENCES nhom_san_pham (ma_nhom);

-- Bảng hóa đơn

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_ma_kh_fk FOREIGN KEY (ma_kh)
REFERENCES khach_hang (ma_kh);

-- Bảng chi tiết hóa đơn

ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_ma_hd_fk FOREIGN KEY (ma_hd)
REFERENCES hoa_don (ma_hd);

ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_ma_sp_fk FOREIGN KEY (ma_sp)
REFERENCES san_pham (ma_sp);

-- Thêm ràng buộc kiểm tra và giá trị mặc định --

-- Bảng sản phẩm

ALTER TABLE san_pham
ADD CONSTRAINT san_pham_gia_goc_ck CHECK (gia_goc > 0);

ALTER TABLE san_pham
ADD CONSTRAINT san_pham_sl_ton_ck CHECK (sl_ton >= 0);

-- Bảng hóa đơn

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_ngay_lap_hd_df DEFAULT GETDATE() FOR ngay_lap_hd;

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_ngay_lap_hd_ck CHECK (ngay_lap_hd >= GETDATE());

-- Bảng chi tiết hóa đơn

ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_so_luong_ck CHECK (so_luong > 0);

ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_chiet_khau_ck CHECK (chiet_khau >= 0);

-- Bảng khách hàng

ALTER TABLE khach_hang
ADD CONSTRAINT khach_hang_loai_kh_ck CHECK (loai_kh IN ('VIP', 'TV', 'VL'));

ALTER TABLE khach_hang
ADD CONSTRAINT khach_hang_diem_tl_ck CHECK (diem_tl >= 0);

-- 4. Viết lệnh thực hiện --

-- a. Thêm cột LoaiHD vào bảng HoaDon

ALTER TABLE hoa_don
ADD loai_hd CHAR(1);

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_loai_hd_ck CHECK (loai_hd IN ('N', 'X', 'C', 'T'));

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_loai_hd_df DEFAULT 'N' FOR loai_hd;

-- b. Tạo thêm ràng buộc trên bảng HoaDon: ngay_giao >= ngay_lap_hd

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_ngay_giao_ck CHECK (ngay_giao >= ngay_lap_hd);

-- Thêm nhóm sản phẩm
ALTER TABLE nhom_san_pham
ALTER COLUMN ten_nhom NVARCHAR(30);

INSERT INTO nhom_san_pham (ma_nhom, ten_nhom) VALUES
	(1, N'Điện Tử'),
	(2, N'Gia Dụng'),
	(3, N'Dụng Cụ Gia Đình'),
	(4, N'Các Mặt Hàng Khác');

SELECT ma_nhom, ten_nhom FROM nhom_san_pham;

-- Thêm nhà cung cấp
INSERT INTO nha_cung_cap (ma_ncc, ten_ncc, dia_chi, phone, so_fax, dc_mail) VALUES
	(1, N'Công ty TNHH Nam Phương', N'67 Lê Lợi', '096967676', '67696969', 'namphuong@yahoo.com'),
	(2, N'Công ty Lan Ngọc', N'69 Cao Bá Quát', '08361867', '43224342', 'lanngoc@gmail.com');

SELECT * FROM nha_cung_cap;

-- Thêm sản phẩm
INSERT INTO san_pham (ma_sp, ten_sp, don_vi_tinh, gia_goc, sl_ton, ma_nhom, ma_ncc, mo_ta) VALUES
	(1, N'Máy Tính', N'Cái', 7000.0000, 100, 1, 1, N'Máy Sony Ram 2GB'),
	(2, N'Bàn Phím', N'Cái', 1000.0000, 50, 1, 1, N'Bàn Phím 101 phím'),
	(3, N'Chuột', N'Cái', 800.0000, 150, 1, 1, N'Chuột không dây'),
	(4, N'CPU', N'Cái', 3000.0000, 200, 1, 1, N'CPU'),
	(5, N'USB', N'Cái', 500.0000, 100, 3, 2, N'8GB'),
	(6, N'Lò Vi Sóng', N'Cái', 1000000.0000, 20, 1, 1, NULL);

SELECT * FROM san_pham;

-- Thêm khách hàng
EXEC sp_rename 'khach_hang.phone', 'dien_thoai', 'COLUMN';
ALTER TABLE khach_hang 
ADD so_fax NVARCHAR(24);

INSERT INTO khach_hang (ma_kh, ten_kh, dia_chi, dien_thoai, loai_kh, dc_mail, diem_tl) VALUES
	('KH1', N'Nguyễn Thu Hằng', N'12 Nguyễn Du', '', 'VL', NULL, NULL),
	('KH2', N'Lê Minh', N'34 Điện Biên Phủ', '0123943455', 'TV', 'leminh@yahoo.com', 100),
	('KH3', N'Nguyễn Minh Trung', N'3 Lê Lợi Quận Gò Vấp', '098343434', 'VIP', 'trung@gmail.com', 800);

SELECT * FROM khach_hang;

-- Thêm hóa đơn
SET DATEFORMAT DMY;

INSERT INTO hoa_don (ma_hd, ngay_lap_hd, ma_kh, ngay_giao, noi_chuyen) VALUES
	(1, '30/09/2026', 'KH1', '05/10/2026', N'Cửa hàng ABC 3 Lý Chính Thắng Quận 3'),
	(2, '29/07/2026', 'KH2', '08/10/2026', N'23 Lê Lợi Quận Gò Vấp'),
	(3, '01/10/2026', 'KH3', '01/10/2026', N'2 Nguyễn Du Quận Gò Vấp');

-- Thêm chi tiết hóa đơn
INSERT INTO ct_hoa_don (ma_hd, ma_sp, don_gia, so_luong) VALUES
	(1, 1, 8000.0000, 5),
	(1, 2, 1200.0000, 4),
	(1, 3, 1000.0000, 15),
	(2, 2, 1200.0000, 9),
	(2, 4, 8000.0000, 5),
	(3, 2, 3500.0000, 20),
	(3, 3, 1000.0000, 15);

SELECT 
	hd.*,
	kh.*,
	ct.*,
	sp.*
FROM hoa_don hd
INNER JOIN khach_hang kh ON kh.ma_kh = hd.ma_kh
INNER JOIN ct_hoa_don ct ON ct.ma_hd = hd.ma_hd
INNER JOIN san_pham sp ON sp.ma_sp = ct.ma_sp;

-- cập nhật dữ liệu

-- a. Tăng giá bán lên 5%
UPDATE san_pham 
SET gia_goc = gia_goc * 1.05
WHERE ma_sp = 2;

-- b. Tăng số lượng tồn
UPDATE san_pham 
SET sl_ton = 100
WHERE ma_nhom = 3 AND ma_ncc = 2;

-- c. Cập nhật mô tả
UPDATE san_pham
SET mo_ta = N'Never gonna give you up'
WHERE ten_sp LIKE '%Lò Vi Sóng%';

SELECT * FROM san_pham;

-- d. Cập nhật mã khách hàng
ALTER TABLE hoa_don
ALTER COLUMN ma_kh CHAR(5);

UPDATE hoa_don
SET ma_kh = NULL
WHERE ma_kh = 'KH3';

UPDATE khach_hang
SET ma_kh = 'VI003'
WHERE ma_kh = 'KH3';

UPDATE hoa_don
SET ma_kh = 'VI003'
WHERE ma_kh IS NULL;

-- 

UPDATE hoa_don
SET ma_kh = NULL
WHERE ma_kh = 'KH1';

UPDATE khach_hang
SET ma_kh = 'VL001'
WHERE ma_kh = 'KH1';

UPDATE hoa_don
SET ma_kh = 'VL001'
WHERE ma_kh IS NULL;

--

UPDATE hoa_don
SET ma_kh = NULL
WHERE ma_kh = 'KH2';

UPDATE khach_hang
SET ma_kh = 'T0002'
WHERE ma_kh = 'KH2';

UPDATE hoa_don
SET ma_kh = 'T0002'
WHERE ma_kh IS NULL;

ALTER TABLE hoa_don
ALTER COLUMN ma_kh CHAR(5) NOT NULL;

SELECT 
	hd.*, 
	kh.*
FROM hoa_don hd
INNER JOIN khach_hang kh ON kh.ma_kh = hd.ma_kh;

-- xóa dữ liệu

-- a. xóa nhóm
DELETE FROM nhom_san_pham
WHERE ma_nhom = 4;

-- b. xóa chi tiết hóa đơn
DELETE FROM ct_hoa_don
WHERE ma_hd = 1 AND ma_sp = 3;

-- c. xóa hóa đơn
DELETE FROM ct_hoa_don
WHERE ma_hd = 1;

DELETE FROM hoa_don
WHERE ma_hd = 1;

-- d. xóa hóa đơn

DELETE FROM ct_hoa_don
WHERE ma_hd = 2;

DELETE FROM hoa_don
WHERE ma_hd = 2;