-- -- triggers

drop trigger if exists payment_after_insert;
drop trigger if exists payment_after_delete;

delimiter $$

create trigger payment_after_insert
	after insert on payments
    for each row
begin
	update invoices
    set payment_total = payment_total + new.amount
    where invoice_id = new.invoice_id;
end $$

create trigger payment_after_delete
	after delete on payments
    for each row
begin
	update invoices
    set payment_total = payment_total - old.amount
    where invoice_id = old.invoice_id;
    
    insert into payments_audit
    values (old.client_id, old.date, old.amount, 'delete', now());
end $$

delimiter ;

show triggers;

show triggers like 'payments%' -- re

delimiter $$


-- -- event

show variables like 'event%';

delimiter $$
drop event if exists yearly_delete_sales_audit_rows$$

create event yearly_delete_sales_audit_rows
on schedule
	-- at '2019-01-01' -- only once
    every 1 year starts '2025-01-01' ends '2029-01-01'
do begin
	delete from payments_audit
    -- where action_date < datesub(now(), interval 1 year) -- either is ok
    where action_date < now() - interval 1 year;
end $$

show events $$

alter event yearly_delete_sales_audit_rows
on schedule
	-- at '2019-01-01' -- only once
    every 1 year starts '2025-01-01' ends '2029-01-01'
do begin
	delete from payments_audit
    -- where action_date < datesub(now(), interval 1 year) -- either is ok
    where action_date < now() - interval 1 year;
end $$

delimiter ;

alter event yearly_delete_sales_audit_rows disable;
-- some time later...
alter event yearly_delete_sales_audit_rows enable;