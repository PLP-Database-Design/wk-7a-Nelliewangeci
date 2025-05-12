-- Question 1.
-- Create a new table to store the 1NF compliant data.
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Populate the new table by splitting the Products column from the original table.
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM
    ProductDetail
CROSS JOIN (
    SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
) AS numbers
WHERE
    n <= LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) + 1;

-- Select all data from the new table
SELECT * FROM ProductDetail_1NF;


-- Question 2
-- Create a new table for Orders (OrderID, CustomerName)
CREATE TABLE Orders2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Populate the Orders table
INSERT INTO Orders2NF (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create a new table for OrderProducts (OrderID, Product, Quantity)
CREATE TABLE OrderProducts2NF (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders2NF(OrderID)
);

-- Populate the OrderProducts table
INSERT INTO OrderProducts2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Verify the new tables
SELECT * FROM Orders2NF;
SELECT * FROM OrderProducts2NF;
