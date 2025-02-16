# Views

## 1. What is a View?

A **view** is a virtual table based on a **SELECT** query. It does not store data physically (unless it’s a materialized view in some DBMS) but allows you to:

- Simplify complex queries.
- Enhance security by restricting direct access to base tables.
- Provide a consistent interface even if the underlying schema changes.

---

## **2. Creating a View**You can create a view with the **CREATE VIEW** statement. Below is an example from the **sql_invoicing** database:

```sql
-- Create a view to show total sales by client
CREATE VIEW sales_by_client AS
SELECT    
		client_id,
    name,
    SUM(invoice_total) AS total_sales
FROM clients
JOIN invoices USING (client_id)
GROUP BY client_id, name;
```

**Key Points:**
- **CREATE VIEW view_name AS** *SELECT statement*;
- The **view** name is used later in queries just like a table name.

---

## **3. Using Views**

Once created, use a view in SELECT statements just like a table:

```sql
SELECT *
FROM sales_by_client
JOIN clients USING (client_id)
WHERE total_sales > 500;
```

**Advantages:**
- Hides the complexity of underlying tables and joins.
- Can provide **read-only** or filtered access to sensitive data.

---

## **4. Dropping and Replacing Views**

If you need to modify an existing view, you can drop and recreate it, or use **CREATE OR REPLACE**:

```sql
DROP VIEW sales_by_client;
-- Recreate or replace the view
CREATE OR REPLACE VIEW sales_by_client AS
SELECT    
		client_id,
    name,
    SUM(invoice_total) AS total_sales
FROM clients
JOIN invoices USING (client_id)
GROUP BY client_id, name;
```

**Key Points:**
- **DROP VIEW view_name;** removes the view from the database.
- **CREATE OR REPLACE VIEW** overwrites an existing view definition without needing to drop it first.

---

## **5. Updating Data via Views**

### **5.1 Which Views Are Updatable?**

A view is generally **updatable** if it:
- Does **not** have `DISTINCT`.
- Does **not** use aggregate functions (`SUM`, `MAX`, `MIN`, `AVG`, `COUNT`, etc.).
- Does **not** include `GROUP BY` / `HAVING`.
- Does **not** use set operators like `UNION`.
- And certain other restrictions depending on the SQL dialect.

If a view meets these conditions, you can issue `UPDATE` or `DELETE` statements against the view, and it will affect the underlying table(s).

**Example of a potentially updatable view**:

```sql
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
    invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE invoice_total - payment_total > 0;
```

### **5.2 Modifying Data**

```sql
-- Delete via the view
DELETE FROM invoices_with_balance
WHERE invoice_id = 1;
-- Update via the view
UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;
```

**Key Points:**
- Any valid changes through the view are reflected in the underlying table.
- If the view is not updatable, these statements will raise an error.

---

## **6. WITH CHECK OPTION**

**WITH CHECK OPTION** prevents updates or inserts through a view that would cause rows to disappear from that view’s own `WHERE` clause:

```sql
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
    invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE invoice_total - payment_total > 0
WITH CHECK OPTION;
```

**Example Scenario:**
- Without **WITH CHECK OPTION**, setting `payment_total = invoice_total` would remove a row from the view (because `invoice_total - payment_total` would be 0).

- With **WITH CHECK OPTION**, the DB will raise an error instead of allowing the row to “fall out” of the view.

**Key Points:**
- Protects data consistency from within the view context.
- Ensures rows remain visible in the view if an **UPDATE** or **INSERT** would otherwise exclude them from the `WHERE` filter.

---

## **7. Best Practices and Additional Benefits of Views**

1. **Simplify Repetitive Queries:** Consolidate complex `JOIN`s or calculations into a single logical unit.
2. **Security:** Expose only specific columns or rows from the underlying tables.
3. **Logical Data Independence:** Change base table structures while keeping the same view for end users.
4. **Version Control:** Store your **CREATE VIEW** statements in source control (like Git) to manage schema changes.

**Note:** Some systems (like MySQL) have additional features or limitations on views, especially concerning updatable views or performance.

---

# **Summary**

- **Creating/Using Views:** `CREATE VIEW ... AS SELECT ...` provides a virtual table based on a query.
- **Replacing Views:** `CREATE OR REPLACE VIEW` modifies an existing view without dropping it first.
- **Updatable Views:** Must not contain aggregates, GROUP BY, DISTINCT, UNION, etc.
- **WITH CHECK OPTION:** Ensures data changes via the view don’t violate the view’s own conditions.
- **Dropping Views:** `DROP VIEW view_name;` removes a view definition.

Using views effectively lets you simplify data access patterns, enhance security, and maintain logical consistency even when your schema evolves.