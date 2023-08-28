USE mnt2;
SELECT
    p.productCode,
    p.productName,
    p.productLine,
    p.quantityInStock,
    p.warehouseCode
FROM
    products p
WHERE
    p.warehouseCode = 'd'
    AND NOT EXISTS (
        SELECT 1
        FROM products p2
        WHERE p.productCode = p2.productCode
            AND p2.warehouseCode IN ('a', 'b', 'c')
    );
