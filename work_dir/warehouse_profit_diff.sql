USE mintclassics;

-- Calculate the original total profit, adjusted total profit (excludes 80% of overstocked items and fills understocked items by 30%),
-- and the difference between them for each warehouse
SELECT
    W.warehouseCode,
    W.warehouseName,
    SUM(od.profit) AS original_total_profit,
    SUM(p.quantityInStock) AS totalQuantityInStock,
    SUM(CASE
        WHEN (od.totalQuantityOrdered / p.quantityInStock) < 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) < 0.5 THEN 0.5 * od.profit
        WHEN (od.totalQuantityOrdered / p.quantityInStock) > 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) > 0.6 THEN 0.8 * od.profit
        ELSE od.profit
    END) AS adjusted_total_profit,
    SUM(CASE
        WHEN (od.totalQuantityOrdered / p.quantityInStock) < 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) < 0.5 THEN 0.5
        * od.profit - od.profit
        WHEN (od.totalQuantityOrdered / p.quantityInStock) > 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) > 0.6 THEN 0.8 * od.profit - od.profit
        ELSE 0
    END) AS profit_difference
FROM
    warehouses AS W
JOIN products p ON W.warehouseCode = p.warehouseCode
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
) od ON p.productCode = od.productCode
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
