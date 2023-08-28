-- FILLING UP UNDERSTOCKED ITEMS 
USE mnt2;
SET SQL_SAFE_UPDATES = 0;

UPDATE products p
JOIN (
    SELECT
        p.productCode,
        p.quantityInStock,
        od.totalQuantityOrdered AS tql, 
        (od.totalQuantityOrdered / p.quantityInStock) AS SO,
        (od.profit * 100 / totalTotalProfit.totalTotalProfit) AS profit_pcnt
    FROM
        products p
    LEFT JOIN (
        SELECT
            odd.productCode,
            SUM(odd.quantityOrdered) AS totalQuantityOrdered,
            SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS profit
        FROM
            orderdetails odd
        JOIN products pp ON odd.productCode = pp.productCode
        GROUP BY odd.productCode
    ) od ON p.productCode = od.productCode
    CROSS JOIN (
        SELECT
            SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS totalTotalProfit
        FROM
            orderdetails odd
        JOIN products pp ON odd.productCode = pp.productCode
    ) AS totalTotalProfit
) AS subquery ON p.productCode = subquery.productCode
SET p.quantityInStock = tql / 0.4 	-- increasing stocks 
WHERE subquery.SO > 0.5 AND subquery.profit_pcnt > 0.6;

SET SQL_SAFE_UPDATES = 1;