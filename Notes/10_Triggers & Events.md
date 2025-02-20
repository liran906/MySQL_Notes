# Triggers & Event

## **1. What is a Trigger?**

A **trigger** is a special kind of stored procedure that automatically executes in response to specific **database events** (e.g., `INSERT`, `UPDATE`, `DELETE`) on a given table.

### **1.1 Trigger Timing and Event**

- **Timing:** You can define triggers to fire **BEFORE** or **AFTER** a specific SQL command.
- **Event:** The specific operation (e.g., **INSERT**, **DELETE**, **UPDATE**) on which the trigger will execute.

**General Syntax:**

```sql
CREATE TRIGGER trigger_name
    {BEFORE | AFTER} {INSERT | UPDATE | DELETE}
    ON table_name
    FOR EACH ROWBEGIN    -- Trigger bodyEND;
```

---

## **2. Creating Triggers**

### 2.1 Example Triggers

In this lesson, we create two **AFTER** triggers on the `payments` table:

```sql
DROP TRIGGER IF EXISTS payment_after_insert;
DROP TRIGGER IF EXISTS payment_after_delete;

DELIMITER $$

CREATE TRIGGER payment_after_insert
    AFTER INSERT ON payments
    FOR EACH ROWBEGIN    UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
END $$

CREATE TRIGGER payment_after_delete
    AFTER DELETE ON payments
    FOR EACH ROWBEGIN    UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
    INSERT INTO payments_audit
    VALUES (OLD.client_id, OLD.date, OLD.amount, 'delete', NOW());
END $$

DELIMITER ;
```

**Explanation:**
1. **payment_after_insert** trigger updates the `invoices` table, adding the new `payment` amount to the `payment_total`.
2. **payment_after_delete** trigger updates the `invoices` table, subtracting the old (deleted) `amount`.

- It also writes an entry into `payments_audit` to log the deletion activity.

**Key Points:**
- `NEW.column_name`: Refers to the new row values for an `INSERT` or `UPDATE`.
- `OLD.column_name`: Refers to the existing row values for a `DELETE` or `UPDATE`.
- The `AFTER` triggers run after the main SQL operation completes successfully.

---

## **3. Viewing Existing Triggers**

You can query which triggers exist using:

```sql
SHOW TRIGGERS;
SHOW TRIGGERS LIKE 'payments%';  -- filter by re in name pattern
```

---

## **4. What is an Event?**

MySQL **Events** are scheduled tasks (similar to cron jobs in Unix) that run at specified times or intervals. They are part of the **Event Scheduler** subsystem.

### 4.1 Checking Event Scheduler Status

```sql
SHOW VARIABLES LIKE 'event%';
```

- You might see something like `event_scheduler = ON` or `OFF`.
- If it’s **OFF**, you can enable it via:
    
    ```sql
    SET GLOBAL event_scheduler = ON;
    ```
    

---

## **5. Creating and Managing Events**

### 5.1 Basic Syntax

```sql
CREATE EVENT event_name
ON SCHEDULE AT 'YYYY-MM-DD hh:mm:ss'
DO
BEGIN    
	-- Your statements
END;
```

or for recurring tasks:

```sql
CREATE EVENT event_name
ON SCHEDULE EVERY 1 DAY
	STARTS 'YYYY-MM-DD hh:mm:ss'
	ENDS 'YYYY-MM-DD hh:mm:ss'
DO
BEGIN    
	-- Your statements
END;
```

### 5.2 Example Event

In this lesson, we create an event that deletes old rows from `payments_audit` table yearly:

```sql
SHOW VARIABLES LIKE 'event%';
DELIMITER $$
DROP EVENT IF EXISTS yearly_delete_sales_audit_rows$$
CREATE EVENT yearly_delete_sales_audit_rows
ON SCHEDULE
    EVERY 1 YEAR
	    STARTS '2025-01-01'    
	    ENDS '2029-01-01'
DO
BEGIN    
		DELETE FROM payments_audit
		-- WHERE action_date < DATESUB(NOW(), INTERVAL 1 YEAR;) -- either is ok
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$

SHOW EVENTS $$

ALTER EVENT yearly_delete_sales_audit_rows
ON SCHEDULE
    EVERY 1 YEAR
	    STARTS '2025-01-01'    
	    ENDS '2029-01-01'
DO
BEGIN    
		DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$
DELIMITER ;
```

**Key Points:**
- **DROP EVENT IF EXISTS**: Removes the event if it already exists.
- **ON SCHEDULE**: Defines how often and when the event fires.
- **STARTS** and **ENDS**: Optional. Specifies when the repeating schedule begins and when it stops.

### 5.3 Enabling and Disabling Events

```sql
ALTER EVENT yearly_delete_sales_audit_rows DISABLE;
-- some time later...
ALTER EVENT yearly_delete_sales_audit_rows ENABLE;
```

**Key Points:**
- Disabling an event prevents it from running according to its schedule until re-enabled.

---

# **Summary**

- **Triggers** automate data changes in response to `INSERT`, `UPDATE`, or `DELETE` operations.
    - **NEW** and **OLD** references are used in trigger bodies.
    - Useful for maintaining audit logs, keeping related tables in sync, or enforcing complex constraints.
- **Events** allow you to schedule SQL operations at specific times or intervals (similar to a cron job).
    - Must ensure the **Event Scheduler** is enabled.
    - Can be one-time (`AT`) or recurring (`EVERY ... STARTS ... ENDS ...`).

Both **Triggers** and **Events** add automation and logic at the database level, centralizing tasks that might otherwise require separate application code or manual processes.