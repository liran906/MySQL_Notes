# SELECT

## 1. Overview- **Purpose:** Retrieve data from one or more tables.

- **Functionality:**
  - Select specific columns.
  - Filter rows.
  - Aggregate data.
  - Sort results.
  - Paginate results.
- *Note:* "retrieve" means to extract or fetch data (提取数据).

---

## 2. Basic Syntax

```sql
SELECT [DISTINCT] column1, column2, ...FROM table_name
[WHERE condition]
[GROUP BY column_list]
[HAVING group_condition]
[ORDER BY column_list [ASC|DESC]]
[LIMIT number OFFSET number];
```

- *Note:* Square brackets `[ ]` indicate optional clauses.

---

## 3. Clause Breakdown

| **Clause** | **Purpose** | **Key Points** |
| --- | --- | --- |
| **SELECT** | Specifies columns or expressions to return. | - Use `AS` for aliases (optional, 别名：为列或表设置临时名称).- `DISTINCT` removes duplicate rows. |
| **FROM** | Indicates the source table(s). | - Can include multiple tables using JOINs.- Table aliases simplify query writing. |
| **WHERE** | Filters rows based on specified conditions. | - Use comparison operators: `=, >, <, >=, <=, <>`.- Combine conditions using logical operators (`AND`, `OR`, `NOT`). |
| **GROUP BY** | Groups rows with identical values into summary rows. | - Used with aggregate functions (e.g., `COUNT()`, `SUM()`, `AVG()`, `MAX()`, `MIN()`).- Non-aggregated columns should appear here (dialect-dependent). |
| **HAVING** | Filters groups formed by `GROUP BY`. | - Similar to `WHERE` but applies to groups (aggregated data). |
| **ORDER BY** | Sorts the result set by one or more columns. | - Default order is ascending (`ASC`).- Use `DESC` for descending order. |
| **LIMIT/OFFSET** | Restricts and paginates the number of rows returned. | - Commonly used for pagination.- Syntax may vary across SQL dialects (e.g., MySQL vs. PostgreSQL). |

---

## 4. Logical Execution Order

Even though the query is written in the order above, the SQL engine processes the clauses in the following logical order:

| **Step** | **Description** |
| --- | --- |
| **1. FROM** | Identify the source tables. |
| **2. WHERE** | Filter rows based on conditions. |
| **3. GROUP BY** | Group the filtered rows. |
| **4. HAVING** | Filter groups based on aggregate conditions. |
| **5. SELECT** | Select the required columns/expressions. |
| **6. ORDER BY** | Sort the final result set. |
| **7. LIMIT/OFFSET** | Limit the number of rows returned and optionally skip rows. |

*Note:* “execution order” (执行顺序) refers to the order in which SQL processes the clauses.

---

## 5. Additional Tips

| **Tip** | **Description** |
| --- | --- |
| **Aliasing** | Use `AS` to assign temporary names to columns or tables (别名：为列或表设置临时名称). |
| **Subqueries** | Embed nested `SELECT` statements within other clauses to build complex queries (嵌套查询：在其他子句中嵌入 `SELECT` 语句). |
| **Functions** | Utilize SQL functions and expressions in the `SELECT` clause for calculations or transformations. |
| **Reserved Words** | Avoid using SQL reserved words as identifiers; use escape characters if necessary. |
| **Performance** | - Apply filters early using `WHERE`.- Use `DISTINCT` cautiously on large datasets.- Ensure proper indexing. |

---

## 6. Example Query

```sql
SELECT DISTINCT e.employee_id, e.name, d.department_name, COUNT(p.project_id) AS project_count
FROM employees AS e
INNER JOIN departments AS d ON e.department_id = d.department_id
LEFT JOIN projects AS p ON e.employee_id = p.employee_id
WHERE e.status = 'active'GROUP BY e.employee_id, e.name, d.department_name
HAVING COUNT(p.project_id) > 2ORDER BY project_count DESCLIMIT 10 OFFSET 0;
```

**Explanation:**

- **SELECT DISTINCT:** Removes duplicate rows.
- **FROM / JOIN:** Retrieves data from `employees`, `departments`, and `projects` using `INNER JOIN` and `LEFT JOIN`.
- **WHERE:** Filters for active employees (`e.status = 'active'`).
- **GROUP BY:** Groups results by employee and department.
- **HAVING:** Filters groups where the employee has more than 2 projects.
- **ORDER BY:** Sorts results by the number of projects in descending order.
- **LIMIT/OFFSET:** Returns the first 10 rows (pagination).

---