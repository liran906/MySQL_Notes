# SQL Built Functions

# **Numeric, String, Date/Time, and Conditional Expressions**

## 1. Overview

This lesson covers common **built-in SQL functions** that manipulate numeric values, strings, and dates/times. It also introduces **conditional expressions** (IF, CASE) and **null-handling functions** (IFNULL, COALESCE).

---

## 2. Numeric Functions

**Numeric functions** help you perform mathematical operations and round, truncate, or generate random numbers.

### 2.1 Rounding and Truncation

```sql
SELECT ROUND(5.7345);          -- 6
SELECT ROUND(5.7345, 1);       -- 5.7
SELECT ROUND(5.7345, 2);       -- 5.73
SELECT TRUNCATE(5.7385, 0);    -- 5
SELECT TRUNCATE(5.7385, 2);    -- 5.73
```

**Key Points:**
- **ROUND(x, d)**: Rounds a number to **d** decimal places.
- **TRUNCATE(x, d)**: Truncates (cuts off) the number to **d** decimal places (no rounding).

### 2.2 Ceiling and Floor

```sql
SELECT CEILING(5.3);  -- 6
SELECT CEILING(5);    -- 5
SELECT FLOOR(5.6);    -- 5
SELECT FLOOR(5);      -- 5
```

**Key Points:**
- **CEILING(x)**: Rounds **x** up to the nearest integer.
- **FLOOR(x)**: Rounds **x** down to the nearest integer.

### 2.3 Absolute Value and Random

```sql
SELECT ABS(-5.3);      -- 5.3
SELECT RAND();         -- random float between 0 and 1
```

**Key Points:**
- **ABS(x)**: Returns the absolute value of **x**.
- **RAND()**: Generates a pseudo-random float value between 0 and 1.

---

## 3. String Functions

**String functions** let you manipulate text, such as changing case, trimming spaces, or extracting substrings.

### 3.1 Changing Case and Trimming

```sql
SELECT LENGTH('sky');        -- 3
SELECT UPPER('sky');         -- 'SKY'
SELECT LOWER('Sky');         -- 'sky'
SELECT LTRIM('      sky');   -- 'sky'
SELECT RTRIM('sky      ');   -- 'sky'
SELECT TRIM('    sky   ');   -- 'sky'
```

**Key Points:**
- **LENGTH(str)**: Returns the number of characters in `str`.
- **UPPER/LOWER(str)**: Converts `str` to uppercase or lowercase.
- **LTRIM/RTRIM/TRIM(str)**: Removes leading, trailing, or both leading and trailing spaces.

### 3.2 Substring and Position

```sql
SELECT LEFT('kindergarten', 4);      -- 'kind'
SELECT RIGHT('kindergarten', 5);     -- 'arten'
SELECT SUBSTRING('kindergarten', 2, 5); -- 'inder' (starting at position 2)
SELECT SUBSTRING('kindergarten', 2);    -- 'indergarten'
SELECT LOCATE('N', 'kindergarten');  -- 3 (case-insensitive)
SELECT LOCATE('q', 'kindergarten');  -- 0 (not found)
SELECT LOCATE('garten', 'kindergarten'); -- 7
```

**Key Points:**
- **LEFT(str, n)** / **RIGHT(str, n)**: Extract **n** characters from the left or right.
- **SUBSTRING(str, start, length)**: Extract a substring starting at position `start` (1-based index).
- **LOCATE(substr, str)**: Returns the position of the **first** occurrence of `substr` in `str` (0 if not found).

### 3.3 Replacing and Concatenation

```sql
SELECT REPLACE('kindergarten', 'garten', 'garden'); -- 'kindergarden'
SELECT CONCAT('John', 'Smith');                     -- 'JohnSmith'
SELECT CONCAT('John', ' ', 'Smith');                -- 'John Smith'
```

**Key Points:**
- **REPLACE(str, from, to)**: Replaces occurrences of `from` in `str` with `to`.
- **CONCAT(…)**: Joins multiple strings together.

---

## 4. Date/Time Functions

**Date/time functions** allow you to obtain the current date/time, extract components, and format or manipulate dates.

### 4.1 Current Date and Time

```sql
SELECT NOW();       -- '2025-02-15 11:31:39'
SELECT CURDATE();   -- '2025-02-15'
SELECT CURTIME();   -- '11:33:13'
SELECT DATE(NOW()); -- '2025-02-15'
SELECT TIME(NOW()); -- '11:32:35'
```

**Key Points:**
- **NOW()**: Returns the current date/time (datetime).
- **CURDATE()/CURTIME()**: Current date or time separately.
- **DATE(expr)** / **TIME(expr)**: Extracts date/time from a datetime.

### 4.2 Extracting Components

```sql
SELECT YEAR(NOW());       -- 2025
SELECT MONTH(NOW());      -- 2
SELECT DAY(NOW());        -- 15
SELECT HOUR(NOW());       -- 11
SELECT MINUTE(NOW());     -- 49
SELECT SECOND(NOW());     -- 3S
ELECT DAYNAME(NOW());     -- 'Saturday'
SELECT MONTHNAME(NOW());  -- 'February'
SELECT EXTRACT(DAY FROM NOW());   -- 15
SELECT EXTRACT(HOUR FROM NOW());  -- 11
```

**Key Points:**
- **YEAR()**, **MONTH()**, **DAY()**, etc., return integer parts of a date.
- **DAYNAME()**, **MONTHNAME()**: Return textual names (e.g., ‘Saturday’, ‘February’).
- **EXTRACT(field FROM source)**: General approach to get the specified date/time component.

### 4.3 Filtering by Date

```sql
-- SELECT ORDERS FROM CURRENT YEARUSE sql_store;
SELECT *FROM orders
WHERE YEAR(order_date) = YEAR(NOW());
```

**Key Points:**
- Common usage: compare date fields to the current year, month, etc.

### 4.4 Formatting Dates/Times

```sql
SELECT DATE_FORMAT(NOW(), '%M %D %Y');  -- 'February 15th 2025'
SELECT DATE_FORMAT(NOW(), '%m %d %y');  -- '02 15 25'
SELECT TIME_FORMAT(NOW(), '%h %i %s');  -- '12 03 11'
SELECT TIME_FORMAT(NOW(), '%h:%i %p');  -- '12:04 PM'
```

**Key Points:**
- **DATE_FORMAT(date, format) / TIME_FORMAT(time, format)**: Format date/time into a string using placeholders like `%M`, `%D`, `%Y`, `%h`, etc.

### 4.5 Calculating Dates and Times

```sql
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR);      -- '2026-02-15 12:06:06'
SELECT DATE_ADD(NOW(), INTERVAL -1 MONTH);    -- '2025-01-15 12:06:48'
SELECT DATE_SUB(NOW(), INTERVAL 1 MONTH);     -- '2025-01-15 12:06:48'
SELECT DATEDIFF(NOW(), '2025-01-01');         -- 45
SELECT DATEDIFF('2024-05-05', '2025-01-01');  -- -241
SELECT TIME_TO_SEC('09:00');                  -- 32400 (seconds since 00:00)
SELECT TIME_TO_SEC('09:00') - TIME_TO_SEC('09:02'); -- -120
```

**Key Points:**
- **DATE_ADD / DATE_SUB(date, INTERVAL expr unit)**: Adds/subtracts date/time intervals (YEAR, MONTH, DAY, etc.).
- **DATEDIFF(date1, date2)**: Returns the difference in days between `date1` and `date2`.
- **TIME_TO_SEC(time)**: Converts a time value to the number of seconds since midnight.

---

## 5. Handling NULLs with IFNULL and COALESCE

### 5.1 IFNULL

Replaces a **NULL** with a specified value:

```sql
SELECT  order_id,
  IFNULL(shipper_id, 'Not assigned') AS Shipper
FROM orders;
```

**Key Points:**
- **IFNULL(expr, alt)**: If `expr` is NULL, returns `alt`. Otherwise returns `expr`.

### 5.2 COALESCE

Returns the **first non-NULL** value in a list:

```sql
SELECT  order_id,
  COALESCE(shipper_id, comments, 'Not assigned') AS Shipper
FROM orders;
```

**Key Points:**
- **COALESCE(val1, val2, …)**: Checks each argument in order, returning the first that is not NULL.

---

## 6. IF Function

The **IF** function in SQL allows **conditional logic** in a query, returning one of two values:

```sql
-- is more concise than UNIONSELECT  order_id,
  IF(
    YEAR(order_date) = 2019,    -- expression    
    'ACTIVE',                   -- if true    
    'ARCHIVED'                  -- if false  
  ) AS categoryFROM orders;
```

Another example:

```sql
SELECT
  product_id,
  name,
  COUNT(*) AS orders,
  IF(
    COUNT(*) > 1,     -- expression    
    'Many times',     -- if true    
    'Once'            -- if false  
  ) AS frequency
FROM products
JOIN order_items USING (product_id)
GROUP BY product_id, name;
```

**Key Points:**
- Useful for dynamically labeling or grouping records in a single query.

---

## 7. CASE Expression

The **CASE** expression is a more powerful version of IF, supporting multiple conditions:

```sql
-- is more concise than UNIONSELECT  order_id,
  CASE    
	  WHEN YEAR(order_date) = 2019 THEN 'ACTIVE'    
	  WHEN YEAR(order_date) = 2018 THEN 'NOT THAT ACTIVE'    
	  WHEN YEAR(order_date) < 2018 THEN 'ARCHIVED'    
	  ELSE 'FUTURE'  
	END AS category
FROM orders;
SELECT
  CONCAT(first_name, ' ', last_name) AS customer,
  points,
  CASE    
	  WHEN points > 3000 THEN 'GOLD'    
	  WHEN points > 2000 THEN 'SILVER'    
	  ELSE 'BRONZE'  
	END AS category
FROM customers;
```

**Key Points:**
- **CASE** handles multiple conditions; the first match applies.
- **ELSE** covers any scenario that doesn’t match preceding conditions.

---

# **Summary of Key Functions**

| **Function Group** | **Examples/Highlights** |
| --- | --- |
| **Numeric** | ROUND, TRUNCATE, CEILING, FLOOR, ABS, RAND |
| **String** | LENGTH, UPPER, LOWER, TRIM, SUBSTRING, LOCATE, REPLACE, CONCAT |
| **Date/Time** | NOW, CURDATE, EXTRACT, DATE_FORMAT, DATE_ADD, DATE_SUB, DATEDIFF, TIME_TO_SEC |
| **Null Handling** | IFNULL(expr, alt), COALESCE(expr1, expr2, …, alt) |
| **Conditional** | IF(condition, value_if_true, value_if_false), CASE WHEN condition THEN value … ELSE other_value END |

**Takeaways:**
1. **Numeric Functions** handle rounding/truncation and absolute value or random number generation.

2. **String Functions** manipulate text, from trimming spaces to concatenating strings.

3. **Date/Time Functions** are essential for extracting parts of dates, formatting them, and calculating intervals.

4. **NULL Handling** with IFNULL and COALESCE ensures you can provide default values when data is missing.

5. **Conditional Logic** (IF, CASE) lets you dynamically classify or transform your query results on the fly.

Each DBMS may have unique or additional functions, but these are common to many SQL dialects. Experiment with these to create sophisticated, readable, and efficient queries.