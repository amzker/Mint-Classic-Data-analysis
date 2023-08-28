USE mintclassics;

SELECT
    W.warehouseCode,
    W.warehouseName,
    W.warehousePctCap,
    ROUND(100 * SUM(products.quantityInStock) / W.warehousePctCap) AS warehouseCapacity,
    SUM(products.quantityInStock) AS totalQuantityInStock,
    SUM(od.totalQuantityOrdered) AS totalQuantityOrdered,
    SUM(od.profit) AS totalProfitPerWarehouse,
    SUM(od.totalQuantityOrdered) / SUM(products.quantityInStock) AS SO,
    CASE
        WHEN SUM(od.profit) > 0 THEN SUM(od.profit) / SUM(od.totalQuantityOrdered)
        ELSE 0
    END AS QP,
    (SUM(od.totalQuantityOrdered) * 100) / totalTotalQuantity.totalQuantityOrdered AS pctTotalQuantityOrdered
FROM
    warehouses AS W
JOIN products ON W.warehouseCode = products.warehouseCode
LEFT JOIN (
    SELECT
        odd.productCode,
        SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS profit,
        SUM(odd.quantityOrdered) AS totalQuantityOrdered
    FROM
        orderdetails odd
    JOIN
        products pp ON odd.productCode = pp.productCode
    GROUP BY
        odd.productCode
) od ON products.productCode = od.productCode
CROSS JOIN (
    SELECT
        SUM(odd.quantityOrdered) AS totalQuantityOrdered
    FROM
        orderdetails odd
) AS totalTotalQuantity
GROUP BY
    W.warehouseCode, W.warehouseName, totalTotalQuantity.totalQuantityOrdered
ORDER BY
    totalQuantityInStock DESC;

