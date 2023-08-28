SELECT
    'Max Profit' AS Attribute,
    MAX(profit) AS Value
FROM (
    SELECT
        (od.priceEach - p.buyPrice) * od.quantityOrdered AS profit
    FROM
        products p
    JOIN orderdetails od ON p.productCode = od.productCode
) calculated_data

UNION

SELECT
    'Average Profit' AS Attribute,
    AVG(profit) AS Value
FROM (
    SELECT
        (od.priceEach - p.buyPrice) * od.quantityOrdered AS profit
    FROM
        products p
    JOIN orderdetails od ON p.productCode = od.productCode
) calculated_data

UNION

SELECT
    'Min Profit' AS Attribute,
    MIN(profit) AS Value
FROM (
    SELECT
        (od.priceEach - p.buyPrice) * od.quantityOrdered AS profit
    FROM
        products p
    JOIN orderdetails od ON p.productCode = od.productCode
) calculated_data

UNION

SELECT
    'Average QP' AS Attribute,
    AVG(profit / quantityOrdered) AS Value
FROM (
    SELECT
        (od.priceEach - p.buyPrice) * od.quantityOrdered AS profit,
        od.quantityOrdered
    FROM
        products p
    JOIN orderdetails od ON p.productCode = od.productCode
) calculated_data


ORDER BY Attribute;
