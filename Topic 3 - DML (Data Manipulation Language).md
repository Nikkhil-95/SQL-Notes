# Topic 3: DML — Data Manipulation Language

## Definition
DML (Data Manipulation Language) operates on rows inside tables.
Unlike DDL, DML is transactional and can be rolled back.

## DML Commands
| Command | Purpose                        |
|---------|--------------------------------|
| INSERT  | Add new rows                   |
| UPDATE  | Modify existing rows           |
| DELETE  | Remove specific rows           |
| MERGE   | Insert or Update (Upsert)      |

---

## INSERT

**Syntax:**

```sql
INSERT INTO table_name (column1, column2,....)
VALUES (value1, value2,....);
```

### Single Row
```sql
INSERT INTO departments (dept_name, location)
VALUES ('Engineering', 'Bangalore');
```
**Important:** Column list is optional but always specify it. You can write **INSERT INTO departments VALUES(....)** without listing columns, but then you must provide values in the exact order columns were created. If someone later adds/reorder columns, query silently breaks.

### Multiple Rows
```sql
INSERT INTO departments (dept_name, location)
VALUES ('Marketing', 'Mumbai'),
       ('Finance',   'Delhi');
```

### With RETURNING

**Definition — RETURNING clause:** 

A PostgreSQL extension to INSERT (also works with UPDATE/DELETE) that returns the values of specified columns from the rows that were just affected. Eliminates the need for a follow-up SELECT.

```sql
-- Get the auto-generated ID immediately after insert
INSERT INTO departments (dept_name, location)
VALUES ('Legal', 'Delhi')
RETURNING dept_id, dept_name;

-- Return everything
INSERT INTO departments (dept_name, location)
VALUES ('Product', 'Pune')
RETURNING *;
```

### INSERT from SELECT

**Definition — INSERT INTO ... SELECT:** Inserts rows into a table using the result of a SELECT query instead of hardcoded values. Powerful for copying, transforming, or migrating data.

```sql
-- Copy all Engeering employees into an archive table
-- assume emp_archive has same structure as employees

INSERT INTO emp_archive (emp_id, first_name, email)
SELECT emp_id, first_name, email
FROM employees
WHERE dept_id = 1;
```

### UPSERT (ON CONFLICT)
```sql
INSERT INTO employees (email, salary)
VALUES ('arjun@company.com', 270000)
ON CONFLICT (email)
DO UPDATE SET salary = EXCLUDED.salary;

-- Silently ignore duplicates
ON CONFLICT (dept_name) DO NOTHING;
```
**EXCLUDED** = A special table reference in ON CONFLICT DO UPDATE that refers to the rows that was proposed for insertion (the one that caused that conflict). You use it to access the new values you tried to insert.

---

## UPDATE

**Syntax:**

```sql
UPDATE table_name
SET column1 = value1,
    column2 = value2
WHERE condition;
```
**Important Rule:** Always write WHERE caluse before running an UPDATE or DELETE. An UPDATE without WHERE updates every single row in the table.

### Basic
```sql
-- Give Sneha a raise
UPDATE employees
SET salary = 135000
WHERE emp_id = 4;
```

### Multiple Columns
```sql
-- Promote Vikram - new title and salary
UPDATE employees
SET job_title = 'Senior Engineer',
    salary    = 115000
WHERE emp_id = 5;
```

### With Expression
```sql
-- Give everyone in Engneering a 10% raise
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 1;
```

### With CASE
```sql
-- Update using CASE (conditional update - extremely useful)
UPDATE employees
SET salary = CASE
    WHEN job_title = 'Junior Engineer' THEN salary * 1.15
    WHEN job_title = 'Engineer'        THEN salary * 1.10
    ELSE salary
END
WHERE dept_id = 1;
```

### With RETURNING
```sql
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 1
RETURNING emp_id, first_name, salary;
```

### Safe UPDATE Workflow
1. SELECT first to verify affected rows
2. Run UPDATE
3. SELECT again to verify result
4. Wrap in BEGIN/COMMIT for safety

---

## DELETE

**Syntax:**
```sql
DELETE FROM table_name
WHERE condition;
```

### Basic
```sql
DELETE FROM employees WHERE emp_id = 10;
```

### With RETURNING (Audit Pattern)
```sql
DELETE FROM employees
WHERE emp_id = 9
RETURNING *;
```

### Archive Before Delete (Best Practice)
```sql
INSERT INTO emp_archive SELECT * FROM employees WHERE emp_id = 9;
DELETE FROM employees WHERE emp_id = 9;
```
**Important:** Before deleting, insert the rows into an archive table using INSERT INTO archieve SELECT .... FROM table WHERE condition, then delete. This gives recoverable audit trail.

---

## DELETE vs TRUNCATE
| Feature         | DELETE       | TRUNCATE            |
|-----------------|--------------|---------------------|
| WHERE clause    | YES          | NO                  |
| Rollback        | YES          | YES (PostgreSQL)    |
| Fires triggers  | YES          | NO                  |
| Resets SERIAL   | NO           | YES (RESTART IDENT) |
| Speed           | Slow         | Very Fast           |

---

## NULL Rules in DML
```sql
-- Insert NULL explicitly
INSERT INTO employees (first_name, last_name, email, salary, dept_id, manager_id)
VALUES ('Test', 'User', 'test@company.com', '80000', 1, NULL);

-- Setting a value to NULL via UPDATE
UPDATE employees 
SET manager_id = NULL 
WHERE emp_id = 4;

-- Check for NULL (= NULL never works)
WHERE manager_id IS NULL
WHERE manager_id IS NOT NULL
```

---

## Key Definitions
- **UPSERT:** Insert if not exists, Update if it does
- **EXCLUDED:** Special table in ON CONFLICT referring to 
  the proposed (conflicting) row's values
- **RETURNING:** Clause that returns affected row values 
  immediately after INSERT/UPDATE/DELETE
- **CASE:** SQL conditional expression (like if-else)

---

## ⚠️ Golden Rules
1. NEVER run UPDATE or DELETE without a WHERE clause
2. Always SELECT first to verify rows that will be affected
3. Wrap destructive operations in BEGIN/COMMIT transactions
4. Always specify column names in INSERT (never rely on order)
5. Use RETURNING to avoid unnecessary follow-up SELECT queries


