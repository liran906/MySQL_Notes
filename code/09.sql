-- -- stored procedure

-- -- creating a SP

-- change default delimiter ';' into '$$'. '$$' is by convention. BTW, this is a MySQL thing
-- delimiter $$ 
-- create procedure get_clients()
-- begin
-- 	select * from clients; -- the body of the procedure, every sentence end with ;
-- end$$

-- -- change delimiter back
-- delimiter ; 

-- call get_clients();

-- delimiter $$
-- create procedure get_invoices_with_balance()
-- begin
-- 	select *
--     from invoices
--     where invoice_total - payment_total > 0;
-- end$$
-- delimiter ;
-- call get_invoices_with_balance()

-- -- another way without changing delimiter is to right click on 'stored procedures' and add one.

-- -- drop SP

-- drop procedure if exists get_clients; -- no parentheses

-- -- parameters

-- drop procedure if exists get_clients_by_state;
-- delimiter $$
-- create procedure get_clients_by_state(state CHAR(2))
-- begin
-- 	select *
--     from clients c
--     where c.state = state;
-- end$$
-- delimiter ;
-- call get_clients_by_state('CA');

-- drop procedure if exists get_clients_by_id;
-- delimiter $$
-- create procedure get_clients_by_id(id int)
-- begin
-- 	select *
--     from clients c
--     where c.client_id = id;
-- end$$
-- delimiter ;
-- call get_clients_by_id(1);

-- -- parameters with default values

-- drop procedure if exists get_clients_by_state;
-- delimiter $$
-- create procedure get_clients_by_state(state CHAR(2))
-- begin
-- 	if state is null then
-- 		set state = 'CA'; -- look here
-- 	end if;
-- 	select *
--     from clients c
--     where c.state = state;
-- end$$
-- delimiter ;
-- call get_clients_by_state(NULL);

-- drop procedure if exists get_clients_by_state;
-- delimiter $$
-- create procedure get_clients_by_state(state CHAR(2))
-- begin
-- 	if state is null then
-- 		select * from clients; -- look here for the ;
-- 	else
-- 		select *
-- 		from clients c
-- 		where c.state = state;
--     end if;
-- end$$
-- delimiter ;
-- call get_clients_by_state(NULL);

-- OR code it like this:

-- drop procedure if exists get_clients_by_state;
-- delimiter $$
-- create procedure get_clients_by_state(state CHAR(2))
-- begin
-- 	select *
-- 	from clients c
-- 	where c.state = IFNULL(state, c.state); -- look here
-- end$$
-- delimiter ;
-- call get_clients_by_state(NULL);

-- excersize

-- drop procedure if exists get_payment;
-- delimiter $$
-- create procedure get_payment(c_id INT, p_id TINYINT)
-- begin
-- 	select
-- 		client_id,
--         c.name,
--         amount,
--         pm.name as pay_method,
--         date
-- 	from payments p
--     join clients c using (client_id)
--     join payment_methods pm on p.payment_method = pm.payment_method_id
-- 	where client_id = ifnull(c_id, client_id) and
-- 		payment_method = ifnull(p_id, payment_method);
-- end$$
-- delimiter ;
-- call get_payment(NULL, NULL);

-- --  parameter validation

-- drop procedure if exists make_payment;
-- delimiter $$
-- create procedure make_payment(id int, amount decimal(9,2), p_date date)
-- begin
-- 	-- here is the validation. usually do validation in front\backend, but can also do at db.
-- 	if amount <= 0 then 
-- 		signal sqlstate '22003'
-- 			set message_text = 'Invalid payment amount';
--     end if;
-- 	update invoices i
--     set
-- 		invoice_total = amount,
--         payment_date = p_date
-- 	where invoice_id = id;
-- end$$
-- delimiter ;
-- call make_payment(2, -50.88, now())

-- -- output parameters

-- drop procedure if exists get_unpaid_for_client;
-- delimiter $$
-- create procedure get_unpaid_for_client(
-- 	c_id int,
--     out count int, 			-- OUT keyword, meaning the para is out para
--     out sum decimal
-- )
-- begin
-- 	select count(*), sum(invoice_total)
-- 	into count, sum					-- return the values into corresponding para
-- 	from invoices i
-- 	where client_id = c_id and payment_total = 0;
-- end$$
-- delimiter ;

-- This is when calling the SP from pannle:
-- set @count = 0;  -- prefix with @ means a variable.
-- set @sum = 0;
-- call sql_invoicing.get_unpaid_for_client(3, @count, @sum);
-- select @count, @sum;

-- -- variables

-- user or session variables
-- set @var = 0  -- prefix with @ means a variable.

-- local variables
-- declare var int

-- example
-- drop procedure if exists get_risk_factor;

-- delimiter $$
-- create procedure get_risk_factor(c_id int)
-- begin
-- 	declare risk_factor decimal(9,2) default 0;
--     declare invoices_count int;
--     declare invoices_total decimal(9,2);
--     
--     select count(*), sum(invoice_total)
--     into invoices_count, invoices_total
--     from invoices
--     where client_id = ifnull(c_id, client_id);
--     
--     set risk_factor = invoices_total / invoices_count * 5;
-- 	
--     select risk_factor;
-- end$$

-- delimiter ;

-- call get_risk_factor(null);

-- -- functions

-- -- similar to SP, but can only return ONE value.alter
drop function if exists get_risk_factor_from_client;

delimiter $$
create function get_risk_factor_from_client(c_id int)
returns int          -- look here. difference from SP.
-- attrabutes of the function
-- deterministic     -- 确定性，给定的数据不会返回不同的值。返回不同值的情况：函数基于会变化的数据。这里不需要
reads sql data
-- modifies sql data -- not needed here
begin
	declare risk_factor decimal(9,2) default 0;
    declare invoices_count int;
    declare invoices_total decimal(9,2);
    
    select count(*), sum(invoice_total)
    into invoices_count, invoices_total
    from invoices
    where client_id = c_id;
    
    set risk_factor = invoices_total / invoices_count * 5;
	
    return ifnull(risk_factor, 0);
end$$

delimiter ;

select
	client_id,
    name,
    get_risk_factor_from_client(client_id) as risk_factor
from clients;