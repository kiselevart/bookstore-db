-- Active: 1731980817378@@localhost@5431@bookstore

CREATE DATABASE IF NOT EXISTS bookstore;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(15),
    address TEXT,
    membership_status VARCHAR(50)
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,              
    title VARCHAR(255) NOT NULL,          
    author VARCHAR(255) NOT NULL,          
    isbn VARCHAR(13) UNIQUE NOT NULL,    
    genre VARCHAR(100),                   
    publisher VARCHAR(255),               
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    address TEXT
);

CREATE TABLE supplier_books (
    supplier_id INT REFERENCES suppliers(supplier_id),
    book_id SERIAL REFERENCES books(book_id),
    supply_price DECIMAL(10, 2),
    PRIMARY KEY (supplier_id, book_id)
);

CREATE TABLE book_inventory (
    inventory_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id),
    stock_level INT NOT NULL DEFAULT 0,  
    restock_threshold INT NOT NULL DEFAULT 5
);

-- Create table for tracking stock movements 
CREATE TABLE stock_movements (
    movement_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id),
    movement_type VARCHAR(50) NOT NULL,  
    quantity INT NOT NULL, 
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for restocking orders from suppliers
CREATE TABLE restock_orders (
    restock_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id),
    quantity INT NOT NULL, 
    restock_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE order_status AS ENUM ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status order_status DEFAULT 'Pending'
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    book_id INT REFERENCES books(book_id),
    quantity INT NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL
);

CREATE TYPE reservation_status AS ENUM('Pending', 'Approved', 'Rejected');

CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    book_id INT REFERENCES books(book_id),
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status reservation_status DEFAULT 'Pending'
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Pending'
);

CREATE TABLE sales_analytics (
    analytics_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    total_sales DECIMAL(10, 2) NOT NULL,
    total_transactions INT NOT NULL,
    average_sale_amount DECIMAL(10, 2) NOT NULL,
    sales_by_credit_card DECIMAL(10, 2) NOT NULL,
    sales_by_cash DECIMAL(10, 2) NOT NULL
);

CREATE OR REPLACE PROCEDURE create_analytics(p_days INT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO sales_analytics (date, total_sales, total_transactions, average_sale_amount, sales_by_credit_card, sales_by_cash)
    SELECT CURRENT_DATE, 
           COALESCE(SUM(total_amount), 0), 
           COALESCE(COUNT(sale_id), 0), 
           COALESCE(AVG(total_amount), 0), 
           COALESCE(SUM(CASE WHEN payment_method = 'Credit Card' THEN total_amount ELSE 0 END), 0), 
           COALESCE(SUM(CASE WHEN payment_method = 'Cash' THEN total_amount ELSE 0 END), 0)
    FROM sales
    WHERE sale_date >= CURRENT_DATE - (p_days * INTERVAL '1 day');
END;
$$;

CALL create_analytics(7);

-- DATA INSERTION
INSERT INTO customers (first_name, last_name, email, phone_number, address, membership_status) VALUES
    ('Alice', 'Johnson', 'alice@example.com', '123-456-7890', '789 Reader Lane, Booktown', 'Gold'),
    ('Bob', 'Smith', 'bob@example.com', '987-654-3210', '321 Library Blvd, NovelCity', 'Silver');

INSERT INTO books (title, author, isbn, genre, publisher, price)
VALUES
    ('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Fiction', 'Scribner', 9.99),
    ('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'Classic', 'J.B. Lippincott & Co.', 8.99),
    ('1984', 'George Orwell', '9780451524935', 'Dystopian', 'Secker & Warburg', 12.99),
    ('The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 'Fiction', 'Little, Brown and Company', 5.99),
    ('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 'Fantasy', 'Houghton Mifflin Harcourt', 9.99);

INSERT INTO suppliers (name, contact_info, address) VALUES
    ('BookSupply Co.', 'booksupply@example.com', '123 Paper Street, Booktown'),
    ('GlobalBooks Ltd.', 'globalbooks@example.com', '456 Novel Avenue, ReadCity');

INSERT INTO supplier_books (supplier_id, book_id, supply_price) VALUES
    (1, 1, 7.50),
    (1, 2, 6.00),
    (2, 3, 8.00);

INSERT INTO book_inventory (book_id, stock_level, restock_threshold)
VALUES 
    (1, 15, 5),
    (2, 8, 5),
    (3, 5, 3),
    (4, 10, 6),
    (5, 3, 4);

INSERT INTO stock_movements (book_id, movement_type, quantity)
VALUES
    (1, 'sale', 2),
    (2, 'sale', 1),
    (3, 'return', 2),
    (4, 'sale', 1),
    (5, 'restock', 5);

INSERT INTO restock_orders (book_id, quantity)
VALUES
    (1, 10),
    (2, 5),
    (3, 10),
    (4, 6),
    (5, 8);

INSERT INTO orders(customer_id, total_amount, status) VALUES
    (1, 19.98, 'Delivered'),
    (2, 19.98, 'Shipped'),
    (1, 9.99, 'Processing'),
    (2, 12.99, 'Pending');

INSERT INTO order_items (order_id, book_id, quantity, subtotal) VALUES
    (1, 1, 2, 19.98),
    (2, 1, 1, 9.99),
    (2, 5, 1, 9.99),
    (3, 5, 1, 9.99),
    (4, 3, 1, 12.99);

INSERT INTO reservations(customer_id, book_id) VALUES
    (1, 2),
    (2, 2);

INSERT INTO sales (customer_id, total_amount, payment_method, status)
VALUES
    (1, 25.50, 'Credit Card', 'Completed'),
    (2, 10.00, 'Cash', 'Pending'),
    (1, 15.75, 'Credit Card', 'Completed'),
    (2, 32.00, 'Cash', 'Completed'),
    (1, 40.00, 'Credit Card', 'Cancelled')