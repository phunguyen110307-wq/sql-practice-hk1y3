-- Đề [Trung bình]: với mỗi khách, lấy đơn đã giao MỚI NHẤT (OrderID và OrderDate).
-- Gợi ý: ROW_NUMBER với PARTITION BY CustomerID.
-- Cách nghĩ: đánh số các đơn đã giao của mỗi khách theo OrderDate giảm dần,
-- rồi lấy số thứ tự 1.
-- Chỗ dễ sai: thêm OrderID DESC để phá hòa khi hai đơn cùng ngày.

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
