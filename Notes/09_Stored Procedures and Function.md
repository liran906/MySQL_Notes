# Stored Procedures and Function

## **1. Introduction**

MySQL allows you to encapsulate SQL logic into:
1. **Stored Procedures (SPs)** – can return multiple values via OUT parameters or affect data in various ways.
2. **Functions** – designed to return exactly one value and typically used in expressions (e.g., SELECT statements).

---

## **2. Creating a Stored Procedure**

MySQL requires modifying the **delimiter** to define multi-statement procedures:

```sql
-- change default delimiter ';' to '$$' (a MySQL convention)
delimiter $$
CREATE PROCEDURE get_clients()
BEGIN  SELECT * FROM clients;  -- the body of the procedure
END$$
-- revert delimiter back to ';'
delimiter ;
-- call the stored procedureCALL get_clients();
```

**Key Points:**

- **`DELIMITER $$`** Tells MySQL to treat `$$` as the end of a block, instead of `;` .
- After the procedure is created, revert to the default `;` .
- **`CALL procedure_name()`** Executes the procedure.

---

## **3. Dropping a Stored Procedure**

If you need to remove or redefine a procedure:

```sql
DROP PROCEDURE IF EXISTS get_clients;  -- no parentheses for dropping
```

---

## **4. Parameters in Stored Procedures**

### 4.1 IN Parameters (Default)

An **IN** parameter passes a value **into** the procedure. Example:

```sql
DROP PROCEDURE IF EXISTS get_clients_by_state;
delimiter $$
CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN  
	SELECT *  
	FROM clients c
  WHERE c.state = state;
END$$
delimiter ;
CALL get_clients_by_state('CA');
```

**Key Points:**
- By default, parameters are **IN** parameters (though not explicitly stated in MySQL).
- You can pass different values each time you call the procedure.

### 4.2 Default Parameter Values

You can simulate default values in MySQL by checking if the input is **NULL**:

```sql
DROP PROCEDURE IF EXISTS get_clients_by_state;
delimiter $$
CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN  
	IF state IS NULL THEN    
		SELECT * 
		FROM clients;  -- no IFNULL()
	ELSE    
		SELECT *    
		FROM clients c
    WHERE c.state = state;
  END IF;
END$$
delimiter ;
CALL get_clients_by_state(NULL);
```

**Alternate Approach:**

```sql
DROP PROCEDURE IF EXISTS get_clients_by_state;
delimiter $$
CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN  
	SELECT *  
	FROM clients c
  WHERE c.state = IFNULL(state, c.state);
END$$
delimiter ;
CALL get_clients_by_state(NULL);
```

---

## **5. Example – Multiple Parameters and Filtering**

```sql
DROP PROCEDURE IF EXISTS get_payment;
delimiter $$
CREATE PROCEDURE get_payment(c_id INT, p_id TINYINT)
BEGIN  
	SELECT    
		client_id,
    c.name,
    amount,
    pm.name AS pay_method,
    date  
  FROM payments p
  JOIN clients c USING (client_id)
  JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
  WHERE client_id = IFNULL(c_id, client_id)
    AND payment_method = IFNULL(p_id, payment_method);
END$$
delimiter ;

CALL get_payment(NULL, NULL);  -- both parameters are NULL
```

---

## **6. Validating Input – SIGNAL**

You can validate parameters within the procedure and **raise errors** using **SIGNAL**:

```sql
DROP PROCEDURE IF EXISTS make_payment;
delimiter $$
CREATE PROCEDURE make_payment(id INT, amount DECIMAL(9,2), p_date DATE)
BEGIN  -- input validation  
	IF amount <= 0 THEN    
		SIGNAL SQLSTATE '22003'      
			SET MESSAGE_TEXT = 'Invalid payment amount';
  END IF;
  UPDATE invoices i
  SET    
	  invoice_total = amount,
    payment_date = p_date
  WHERE invoice_id = id;
END$$
delimiter ;

-- This call will raise an error due to the negative amount
CALL make_payment(2, -50.88, NOW());
```

**Key Points:**
- **SIGNAL**: Throws a custom error with a specified SQLSTATE and message.

---

## **7. OUT Parameters**

A procedure can **return** multiple values via OUT parameters:

```sql
DROP PROCEDURE IF EXISTS get_unpaid_for_client;
delimiter $$
CREATE PROCEDURE get_unpaid_for_client(
  c_id INT,
  OUT unpaid_count INT,     -- OUT parameter  
  OUT unpaid_sum DECIMAL)
BEGIN  
	SELECT COUNT(*), SUM(invoice_total)
  INTO unpaid_count, unpaid_sum    -- store results in OUT parameters  
	FROM invoices i
  WHERE client_id = c_id AND payment_total = 0;
END$$
delimiter ;
```

**How to call it and retrieve OUT values:**

```sql
-- user/session variablesSET @count = 0;
SET @sum = 0;
CALL sql_invoicing.get_unpaid_for_client(3, @count, @sum);
SELECT @count, @sum;
```

---

## **8. Local Variables**

Inside a stored procedure, you can declare **local variables** that exist only during the procedure execution:

```sql
DROP PROCEDURE IF EXISTS get_risk_factor;
delimiter $$
CREATE PROCEDURE get_risk_factor(c_id INT)
BEGIN  
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
  DECLARE invoices_count INT;
  DECLARE invoices_total DECIMAL(9,2);
  
  SELECT COUNT(*), SUM(invoice_total)
  INTO invoices_count, invoices_total
  FROM invoices
  WHERE client_id = IFNULL(c_id, client_id);
  
  SET risk_factor = invoices_total / invoices_count * 5;
  
  SELECT risk_factor;
END$$
delimiter ;

CALL get_risk_factor(NULL);
```

**Key Points:**
- **`DECLARE var_name data_type [DEFAULT default_value]`** to define a local variable.
- **Scope** is limited to the procedure body.

---

## **9. Stored Functions**

A **function** is similar to a procedure, but it **must** return **exactly one value** and is typically used within expressions.

### 9.1 Creating a Function

```sql
DROP FUNCTION IF EXISTS get_risk_factor_from_client;
delimiter $$
CREATE FUNCTION get_risk_factor_from_client(c_id INT)
RETURNS INT  -- look here. difference from SP

-- function attributes
-- DETERMINISTIC     -- 确定性，给定的数据不会返回不同的值。返回不同值的情况：函数基于会变化的数据。这里不需要
-- MODIFIES SQL DATA -- not needed here
READS SQL DATA       -- read data from sql, needed here

BEGIN  
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
  DECLARE invoices_count INT;
  DECLARE invoices_total DECIMAL(9,2);
  
  SELECT COUNT(*), SUM(invoice_total)
  INTO invoices_count, invoices_total
  FROM invoices
  WHERE client_id = c_id;
  
  SET risk_factor = invoices_total / invoices_count * 5;
  
  RETURN IFNULL(risk_factor, 0);
END$$
delimiter ;
```

**Key Points:**
- **`RETURNS data_type`** must specify the data type of the single value the function returns.
- **`DETERMINISTIC`** indicates that given the same input, the function always returns the same result (optional, but recommended if it’s truly deterministic).
- You use **`RETURN`** to output a single value.

### 9.2 Using the Function

Functions can be called in SELECT queries like built-in functions:

```sql
SELECT  
	client_id,
  name,
  get_risk_factor_from_client(client_id) AS risk_factor
FROM clients;
```

**Key Differences From Procedures:**
- A stored function must return exactly one value.
- Typically used for computations within queries, while procedures are called via `CALL` statements.

---

# **Summary of Key Concepts**

1. **Creating a Stored Procedure**:
    - Use **CREATE PROCEDURE**.
    - Change **DELIMITER** to define multi-statement blocks.
    - End each statement with `;` inside the procedure, then close with `END`.
2. **Parameters**:
    - **IN** (default): Passes a value into the procedure.
    - **OUT**: Sends a value back to the caller.
    - **INOUT**: Combines both behaviors (not covered in detail here).
3. **Validation**:
    - Use **IF** statements and **SIGNAL** for custom error messages.
4. **Local Variables**:
    - Declared with **DECLARE** inside the procedure.
5. **Stored Functions**:
    - Must return exactly one value using the **RETURN** statement.
    - Commonly used in expressions inside **SELECT** or **WHERE** clauses.
6. **Example Use Cases**:
    - **SP** for complex multi-step operations, returning multiple outputs or no output.
    - **Function** for computing and returning a single scalar value, like a custom calculation in a query.

Stored procedures and functions add modularity, reusability, and the ability to enforce business logic at the database level. They’re particularly useful in enterprise environments where database-centric operations can improve consistency and performance.