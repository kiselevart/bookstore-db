CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    address TEXT
);

-- Relationship: SupplierBooks
CREATE TABLE supplier_books (
    supplier_id INT REFERENCES suppliers(supplier_id),
    book_id SERIAL REFERENCES books(book_id),
    supply_price DECIMAL(10, 2),
    PRIMARY KEY (supplier_id, book_id)
);

-- Sample Data: Suppliers
INSERT INTO suppliers (name, contact_info, address) VALUES
    ('BookSupply Co.', 'booksupply@example.com', '123 Paper Street, Booktown'),
    ('GlobalBooks Ltd.', 'globalbooks@example.com', '456 Novel Avenue, ReadCity');

-- Sample Data: SupplierBooks
INSERT INTO supplier_books (supplier_id, book_id, supply_price) VALUES
    (1, 1, 7.50),
    (1, 2, 6.00),
    (2, 3, 8.00);