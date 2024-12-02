-- Active: 1731980817378@@localhost@5431@bookstore
-- Create table for book stock management
CREATE TABLE book_inventory (
    inventory_id SERIAL PRIMARY KEY,
    book_id SERIAL REFERENCES books(book_id),
    stock_level INT NOT NULL DEFAULT 0,  
    restock_threshold INT NOT NULL DEFAULT 5
);

-- Create table for tracking stock movements 
CREATE TABLE stock_movements (
    movement_id SERIAL PRIMARY KEY,
    book_id SERIAL REFERENCES books(book_id),
    movement_type VARCHAR(50) NOT NULL,  
    quantity INT NOT NULL, 
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for restocking orders from suppliers
CREATE TABLE restock_orders (
    restock_id SERIAL PRIMARY KEY,
    book_id SERIAL REFERENCES books(book_id),
    quantity INT NOT NULL, 
    restock_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample data for the inventory
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