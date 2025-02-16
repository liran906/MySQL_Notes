# Aggregate Functions

### 1. Overview

| **Functions** | Function | Example |
| --- | --- | --- |
| MAX() | Returns the largest value in a set of values. | SELECT MAX(invoice_total) FROM invoices; |
| MIN() | Returns the smallest value in a set of values. | SELECT MIN(invoice_total) FROM invoices; |
| AVG() | Returns the average (mean) value of a numeric column. | SELECT AVG(invoice_total) FROM invoices; |
| SUM() | Returns the total sum of a numeric column. | SELECT SUM(invoice_total) FROM invoices; |
| COUNT(*) | Returns the number of rows that match the specified criteria. | SELECT COUNT(*) FROM invoices; |
| COUNT(DISTINCT) | Returns the count of unique non-null values in a column. | COUNT(DISTINCT client_id) |

**Key Points:**
- Aggregate functions operate on a set of rows and return a single result per group or for the entire table if no grouping is specified.

- `COUNT(\*)` includes all rows (including duplicates and null values), whereas `COUNT(DISTINCT column)` counts only unique values and excludes nulls.
**Common Pitfalls:**
- Applying an aggregate function in the `SELECT` list without grouping other columns usually causes an error unless using certain SQL modes or dialects.

---

**2. GROUP BY Clause** **Purpose:**
- Groups rows that have the same values in specified columns, allowing aggregate functions to be applied to each group.
**Syntax:**

```sql
SELECT column1, column2, AGGREGATE_FUNCTION(column3)
FROM table[WHERE condition]
GROUP BY column1, column2
[HAVING condition]
[ORDER BY column(s)];
```

**Example:**

```sql
SELECT client_id, SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id;
```

**Key Points:**

- All **non-aggregated** columns in the `SELECT` list must typically be included in the `GROUP BY` clause (SQL standards may vary by dialect).

- `GROUP BY` combines rows that share the same values in the grouping columns, so aggregate functions apply per group.
**Common Pitfalls:**
- Attempting to reference an aggregate alias (e.g., `total_sales`) in the `WHERE` clause. Use **HAVING** instead.
- Including columns in the `SELECT` list that aren’t included in either an aggregate function or the `GROUP BY` clause (which leads to an error in strict SQL modes).

---

**3. HAVING Clause** **Purpose:**

- Similar to `WHERE`, but filters the groups **after** they have been formed by `GROUP BY`.

- Usually used to filter on **aggregate** values.
**Example:**

```sql
SELECT client_id, SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id
HAVING total_sales > 500;
```

**Key Points:**

- `HAVING` is applied **after** grouping; `WHERE` is applied **before** grouping.

- You can reference aggregate function aliases in the `HAVING` clause (e.g., `HAVING total_sales > 500`).
**Common Pitfalls:**
- Using `WHERE` to filter on aggregate values. This will cause an error or yield incorrect results because `WHERE` is evaluated **before** the grouping occurs.

---

**4. UNION Operator with Aggregates** **Purpose:**

- Combine the results of multiple `SELECT` statements into a single result set.

- Often used to create summarized rows for different conditions and then unify them.
**Example:**

```sql
SELECT  'First half of 2019' AS date_range,
  SUM(invoice_total) AS total_sales,
  SUM(payment_total) AS total_payments,
  SUM(invoice_total) - SUM(payment_total) AS expected
FROM invoices
WHERE invoice_date <= '2019-06-30'
UNION
SELECT  'Second half of 2019' AS date_range,
  SUM(invoice_total) AS total_sales,
  SUM(payment_total) AS total_payments,
  SUM(invoice_total) - SUM(payment_total) AS expected
FROM invoices
WHERE invoice_date > '2019-06-30'
UNION
SELECT  'Total' AS date_range,
  SUM(invoice_total) AS total_sales,
  SUM(payment_total) AS total_payments,
  SUM(invoice_total) - SUM(payment_total) AS expected
FROM invoices;
```

**Key Points:**

- Each `SELECT` must have the same number of columns and compatible data types.

- By default, `UNION` removes duplicate rows. If duplicates are acceptable, use `UNION ALL`.
**Common Pitfalls:**
- Mismatched column counts or types among the `SELECT` statements causing errors.
- Unintentionally removing duplicates if you actually need them.

---

**5. ORDER BY with Aggregates** **Purpose:**
- Sorts the result set, typically by an aggregated column or a grouped column.
**Example:**

```sql
SELECT client_id, SUM(invoice_total) AS total_sales
FROM invoices
WHERE invoice_date > '2019-06-30'
GROUP BY client_id
ORDER BY total_sales DESC;
```

**Key Points:**

- You can order by an aggregate function alias or any column in the `SELECT` list.

- If you include `HAVING`, it is processed before `ORDER BY`.
**Common Pitfalls:**
- Using columns in `ORDER BY` that are neither grouped nor aggregated can produce undefined results in some SQL dialects.

---

**6. ROLLUP Extension (MySQL-Specific)** **Purpose:**

- `WITH ROLLUP` allows you to get **subtotals** and **grand totals** across the grouping columns.
**Example:**

```sql
SELECT city, state, SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients c USING (client_id)
GROUP BY city, state WITH ROLLUP;
```

OR

```sql
SELECT pm.name AS method_of_payment, SUM(amount) AS total
FROM payments p
JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY method_of_payment WITH ROLLUP;
```

**Key Points:**

- `WITH ROLLUP` adds extra summary rows that represent subtotals and the grand total at the end.

- The number of subtotal rows depends on how many columns you group by.
- Not supported by all SQL dialects; it’s a MySQL extension (also available in some form in other RDBMS with different syntax, like Oracle’s `GROUPING SETS`).
**Common Pitfalls:**
- Interpreting the extra rows incorrectly. The rows with `NULL` in certain columns indicate subtotals or grand totals.
- Forgetting that `WITH ROLLUP` can change the number of rows returned.

---

**7. Putting It All Together**
Below is a sample query demonstrating several concepts:

```sql
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.state,
    SUM(oi.quantity * oi.unit_price) AS total_price
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE c.state = 'VA'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.state
HAVING total_price > 100ORDER BY total_price DESC;
```

1. **FROM / JOIN:** Combines data from multiple tables.
2. **WHERE:** Filters rows before grouping (`state = 'VA'`).
3. **GROUP BY:** Groups by customer details.
4. **SELECT (Aggregates):** Summarizes total price per customer.
5. **HAVING:** Filters grouped data by `total_price > 100`.
6. **ORDER BY:** Sorts results descending by total price.

---

**Key Takeaways**

1. **Aggregate Functions** : `MAX()`, `MIN()`, `SUM()`, `AVG()`, `COUNT()`, etc., help summarize data.

1. **GROUP BY** : Needed to aggregate data by specific columns.
2. **HAVING** : Works like `WHERE` but applies to the grouped results.
3. **UNION** : Combines multiple queries into one result set, especially for summarizing different time periods or conditions.
4. **ROLLUP** : Adds subtotals and a grand total to grouped data (MySQL-specific).
Staying mindful of the difference between `WHERE` (pre-group filtering) and `HAVING` (post-group filtering) is critical. Also, watch out for **ORDER BY** usage, especially in complex grouped queries, and confirm that columns are either grouped or aggregated.