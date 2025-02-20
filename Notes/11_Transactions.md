# Transaction

## 1. What is a Transaction?

A **transaction** is a set of one or more SQL statements that are executed as a single logical unit of work. Either all statements succeed (committed) or they all fail (rolled back). This ensures integrity, especially when multiple changes must succeed or fail together.

### **1.1 ACID Properties**

1. **Atomicity**: All statements in a transaction succeed or fail together (all-or-nothing).
2. **Consistency**: The database moves from one valid state to another, preserving data integrity.
3. **Isolation**: Transactions do not interfere with each other; each sees a consistent view of the data.
4. **Durability**: Once a transaction commits, its changes are permanent, even if the system crashes.

For more background, see [ACID and transaction concepts (video)](https://www.bilibili.com/video/BV1UE41147KC/?p=85).

---

## 2. Basic Transaction Control

Below is an example using the **sql_store** database:

```sql
USE sql_store;
START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2025-01-01', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 1);

COMMIT;
```

1. **START TRANSACTION**: Begins a new transaction.
2. **COMMIT**: Makes the changes permanent.
3. **ROLLBACK** (not shown above) would undo changes if needed.

---

## 3. Concurrency Anomalies

When transactions run concurrently, they can conflict or interfere in subtle ways. Common anomalies include:

1. **Dirty Reads**
    - Occur when one transaction (**T1**) reads uncommitted data from another transaction (**T2**).
    - If **T2** rolls back, **T1** has used data that effectively never existed.
2. **Non-Repeatable Reads**
    - Happen when **T1** rereads a row and finds it changed by another transaction (**T2**) that committed in the interim.
    - The same row read twice in one transaction returns **different** data.
3. **Phantom Reads**
    - Happen when **T1** reruns a **range query** (e.g., `WHERE salary > 5000`) and finds new or fewer rows.
    - Another transaction **T2** might have inserted or deleted rows in that range.
4. **Lost Updates**
    - When two transactions read the same data and then both try to update it. One update overwrites the other, so the first update is “lost.”
    - For example, **T1** sets quantity to 12, **T2** sets quantity to 11 after reading the old value, erasing **T1**’s change.

These issues relate to different isolation levels, which define how visible concurrent changes are.

---

## 4. SQL Isolation Levels

![image.png](Transaction%201a028e7162a58034b39fd8e92cf31724/image.png)

SQL defines four standard isolation levels, each preventing more anomalies but reducing concurrency:

1. **READ UNCOMMITTED**
    - **Dirty Reads**: Allowed
    - **Non-Repeatable Reads**: Allowed
    - **Phantom Reads**: Allowed
    - **Lost Updates**: Can occur without additional locking
    - **Usage**: Rarely recommended due to inconsistency risks.
2. **READ COMMITTED**
    - **Dirty Reads**: **Prevented**
    - **Non-Repeatable Reads**: Possible
    - **Phantom Reads**: Possible
    - **Lost Updates**: Still can happen if not handled by application logic
    - **Usage**: Default in Oracle & SQL Server; typically good concurrency and avoids dirty reads.
3. **REPEATABLE READ**
    - **Dirty Reads**: Prevented
    - **Non-Repeatable Reads**: Prevented
    - **Phantom Reads**: Possible by strict SQL definition, but often prevented in MySQL via Next-Key Locks.
    - **Lost Updates**: Usually prevented if proper row locks are used.
    - **Usage**: MySQL’s default (InnoDB). Usually a good balance for many applications.
4. **SERIALIZABLE**
    - **Dirty Reads**: Prevented
    - **Non-Repeatable Reads**: Prevented
    - **Phantom Reads**: Prevented
    - **Lost Updates**: Prevented
    - **Usage**: Highest isolation. Ensures transactions behave as if they run one by one (serially). Can reduce concurrency significantly.

### 4.1 Checking and Setting Isolation Levels

```sql
SHOW VARIABLES LIKE 'transaction_isolation';
-- orSELECT @@transaction_isolation;
-- Setting isolation level globally or for the sessionSET GLOBAL transaction_isolation_level = 'SERIALIZABLE';
SET SESSION transaction_isolation_level = 'SERIALIZABLE';
```

---

## 5. Concurrency and Locking

While one user is inside a transaction, rows involved may be locked to ensure consistency. The isolation level influences which locks are acquired.

- **Higher isolation** = more locking or versions are managed, reducing concurrency but preventing anomalies.

- **Lower isolation** = fewer locks, better concurrency, but more potential anomalies.

**Lost updates** can often be avoided by using:
- **SELECT … FOR UPDATE** to lock rows when reading them.

- Higher isolation levels.

- Application logic that checks or rechecks data before writing.

For deeper discussion, see:
- [Concurrency & Locking (video 1)](https://www.bilibili.com/video/BV1UE41147KC/?p=88)

- [Concurrency & Locking (video 2)](https://www.bilibili.com/video/BV1UE41147KC/?p=89)

---

# **Summary**

1. **Transactions** group multiple changes into a single atomic operation (ACID properties).
2. **Concurrency** can cause anomalies like **dirty reads**, **non-repeatable reads**, **phantom reads**, and **lost updates**.
3. **Isolation Levels** control which anomalies are prevented:
    - **READ UNCOMMITTED** allows most anomalies.
    - **READ COMMITTED** prevents dirty reads, but allows non-repeatable and phantom reads.
    - **REPEATABLE READ** prevents dirty and non-repeatable reads, might still see phantoms in strict SQL; MySQL typically prevents them.
    - **SERIALIZABLE** is the strictest, preventing all anomalies but can reduce performance under heavy concurrency.
4. **Locking and Application Logic** are key to avoiding lost updates and ensuring consistency.

Balancing **performance** (through concurrency) vs. **consistency** is crucial. Choose the appropriate isolation level and design your transactions accordingly.