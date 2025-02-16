-- COLUM ATTR
-- varchar
-- NN(not null)
-- PK(primary key)
-- AI(auto increment) -- mysql remembers even if record is deleted

-- INSERT INTO customers
-- VALUES (
-- 	DEFAULT,
--     'John',
--     'Smith',
--     '1990-01-01',
--     NULL, -- or DEFAULT, since the default is set to NULL
--     'address',
--     'city',
--     'CA',
--     DEFAULT)

-- INSERT INTO customers (
-- 	last_name, -- can swap position
-- 	first_name,
--     birth_date,
--     address,
--     city,
--     state)
-- VALUES (
--     'Smith',
--     'John',
--     '1990-01-01',
--     'address',
--     'city',
--     'CA')

-- INSERT INTO shippers (name)
-- VALUES ('shipper1'),
-- 	 	  ('shipper2'),
--        ('shipper3')

-- INSERT INTO products (name, quantity_in_stock, unit_price)
-- VALUES ('soap', 200, 0.49),
-- 		  ('toothbrush', 100, 0.39),
--        ('PS5', 30, 39.9)

-- INSERT INTO orders (customer_id, order_date, status)
-- VALUES (1, '2019-01-03', 1);

-- INSERT INTO order_items
-- VALUES 
-- 	-- (1, 1, 1, 2.95),  -- WILL ERROR IF PK IS NOT UNIQUE
--     (LAST_INSERT_ID(), 1, 1, 3.99),
--     (LAST_INSERT_ID(), 3, 1, 1.69)

-- CREATE TABLE order_archieved AS
-- SELECT * FROM orders -- SUBQUERY
-- -- NOTE: THIS DOESN'T COPY PK AND AI.

-- TURNCATE order_archieved HERE.

-- INSERT INTO order_archieved
-- SELECT *
-- FROM orders
-- WHERE order_date < '2019-12-31'

-- USE sql_invoicing;
-- CREATE TABLE invoice_archieved AS
-- SELECT i.invoice_id, i.number, c.name, payment_date
-- FROM invoices i
-- JOIN clients c USING (client_id)
-- WHERE payment_date IS NOT NULL

-- UPDATE invoices
-- SET payment_total = 100, payment_date = '2019-03-01'
-- WHERE invoice_id = 1

-- UPDATE invoices
-- SET payment_total = DEFAULT, payment_date = NULL
-- WHERE invoice_id = 1

-- UPDATE invoices
-- SET 
-- 	payment_total = invoice_total * 0.7,
--     payment_date = due_date
-- WHERE invoice_id = 3

-- UPDATE invoices
-- SET 
-- 	payment_total = invoice_total * 0.7,
--     payment_date = due_date
-- WHERE client_id IN (3,4)

-- USE sql_store;
-- UPDATE customers
-- SET points = points + 50
-- WHERE birth_date < '1990-01-01'

-- SELECT client_id
-- FROM clients
-- WHERE name = 'Myworks'

-- UPDATE invoices
-- SET payment_total = invoice_total * 0.5, payment_date = due_date
-- WHERE client_id = 
-- 	(SELECT client_id
-- 	FROM clients
-- 	WHERE name = 'Myworks')

-- UPDATE invoices
-- SET payment_total = invoice_total * 0.5, payment_date = due_date
-- WHERE client_id IN 
-- -- select the subquery first and run to see if its right!
-- 	(SELECT client_id
-- 	FROM clients
-- 	WHERE state IN ('CA', 'NY'))

-- USE sql_store;
-- UPDATE orders
-- SET comments = 'Gold Customer'
-- WHERE customer_id IN 
-- 	(SELECT customer_id
--     FROM customers
--     WHERE points > 3000)

DELETE FROM invoices
WHERE client_id = (
	SELECT client_id
    FROM clients
    WHERE name = 'Myworks'
    )
