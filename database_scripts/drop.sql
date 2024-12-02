-- CAREFUL! 

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

