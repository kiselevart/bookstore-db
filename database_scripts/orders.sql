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