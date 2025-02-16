-- select
-- 	max(invoice_total) as max_invoice,
--     min(invoice_total) as min_invoice,
--     avg(invoice_total) as avg_invoice,
--     sum(invoice_total) as sum_of_invoices,
--     count(*) as total_records,
--     count(distinct client_id) as num_of_clients
-- from invoices
-- where invoice_date < '2019-06-30'

-- select
-- 	'First half of 2019' as date_range,
-- 	sum(invoice_total) as total_sales,
--     sum(payment_total) as total_payments,
--     sum(invoice_total) - sum(payment_total) as expected
-- from invoices
-- where invoice_date <= '2019-06-30'
-- union
-- select
-- 	'Second half of 2019' as date_range,
-- 	sum(invoice_total) as total_sales,
--     sum(payment_total) as total_payments,
--     sum(invoice_total) - sum(payment_total) as expected
-- from invoices
-- where invoice_date > '2019-06-30'
-- union
-- select
-- 	'Total' as date_range,
-- 	sum(invoice_total) as total_sales,
--     sum(payment_total) as total_payments,
--     sum(invoice_total) - sum(payment_total) as expected
-- from invoices

-- select 
-- 	client_id,
-- 	sum(invoice_total) as total_sales
-- from invoices
-- where invoice_date > '2019-06-30'
-- group by client_id
-- order by total_sales desc payments

-- select 
-- 	date,
--     pm.name as method,
-- 	sum(amount) as total_amount
-- from payments p
-- join payment_methods pm on p.payment_method = pm.payment_method_id
-- group by date, payment_method
-- order by date

-- select 
-- 	client_id,
-- 	sum(invoice_total) as total_sales
-- from invoices
-- -- where total_sales > 500 -- CANNOT DO THIS BECAUSE NOT GROUPED YET, use where to filter BEFORE is grouped
-- group by client_id
-- having total_sales > 500 -- use having AFTER data is grouped

-- select 
-- 	client_id,
-- 	sum(invoice_total) as total_sales,
--     count(*) as num_of_invoices
-- from invoices
-- group by client_id
-- having total_sales > 500 and num_of_invoices > 5 -- can only use coloums from select clause

-- select
-- 	customer_id,
-- 	first_name,
--     last_name,
--     state,
-- 	sum(quantity * unit_price) as total_price
-- from customers c
-- join orders o using (customer_id)
-- join order_items oi using (order_id)
-- where state in ('VA')
-- group by -- usually group by same collums in select
-- 	customer_id,
-- 	first_name,
--     last_name,
--     state
-- having total_price > 100

-- select 
--     city,
--     state,
-- 	sum(invoice_total) as total_sales
-- from invoices i
-- join clients c using (client_id)
-- group by city, state with rollup -- rollup is to get the total amount, ONLY IN MYSQL.

select 
	pm.name as method_of_payment,
    sum(amount) as total
from payments p
join payment_methods pm on p.payment_method = pm.payment_method_id
group by method_of_payment with rollup