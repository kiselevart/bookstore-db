CREATE TYPE reservation_status AS ENUM('Pending', 'Approved', 'Rejected');
DROP TYPE reservation_status;

CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    book_id INT REFERENCES books(book_id),
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status reservation_status DEFAULT 'Pending'
);

INSERT INTO reservations(customer_id, book_id) VALUES
    (1, 2),
    (2, 2);