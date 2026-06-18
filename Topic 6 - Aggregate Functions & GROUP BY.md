# Topic 7: Aggregate Functions & GROUP BY

## What are Aggregate Functions

A function that takes a set of rows as input and returns a single scalar value as output. It collapses multiple rows into one summary value.

**Scalar Value**: A single value - one number, one string, one data. Not a set of rows.

### Execution Order Consequence

Aggreagate functions execuite in the HAVING and SELECT phases — after FROM and WHERE. This means you filter individual rows with WHERE first, then aggregate. You filter aggregated results with HAVING.


## The Five Core Aggregate Functions

## COUNT()

### Definition: 

COUNT() Returns the number of rows or non-NULL values in a set.

```sql
-- COUNT(*): counts ALL rows including NULLs
SELECT COUNT(*) AS total_employees
FROM employees;

-- COUNT(column): counts only NON-NULL values in that column
SELECT COUNT(manager_id) AS employees_with_manager
FROM employees;

-- COUNT(DISTINCT column): counts unique non-NULL values
SELECT COUNT(DISTINCT dept_id) AS departments_with_staff
FROM employees;

-- Difference demonstration
SELECT
    COUNT(*)                    AS total_rows,
    COUNT(manager_id)           AS has_manager,
    COUNT(DISTINCT dept_id)     AS unique_depts,
    COUNT(*) - COUNT(manager_id) AS no_manager_count
FROM employees;
```

## SUM()

### Definition:

SUM() Returns the total of all non-NULL numeric values in a set. Ignores NULLs.

```sql
-- Total payroll
SELECT SUM(salary) AS total_payroll
FROM employees;

-- Total payroll by department
SELECT dept_id, SUM(salary) AS dept_payroll
FROM employees
GROUP BY dept_id;

-- SUM ignores NULLs silently
-- If 3 out of 10 salaries are NULL, SUM adds the other 7
SELECT SUM(salary) FROM employees;   -- NULLs not counted
```

**Nuance**: If ALL values in the column are NULL, SUM() returns NULL (not 0). Use COALESCE(SUM(salary), 0) if you need zero instead of NULL.

## AVG()

### Definition:

AVG() Returns the arithmetic mean of all non-NULL numeric values. Ignores NULLs in both numerator and denominator.

```sql
-- Average salary
SELECT AVG(salary) AS avg_salary
FROM employees;

-- Rounded average
SELECT ROUND(AVG(salary), 2) AS avg_salary
FROM employees;
```

## MIN() & MAX()

### Definition:

MIN(): Returns the smallest non-NULL value in a set. Works on numbers, dates, and strings.

MAX(): Returns the largest non-NULL value in a set. Works on numbers, dates, and strings.

```sql
SELECT
    MIN(salary)     AS lowest_salary,
    MAX(salary)     AS highest_salary,
    MAX(hire_date)  AS most_recent_hire,
    MIN(hire_date)  AS earliest_hire,
    MAX(first_name) AS last_alphabetically,
    MIN(first_name) AS first_alphabetically
FROM employees;
```

## GROUP BY

### Definition:

Clause that divides rows into groups based on one or more columns. Aggregate functions then operate on each group independently, returning one row per group.

```sql
-- One row per department — total employees and payroll
SELECT
    dept_id,
    COUNT(*)        AS employee_count,
    SUM(salary)     AS total_payroll,
    ROUND(AVG(salary), 2) AS avg_salary,
    MIN(salary)     AS min_salary,
    MAX(salary)     AS max_salary
FROM employees
GROUP BY dept_id
ORDER BY total_payroll DESC;
```

### The GROUP BY Rule
Every column in SELECT must either be:
1. In the GROUP BY clause, OR
2. Wrapped in an aggregate function

### GROUP BY Multiple Columns

```sql
-- One row per unique (dept_id, is_active) combination
SELECT
    dept_id,
    is_active,
    COUNT(*)            AS count,
    AVG(salary)         AS avg_salary
FROM employees
GROUP BY dept_id, is_active
ORDER BY dept_id, is_active;
```

### GROUP BY with WHERE

```sql
-- Average salary per department — active employees only
SELECT
    dept_id,
    ROUND(AVG(salary), 2) AS avg_active_salary,
    COUNT(*)              AS active_count
FROM employees
WHERE is_active = TRUE          -- filter ROWS first
GROUP BY dept_id
ORDER BY avg_active_salary DESC;
```

**WHERE vs HAVING - The Fundamental Distinction:**
*   WHERE filters individual rows - before grouping. Cannot use aggregate functions
*   HAVING filters groups - after grouping. Can use aggregate functions.

### GROUP BY with Expression
```sql
-- Group by year of hire
SELECT
    EXTRACT(YEAR FROM hire_date)    AS hire_year,
    COUNT(*)                        AS hires_that_year,
    SUM(salary)                     AS total_salary_committed
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY hire_year;

-- Group by salary band
SELECT
    CASE
        WHEN salary >= 200000 THEN 'Executive'
        WHEN salary >= 100000 THEN 'Senior'
        WHEN salary >= 70000  THEN 'Mid-level'
        ELSE 'Junior'
    END                     AS salary_band,
    COUNT(*)                AS headcount,
    ROUND(AVG(salary), 2)   AS avg_in_band
FROM employees
GROUP BY
    CASE
        WHEN salary >= 200000 THEN 'Executive'
        WHEN salary >= 100000 THEN 'Senior'
        WHEN salary >= 70000  THEN 'Mid-level'
        ELSE 'Junior'
    END
ORDER BY avg_in_band DESC;
```

**Nuance**: PostgreSQL allows GROUP BY alias in some cases but its not standard. Always repeat the expression in GROUP BY for portability across database.


## HAVING - Filtering Groups

### Definition:

HAVING Clause that filters groups produced by GROUP BY. Evaluated after grouping — can reference aggregate functions. Equivalent of WHERE but for groups.

```sql
-- Only show departments with more than 2 employees
SELECT
    dept_id,
    COUNT(*)        AS employee_count,
    SUM(salary)     AS total_payroll
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > 2;

-- Departments where average salary exceeds 100000
SELECT
    dept_id,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > 100000;

-- Departments with total payroll between 200k and 500k
SELECT
    dept_id,
    SUM(salary) AS total_payroll
FROM employees
GROUP BY dept_id
HAVING SUM(salary) BETWEEN 200000 AND 500000;
```

## Aggregate Functions and NULLs

```sql
SELECT
    COUNT(*)                AS counts_all_rows,           -- NULLs counted
    COUNT(salary)           AS counts_non_null_salary,    -- NULLs ignored
    SUM(salary)             AS sum_ignores_nulls,
    AVG(salary)             AS avg_ignores_nulls,         -- careful!
    COALESCE(SUM(salary),0) AS sum_null_safe,
    AVG(COALESCE(salary,0)) AS avg_treating_null_as_zero
FROM employees;
```


## FILTER Clause (Conditional Aggregation)

```sql
-- Conditional aggregation using FILTER — cleaner than CASE
SELECT
    COUNT(*)                                        AS total_employees,
    COUNT(*) FILTER (WHERE is_active = TRUE)        AS active_count,
    COUNT(*) FILTER (WHERE is_active = FALSE)       AS inactive_count,
    COUNT(*) FILTER (WHERE dept_id = 1)             AS engineering_count,
    ROUND(AVG(salary) FILTER (WHERE dept_id = 1),2) AS avg_engg_salary,
    SUM(salary)   FILTER (WHERE is_active = TRUE)   AS active_payroll
FROM employees;
```
Equivalent CASE approach (portable):
```sql

-- CASE approach (portable, works in MySQL/SQL Server too)
SELECT
    COUNT(*) AS total,
    SUM(CASE WHEN is_active = TRUE THEN 1 ELSE 0 END)  AS active_count,
    SUM(CASE WHEN dept_id = 1      THEN 1 ELSE 0 END)  AS engg_count,
    AVG(CASE WHEN dept_id = 1      THEN salary END)     AS avg_engg_salary
FROM employees;
-- Note: AVG ignores NULLs — ELSE clause omitted intentionally
```

## STRING_AGG

### Definition:

STRING_AGG(expression, delimiter): Aggregate function that concatenates string values from multiple rows into a single string, separated by a delimiter.

```sql
-- List all employees in each department as a comma-separated string
SELECT
    dept_id,
    STRING_AGG(first_name, ', ' ORDER BY first_name) AS employee_names,
    COUNT(*) AS headcount
FROM employees
GROUP BY dept_id
ORDER BY dept_id;
```
Concatenates strings across rows with a delimiter.
MySQL equivalent: GROUP_CONCAT

