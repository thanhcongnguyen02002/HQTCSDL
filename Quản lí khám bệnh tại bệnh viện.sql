CREATE DATABASE quanLyKhamBenhBenhVien
ON
(
   	NAME = 'QLKBBV',
   	FILENAME = 'E:\SQL_SERVER\QLKBBV.mdf',
   	SIZE = 10MB,
   	MAXSIZE = UNLIMITED,
   	FILEGROWTH = 10%
);
GO
use quanLyKhamBenhBenhVien
--Bảng phòng
CREATE TABLE tblPHONG
(
   	iSoPhong INT NOT NULL,
   	sTenPhong NVARCHAR(50) NOT NULL,
   	
   	 CONSTRAINT Pk_Phong PRIMARY KEY (iSoPhong)
);

--Bảng bác sỹ
CREATE TABLE  tblBACSY
(
   	sMaBacSy NVARCHAR(20) NOT NULL,
	sTenBacSy NVARCHAR(30) NOT NULL,
   	iSoPhong INT NOT NULL,
   	sChucVu NVARCHAR(50) NOT NULL,
   	dNgaySinh DATETIME NOT NULL,
   	sGioiTinh BIT NOT NULL,
   	dNgayvaolam DATETIME NOT NULL,
   	fLuongCoBan FLOAT NOT NULL,
   	fHSLuong FLOAT NOT NULL,
   	fPhuCap FLOAT NOT NULL,
   	CONSTRAINT Pk_BacSy PRIMARY KEY (sMaBacSy)
);
--khoá ngoại cho bảng tblBACSY_PHONG
ALTER TABLE dbo.tblBACSY
ADD CONSTRAINT Fk_BacSy_Phong FOREIGN KEY (iSoPhong)
REFERENCES dbo.tblPHONG (iSoPhong);
--ràng buộc dữ liệu cho bảng tblBacSy
ALTER TABLE dbo.tblBACSY
ADD CONSTRAINT CK_BACSY
CHECK(fLuongCoBan >0 AND fHSLuong>0 AND fPhuCap >0
AND DATEDIFF(DAY,dNgaySinh,GETDATE())/365 -24 >=0
AND dNgayvaolam <= GETDATE())
GO

--Bảng bệnh nhân
CREATE TABLE  tblBENHNHAN
(
   	sMaBenhNhan NVARCHAR(20) NOT NULL,
   	sHoTen NVARCHAR(30) NOT NULL,
   	sDiaChi NVARCHAR(50) NOT NULL,
   	dNgaySinh DATETIME NOT NULL,
   	bGioiTinh BIT NOT NULL,
   	sSDT nvarchar(12) NOT NULL, 	
   	CONSTRAINT Pk_BenhNhan PRIMARY KEY (sMaBenhNhan)
);
 --ràng buộc dữ liệu cho bảng tblBenhNhan
ALTER TABLE dbo.tblBENHNHAN
ADD CONSTRAINT CK_BENHNHAN_dNgaySinh
CHECK( dNgaySinh <= GETDATE())
GO
--Bảng bệnh án
CREATE TABLE tblBENHAN
(
   	sMaHS NVARCHAR(20) NOT NULL,
   	sMaBenhNhan NVARCHAR(20) NOT NULL,
   	dNgayLapBA DATETIME,
   	sMaBS NVARCHAR(20) NOT NULL,
   	dNgayKhamLai DATETIME,
);

 ALTER TABLE dbo.tblBENHAN
 ADD
    CONSTRAINT Pk_BenhAn PRIMARY KEY (sMaHS),
 CONSTRAINT FK_BENHANBS FOREIGN KEY(sMaBS) REFERENCES dbo.tblBACSY
GO
--ràng buộc dữ liệu cho bảng tblBenhAn
ALTER TABLE dbo.tblBENHAN
ADD CONSTRAINT CK_BENHAN_dNgLapBenhAn
CHECK (dNgayLapBA <= GETDATE())
, CONSTRAINT CK_ngaykhamlai CHECK(dNgayKhamLai >dNgayLapBA)
GO
ALTER TABLE dbo.tblBENHAN
ADD CONSTRAINT DF_BENHAN_dNgLapBenhAn
DEFAULT GETDATE() FOR dNgayLapBA
GO
--khoá ngoại cho bảng tblBENHAN_BENHNHAN
ALTER TABLE tblBENHAN
ADD CONSTRAINT Fk_BenhAn_BenhNhan
FOREIGN KEY (sMaBenhNhan)
REFERENCES dbo.tblBENHNHAN (sMaBenhNhan);

--Bảng dịch vụ
CREATE TABLE tblDICHVU
(
   	sMaDV NVARCHAR(20) NOT NULL,
   	sTenDV NVARCHAR(50) NOT NULL,
   	fGiaThanh FLOAT NOT NULL,
   	CONSTRAINT Pk_DichVu PRIMARY KEY (sMaDV)
);
--Bảng chi tiết dịch vụ 
CREATE TABLE tblCTDV
(
   	sMaDV NVARCHAR(20) NOT NULL,
   	iSoP INT NOT NULL,
   	sMaBS NVARCHAR(20) NOT NULL,
   	dNgaySD DATETIME NOT NULL,
   	sChuanDoan NVARCHAR(100) NOT NULL
);

ALTER TABLE dbo.tblCTDV
ADD CONSTRAINT PK_BENHNHANDICHVU PRIMARY KEY(sMaDV,iSoP);

--Bảng đơn thuốc
CREATE TABLE tblDONTHUOC
(
   	sMaDT NVARCHAR(20) NOT NULL,
   	sMaBacSy NVARCHAR(20) NOT NULL,
   	sMaHS NVARCHAR(20) NOT NULL,
   	dNgayLap DATETIME NOT NULL,
   	ftongTienDT FLOAT,
);
--ràng buộc khoá cho bảng tbldonthuoc
ALTER TABLE dbo.tblDONTHUOC
ADD
CONSTRAINT Pk_DonThuoc PRIMARY KEY (sMaDT),
CONSTRAINT UN_DTMaHS UNIQUE(sMaHS),
CONSTRAINT Fk_DonThuoc_BacSy FOREIGN KEY  (sMaBacSy) REFERENCES dbo.tblBACSY (sMaBacSy) ,
CONSTRAINT DF_tongTienDT DEFAULT 0 FOR ftongTienDT,
CONSTRAINT Fk_DonThuoc_BenhAn FOREIGN KEY (sMaHS) REFERENCES dbo.tblBENHAN (sMaHS) ;
--ràng buộc dữ liệu cho bảng tblDonThuoc
ALTER TABLE dbo.tblDONTHUOC
ADD CONSTRAINT CK_DONTHUOC_dNgayLap
CHECK(dNgayLap<=GETDATE())
GO
--Bảng thuốc
CREATE TABLE tblTHUOC
(
   	sMaThuoc NVARCHAR(20) NOT NULL,
   	sTenThuoc NVARCHAR(50) NOT NULL,
   	fSLuong INT NOT NULL,
   	sCachDung NVARCHAR(100) NOT NULL,
   	fGiaTien FLOAT NOT NULL,
   	sDangThuoc NVARCHAR(50) NOT NULL,
   	dHanSD DATETIME NOT NULL,
   	CONSTRAINT Pk_Thuoc PRIMARY KEY (sMaThuoc)
);
--Bảng ttblDONTHUOC_THUOC
CREATE TABLE tblDONTHUOC_THUOC
(
   	sMaDT NVARCHAR(20) NOT NULL,
   	sMaThuoc NVARCHAR(20) NOT NULL,
   	iSoLuong INT NOT NULL,
   	fLieuDung FLOAT NOT NULL,
   	sCachDung NVARCHAR(100)  NOT NULL
);
--Khóa chính bảng tblDONTHUOC_THUOC
ALTER TABLE dbo.tblDONTHUOC_THUOC
ADD CONSTRAINT Pk_DONTHUOC_THUOC
PRIMARY KEY (sMaDT,sMaThuoc);
GO
--khoá ngoại cho bảng tblDONTHUOC_THUOC
ALTER TABLE dbo.tblDONTHUOC_THUOC
ADD CONSTRAINT Fk_CTDonThuoc__DT
FOREIGN KEY (sMaDT) REFERENCES dbo.tblDONTHUOC (sMaDT) ,

--khoá ngoại cho bảng tblDONTHUOC_THUOC
CONSTRAINT Fk_CTDONTHUOC_Thuoc
FOREIGN KEY (sMaThuoc) REFERENCES dbo.tblTHUOC (sMaThuoc);
--ràng buộc dữ liệu cho bảng tbl_DONTHUOC_THUOC
ALTER TABLE dbo.tblDONTHUOC_THUOC
ADD CONSTRAINT CK_DONTHUOC_THUOC_SL
CHECK(iSoLuong>0 AND fLieuDung >0)
GO
--Bảng hóa đơn viện phí
CREATE TABLE tblHOADONDICHVU
(
   	iSoHD INT NOT NULL,
   	sMaHS NVARCHAR(20) NOT NULL UNIQUE,
   	dNgayLap DATETIME NOT NULL,
	fTongtien FLOAT DEFAULT(0),
   	CONSTRAINT Pk_HoaDonVienPhi PRIMARY KEY (iSoHD)
);

--ràng buộc dữ liệu cho bảng tblHOADONDICHVU
ALTER TABLE dbo.tblHOADONDICHVU
ADD CONSTRAINT CK_ngayTT
CHECK(dNgayLap <= GETDATE()),
CONSTRAINT UN_maHS_HOADONTT UNIQUE(sMaHS)
GO

--khoá ngoại cho bảng tblHOADONDICHVU_BENHAN
ALTER TABLE dbo.tblHOADONDICHVU
ADD CONSTRAINT Fk_tblHOADONDICHVU_BenhAn
FOREIGN KEY (sMaHS) REFERENCES dbo.tblBENHAN (sMaHS);

--khóa ngoại của bảng CTDV
ALTER TABLE dbo.tblCTDV
ADD CONSTRAINT FkCTDV_DichVu
FOREIGN KEY (sMaDV) REFERENCES dbo.tblDICHVU (sMaDV);
ALTER TABLE dbo.tblCTDV
ADD
CONSTRAINT Fk_CTDV_HOADONDV
FOREIGN KEY (iSoP) REFERENCES dbo.tblHOADONDICHVU (iSoHD);
ALTER TABLE dbo.tblCTDV ADD
CONSTRAINT FK_CTDV_MaBS FOREIGN KEY(sMaBS) REFERENCES dbo.tblBACSY(sMaBacSy)
GO





--Nhập dữ liệu cho bảng bệnh nhân
INSERT INTO dbo.tblBENHNHAN
(sMaBenhNhan, sHoTen, sDiaChi, dNgaySinh, bGioiTinh, sSDT)
VALUES
(N'BN001',N'Ngô Văn A',N'Nghĩa Hội - Nghĩa Đàn - Nghệ An','20020401',0,N'0632315328'),
(N'BN002',N'Nguyễn Thị B',N'Chí Linh - Hải Dương','20000811',1,N'0326482156'),
(N'BN003',N'Đường Thị C ',N'Hoàng Mai - Hà Nội','20020512',1,N'0324624882'),
(N'BN004',N'Ngô Sỹ D',N'Nghĩa Hội - Nghĩa Đàn - Nghệ An','20020825',0,N'0632310328'),
(N'BN005',N'Trịnh Thị E',N'TPHCM','20120302',1,N'0936310328'),
(N'BN006',N'Trần văn F',N'Nghĩa Hội - Nghĩa Đàn - Nghệ An','20020904',0,N'0632310328'),
(N'BN007',N'Đặng Văn G',N'Thanh Xuân - Nghệ An','19500621',0,N'0122304514'),
(N'BN008',N'Trần Thị M',N'TPHCM','19970318',0,N'0632310328'),
(N'BN009',N'Nguyễn Mạnh N',N'Tây Hồ - Hà Nội','20190407',0,N'04124234731'),
(N'BN010',N'Phạm Thị M',N'Đà Nẵng','18980301',0,N'0339310328')
GO

--Nhập dữ liệu bảng phòng
INSERT INTO dbo.tblPHONG (iSoPhong,sTenPhong)
VALUES
(	1, N'Phòng khám 1'),
(	2, N'Phòng khám 2'),
(	3, N'Phòng khám 3'),
(	4, N'Phòng khám 4'),
(	5, N'Phòng khám 5'),
(	6, N'Phòng khám 6')
GO

--Nhập dữ liệu bảng bác sĩ
INSERT INTO tblBACSY (sMaBacSy, sTenBacSy, iSoPhong, sChucVu, dNgaySinh, sGioiTinh, dNgayvaolam, fLuongCoBan, fHSLuong, fPhuCap)
VALUES
 ('BS1', N' Nguyễn Văn Long ',1,N' Trưởng phòng ','3-4-1868',1,'2-7-2010',20000000,2.5,500000),
 ('BS2', N' Đỗ Ngọc Thủy ',1,N' Y tá ', '4-26-1990',0,'4-8-2012',8000000,1.7,100000),
 ('BS3', N' Phan Quang Anh ',1,N' Phó phòng ','3-28-1868',1,'8-2-2020',15000000,2.0,300000),
 ('BS4', N' Đô Quang Thắng ',2,N' Trưởng phòng ','5-7-1890',1,'3-6-2018',2.5,25000000,500000),
 ('BS5', N' Phạm Xuân Sơn ',2,N' Phó phòng ','3-9-1990',1,'2-6-2017',25000000,2.0,300000),
 ('BS6', N' Trịnh Hồng Trang ',2,N' Y tá ','4-27-1893',1,'2-10-2011',10000000,1.7,100000),
 ('BS7', N' Dương Văn Phong ',3,N' Trưởng phòng ','3-29-1887',1,'3-5-2015',22000000,2.5,500000),
 ('BS8', N' Dương Hoài Thu ',3,N' Phó phòng ','7-20-1884',0,'2-9-2013',17000000,1.7,300000),
 ('BS9', N' Nguyễn Thị Xuân',3,N' Y tá ','5-4-1887',0,'2-9-2018',7000000,1.1,2000000),
 ('BS10', N' Phạm Hồng Thái ' ,4,N' Trưởng phòng ','3-27-1873',1,'4-3-2009',30000000,3.0,700000),
 ('BS11', N' Phạm Xuân Tú ',4,N' Phó phòng ','3-29-1863',1,'4-13-2009',25000000,2.0,500000),
 ('BS12', N' Phan Thu Uyên ',4,N' Y tá ','7-21-1863',0,'1-13-2009',10000000,1.7,400000),
 ('BS13', N' Lại Quang Quân ',5,N' Trưởng phòng ','7-29-1863',1,'10-13-2010',25000000,2.7,500000),
 ('BS14', N' Trình Phương Uyên ',5,N' Phó phòng ','9-21-1873',0,'10-1-2010',20000000,1.7,500000),
 ('BS15', N' Nguyên Phương Anh ',5,N' Y tá ','9-21-1883',0,'10-1-2011',7000000,1.3,200000),
 ('BS16', N' Phạm Xuân Anh ',6,N' Trưởng phòng ','9-21-1889',1,'1-7-2011',2000000,2.3,500000),
 ('BS17', N' Nguyễn Kỳ Duyên ',6,N' Phó phòng ','9-29-1873',0,'10-19-2010',17000000,1.7,300000),
 ('BS18', N' Nguyễn Mỹ Duyên',6,N' Y tá ','9-21-1783',0,'10-14-2011',9000000,1.3,200000)
GO
--Nhập dữ liệu cho bảng bệnh án
INSERT INTO dbo.tblBENHAN (sMaHS, sMaBenhNhan, dNgayLapBA,sMaBS,dNgayKhamLai)
VALUES
(   N'BA001',N'BN001','2020-05-09','BS1','2020-05-24'),
(   N'BA002',N'BN002','2021-08-22','BS1','2021-09-10'),
(   N'BA003',N'BN004','2019-07-11','BS2','2019-07-28'),
(   N'BA004',N'BN005','2020-11-03','BS4','2020-11-20'),
(   N'BA005',N'BN008','2020-05-09','BS7','2020-05-25'),
(   N'BA006',N'BN001','2020-05-19','BS3','2020-06-1'),
(   N'BA007',N'BN007','2021-10-11','BS5','2021-10-23'),
(   N'BA008',N'BN010','2020-01-11','BS4','2020-02-01'),
(   N'BA009',N'BN002','2021-08-25','BS8','2021-09-10'),
(   N'BA010',N'BN002','2021-09-05','BS7','2021-09-28'),
(   N'BA011',N'BN006','2021-09-05','BS8','2021-09-25'),
(   N'BA012',N'BN003','20210907','BS9','2021-09-30'),
(   N'BA013',N'BN005','20210911','BS10','2021-10-01')
GO
 --Nhập dữ liệu bảng dịch vụ
INSERT INTO dbo.tblDICHVU ( sMaDV, sTenDV, fGiaThanh)
VALUES
(   N'DV001', N'Xét nghiệm máu', 40000.0),
(   N'DV002', N'Khám Da liễu', 	200000),
(   N'DV003', N'Khám tổng quát', 15000000.0),
(   N'DV004', N'Khám Mắt', 200000.0),
(   N'DV005', N'Khám Nam khoa', 300000.0),
(   N'DV006', N'TPT tế bào máu ngoại vi ', 500000.0),
(   N'DV007', N'Khám Tai mũi họng', 200000.0),
(   N'DV008', N'Test nhanh covid-19', 200000.0),
(   N'DV009', N'Định nhóm máu ABO', 800000.0),
(   N'DV010', N'HIV Ab miễn dịch tự động', 250000.0),
(   N'DV011', N'HBeAg test nhanh', 210000.0),
(   N'DV012', N'Chụp cộng hưởng từ động mạch', 1200000.0),
(   N'DV013', N'Chụp cộng hưởng từ khớp', 2000000.0),
(   N'DV014', N'Nội soi đại tràng', 3000000.0),
(   N'DV015', N'Siêu âm 2D ', 200000.0)
GO
--Nhập dữ liệu cho bảng đơn thuốc
 INSERT INTO tblDONTHUOC (sMaDT,sMaBacSy,sMaHS,dNgayLap)
  VALUES
 ('DT01','BS1','BA001', '20200509'),
 ('DT02','BS2','BA002', '20210822'),
 ('DT03','BS3','BA003', '20190711'),
 ('DT04','BS4','BA004', '20201103'),
 ('DT05','BS5','BA005', '20200509'),
 ('DT06','BS6','BA006', '20200519'),
 ('DT07','BS7','BA007', '20211011'),
 ('DT08','BS1','BA008', '20200111'),
 ('DT09','BS9','BA009', '20210825'),
 ('DT010','BS10','BA010', '20210905'),
 ('DT011','BS11','BA011', '20210905'),
 ('DT012','BS12','BA012', '20210907'),
 ('DT013','BS13','BA013', '20210911')
 GO
 --Nhập dữ liệu cho bảng thuốc
INSERT INTO dbo.tblTHUOC ( sMaThuoc, sTenThuoc, fSLuong, sCachDung, fGiaTien, sDangThuoc, dHanSD )
 VALUES
 (  'T01', N'Thuốc Paracetamol', 100, N'Uống 1 viên Paracetamol 500mg/ lần mỗi 4 – 6 giờ. Uống thuốc liên tục 5 đến 7 ngày', 32.000, N'Viên', '01-01-2022' ),
 (  'T02', N'Thuốc Hoạt huyết Phục cốt hoàn', 100, N'Người trên 15 tuổi: Uống từ 12 – 14 viên/ngày và chia thành 2 lần. ', 302.000, N'Viên', '05-05-2022' ),
 (  'T03', N'Thuốc Glucosamine Orihiro', 200, N'Mỗi ngày nên uống 10 viên, uống làm 2 lần sau các bữa ăn.', 82.000, N'Viên', '09-10-2022' ),
 (  'T04', N'Thuốc PENICILLIN', 100, N'Uống 1 viên Viên Bổ Phổi Bảo Khí Khang mỗi ngày.Uống thuốc liên tục 5 đến 7 ngày', 186.000, N'Viên', '07-01-2022' ),
 (  'T05', N'Thuốc Bổ Regatonicl', 200, N'Uống 2 lần mỗi lần 1 viên. Uống thuốc liên tục 5 đến 7 ngày', 120.000, N'Viên', '12-11-2022' ),
 (  'T06', N'Thuốc An Trĩ Vương', 100, N'Uống 1 viên An Trĩ Vương 500mg/ lần mỗi 4 – 6 giờ. Uống thuốc liên tục 15 ngày', 132.000, N'Viên', '11-07-2022' ),
 (  'T07', N'Thuốc Multivitamin ALVITYL', 300, N'Uống 2 viên vào sáng và tối . Uống thuốc liên tục 30 ngày', 102.000, N'Viên', '03-01-2022' ),
 (  'T08', N'Thuốc An Hầu Đan', 50, N'Uống 1 viên vào trưa. Uống thuốc liên tục 7 ngày', 932.000, N'Viên', '12-12-2022' ),
 (  'T09', N'Thuốc bổ Cebraton', 400, N'Uống 2 viên mỗi buổi sáng và trưa . Uống thuốc liên tục 3 tháng ', 92.000, N'Viên', '10-15-2022' ),
 (  'T10', N'Thuốc bổ Otiv', 100, N'Uống 1 viên mỗi ngày vào buổi trưa. Uống thuốc liên tục 15 ngày', 530.000, N'Viên', '11-11-2022' );
 GO
 --Nhập dữ liệu bảng đơn thuốc_thuốc
 INSERT INTO dbo.tblDONTHUOC_THUOC ( sMaDT, sMaThuoc, iSoLuong, fLieuDung, sCachDung )
 VALUES
 (   'DT01', 'T01', 1, 3, N' Uống 1 viên Paracetamol 500mg/ lần mỗi 4 – 6 giờ. Uống thuốc liên tục 5 đến 7 ngày'  ),
 (   'DT02', 'T03', 1, 20, N' Mỗi ngày nên uống 10 viên, uống làm 2 lần sau các bữa ăn'  ),
 (   'DT03', 'T01', 2, 3, N' Uống 1 viên Paracetamol 500mg/ lần mỗi 4 – 6 giờ. Uống thuốc liên tục 15 ngày'  ),
 (   'DT04', 'T04', 1, 1, N' Uống 1 viên Viên Bổ Phổi Bảo Khí Khang mỗi ngày.Uống thuốc liên tục 5 đến 7 ngày'  ),
 (   'DT05', 'T05', 1, 2, N' Uống 2 lần mỗi lần 1 viên. Uống thuốc liên tục 5 đến 7 ngày'  ),
 (   'DT06', 'T06', 1, 3, N' Uống 1 viên An Trĩ Vương 500mg/ lần mỗi 4 – 6 giờ. Uống thuốc liên tục 15 ngày'  ),
 (   'DT07', 'T07', 1, 2, N' Uống 2 viên vào sáng và tối . Uống thuốc liên tục 30 ngày'  ),
 (   'DT08', 'T08', 1, 1, N' Uống 1 viên vào trưa. Uống thuốc liên tục 7 ngày'  ),
 (   'DT09', 'T09', 3, 2, N' Uống 2 viên mỗi buổi sáng và trưa . Uống thuốc liên tục 3 tháng'  ),
 (   'DT010', 'T09', 4, 2, N' Uống 2 viên mỗi buổi sáng và trưa . Uống thuốc liên tục 4 tháng'  ),
 (   'DT011', 'T09', 2, 1, N' Uống 1 viên mỗi ngày vào buổi trưa. Uống thuốc liên tục 15 ngày'  ),
 (   'DT012', 'T08', 1, 1, N' Uống 1 viên vào trưa. Uống thuốc liên tục 15 ngày'  ),
 (   'DT013', 'T02', 1, 24, N' Uống từ 12 – 14 viên/ngày và chia thành 2 lần'  );
GO

 -------Nhập dữ liệu cho bảng chi tiết dịch vụ 
INSERT INTO dbo.tblCTDV (  sMaDV, iSoP, sMaBS, dNgaySD, sChuanDoan )
 VALUES
 (  'DV001', 1,'BS1',  '20200509', N' Máu nhiễm mỡ'  ),
 (  'DV002', 1,'BS2',  '20200509', N' Viêm da '  ),
 (  'DV003', 3,'BS1' , '20190711', N' Thoái hóa xương cổ '  ),
 (  'DV004', 1,'BS1',  '20201103', N' Viêm mắt '  ),
 (  'DV005',2,'BS4', '20200509', N' Suy não '  ),
 (  'DV006', 1,'BS3',  '20200519', N' Viêm tế bào '  ),
 (  'DV007', 5, 'BS2', '20211011', N' Viêm họng '  ),
 (  'DV008', 6,'BS5',  '20200111', N' Dương tính covid-19 '  ),
 (  'DV009', 6, 'BS7', '20210825', N' Nhiễm HIV '  ),
 (  'DV010', 6,'BS8',  '20210905', N' Dương tính với HIV '  ),
 (  'DV011', 4,'BS5',  '20210905', N' Động mạch không đều '  ),
 (  'DV012', 1,'BS3' , '20210907', N' Viêm khớp gối '  ),
 (  'DV013', 2,'BS2',  '20210911', N' Đại tràng '  ),
 (  'DV014', 2, 'BS2', '20210911', N' Đại tràng '  );
  GO
 
 -------Nhâp bảng hóa đơn dịch vụ
 INSERT INTO dbo.tblHOADONDICHVU (  iSoHD, sMaHS,dNgayLap,fTongtien)
 VALUES
 (  1, 'BA001', '2020-5-4',10000000 ),
 (  2, 'BA002', '2021-08-22',20000000),
 (  3, 'BA003', '2019-07-11',15000000),
 (  4, 'BA004', '2020-11-03',12000000),
 (  5, 'BA005', '2020-05-09',13000000),
 (  6, 'BA006', '2020-05-19',700000),
 (  7, 'BA007', '2021-10-11',8000000),
 (  8, 'BA008', '2020-01-11',9000000),
 (  9, 'BA009', '2021-08-25',10000000),
 (  10, 'BA010', '2021-09-05',5000000),
 (  11, 'BA011', '2021-09-05',900000),
 (  12, 'BA012', '2021-09-07',500000),
 (  13, 'BA013', '2021-09-11',1000000);
 GO
 --TRuy vấn dữ liệu
  ----Lấy dữ liệu từ 1 bảng -----
   /*lấy thông tin bệnh nhân có địa chỉ ở HÀ Nội*/
   select * from dbo.tblBENHNHAN where sdiaChi like N'%Hà Nội'
   /*lấy thông tin các thuốc có giá > 120*/
   select * from dbo.tblTHUOC where fGiatien > 120
   /*lấy thông tin các bác sỹ có hsl >=2*/
   select * from dbo.tblBACSY where fHSLuong >=2 
   /*Lấy thông tin các dịch vụ có giá <=1000000 theo thứ tự giảm dần của giá*/
   select * from dbo.tblDICHVU where fGiaThanh <=1000000 
   order by fGiaThanh Desc 
   /*lấy thông tin 5 bệnh án được lập gần đây nhất*/
   select top 5 with ties  * from dbo.tblBENHAN 
   order by dNgayLapBA DESC 
  -----Lấy dữ liệu từ nhiều bảng (5 câu)-----
    /*Lấy thông tin các bệnh án của bệnh nhân Ngô Văn A*/
	select sMaHS, dNgayLapBA,sMaBS, dNgayKhamLai
	from dbo.tblBENHNHAN inner join dbo.tblBENHAN 
	on tblBENHNHAN.sMaBenhNhan=tblBENHAN.sMaBenhNhan
	where sHoTen like N'%Ngô Văn A'
	
	
    /*cho biết tổng số các dịch vụ mà các bác sỹ đã thực hiện trong 2020*/
	select count (sMaDV) as [ tổng số dịch vụ] 
	from dbo.tblBACSY inner join dbo.tblCTDV
	on tblBacSy.sMaBacSy =tblCTDV.sMaBS
	where year(dNgaySD)=2021
    /*Lấy thông tin các đơn thuốc của bệnh nhân Ngô Văn A*/
	select sMaDT, dNgayLap 
	from dbo.tblDONTHUOC inner join dbo.tblBENHAN
	on tblDONTHUOC.sMaHS=tblBENHAN.sMaHS
	inner join dbo.tblBENHNHAN 
	on tblBENHAN.sMaBenhNhan=tblBENHNHAN.sMaBenhNhan
	where sHoTen like N'%Ngô Văn A'
	/*Lấy thông tin các đơn thuốc mà bác sỹ  Phạm Xuân Tú đã kê*/
  SELECT sMaDT,sMaHS,dNgayLap,sTenBacSy FROM dbo.tblDONTHUOC
LEFT JOIN dbo.tblBACSY ON tblBACSY.sMaBacSy = tblDONTHUOC.sMaBacSy
WHERE sTenBacSy=N' Nguyễn Văn Long '
-------- tạo view-------------
--1.Tạo view chứa thông tin bệnh nhân gồm mã bệnh nhân, tên bệnh nhân,giới tính (nam, nữ), địa chỉ, số điện thoại
create view TT_BenhNhan
as
select sMaBenhNhan, sHoTen, bGioiTinh, sDiaChi,sSDT
FROM DBO.tblBENHNHAN


SELECT* FROM TT_BenhNhan
--2.Tạo view cho biết thong tin bệnh nhân và bệnh án của bệnh nhân trong năm 2021
create view TT_BA_2021a
as
select sMaHS, tblBENHNHAN.sMaBenhNhan ,sHoTen, dNgayLapBA 
from dbo.tblBENHNHAN inner join dbo.tblBENHAN
on tblBENHNHAN.sMaBenhNhan= tblBENHAN.sMaBenhNhan
where year(dNgayLapBA)= 2021


SELECT * FROM TT_BA_2021a



--viết Stored Procedure liệt kê dsach bác sỹ với mã phong truyền vào
create proc sp_dsachBACSY
@MaP INT
AS 
Begin
	Select sMaBacSy,sTenBacSy  
	from dbo.tblBACSY inner join dbo.tblPHONG 
	on tblBACSY.iSoPhong=tblPHONG.iSoPhong
	where tblPHONG.iSophong=@MaP
END
exec dbo.sp_dsachBACSY @MaP=1


----Viết stored proceduce liệt kê dsach tên dịch vụ mà bệnh nhân sử dụng trong năm đươc truyền vào và mã bệnh nhân được truyền vào

create  proc sp_dsachDICHVU
@nam int,
@MaBenhNhan nvarchar(20)
as
begin
   select sTenDV  from dbo.tblBENHNHAN inner join dbo.tblBENHAN on tblBENHNHAN.sMaBenhNhan=tblBENHAN.sMaBenhNhan
   inner join dbo.tblHOADONDICHVU on tblBENHAN.sMaHS=tblHOADONDICHVU.sMaHS
   inner join dbo.tblCTDV on tblHOADONDICHVU.iSoHD=tblCTDV.iSoP
   inner join dbo.tblDICHVU on tblCTDV.sMaDV=tblDICHVU.sMaDV
   where @nam=year(dNgayLapBA) and @MaBenhNhan=tblBENHNHAN.sMaBenhNhan
end
go
exec dbo.sp_dsachDICHVU @nam=2021, @MaBenhNhan=N'BN005'





--viết Stored Procedure sửa giá bản ghi vào thuốc = thuốc *0.75 với những thuốc có tên truyền vào
CREATE PROC sp_Suagiathuoc_Thuoc
@Tenthuoc NVARCHAR(50)
AS  
	BEGIN
	UPDATE dbo.tblTHUOC SET fGiaTien = fGiaTien * 0.75 WHERE sTenThuoc = @Tenthuoc
	END
GO
--viết Stored Procedure  xóa bản ghi bệnh án dịch vụ có tháng và năm truyền vào
CREATE PROC sp_Xoabangghibenhandichvu_BenhAn_DichVu
@Thang INT, @Nam INT
AS
	BEGIN 
	DELETE dbo.tblBENHAN_DICHVU WHERE YEAR(dNgaySD) = @Nam AND MONTH(dNgaySD) = @Thang
	END
GO
USE quanLyKhamBenhBenhVien
GO


/*Cho biết thông tin các dịch vụ đã dùng của BA003*/
SELECT sTenDV,dNgaySD,fGiaThanh FROM dbo.tblBENHAN

LEFT JOIN dbo.tblHOADONDICHVU ON tblHOADONDICHVU.sMaHS = tblBENHAN.sMaHS 
LEFT JOIN dbo.tblCTDV ON tblCTDV.iSoP = tblHOADONDICHVU.iSoHD
LEFT JOIN dbo.tblDICHVU ON tblDICHVU.sMaDV = tblCTDV.sMaDV WHERE tblBENHAN.sMaHS = N'BA003'
GO
/* Tạo view cho biết các thông tin bác sỹ có chức vụ là trưởng phòng : tên bác sỹ, giới tính,ngay sinh,số năm làm việc,tổng lương */
 ALTER VIEW TT_BS(sMaBacSy,tenBS, gioiTinh, ngaySinh, sonamlamviec, tongluong)
 AS
 SELECT dbo.tblBACSY.sMaBacSy,dbo.tblBACSY.sTenBacSy, dbo.tblBACSY.sGioiTinh, dbo.tblBACSY.dNgaySinh, YEAR(GETDATE())- YEAR(dNgayvaolam), fLuongCoBan*fHSLuong +fPhuCap
 FROM dbo.tblBACSY
 WHERE sChucVu=N' Trưởng phòng '

GO
 SELECT * FROM dbo.TT_BS
 SELECT* FROM dbo.tblBACSY
  /* View cho biết tên bệnh nhân và số lần đến khám tại bệnh viện */
  go 
  CREATE VIEW  TT_BN_SOLANKHAM1(TEN,SOLANKHAM)
   AS
   SELECT dbo.tblBENHNHAN.sHoTen, COUNT(dbo.tblBENHAN.sMaBenhNhan)
   FROM dbo.tblBENHNHAN INNER JOIN dbo.tblBENHAN
   ON dbo.tblBENHNHAN.sMaBenhNhan=tblBENHAN.sMaBenhNhan
   GROUP BY sHoTen

   GO
   SELECT * FROM TT_BN_SOLANKHAM1
    


   
/* Tạo view tính hóa đơn dịch vụ của các bệnh nhân năm 2021 */
go 
CREATE VIEW Tongtiendichvu2021a( mabenhnhan,Hoten tongtien)
AS 
SELECT dbo.tblBENHAN.sMaBenhNhan,sHoten, fTongtien= SUM(fTongtien)
FROM dbo.tblBENHAN INNER JOIN dbo.tblHOADONDICHVU ON  tblHOADONDICHVU.sMaHS = tblBENHAN.sMaHS
		
WHERE YEAR(dNgayLap) =2021
GROUP BY sMaBenhNhan
GO


SELECT * FROM Tongtiendichvu2021a

/* Tạo view tính tiền các hóa đơn thuốc của bệnh nhân */
 
   -- tạo view tính hóa đơn tuừng  đơn thuốc của bệnh nhân
   CREATE VIEW hoadonthuoc1(madonthuoc, tongtien)
   AS
   SELECT sMaDT , iSoLuong*fGiaTien
   FROM dbo.tblDONTHUOC_THUOC INNER JOIN dbo.tblTHUOC
   ON tblTHUOC.sMaThuoc = tblDONTHUOC_THUOC.sMaThuoc
    GO 
     SELECT * FROM  hoadonthuoc1
   -- tạo view tính tổng tất cả vào
    ALTER VIEW tongtiendonthuoc2(maBN,TEN, tongtien)
	AS 
	SELECT  dbo.tblBENHAN.sMaBenhNhan, sHoTen,SUM(tongtien) 
    FROM  ((hoadonthuoc INNER JOIN dbo.tblDONTHUOC ON hoadonthuoc.madonthuoc =tblDONTHUOC.sMaDT)
			INNER JOIN dbo.tblBENHAN ON tblBENHAN.sMaHS = tblDONTHUOC.sMaHS)
			INNER JOIN dbo.tblBENHNHAN ON tblBENHAN.sMaBenhNhan = tblBENHNHAN.sMaBenhNhan
			

	GROUP BY dbo.tblBENHAN.sMaBenhNhan,sHoTen
	go
	
	 SELECT * FROM tongtiendonthuoc2
	 SELECT * FROM  hoadonthuoc
     SELECT * FROM dbo.tblBENHAN
	SELECT * FROM dbo.tblDONTHUOC
	  SELECT * FROM dbo.tblTHUOC

 

   
/* Tạo view tính tổng tiền khám và tiền hóa đơn thuốc của bệnh nhân */

  SELECT * FROM dbo.tblDICHVU
  SELECT * FROM dbo.tblHOADONDICHVU
  SELECT * FROM dbo.tblBENHAN
  SELECT * FROM tongtiendonthuoc
  go 
   ---- tạo view tính tổng tiền hóa đơn dịch vụ
   CREATE VIEW  TIEN_HDDV1(maBN, tien)
   AS
   SELECT sMaBenhNhan,SUM(fTongtien)
   FROM dbo.tblBENHAN INNER JOIN dbo.tblHOADONDICHVU
   ON tblHOADONDICHVU.sMaHS = tblBENHAN.sMaHS
   GROUP BY sMaBenhNhan
    SELECT * FROM TIEN_HDDV1
	 SELECT * FROM tongtiendonthuoc
	 go 
	 --- TẠO VIEW TÍNH TỔNG TIỀN HÓA ĐƠN VÀ THUỐC CỦA BỆNH NHÂN
	  CREATE VIEW  TONGTIENDICHVU_THUOC( maBN, Tongtien)
	  AS
      SELECT  TIEN_HDDV.maBN, TIEN_HDDV.tien+ tongtiendonthuoc.tongtien
      FROM tongtiendonthuoc INNER JOIN  TIEN_HDDV
	  ON tongtiendonthuoc.maBN =TIEN_HDDV.maBN
	  SELECT * FROM TONGTIENDICHVU_THUOC


go
/* Tạo view lấy ra 5 người có hóa đơn viện phí cao nhất */
   ALTER VIEW HOADONVIENPHI(ten, maBN,tongtien)
   AS 
   SELECT TOP 5  sHoTen,sMaBenhNhan,TONGTIENDICHVU_THUOC.Tongtien
   FROM dbo.tblBENHNHAN INNER JOIN TONGTIENDICHVU_THUOC
   ON tblBENHNHAN.sMaBenhNhan =TONGTIENDICHVU_THUOC.maBN
   ORDER BY TONGTIENDICHVU_THUOC.Tongtien DESC

   SELECT * FROM TONGTIENDICHVU_THUOC
   SELECT* FROM HOADONVIENPHI
/* Danh sách bệnh nhân ở phòng khám 1 */
SELECT * FROM dbo.tblBENHNHAN
SELECT * FROM dbo.tblBENHAN
SELECT * FROM dbo.tblBACSY
go
CREATE VIEW BENHNHAN_PHONG1( MaBN)
AS
SELECT sMaBenhNhan
FROM ( dbo.tblBACSY INNER JOIN dbo.tblBENHAN ON tblBENHAN.sMaBS = tblBACSY.sMaBacSy ) 
WHERE  dbo.tblBACSY.iSoPhong =1
 SELECT * FROM BENHNHAN_PHONG1
 GO

/* Số bệnh nhân đã được bác sĩ điều trị */
CREATE VIEW vw_BenhNhan_BacSy1 AS
SELECT sMaBacSy, sTenBacSy, COUNT(tblBENHAN.sMaBenhNhan) AS 'Số bệnh nhân' FROM dbo.tblBENHNHAN INNER JOIN dbo.tblBENHAN

ON tblBENHAN.sMaBenhNhan = tblBENHNHAN.sMaBenhNhan RIGHT JOIN dbo.tblBACSY ON tblBACSY.sMaBacSy = tblBENHAN.sMaBS GROUP BY sMaBacSy, sTenBacSy
GO
SELECT * FROM vw_BenhNhan_BacSy1

/* Số loại thuốc mà mỗi bệnh nhân đã mua */
SELECT* FROM dbo.tblDONTHUOC
SELECT * FROM dbo.tblDONTHUOC_THUOC
SELECT * FROM dbo.tblBENHAN
 go 
 ALTER VIEW  SOTHUOCBENHNHANMUA (maBN, sothuoc)
 AS
 SELECT sMaBenhNhan, SUM(iSoLuong) 
 FROM (dbo.tblDONTHUOC_THUOC INNER JOIN dbo.tblDONTHUOC ON tblDONTHUOC.sMaDT = tblDONTHUOC_THUOC.sMaDT) 
								 INNER JOIN dbo.tblBENHAN 
								 ON tblBENHAN.sMaHS=dbo.tblDONTHUOC.sMaHS
 GROUP BY sMaBenhNhan 
 
 SELECT * FROM SOTHUOCBENHNHANMUA
 SELECT* FROM dbo.tblDONTHUOC
SELECT * FROM dbo.tblDONTHUOC_THUOC
SELECT * FROM dbo.tblBENHAN

/* Số dịch vụ mà bệnh nhân đã thực hiện */
SELECT * FROM dbo.tblHOADONDICHVU
SELECT * FROM dbo.tblBENHAN
GO
CREATE VIEW SDICHVU( MaBN, SODICHVU)
AS
SELECT sMaBenhNhan, COUNT(tblBENHAN.sMaBenhNhan)
FROM  dbo.tblBENHAN INNER JOIN dbo.tblHOADONDICHVU
ON tblBENHAN.sMaHS = tblHOADONDICHVU.sMaHS 
group by sMaBenhNhan
 SELECT * FROM SDICHVU
/* Danh sách những loại*/


--Viết Stored Procedure thêm bản ghi vào bệnh nhân
go
CREATE  PROCEDURE INSERT_BENHNHAN
@sMaBenhNhan NVARCHAR(20) ,@sHoTen NVARCHAR(30) ,	@sDiaChi NVARCHAR(50) ,	@dNgaySinh DATETIME ,	@bGioiTinh BIT ,	@sSDT nvarchar(12) 

AS
BEGIN
	IF EXISTS(SELECT * FROM dbo.tblBENHNHAN WHERE sMaBenhNhan=@sMaBenhNhan)
		BEGIN
			PRINT N'bệnh nhân này đã có, nhập mã khác'
			RETURN -1
		END
	
	INSERT INTO dbo.tblBENHNHAN
	VALUES (@sMaBenhNhan  ,@sHoTen  ,	@sDiaChi  ,	@dNgaySinh  ,	@bGioiTinh  ,	@sSDT )
END
 
EXEC INSERT_BENHNHAN 'BN015','Nguyen Thanh Cong', 'y yen - nam dinh','2002-05-06',1,'0332831072'
SELECT * FROM tblBENHNHAN
GO


-- viết procedure xóa bệnh nhân có mã nhập vào
CREATE  PROCEDURE DELETE_BENHNHAN1
	@sMaBenhNhan NVARCHAR(20)
as
BEGIN
	IF NOT EXISTS (SELECT * FROM dbo.tblBENHNHAN WHERE sMaBenhNhan=@sMaBenhNhan)
		BEGIN
			PRINT N'BỆNH NHÂN NÀY KHÔNG TỒN TẠI'
			RETURN -1
		END
		DELETE FROM dbo.tblBENHNHAN WHERE sMaBenhNhan=@sMaBenhNhan
		PRINT N'Xoá thành công'
END
EXEC DELETE_BENHNHAN1 'BN015'


GO




--Viết procedure update thông tin bệnh nhân có mã chỉ định
CREATE  PROCEDURE UPDATE_BENHNHAN
 @sMaBenhNhan NVARCHAR(20) ,@sHoTen NVARCHAR(30) ,	@sDiaChi NVARCHAR(50) ,	@dNgaySinh DATETIME ,	@bGioiTinh BIT ,	@sSDT nvarchar(12) 
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM dbo.tblBENHNHAN WHERE sMaBenhNhan = @sMaBenhNhan)
		BEGIN
			PRINT N'BỆNH NHÂN NÀY KHÔNG TỒN TẠI'
			RETURN -1
		END
	UPDATE dbo.tblBENHNHAN SET sHoTen=@sHoTen,sDiaChi=@sDiaChi,
								dNgaySinh=@dNgaySinh,bGioiTinh=@bGioiTinh, sSDT=@sSDT
	WHERE sMaBenhNhan=@sMaBenhNhan
	PRINT N'CẬP NHÂN THÔNG TIN THÀNH CÔNG'
END
EXEC UPDATE_BENHNHAN 'BN011','THANH CONG NE', 'y yen - nam dinh','2002-05-06',1,'0332831072'
SELECT * FROM tblBENHNHAN
GO

-- viết Stored Procedure hiện thông tin bệnh nhân có mã nhập vào
	CREATE   PROCEDURE SELECT_BENHNHAN
	@sMaBenhNhan NVARCHAR(20)
as
BEGIN
	IF NOT EXISTS (SELECT * FROM dbo.tblBENHNHAN WHERE sMaBenhNhan=@sMaBenhNhan)
		BEGIN
			PRINT N'BỆNH NHÂN NÀY KHÔNG TỒN TẠI'
			RETURN -1
		END
		SELECT * FROM dbo.tblBENHNHAN WHERE sMaBenhNhan=@sMaBenhNhan
		
END
EXEC SELECT_BENHNHAN 'BN010'

GO




--viết store procedure in ra thông tin bác sĩ khi nhập vào mã phòng
	CREATE   PROCEDURE SELECT_BACSY
	@iSoPhong NVARCHAR(20)
as
BEGIN
	IF NOT EXISTS (SELECT * FROM dbo.tblBACSY WHERE iSoPhong=@iSoPhong)
		BEGIN
			PRINT N'PHÒNG NÀY KHÔNG TỒN TẠI'
			RETURN -1
		END
		SELECT sMaBacSy,sTenBacSy  FROM dbo.tblBACSY WHERE iSoPhong=@iSoPhong
		
END
EXEC SELECT_BACSY '2'


SELECT * FROM tblBACSY
GO




--Viết Stored Procedure thêm bản ghi vào dịch vụ
 create procedure INSERT_DICHVU 
	@sMaDV NVARCHAR(20) , @sTenDV NVARCHAR(50) ,@fGiaThanh FLOAT 
AS
BEGIN 
	IF EXISTS (SELECT *from dbo.tblDICHVU WHERE  sMaDV= @sMaDV)
		begin 
			print N'dịch vụ này đã tồn tại'
			return -1
		end
	INSERT INTO dbo.tblDICHVU
	VALUES(@sMaDV  , @sTenDV  ,@fGiaThanh )
END

EXEC INSERT_DICHVU 'DV016',N'xét nghiệm tiểu đường','500000'
SELECT * FROM dbo.tblDICHVU




--Viết Stored Procedure thêm bản ghi vào bác sỹ
go
CREATE PROCEDURE INSERT_BACSY
	@sMaBacSy NVARCHAR(20),@sTenBacSy NVARCHAR(30),@iSoPhong INT,@sChucVu NVARCHAR(50),@dNgaySinh DATETIME,@sGioiTinh BIT
	,@dNgayvaolam DATETIME,@fLuongCoBan FLOAT,@fHSLuong FLOAT ,@fPhuCap FLOAT
AS
BEGIN
	IF EXISTS (SELECT * FROM tblBACSY WHERE sMaBacSy=@sMaBacSy)
		BEGIN
			PRINT N'BÁC SỸ ĐÃ TỒN TẠI'
			RETURN -1
		END
	INSERT INTO dbo.tblBACSY
	VALUES(@sMaBacSy ,@sTenBacSy,@iSoPhong ,@sChucVu ,@dNgaySinh ,@sGioiTinh ,@dNgayvaolam ,@fLuongCoBan ,@fHSLuong  ,@fPhuCap )
END

EXEC INSERT_BACSY 'BS100',N'nguyễn thành công','1','Y tá','1995-06-07','1','2015-07-08','2500000','2.3','500000'
SELECT *FROM tblBACSY




--Viết Stored Procedure  thêm bản ghi vào thuốc
CREATE PROCEDURE INSERT_THUOC
	@sMaThuoc NVARCHAR(20) ,@sTenThuoc NVARCHAR(50),@fSLuong INT,@sCachDung NVARCHAR(100),@fGiaTien FLOAT,@sDangThuoc NVARCHAR(50),@dHanSD DATETIME 
AS
BEGIN
	IF EXISTS (SELECT * FROM dbo.tblTHUOC WHERE sMaThuoc=@sMaThuoc)
		BEGIN
			PRINT N'THUỐC ĐÃ TỒN TẠI'
			RETURN -1
		END
	INSERT INTO dbo.tblTHUOC
	VALUES (@sMaThuoc  ,@sTenThuoc ,@fSLuong ,@sCachDung ,@fGiaTien ,@sDangThuoc ,@dHanSD  )
END

EXEC INSERT_THUOC 'T13',N'ĐAU BỤNG','400',N'ngày 2 viên sáng tối sau ăn','100000',N'viên','2030-07-09'

SELECT *FROM tblTHUOC
-----------------------------------------------------------------------------------

--Xử lý tăng lương 10% cho các nhân viên (thủ tục không có tham số)

create view TONGLUONGBACSY (MaBacSi,TenBacSi,TongLuong)
as
select dbo.tblBACSY.sMaBacSy, dbo.tblBACSY.sTenBacSy,fLuongCoBan*fHSLuong +fPhuCap
from dbo.tblBACSY
select * from TONGLUONGBACSY

select * from tblBACSY



--Tạo thủ tục

CREATE PROC Tang_luong
AS   
    UPDATE TONGLUONGBACSY SET TongLuong = TongLuong * 1.1
GO
EXEC Tang_luong
----------------------------
--Xử lý tăng lương x% cho các nhân viên (thủ tục có tham số)
--Tạo thủ tục
go
CREATE PROC Tang_luong
		@Phan_tram int
AS
    DECLARE @Ty_le decimal(3,1) = 1 + @Phan_tram / 100
    UPDATE TONGLUONGBACSY  SET TongLuong = TongLuong * @Ty_le
GO
--Gọi thực hiện thủ tục
EXEC Tang_luong @Phan_tram = 10

-----------------------------------------------------------------------------------
go
-- trigger tự động giảm số lượng thuốc khi có đơn thuốc mới khi số lượng k đủ thì thông báo vi phạm

 create trigger tudonggiamthuoc
 on dbo.tblDONTHUOC_THUOC 
 for insert
 as
 begin 
		declare @soluongcon int;
		declare @soluongban int;
		declare @sMaThuoc CHAR(20)
		select @sMaThuoc =sMaThuoc, @soluongban = iSoLuong 
		from inserted
		select @soluongcon = fSLuong 
		from  dbo.tblTHUOC 
		where @sMaThuoc=  sMaThuoc;
		if(@soluongban >@soluongcon)
			begin
				print 'so luong thuoc khong du'
				rollback transaction 
			end
		else
			begin
				update dbo.tblTHUOC 
				set fSLuong =fSLuong-@soluongban 
				from  dbo.tblTHUOC 
				where @sMaThuoc=  sMaThuoc;
			end
 end
 INSERT INTO dbo.tblBENHAN (sMaHS, sMaBenhNhan, dNgayLapBA,sMaBS,dNgayKhamLai)
VALUES
(   N'BA333',N'BN001','2020-05-09','BS1','2020-05-24')
 INSERT INTO tblDONTHUOC (sMaDT,sMaBacSy,sMaHS,dNgayLap)
  VALUES
 ('DT333','BS1','BA333', '20200509')
insert into tblDONTHUOC_THUOC ( sMaDT, sMaThuoc, iSoLuong, fLieuDung, sCachDung )
values (   'DT333', 'T01', 300, 3, N' Uống 1 viên Paracetamol 500mg/ lần mỗi 4 – 6 giờ. Uống thuốc liên tục 5 đến 7 ngày'  )
select * from tblTHUOC
 GO 


 -- trigger xóa bác sĩ

CREATE  TRIGGER xoabacsi
ON dbo.tblBACSY
FOR DELETE
AS 
BEGIN
	DECLARE @MaBacSy CHAR (20)
	 SELECT @MaBacSy =sMaBacSy 
	 FROM Deleted
		IF  EXISTS( SELECT * FROM dbo.tblBACSY WHERE @MaBacSy =sMaBacSy)
			BEGIN

			    PRINT'Bac si nay khong ton tai'
				ROLLBACK TRANSACTION
			END
		ELSE 
		DELETE dbo.tblBACSY WHERE  @MaBacSy =sMaBacSy
		
END
DELETE dbo.tblBACSY WHERE sMaBacSy='100'
CREATE LOGIN quanlybenhnhan
WITH PASSWORD ='1234'
GO
CREATE LOGIN quanlydichvu
WITH PASSWORD ='1234'
GO
 --tạo tài khoản quanlydonthuoc
 CREATE LOGIN quanlydonthuoc
WITH PASSWORD ='1234'
GO
 --tạo tài khoản quanlybacsy
 CREATE LOGIN quanlybacsy
WITH PASSWORD ='1234'
GO
--tạo tài khoản quanlybenhanh
CREATE USER quanlybenhnhanh
FROM LOGIN quanlybenhnhan
WITH DEFAULT_SCHEMA = quanLyKhamBenh
GO
--tạo tài khoản qualydichvu
CREATE USER quanlydichvu
FROM LOGIN quanlydichvu
WITH DEFAULT_SCHEMA = quanLyKhamBenh
GO
--tạo user quanlydonthuoc
CREATE USER quanlydonthuoc
FROM LOGIN quanlydonthuoc
WITH DEFAULT_SCHEMA = quanLyKhamBenh
GO
--tạo tài khoản quanlybacsy
CREATE USER qlbacsy
FROM LOGIN quanlybacsy
WITH DEFAULT_SCHEMA = quanLyKhamBenh
GO



--Tạo role  quanlybenhnhan
CREATE ROLE quanlybenhnhan
--cho phép thêm sửa xóa xem bảng bệnh nhân, bệnh án
GRANT INSERT, UPDATE, DELETE, SELECT ON dbo.tblBENHAN TO quanlybenhnhan
GRANT INSERT, UPDATE, DELETE, SELECT ON dbo.tblBENHNHAN TO quanlybenhnhan
--cho phép thêm sửa xóa xem trên bảng hóa đơn dịch vụ và bảng chi tiết dịch vụ
GRANT INSERT, UPDATE, DELETE, SELECT ON dbo.tblHOADONDICHVU TO quanlybenhnhan
GRANT INSERT, UPDATE, DELETE, SELECT ON dbo.tblCTDV TO quanlybenhnhan
--cho phép thêm sửa xóa xem trên bảng đơn thuốc và đơn thuốc thuốc
GRANT INSERT, UPDATE, DELETE, SELECT ON dbo.tblDONTHUOC TO quanlybenhnhan
GRANT INSERT, UPDATE, DELETE, SELECT ON dbo.tblDONTHUOC_THUOC TO quanlybenhnhan
--cho phép thêm sửa xóa xem trên bảng bác sỹ phòng
GRANT INSERT, UPDATE, DELETE, SELECT ON dbo.tblBACSY TO quanlybenhnhan



--Tạo role quanlybacsy 
create role quanlybacsy
--cho phép thêm sửa xóa xem bảng bác sỹ, phòng
grant insert, update, delete, select, execute  on tblPHONG to quanlybacsy
grant insert, update, delete, select, execute on tblBACSY to quanlybacsy

--thu hồi quyền sửa xóa của role quanlybenhnhan trên bảng thuốc, bác sỹ
deny update, delete on tblTHUOC to quanlybenhnhan
deny update, delete on tblBACSY to quanlybenhnhan
--cấm quyền sửa xóa của role quanlybenhnhan trên bảng dịch vụ,đơn thuốc,hóa đơn dịch vụ, chi tiết dịch vụ
revoke update, delete on tblDICHVU to quanlybenhnhan
revoke update, delete on tblDONTHUOC to quanlybenhnhan
revoke update, delete on tblHOADONDICHVU to quanlybenhnhan
revoke update, delete on tblCTDV to quanlybenhnhan



 












