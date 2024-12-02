-- CAREFUL! 

-- orders.sql
DROP TABLE IF EXISTS OrderItems CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;

-- inventory.sql
DROP TABLE IF EXISTS book_inventory CASCADE;
DROP TABLE IF EXISTS restock_orders CASCADE;
DROP TABLE IF EXISTS stock_movements CASCADE;

-- suppliers.sql
DROP TABLE IF EXISTS SupplierBooks CASCADE;
DROP TABLE IF EXISTS Suppliers CASCADE;

-- reservations.sql
DROP TABLE IF EXISTS Reservations CASCADE;

-- books.sql
DROP TABLE IF EXISTS Books CASCADE;

-- customers.sql
DROP TABLE IF EXISTS Customers CASCADE;

