-- Inventory schema setup

-- Create inventory schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS inventory;

-- Create table for book stock management
CREATE TABLE inventory.book_inventory (
    inventory_id SERIAL PRIMARY KEY,
    book_id INT NOT NULL,
    stock_level INT NOT NULL DEFAULT 0,  
    restock_threshold INT NOT NULL DEFAULT 5, 

    CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES core.books(book_id)
);

-- Create table for tracking stock movements 
CREATE TABLE inventory.stock_movements (
    movement_id SERIAL PRIMARY KEY,
    book_id INT NOT NULL,
    movement_type VARCHAR(50) NOT NULL,  
    quantity INT NOT NULL, 
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES core.books(book_id)
);

-- Create table for restocking orders from suppliers
CREATE TABLE restock_orders (
    restock_id SERIAL PRIMARY KEY,
    book_id INT NOT NULL,
    quantity INT NOT NULL, 
    restock_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 

    CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES core.books(book_id)
);

-- Sample data for the inventory
INSERT INTO inventory.book_inventory (book_id, stock_level, restock_threshold)
VALUES 
    (1, 15, 5),
    (2, 8, 5),
    (3, 5, 3),
    (4, 10, 6),
    (5, 3, 4);

INSERT INTO inventory.stock_movements (book_id, movement_type, quantity)
VALUES
    (1, 'sale', 2),
    (2, 'sale', 1),
    (3, 'return', 2),
    (4, 'sale', 1),
    (5, 'restock', 5);

INSERT INTO inventory.restock_orders (book_id, quantity, supplier_name)
VALUES
    (1, 10),
    (2, 5),
    (3, 10),
    (4, 6),
    (5, 8);