DROP TYPE IF EXISTS order_status CASCADE;
CREATE TYPE order_status AS ENUM ('Pending', 'Processing', 'Shipped', 'Completed', 'Cancelled');

DROP TYPE IF EXISTS sale_status CASCADE;
CREATE TYPE sale_status AS ENUM('Pending', 'Processing', 'Completed', 'Cancelled');

DROP TYPE IF EXISTS movement_type CASCADE;
CREATE TYPE movement_type AS ENUM ('Restock', 'Sale', 'Return', 'Adjustment');

DROP TABLE IF EXISTS stores CASCADE;
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    store_location VARCHAR(255),
    contact_number VARCHAR(50),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS customers CASCADE;
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    address TEXT,
    membership_status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS books CASCADE;
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    genre VARCHAR(100),
    publisher VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS book_inventory CASCADE;
CREATE TABLE book_inventory (
    inventory_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id) ON DELETE CASCADE, 
    store_id INT REFERENCES stores(store_id) ON DELETE CASCADE,
    stock_level INT NOT NULL DEFAULT 0,
    restock_threshold INT NOT NULL DEFAULT 5,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS stock_movements CASCADE;
CREATE TABLE stock_movements (
    movement_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id) ON DELETE CASCADE,
    store_id INT REFERENCES stores(store_id) ON DELETE CASCADE,
    movement_type movement_type NOT NULL,
    quantity INT NOT NULL,
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS restock_orders CASCADE;
CREATE TABLE restock_orders (
    restock_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id) ON DELETE CASCADE,
    store_id INT REFERENCES stores(store_id) ON DELETE CASCADE,
    quantity INT NOT NULL,
    restock_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS restock_notices CASCADE;
CREATE TABLE restock_notices (
    notice_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id) ON DELETE CASCADE,
    store_id INT REFERENCES stores(store_id) ON DELETE CASCADE,
    stock_level INT NOT NULL,
    restock_threshold INT NOT NULL,
    notice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    store_id INT REFERENCES stores(store_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status order_status DEFAULT 'Pending', 
    shipping_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS order_items CASCADE;
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    book_id INT REFERENCES books(book_id) ON DELETE CASCADE,
    quantity INT NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS sales CASCADE;
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50), 
    status sale_status DEFAULT 'Pending',  
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO stores (store_name, store_location, contact_number, email)
VALUES
    ('Store A', 'New York, NY', '123-456-7890', 'storea@example.com'),
    ('Store B', 'Los Angeles, CA', '234-567-8901', 'storeb@example.com'),
    ('Store C', 'Chicago, IL', '345-678-9012', 'storec@example.com');

INSERT INTO customers (first_name, last_name, email, address, membership_status) VALUES
    ('Alice', 'Johnson', 'alice@example.com',  '789 Reader Lane, Booktown', 'Gold'),
    ('Bob', 'Smith', 'bob@example.com', '321 Library Blvd, NovelCity', 'Silver'),
    ('Charlie', 'Davis', 'charlie.davis@example.com', '456 Novel Ave, Booktown', 'Bronze'),
    ('David', 'Evans', 'david.evans@example.com', '987 Story Rd, Readsville', 'Gold'),
    ('Emma', 'Wilson', 'emma.wilson@example.com', '123 Page St, StoryCity', 'Platinum');

INSERT INTO books (title, author, isbn, genre, publisher, price)
VALUES
    ('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Fiction', 'Scribner', 9.99),
    ('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'Classic', 'J.B. Lippincott & Co.', 8.99),
    ('1984', 'George Orwell', '9780451524935', 'Dystopian', 'Secker & Warburg', 12.99),
    ('The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 'Fiction', 'Little, Brown and Company', 5.99),
    ('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 'Fantasy', 'Houghton Mifflin Harcourt', 9.99),
    ('Pride and Prejudice', 'Jane Austen', '9781503290563', 'Romance', 'CreateSpace Independent Publishing Platform', 7.99),
    ('Brave New World', 'Aldous Huxley', '9780060850524', 'Dystopian', 'HarperCollins', 11.99),
    ('Moby Dick', 'Herman Melville', '9781503280786', 'Adventure', 'CreateSpace Independent Publishing Platform', 13.99),
    ('War and Peace', 'Leo Tolstoy', '9781853260629', 'Historical', 'Wordsworth Editions', 14.99);

INSERT INTO book_inventory (book_id, store_id, stock_level, restock_threshold)
VALUES
    (1, 1, 15, 5),
    (2, 1, 8, 5),
    (3, 1, 5, 3),
    (4, 1, 10, 6),
    (5, 1, 3, 4),
    (6, 1, 20, 5),
    (7, 1, 12, 5),
    (8, 1, 7, 4),
    (9, 1, 10, 6),
    (1, 2, 10, 5),
    (1, 3, 10, 5);

INSERT INTO stock_movements (book_id, store_id, movement_type, quantity)
VALUES
    (1, 1, 'Sale', 2),
    (2, 1, 'Sale', 1),
    (3, 1, 'Return', 2),
    (4, 1, 'Sale', 1),
    (5, 1, 'Restock', 5),
    (1, 1, 'Adjustment', -3), 
    (2, 1, 'Restock', 8),
    (3, 1, 'Sale', 3),        
    (4, 1, 'Sale', 2),       
    (5, 1, 'Restock', 4),      
    (1, 2, 'Restock', 10),
    (1, 3, 'Restock', 10);

INSERT INTO restock_orders (book_id, quantity)
VALUES
    (1, 10),
    (2, 5), 
    (3, 8); 

INSERT INTO orders(customer_id, store_id, total_amount, status, shipping_address) 
VALUES
    (1, 1, 19.98, 'Completed', '789 Reader Lane, Booktown'),
    (2, 1,19.98, 'Pending', '321 Library Blvd, NovelCity'),
    (1, 1, 9.99, 'Processing', '789 Reader Lane, Booktown'),
    (2, 1, 12.99, 'Pending', '321 Library Blvd, NovelCity'),
    (3, 1, 25.98, 'Completed', '456 Novel Ave, Booktown'),
    (4, 1, 40.00, 'Shipped', '987 Story Rd, Readsville'),
    (5, 1, 45.98, 'Cancelled', '123 Page St, StoryCity');

INSERT INTO order_items (order_id, book_id, quantity, subtotal) 
VALUES
    (1, 1, 2, 19.98),
    (2, 1, 1, 9.99),
    (2, 5, 1, 9.99),
    (3, 5, 1, 9.99),
    (4, 3, 1, 12.99),
    (5, 6, 3, 23.97)

INSERT INTO sales (order_id, total_amount, payment_method, status)
VALUES
    (1, 25.50, 'Credit Card', 'Completed'),
    (2, 10.00, 'Cash', 'Pending'),
    (3, 15.75, 'Credit Card', 'Completed'),
    (4, 32.00, 'Cash', 'Completed'),
    (5, 40.00, 'Credit Card', 'Cancelled'),
    (6, 45.98, 'Credit Card', 'Completed'),
    (7, 50.00, 'Debit Card', 'Completed');