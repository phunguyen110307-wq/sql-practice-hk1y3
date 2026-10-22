-- Đề: Với bảng employees(id, name, department, salary),
-- lấy nhân viên có lương cao nhất trong từng phòng ban.
-- Cách nghĩ: đánh số lương giảm dần trong mỗi phòng ban bằng ROW_NUMBER,
-- rồi lấy số thứ tự 1.
-- Chỗ từng sai: quên PARTITION BY nên đánh số toàn bảng.

SELECT id, name, department, salary
FROM (
    SELECT
        id, name, department, salary,
        ROW_NUMBER() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS rn
    FROM employees
) t
WHERE rn = 1;

--[Cơ bản] Đánh số thứ tự khách hàng theo tên công ty (A → Z) bằng ROW_NUMBER().
SELECT [CompanyName],
       ROW_NUMBER() OVER (ORDER BY  [CompanyName] ASC) AS SoThuTu
FROM [dbo].[Customers];

--[Trung bình] Với mỗi khách, lấy đơn đã giao MỚI NHẤT (OrderID và OrderDate). Gợi ý:
--ROW_NUMBER với PARTITION BY CustomerID.
WITH RankedOrders AS (
    SELECT 
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        ROW_NUMBER() OVER (
            PARTITION BY o.CustomerID 
            ORDER BY o.OrderDate DESC, o.OrderID DESC
        ) AS The_Newest_OrderDate
    FROM dbo.Orders o
    WHERE o.ShippedDate IS NOT NULL
)
SELECT 
    CustomerID,
    OrderID,
    OrderDate
FROM RankedOrders
WHERE The_Newest_OrderDate = 1;

--[Nâng cao] Tính tỷ trọng doanh thu của từng sản phẩm TRONG danh mục của nó, theo phần
--trăm, làm tròn 2 chữ số thập phân.
WITH Product_Revenue AS (
    SELECT 
        p.CategoryID,
        p.ProductID,
        p.ProductName,
        -- Lưu ý: Trong database Northwind, nếu có chiết khấu thì nhân thêm (1 - od.Discount)
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DoanhThu_SanPham
    FROM [dbo].[Products] p
    JOIN [dbo].[Order Details] od ON p.ProductID = od.ProductID
    GROUP BY p.CategoryID, p.ProductID, p.ProductName
)
SELECT 
    pr.CategoryID,
    pr.ProductID,
    pr.ProductName,
    pr.DoanhThu_SanPham,
    SUM(pr.DoanhThu_SanPham) OVER (PARTITION BY pr.CategoryID) AS TongDoanhThu_DanhMuc,
    -- Nhân với 100.0 để tránh phép chia số nguyên và ra định dạng %
    ROUND(
        pr.DoanhThu_SanPham * 100.0 / SUM(pr.DoanhThu_SanPham) OVER (PARTITION BY pr.CategoryID), 
        2
    ) AS [TyTrong_PhanTram]
FROM Product_Revenue pr
ORDER BY pr.CategoryID, [TyTrong_PhanTram] DESC;
