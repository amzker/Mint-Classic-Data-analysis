USE mintclassics;

SELECT
    W.warehouseCode,
    W.warehouseName,
    SUM(products.quantityInStock) AS totalQuantityInStock,
    SUM(CASE WHEN (od.totalQuantityOrdered / products.quantityInStock) < 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) < 0.5 THEN 1 ELSE 0 END) AS understocked_items,
    SUM(CASE WHEN (od.totalQuantityOrdered / products.quantityInStock) < 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) > 0.6 THEN 1 ELSE 0 END) AS overstocked_items
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
        SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS totalTotalProfit
    FROM
        orderdetails odd
    JOIN
        products pp ON odd.productCode = pp.productCode
) AS totalTotalProfit
GROUP BY
    W.warehouseCode, W.warehouseName
ORDER BY
    warehouseCode;
