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

INSERT INTO book_inventory (book_id, stock_level, restock_threshold)
VALUES
    (1, 15, 5),
    (2, 8, 5),
    (3, 5, 3),
    (4, 10, 6),
    (5, 3, 4),
    (6, 20, 5),
    (7, 12, 5),
    (8, 7, 4),
    (9, 10, 6);

INSERT INTO stock_movements (book_id, movement_type, quantity)
VALUES
    (1, 'Sale', 2),
    (2, 'Sale', 1),
    (3, 'Return', 2),
    (4, 'Sale', 1),
    (5, 'Restock', 5),
    (1, 'Adjustment', -3), 
    (2, 'Restock', 8),
    (3, 'Sale', 3),        
    (4, 'Sale', 2),       
    (5, 'Restock', 4);      

INSERT INTO restock_orders (book_id, quantity)
VALUES
    (1, 10),
    (2, 5), 
    (3, 8); 

INSERT INTO orders(customer_id, total_amount, status, shipping_address) 
VALUES
    (1, 19.98, 'Completed', '789 Reader Lane, Booktown'),
    (2, 19.98, 'Pending', '321 Library Blvd, NovelCity'),
    (1, 9.99, 'Processing', '789 Reader Lane, Booktown'),
    (2, 12.99, 'Pending', '321 Library Blvd, NovelCity'),
    (3, 25.98, 'Completed', '456 Novel Ave, Booktown'),
    (4, 40.00, 'Cancelled', '987 Story Rd, Readsville'),
    (5, 45.98, 'Cancelled', '123 Page St, StoryCity');

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

INSERT INTO reservations (customer_id, book_id, status, expiry_date, pickup_date)
VALUES
    (1, 2, 'Approved', '2024-12-15', '2024-12-10'),
    (2, 2, 'Pending', '2024-12-15', NULL),
    (3, 4, 'Approved', '2024-12-12', '2024-12-08'),
    (4, 3, 'Rejected', '2024-12-20', NULL),
    (5, 7, 'Approved', '2024-12-18', '2024-12-10');