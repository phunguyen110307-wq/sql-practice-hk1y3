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
