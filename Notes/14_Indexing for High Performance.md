# Indexing for High Performance

Indexes are powerful tools for speeding up query execution, but they come with costs. The key is to design indexes based on your query patterns—not just on your tables.

---

## 1. Why Use Indexes?

- **Speed Up Queries:**
    
    Indexes allow the database engine to quickly locate rows without scanning the entire table.
    
- **Costs of Indexing:**
    - **Increased Storage:**
    Indexes add extra data to your database, increasing its overall size.
    - **Slower Writes:**
    Inserting, updating, or deleting rows can be slower because indexes must be updated accordingly.

**Guideline:**

Reserve indexes for performance-critical queries. Design indexes based on the queries you run, rather than adding indexes indiscriminately when creating tables.

---

## 2. How Indexes Work

- **Data Structure:**
    
    Most databases store indexes in a binary-tree (B-tree) structure. This allows logarithmic time lookups.
    
- **Primary vs. Secondary Indexes:**
    - **Primary (Clustered) Index:**
    Created automatically when a primary key is defined. The table’s data is stored in order of this index.
    - **Secondary Indexes:**
    User-created indexes and those automatically created for foreign keys. Secondary indexes include the primary key in their structure to allow row lookups.

---

## 3. Creating and Evaluating Indexes in MySQL

### 3.1 Basic Example

Before creating an index, you can check the execution plan with `EXPLAIN`:

```sql
USE sql_store;
-- Without index: full table scan or less efficient method.
EXPLAIN SELECT customer_id FROM customers WHERE state = 'CA';

-- Create an index on the state column.
CREATE INDEX idx_state ON customers (state);

-- With index: the plan should now use a REF or similar method.
EXPLAIN SELECT customer_id FROM customers WHERE state = 'CA';

-- To view existing indexes:
SHOW INDEXES IN customers;
```

---

## 4. Indexing String Columns and Prefix Indexes

- **String Indexes:**
    
    Indexing columns with data types like `CHAR`, `VARCHAR`, `TEXT`, or `BLOB` is common.
    
- **Prefix Indexes:**
    
    For very large text columns, you can index only a prefix (the first N characters) of the column.
    
    **Example:**
    
    ```sql
    CREATE INDEX idx_lastname ON customers (last_name(5));
    ```
    
    **How to decide on the prefix length?**
    
    Use queries like:
    
    ```sql
    SELECT
        COUNT(*) AS total,
        COUNT(DISTINCT LEFT(last_name, 1)) AS prefix_1,
        COUNT(DISTINCT LEFT(last_name, 3)) AS prefix_3,
        COUNT(DISTINCT LEFT(last_name, 5)) AS prefix_5,
        COUNT(DISTINCT LEFT(last_name, 10)) AS prefix_10
    FROM customers;
    ```
    
    In this example, indexing the first 5 characters may be optimal if it sufficiently distinguishes values.
    

---

## 5. Full-Text Indexes

Full-text indexes are used for text search operations, especially when using natural language queries.

### 5.1 Basic Usage

Without a full-text index:

```sql
SELECT *FROM posts
WHERE title LIKE '%react redux%' OR body LIKE '%react redux%';
```

Create a full-text index:

```sql
CREATE INDEX idx_title_body ON posts (title, body);
```

Then perform full-text search:

```sql
SELECT *FROM posts
WHERE MATCH (title, body) AGAINST ('react redux');
```

### 5.2 Boolean Mode and Exact Phrases

Full-text search in Boolean mode lets you refine queries:

```sql
-- Exclude 'redux' but include 'react' and an exact term 'form'
SELECT *
FROM posts
WHERE MATCH (title, body) AGAINST ('react -redux +form' IN BOOLEAN MODE);

-- Search for an exact phrase using double quotes:
SELECT *
FROM posts
WHERE MATCH (title, body) AGAINST ('"handling a form"' IN BOOLEAN MODE);
```

---

## 6. Composite Indexes

- **Definition:**
    
    A composite index is built on multiple columns. It’s used when your queries filter on more than one column.
    
- **Creating a Composite Index:**
    
    ```sql
    CREATE INDEX idx_state_points ON customers (state, points);
    ```
    
- **Order Matters:**
    
    In a composite index `(a, b)`, queries that filter on `a` or on `a, b` are fast, while queries filtering only on `b` might not benefit from the index.
    

---

## 7. Sorting and Covering Indexes

- **Sorting:**
    
    Indexes can help speed up `ORDER BY` operations. For best performance, the order of columns in the index should match the order by which you sort.
    
    **Example Fast Sorts with an index on (a, b):**
    
    - `ORDER BY a`
    - `ORDER BY a, b`
    - `ORDER BY a DESC, b DESC`
    
    **Example Slow Sorts:**
    
    - `ORDER BY b`
    - `ORDER BY b, a`
    - `ORDER BY a, b DESC`
    - `ORDER BY a DESC, b`
- **Covering Index:**
    
    An index that contains all columns needed for a query so that the database does not need to access the table data separately. This is the fastest scenario for read queries.
    

---

## 8. Index Maintenance and Strategy

- **Design Based on Queries:**
    
    Indexes should be designed according to the queries you run most frequently, not merely based on table structure.
    
- **Index Selection Strategy:**
    1. Check the **`WHERE` clause** for frequently used columns.
    2. Then consider the **`ORDER BY` clause**.
    3. Finally, consider the **`SELECT` clause** to determine if a covering index can be created.
- **Index Maintenance:**
    
    Keep in mind that indexes add overhead on write operations (INSERT, UPDATE, DELETE). They also consume additional disk space.
    

---

## 9. Summary & Best Practices

- **Indexes speed up queries** by reducing the amount of data scanned, but they **increase database size** and **slow down writes**.
- **Use indexes judiciously:**
    - Reserve them for performance-critical queries.
    - Design indexes based on your queries, not solely on table structure.
- **Index types:**
    - **Basic Indexes:** For most columns.
    - **Prefix Indexes:** For large string columns.
    - **Full-Text Indexes:** For natural language search.
    - **Composite Indexes:** For queries filtering on multiple columns.
    - **Covering Indexes:** When the index includes all columns required by the query.
- **Monitor Performance:**
Use tools like `EXPLAIN` and `SHOW INDEXES` to verify that your indexes are being used effectively.
- **Trade-Offs:**
Balance the need for fast reads against the overhead on write operations.

By carefully designing and maintaining your indexes, you can significantly enhance the performance of your database queries while minimizing the overhead on your system.