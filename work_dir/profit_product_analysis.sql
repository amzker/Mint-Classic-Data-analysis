USE mintclassics;

-- Calculate the current total profit and total storage
SELECT
    SUM(od.profit) AS current_total_profit,
    SUM(p.quantityInStock) AS current_total_storage
FROM
    products p
LEFT JOIN (
    SELECT
        odd.productCode,
        SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS profit
    FROM
        orderdetails odd
    JOIN
        products pp ON odd.productCode = pp.productCode
    GROUP BY
        odd.productCode
) od ON p.productCode = od.productCode;

-- Calculate the adjusted total profit, adjusted total storage, and their differences from the current values
SELECT
    W.warehouseCode,
    W.warehouseName,
    SUM(CASE
        WHEN (od.totalQuantityOrdered / p.quantityInStock) < 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) < 0.5 THEN 0.3 * od.profit
        WHEN (od.totalQuantityOrdered / p.quantityInStock) > 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) > 0.6 THEN 0.8 * od.profit
        ELSE od.profit
    END) AS adjusted_profit,
    SUM(CASE
        WHEN (od.totalQuantityOrdered / p.quantityInStock) < 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) < 0.5 THEN 0.3 * p.quantityInStock
        WHEN (od.totalQuantityOrdered / p.quantityInStock) > 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) > 0.6 THEN -0.8 * p.quantityInStock
        ELSE 0
    END) AS adjusted_storage,
    CASE
        WHEN (od.totalQuantityOrdered / p.quantityInStock) < 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) < 0.5 THEN 'Understocked, Adjusted'
        WHEN (od.totalQuantityOrdered / p.quantityInStock) > 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) > 0.6 THEN 'Overstocked, Adjusted'
        ELSE 'No Adjustment'
    END AS profit_adjustment_label,
    od.profit AS original_profit,
    p.quantityInStock AS original_storage
FROM
    warehouses AS W
JOIN products p ON W.warehouseCode = p.warehouseCode
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
) od ON p.productCode = od.productCode
CROSS JOIN (
    SELECT
        SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS totalTotalProfit
    FROM
        orderdetails odd
    JOIN
        products pp ON odd.productCode = pp.productCode
) AS totalTotalProfit
GROUP BY
    W.warehouseCode, W.warehouseName;

-- Calculate the differences in total profit and total storage and their impact labels
SELECT
    current_total_profit - adjusted_total_profit AS profit_difference,
    CASE
        WHEN current_total_profit < adjusted_total_profit THEN 'Positive Impact on Profit'
        WHEN current_total_profit > adjusted_total_profit THEN 'Negative Impact on Profit'
        ELSE 'No Impact on Profit'
    END AS profit_impact_label,
    current_total_storage - adjusted_total_storage AS storage_difference,
    CASE
        WHEN current_total_storage < adjusted_total_storage THEN 'Positive Impact on Storage'
        WHEN current_total_storage > adjusted_total_storage THEN 'Negative Impact on Storage'
        ELSE 'No Impact on Storage'
    END AS storage_impact_label
FROM (
    -- Subquery to calculate the current total profit and total storage
    SELECT
        SUM(od.profit) AS current_total_profit,
        SUM(p.quantityInStock) AS current_total_storage
    FROM
        products p
    LEFT JOIN (
        SELECT
            odd.productCode,
            SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS profit
        FROM
            orderdetails odd
        JOIN
            products pp ON odd.productCode = pp.productCode
        GROUP BY
            odd.productCode
    ) od ON p.productCode = od.productCode
) AS current
CROSS JOIN (
    -- Subquery to calculate the adjusted total profit, adjusted total storage
    SELECT
        SUM(CASE
            WHEN (od.totalQuantityOrdered / p.quantityInStock) < 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) < 0.5 THEN 0.3 * od.profit
            WHEN (od.totalQuantityOrdered / p.quantityInStock) > 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) > 0.6 THEN 0.8 * od.profit
            ELSE od.profit
        END) AS adjusted_total_profit,
        SUM(CASE
            WHEN (od.totalQuantityOrdered / p.quantityInStock) < 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) < 0.5 THEN 0.3 * p.quantityInStock
            WHEN (od.totalQuantityOrdered / p.quantityInStock) > 0.5 AND (od.profit * 100 / totalTotalProfit.totalTotalProfit) > 0.6 THEN -0.8 * p.quantityInStock
            ELSE 0
        END) AS adjusted_total_storage
    FROM
        warehouses AS W
    JOIN products p ON W.warehouseCode = p.warehouseCode
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
    ) od ON p.productCode = od.productCode
    CROSS JOIN (
        SELECT
            SUM((odd.priceEach - pp.buyPrice) * odd.quantityOrdered) AS totalTotalProfit
        FROM
            orderdetails odd
        JOIN
            products pp ON odd.productCode = pp.productCode
    ) AS totalTotalProfit
    GROUP BY
        W.warehouseCode
) AS adjusted;
