SELECT
    c.country,
    SUM(CASE WHEN p.warehouseCode = 'a' THEN 1 ELSE 0 END) AS a,
    SUM(CASE WHEN p.warehouseCode = 'b' THEN 1 ELSE 0 END) AS b,
    SUM(CASE WHEN p.warehouseCode = 'c' THEN 1 ELSE 0 END) AS c,
    SUM(CASE WHEN p.warehouseCode = 'd' THEN 1 ELSE 0 END) AS d
FROM
    products p
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
JOIN customers c ON o.customerNumber = c.customerNumber
GROUP BY c.country;
