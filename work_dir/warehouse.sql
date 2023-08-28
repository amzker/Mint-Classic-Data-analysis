USE mintclassics;

SELECT W.warehouseCode , W.warehouseName , sum(products.quantityInStock) AS TQinStock, W.warehousePctCap
FROM warehouses AS W
JOIN products ON W.warehouseCode = products.warehouseCode
GROUP BY W.warehouseCode
ORDER BY COUNT(products.quantityInStock) DESC;

