# Subqueries

## 1. Introduction to Subqueries

A **subquery** (also known as a nested query) is a **SELECT** statement nested inside another SQL statement, such as **SELECT**, **INSERT**, **UPDATE**, or **DELETE**. Subqueries allow you to:

- Compare values to aggregated results or another set of rows.
- Dynamically filter data with operators like **IN**, **ANY**, or **ALL**.
- Determine the existence (or absence) of related data using **EXISTS** or **NOT EXISTS**.
- Compute values in the **SELECT** clause or create derived tables in the **FROM** clause.

## 2. Single-Value (Scalar) Subqueries

### 2.1 Basic Scalar Comparison

A **scalar subquery** returns exactly one row and one column. It’s often used to compare a column against an aggregate, for example:

```sql
-- Using a subquery to filter employees whose salary is above the company's averageUSE sql_hr;
SELECT *FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

**Key Points:**

- The subquery `(SELECT AVG(salary) FROM employees)` returns a single numeric value.

- The outer query compares each employee’s `salary` to that single value.
**Common Pitfalls:**
- If the subquery accidentally returns multiple rows (instead of one), this query will fail or produce an error, depending on your SQL dialect.

---

## 3. Multi-Value Subqueries (IN / NOT IN)

### 3.1 Using IN

When a subquery returns multiple values, the **IN** operator can be used to filter rows by membership in a set. For instance:

```sql
USE sql_invoicing;
SELECT *FROM clients
WHERE client_id NOT IN (
    SELECT DISTINCT client_id
    FROM invoices
);
```

- This query retrieves **clients** who have **not** issued any invoices.
**Key Points:**
- `NOT IN` is the negation of `IN`; if the subquery’s list includes `NULL`, it can affect the logic unexpectedly.
- The subquery `(SELECT DISTINCT client_id FROM invoices)` returns multiple client IDs, and the outer query checks if the client’s ID is **not** in that list.

---

## 4. Nested Subqueries

You can nest subqueries several levels deep. Although often correct, deep nesting can hamper readability and performance. Below is an example referencing **multiple** related tables:

```sql
USE sql_store;
SELECT *FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE order_id IN (
        SELECT order_id
        FROM order_items
        WHERE product_id IN (
            SELECT product_id
            FROM products
            WHERE name = 'Lettuce - Romaine, Heart'        )
    )
);
```

**Explanation & Key Points:**

- The deepest subquery finds the `product_id` for **“Lettuce - Romaine, Heart”** .

- The next level up finds `order_id` rows where that `product_id` was sold.
- The next level returns `customer_id` rows for those orders.
- Finally, the outer query fetches the matching customers.
**Alternative with JOIN:**

```sql
SELECT *FROM order_items
JOIN orders USING (order_id)
JOIN customers USING (customer_id)
WHERE product_id = 3;
```

- Sometimes rewriting subqueries as **JOIN** statements can be clearer or faster.

---

## 5. Comparing to All or Any Values

### 5.1 Using ALL

To compare a single value to *every* row in a subquery result, use **ALL** . Example:

```sql
-- "Select invoices greater than ALL invoices of client 3."USE sql_invoicing;
SELECT *FROM invoices
WHERE invoice_total > ALL (
    SELECT invoice_total
    FROM invoices
    WHERE client_id = 3);
```

- The condition `invoice_total > ALL ( ... )` means “the invoice_total must be **greater than** every invoice_total of client 3.”

### 5.2 Using ANY

**ANY** returns rows if the condition is true for **at least one** value in the subquery. Consider this example, where we want clients who have at least 2 invoices:

```sql
-- Using ANYSELECT *FROM clients
WHERE client_id = ANY (
    SELECT client_id
    FROM invoices
    GROUP BY client_id
    HAVING COUNT(*) >= 2);
```

**Key Points:**

- `ANY` is logically similar to `IN` for equality conditions but more flexible for comparisons like `> ANY(...)` or `< ANY(...)`.

- `ALL` and `ANY` can reduce the need for manual grouping or rewriting logic.

---

## 6. Correlated Subqueries

### 6.1 Basics of Correlation

A **correlated subquery** references columns from the outer query. It effectively runs once **per row** of the outer query, which can impact performance if not used judiciously.

```sql
USE sql_hr;
SELECT *FROM employees e_outter
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE office_id = e_outter.office_id  -- correlated with the outer query);
```

**Key Points:**

- `office_id = e_outter.office_id` ties each subquery execution to the current row in `employees`.

- Generally slower than a non-correlated subquery because it executes multiple times.
Another example in `sql_invoicing`:

```sql
SELECT *FROM invoices i_outter
WHERE invoice_total > (
    SELECT AVG(invoice_total)
    FROM invoices
    WHERE client_id = i_outter.client_id
);
```

- Each invoice is compared with **the average invoice total** of the same client.

---

## 7. EXISTS and NOT EXISTS

### 7.1 EXISTS for Large Datasets

**EXISTS** checks if a subquery returns **at least one** row. This approach can be more efficient than an **IN** subquery when tables are large:

```sql
-- More efficient than IN operator when dealing with large datasetsUSE sql_invoicing;
SELECT *FROM clients c
WHERE EXISTS (
    SELECT *    FROM invoices
    WHERE client_id = c.client_id
);
```

**Key Points:**

- Returns the outer row if the subquery is **not empty** .

- `NOT EXISTS` is the negation, returning rows if the subquery is empty.
**Example with NOT EXISTS** :

```sql
USE sql_store;
SELECT *FROM products p
WHERE NOT EXISTS (
    SELECT *    FROM order_items
    WHERE product_id = p.product_id
);
```

- This finds products that have never been ordered.

---

## 8. Subqueries in the SELECT Clause

You can place subqueries in the **SELECT** list to compute extra columns. However, each subquery must return exactly one value:

```sql
USE sql_invoicing;
-- Example: comparing each invoice to the overall averageSELECT    invoice_id,
    invoice_total,
    (SELECT AVG(invoice_total) FROM invoices) AS average,
    invoice_total - (SELECT AVG(invoice_total) FROM invoices) AS difference
FROM invoices
GROUP BY invoice_id, invoice_total;
```

**Key Points:**

- Each row from `invoices` calls the subquery `(SELECT AVG(invoice_total) ...)` independently.

- Overuse of subqueries in the SELECT clause can be slow, but it’s straightforward for cross-referencing aggregated data.

---

## 9. Subqueries in the FROM Clause (Derived Tables)

A subquery inside the **FROM** clause acts as a **derived table** (inline view). For instance:

```sql
USE sql_invoicing;
SELECT *FROM (
    -- using the above table here:    SELECT        client_id,
        name,
        (SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
        (SELECT AVG(invoice_total) FROM invoices) AS average,
        (SELECT total_sales - average) AS difference
    FROM clients c
) AS summary  -- table aliasWHERE total_sales IS NOT NULL; -- can filter or process this derived data
```

**Key Points:**

- A derived table must have an **alias** (in this case, `summary`).

- Keep these subqueries simple; complex transformations might be clearer using a **VIEW** .

---

## 10. Rewriting Subqueries as JOINs

In many cases, you can rewrite a subquery using **JOIN** operations. The choice depends on:
1. **Performance:** Some JOINs can be faster if proper indexes exist.

1. **Readability:** JOIN-based queries can be clearer or more cumbersome depending on the scenario.

```sql
-- Example: subqueries can be replaced with JOIN for better performanceSELECT *FROM invoices
LEFT JOIN clients USING (client_id)
WHERE invoice_id IS NOT NULL;
```

---

# Summary & Best Practices

1. **Choose the Right Approach:** Decide between subqueries or **JOIN** based on clarity and performance.
2. **Use Correlated Subqueries Sparingly:** Each row triggers the subquery, which can be slow on large tables.
3. **ANY, ALL, EXISTS:** Provide flexible ways to test for membership, maximum/minimum comparisons, or existence.
4. **Derived Tables (FROM Clause):** Create on-the-fly views to simplify complex logic—but watch for readability.
5. **Subqueries in SELECT:** Great for quick calculations but can be slow if repeated many times.
Understanding these subquery methods (and their pros and cons) is crucial to writing **clean** , **efficient** , and **effective** SQL queries.