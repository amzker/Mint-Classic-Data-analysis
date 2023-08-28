USE mnt2;

SELECT  p.productLine, COUNT(p.productCode)
FROM products AS p 
WHERE p.warehouseCode = "d"
GROUP BY p.productLine