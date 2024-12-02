CREATE TYPE sale_status AS ENUM ('Completed', 'Pending', 'Cancelled');

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Pending'
);

INSERT INTO sales (customer_id, total_amount, payment_method, status)
VALUES
    (1, 25.50, 'Credit Card', 'Completed'),
    (2, 10.00, 'Cash', 'Pending'),
    (1, 15.75, 'Credit Card', 'Completed'),
    (2, 32.00, 'Cash', 'Completed'),
    (1, 40.00, 'Credit Card', 'Cancelled');
