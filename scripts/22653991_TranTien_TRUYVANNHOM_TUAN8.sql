--MASV: 22653991
--HỌ TÊN: Tran Tien

use Northwind

----------THỰC HÀNH
--BÀI TẬP 3: LỆNH SELECT – TRUY VẤN GOM NHÓM
--1.  Liệt kê danh sách các orders ứng với tổng tiền của từng hóa đơn. Thông tin 
--bao gồm OrderID, OrderDate, Total. Trong đó Total là Sum của Quantity * 
--Unitprice, kết nhóm theo OrderID.
SELECT 
  o.OrderID,
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
GROUP BY o.OrderID, o.OrderDate;

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
  c.Address,
  c.City,
  c.Phone,
  COUNT(DISTINCT o.OrderID) AS TotalOrders,
  SUM(d.Quantity * d.UnitPrice) AS TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] d ON o.OrderID = d.OrderID
WHERE o.OrderDate >= '1996-12-31' AND o.OrderDate <= '1998-01-01'
GROUP BY c.CustomerID, c.CompanyName, c.Address, c.City, c.Phone
HAVING SUM(d.Quantity * d.UnitPrice) > 20000
ORDER BY c.CustomerID, TotalAmount DESC;

--9.  Liệt kê danh sách các customer ứng với tổng tiền của các hóa đơn ở từng 
--tháng.  Thông  tin  bao  gồm  CustomerID,  CompanyName,  Month_Year, 
--Total. Trong đó Month_year là tháng và năm lập hóa đơn, Total là tổng của 
--Unitprice* Quantity.
SELECT
  c.CustomerID,
  c.CompanyName,
  CAST(MONTH(o.OrderDate) AS VARCHAR(2)) + '-' + CAST(YEAR(o.OrderDate) AS VARCHAR(4)) AS Month_Year,
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

--TUẦN 8 (3 TIẾT)
--BÀI TẬP 4: LỆNH SELECT – TRUY VẤN LỒNG NHAU
--1.  Liệt kê  các product  có đơn giá  mua  lớn hơn đơn giá  mua  trung bình  của 
--tất cả các product.
SELECT 
	p.ProductID, 
	p.ProductName
FROM Products p
WHERE p.UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM Products
);

--2.  Liệt kê các product có đơn giá mua lớn hơn đơn giá mua nhỏ nhất của tất 
--cả các product.
SELECT 
	p.ProductID, 
	p.ProductName
FROM Products p
WHERE p.UnitPrice > (
    SELECT MIN(UnitPrice)
    FROM Products
);

--3.  Liệt kê các product có đơn giá  bán  lớn hơn đơn giá  bán  trung bình của 
--các  product.  Thông  tin  gồm  ProductID,  ProductName,  OrderID, 
--Orderdate,  Unitprice .
SELECT 
	p.ProductID, 
	p.ProductName, 
	d.OrderID, 
	o.OrderDate,
	d.UnitPrice
FROM Products p
JOIN [Order Details] d ON d.ProductID = p.ProductID
JOIN Orders o ON o.OrderID = d.OrderID
WHERE d.UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM [Order Details]
);

--4.  Liệt kê các  product có đơn giá  bán  lớn hơn  đơn giá  bán  trung bình của 
--các product có ProductName bắt đầu là ‘N’.
SELECT 
	p.ProductID, 
	p.ProductName, 
	d.OrderID, 
	o.OrderDate, 
	d.UnitPrice
FROM Products p
JOIN [Order Details] d ON d.ProductID = p.ProductID
JOIN Orders o ON o.OrderID = d.OrderID
WHERE p.ProductName LIKE 'N%' AND d.UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM [Order Details]
);

--5.  Cho biết  những sản phẩm có tên  bắt đầu bằng  ‘T’  và  có  đơn giá bán  lớn 
--hơn  đơn giá bán của  (tất cả) những  sản phẩm có tên bắt đầu bằng chữ 
--‘V’.
SELECT 
	p.ProductID, 
	p.ProductName
FROM Products p
JOIN [Order Details] d ON d.ProductID = p.ProductID
WHERE p.ProductName LIKE 'T%' AND d.UnitPrice > (
    SELECT AVG(dd.UnitPrice)
    FROM [Order Details] dd
	JOIN Products pp ON pp.ProductID = dd.ProductID
	WHERE pp.ProductName LIKE 'V%'
);
 
--6.  Cho biết sản phẩm nào có đơn giá bán cao nhất trong số những sản phẩm 
--có đơn vị tính có chứa chữ ‘box’ .
SELECT TOP 1 
	p.ProductID, 
	p.ProductName, 
	d.UnitPrice
FROM Products p
JOIN [Order Details] d ON d.ProductID = p.ProductID
WHERE p.QuantityPerUnit LIKE '%box%'
ORDER BY d.UnitPrice DESC;

--7.  Liệt kê các product  có tổng  số lượng bán  (Quantity)  trong năm 1998  lớn 
--hơn tổng số lượng bán trong năm 1998 của mặt hàng có mã 71 
WITH Sales1998 AS (
    SELECT 
        d.ProductID,
        SUM(d.Quantity) AS TotalQuantity
    FROM [Order Details] d
    JOIN Orders o ON o.OrderID = d.OrderID
    WHERE YEAR(o.OrderDate) = 1998
    GROUP BY d.ProductID
)
SELECT p.ProductID, p.ProductName, s.TotalQuantity
FROM Sales1998 s
JOIN Products p ON p.ProductID = s.ProductID
WHERE s.TotalQuantity > (
    SELECT TotalQuantity
    FROM Sales1998
    WHERE ProductID = 71
);

--8.  Thực hiện :
---  Thống kê  tổng số lượng bán  ứng với  mỗi  mặt hàng thuộc nhóm 
--hàng  có  CategoryID  là  4.  Thông  tin  :  ProductID,  QuantityTotal 
--(tập A) 
SELECT
	p.ProductId,
	SUM(d.Quantity) AS QuantityTotal
FROM Products p
JOIN [Order Details] d ON d.ProductID = p.ProductID
WHERE p.CategoryID = 4
GROUP BY p.ProductID;

---  Thống kê tổng số lượng bán  ứng với  mỗi mặt hàng thuộc nhóm 
--hàng khác 4 . Thông tin : ProductID, QuantityTotal (tập B)
SELECT
	p.ProductId,
	SUM(d.Quantity) AS QuantityTotal
FROM Products p
JOIN [Order Details] d ON d.ProductID = p.ProductID
WHERE p.CategoryID != 4
GROUP BY p.ProductID;

---  Dựa vào 2 truy vấn trên : Liệt kê  danh sách các mặt hàng trong 
--tập A có QuantityTotal lớn hơn tất cả QuantityTotal của tập B
WITH A AS (
	SELECT
		p.ProductId,
		SUM(d.Quantity) AS QuantityTotal
	FROM Products p
	JOIN [Order Details] d ON d.ProductID = p.ProductID
	WHERE p.CategoryID = 4
	GROUP BY p.ProductID
), B AS (
	SELECT
		p.ProductId,
		SUM(d.Quantity) AS QuantityTotal
	FROM Products p
	JOIN [Order Details] d ON d.ProductID = p.ProductID
	WHERE p.CategoryID != 4
	GROUP BY p.ProductID
) SELECT *
FROM A
WHERE QuantityTotal > ALL (
	SELECT QuantityTotal FROM B
);

--9.  Danh sách các Product  có tổng số lượng  bán  được lớn nhất trong năm 
--1998
--Lưu ý : Có nhiều phương án thực hiện các truy vấn sau (dùng JOIN hoặc 
--subquery ). Hãy đưa ra phương án sử dụng subquery.
WITH Products1998 AS (
	SELECT
		p.ProductId,
		p.ProductName,
		SUM(d.Quantity) AS Total
	FROM Products p
	JOIN [Order Details] d ON d.ProductID = p.ProductID
	JOIN Orders o ON o.OrderID = d.OrderID
	WHERE YEAR(o.OrderDate) = 1998
	GROUP BY p.ProductID, p.ProductName
) SELECT *
FROM Products1998 p
WHERE p.Total = (
	SELECT MAX(Total)
	FROM Products1998
);

--10.  Danh sách các products đã có khách hàng mua hàng (tức là ProductID có 
--trong  [Order  Details]).  Thông  tin  bao  gồm  ProductID,  ProductName, 
--Unitprice
SELECT
	p.ProductId,
	p.ProductName,
	p.UnitPrice
FROM Products p
WHERE p.ProductID IN (
	SELECT d.ProductId
	FROM [Order Details] d
)

--11.  Danh sách các hóa đơn của những  khách hàng  ở thành phố LonDon và 
--Madrid.
SELECT
	o.*
FROM Orders o
WHERE o.CustomerID IN (
	SELECT c.CustomerID
	FROM Customers c
	WHERE c.City IN ('LonDon', 'Madrid')
);

--12.  Liệt kê các sản phẩm có trên 20 đơn hàng trong  quí 3  năm 1998, thông 
--tin gồm ProductID, ProductName.
SELECT
    p.ProductID,
    p.ProductName
FROM Products p
WHERE p.ProductID IN (
    SELECT d.ProductID
    FROM Orders o
    JOIN [Order Details] d ON d.OrderID = o.OrderID
    WHERE YEAR(o.OrderDate) = 1998 AND MONTH(o.OrderDate) IN (7, 8, 9)
    GROUP BY d.ProductID
    HAVING COUNT(DISTINCT o.OrderID) > 20
);

--13.  Liệt kê danh sách các sản phẩm chưa bán được trong tháng 6 năm 1996
SELECT
	p.ProductId,
	p.ProductName
FROM Products p
WHERE NOT EXISTS (
	SELECT 1
	FROM Orders o
    JOIN [Order Details] d ON d.OrderID = o.OrderID
	WHERE d.ProductID = p.ProductID AND YEAR(o.OrderDate) = 1996 AND MONTH(o.OrderDate) = 6
);

--14.  Liệt kê danh sách các Employes không lập hóa đơn vào ngày hôm nay
SELECT
	e.EmployeeID,
	e.FirstName + ' ' + e.LastName AS EmployeeName
FROM Employees e
WHERE NOT EXISTS (
	SELECT 1
	FROM Orders o
	WHERE o.EmployeeID = e.EmployeeID AND o.OrderDate = GETDATE()
);

--15.  Liệt kê danh sách các Customers chưa mua hàng trong năm 1997
SELECT
	c.CustomerID,
	c.CompanyName,
	c.ContactName
FROM Customers c
WHERE NOT EXISTS (
	SELECT 1
	FROM Orders o
	WHERE o.CustomerID = c.CustomerID AND YEAR(o.OrderDate) = 1997
);

--16.  Tìm tất cả các Customers mua các sản phẩm có tên bắt đầu bằng chữ T 
--trong tháng 7 năm 1997
SELECT
    c.CustomerID,
    c.CompanyName,
    c.ContactName
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    JOIN [Order Details] d ON d.OrderID = o.OrderID
    JOIN Products p ON p.ProductID = d.ProductID
    WHERE o.CustomerID = c.CustomerID
      AND YEAR(o.OrderDate) = 1997
      AND MONTH(o.OrderDate) = 7
      AND p.ProductName LIKE 'T%'
);

--17.  Liệt kê danh sách các khách hàng mua các hóa đơn mà các hóa đơn này 
--chỉ mua những sản phẩm có mã >=3 

--18.  Tìm các Customer chưa từng lập  hóa đơn (viết bằng ba cách: dùng NOT 
--EXISTS, dùng LEFT JOIN, dùng NOT IN )

--19.  Bạn hãy mô tả kết quả của các câu truy vấn sau ?
--Select ProductID, ProductName, UnitPrice  From [Products]
--Where Unitprice>ALL (Select Unitprice from [Products] where 
--ProductName like ‘N%’)
--Select ProductId, ProductName, UnitPrice From [Products]
--Where Unitprice>ANY (Select Unitprice from [Products] where 
--ProductName like ‘N%’)
--Select ProductId, ProductName, UnitPrice from [Products]
--Where Unitprice=ANY (Select Unitprice from [Products] where 
--Trường ĐH Công Nghiệp TP.HCM    Bài Tập Thực Hành Môn Hệ Cơ Sở Dữ Liệu
--Khoa Công Nghệ Thông Tin    50/57
--ProductName like ‘N%’)
--Select ProductId, ProductName, UnitPrice from [Products]
--Where ProductName like ‘N%’ and 
--Unitprice>=ALL (Select Unitprice from [Products] where
--ProductName like ‘N%’)
