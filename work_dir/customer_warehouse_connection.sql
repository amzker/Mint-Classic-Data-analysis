USE mintclassics;

SELECT
    o.orderNumber,
    c.customerName,
    c.addressLine1 AS customerAddressLine1,
    c.postalCode AS customerPostalCode,
    concat_ws(",",c.city,c.state,c.country,c.postalCode) AS customerLocation,
    c.city AS customerCity,
    c.state AS customerState,
    c.country AS customerCountry,
    w.warehouseCode,
    p.productName,
    od.quantityOrdered,
    od.priceEach,
    emp.employeeNumber,
    offs.officeCode,
    concat_ws(",",offs.city,offs.state,offs.country,offs.postalCode) AS officeLocation,
    offs.city AS officeCity,
    offs.state AS officeState,
    offs.country AS officeCountry,
    offs.postalCode AS officePostalCode
FROM
    orders o
JOIN
    customers c ON o.customerNumber = c.customerNumber
JOIN
    orderdetails od ON o.orderNumber = od.orderNumber
JOIN
    products p ON od.productCode = p.productCode
JOIN
    warehouses w ON p.warehouseCode = w.warehouseCode
JOIN
    employees emp ON c.salesRepEmployeeNumber = emp.employeeNumber
JOIN
    offices offs ON emp.officeCode = offs.officeCode
ORDER BY
    o.orderNumber, p.productName;
