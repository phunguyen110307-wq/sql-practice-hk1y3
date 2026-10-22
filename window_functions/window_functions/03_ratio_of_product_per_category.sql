-- Đề [Nâng cao]: tính tỷ trọng doanh thu của từng sản phẩm TRONG danh mục
-- của nó, theo phần trăm, làm tròn 2 chữ số thập phân.
-- Cách nghĩ: tính doanh thu từng sản phẩm, rồi dùng SUM() OVER (PARTITION BY
-- CategoryID) để lấy tổng của danh mục, sau đó chia.
-- Chỗ dễ sai: nhân với 100.0 để tránh chia số nguyên; nhớ tính chiết khấu (1 - Discount).

WITH Product_Revenue AS (
    SELECT
        p.CategoryID,
        p.ProductID,
        p.ProductName,
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
    ROUND(
        pr.DoanhThu_SanPham * 100.0 / SUM(pr.DoanhThu_SanPham) OVER (PARTITION BY pr.CategoryID),
        2
    ) AS [TyTrong_PhanTram]
FROM Product_Revenue pr
ORDER BY pr.CategoryID, [TyTrong_PhanTram] DESC;
