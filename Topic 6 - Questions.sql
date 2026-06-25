CREATE TABLE orders (
    order_id          SERIAL PRIMARY KEY,
    customer_name     VARCHAR(50),
    product_category  VARCHAR(30),
    product_name      VARCHAR(50),
    quantity          INT,
    unit_price        NUMERIC(10,2),
    order_date        DATE,
    region            VARCHAR(20),
    payment_status    VARCHAR(20),
    delivery_partner  VARCHAR(30),
    discount_percent  NUMERIC(5,2),
    is_prime_member   BOOLEAN
);

INSERT INTO orders
(customer_name, product_category, product_name, quantity, unit_price, order_date, region, payment_status, delivery_partner, discount_percent, is_prime_member)
VALUES
('Rohan Mehta',      'Electronics', 'Wireless Mouse',     2,  799.00,  '2023-01-15', 'North', 'Completed', 'Delhivery', 10.0, TRUE),
('Priya Nair',       'Clothing',    'Cotton Kurta',       1, 1299.00,  '2023-02-10', 'South', 'Completed', 'Ekart',     NULL, FALSE),
('Amit Verma',       'Groceries',   'Basmati Rice 5kg',   3,  450.00,  '2023-02-20', 'North', 'Completed', NULL,        5.0,  TRUE),
('Sneha Reddy',      'Electronics', 'Bluetooth Speaker',  1, 2199.00,  '2023-03-05', 'South', 'Pending',   NULL,        NULL, FALSE),
('Karan Singh',      'Books',       'Atomic Habits',      4,  399.00,  '2023-03-18', 'West',  'Completed', 'BlueDart',  0.0,  TRUE),
('Anjali Gupta',     'Furniture',   'Study Table',        1, 4999.00,  '2023-04-02', 'East',  'Completed', 'Delhivery', 15.0, FALSE),
('Vikram Rao',       'Electronics', 'USB-C Charger',      2,  599.00,  '2023-04-25', 'North', 'Cancelled', NULL,        NULL, TRUE),
('Neha Joshi',       'Beauty',      'Face Serum',         2,  699.00,  '2023-05-09', 'South', 'Completed', 'Ekart',     10.0, TRUE),
('Rahul Kapoor',     'Clothing',    'Denim Jacket',       1, 1899.00,  '2023-06-14', 'West',  'Completed', 'BlueDart',  20.0, FALSE),
('Pooja Iyer',       'Groceries',   'Cooking Oil 1L',     5,  180.00,  '2023-06-30', 'South', 'Refunded',  'Ekart',     NULL, FALSE),
('Arjun Desai',      'Electronics', 'Laptop Stand',       1, 1099.00,  '2023-07-11', 'West',  'Completed', NULL,        0.0,  TRUE),
('Divya Pillai',     'Books',       'The Alchemist',      2,  299.00,  '2023-08-03', 'South', 'Completed', 'Delhivery', 5.0,  FALSE),
('Manish Tiwari',    'Furniture',   'Office Chair',       1, 3499.00,  '2023-09-19', 'North', 'Pending',   NULL,        NULL, TRUE),
('Kavita Menon',     'Beauty',      'Lipstick Set',       3,  450.00,  '2023-10-07', 'South', 'Completed', 'Ekart',     12.5, FALSE),
('Suresh Yadav',     'Electronics', 'Wireless Mouse',     1,  799.00,  '2023-11-22', 'East',  'Completed', 'BlueDart',  0.0,  FALSE),
('Ritu Bhatia',      'Clothing',    'Silk Saree',         1, 5999.00,  '2024-01-12', 'North', 'Completed', 'Delhivery', 25.0, TRUE),
('Naveen Krishnan',  'Groceries',   'Wheat Flour 10kg',   2,  399.00,  '2024-02-08', 'South', 'Completed', NULL,        NULL, TRUE),
('Sanjana Das',      'Books',       'Sapiens',            1,  549.00,  '2024-03-15', 'East',  'Cancelled', NULL,        NULL, FALSE),
('Harish Pillai',    'Furniture',   'Bookshelf',          2, 2299.00,  '2024-04-21', 'West',  'Completed', 'BlueDart',  10.0, TRUE),
('Meera Subramanian','Electronics', 'Bluetooth Speaker',  1, 2199.00,  '2024-05-06', 'South', 'Completed', 'Ekart',     5.0,  FALSE);



-- Write a query to find the total number of orders placed

SELECT 
	COUNT (*) AS total_orders
FROM orders;

-- Write a query to find how many orders have a delivery partner assigned

SELECT
	COUNT(*) AS orders_assigned
FROM orders
WHERE delivery_partner IS NOT NULL;

-- Write a query to find how many distinct product categories have been orders

SELECT
	COUNT(DISTINCT product_category ) AS number_of_distinct_product
FROM orders;

-- Write a query to count how many orders are either Cancelled or Refunded

SELECT
	COUNT(*) AS cancelled_or_refunded_product
FROM orders
WHERE payment_status IN ('Cancelled', 'Refunded');

-- Write a query to return 
-- Total number of orders
-- Number of orders with a non-NULL delivery partner
-- Number of orders with NULL delivery partner
-- Number of distinct region

SELECT
	COUNT(*) AS total_orders,
	COUNT(delivery_partner) AS order_assigned,
	COUNT(*) - COUNT(delivery_partner) AS unassigned_orders,
	COUNT(DISTINCT region) AS distinct_region
FROM orders;

-- Write a query to find the total revenue generated from all orders.

SELECT
	SUM(quantity * unit_price) AS total_revenue
FROM orders;

-- Write a query to find the total quantity sold for each product category

SELECT
	product_category,
	SUM(quantity) AS total_quantity
FROM orders
GROUP BY product_category;

-- Write a query to find the total revenue after discount for each order.
-- Return - customer_name, product_name, total_revenue, discounted_revenue
SELECT
	customer_name,
	product_name,
	(quantity * unit_price) AS total_revenue,
	ROUND((quantity * unit_price) * (1 - COALESCE(discount_percent, 0)/100), 2) AS discounted_revenue
FROM orders

-- Write a query to find the total discounted revenue per region

SELECT
	region,
	ROUND(SUM((quantity * unit_price) * (1 - COALESCE(discount_percent, 0)/100)), 2) AS discounted_revenue
FROM orders
GROUP BY region;

-- Write a query to find, for each delivery partner (excluding NULLs), 
-- the total revenue (no discount needed here) 
-- only from orders with payment_status = 'Completed'. 
-- Order the result by total revenue descending.

SELECT
	delivery_partner,
	SUM(quantity * unit_price) AS total_revenue
FROM orders
WHERE delivery_partner IS NOT NULL AND payment_status = 'Completed'
GROUP BY delivery_partner
ORDER BY total_revenue DESC;

-- Write a query to find the average order value

SELECT
	ROUND(AVG(quantity * unit_price), 2) AS avg_order_value
FROM orders;

-- Write a query to find the average unit price per product category.

SELECT
	product_category,
	ROUND(AVG(unit_price),2) AS avg_unit_price
FROM orders
GROUP BY product_category;

-- Write a query to return average quantity where delivery partner is non-NULLs and average quantity of all orders
-- Observe the difference because of NULL handeling

SELECT
	ROUND(AVG(quantity),2) AS avg_quantity_all,
	ROUND(AVG(quantity) FILTER (WHERE delivery_partner IS NOT NULL),2) AS avg_quantity_assigned_only
FROM orders

-- Write a query to find the average discounted revenue
-- only for is_prime_member = TRUE

SELECT
	ROUND(AVG((quantity * unit_price) * (1 - COALESCE(discount_percent, 0)/100)),2) AS active_member_discounted_revenue
FROM orders
WHERE is_prime_member = TRUE;

-- Write a query to find the highest and lowest unit price in the entire orders table

SELECT
	MIN(unit_price) AS lowest_unit_price,
	MAX(unit_price) AS highest_unit_price
FROM orders;

-- Write a query to find the earliest and most recent order date for each region.

SELECT
	region,
	MIN(order_date) AS earliest_order_date,
	MAX(order_date) AS recent_order_date
FROM orders
GROUP BY region;

-- Write a query to find the price range (i.e., MAX(unit_price) - MIN(unit_price)) for each product_category
-- and only show categories where that range is greater than 1000.

SELECT
	product_category,
	MAX(unit_price) - MIN(unit_price) AS price_range
FROM orders
GROUP BY product_category
HAVING MAX(unit_price) - MIN(unit_price) > 1000;

-- Write a query to find, for each region, 
-- the most recent order date among only "Completed" orders. 
-- If a region has no Completed orders at all, 
-- it should still appear in the result (with NULL for that date) rather than disappear entirely.

SELECT
	region,
	MAX(order_date) FILTER (WHERE payment_status = 'Completed') AS most_recent_order
FROM orders
GROUP BY region;

-- Write a query to find the number of orders and total revenue 
-- for each combination of region and payment_status

SELECT
	region,
	payment_status,
	COUNT(*) AS total_orders,
	SUM(quantity * unit_price) AS total_revenue
FROM orders
GROUP BY region, payment_status;

-- Write a query to find the number of orders per product_category, 
-- but only counting orders placed in the year 2023
-- Order results by order count DESC

SELECT
	product_category,
	COUNT(*) as total_orders
FROM orders
WHERE EXTRACT (YEAR FROM order_date) = 2023
GROUP BY product_category
ORDER BY total_orders DESC;

-- Write a query that groups orders into a custom price teir based on unit_price
-- 'Premium' if unit_price >= 2000
-- 'Mid-range' if unit_price >= 500 and < 2000
-- 'Budget' if unit_price < 500
-- Show each tier along with the count of orders and average unit_price in that tier
-- Order by average unit_price descending

SELECT
	CASE
		WHEN unit_price >= 2000 THEN 'Premium'
		WHEN unit_price >= 500 THEN 'Mid-range'
		ELSE 'Budget'
	END AS price_tier,
	COUNT(*) AS total_orders,
	ROUND(AVG(unit_price), 2) AS avg_price
FROM orders
GROUP BY 
	CASE
		WHEN unit_price >= 2000 THEN 'Premium'
		WHEN unit_price >= 500 THEN 'Mid-range'
		ELSE 'Budget'
	END
ORDER BY avg_price DESC;

-- Write a query to find the total revenue per delivery partner per year
-- Exclude rows where delivery_partner is NULL. 
-- Order by year and total revenue descending

SELECT
	delivery_partner,
	SUM(unit_price * quantity) AS total_revenue,
	EXTRACT (YEAR FROM order_date) AS year
FROM orders
WHERE delivery_partner IS NOT NULL
GROUP BY 	delivery_partner,
		 	EXTRACT(YEAR FROM order_date)
ORDER BY year, total_revenue DESC;

-- Write a query to find all product categories 
-- where the total number of orders is greater than 2.

SELECT
	product_category,
	COUNT(*) AS total_orders
FROM orders
GROUP BY product_category
HAVING COUNT(*) > 2;

-- Write a query to find all regions where the average unit_price is > 1000
-- Show the region and the average unit price

SELECT
	region,
	ROUND(AVG(unit_price),2) AS avg_unit_price
FROM orders
GROUP BY region
HAVING AVG(unit_price) > 1000;

-- Write a query to find all delivery partners (excluding NULLs) where
-- Total number of orders handled is greater than 2 and
-- Totol revenue generated is greater than 5000
-- Show delivery_partner, order count, and total_revenue

SELECT
	delivery_partner,
	COUNT(*) AS total_orders,
	SUM(quantity * unit_price) AS total_revenue
FROM orders
WHERE delivery_partner IS NOT NULL
GROUP BY delivery_partner
HAVING
	COUNT(*) > 2 AND
	SUM(quantity * unit_price) > 5000;

-- Write a query to find all product categories 
-- Where difference between the highest and lowest unit price is between 500 and 3000
-- Show the category, max price, min price and the calculated range

SELECT
	product_category,
	MIN(unit_price) AS min_price,
	MAX(unit_price) AS max_price,
	MAX(unit_price) - MIN(unit_price) AS calculated_range
FROM orders
GROUP BY product_category
HAVING MAX(unit_price) - MIN(unit_price) BETWEEN 500 AND 3000;

-- Write a query to find all regions where
-- Only considering completed orders
-- The total revenue is greater than 5000, AND 
-- The number of distinct product category ordered is greater than 1
-- Show region, total_revenue and distinct category count

SELECT
	region,
	SUM(quantity * unit_price) AS total_revenue,
	COUNT(DISTINCT product_category) AS product_category
FROM orders
WHERE payment_status = 'Completed'
GROUP BY region
HAVING	SUM(quantity * unit_price) > 5000 AND
		COUNT(DISTINCT(product_category)) > 1	

-- Write a single query that shows side by side
-- 1. COUNT(*) - total rows
-- 2. COUNT(discount_percent) - non-NULL discount rows
-- 3. The number of rows where discount_percent is NULL

SELECT
	COUNT(*) AS total_rows,
	COUNT(discount_percent) AS non_null_discount_rows,
	COUNT(*) - COUNT(discount_percent) AS null_discount_rows
FROM orders;

-- Write a query that shows the difference between two approaches to calculating average discount
-- 1. AVG(discount_percent)
-- 2. AVG(COALESCE(discount_percent, 0))

SELECT
	ROUND(AVG(discount_percent),2) AS avg_ignoring_nulls,
	ROUND(AVG(COALESCE(discount_percent, 0)),2) AS avg_treating_null_as_zero
FROM orders;

-- SUM() returns NULL (not 0) when all values in the column are NULL. 
-- Write a query that demonstrates NULL-safe SUM using COALESCE
-- show both the raw SUM(discount_percent) and a NULL-safe version side by side.

SELECT
	SUM(discount_percent) AS raw_rum,
	SUM(COALESCE(discount_percent, 0)) AS null_safe_sum
FROM orders;
	
-- Write a query showing per region:
-- 1. AVG(discount_percent) — ignoring NULLs
-- 2. AVG(COALESCE(discount_percent, 0)) — treating NULL as 0%
-- 3. The difference between these two averages (round all three to 2 decimal places)
-- Which region shows the largest difference, and what does that tell you about that region's data?

SELECT
	region,
	ROUND(AVG(discount_percent), 2) AS avg_ignoring_nulls,
	ROUND(AVG(COALESCE(discount_percent, 0)), 2) AS avg_treating_null_as_zero,
	ROUND(AVG(discount_percent) - AVG(COALESCE(discount_percent, 0)),2) AS difference_between_avg
FROM orders
GROUP BY region
ORDER BY difference_between_avg DESC;

-- North Region has many orders placed without any discount 
-- 1. either customers there buy at full price more often or
-- 2. discount campaigns aren't reaching that region effectively

-- Write a query that shows, for each payment_status, the following in a single query:
-- 1. Total number of orders
-- 2. Number of orders with a NULL delivery_partner
-- 3. Percentage of orders with NULL delivery_partner (rounded to 2 decimal places)
-- 4. SUM(quantity * unit_price) — but return 0 instead of NULL if no revenue exists for that group
-- Order by NULL delivery partner percentage descending.

SELECT
    payment_status,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE delivery_partner IS NULL) AS null_delivery_orders,
    ROUND(COUNT(*) FILTER (WHERE delivery_partner IS NULL)::NUMERIC / COUNT(*) * 100, 2) AS null_delivery_pct,
    COALESCE(SUM(quantity * unit_price), 0) AS total_revenue
FROM orders
GROUP BY payment_status
ORDER BY null_delivery_pct DESC;

-- Write a single query that returns one row with the following counts side by side:
-- 1. Total orders
-- 2. Orders where is_prime_member = TRUE
-- 3. Orders where is_prime_number = FALSE

SELECT
	COUNT(*) AS total_orders,
	COUNT(*) FILTER (WHERE is_prime_member = TRUE) AS prime_members, 
	COUNT(*) FILTER (WHERE is_prime_member = FALSE) AS non_prime_members
FROM orders;

-- Write a single query that shows total revenue broken down by payment_status
-- but instead of using GROUP BY, show each status as a separate column in one row:
-- 1. completed_revenue
-- 2. pending_revenue
-- 3. cancelled_revenue
-- 4. refunded_revenue

SELECT
    SUM(quantity * unit_price) FILTER (WHERE payment_status = 'Completed')  AS completed_revenue,
    SUM(quantity * unit_price) FILTER (WHERE payment_status = 'Pending')    AS pending_revenue,
    SUM(quantity * unit_price) FILTER (WHERE payment_status = 'Cancelled')  AS cancelled_revenue,
    SUM(quantity * unit_price) FILTER (WHERE payment_status = 'Refunded')   AS refunded_revenue
FROM orders;




















