USE mnt2;

-- Add the capacity column to the warehouses table
ALTER TABLE warehouses
ADD COLUMN capacity INT;

SET SQL_SAFE_UPDATES = 1;
-- Update the capacity values for each warehouse
UPDATE warehouses
SET capacity = CASE
    WHEN warehouseCode = 'b' THEN 256493
    WHEN warehouseCode = 'a' THEN 154857
    WHEN warehouseCode = 'c' THEN 209224
    WHEN warehouseCode = 'd' THEN 106681
    -- Add more cases for other warehouse codes if needed
    ELSE 0 -- Default value in case of no match
END;
