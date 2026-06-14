-- Create a table named customers
-- customer_id      INT                 PRIMARY KEY
-- customer_name    VARCHAR(100)        SHOULD NOT BE NULL
-- email            VARCHAR(100)        SHOULD BE UNIQUE
-- city             VARCHAR(50)
-- signup_date      DATE

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    signup_date DATE
);

-- Add a new column names phone_number
-- Data type should be VARCHAR(15)

ALTER TABLE customers
ADD COLUMN phone_number VARCHAR(15);

-- Insert a record in customers table

INSERT INTO customers (customer_id, customer_name, email, city, signup_date, phone_number)
VALUES (101, 'Rahul Sharma', 'rahul@gmail.com', 'Delhi', '2025-01-15', '9876543210');

-- Insert Multiple rows in customers table

INSERT INTO customers
VALUES (102, 'Priya Verma', 'priya@gmail.com', 'Mumbai', '2025-02-10', '9876543211'),
(103, 'Amit Singh', 'amit@gmail.com', 'Pune', '2025-03-05', '9876543212'),
(104, 'Neha Gupta', 'neha@gmail.com', 'Bangalore', '2025-03-18', '9876543213');

-- The customer Rahul Sharma (customer_id = 101) has moved from Delhi to Gurgaon.
-- Update the city for customer_id 101 to Gurgaon.

UPDATE customers
SET city = 'Gurgaon'
WHERE customer_id = 101
RETURNING * ;

-- The company has decided to give all customers from Mumbai a new city value of Navi Mumbai.
-- Write a single SQL query to update all records

UPDATE customers
SET city = 'Navi Mumbai'
WHERE city = 'Mumbai'
RETURNING * ;

-- The customer with 'customer_id = 104' has requested account deletion.
-- Write a SQL query to delete only that customer from the customers table.

DELETE FROM customers
WHERE customer_id = 104;

-- The company wants to remove all customers who signed up before 2025-03-01.

DELETE FROM customers
WHERE signup_date < '2025-03-01';

-- The business now wants to track customer loyalty points.
-- Add a new Column 'loyalty_points' type INT and set a default value of 0

ALTER TABLE customers
ADD COLUMN loyalty_points INT DEFAULT 0;

-- The business team has noticed that some phone numbers may include:
-- Country codes (+91)
-- Spaces
-- Future international numbers
-- Change the phone_number column so that it can store up to 20 characters.
-- After changing the column, make city a NOT NULL column.

ALTER TABLE customers
ALTER COLUMN phone_number TYPE VARCHAR(20);

ALTER TABLE customers
ALTER COLUMN city SET NOT NULL;

-- The business has decided that the table name customers is too generic.
-- Rename the table to customer_master
-- Rename column name customer_name to full_name

ALTER TABLE customers
RENAME TO customer_master;

ALTER TABLE customer_master
RENAME COLUMN customer_name TO full_name;

-- After renaming the table and column, a new requirement arrives:
-- Add a new column 'status' type VARCHAR(20) and set default value 'Active'

ALTER TABLE customer_master
ADD COLUMN status VARCHAR(20) DEFAULT 'Active';

-- Assume customer_master currently contains 10 lakh (1,000,000) rows.
-- The company wants to remove all rows from the table, but keep:
-- Table structure
-- Columns
-- Constraints
-- Indexes

TRUNCATE TABLE customer_master;

-- The company wants to remove only customers from:
-- city = 'Delhi'

DELETE FROM customer_master
WHERE city = 'Delhi';





































