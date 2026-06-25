# Topic 8: JOINs — Combining Tables

## Definition
JOIN combines rows from two or more tables based on a related
column. 

**Join Condition**: The Logical expression (usually an equality between a foerign key and primary key) that determines which rows from each table are paired.

---

## JOIN Types Summary

| JOIN Type       | Returns                                        |
|-----------------|------------------------------------------------|
| INNER JOIN      | Only matching rows from both tables            |
| LEFT JOIN       | All left rows + matching right (NULL if none)  |
| RIGHT JOIN      | All right rows + matching left (NULL if none)  |
| FULL OUTER JOIN | All rows from both (NULLs where no match)      |
| CROSS JOIN      | Every combination (m × n rows)                 |
| SELF JOIN       | Table joined to itself (needs two aliases)     |

---

## INNER JOIN

Returns only the rows where the join condition is satisfied in both tables. Non-matching rows from either table are excluded.

```sql
-- Basic Syntax
SELECT e.emp_id, e.first_name, e.last_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

-- INNER is optional — JOIN alone means INNER JOIN
SELECT e.emp_id, e.first_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
```
**Table Alias**: A short name given to a table within query using the AS keyword (or just a space). employee e means "refer to employees as e". Makes queries shorter and required when joining a table to itself.

---

## LEFT JOIN

**LEFT JOIN (LEFT OUTER JOIN)**: Returns all rows from the left table and matching rows from the right table. Where no match exists in the right table, NULLs are returned for all right table columns.

```sql
-- All employees, with their department (NULL if no dept assigned)
SELECT
    e.emp_id,
    e.first_name,
    e.last_name,
    e.dept_id,
    d.dept_name         -- NULL if no department match
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
ORDER BY e.emp_id;
```
All employees returned. NULL dept_name where no dept match.

### Anti-Join Pattern (Find unmatched rows)

**Anti-Join**: A pattern using LEFT JOIN + WHERE to find rows in the left table that have no match in the right table.

```sql
-- Employees with NO department assigned
-- Classic "find what's missing" pattern
SELECT e.emp_id, e.first_name, e.dept_id
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;    -- right side is NULL = no match found
```

```sql
-- Departments with NO employees
SELECT d.dept_id, d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;
```
Find all customers who have never placed an order - this is always a LEFT JOIN anti-join. Recognise this pattern instantly.

---

## RIGHT JOIN

**RIGHT JOIN (RIGHT OUTER JOIN)**: Returns all rows from the right table and matching rows from the left table. Where no match exists in the left table, NULLs fill the table columns.

```sql
-- All departments, with their employees (NULL if no employees)
SELECT
    e.first_name,
    e.salary,
    d.dept_id,
    d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_id;
```
**Practical Note**: RIGHT JOIN is rarely used in practice. Every RIGHT JOIN can be rewritten as a LEFT JOIN by swapping the table order. Most teams standardise on LEFT JOIN for readability — you always know which table is being preserved.

```sql
-- These two are identical in result:
FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id
FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id
```

---

## FULL OUTER JOIN

**FULL OUTER JOIN**: Returns all rows from both tables. Where a match exists, columns from both sides are populated. Where no match exists on either side, NULLs fill the non-matching side's columns.

```sql
-- All employees AND all departments — matched where possible
SELECT
    e.emp_id,
    e.first_name,
    d.dept_id,
    d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_id NULLS LAST;
```
```sql
-- Find ALL unmatched rows from BOTH tables
SELECT
    e.emp_id,
    e.first_name,
    d.dept_id,
    d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id
WHERE e.dept_id IS NULL         -- employees with no dept
   OR d.dept_id IS NULL;        -- departments with no employees
```

---

## CROSS JOIN

**CROSS JOIN**: Returns every possible combination of rows from the two tables. If table A has m rows and table B has n rows, CROSS JOIN returns m × n rows. No join condition is specified.

```sql
-- Every employee paired with every department
SELECT
    e.first_name,
    d.dept_name
FROM employees e
CROSS JOIN departments d;
-- 10 employees × 7 departments = 70 rows
```
When CROSS JOIN is useful?
*   Generating test data (every product * every region)
*   Calendar tables (every date * every store)

Warning: CROSS JOIN on large tables is explosive. 1M rows * 1M rows = 1 trillion rows. Always be intentional. 


## SELF JOIN

**SELF JOIN**: A join where a table is joined to itself. Requires two separate aliases for the same table. Used for hierarchical/recursive data — org charts, category trees, bill of materials.

```sql
-- Employee + their manager's name
-- manager_id in employees references emp_id in the same table
SELECT
    e.emp_id,
    e.first_name                        AS employee,
    e.job_title                         AS emp_title,
    m.first_name                        AS manager,
    m.job_title                         AS mgr_title
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;
-- LEFT JOIN (not INNER) to include top-level employees
```
**Why LEFT JOIN for SELF JOIN?**

Top-Level employees (CEO, VPs) have manager_id = NULL. If INNER JOIN is used, they get excluded. Almost always use LEFT JOIN for self-joins on hierarchical data.

```sql
-- Find all employees and their "skip-level" manager
-- (manager's manager)
SELECT
    e.first_name            AS employee,
    m.first_name            AS manager,
    gm.first_name           AS grand_manager
FROM employees e
LEFT JOIN employees m   ON e.manager_id  = m.emp_id
LEFT JOIN employees gm  ON m.manager_id  = gm.emp_id;
```

---

## Non-Equi Join

```sql
-- Non-equi join: match employees to salary bands table
SELECT
    e.first_name,
    e.salary,
    sb.band_name
FROM employees e
JOIN salary_bands sb
    ON e.salary BETWEEN sb.min_salary AND sb.max_salary;

-- Multiple conditions in ON clause
SELECT e.first_name, p.project_name
FROM employees e
JOIN projects p
    ON e.dept_id = p.dept_id
    AND e.hire_date <= p.start_date;
```

**Non-Equi Join**: A join whose condition uses an operator other than = (such as BETWEEN, <, >, <=, =>). Used to match rows based on ranges rather than exact values.


## NULL Behaviour in JOINs

```sql
-- NULL never matches NULL in a join condition
-- emp.dept_id = NULL will NEVER match dept.dept_id = NULL

-- Demonstration:
INSERT INTO employees (first_name, last_name, email, salary, dept_id)
VALUES ('Test', 'User', 'test@co.com', 50000, NULL);

-- INNER JOIN excludes this row (NULL dept_id)
SELECT e.first_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
-- 'Test User' does NOT appear

-- LEFT JOIN includes it with NULL dept_name
SELECT e.first_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
-- 'Test User' appears with dept_name = NULL
```
## JOIN vs WHERE for Filtering 

```sql
-- Filtering in ON clause vs WHERE clause behaves differently
-- for OUTER JOINs — this is a very common interview trap

-- OPTION A: Filter in WHERE (applied AFTER join)
-- Turns LEFT JOIN into INNER JOIN effectively
SELECT e.first_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Engineering';
-- Only Engineering employees — employees with no dept are EXCLUDED
-- because WHERE filters out NULLs

-- OPTION B: Filter in ON clause (applied DURING join)
-- Preserves all left table rows
SELECT e.first_name, d.dept_name
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id
    AND d.dept_name = 'Engineering';
-- Returns ALL employees — non-Engineering get NULL dept_name
-- Engineering employees get their dept_name populated
```

**The Rule**:
*   Condition in ON - applied during the join - left rows preserved
*   Condition in WHERE - applied after the join - NULL rows from the outer join get filtered out

