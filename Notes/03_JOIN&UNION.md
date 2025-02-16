# JOIN&UNION

# 📊 **SQL Joins and UNION - Course Notes**

## 🚀 **Summary of Key Concepts**

| **Concept** | **Description** | ⚡ **Key Points** | ⚠️ **Common Pitfalls** |
| --- | --- | --- | --- |
| **Using Multiple Databases** | Switch active database using the **`USE`** statement | Always verify the current database context before running queries | Forgetting to switch databases leads to querying incorrect data |
| **Table Aliasing** | Assign short names to tables/columns to simplify queries | Use clear, consistent aliases; the **`AS`** keyword is optional | Ambiguous or inconsistent alias naming |
| **INNER JOIN** | Returns only matching rows from joined tables | Always include accurate join conditions with the **`ON`** clause | Omitting join conditions causes a **Cartesian product** (笛卡尔积) |
| **Implicit Join Syntax** | Use comma-separated tables with a **`WHERE`** clause for joins | Less readable and error-prone than explicit **`JOIN`** syntax | Missing join conditions results in unexpected outputs |
| **OUTER JOINS (LEFT/RIGHT)** | Returns unmatched rows along with matched rows | Understand which table is **primary (LEFT)** and which is **secondary (RIGHT)** | Misinterpreting join direction may yield missing or extra rows |
| **Composite Key Joins** | Join tables on multiple columns (composite keys) | Include **all parts** of the composite key in the join condition | Joining on only part of the composite key results in incorrect data |
| **JOIN Using the USING Clause** | Simplifies joins when joined columns share the same name | Column names **must be identical** across tables | Using **`USING`** with mismatched column names causes errors |
| **NATURAL JOIN** | Automatically joins tables on all columns with matching names | Reduces explicit conditions by matching all common columns | Unintentional joins on unwanted columns; **use cautiously** |
| **CROSS JOIN** | Produces the **Cartesian product** of two tables | Use only when a full Cartesian product is intended | Unfiltered **`CROSS JOIN`** can generate huge, unmanageable datasets |
| **UNION Operator** | Combines results from multiple **`SELECT`** queries | Each **`SELECT`** must have the same number and type of columns | Mismatched columns or data types; unintended duplicate removal |

---

## 🗂️ **1. Using Multiple Databases**

**Key Concept:**

- **`USE` Statement:** Switches the active database/schema for subsequent queries.

**Example:**

```sql
USE sql_store;
SELECT *
FROM order_items;
```

**⚡ Key Points:**

- Always verify the current database with `SELECT DATABASE();` before executing queries.
*Always verify the current database with `SELECT DATABASE();` before executing queries.
（使用 `SELECT DATABASE()` 检查当前数据库）***⚠️ Common Pitfalls:**

- Forgetting to switch databases may result in querying the **wrong dataset** .

---

## 🗃️ **2. Table Aliasing** **Key Concept:**

- **Alias:** Assign short, meaningful names to tables or columns to improve query readability.
*（Alias：别名，用于简化查询语句）***Example:**

```sql
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
JOIN employees m ON e.reports_to = m.employee_id;
```

**⚡ Key Points:**
- Use clear, consistent aliases.

- The **The `AS`** keyword is optional but improves clarity.
**⚠️ Common Pitfalls:**
- Ambiguous or duplicate aliases can cause confusion.

---

## 🔗 **3. INNER JOIN (Explicit Join)** **Key Concept:**

- **`INNER JOIN`:** Retrieves only rows with matching values in both tables.
**Example:**

```sql
SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_statuses os ON o.status = os.order_status_id;
```

**⚡ Key Points:**

- Always specify accurate join conditions using the **Always specify accurate join conditions using the `ON`** clause.
**⚠️ Common Pitfalls:**

- Omitting join conditions may cause a **Cartesian product** (笛卡尔积).

---

## 🔄 **4. Implicit Join Syntax** **Key Concept:**

- **Implicit Join:** Uses comma-separated tables in the `FROM` clause with a `WHERE` clause to define join conditions.
**Example:**

```sql
SELECT *FROM customers c, orders o
WHERE c.customer_id = o.customer_id;
```

**⚡ Key Points:**

- Valid but less readable than explicit `JOIN`.
**⚠️ Common Pitfalls:**

- Forgetting the join condition in the `WHERE` clause can produce incorrect results.

---

## 🔄 **5. OUTER JOINS (LEFT & RIGHT JOINs)** **Key Concept:**

- **OUTER JOIN:** Returns all records from one table, plus matched records from the other.

- **LEFT JOIN:** Returns all rows from the left table.
- **RIGHT JOIN:** Returns all rows from the right table.
**LEFT JOIN Example:**

```sql
SELECT c.customer_id, o.order_id, o.order_date, c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id;
```

**RIGHT JOIN Example:**

```sql
SELECT order_id, quantity, name
FROM order_items oi
RIGHT JOIN products p ON p.product_id = oi.product_id;
```

**⚡ Key Points:**

- Understand which table is **primary (LEFT)** and which is **secondary (RIGHT)** .
**⚠️ Common Pitfalls:**
- Misinterpreting join direction may result in missing or extra rows.

---

## 🔑 **6. Composite Key Joins** **Key Concept:**

- **Composite Keys:** Join conditions based on multiple columns (复合键).
**Example:**

```sql
SELECT *FROM order_items oi
JOIN order_item_notes oin
  ON oi.order_id = oin.order_id
  AND oi.product_id = oin.product_id;
```

**⚡ Key Points:**
- Include all parts of the composite key in the join condition.
**⚠️ Common Pitfalls:**
- Joining on only part of the composite key causes incorrect results.

---

## 🔗 **7. JOIN Using the USING Clause** **Key Concept:**

- **USING Clause:** Simplifies join conditions when columns have the same name in both tables.
*（适用于列名相同的情况）***Example:**

```sql
SELECT customer_id, c.first_name, sh.name AS shipper
FROM customers c
JOIN orders o USING (customer_id)
LEFT JOIN shippers sh USING (shipper_id);
```

**⚡ Key Points:**
- Column names must be identical in all tables involved.
**⚠️ Common Pitfalls:**

- Using `USING` with mismatched column names causes errors.

---

## 🌐 **8. NATURAL JOIN** **Key Concept:**

- **NATURAL JOIN:** Automatically joins tables based on all columns with matching names.
**Example:**

```sql
SELECT *FROM orders o
NATURAL JOIN customers c;
```

**⚡ Key Points:**
- Reduces the need for explicit join conditions.
**⚠️ Common Pitfalls:**
- May unintentionally join on columns that were not intended.

---

## ➗ **9. CROSS JOIN** **Key Concept:**

- **CROSS JOIN:** Produces the Cartesian product of two tables.
*（笛卡尔积，生成所有可能的组合）***Example:**

```sql
SELECT c.first_name, p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;
```

**⚡ Key Points:**
- Use only when a full Cartesian product is intended.
**⚠️ Common Pitfalls:**

- Unfiltered `CROSS JOIN` can generate a large, unmanageable dataset.

---

## 🔗 **10. UNION Operator** **Key Concept:**

- **UNION:** Combines results from multiple `SELECT` statements, removing duplicates by default.
**Example:**

```sql
SELECT first_name, points, 'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT first_name, points, 'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT first_name, points, 'Gold' AS type
FROM customers
WHERE points > 3000ORDER BY first_name;
```

**⚡ Key Points:**

- Each `SELECT` must return the same number and type of columns.

- Use `UNION ALL` to include duplicates.
**⚠️ Common Pitfalls:**
- Mismatched columns or data types can cause errors.
- Unintended removal of duplicates when not using `UNION ALL`.

---

## 📋 **Overall Summary**

**This course covered:**

- ✅ **Switching Databases:** Using the **✅** Switching Databases:** Using the `USE`* statement effectively.
- ✅ **Table Aliasing:** Enhancing query readability.
- ✅ **Joins:** Mastering different join types (**INNER** , **OUTER** , **CROSS** , **NATURAL** ).
- ✅ **Composite Keys & USING Clause:** Handling complex joins.
- ✅ **UNION Operator:** Combining datasets efficiently.

**🔑 Pro Tip:** Always verify your join conditions and be mindful of common pitfalls to write efficient, accurate SQL queries.