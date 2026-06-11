## 1.1 What is Data?

Definition: Data is raw, unprocessed facts and figures. On its own, data has no meaning

**Example:** 

42, "Nikhil", 18-04-1995

## 1.2 What is Database?

**Definition:** 

A database is an organized, structured collection of data stored electronically so it can be easily accessed, managed, and updated.

## 1.3 What is DBMS?

**Definition:** 

A Databse Management System (DBMS) is software that acts as an interface between the user and the database. It handles storing, retrieving and managing data.

**Example:** 

MySQL, PostgreSQL, Oracle, Microsoft SQL Server

## 1.4 What is an RDBMS?

**Definition:**

A Relational Database Management System (RDBMS) is a type of DMBS where data is stored in tables (called relations) and tables can be connected to each other through relationships.

The "relational" model was invented by Edgar F.Codd at IBM in 1970.

## 1.5 What is SQL?

**Definition:** 

SQL (Structred Query Language) is the standard language used to communicate with relational database. It lets you create, read, update and delete data - and much more.

SQL is declarative - you tell the database what you want, not how to get it. The Database engine figures out the how.

## 1.6 The Building Blocks - Tables, Rows and Columns

TABLE: employees

| emp_id | name | department | salary |
|--------|------|------------|--------|
| 1      | Alice| Engineering| 95000  |
| 2      | Bob  | Marketing  | 72000  |
| 3      | Carol| Engineering| 105000 |

**Table (Relation):**

A structured grid of data organized into rows and columns. Every table has a unique name within a Database.

**Column (Attrubute/Field):**

A vertical structure that holds one specific type of data. Every column has a name and a data type.

**Example:** salary only holds numbers

**Row (Record/Tuple):**

A horizontal structure representing one complete entry. 

**Example:** Row 1 represents everything about Alice.

**Cell:**

The interection of a row and a column. Holds a single value.

## 1.7 What is a Primary Key?

**Definition:**

A Primary Key is a column that uniquely identifies each row in a table.

**Rules:**

1. Must be unique - no two rows can have the same value
2. Must be NOT NULL - every row must have a vlue
3. A table can have only one primary key

In our example, emp_id is the primary key.

## What is a Foreign Key?

**Definition:**

A foriegn Key is a column in one table that refers to the Primary Key of another table. This is how relatonships between tables are established.

**TABLE:** departments

| dept_id | dept_name |
|---------|-----------|
| 10      | Engg      |
| 20      | Marketing |

**TABLE:** employees

| emp_id | name | dept_id (FK) |
|--------|------|--------------|
| 1      | Alice| 10           |
| 2      | Bob  | 20           |

**employee.dept_id** is a Forign Key to **departments.dept_id**. This enforces that you can't assign employee to a department that doesn't exists.

## 1.9 The SQL Sub-language 

SQL is not just one thing. It's divided into 5 sub-languages

1. DDL (Data Definition Language) It defines structure/schema.
Commands: CREATE, ALTER, DROP, TRUNCATE

2. DML (Data Manipulation Language) Manipulates Data.Commands: INSERT, UPDATE, DELETE, MERGE

3. DQL (Data Query Language) Queries/reads data.           
Commands: SELECT

4. DCL (Data Control Language) Controls access/permission.
Commands: GRANT, REVOKE

5. TCL (Transaction Control Language) Manages transactions.
Commands: COMMIT, ROLLBACK, SAVEPOINT

## 1.10 How SQL Actually Executes 

| Written Order | Execution Order |
|---------------|-----------------|
| 1. SELECT     | 1. FROM         |
| 2. FROM       | 2. WHERE        |
| 3. WHERE      | 3. GROUP BY     |
| 4. GROUP BY   | 4. HAVING       |
| 5. HAVING     | 5. SELECT       |
| 6. ORDER BY   | 6. ORDER BY     |
| 7. LIMIT      | 7. LIMIT        |

