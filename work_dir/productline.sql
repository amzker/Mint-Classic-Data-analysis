USE mintclassics;

SELECT
    p.productLine,
    SUM(od.totalRevenue) AS totalRevenue,
    SUM(od.profit) AS totalProfit,
    SUM(p.quantityInStock) AS totalQuantityInStock,
    SUM(od.totalQuantityOrdered) AS totalQuantityOrdered,
    SUM(od.totalQuantityOrdered) / SUM(p.quantityInStock) AS SO,
    CASE
        WHEN SUM(od.profit) > 0 THEN SUM(od.profit) / SUM(od.totalQuantityOrdered)
        ELSE 0
    END AS QP,
    SUM(od.profit) * 100 / totalTotalProfit.totalTotalProfit AS profit_pcnt
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
JOIN (
    SELECT
        SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS totalTotalProfit
    FROM
        orderdetails odd
    JOIN
        products pp ON odd.productCode = pp.productCode
) AS totalTotalProfit
GROUP BY
    p.productLine, totalTotalProfit.totalTotalProfit
ORDER BY
    QP DESC;
