-- removing toyota supra , setting q.instock to 100
USE mnt2;
UPDATE products
SET quantityInStock = 100
WHERE productCode = 'S18_3233';


-- Update the quantity in stock for overstocked products Based on SO 0.8

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
SET p.quantityInStock = tql / 0.8
WHERE subquery.SO < 0.5 AND subquery.profit_pcnt < 0.5;

SET SQL_SAFE_UPDATES = 1;

-- Reducing moderate Q prodcuts

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
SET p.quantityInStock = ROUND(p.quantityInStock * 0.90) -- Reduce by 10%
WHERE subquery.SO < 0.3 AND subquery.profit_pcnt < 1.5;


SET SQL_SAFE_UPDATES = 1;



