-- USE sql_hr;
-- SELECT *
-- FROM employees
-- WHERE salary > (
-- 	SELECT AVG(salary)
--     FROM employees
-- )

-- use sql_invoicing;
-- select *
-- from clients
-- where client_id not in (
-- 	select distinct client_id
--     from invoices
-- )

-- subqueries can be rewritten by using JOIN clause:
-- choosing which one relies on:
-- 1- PERFORMANCE
-- 2- READABILITY

-- select *
-- from invoices
-- left join clients using (client_id)
-- where invoice_id is not null

-- use sql_store;
-- select *
-- from customers
-- where customer_id in (
-- 	select customer_id
--     from orders
--     where order_id in (
-- 		select order_id
--         from order_items
--         where product_id in (
-- 			select product_id
--             from products
--             where name = 'Lettuce - Romaine, Heart'
--         )
--     )
-- )

-- select * 
-- from order_items
-- join orders using (order_id)
-- join customers using (customer_id)
-- where product_id = 3

-- selct invoices greater than all invoices of client 3.

-- use sql_invoicing;
-- select *
-- from invoices
-- where invoice_total > (
-- 	select max(invoice_total)
-- 	from invoices
-- 	where client_id = 3
-- )

-- using ALL keyword

-- use sql_invoicing;
-- select *
-- from invoices
-- where invoice_total > all (
-- 	select invoice_total
-- 	from invoices
-- 	where client_id = 3
-- )

-- select clients whit 2 invoices

-- select *
-- from clients
-- where client_id in (
-- 	select client_id
-- 	from invoices
-- 	group by client_id
-- 	having count(*) >= 2
-- )

-- using ANY

-- select *
-- from clients
-- where client_id = any ( 
-- 	select client_id
-- 	from invoices
-- 	group by client_id
-- 	having count(*) >= 2
-- )

-- correlated subqueries

-- use sql_hr;
-- select *
-- from employees e_outter
-- where salary > (
-- 	select avg(salary)
--     from employees
--     where office_id = e_outter.office_id -- this is correlated with outter table. So it can be slow
-- )

-- exercise

-- use sql_invoicing;
-- select *
-- from invoices i_outter
-- where invoice_total > (
-- 	select avg(invoice_total)
--     from invoices
--     where client_id = i_outter.client_id
-- )

-- EXISTS operator
-- more efficient than IN operator when dealing with large datasets

-- select *
-- from clients c
-- where exists (
-- 	select *
--     from invoices
--     where client_id = c.client_id
-- )

-- use sql_store;
-- select *
-- from products p
-- where not exists (
-- 	select *
--     from order_items
--     where product_id = p.product_id
-- )

-- subqueries in select clause --

-- use sql_invoicing;
-- select
-- 	invoice_id,
-- 	invoice_total,
--     avg(invoice_total) -- this is wrong, because it calculates avg of every group.
-- from invoices
-- group by invoice_id, invoice_total

-- select
-- 	invoice_id,
-- 	invoice_total,
--     (select avg(invoice_total) from invoices) as average,
--     invoice_total - (select average) as difference
-- from invoices
-- group by invoice_id, invoice_total

-- select
-- 	client_id,
--     name,
--     (select sum(invoice_total) from invoices where client_id = c.client_id) as total_sales,
--     (select avg(invoice_total) from invoices) as average,
--     (select total_sales - average) as difference
-- from clients c

-- subqueries in FROM clause
select *
from (
	-- using the above table here:
	select
		client_id,
		name,
		(select sum(invoice_total) from invoices where client_id = c.client_id) as total_sales,
		(select avg(invoice_total) from invoices) as average,
		(select total_sales - average) as difference
	from clients c	
) as summary -- table alias
where total_sales is not null -- can do anything

-- when using subQs in from, keep it simple. or can save the selected table as view