-- SELECT 
--     oi.product_id, 
--     quantity, 
--     oi.unit_price, 
--     name, 
--     c.customer_id, 
--     o.order_date, 
--     o.order_id, 
--     first_name, 
--     last_name
-- FROM sql_store.order_items oi
-- JOIN products p ON p.product_id = oi.product_id
-- JOIN orders o ON o.order_id = oi.order_id
-- JOIN customers c ON c.customer_id = o.customer_id

-- USE sql_store;
-- SELECT * 
-- FROM order_items oi
-- JOIN sql_inventory.products p ON p.product_id = oi.product_id

-- USE sql_inventory;
-- SELECT * 
-- FROM sql_store.order_items oi
-- JOIN products p ON p.product_id = oi.product_id

-- USE sql_hr;
-- SELECT e.employee_id, e.first_name, m.first_name AS manager
-- FROM employees e
-- JOIN employees m ON e.reports_to = m.employee_id

-- USE sql_store;
-- SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
-- FROM orders o
-- JOIN customers c ON o.customer_id = c.customer_id
-- JOIN order_statuses os ON o.status = order_status_id

-- USE sql_store;
-- SELECT *
-- FROM order_items oi -- composite primary key
-- JOIN order_item_notes oin
-- 	ON oi.order_id = oin.order_id
--     AND oi.product_id = oin.product_id

-- Impilicit Join Syntax
-- SELECT *
-- FROM customers c, orders o
-- WHERE c.customer_id = o.customer_id

-- SELECT *
-- FROM orders o, shippers s, order_statuses os
-- WHERE o.shipper_id = s.shipper_id AND o.status = os.order_status_id

-- SELECT *
-- FROM orders o
-- JOIN order_statuses os ON o.status = os.order_status_id
-- JOIN shippers s ON o.shipper_id = s.shipper_id

-- Outter Join
-- SELECT c.customer_id, o.order_id, o.order_date, c.first_name, c.last_name
-- FROM customers c -- This is left table.
-- LEFT JOIN orders o ON o.customer_id = c.customer_id
-- -- RIGHT JOIN orders o ON o.customer_id = c.customer_id
-- ORDER BY c.customer_id

-- SELECT order_id, quantity, name
-- FROM order_items oi
-- RIGHT JOIN products p ON p.product_id = oi.product_id

-- Outter Join
-- SELECT o.order_id, o.order_date, first_name, sh.name AS shipper, os.name AS status
-- FROM orders o
-- JOIN customers c ON o.customer_id = c.customer_id 
-- LEFT JOIN shippers sh ON sh.shipper_id = o.shipper_id -- Left join is more prefered, for readibility, expeacially when joining multi tables.
-- LEFT JOIN order_statuses os ON os.order_status_id = o.status

-- USE sql_hr;
-- SELECT e.employee_id, e.first_name, m.first_name AS manager
-- FROM employees e
-- LEFT JOIN employees m ON e.reports_to = m.employee_id

-- SELECT customer_id, c.first_name, sh.name AS shipper
-- Note that this time dont need to identify where customer_id is from
-- FROM customers c
-- JOIN orders o 
-- 	-- ON o.customer_id = c.customer_id 
--     USING (customer_id)
-- LEFT JOIN shippers sh
--     USING(shipper_id)

-- USE sql_invoicing;
-- SELECT date, c.name AS client, amount, pm.name
-- FROM payments p
-- JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
-- JOIN clients c USING (client_id)

-- Natural join. NOT RECOMMENDED
-- SELECT *
-- FROM orders o
-- NATURAL JOIN customers c

-- SELECT c.first_name, p.name AS product
-- FROM customers c
-- CROSS JOIN products p
-- ORDER BY c.first_name

-- SELECT c.first_name, p.name AS product
-- FROM customers c, products p
-- ORDER BY c.first_name

-- UNION, unions of rows from different inqueries
SELECT first_name, points, 'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT first_name, points, 'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT first_name, points, 'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name