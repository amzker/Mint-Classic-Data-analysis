SELECT
    p.warehouseCode,
    W.warehouseName,
    AVG(CASE WHEN c.country = 'USA' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysUSA,
    AVG(CASE WHEN c.country = 'Canada' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysCanada,
    AVG(CASE WHEN c.country = 'France' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysFrance,
    AVG(CASE WHEN c.country = 'UK' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysUK,
    AVG(CASE WHEN c.country = 'New Zealand' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysNWZ,
    AVG(CASE WHEN c.country = 'Switzerland' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysSWL,
    AVG(CASE WHEN c.country = 'Belgium' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysBelgium,
    AVG(CASE WHEN c.country = 'Japan' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysJapan,
    AVG(CASE WHEN c.country = 'Denmark' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysDEN,
	AVG(CASE WHEN c.country = 'Austria' THEN DATEDIFF(o.shippedDate, o.orderDate) END) AS avgDaysAustira
    -- Repeat the AVG(CASE...) pattern for other countries
    -- ...
FROM
    products p
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
JOIN customers c ON o.customerNumber = c.customerNumber
JOIN warehouses as W ON p.warehouseCode = W.warehouseCode
GROUP BY
    p.warehouseCode
ORDER BY
    p.warehouseCode;
