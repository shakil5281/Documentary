# Module 14 Solutions

```sql
-- 1 Library
USE LibraryDB;
SELECT * FROM library.vw_ActiveLoans WHERE IsOverdue = 1;

-- 2 School
USE SchoolDB;
SELECT s.FullName FROM school.Student s
JOIN school.Enrollment e ON e.StudentId = s.StudentId
JOIN school.Course c ON c.CourseId = e.CourseId WHERE c.CourseCode = N'CS101';

-- 3 E-commerce
USE EcommerceDB;
SELECT TOP 5 p.Name, SUM(oi.Qty * oi.UnitPrice) AS Revenue
FROM shop.Product p JOIN shop.OrderItem oi ON oi.ProductId = p.ProductId
GROUP BY p.Name ORDER BY Revenue DESC;
```

4. `BACKUP DATABASE EcommerceDB TO DISK = N'C:\Temp\SqlBackups\ecom.bak' WITH CHECKSUM;`
5. Dedicated SQL login per app, least privilege, no sa, Encrypt=True, secrets in vault not git.
