USE mintclassics;

SELECT
    p.*,
    COALESCE(od.totalRevenue, 0) AS totalRevenue,
    COALESCE(od.profit, 0) AS profit,
    COALESCE(od.totalQuantityOrdered, 0) AS T_Qordered,
    CASE
        WHEN od.profit > 0 THEN  od.profit / od.totalQuantityOrdered
        ELSE 0
    END AS QP
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
ORDER BY
    QP DESC;
