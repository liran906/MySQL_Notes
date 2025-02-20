-- -- -- Transactions 事务

-- -- basic concepts
-- a group of sql sentences that represent a group of work

-- ACID properties:
-- atomicity
-- consistancy
-- isolation
-- durability

-- check https://www.bilibili.com/video/BV1UE41147KC/?p=85

-- -- create transaction

use sql_store;

start transaction;

insert into orders (customer_id, order_date, status)
values (1, '2025-01-01', 1);

insert into order_items
values (last_insert_id(), 1, 1, 1);

commit;

-- -- concurrency and locking

-- while one user is under transaction, the table is locked from other users, until the first user commits or rollbacks.

-- check https://www.bilibili.com/video/BV1UE41147KC/?p=88
-- &
-- https://www.bilibili.com/video/BV1UE41147KC/?p=89

show variables like 'transaction_isolation';

set global transaction isolation level serializable;
set session transaction isolation level serializable; -- only for this session. recommended