# Topic 4: SELECT

## Definition
SELECT retrieves data from tables. It never modifies data.
Returns a **result set** — a temporary in-memory table.

## Execution Order (CRITICAL)
Written:  SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT

Executed: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

Consequence: SELECT aliases CANNOT be used in WHERE, GROUP BY, or HAVING.
             SELECT aliases CAN be used in ORDER BY.

---

## SELECT All Columns

### Syntax

```sql
-- The * wildcard means "all columns"
SELECT * 
FROM employees;
```

## SELECT Specified Column

### Syntax

```sql
-- Always specify exactly what you need
SELECT first_name, last_name, salary
FROM employees;
```

---

## Column Aliases - AS

### Definition:

A temporary name assigned to a column or table within a qyery. It exists only for the duration of that query using the AS keyword.

```sql
-- Basic alias
SELECT
    first_name  AS  "First_Name",
    last_name   AS  "Last Name",
    salary      AS  annual_salary
FROM employees;

-- AS keyword is optional - but always include it for readability
SELECT first_name "First Name", salary annual_salary
FROM employees;
```
### Nuance - Quoting aliases:

*   AS first_name - lowercase, no spaces - no quotes needed
*   AS "First Name" - has a space - double quotes required
*   AS 'First Name' - single quotes are WRONG here - single quotes are for string values, not identifiers


---

## Expressions & Calculations in SELECT

```sql
-- Arithmetic expressions
SELECT
    first_name,
    last_name,
    salary,
    salary * 12     AS annual_salary,
    salary * 0.10   AS bonus,
FROM employees;

--String concatenation using ||
SELECT
    first_name || '' || last_name       AS full_name,
    first_name || '('|| job_titel ||')' AS display_name
FROM employees;

-- CONCAT function (handles NULLS differently)
SELECT CONCAT (first_name,'',last_name) AS full_name
FROM employees;
```
### Nuance - NULL in expression

Any arithmetic operation involving NULL returns NULL.

salary + NULL = NULL

'Alice' || NULL = NULL

CONCAT ('Alice', NULL) = 'Alice' (CONCAT ignores NULLs)

---

## DISTINCT - Removing Duplicates

### Definition 

DISTINCT keyword eliminates duplicates rows from the result set. Applied after all rows are retrieved, before ORDER BY.

```sql
-- All job titles that exists (no duplicates)
SELECT DISTINCT job_title 
FROM employees;

-- Distinct combination of dept + job title
SELECT DISTINCT dept_id, job_title 
FROM employees;

-- How many unique departments have employees?
SELECT COUNT(DISTINCT dept_id) 
FROM employees;
```


## Literal Values Constants in SELECT

### DEfinition:

Literal Values are fixed hardcooded values in a query that doesn't come from a column.

```sql
--- You can SELECT literal values
SELECT
    first_name,
    salary,
    'Active Employee'       AS status       -- string literal
    2024                    AS report_year  -- integer literal
    TRUE                    AS is_current   -- boolean literal
```

## Type Casting

### Definition:

Type Casting is converting a valu from one data type to another. In PostgreSQL, :: is the cast operator (shorthand for CAST(value as type)).

The  :: operator is PostgreSQL specific. In MySQL/SQL Server, use CAST() or CONVERT().

```sql
SELECT CAST('2024-01-15' AS DATE);
SELECT '42' :: INTEGER;     -- PostgreSQL shorthand for CAST
SELECT 9.99 :: DECIMAL(10,2);
```

## Useful SELECT Functions

### String Function

```sql
SELECT
    UPPER(first_name)       AS upper_name,      -- ALICE
    LOWER(last_name)        AS lower_name,      -- sharma
    LENGTH(email)           AS email_length,    -- 25
    TRIM('   Alice   ')     AS trimmed,         -- 'Alice'
    LTRIM('   Alice')       AS lift_trim,       -- 'Alice'
    RTRIM('Alice   ')       AS right_trim       -- 'Alice'
    SUBSTRING(email, 1, 5)  AS emmail_prefix,   -- first 5 char
    REPLACE(email, '@company.com', '') AS username,  -- strip domain
    LEFT(first_name, 1)     AS initial,         -- 'A' 
```

### Numeric Function

```sql
SELECT
    ROUND(salary, -3)       AS rounded_to_thousands,    -- 95000 - 95000
    ROUND(9.5678, 2)        AS two_decimal,             -- 9.57
    FLOOR(9.9)              AS floor_value,             -- 9
    MOD(17,5)               AS remainder,               -- 2
    POWER(2,10)             AS two_to_ten               -- 1024
FROM employees;
```

### Date Function

```sql
SELECT
    hire_date,
    EXTRACT(YEAR FROM hire_date)        AS hire_year,
    EXTRACT(MONTH FROM hire_date)       AS hire_month,
    EXTRACT(DOW FROM hire_date)         AS day_of_week,
    AGE(CURRENT_DATE, hire_date)        AS tenure,
    hire_date + INTERVAL '90 days'      AS probation_end,
    TO-CHAR(hire_date, 'DD Month YYYY') AS formatted_date
FROM employees;
```

#### Extract:

Function that retrieves a specific component (year, month, day, hour, etc) from a date/timestamp value.

#### Age():

PostgreSQL function that returns the interval between two dates/timestamps. AGE(end, start) returns a human-readable interval like 4 years 3 months 12 days.

#### TO_CHAR():

Converts a date or number to a formatted string.

## CASE Expression in SELECT

SQL conditional logic evaluates conditions in order and returns the value from the first matching branch. Always ends with END.


```sql
-- Simple CASE
SELECT
    first_name,
    dept_id,
    CASE dept_id
        WHEN 1 THEN 'Engineering'
        WHEN 2 THEN 'Marketing'
        ELSE 'Other'   
    END AS department_name
FROM employees;

-- Searched CASE
SELECT
    first_name,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'Senior'
        WHEN salary >= 70000  THEN 'Mid-level'
        ELSE 'Junior'
    END AS salary_band
FROM employees;
```
CASE Evaluates top to bottom and stops at first TRUE. Order Matters. Put the most restrictive condition first.

---

## NULL Handling Functions
```sql
-- COALESCE: Returns first non-NULL valu in the list
SELECT
    first_name,
    COALESCE(manager_id :: TEXT, 'No Manager') AS manager,
    COALESCE(phone_number, email, 'No Contact') AS contact
FROM employees;

-- NULLIF: Returns NULL if two values are equal, else returns first value
-- Use Case: prevent division by zero
SELECT
    total_sales/NULLIF(total_orders, 0) AS avg_order_value
FROM sales_summary;

-- IS DISTINCT FROM: NULL-safe comparison
-- Unlike =, this treats NULL as a comparable value
SELECT *
FROM employees
WHERE manager_id IS DISTINCT FROM 1;

-- Returns rows where manager_id != 1 AND rows where manager_id IS NULL
```


---

## ORDER BY - Sorting Result

### Definition:

Clause that sorts the result set by one or more columns or expression. Executes after SELECT - so you can use SELECT aliases here.


```sql
-- Single column, ascending (default)
SELECT first_name, salary FROM employees
ORDER BY salary;

-- Descending
SELECT first_name, salary FROM employees
ORDER BY salary DESC;

-- Multiple columns: primary sort by dept, secondary by salary
SELECT first_name, dept_id, salary FROM employees
ORDER BY dept_id ASC, salary DESC;

-- Order by alias (works because ORDER BY runs after SELECT)
SELECT first_name, salary * 12 AS annual_salary
FROM employees
ORDER BY annual_salary DESC;

-- Order by column position (legal but avoid — fragile)
SELECT first_name, salary FROM employees
ORDER BY 2 DESC;    -- 2 = second column = salary

-- NULL handling in ORDER BY
ORDER BY salary DESC NULLS LAST;    -- NULLs go to bottom
ORDER BY salary ASC  NULLS FIRST;   -- NULLs go to top
```
Default: ASC. PostgreSQL ASC = NULLs last; DESC = NULLs first.

---

## LIMIT & OFFSET (Pagination)

### Definition: LIMIT

Restricts the number of rows returned by the query.

### Definition: OFFSET

Skips a specified number of rows before starting to return result.


```sql
-- Top 5 highest paid employees
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- Page 2 (rows 6-10) — pagination pattern
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 5;

-- Page 3 (rows 11-15)
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 10;

-- General pagination formula:
-- OFFSET = (page_number - 1) * page_size
```
⚠️ OFFSET reads and discards skipped rows — slow at large scale.
Production uses cursor-based pagination (WHERE id > last_seen_id).

```sql
-- Cursor-based pagination (production pattern)
SELECT * FROM employees
WHERE emp_id > 1000   -- last seen ID from previous page
ORDER BY emp_id
LIMIT 20;
```

