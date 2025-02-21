CREATE DATABASE IF NOT EXISTS name;

DROP DATABASE IF EXISTS name;

CREATE TABLE IF NOT EXISTS name
(
	column_name1 INT PRIMARY KEY AUTO_INCREMENT,
	column_name2 VARCHAR(63) NOT NULL UNIQUE,
	column_name3 BOOLEAN NOT NULL DEFAULT TRUE,
	…
);

ALTER TABLE name
	ADD last_name CHAR(63) NOT NULL AFTER first_name,
	MODIFY column_name CHAR(10) NOT NULL,
	DROP column_name;

CREATE TABLE IF NOT EXISTS order
(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_id IN NOT NULL,
	FOREIGN KEY fk_orders_customers (customer_id)
		REFERENCES customers (customer_id)
		ON UPDATE CASCADE
		ON DELETE NO ACTION
);

ALTER TABLE orders
	ADD PRIMARY KEY (order_id),
	DROP PRIMARY KEY,
	DROP FOREIGN KEY fk_orders_customers,
	ADD FOREIGN KEY fk_orders_customers (customer_id)
		REFERENCES customers (customer_id)
		ON UPDATE CASCADE;

---

SHOW CHARSET;

UTF8 -> 1 Byte for english char, 2 Bytes for mid-eastern char, 3 Bytes for asian char
UTF8 maxlen = 3
so CHAR(10) -> 30 Bytes
can change charset to save space

CREATE [ALTER] DATABASE db_name
	CHARACTER SET latin1;

CREATE TABLE table1
(
	...
)
CHARACTER SET latin1;

ALTER TABLE table1
CHARACTER SET latin1;

CREATE TABLE table1
(
	...
	column_name CHARACTER SET latin1VARCHAR(63) NOT NULL UNIQUE,
	...
)

---
storage engine

SHOW ENGINE;

-- InnoDB <- usually used

-- if not innoDB, can change by:

ENGINE = InnoDB -- can take a long time, and DB cannot be accessed duringly.