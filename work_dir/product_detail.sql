USE mintclassics;

SELECT
    p.productCode,
    p.productName,
    p.productLine,
    p.quantityInStock,
    p.warehouseCode,
    COALESCE(od.totalRevenue, 0) AS totalRevenue,
    COALESCE(od.profit, 0) AS profit,
    CASE
        WHEN od.profit > 0 THEN od.profit * 100 / totalTotalProfit.totalTotalProfit
        ELSE 0
    END AS profit_pcnt,
    COALESCE(od.totalQuantityOrdered, 0) AS T_Qordered,
    CASE
        WHEN od.profit > 0 THEN od.profit / od.totalQuantityOrdered
        ELSE 0
    END AS QP,
    CASE
        WHEN od.totalQuantityOrdered > 0 THEN od.totalQuantityOrdered / p.quantityInStock
        ELSE 0
    END AS SO
FROM
    products p
LEFT JOIN (
    SELECT
        odd.productCode,
        SUM(odd.priceEach * odd.quantityOrdered) AS totalRevenue,
        SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS profit,
        SUM(odd.quantityOrdered) AS totalQuantityOrdered
    FROM
        orderdetails odd
    JOIN
        products pp ON odd.productCode = pp.productCode
    GROUP BY
        odd.productCode
) od ON p.productCode = od.productCode
CROSS JOIN (
    SELECT
        SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS totalTotalProfit
    FROM
        orderdetails odd
    JOIN
        products pp ON odd.productCode = pp.productCode
) AS totalTotalProfit
WHERE
    (od.totalQuantityOrdered / p.quantityInStock) > 0.5
ORDER BY
	profit_pcnt DESC;