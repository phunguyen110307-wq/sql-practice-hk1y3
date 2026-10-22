-- Đề: Xếp hạng sản phẩm theo tổng số lượng bán ra (chỉ tính đơn đã giao).
-- Cách nghĩ: join 3 bảng, lọc đơn đã giao, gom nhóm theo sản phẩm rồi dùng
-- ROW_NUMBER, RANK, DENSE_RANK trên tổng số lượng để so sánh 3 cách xếp hạng.
-- Chỗ dễ sai: ROW_NUMBER luôn cho số duy nhất nên không xử lý hòa;
-- RANK bỏ số khi hòa, DENSE_RANK thì không bỏ.

SELECT P.ProductName,
     SUM(OD.Quantity) AS TongSL,
     ROW_NUMBER() OVER (ORDER BY SUM(OD.Quantity) DESC, P.ProductName) AS SoThuTu,
     RANK() OVER (ORDER BY SUM(OD.Quantity) DESC) AS Hang,
     DENSE_RANK() OVER (ORDER BY SUM(OD.Quantity) DESC) AS HangLienTiep
FROM [dbo].[Order Details] OD
JOIN [dbo].[Orders] O ON O.OrderID = OD.OrderID
JOIN [dbo].[Products] P ON P.ProductID = OD.ProductID
WHERE O.ShippedDate IS NOT NULL
GROUP BY P.ProductID, P.ProductName
ORDER BY TongSL DESC, P.ProductName;
