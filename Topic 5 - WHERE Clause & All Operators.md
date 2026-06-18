# Topic 6: WHERE Clause & All Operators

## Definition
WHERE filters rows before grouping/selection.
Only rows evaluating to TRUE pass through.
Rows evaluating to FALSE or NULL are excluded.

### Three-Valued Logic (CRITICAL)
SQL doesn't just have TURE and FALSE. It has TRUE, FALSE, and NULL(UNKNOWN). A WHERE condition that evaluates to NULL (UNKOWN) excludes that row - same as FALSE.

---

## Comparison Operators
```sql
-- Equal
SELECT * FROM employees WHERE dept_id = 1;

-- Not equal (both forms work, prefer <>  — it's ANSI standard)
SELECT * FROM employees WHERE dept_id <> 1;
SELECT * FROM employees WHERE dept_id != 1;

-- Greater than / Less than
SELECT * FROM employees WHERE salary > 100000;
SELECT * FROM employees WHERE salary < 100000;

-- Greater than or equal / Less than or equal
SELECT * FROM employees WHERE salary >= 100000;
SELECT * FROM employees WHERE hire_date <= '2020-12-31';
```

**Nuance** - Companring dates: Dates in SQL are compared chronologically. '2020-01-01' < '2024-01-01' is TRUE. Always use ISO format 'YYYY-MM-DD' for date literals - its unambiguous across all databases.

**Nuance** - String comparison: Strings compare lexicographically (dictionary order). 'B' > 'A' is TRUE. 'b' > 'A' depends on collation.

---

## BETWEEN (Inclusive Range)
```sql
-- Numeric range (inclusive on both ends)
SELECT first_name, salary
FROM employees
WHERE salary BETWEEN 80000 AND 150000;
-- Equivalent to: WHERE salary >= 80000 AND salary <= 150000

-- Date range
SELECT first_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2020-01-01' AND '2022-12-31';

-- NOT BETWEEN
SELECT first_name, salary
FROM employees
WHERE salary NOT BETWEEN 80000 AND 150000;
```
**Nuance** - BETWEEN is always inclusive. BETWEEN 1 AND 10 includes both 1 and 10. BETWEEN '2023-01-01' AND '2023-12-31' includes all of Dec 31 but only at midnight (00:00:00). If your column is TIMESTAMP, use >= '2023-01-01' AND < '2024-01-01' instead for full-day precision.

```sql
-- Safer date range with timestamps
SELECT * FROM orders
WHERE created_at >= '2023-01-01'
  AND created_at <  '2024-01-01';   -- excludes 2024-01-01 00:00:00
```

---

## IN Operator

### Definition:

IN Tests whether a value matches any value in a specific list. Cleaner and more readable than multiple OR conditions.


```sql
-- Match any value in a list
SELECT first_name, dept_id
FROM employees
WHERE dept_id IN (1, 3, 7);
-- Equivalent to: WHERE dept_id = 1 OR dept_id = 3 OR dept_id = 7

-- String list
SELECT * FROM employees
WHERE job_title IN ('Engineer', 'Senior Engineer', 'VP Engineering');

-- NOT IN
SELECT * FROM employees
WHERE dept_id NOT IN (1, 2);
```

**Critical NULL Trap with NOT IN**: If the list contains a NULL value, NOT IN returns NULL for every row - meaning it returns zero rows.

```sql
-- Suppose dept_id list contains NULL:
SELECT * FROM employees
WHERE dept_id NOT IN (1, 2, NULL);
-- Returns ZERO rows — because NOT IN (NULL) = UNKNOWN for all rows

-- Safe alternative: use NOT EXISTS or IS NULL check explicitly
SELECT * FROM employees
WHERE dept_id NOT IN (1, 2)
   OR dept_id IS NULL;
```

---

## LIKE (Pattern Matching — Case Sensitive)

### Definition:

LIKE tests whether a string matches a specified pattern using wildcard characters.

**LIKE Wildcard Characters:**

% - Zero or more of any character

_ - Exactly one of any character


```sql
-- Starts with 'A'
SELECT * FROM employees WHERE first_name LIKE 'A%';

-- Ends with 'a'
SELECT * FROM employees WHERE first_name LIKE '%a';

-- Contains 'neer' anywhere
SELECT * FROM employees WHERE job_title LIKE '%neer%';

-- Exactly 5 characters
SELECT * FROM employees WHERE first_name LIKE '_____';

-- Second character is 'n'
SELECT * FROM employees WHERE first_name LIKE '_n%';

-- NOT LIKE
SELECT * FROM employees WHERE email NOT LIKE '%@gmail.com';
```

**Nuance** - LIKE is case-sensitive in PostgreSQL. LIKE 'alice%' will NOT match 'Alice'.

## ILIKE (Case-Insensitive Pattern Matching)

### Definition:

ILIKE - PostgreSQL specific variant of LIKE that performs case-insensitive pattern matching.

```sql
-- Matches 'Alice', 'alice', 'ALICE', 'aLiCe'
SELECT * FROM employees WHERE first_name ILIKE 'alice%';

-- Search regardless of case
SELECT * FROM employees WHERE job_title ILIKE '%engineer%';

-- NOT ILIKE
SELECT * FROM employees WHERE email NOT ILIKE '%@company.com';
```

```sql
-- Portable case-insensitive pattern matching (works everywhere)
SELECT * FROM employees 
WHERE LOWER(first_name) LIKE LOWER('alice%');
```

## Escaping Special Characters in LIKE

### Definition:

ESCAPE defines a character that, when placed before % or _ in a LIKE pattern, treats them as literal characters rather than wildcards.

```sql
-- What if you need to search for a literal % or _ ?
-- Use ESCAPE to define an escape character

-- Find job titles containing '100%'
SELECT * FROM job_targets
WHERE target_description LIKE '%100\%%' ESCAPE '\';

-- Find column names containing '_id'
SELECT * FROM metadata
WHERE column_name LIKE '%\_id%' ESCAPE '\';
```


## IS NULL / IS NOT NULL

**Definition**: IS NULL/IS NOT NULL tests whether a value is NULL or NOT. The only correct way to check for NULL - never use = NULL


```sql
-- Find employees with no manager (top-level)
SELECT first_name, manager_id
FROM employees
WHERE manager_id IS NULL;

-- Find employees who have a manager
SELECT first_name, manager_id
FROM employees
WHERE manager_id IS NOT NULL;

-- Find employees with no department assigned
SELECT * FROM employees WHERE dept_id IS NULL;
```


## Logical Operators

**AND**: Returns TRUE only when both conditions are TRUE

**OR**: Returns TRUE when at least one condition is TRUE

**NOT**: Reverses/negates a condition


```sql
-- AND: both must be true
SELECT * FROM employees
WHERE dept_id = 1
  AND salary > 100000;

-- OR: at least one must be true
SELECT * FROM employees
WHERE dept_id = 1
   OR dept_id = 2;

-- NOT: negates the condition
SELECT * FROM employees
WHERE NOT is_active;
-- Equivalent to: WHERE is_active = FALSE

-- Combining all three
SELECT * FROM employees
WHERE (dept_id = 1 OR dept_id = 2)
  AND salary > 80000
  AND NOT is_active = FALSE;
```

## Operator Precedence

Parentheses () has the highest precedence thats why its always evaluated first.

AND has higher precedence than OR. Always use () when combining both in WHERE clause

```sql
-- INTENT: Get Engineering OR Marketing employees with salary > 100000
-- BUG: AND evaluates before OR
SELECT * FROM employees
WHERE dept_id = 1
   OR dept_id = 2
  AND salary > 100000;

-- What actually executes:
-- WHERE dept_id = 1 OR (dept_id = 2 AND salary > 100000)
-- Returns ALL Engineering employees (any salary) + 
--         Marketing employees with salary > 100000 only
-- This is WRONG if your intent was both departments filtered by salary

-- CORRECT: Use parentheses to enforce your intent
SELECT * FROM employees
WHERE (dept_id = 1 OR dept_id = 2)
  AND salary > 100000;
```


