USE mnt2;

SELECT
    W.warehouseCode,
    W.warehouseName,
    W.capacity,
    ROUND(SUM(products.quantityInStock) *100 / W.capacity,2) AS Capacity_percentage,
    SUM(products.quantityInStock) AS totalQuantityInStock,
    SUM(od.totalQuantityOrdered) AS totalQuantityOrdered,
    SUM(od.profit) AS totalProfitPerWarehouse,
    SUM(od.totalQuantityOrdered) / SUM(products.quantityInStock) AS SO,
    CASE
        WHEN SUM(od.profit) > 0 THEN SUM(od.profit) / SUM(od.totalQuantityOrdered)
        ELSE 0
    END AS QP
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
GROUP BY
    W.warehouseCode
ORDER BY
    totalQuantityInStock DESC;
