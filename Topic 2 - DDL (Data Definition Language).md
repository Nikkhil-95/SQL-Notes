# Topic 2: DDL — Data Definition Language

## Definition
DDL (Data Definition Language) is the subset of SQL used to define, 
modify, and delete database structures. DDL is auto-committed in 
PostgreSQL — changes are immediate and mostly irreversible.

## DDL Commands
| Command  | Purpose                              |
|----------|--------------------------------------|
| CREATE   | Build new structures                 |
| ALTER    | Modify existing structures           |
| DROP     | Permanently delete structures        |
| TRUNCATE | Remove all data, keep structure      |
| RENAME   | Rename a structure                   |

---

## Data Types

### Numeric
| Type           | Notes                                      |
|----------------|--------------------------------------------|
| SMALLINT       | 2 bytes, small numbers                     |
| INTEGER / INT  | 4 bytes, standard IDs and counts           |
| BIGINT         | 8 bytes, very large numbers                |
| DECIMAL(p,s)   | Exact decimal — use for MONEY              |
| SERIAL         | Auto-incrementing INT (great for IDs)      |
| BIGSERIAL      | Auto-incrementing BIGINT                   |

⚠️ DECIMAL vs FLOAT: Never use FLOAT for money. FLoating point types have rounding errors (0.1 + 0.2 = 0.30000000000000004). Always use DECIMAL or NUMERIC for financial data.

**Definition - DECIMAL (p,s):**

*   p = precision - total number of digit
*   s = scale - digit after the decimal point
*   Example: DECIMAL(10,2) stores upto 99999999.99

### Text
| Type        | Notes                                         |
|-------------|-----------------------------------------------|
| CHAR(n)     | Fixed length, pads with spaces                |
| VARCHAR(n)  | Variable length, max n chars                  |
| TEXT        | Unlimited length                              |

### Date & Time
| Type        | Notes                                         |
|-------------|-----------------------------------------------|
| DATE        | YYYY-MM-DD                                    |
| TIME        | HH:MM:SS                                      |
| TIMESTAMP   | Date + time, no timezone                      |
| TIMESTAMPTZ | Date + time + timezone ← use in production    |

**Pro Tip** - Always use TIMESTAMPTZ in production. Plain TIMESTAMP stores no timezone info - if your server timezone changes or you have global users, your data becomes meaningless.

### Other
| Type    | Notes                                           |
|---------|-------------------------------------------------|
| BOOLEAN | TRUE / FALSE / NULL                             |
| UUID    | Universally unique ID                           |
| JSONB   | Indexed JSON — preferred over JSON              |

---

## Constraints

**Definition:**

A rule applied to a column or table that restricts what data can be stored, ensuring accuracy and consistency.  Constraints are enforced by the database engine automatically.

| Constraint  | Purpose                                        |
|-------------|------------------------------------------------|
| PRIMARY KEY | Unique + NOT NULL. A Table can have only one.  |
| NOT NULL    | Column must always have a value                |
| UNIQUE      | All values must be distinct (allows NULL)      |
| CHECK       | Value must satisfy a condition                 |
| DEFAULT     | Value used when none is provided on INSERT     |
| FOREIGN KEY | Value must exist in referenced table           |

⚠️ NULL means unknown/absent — NOT zero, NOT empty string.
   Always use IS NULL / IS NOT NULL (never = NULL)

---

## CREATE TABLE

**Syntax:**

```sql
CREATE TABLE table_name (
    column1 datatype [constraints],
    column2 datatype [constraints],
    ...
    [table_level_constraints]
);
```

**Example schema - a company database:**

```sql
CREATE TABLE departments (
    dept_id    SERIAL        PRIMARY KEY,
    dept_name  VARCHAR(100)  NOT NULL UNIQUE,
    location   VARCHAR(100),
    created_at TIMESTAMPTZ   DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    emp_id     SERIAL          PRIMARY KEY,
    first_name VARCHAR(50)     NOT NULL,
    last_name  VARCHAR(50)     NOT NULL,
    email      VARCHAR(100)    NOT NULL UNIQUE,
    hire_date  DATE            NOT NULL DEFAULT CURRENT_DATE,
    salary     DECIMAL(12,2)   CHECK (salary > 0),
    is_active  BOOLEAN         DEFAULT TRUE,
    dept_id    INT             REFERENCES departments(dept_id),
    manager_id INT             REFERENCES employees(emp_id)
);
```
**Important: Self-referencing Forieng Key** 

**manager_id** references **employee(emp_id)** in same table. This is called self-join or recursive relationship. It's how organisations charts and hierarchies are stored in SQL.

```sql
CREATE TABLE projects (
    project_id      SERIAL          PRIMARY KEY,
    project_name    VARCHAR(150)    NOT NULL,
    start_date      DATE,
    end_date        DATE,
    budget          DECIMAL (15,2)  CHECK (budget>=0),
    dept_id         INT             REFERENCES departments(dept_id),

    --Table level constraint: end date must be after start date
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
) 
```
```sql
-- Create employee_projects (junction/bridge table for many to many relationship)
CREATE TABLE employee_projects (
    emp_id          INT     REFERENCES employee(emp_id),
    project_id      INT     REFERENCES projects(project_id),
    assigned_date   DATE    DEFAULT CURRENT_DATE,
    role    VARCHAR(100),

    --Composite Primary Key (both columns together = unique identifier)
    PRIMARY KEY (emp_id, project_id)
);
```
**Definition - Junction Table (Bridge Table):** A table that resolves a many to many relationship between two tables by holding foreign keys from both. Example: one employee can work on many projects; one project can have many employees.

**Definition - Composite Primary Key:** A Primary Key made up of two or more columns. The combination of values must be unique, even if indiviual values repeats.

## IF NOT EXISTS - Safe Table Creation

```sql
-- Without this, running CREATE TABLE twice throws an error
-- WIth this, it silently skips if table already exists

CREATE TABLE IF NOT EXISTS departments (
    dept_id     SERIAL          PRIMARY KEY,
    dept_name   VARCHAR(100)    NOT NULL
);
```

## ALTER TABLE
```sql
--ADD a new column
ALTER TABLE employees 
ADD COLUMN middle_name VARCHAR(50);

--ADD a column with a default value
ALTER TABLE employees 
ADD COLUMN updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;

--DROP a column (permanent - data is lost)
ALTER TABLE employees
DROP COLUMN middle_name;

--RENAME a column
ALTER TABLE employees 
RENAME COLUMN phone TO phone_number;

--CHANGE data type of a column
ALTER TABLE employees 
ALTER COLUMN phone_number TYPE VARCHAR(25);

--ADD a constraint
ALTER TABLE employees 
ADD CONSTRAINT chk_salary CHECK (salary > 0);

--DROP a constraint (you need the constraint name)
ALTER TABLE employees 
DROP CONSTRAINT chk_salary;

--RENAME the table itself
ALTER TABLE employees
RENAME TO staff;
```

## DROP vs TRUNCATE vs DELETE
| Command  | Removes Structure | Removes Data  | Rollback | Speed     |
|----------|-------------------|---------------|----------|-----------|
| DROP     | YES               | YES           | NO       | Fast      |
| TRUNCATE | NO                | ALL rows      | Limited  | Very Fast |
| DELETE   | NO                | Selective     | YES      | Slow      |

## TRUNCATE
```sql
TRUNCATE TABLE employees;
TRUNCATE TABLE employees RESTART IDENTITY;  -- resets SERIAL counter
TRUNCATE TABLE departments CASCADE;          -- truncates dependents too
```

## Key Definitions
- **Schema:** Logical namespace grouping tables inside a database
- **Junction Table:** Resolves many-to-many relationships
- **Composite PK:** Primary key made of 2+ columns
- **information_schema:** Built-in metadata schema


