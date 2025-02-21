# Database Designing

This document covers the complete process of designing a relational database—from data modeling to physical implementation. It includes conceptual, logical, and physical models; normalization; forward/reverse engineering; and practical SQL commands. The goal is to build a model tailored to your **problem domain** (current requirements), not the entire real world. 

**Keep it simple and iterative.**

---

## **1. Data Modeling Process**

Designing a database is an iterative, multi-stage process. The main stages are:

### **1.1 Conceptual Model**

![image.png](Database%20Designing%201a128e7162a580e2ab1be888fe19ff26/image.png)

- **Purpose:** Understand and analyze business requirements.
- **Output:** A visual model (e.g., **ER Diagram** or **UML Diagram**) that represents **entities** and **relationships**.
- **Tools:**
    - Microsoft Visio
    - draw.io
    - Lucidcharts
- **Process:** Iteratively refine your diagram to capture key business concepts without worrying about implementation details.

### **1.2 Logical Model**

![image.png](Database%20Designing%201a128e7162a580e2ab1be888fe19ff26/image%201.png)

- **Purpose:** Translate the conceptual model into a structured design that reflects data organization.
- **Key Steps:**
    - **Entity Splitting:** Ensure each table describes a single entity.
    - **Data Types:** Specify the data type for each attribute.
    - **Relationship Types:** Define relationship cardinality (one-to-one, one-to-many).
- **Note:** At this stage, you focus on *what* data you store and *how* it relates, rather than *how* it is physically stored.

### **1.3 Physical Model**

![image.png](Database%20Designing%201a128e7162a580e2ab1be888fe19ff26/image%202.png)

- **Purpose:** Implement the logical model in a specific DBMS.
- **Details Include:**
    - **Primary Keys (PK):** Uniquely identify each record.
    - **Foreign Keys (FK):** Link related tables.
    - **Constraints:** Such as NOT NULL, UNIQUE.
    - **Triggers & Indexes:** Additional logic and performance tuning.
    - **Storage Engine & Character Sets:** Specifics of your DBMS (e.g., InnoDB, UTF8).
- **Example in MySQL:**
Use the EER Diagram tool via: **File → New Model → Physical Schemas → EER Diagram.**

---

## **2. Normalization**

Normalization reduces redundancy and improves data integrity. Although there are up to 7 normal forms, the first 3 are typically sufficient:

### **2.1 First Normal Form (1NF)**

- **Rule:** Each cell must hold a single value; repeated columns or multi-valued cells are not allowed.
- **Solution:** If a cell needs to store multiple values, create a separate table.

### **2.2 Second Normal Form (2NF)**

- **Rule:** Every table should describe one entity, and every non-key column must depend on the entire primary key.
- **Example:**
If an attribute (like *instructor*) in a courses table does not fully depend on the course, consider creating a separate **instructor** table.

### **2.3 Third Normal Form (3NF)**

- **Rule:** No column should be derived from another column (i.e., remove transitive dependencies).
- **Example:**
In a table with `invoice_total`, `payment_total`, and `balance`, if `balance` is always computed as `invoice_total - payment_total`, then storing it violates 3NF.

**Advice:** In real-world projects, don’t obsess over strict NF. Focus on reducing duplication and redundancy while keeping your model simple and aligned with current requirements.

---

## **3. Composite Keys vs. Surrogate Keys**

- **Composite Key:**
    - Example: In an **enrollments** table, using `(student_id, course_id)` as a composite primary key prevents duplicate enrollments.
    - **Benefit:** Enforces natural uniqueness.
    - **Drawback:** Can complicate foreign key relationships if used as a reference in child tables.
- **Surrogate Key:**
    - Example: Adding a new column `enrollment_id` as the primary key.
    - **Benefit:** Simplifies foreign key references and joins.
    - **Trade-off:** Requires extra care to maintain natural uniqueness in other fields.

---

## **4. Engineering Your Database**

### **4.1 Forward Engineering**

- **Purpose:** Generate SQL code from your EER model.
- **How-To:**
Use your modeling tool’s **Forward Engineer** feature to create the complete database schema.
- **Alternative:** If the database already exists, use **Synchronize Model** to update the diagram.

### **4.2 Reverse Engineering**

- **Purpose:** Generate a visual model from an existing database.
- **How-To:**
Use the reverse engineering tools provided by your DBMS to import table definitions into an ER diagram.

---

## **5. Practical SQL – Commands and Examples**

### **5.1 Creating and Dropping Databases**

```sql
CREATE DATABASE IF NOT EXISTS mydb;
DROP DATABASE IF EXISTS mydb;
```

### **5.2 Creating Tables**

```sql
CREATE TABLE IF NOT EXISTS customers (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(63) NOT NULL,
    last_name VARCHAR(63) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE);
```

### **5.3 Altering Tables**

```sql
ALTER TABLE customers
  ADD last_name CHAR(63) NOT NULL AFTER first_name,
  MODIFY first_name VARCHAR(50) NOT NULL,
  DROP COLUMN middle_name;
```

### **5.4 Foreign Key Constraints**

```sql
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    FOREIGN KEY fk_orders_customers (customer_id)
      REFERENCES customers (client_id)
      ON UPDATE CASCADE      ON DELETE NO ACTION
);
```

```sql
ALTER TABLE orders
  DROP FOREIGN KEY fk_orders_customers,
  ADD FOREIGN KEY fk_orders_customers (customer_id)
      REFERENCES customers (client_id)
      ON UPDATE CASCADE;
```

---

## **6. Character Sets and Storage Engines**

### **6.1 Character Sets**

- **UTF8:**
    - 1 byte for English, 2 bytes for mid-eastern, 3 bytes for Asian characters.
    - Example: `CHAR(10)` in UTF8 can use up to 30 bytes.
- **Latin1:**
    - Can save space if multi-byte support is not needed.

```sql
CREATE DATABASE mydb CHARACTER SET latin1;
ALTER TABLE customers CHARACTER SET latin1;
```

### **6.2 Storage Engines**

- **InnoDB** is the default and recommended engine for its support of transactions, row-level locking, and foreign keys.

```sql
SHOW ENGINE INNODB STATUS;
CREATE TABLE example (
  id INT PRIMARY KEY AUTO_INCREMENT,
  ...
) ENGINE=InnoDB;
```

**Note:** Changing the storage engine may take time and cause downtime during the conversion.

## **7. Additional Best Practices**

1. **Focus on the Problem Domain:**
    - Model your database based on current requirements. Avoid modeling “the universe.”
    - Keep the model simple and evolve it iteratively.
2. **Normalization:**
    - Aim for 1NF, 2NF, and 3NF to reduce redundancy while maintaining performance.
    - Balance normalization with practical needs; sometimes denormalization is acceptable for performance reasons.
3. **Forward and Reverse Engineering:**
    - Use modeling tools to generate and synchronize SQL code.
    - Maintain your model in source control (e.g., Git).
4. **Data Types Selection:**
    - Choose data types that match the actual data range and format to optimize storage and performance.
    - For example, use **TINYINT** for small numbers, **DECIMAL** for financial data, and appropriate character sets for multilingual support.
5. **Composite vs. Surrogate Keys:**
    - Use composite keys (e.g., `(student_id, course_id)`) to naturally enforce uniqueness.
    - Consider surrogate keys (e.g., an auto-increment `enrollment_id`) for simpler foreign key relationships, especially in complex schemas.
6. **Document Your Design:**
    - Keep clear, updated models and comments in your SQL scripts to ensure long-term maintainability.

---

## **8. Summary**

- **Data Modeling:**
    - **Conceptual Model:** Visual representation of entities/relationships.
    - **Logical Model:** Define data types and relationship types.
    - **Physical Model:** Implement with SQL (keys, constraints, triggers, storage settings).
- **Normalization:**
    - Ensure 1NF (atomic cells), 2NF (single entity per table), and 3NF (no transitive dependencies).
- **SQL Commands & Practices:**
    - Use proper syntax for creating, altering, and dropping databases and tables.
    - Define foreign keys, indexes, and constraints to maintain data integrity.
    - Choose appropriate character sets and storage engines.

By following these guidelines and best practices, you can design a robust, efficient, and maintainable database that meets your business needs and adapts to changing requirements.

[original note](https://www.notion.so/original-note-1a028e7162a580b697bbe0504d198532?pvs=21)