/*
Ho ten: Tran Tien
MSSV: 22653991
*/

--BÀI TẬP 2: LỆNH SELECT – TRUY VẤN CÓ KẾT NỐI
use Northwind;

--1.  Hiển  thị  thông  tin  về  hóa  đơn  có  mã  ‘10248’,  bao  gồm:  OrderID, 
--OrderDate,  CustomerID,  EmployeeID,  ProductID,  Quantity,  Unitprice, 
--Discount.
SELECT
	o.OrderID,
	o.OrderDate,
	o.CustomerID,
	o.EmployeeID,
	d.ProductID,
	d.Quantity,
	d.UnitPrice,
	d.Discount
FROM Orders o
JOIN [Order Details] d ON d.OrderID = o.OrderID
WHERE o.OrderID = 10248;

--2.  Liệt  kê  các  khách  hàng  có  lập  hóa  đơn  trong  tháng  7/1997  và  9/1997. 
--Thông  tin  gồm  CustomerID,  CompanyName,  Address,  OrderID, 
--Orderdate. Được sắp xếp theo CustomerID, cùng CustomerID thì sắp xếp 
--theo OrderDate giảm dần.
SELECT
	c.CustomerID,
	c.CompanyName,
	c.Address,
	o.OrderID,
	o.OrderDate
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE MONTH(o.OrderDate) IN (7, 9) AND YEAR(o.OrderDate) = 1997
ORDER BY c.CustomerID, o.OrderDate DESC;

--3.  Liệt kê danh sách các  mặt hàng  xuất bán vào ngày 19/7/1996. Thông tin 
--gồm : ProductID, ProductName, OrderID, OrderDate, Quantity.
SELECT
	p.ProductID,
	p.ProductName,
	o.OrderID,
	o.OrderDate,
	d.Quantity
FROM Products p
JOIN [Order Details] d ON d.ProductID = p.ProductID
JOIN Orders o ON o.OrderID = d.OrderID
WHERE o.OrderDate = '1996-07-19';

--4.  Liệt kê danh sách các mặt hàng từ nhà cung cấp (supplier) có mã 1,3,6 và
--đã  xuất  bán  trong  quý  2  năm  1997.  Thông  tin  gồm  :  ProductID, 
--ProductName,  SupplierID,  OrderID,  Quantity.  Được  sắp  xếp  theo  mã 
--nhà  cung  cấp  (SupplierID),  cùng  mã  nhà  cung  cấp  thì  sắp  xếp  theo 
--ProductID.
SELECT 
	p.ProductID, 
	p.ProductName,  
	p.SupplierID,  
	o.OrderID,  
	d.Quantity
FROM Products p 
JOIN [Order Details] d ON P.ProductID = d.ProductID 
JOIN Orders O ON O.OrderID = d.OrderID
WHERE p.SupplierID IN (1,3,6) AND DATEPART(QQ, o.OrderDate) = 2 AND YEAR(o.OrderDate) = 1997
ORDER BY p.SupplierID, p.ProductID;

--5.  Liệt kê danh sách các mặt hàng có đơn giá bán bằng đơn giá mua.
SELECT p.*
FROM Products p
JOIN [Order Details] d ON d.ProductID = p.ProductID
WHERE p.UnitPrice = d.UnitPrice;

--6.  Danh sách các mặt hàng  bán trong ngày thứ 7 và chủ nhật của tháng 12 
--năm 1996, thông tin gồm ProductID, ProductName, OrderID, OrderDate, 
--CustomerID, Unitprice, Quantity, ToTal= Quantity*UnitPrice. Được sắp 
--xếp theo ProductID, cùng ProductID thì sắp xếp theo Quantity giảm dần.
SELECT 
	p.ProductID, 
	p.ProductName, 
	o.OrderID, 
	o.OrderDate,
	o.CustomerID,
	d.Unitprice, 
	d.Quantity, 
	d.Quantity  * d.UnitPrice AS Total
FROM Products p
JOIN [Order Details] d ON d.ProductID = p.ProductID  
JOIN Orders o ON o.OrderID = d.OrderID
WHERE DATENAME(WEEKDAY, o.OrderDate) IN ('MONDAY', 'SATURDAY') 
	AND MONTH(o.OrderDate) = 12 
	AND YEAR(o.OrderDate) = 1996
ORDER BY p.ProductID, d.Quantity DESC;

--7.  Liệt kê danh sách các nhân viên  đã lập hóa đơn trong tháng 7 của năm 
--1996.  Thông  tin  gồm  :  EmployeeID,  EmployeeName,  OrderID, 
--Orderdate.
SELECT
	e.EmployeeID,
	e.FirstName + ' ' + e.LastName AS EmployeeName,
	o.OrderID,
	o.OrderDate
FROM Employees e
JOIN Orders o ON o.EmployeeID = e.EmployeeID
WHERE MONTH(o.OrderDate) = 7 AND YEAR(o.OrderDate) = 1996;

--8.  Liệt kê danh sách các hóa đơn do nhân viên có Lastname là  ‘Fuller’  lập.
--Thông tin gồm : OrderID, Orderdate, ProductID, Quantity, Unitprice. 
SELECT
	o.OrderID,
	o.OrderDate,
	d.ProductID,
	d.Quantity,
	d.UnitPrice
FROM Orders o
JOIN Employees e ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] d ON d.OrderID = o.OrderID
WHERE e.LastName = 'Fuller';

--9.  Liệt kê chi tiết bán hàng của mỗi nhân viên theo từng hóa đơn trong năm 
--1996. Thông tin  gồm:  EmployeeID, EmployName, OrderID, Orderdate, 
--ProductID, quantity, unitprice, ToTalLine=quantity*unitprice. 
SELECT
	e.EmployeeID,
	e.FirstName + ' ' + e.LastName AS EmployName,
	o.OrderID,
	o.OrderDate,
	d.ProductID,
	d.Quantity,
	d.UnitPrice,
	d.Quantity * d.UnitPrice AS ToTalLine
FROM Employees e
JOIN Orders o ON o.EmployeeID = e.EmployeeID
JOIN [Order Details] d ON d.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1996;

--10.  Danh sách các đơn hàng sẽ được giao trong các thứ 7 của tháng 12 năm 
--1996. 
SELECT o.*, DATENAME(WEEKDAY, o.OrderDate)
FROM Orders o
WHERE DATENAME(WEEKDAY, o.OrderDate) = 'Saturday' AND
	MONTH(o.ShippedDate) = 12 AND 
	YEAR(o.ShippedDate) = 1996;

--11.  Liệt  kê  danh  sách  các  nhân  viên  chưa  lập  hóa  đơn  (dùng  LEFT 
--JOIN/RIGHT JOIN).
INSERT INTO Employees(FirstName, LastName) VALUES ('AAA', 'BBB');

SELECT 
	e.EmployeeID AS MANV_NV,
	e.FirstName + ' ' + e.LastName AS Fullname,
	e.Address,
	o.EmployeeID AS MANV_HD,
	o.OrderID,
	o.OrderDate, 
	o.CustomerID
FROM Employees e 
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE o.EmployeeID IS NULL;

--DS NHAN VIEN DA LAP HOA DON
SELECT e.*
FROM Employees e 
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE o.EmployeeID IS NOT NULL;

--12.  Liệt  kê  danh  sách  các  sản  phẩm  chưa  bán  được  (dùng  LEFT 
--JOIN/RIGHT JOIN).
INSERT INTO Products(ProductName) VALUES ('AAA');

SELECT p.*
FROM Products p
LEFT JOIN [Order Details] d ON d.ProductID = p.ProductID
WHERE d.OrderID IS NULL;

--13.  Liệt kê danh sách các khách hàng chưa mua hàng lần nào (dùng LEFT 
--JOIN/RIGHT JOIN).
SELECT c.*
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;