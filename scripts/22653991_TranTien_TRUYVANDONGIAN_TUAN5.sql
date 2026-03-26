-- Họ tên: Trần Tiến
-- MSSV: 22653991

USE Northwind;

--Viết lệnh thực hiện các truy vấn sau :
--1.  Liệt kê danh sách tất cả các mặt hàng (Products).
SELECT p.* FROM Products p;

--2.  Liệt  kê  danh  sách  tất  cả  các  mặt  hàng  (Products).  Thông  tin  bao  gồm 
--ProductID, ProductName, UnitPrice.
SELECT 
	p.ProductID,
	p.ProductName,
	p.UnitPrice
FROM Products p;

--3.  Liệt  kê  danh  sách  các  nhân  viên  (Employees).  Thông  tin  bao  gồm 
--EmployeeID,  EmployeeName,  Phone,  Age.  Trong  đó  EmployeeName 
--được  ghép từ  LastName  và  FirstName;  Age là  tuổi  được  tính  dựa  trên
--năm hiện hành (GetDate()) và năm sinh.
SELECT 
	e.EmployeeID,
	e.FirstName + ' ' + e.LastName AS EmployeeName,
	e.HomePhone AS Phone,
	YEAR(GETDATE()) - YEAR(e.BirthDate) as Age
FROM Employees e;

--4.  Liệt  kê  danh  sách  các  khách  hàng  (Customers)  mà  người  đại  diện  có
--ContactTitle  bắt  đầu  bằng  chữ  ‘O’.  Thông  tin  bao  gồm  CustomerID, 
--CompanyName, ContactName, ContactTitle, City, Phone.
SELECT
	c.CustomerID,
	c.CompanyName,
	c.ContactName,
	c.ContactTitle,
	c.City,
	c.Phone
FROM Customers c
WHERE c.ContactTitle LIKE 'O%';

--5.  Liệt kê danh sách  khách hàng (Customers)  ở thành phố LonDon, Boise 
--và Paris.
SELECT c.*
FROM Customers c
WHERE c.City IN ('LonDon', 'Boise', 'Paris');

--6.  Liệt kê danh sách khách hàng (Customers) có tên bắt đầu bằng chữ V mà 
--ở thành phố Lyon.
SELECT c.*
FROM Customers c
WHERE c.CompanyName LIKE 'V%' AND c.City = 'Lyon';

--7.  Liệt kê danh sách các khách hàng (Customers) không có số fax.
SELECT c.*
FROM Customers c
WHERE c.Fax IS NULL;

--8.  Liệt kê danh sách các khách hàng (Customers) có số Fax.
SELECT c.*
FROM Customers c
WHERE c.Fax IS NOT NULL;

--9.  Liệt kê danh sách nhân viên (Employees) có năm sinh <=1960
SELECT e.*
FROM Employees e
WHERE YEAR(e.BirthDate) <= 1960;

--10.  Liệt kê danh sách các  sản phẩm (Products)  có  chứa chữ  ‘Boxes’ trong 
--cột QuantityPerUnit. 
SELECT p.*
FROM Products p
WHERE p.ProductName LIKE '%Boxes%';

--11.  Liệt  kê  danh  sách  các  mặt  hàng  (Products)  có  đơn  giá  (Unitprice)  lớn 
--hơn 10 và nhỏ hơn 15. 
SELECT p.*
FROM Products p
WHERE p.UnitPrice BETWEEN 11 AND 14;

--12.  Liệt kê danh sách các mặt hàng (Products) có số lượng tồn nhỏ hơn 5.
SELECT p.*
FROM Products p
WHERE p.UnitsInStock < 5;

--13.  Liệt kê danh sách các  mặt hàng  (Products)  ứng với tiền tồn vốn. Thông 
--tin  bao  gồm  ProductId,  ProductName,  Unitprice,  UnitsInStock,  Total. 
--Trong đó Total= UnitsInStock*Unitprice.  Được sắp xếp theo Total  giảm 
--dần.
SELECT 
	p.ProductID,
	p.ProductName,
	p.UnitPrice,
	p.UnitsInStock,
	p.UnitsInStock * p.UnitPrice AS Total
FROM Products p
ORDER BY Total DESC;

--14.  Hiển thị thông tin OrderID, OrderDate, CustomerID, EmployeeID của 2 
--hóa đơn có mã OrderID là ‘10248’ và ‘10250’
SELECT
	o.OrderID,
	o.OrderDate,
	o.CustomerID,
	o.EmployeeID
FROM Orders o
WHERE o.OrderID IN (10248, 10250);

--15.  Liệt  kê  chi  tiết  của  hóa  đơn  có  OrderID  là  ‘10248’.  Thông  tin  gồm 
--OrderID,  ProductID,  Quantity,  Unitprice,  Discount,  ToTalLine  = 
--Quantity * unitPrice *(1-Discount) 
SELECT
	d.OrderID,
	d.ProductID,
	d.Quantity,
	d.UnitPrice,
	d.Discount,
	d.Quantity * d.UnitPrice * (1 - d.Discount) AS ToTalLine
FROM [Order Details] d
WHERE d.OrderID = 10248;

--16.  Liệt  kê  danh  sách  các  hóa  đơn  (orders)  có  OrderDate  được  lập  trong 
--tháng 9 năm 1996.  Được sắp xếp theo mã khách hàng, cùng mã  khách 
--hàng sắp xếp theo ngày lập hóa đơn giảm dần. 
SELECT o.*
FROM Orders o
WHERE MONTH(o.OrderDate) = 9 AND YEAR(o.OrderDate) = 1996
ORDER BY o.CustomerID DESC, o.OrderDate DESC;

--17.  Liệt kê danh sách các hóa đơn (Orders) được lập trong quý 4 năm 1997. 
--Thông  tin  gồm  OrderID,  OrderDate,  CustomerID,  EmployeeID.  Được 
--sắp xếp theo tháng của ngày lập hóa đơn.
SELECT 
	o.OrderID,
	o.OrderDate,
	o.CustomerID,
	o.EmployeeID
FROM Orders o
WHERE MONTH(o.OrderDate) IN (10, 11, 12) AND YEAR(o.OrderDate) = 1997
ORDER BY MONTH(o.OrderDate) DESC;

--18.  Liệt kê danh sách các hóa đơn (Orders) được lập trong trong ngày thứ 7 
--và chủ nhật của tháng 12 năm 1997. Thông tin gồm OrderID, OrderDate, 
--Customerid,  EmployeeID,  WeekDayOfOrdate  (Ngày  thứ  mấy  trong 
--tuần). 
SELECT 
	o.OrderID,
	o.OrderDate,
	o.CustomerID,
	o.EmployeeID,
	DATENAME(WEEKDAY, o.OrderDate) AS WeekDayOfOrdate
FROM Orders o
WHERE 
	MONTH(o.OrderDate) = 12 AND 
	YEAR(o.OrderDate) = 1997 AND 
	DATENAME(WEEKDAY, o.OrderDate) IN ('Saturday', 'Sunday')
ORDER BY MONTH(o.OrderDate) DESC;

--19.  Liệt kê danh sách 5 customers có city có ký tự bắt đầu  ‘M’.
SELECT TOP 5 c.*
FROM Customers c
WHERE c.City LIKE 'M%';

--20.  Liệt  kê  danh  sách  2  employees  có  tuổi  lớn  nhất.  Thông  tin  bao  gồm 
--EmployeeID,  EmployeeName,  Age.  Trong  đó,  EmployeeName  được 
--ghép từ LastName và FirstName; Age là tuổi.
SELECT TOP 2
	e.EmployeeID,
	e.FirstName + ' ' + e.LastName AS EmployeeName,
	YEAR(GETDATE()) - YEAR(e.BirthDate) AS Age
FROM Employees e
ORDER BY Age DESC;
