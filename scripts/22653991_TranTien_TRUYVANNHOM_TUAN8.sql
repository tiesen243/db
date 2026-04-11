-----1 CHO BIET TONG TIEN CUA TUNG HOA DON
use Northwind
SELECT [OrderID], TONGTIEN = SUM([UnitPrice]*[Quantity])
FROM [dbo].[Order Details]
GROUP BY [OrderID]
--
--
SELECT [OrderID],[Quantity], [UnitPrice],TONGTIEN = SUM([UnitPrice]*[Quantity])
FROM [dbo].[Order Details]
GROUP BY [OrderID],[Quantity], [UnitPrice] ---SAI
--
SELECT O.[OrderID], [CustomerID],[EmployeeID],[OrderDate],TONGTIEN = SUM([UnitPrice]*[Quantity])
FROM [dbo].[Order Details] OD JOIN ORDERS O ON OD.OrderID =O.OrderID
GROUP BY O.[OrderID], [CustomerID],[EmployeeID],[OrderDate]
--CHO BIET SO LUONG TRUNG BINH BAN DUOC CUA MOI SAN PHAM
SELECT P.[ProductID],[ProductName],[SupplierID],[CategoryID], SLTB =AVG([Quantity])
FROM [dbo].[Products] P JOIN [dbo].[Order Details] OD ON P.ProductID=OD.ProductID
GROUP BY P.[ProductID],[ProductName],[SupplierID],[CategoryID]

----CHO BIET SO LUONG  BAN DUOC LỚN NHẤT CUA MOI SAN PHAM
SELECT P.[ProductID],[ProductName],[SupplierID],[CategoryID], SLLN =MAX([Quantity])
FROM [dbo].[Products] P JOIN [dbo].[Order Details] OD ON P.ProductID=OD.ProductID
GROUP BY P.[ProductID],[ProductName],[SupplierID],[CategoryID]

------CHO BIET SO LUONG  BAN DUOC NHỎ NHẤT CUA MOI SAN PHAM
SELECT P.[ProductID],[ProductName],[SupplierID],[CategoryID], SLNN =MIN([Quantity])
FROM [dbo].[Products] P JOIN [dbo].[Order Details] OD ON P.ProductID=OD.ProductID
GROUP BY P.[ProductID],[ProductName],[SupplierID],[CategoryID]
----CHO BIET SO LẦN BAN DUOC  CUA MOI SAN PHAM
SELECT P.[ProductID],[ProductName],[SupplierID],[CategoryID], SLBD =COUNT([Quantity])
FROM [dbo].[Products] P JOIN [dbo].[Order Details] OD ON P.ProductID=OD.ProductID
GROUP BY P.[ProductID],[ProductName],[SupplierID],[CategoryID]
--CHO BIET TONG SL, TRUNG BINH , GIA TRI LON NHAT, GIA TRI NHO NHAT, BAN ĐƯỢC BAO NHIEU LAN CUA MOI SAN PHAM
SELECT P.[ProductID],[ProductName], TONGSL =SUM([Quantity]), TB= AVG([Quantity]),SLLN=MAX(QUANTITY),SLNN=MIN(QUANTITY), SLBANDUOC=COUNT(OD.PRODUCTID)
FROM [dbo].[Order Details] OD JOIN [dbo].[Products] P ON P.ProductID =OD.ProductID
GROUP BY P.[ProductID],[ProductName]
ORDER BY  P.[ProductID]
---CHO BIET TONG TIEN CUA CAC HOA DON DUOC LAP TRONG THANG 9
SELECT O.[OrderID], [CustomerID],[EmployeeID],[OrderDate],TONGTIEN = SUM([UnitPrice]*[Quantity])
FROM [dbo].[Order Details] OD JOIN ORDERS O ON OD.OrderID =O.OrderID
WHERE MONTH(ORDERDATE)=9
GROUP BY O.[OrderID], [CustomerID],[EmployeeID],[OrderDate]
ORDER BY O.OrderID
--CHO BIET HOA DON NAO CO TONG TIEN >3000
SELECT O.[OrderID], [CustomerID],[EmployeeID],[OrderDate],TONGTIEN = SUM([UnitPrice]*[Quantity])
FROM [dbo].[Order Details] OD JOIN ORDERS O ON OD.OrderID =O.OrderID
GROUP BY O.[OrderID], [CustomerID],[EmployeeID],[OrderDate]
HAVING SUM([UnitPrice]*[Quantity])>3000
--CHO BIET HOA DON NAO CO THANH TIEN LON NHAT 
SELECT TOP 1 WITH TIES O.[OrderID], [CustomerID],[EmployeeID],[OrderDate],THANHTIEN=[UnitPrice]*[Quantity]
FROM [dbo].[Order Details] OD JOIN ORDERS O ON OD.OrderID =O.OrderID
ORDER BY THANHTIEN DESC
----CHO BIET THANH TIEN LON NHAT CUA TUNG HOA DON
SELECT  O.[OrderID], [CustomerID],[EmployeeID],[OrderDate],TONGTIEN = MAX([UnitPrice]*[Quantity])
FROM [dbo].[Order Details] OD JOIN ORDERS O ON OD.OrderID =O.OrderID
GROUP BY O.[OrderID], [CustomerID],[EmployeeID],[OrderDate]
ORDER BY TONGTIEN DESC
--CHO BIET HOA DON NAO CO TONG TIEN LON NHAT
SELECT TOP 1 WITH TIES O.[OrderID], [CustomerID],[EmployeeID],[OrderDate],TONGTIEN = SUM([UnitPrice]*[Quantity])
FROM [dbo].[Order Details] OD JOIN ORDERS O ON OD.OrderID =O.OrderID
GROUP BY O.[OrderID], [CustomerID],[EmployeeID],[OrderDate]
ORDER BY TONGTIEN DESC
----------THỰC HÀNH
--BÀI TẬP 3: LỆNH SELECT – TRUY VẤN GOM NHÓM
--1.  Liệt kê danh sách các orders ứng với tổng tiền của từng hóa đơn. Thông tin 
--bao gồm OrderID, OrderDate, Total. Trong đó Total là Sum của Quantity * 
--Unitprice, kết nhóm theo OrderID.
SELECT 
  o.OrderID 
  o.OrderDate,
  SUM(d.Quantity * d.UnitPrice) AS Total
FROM Orders o
JOIN [Order Details] d ON o.OrderID = d.OrderID
GROUP BY o.OrderID, o.OrderDate;

--2.  Liệt kê danh sách các orders  mà địa chỉ nhận hàng ở  thành phố    ‘Madrid’
--(Shipcity). Thông tin bao gồm OrderID, OrderDate, Total. Trong đó Total
--là tổng trị giá hóa đơn, kết nhóm theo OrderID. 
SELECT 
  o.OrderID, 
  o.OrderDate, 
  SUM(d.Quantity * d.UnitPrice) AS Total
FROM Orders o
JOIN [Order Details] d ON o.OrderID = d.OrderID
WHERE o.ShipCity = 'Madrid'

--3.  Viết các truy vấn để thống kê số lượng các hóa đơn : 
---  Trong mỗi năm. Thông tin hiển thị : Year , CoutOfOrders ?
---  Trong  mỗi  tháng/năm  .  Thông  tin  hiển  thị  :  Year  ,  Month, 
--CoutOfOrders ?
---  Trong mỗi tháng/năm và ứng với mỗi nhân viên. Thông tin hiển 
--thị : Year, Month, EmployeeID, CoutOfOrders ?
SELECT 
  YEAR(OrderDate) AS Year, 
  COUNT(*) AS CountOfOrders
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY Year;

SELECT 
  YEAR(OrderDate) AS Year, 
  MONTH(OrderDate) AS Month, 
  COUNT(*) AS CountOfOrders
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

--4.  Cho  biết  mỗi  Employee  đã  lập  bao  nhiêu  hóa  đơn.  Thông  tin  gồm 
--EmployeeID,  EmployeeName,  CountOfOrder. Trong đó CountOfOrder là 
--tổng  số  hóa  đơn  của  từng  employee.  EmployeeName  được  ghép  từ 
--LastName và FirstName.
SELECT 
  e.EmployeeID, 
  e.LastName + ' ' + e.FirstName AS EmployeeName, 
  COUNT(*) AS CountOfOrder
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.LastName, e.FirstName
ORDER BY e.EmployeeID;

--5.  Cho biết mỗi Employee đã  lập được bao nhiêu hóa đơn, ứng với tổng tiền
--các  hóa  đơn  tương  ứng.  Thông  tin  gồm  EmployeeID,  EmployeeName, 
--CountOfOrder , Total.
SELECT 
  e.EmployeeID, 
  e.LastName + ' ' + e.FirstName AS EmployeeName, 
  COUNT(*) AS CountOfOrder,
  SUM(d.Quantity * d.UnitPrice) AS Total
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] d ON o.OrderID = d.OrderID
GROUP BY e.EmployeeID, e.LastName, e.FirstName
ORDER BY e.EmployeeID;

--6.  Liệt  kê  bảng  lương  của  mỗi  Employee  theo  từng  tháng  trong  năm  1996 
--gồm  EmployeeID,  EmployName,  Month_Salary,  Salary  = 
--sum(quantity*unitprice)*10%.  Được  sắp  xếp  theo  Month_Salary,  cùmg 
--Month_Salary thì sắp xếp theo Salary giảm dần.
SELECT
  e.EmployeeID,
  e.FirstName + ' ' + e.LastName AS EmployeeName,
  MONTH(o.OrderDate) AS Month_Salary,
  SUM(d.Quantity * d.UnitPrice) * 0.1 AS Salary
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] d ON o.OrderID = d.OrderID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY e.EmployeeID, e.FirstName, e.LastName, MONTH(o.OrderDate)
ORDER BY Month_Salary, Salary DESC;

--7.  Tính tổng số hóa đơn và tổng tiền các hóa đơn  của mỗi nhân viên đã bán 
--trong  tháng  3/1997,  có  tổng  tiền  >4000.  Thông  tin  gồm  EmployeeID, 
--LastName, FirstName, CountofOrder, Total. 
--Trường ĐH Công Nghiệp TP.HCM    Bài Tập Thực Hành Môn Hệ Cơ Sở Dữ Liệu
--Khoa Công Nghệ Thông Tin    48/57
SELECT 
  e.EmployeeID, 
  e.LastName, 
  e.FirstName, 
  COUNT(*) AS CountOfOrder, 
  SUM(d.Quantity * d.UnitPrice) AS Total
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] d ON o.OrderID = d.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 3
GROUP BY e.EmployeeID, e.LastName, e.FirstName
HAVING SUM(d.Quantity * d.UnitPrice) > 4000
ORDER BY Total DESC;

--8.  Liệt kê danh sách các customer ứng với tổng số hoá đơn, tổng tiền các hoá 
--đơn, mà các hóa đơn được lập từ 31/12/1996 đến 1/1/1998 và tổng tiền các 
--hóa  đơn  >20000.  Thông  tin  được  sắp  xếp  theo  CustomerID,  cùng  mã  thì 
--sắp xếp theo tổng tiền giảm dần.
SELECT
  c.CustomerID,
  c.CompanyName,
  COUNT(DISTINCT o.OrderID) AS TotalOrders,
  SUM(d.Quantity * d.UnitPrice) AS TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] d ON o.OrderID = d.OrderID
WHERE o.OrderDate >= '1996-12-31' AND o.OrderDate <= '1998-01-01'
GROUP BY c.CustomerID, c.CompanyName
HAVING SUM(d.Quantity * d.UnitPrice) > 20000
ORDER BY c.CustomerID, TotalAmount DESC;

--9.  Liệt kê danh sách các customer ứng với tổng tiền của các hóa đơn ở từng 
--tháng.  Thông  tin  bao  gồm  CustomerID,  CompanyName,  Month_Year, 
--Total. Trong đó Month_year là tháng và năm lập hóa đơn, Total là tổng của 
--Unitprice* Quantity.
SELECT
  c.CustomerID,
  c.CompanyName,
  MONTH(o.OrderDate) + '-' + CAST(YEAR(o.OrderDate) AS VARCHAR(4)) AS Month_Year,
  SUM(d.Quantity * d.UnitPrice) AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] d ON o.OrderID = d.OrderID
GROUP BY c.CustomerID, c.CompanyName, MONTH(o.OrderDate), YEAR(o.OrderDate)
ORDER BY c.CustomerID, Month_Year;

--10.  Liệt  kê  danh  sách  các  nhóm  hàng  (category)  có  tổng  số  lượng  tồn 
--(UnitsInStock) lớn hơn 300, đơn giá trung bình nhỏ hơn 25. Thông tin bao 
--gồm CategoryID, CategoryName, Total_UnitsInStock, Average_Unitprice.
SELECT
  c.CategoryID,
  c.CategoryName,
  SUM(p.UnitsInStock) AS Total_UnitsInStock,
  AVG(p.UnitPrice) AS Average_UnitPrice
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING SUM(p.UnitsInStock) > 300 AND AVG(p.UnitPrice) < 25
ORDER BY c.CategoryID;

--11.  Liệt kê danh sách các  nhóm hàng (category)  có tổng số mặt hàng  (product)
--nhỏ  hớn  10.  Thông  tin  kết  quả  bao  gồm  CategoryID,  CategoryName, 
--CountOfProducts.  Được sắp xếp theo CategoryName, cùng  CategoryName
--thì sắp theo CountOfProducts giảm dần.
SELECT
  c.CategoryID,
  c.CategoryName,
  COUNT(p.ProductID) AS CountOfProducts
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING COUNT(p.ProductID) < 10
ORDER BY c.CategoryName, CountOfProducts DESC;

--12.  Liệt kê danh sách các Product  bán trong  quý 1 năm 1998 có tổng số lượng 
--bán ra >200, thông tin gồm [ProductID], [ProductName], SumofQuatity 
SELECT
  p.ProductID,
  p.ProductName,
  SUM(od.Quantity) AS SumOfQuantity
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1998 AND MONTH(o.OrderDate) IN (1, 2, 3)
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Quantity) > 200
ORDER BY SumOfQuantity DESC;

--13.  Cho biết Employee nào bán được nhiều tiền nhất trong tháng 7 năm 1997
SELECT TOP 1 WITH TIES
  e.EmployeeID,
  e.FirstName + ' ' + e.LastName AS EmployeeName,
  SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 7
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalSales DESC;

--14.  Liệt kê danh sách 3 Customer có nhiều đơn hàng nhất của năm 1996.
SELECT TOP 3 WITH TIES
  c.CustomerID,
  c.CompanyName,
  COUNT(o.OrderID) AS CountOfOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY c.CustomerID, c.CompanyName
ORDER BY CountOfOrders DESC;

--15.  Liệt  kê  danh  sách  các  Products  có  tổng  số  lượng  lập  hóa  đơn  lớn  nhất.
--Thông tin gồm ProductID, ProductName, CountOfOrders.
SELECT
  p.ProductID,
  p.ProductName,
  COUNT(od.OrderID) AS CountOfOrders
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY CountOfOrders DESC;

