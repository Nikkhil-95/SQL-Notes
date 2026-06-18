-- Dataset - E-commerce Company

CREATE TABLE customers(
customer_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
email VARCHAR(100),
signup_date DATE,
loyalty_points INT
);

-- Insert Records into the 'customers' table

INSERT INTO customers (customer_id, first_name, last_name, city, state, email, signup_date, loyalty_points)
VALUES
(101, 'Amit', 'Sharma', 'Delhi', 'Delhi', 'amit@gmail.com', '2023-01-15', 1200),
(102, 'Priya', 'Verma', 'Mumbai', 'Maharashtra', 'priya@gmail.com', '2022-09-18', 850),
(103, 'Rahul', 'Singh', 'Delhi', 'Delhi', 'rahul@gmail.com', '2021-06-20', 1500),
(104, 'Sneha', 'Patel', 'Ahmedabad', 'Gujarat', 'sneha@gmail.com', '2024-02-01', 500),
(105, 'Arjun', 'Mehta', 'Jaipur', 'Rajasthan', 'arjun@gmail.com', '2020-11-30', 2500),
(106, 'Neha', 'Kapoor', 'Delhi', 'Delhi', 'neha@gmail.com', '2023-08-10', 950),
(107, 'Karan', 'Malhotra', 'Chandigarh', 'Punjab', 'karan@gmail.com', '2022-12-25', 400),
(108, 'Pooja', 'Nair', 'Kochi', 'Kerala', 'pooja@gmail.com', '2021-03-14', 1800),
(109, 'Rohit', 'Joshi', 'Pune', 'Maharashtra', 'rohit@gmail.com', '2024-04-21', 300),
(110, 'Ananya', 'Roy', 'Kolkata', 'West Bengal', 'ananya@gmail.com', '2022-07-07', 1300);

-- Return the following column only
-- customer_id, first_name, city

SELECT
	customer_id,
	first_name,
	city
FROM customers;

-- Return only these columns in this exact order
-- first_name
-- last_name
-- email
-- signup_date

SELECT
	first_name,
	last_name,
	email,
	signup_date
FROM customers;

-- Return the following columns in this exact order:
-- customer_id
-- first_name
-- last_name
-- email
-- loyalty_points

SELECT
	customer_id,
	first_name,
	last_name,
	email,
	loyalty_points
FROM customers;

-- Write a query to return all columns from the customers table

SELECT *
FROM customers;

-- Return the following columns with these aliases:
-- customer_id		Customer ID
-- first_name		First Name
-- last_name		Last Name

SELECT
	customer_id AS "Customer ID",
	first_name AS "First Name",
	last_name AS "Last Name"
FROM customers;

-- Return the following columns with the specified aliases:
-- first_name 		First Name
-- last_name		Last Name
-- city				City
-- email			Email Address

SELECT
	first_name AS "First Name",
	last_name AS "Last Name",
	city AS "City",
	email AS "Email Address"
FROM customers;

-- Return the following columns with the specified aliases:
-- first_name 		First Name
-- last_name		Last Name
-- email			Email
-- Do not use the AS keyword

SELECT
	first_name "First Name",
	last_name "Last Name",
	email "Email"
FROM customers;

-- Write an SQL query to display all unique cities from the customer table.

SELECT DISTINCT(city)
FROM customers;

-- Write an SQL query to display all unique combination of city and state.

SELECT DISTINCT city, state
FROM customers;

-- Write an SQL query to display all unique combination of first_name, last_name and city.

SELECT DISTINCT first_name, last_name, city
FROM customers;

-- Write an SQL query to display all details of the customer whose first_name is Rahul

SELECT *
FROM customers
WHERE first_name = 'Rahul';

-- Write an SQL query to display the following columns:
-- first_name
-- last_name
-- city
-- for the customer who lives in Delhi

SELECT
	first_name,
	last_name,
	city
FROM customers
WHERE city = 'Delhi';

-- Write an SQL query to display
-- customer_id
-- first_name
-- loyalty_points
-- for customers whose loyalty_points are greater than 1000

SELECT
	customer_id,
	first_name,
	loyalty_points
FROM customers
WHERE loyalty_points > 1000;

-- Write an SQL query to display:
-- first_name
-- email
-- for customers whose loyalty points are less than or equal to 500.

SELECT
	first_name,
	email
FROM customers
WHERE loyalty_points <= 500;

-- Write an SQL query to display:
-- first_name
-- last_name
-- signup_date
-- for customers who signed up on 2022-09-18.

SELECT
	first_name,
	last_name,
	signup_date
FROM customers
WHERE signup_date = '2022-09-18';

-- Write an SQL query to display:
-- first_name
-- city
-- loyalty_points
-- for customers who:
-- live in Delhi
-- and have more than 1000 loyalty points.

SELECT
	first_name,
	city,
	loyalty_points
FROM customers
WHERE city = 'Delhi' AND loyalty_points > 1000;

-- Write an SQL query to display:
-- first_name
-- city
-- state
-- for customers who live in Delhi OR Mumbai.

SELECT 
	first_name,
	city,
	state
FROM customers
WHERE city = 'Delhi' or city = 'Mumbai';

-- Write an SQL query to display:
-- first_name
-- state
-- loyalty_points
-- for customers who:
-- do not belong to the Delhi state.

SELECT 
	first_name,
	state,
	loyalty_points
FROM customers
WHERE state != 'Delhi';

-- Write an SQL query to display:
-- first_name
-- city
-- loyalty_points
-- for customers who:
-- live in Delhi or have more than 1800 loyalty points.

SELECT
	first_name,
	city,
	loyalty_points
FROM customers
WHERE city = 'Delhi' OR loyalty_points > 1800;

-- Write an SQL query to display:
-- first_name
-- city
-- state
-- loyalty_points
-- for customers who:
-- live in Delhi AND have more than 1000 loyalty points OR live in Mumbai

SELECT 
	first_name,
	city,
	state,
	loyalty_points
FROM customers
WHERE (city = 'Delhi' AND loyalty_points > 1000) OR city = 'Mumbai';

-- Write an SQL query to display:
-- first_name
-- city
-- state
-- loyalty_points
-- for customers who:
-- do not live in Delhi
-- AND have more than 1000 loyalty points.

SELECT 
	first_name,
	city,
	state,
	loyalty_points
FROM customers
WHERE city != 'Delhi' AND loyalty_points > 1000;

-- Write an SQL query to display:
-- first_name
-- loyalty_points
-- for customers whose loyalty_points are between 1000 and 2000 (inclusive).

SELECT
	first_name,
	loyalty_points
FROM customers
WHERE loyalty_points BETWEEN 1000 AND 2000;

-- Retrieve the first_name, last_name, and signup_date of all customers
-- who signed up between January 1, 2022 and December 31, 2023 (inclusive).

SELECT
	first_name,
	last_name,
	signup_date
FROM customers
WHERE signup_date BETWEEN '2022-01-01' AND '2023-12-31';

-- Retrieve the first_name, last_name, and loyalty_points of customers
-- whose loyalty points are not between 500 and 1500.

SELECT
	first_name,
	last_name,
	loyalty_points
FROM customers
WHERE loyalty_points NOT BETWEEN 500 AND 1500;

-- Retrieve the first_name, last_name, and city of all customers
-- who are from Delhi, Mumbai, or Kochi.

SELECT 
	first_name,
	last_name,
	city
FROM customers
WHERE city IN ('Delhi', 'Mumbai', 'Kochi');

-- Retrieve the first_name, last_name, and state of all customers
-- who are not from Maharashtra, Gujarat, or Rajasthan.

SELECT 
	first_name,
	last_name,
	state
FROM customers
WHERE state NOT IN ('Maharashtra', 'Gujarat', 'Rajasthan');

-- Retrieve the first_name, last_name, and email of all customers
-- whose email starts with the letter 'a'.

SELECT 
	first_name,
	last_name,
	email
FROM customers
WHERE email LIKE 'a%';

-- Retrieve the first_name, last_name, and email of all customers 
-- whose email contains the string 'ra' anywhere in it.

SELECT
	first_name,
	last_name,
	email
FROM customers
WHERE email LIKE '%ra%';

-- Retrieve the first_name, last_name, and email of all customers
-- whose email does not end with '@gmail.com'.

SELECT 
	first_name,
	last_name,
	email
FROM customers
WHERE email NOT LIKE '%@gmail.com';

-- Retrieve the first_name, last_name, state, loyalty_points, and signup_date of customers who:
-- Are from Delhi or Maharashtra, AND
-- Have loyalty points between 800 and 1600, AND
-- Signed up after January 1, 2022

SELECT
	first_name,
	last_name,
	state,
	loyalty_points,
	signup_date
FROM customers
WHERE (state = 'Delhi' OR state = 'Maharashtra')
	AND loyalty_points BETWEEN 800 AND 1600
	AND signup_date > '2022-01-01';

-- Retrieve the first_name, last_name, and loyalty_points of all customers 
-- where loyalty_points is NULL.

SELECT
	first_name,
	last_name,
	loyalty_points
FROM customers
WHERE loyalty_points IS NULL;

-- Retrieve the first_name, last_name, and email of all customers 
-- where email is not NULL.

SELECT 
	first_name,
	last_name,
	email
FROM customers
WHERE email IS NOT NULL;

-- Retrieve the first_name, last_name, and loyalty_points of customers 
-- where loyalty_points is NOT NULL AND is greater than 1000.

SELECT 
	first_name,
	last_name,
	loyalty_points
FROM customers
WHERE loyalty_points IS NOT NULL AND loyalty_points > 1000;

-- Retrieve the first_name, last_name, and loyalty_points
-- but display 'Not Assigned' instead of NULL for any customer where loyalty_points is NULL.

SELECT
	first_name,
	last_name,
	COALESCE(loyalty_points :: TEXT, 'Not Assigned') AS loyalty_points
FROM customers;

-- Retrieve first_name, last_name, and loyalty_points 
-- sorted by loyalty_points in descending order.

SELECT
	first_name,
	last_name,
	loyalty_points
FROM customers
ORDER BY loyalty_points DESC;

-- Retrieve first_name, last_name, state, and loyalty_points 
-- sorted by state alphabetically (A→Z), and within the same state, by loyalty points highest first.

SELECT
	first_name,
	last_name,
	state,
	loyalty_points
FROM customers
ORDER BY state ASC, loyalty_points DESC;

-- Retrieve first_name, last_name, and loyalty_points
-- add a column called points_after_bonus that is loyalty_points + 200
-- and sort by points_after_bonus descending.

SELECT
	first_name,
	last_name,
	loyalty_points,
	loyalty_points + 200 AS points_after_bonus
FROM customers
ORDER BY points_after_bonus DESC;

-- Retrieve first_name, last_name, and loyalty_points 
-- sorted by loyalty_points ascending, with NULLs pushed to the bottom.

SELECT
	first_name,
	last_name,
	loyalty_points
FROM customers
ORDER BY loyalty_points ASC NULLS LAST;

-- Retrieve first_name, last_name, state, loyalty_points, and a column points_after_bonus (loyalty_points + 500). 
-- Sort by state ascending, then points_after_bonus descending, NULLs last.

SELECT 
	first_name,
	last_name,
	state,
	loyalty_points,
	loyalty_points + 500 AS points_after_bonus
FROM customers
ORDER BY state ASC, points_after_bonus DESC NULLS LAST;

-- Retrieve the first_name, last_name, and loyalty_points of the top 3 customers with the highest loyalty points.

SELECT
	first_name,
	last_name,
	loyalty_points
FROM customers
ORDER BY loyalty_points DESC
LIMIT 3;

-- Retrieve first_name, last_name, and loyalty_points 
-- sorted by loyalty_points descending — but skip the top 3 and return the next 3

SELECT 
	first_name,
	last_name, 
	loyalty_points
FROM customers
ORDER BY loyalty_points DESC
LIMIT 3 OFFSET 3;

-- OFFSET = (page_number - 1) * page_size

-- Retrieve first_name, last_name, and customer_id sorted by customer_id ascending
-- return page 4 with a page size of 2.

SELECT
	first_name,
	last_name,
	customer_id
FROM customers
ORDER BY customer_id ASC
LIMIT 2 OFFSET 6;

-- Cursor-based Pagination
-- Retrieve first_name, last_name, and customer_id of the next 3 customers after customer_id 105
-- sorted by customer_id ascending.

SELECT
	first_name,
	last_name,
	customer_id
FROM customers
WHERE customer_id > 105
ORDER BY customer_id ASC
LIMIT 3;

-- Retrieve first_name, last_name, city, and loyalty_points of the 2nd and 3rd highest loyalty point customers 
-- who are not from Delhi.

SELECT 
	first_name,
	last_name,
	city,
	loyalty_points
FROM customers
WHERE city != 'Delhi'
ORDER BY loyalty_points DESC
LIMIT 2 OFFSET 1;

-- Retrieve first_name, last_name, and state — add a column called region that maps states as follows:
-- Delhi → 'North'
-- Maharashtra → 'West'
-- Gujarat → 'West'
-- Everything else → 'Other'

SELECT
	first_name,
	last_name,
	state,
	CASE state
		WHEN 'Delhi' THEN 'North'
		WHEN 'Maharashtra' THEN 'West'
		WHEN 'Gujarat' THEN 'West'
		ELSE 'Other'
	END AS region
FROM customers;

-- Retrieve first_name, last_name, loyalty_points, and a column called customer_tier based on:
-- 2000 and above → 'Platinum'
-- 1000 to 1999 → 'Gold'
-- 500 to 999 → 'Silver'
-- Below 500 → 'Bronze'
-- sort result in this custom order. Platinum -> Gold -> Silver -> Bronze ->

SELECT
	first_name,
	last_name,
	loyalty_points,
	CASE
		WHEN loyalty_points >= 2000 THEN 'Platinum'
		WHEN loyalty_points >= 1000 THEN 'Gold'
		WHEN loyalty_points >= 500 THEN 'Silver'
		ELSE 'Bronze'
	END AS customer_tier
FROM customers
ORDER BY 
	CASE
		WHEN loyalty_points >= 2000 THEN 1
		WHEN loyalty_points >= 1000 THEN 2
		WHEN loyalty_points >= 500 THEN 3
		ELSE 4
	END ASC;

-- Retrieve first_name, last_name, city, loyalty_points, and a column called priority_customer that shows:
-- 'High Priority' — if city is Delhi AND loyalty_points > 1000
-- 'Medium Priority' — if city is Delhi AND loyalty_points <= 1000
-- 'Standard' — everyone else

SELECT
	first_name,
	last_name,
	city,
	loyalty_points,
	CASE
		WHEN city = 'Delhi' AND loyalty_points > 1000 THEN 'High Priority'
		WHEN city = 'Delhi' AND loyalty_points <= 1000 THEN 'Medium Priority'
		ELSE 'Standard'
	END AS priority_customer
FROM customers;




		



		

	






