-- -- views

-- -- create view

-- use sql_invoicing;
-- create view sales_by_client as
-- select
-- 	client_id,
--     name,
--     sum(invoice_total) as total_sales
-- from clients
-- join invoices using (client_id)
-- group by client_id, name;

-- -- use views just like tables
-- select *
-- from sales_by_client
-- join clients using (client_id)
-- where total_sales > 500;

-- create view clients_balance as
-- select client_id, name, sum(invoice_total - payment_total) as balance
-- from clients
-- join invoices using (client_id)
-- group by client_id, name;

-- -- altering and deleting views

-- drop view sales_by_client; 

-- -- SAVE THE VIEW CODE IN SQL FILE AND PUT UNDER SORCE CONTROL, EG. GIT
create or replace view sales_by_client as
select
	client_id,
    name,
    sum(invoice_total) as total_sales
from clients
join invoices using (client_id)
group by client_id, name;

-- -- update views

-- can update view, if view does not have the following:
-- DISTINCT
-- Aggregate Functions (SUM MAX MIN AVG COUNT ect.)
-- GROUP BU / HAVING
-- UNION 
-- example:

-- create or replace view invoices_with_balance as
-- select 
-- 	invoice_id,
--     number,
--     client_id,
--     invoice_total,
--     payment_total,
--     invoice_total - payment_total as balance,
--     invoice_date,
--     due_date,
--     payment_date
-- from invoices
-- where invoice_total - payment_total > 0;

-- delete from invoices_with_balance
-- where invoice_id = 1; 

-- update invoices_with_balance
-- set due_date = date_add(due_date, interval 2 day)
-- where invoice_id = 2;

-- -- WITH OPTION CHECK clause

-- -- invoice_id = 2 will disappear after:
-- update invoices_with_balance
-- set payment_total = invoice_total
-- where invoice_id = 2;

-- -- prevent this by using WITH CHECK OPTION clause:
-- create or replace view invoices_with_balance as
-- select 
-- 	invoice_id,
--     number,
--     client_id,
--     invoice_total,
--     payment_total,
--     invoice_total - payment_total as balance,
--     invoice_date,
--     due_date,
--     payment_date
-- from invoices
-- where invoice_total - payment_total > 0
-- with check option;

-- -- now this will raise error:
-- update invoices_with_balance
-- set payment_total = invoice_total
-- where invoice_id = 2;

-- -- other benefits of views

-- https://www.bilibili.com/video/BV1UE41147KC?buvid=YA4006A1DF4DD26D4FD49C985B0E33E406ED&is_story_h5=false&mid=vGea7dc16Pk4ao2dSEcjnQ%3D%3D&plat_id=344&share_from=ugc&share_medium=iphone&share_plat=ios&share_session_id=70FBF186-D725-43C5-849F-9B0CF74B8D69&share_source=WEIXIN&share_tag=s_i&spmid=playlist.playlist-video-detail.0.0&timestamp=1736934612&unique_k=hqjviN1&up_id=685986&vd_source=8ff8844110d9667133af39a1643e873b&spm_id_from=333.788.videopod.episodes&p=67
