-- Active: 1731980817378@@localhost@5431@postgres
-- CAREFUL! 
REVOKE CONNECT ON DATABASE bookstore FROM PUBLIC;
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'bookstore'
  AND pid <> pg_backend_pid();
DROP DATABASE bookstore;

-- orders.sql
DROP TYPE order_status;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;

-- inventory.sql
DROP TABLE IF EXISTS book_inventory CASCADE;
DROP TABLE IF EXISTS restock_orders CASCADE;
DROP TABLE IF EXISTS stock_movements CASCADE;

-- suppliers.sql
DROP TABLE IF EXISTS supplier_books CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;

-- reservations.sql
DROP TYPE reservation_status;
DROP TABLE IF EXISTS reservations CASCADE;

-- books.sql
DROP TABLE IF EXISTS books CASCADE;

-- customers.sql
DROP TABLE IF EXISTS customers CASCADE;

