CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(15),
    address TEXT,
    membership_status VARCHAR(50)
);

INSERT INTO customers (first_name, last_name, email, phone_number, address, membership_status) VALUES
    ('Alice', 'Johnson', 'alice@example.com', '123-456-7890', '789 Reader Lane, Booktown', 'Gold'),
    ('Bob', 'Smith', 'bob@example.com', '987-654-3210', '321 Library Blvd, NovelCity', 'Silver');