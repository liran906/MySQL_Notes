# Data Type

## 1. Overview

SQL data types fall into several categories:
1. **Numeric** (integers, decimals, floating-point)
2. **Character / String** (CHAR, VARCHAR, TEXT)
3. **Date and Time** (DATE, TIME, DATETIME, TIMESTAMP)
4. **Boolean** (implementation-dependent)
5. **Binary / Large Objects** (BLOB, etc.)
6. **Vendor-specific** (e.g., **ENUM**, **SET**, **JSON** in MySQL)

Below is a rundown of commonly used types in standard SQL, along with notes on vendor-specific differences.

---

## 2. Numeric Data Types

### 2.1 Integer Types

| Type | Range / Size | Description |
| --- | --- | --- |
| **TINYINT** | -128 to 127 (SIGNED)0 to 255 (UNSIGNED) | Very small integer (1-byte). Often used for boolean flags in MySQL. |
| **SMALLINT** | -32768 to 32767 (SIGNED)0 to 65535 (UNSIGNED) | Small integer (2-byte). |
| **MEDIUMINT** (MySQL) | -8,388,608 to 8,388,607 (SIGNED)0 to 16,777,215 (UNSIGNED) | 3-byte integer, specific to MySQL. |
| **INT** or **INTEGER** | -2,147,483,648 to 2,147,483,647 (SIGNED)0 to 4,294,967,295 (UNSIGNED) | Typical 4-byte integer. |
| **BIGINT** | -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 (SIGNED) | 8-byte integer for very large values (e.g., counters). |

**Key Points:**
- **SIGNED** vs. **UNSIGNED**: Some databases (e.g., MySQL) allow unsigned integers, providing higher positive range but no negatives.
- In other SQL dialects (e.g., PostgreSQL), the numeric types might just be **SMALLINT**, **INTEGER**, **BIGINT** without unsigned variants.
- If to make sure the least digits **displayed**, notation is `INT(4)`, displays `0001` for 1, `0056` for 56, ect.

### 2.2 Fixed-Point and Floating-Point

| Type | Description |
| --- | --- |
| **DECIMAL(p, s)** (aka NUMERIC) | **Exact** numeric type with `p` (precision) and `s` (scale). *注释: “exact” (精确) means it stores values precisely without floating-point rounding.* |
| **FLOAT(m, d)** | Approximate floating-point with optional display width (m) and decimals (d). |
| **DOUBLE** | Double-precision floating-point (8 bytes). Also approximate. |
| **REAL** | In some SQL dialects, equivalent to DOUBLE or FLOAT, depending on vendor. |

**Key Points:**

- **Use DECIMAL (or NUMERIC) for monetary values or cases requiring exact arithmetic.**
- **Floating-point types (FLOAT, DOUBLE) can introduce rounding errors.**

---

## 3. Character / String Data Types

### 3.1 Fixed-Length vs. Variable-Length

| Type | Description |
| --- | --- |
| **CHAR(n)** | Stores a fixed-length string of length `n`. Pads with spaces if the data is shorter. |
| **VARCHAR(n)** | Stores up to `n` characters (variable-length). Uses only as many bytes as needed for each entry. |
| **TEXT**, **CLOB**, **LONGTEXT** | Large text fields for storing lengthy documents or strings (e.g., up to 2GB in some systems). |

**Key Points:**
- **CHAR** is often used for short, consistent-length data (e.g., country codes).

- **VARCHAR** is typical for general text.

- **TEXT / CLOB** handles very large text content (e.g., blog posts).

- **MEDIUMTEXT** store up to 16MB

-  **LONGTEXT** store up to 4GB

### 3.2 Collation and Character Sets

- **Collation** defines how strings are compared/sorted.
- **Character Sets** determine encoding (e.g., UTF-8, Latin1).
- Always confirm the default character set and collation in your database if you store multilingual data.

---

## 4. Date and Time Data Types

### 4.1 Common Date/Time Types

| Type | Description |
| --- | --- |
| **DATE** | Stores a date (year, month, day). |
| **TIME** | Stores a time of day (hours, minutes, seconds). |
| **DATETIME** | Stores both date and time (e.g., `YYYY-MM-DD HH:MM:SS`). |
| **TIMESTAMP** | Similar to `DATETIME`, but often used for tracking row changes (some systems auto-update). Uses 4 bytes of space, can only store to year 2039. |
| **YEAR** (MySQL) | Stores only a year in two- or four-digit format. |

**Key Points:**
- In MySQL, **DATETIME** vs. **TIMESTAMP** differ in range, default behaviors, and time zone handling.

- Other SQL dialects (like PostgreSQL) may use **TIMESTAMP WITHOUT TIME ZONE** or **TIMESTAMP WITH TIME ZONE** for more precise usage.

### 4.2 Time Zone Awareness

- Some systems support `TIMESTAMP WITH TIME ZONE` or `TIMESTAMP WITH LOCAL TIME ZONE`.
- This can simplify storing times that need to reflect or convert between time zones.

---

## 5. Boolean Data Types

- Standard SQL includes **BOOLEAN** or **BOOL**, but behavior differs among vendors.
- MySQL treats **BOOLEAN** as a synonym for **TINYINT(1)** with `0` = false, `1` = true.
- PostgreSQL has a native **BOOLEAN** type.

**Key Points:**
- Check your SQL dialect for how it implements boolean logic. If it lacks a real boolean, you may store 0/1 or ‘Y’/‘N’.

---

## 6. MySQL ENUM and SET Types

### 6.1 ENUM

**ENUM** defines a column that can take **one** value from a predefined list.

```sql
CREATE TABLE example_enum (
  color ENUM('red', 'green', 'blue') NOT NULL);
```

- **Storage**: Internally stored as an integer index referencing the string.
- **Pros**:
    - Easy constraint: can only store one of the defined options.
    - Potentially space-saving if the list is small.
- **Cons**:
    - Changing or adding options requires an ALTER TABLE.
    - Portability issues if you switch databases.
    - In some designs, it can be clearer to use a **lookup table** for these values or store them in a plain VARCHAR with foreign key constraints or app-level checks.

### 6.2 SET

**SET** defines a column that can store **one or more** values from a predefined list, in a single field:

```sql
CREATE TABLE example_set (
  my_set SET('apple', 'banana', 'cherry')
);
```

- The stored value can be `'apple'`, `'banana'`, `'apple,banana'`, etc.
- **Cons**: Similar to ENUM, it’s less flexible and can complicate queries and indexing. Often a separate **many-to-many** table is more normalized and scalable.

**Key Takeaway:**

- Many developers avoid **ENUM** and **SET** for large or evolving lists.

- If your list rarely changes and truly belongs as a single field, you might use them. Otherwise, a **lookup table** or a **JOIN** is more standard.

---

## 7. JSON Type (MySQL)

MySQL (5.7+) includes a native **JSON** data type. This lets you store and query JSON documents with specialized functions:

### 7.1 Storing JSON

```sql
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  name VARCHAR(50),
  properties JSON
);
```

You can insert JSON strings:

```sql
INSERT INTO products (product_id, name, properties)
VALUES (
  1,
  'PlayStation',
  '{    "weight": 10,    "dimensions": [1, 2, 3],    "manufacturer": { "name": "sony" }  }');
```

Or construct JSON with MySQL functions:

```sql
UPDATE products
SET properties = JSON_OBJECT(
  'weight', 10,
  'dimensions', JSON_ARRAY(1, 2, 3),
  'manufacturer', JSON_OBJECT('name', 'sony')
)
WHERE product_id = 1;
```

### 7.2 Querying JSON

MySQL provides functions to extract or manipulate JSON data, e.g.:

```sql
SELECT JSON_EXTRACT(properties, '$.manufacturer.name') AS maker
FROM products
WHERE product_id = 1;
```

- `$.manufacturer.name` references the path to the `name` key inside `manufacturer`.

### 7.3 Pros and Cons of JSON Columns

- **Pros**:
    - Flexible schema for attributes that vary per row.
    - Quick to store hierarchical data without multiple JOINs.
- **Cons**:
    - Harder to enforce constraints or type checks on nested fields.
    - Complex queries are less efficient than normalized relational columns.
    - If data is truly relational, an EAV or properly normalized schema might be clearer.

---

## 8. Binary & Large Object Types

### 8.1 Binary Data

| Type | Description |
| --- | --- |
| **BINARY(n)** | Fixed-length binary data of length `n`. |
| **VARBINARY(n)** | Variable-length binary data of maximum length `n`. |

### 8.2 BLOB (Binary Large Object)

**BLOB** (Binary Large OBject) can store images, videos, or other binary files.

| Type | Description |
| --- | --- |
| **BLOB** (MySQL) | Up to 65,535 bytes (64 KB). |
| **MEDIUMBLOB** | Up to 16 MB. |
| **LONGBLOB** | Up to 4 GB. |
| **BYTEA** (PostgreSQL) | Similar usage to BLOB in PGSQL. |

**Key Points:**

storing large files **in** the DB can lead to:

1. **Increased Database Size**
    - Large files bloat the database storage.
2. **Slower Backups**
    - Database dumps become huge and take longer to back up or restore.
3. **Performance Problems**
    - Reading/writing large BLOBs can slow queries or degrade concurrency.
4. **More Complex Code**
    - You need to handle file I/O through the database API. Retrieving or streaming images can be more cumbersome.

**Alternative**: Store only **file paths** or **URLs** in the database, and keep the actual files on a file server or object storage (S3, etc.). This approach usually yields:
- Smaller database size
- Faster backups
- Better separation of concerns

## However, some cases (strongly consistent backups, security needs) might justify storing files in the DB.

## 9. Choosing the Right Data Type

1. **Performance**:
    - Smaller types can mean faster queries (especially if indexing).
    - **e.g.,** If you only store small numbers (range < 100), a TINYINT might suffice.
2. **Storage Space**:
    - Using a huge type (e.g., BIGINT) for a small range can waste space.
    - Overly large VARCHAR or TEXT fields can slow data retrieval.
3. **Data Integrity**:
    - Use **DECIMAL** for financial data to avoid floating-point errors.
    - Use **DATE** or **DATETIME** for date/time, not strings.
4. **Vendor Differences**:
    - MySQL has many custom data types (e.g., MEDIUMINT, ENUM).
    - PostgreSQL has arrays, JSON, etc.
    - Know your DB’s capabilities and defaults.

---

## 10. Example: Table Creation

```sql
CREATE TABLE example (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,      -- exact numeric for monetary    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE);
```

**Explanation:**
- **id**: INT with auto-increment for a primary key.
- **name**: Variable-length string with max 50 chars.
- **price**: DECIMAL for storing exact currency (10 digits total, 2 after decimal).
- **created_at**: DATETIME with default as current timestamp (MySQL syntax).
- **description**: TEXT for larger text content.
- **is_active**: BOOLEAN (in MySQL, typically TINYINT(1)) with default TRUE.

---

## 11. Brief Recap of Standard Types

1. **Numeric**
    - INT, TINYINT, BIGINT, DECIMAL, FLOAT, etc.
2. **String**
    - CHAR(n), VARCHAR(n), TEXT, etc.
3. **Date/Time**
    - DATE, TIME, DATETIME, TIMESTAMP, etc.
4. **Boolean** (in MySQL, typically TINYINT(1))
5. **Binary**
    - BINARY, VARBINARY, BLOB types
6. **ENUM / SET** (MySQL-specific)
7. **JSON** (MySQL-specific)

---

# **Summary**

1. **Numeric**: Choose between integer (TINYINT, SMALLINT, INT, BIGINT) or fixed/float (DECIMAL, FLOAT).
2. **String**: Use CHAR for fixed-length, VARCHAR for variable, TEXT for large text.
3. **Date/Time**: **DATE**, **TIME**, **DATETIME**, **TIMESTAMP** (depending on time zone needs).
4. **Boolean**: Some SQL dialects have real BOOLEAN, others store as TINYINT or a char. (in MySQL, typically TINYINT(1))
5. **Binary/Large Objects**: For files or large amounts of data (BLOB, VARBINARY, etc.).
6. **Vendor Specifics**: MySQL, PostgreSQL, Oracle, etc., have variations or additional data types.
7. **ENUM** and **SET** are MySQL-specific for restricting a field’s allowed values, but can be less flexible than a lookup table.
8. **JSON** in MySQL provides semi-structured data storage and easy JSON manipulation, but watch out for performance and structural complexity.
9. **BLOB** Storing large files (BLOB) in the database can cause big performance and backup issues—consider storing only file paths or using external storage.

Choose the type that best fits your **data shape**, **performance** needs, and **future flexibility**. By selecting data types that match your real-world data’s **range** and **format**, you ensure better **performance**, **storage efficiency**, and **data integrity**. For many evolving use cases, normalized tables or external file storage plus references in the DB is more maintainable.