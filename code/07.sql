-- -- NUMERIC FUNCTIONS

-- SELECT ROUND(5.7345); -- 6
-- SELECT ROUND(5.7345, 1); -- 5.7
-- SELECT ROUND(5.7345, 2); -- 5.73
-- SELECT TRUNCATE(5.7385, 0); -- 5
-- SELECT TRUNCATE(5.7385, 2); -- 5.73
-- SELECT CEILING(5.3); -- 6
-- SELECT CEILING(5); -- 5
-- SELECT FLOOR(5.6); -- 5
-- SELECT FLOOR(5); -- 5
-- SELECT ABS(-5.3); -- 5.3
-- SELECT RAND() -- 0 < FLOAT < 1

-- -- STRING FUNCTIONS

-- SELECT LENGTH('sky'); -- 3
-- SELECT UPPER('sky'); -- 'SKY'
-- SELECT LOWER('Sky'); -- 'sky'
-- SELECT LTRIM('      sky'); -- 'sky'
-- SELECT RTRIM('sky      '); -- 'sky'
-- SELECT TRIM('    sky   '); -- 'sky'
-- SELECT LEFT('kindergarten', 4); -- 'kind'
-- SELECT RIGHT('kindergarten', 5); -- 'arten'
-- SELECT SUBSTRING('kindergarten', 2, 5); -- 'inder' -- starts from 1, not 0
-- SELECT SUBSTRING('kindergarten', 2); -- 'indergarten'
-- SELECT LOCATE('N', 'kindergarten'); -- 3 -- first 'n' or 'N', non-case-sensitive
-- SELECT LOCATE('q', 'kindergarten'); -- 0 -- not -1 but 0
-- SELECT LOCATE('garten', 'kindergarten'); -- 7
-- SELECT REPLACE('kindergarten', 'garten', 'garden'); -- 'kindergarden'
-- SELECT CONCAT('John', 'Smith'); -- 'JohnSmith'
-- SELECT CONCAT('John', ' ', 'Smith'); -- 'John Smith'

-- -- DATE FUNCTIONS

-- SELECT NOW(); -- '2025-02-15 11:31:39'
-- SELECT CURDATE(); -- '2025-02-15'
-- SELECT CURTIME(); -- '11:33:13'
-- SELECT DATE(NOW()); -- '2025-02-15'
-- SELECT TIME(NOW()); -- '11:32:35'
-- SELECT YEAR(NOW()); -- 2025 -- RETURN INT, SAME BELOW
-- SELECT MONTH(NOW()); -- 02
-- SELECT DAY(NOW()); -- 15
-- SELECT HOUR(NOW()); -- 11
-- SELECT MINUTE(NOW()); -- 49
-- SELECT SECOND(NOW()); -- 3
-- SELECT DAYNAME(NOW()); -- 'Saturday'
-- SELECT MONTHNAME(NOW()); -- 'February'
-- SELECT EXTRACT(DAY FROM NOW()); -- 15
-- SELECT EXTRACT(HOUR FROM NOW()); -- 11

-- SELECT ORDERS FROM CURRENT YEAR

-- USE sql_store;
-- SELECT *
-- FROM orders
-- WHERE YEAR(order_date) = YEAR(NOW())

-- -- FORMATTING DATES AND TIME

-- SELECT DATE_FORMAT(NOW(), '%M %D %Y'); -- 'February 15th 2025'
-- SELECT DATE_FORMAT(NOW(), '%m %d %y'); -- '02 15 25'
-- SELECT TIME_FORMAT(NOW(), '%h %i %s'); -- '12 03 11'
-- SELECT TIME_FORMAT(NOW(), '%h:%i %p'); -- '12:04 PM'

-- -- CALCUALTING DATES AND TIME

-- SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR); -- '2026-02-15 12:06:06'
-- SELECT DATE_ADD(NOW(), INTERVAL -1 MONTH); -- '2025-01-15 12:06:48'
-- SELECT DATE_SUB(NOW(), INTERVAL 1 MONTH); -- '2025-01-15 12:06:48'
-- SELECT DATEDIFF(NOW(), '2025-01-01'); -- 45
-- SELECT DATEDIFF('2024-05-05', '2025-01-01'); -- -241
-- SELECT DATEDIFF('2024-05-05 09:00', '2025-01-01 18:00'); -- -241
-- SELECT TIME_TO_SEC('09:00'); -- 32400 -- TIME TO 00:00
-- SELECT TIME_TO_SEC('09:00') - TIME_TO_SEC('09:02'); -- -120

-- -- IFNULL & COALESCE

-- SELECT
-- 	order_id,
--     IFNULL(shipper_id, 'Not assigned') AS Shipper
-- FROM orders;

-- SELECT
-- 	order_id,
--     COALESCE(shipper_id, comments, 'Not assigned') AS Shipper -- return the first not null value in the list
-- FROM orders;

-- SELECT
-- 	CONCAT(first_name, ' ', last_name) AS name, 
--     IFNULL(phone, 'Unknown') AS phone
-- FROM customers;

-- -- IF
-- is more concise than UNION

-- SELECT
-- 	order_id,
--     IF(
-- 		YEAR(order_date) = 2019, -- expression
--         'ACTIVE',                -- if ture
--         'ARCHIVED') AS category. -- if false
-- FROM orders

-- SELECT 
-- 	product_id, 
--     name, 
--     COUNT(*) AS orders, 
--     IF(
-- 		COUNT(*) > 1, -- expression
--         'Many times',  -- if true
--         'Once' -- if false
-- 	) AS frequency
-- FROM products
-- JOIN order_items USING (product_id)
-- GROUP BY product_id, name

-- -- CASE
-- is more concise than UNION

-- SELECT
-- 	order_id,
--     CASE
-- 		WHEN YEAR(order_date) = 2019 THEN 'ACTIVE'
--         WHEN YEAR(order_date) = 2018 THEN 'NOT THAT ACTIVE'
--         WHEN YEAR(order_date) < 2018 THEN 'ARCHIVED'
--         ELSE 'FUTURE'
-- 	END AS category
-- FROM orders

SELECT 
	CONCAT(first_name, ' ', last_name) AS customer, 
    points,
	CASE
		WHEN points > 3000 THEN 'GOLD'
        WHEN points > 2000 THEN 'SILVER'
        ELSE 'BRONZE'
	END AS category
FROM customers