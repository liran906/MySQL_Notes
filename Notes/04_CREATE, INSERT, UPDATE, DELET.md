# CREATE, INSERT, UPDATE, DELET

## 🚀 **Summary of Key Concepts**

| **Concept** | **Description** | 📝 **Syntax** | ⚠️ **Remarks** |
| --- | --- | --- | --- |
| **Column Attributes** | Defining column properties (e.g., VARCHAR, NN, PK, AI) | `VARCHAR`, `NOT NULL`, `PRIMARY KEY`, `AUTO_INCREMENT` | **AI** retains sequence even if records are deleted; constraints ensure data integrity |
| **INSERT Statements** | Adding new records to a table | `INSERT INTO table (columns) VALUES (...);` | Use **DEFAULT** for auto-generated columns; specify column list to prevent schema-related errors |
| **Multiple Row Inserts** | Inserting several rows in one statement | `INSERT INTO table VALUES (...), (...), (...);` | Ensure data consistency; maintain proper column order if not specified |
| **LAST_INSERT_ID()** | Retrieves the last auto-increment value from the previous INSERT | `SELECT LAST_INSERT_ID();` | May return unexpected values if multiple inserts occur simultaneously |
| **CREATE TABLE AS SELECT** | Creates a new table based on a query’s result | `CREATE TABLE new_table AS SELECT * FROM old_table;` | Data copied without constraints; redefine PK or AI if necessary |
| **INSERT … SELECT** | Inserts records into a table from a SELECT query | `INSERT INTO table SELECT ... FROM ...;` | Check for data type compatibility between source and target columns |
| **UPDATE Statements** | Modifies existing records | `UPDATE table SET column = value WHERE condition;` | Use **WHERE** clause to avoid unintended updates; verify expressions |
| **Subqueries in UPDATE/DELETE** | Use nested queries to set dynamic criteria in UPDATE/DELETE | `UPDATE table SET col = (SELECT ...) WHERE ...;` | Ensure subqueries return expected results; optimize performance |
| **DELETE Statements** | Removes records from a table | `DELETE FROM table WHERE condition;` | Precise conditions prevent accidental mass deletions; backup data when necessary |

---

## 📂 **1. Column Attributes**

**🔑 Knowledge Point:**

- Define properties such as data type (e.g., **VARCHAR**), constraints like **NN** (NOT NULL), **PK** (Primary Key), and **AI** (Auto Increment).

- ⚡ **Note:** In MySQL, **AI** values continue to increment even if records are deleted.

**✅ Key Points:**

- Understand each attribute to ensure data integrity.

**⚠️ Common Pitfalls:**

- Assuming auto-increment resets on deletion or misconfiguring constraints.

---

## 📝 **2. INSERT Statements**

**🔑 Knowledge Point:**

- **INSERT INTO:** Adds new records to a table.

- **Approaches:**

1. **Without a column list:** Relies on default order and uses **DEFAULT** for auto-generated values.

2. **With a column list:** Provides clarity and flexibility (e.g., swapping column order).

📌 Examples:

*Without Column List:*

```sql
INSERT INTO customers
VALUES (
    DEFAULT,
    'John',
    'Smith',
    '1990-01-01',
    NULL, -- or DEFAULT    'address',
    'city',
    'CA',
    DEFAULT);
```

*With Column List:*

```sql
INSERT INTO customers (
    last_name,
    first_name,
    birth_date,
    address,
    city,
    state
)
VALUES (
    'Smith',
    'John',
    '1990-01-01',
    'address',
    'city',
    'CA');
```

**✅ Key Points:**

- Use **DEFAULT** for auto-generated values.

- Specifying columns increases clarity and prevents errors when the schema changes.
**⚠️ Common Pitfalls:**
- Relying solely on column order may cause issues if the schema is modified.

---

## 📥 **3. Multiple Row Inserts** **🔑 Knowledge Point:**

- Insert multiple records in a single statement for efficiency.

📌 Example:

```sql
INSERT INTO shippers (name)
VALUES ('shipper1'),
       ('shipper2'),
       ('shipper3');
```

**✅ Key Points:**
- Improves performance.

- Maintain consistent data types.
**⚠️ Common Pitfalls:**
- Mismatched data types can cause errors.

---

## 🔑 **4. Using LAST_INSERT_ID()** **🔑 Knowledge Point:**

- Retrieves the last auto-increment value after an insert.

📌 Example:

```sql
INSERT INTO order_items
VALUES
    (LAST_INSERT_ID(), 1, 1, 3.99),
    (LAST_INSERT_ID(), 3, 1, 1.69);
```

**✅ Key Points:**
- Useful for maintaining relationships between tables.
**⚠️ Common Pitfalls:**
- Unexpected results if multiple inserts occur simultaneously.

---

## 🗃️ **5. CREATE TABLE AS SELECT** **🔑 Knowledge Point:**

- Creates a new table from the result of a query.

📌 Example:

```sql
CREATE TABLE order_archived ASSELECT * FROM orders;
```

**✅ Key Points:**

- Data is copied, but constraints like **PK** and **AI** are not.
**⚠️ Common Pitfalls:**
- Expecting constraints to be copied automatically.

---

## 🔄 **6. INSERT … SELECT** **🔑 Knowledge Point:**

- Inserts data into a table from another table.

📌 Example:

```sql
INSERT INTO order_archived
SELECT *FROM orders
WHERE order_date < '2019-12-31';
```

**✅ Key Points:**
- Useful for data archiving or migration.
**⚠️ Common Pitfalls:**
- Data type mismatches between source and destination.

---

## ✏️ **7. UPDATE Statements** **🔑 Knowledge Point:**

- Modifies existing data using various techniques.

📌 Examples:

```sql
UPDATE invoices
SET payment_total = 100, payment_date = '2019-03-01'WHERE invoice_id = 1;
```

```sql
UPDATE invoices
SET payment_total = DEFAULT, payment_date = NULLWHERE invoice_id = 1;
```

**✅ Key Points:**

- Always include a **WHERE** clause to avoid unintended changes.
**⚠️ Common Pitfalls:**

- Omitting the **WHERE** clause can update all records unintentionally.

---

## 🔍 **8. Subqueries in UPDATE/DELETE** **🔑 Knowledge Point:**

- Use subqueries to define conditions dynamically.

📌 Example (UPDATE with Subquery):

```sql
UPDATE invoices
SET payment_total = invoice_total * 0.5
WHERE client_id = (
    SELECT client_id
    FROM clients
    WHERE name = 'Myworks');
```

**✅ Key Points:**
- Verify subqueries independently for accuracy.
**⚠️ Common Pitfalls:**
- Returning multiple rows when a single value is expected.

---

## ❌ **9. DELETE Statements** **🔑 Knowledge Point:**

- Deletes records from a table based on conditions.

📌 Example:

```sql
DELETE FROM invoices
WHERE client_id = (
    SELECT client_id
    FROM clients
    WHERE name = 'Myworks');
```

**✅ Key Points:**
- Double-check deletion conditions to prevent data loss.
**⚠️ Common Pitfalls:**
- Missing conditions can result in accidental mass deletions.

---

## 📋 **Overall Summary**

- **Column Attributes:** Define data types and constraints like **VARCHAR** , **NN** , **PK** , **AI** .
- **INSERT Statements:** Add records with flexibility using column lists and **DEFAULT** values.
- **LAST_INSERT_ID():** Manage auto-increment relationships effectively.
- **CREATE TABLE AS SELECT:** Create tables from queries (constraints not copied).
- **INSERT … SELECT:** Useful for data migration.
- **UPDATE Statements:** Modify data securely with conditions.
- **Subqueries:** Enhance UPDATE/DELETE with dynamic queries.
- **DELETE Statements:** Remove data carefully with precise conditions.