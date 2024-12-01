-- Active: 1731980817378@@localhost@5431@bookstore 

-- creating books table
CREATE TABLE books (
    book_id SERIAL,              
    title VARCHAR(255) NOT NULL,          
    author VARCHAR(255) NOT NULL,          
    isbn VARCHAR(13) UNIQUE NOT NULL,    
    genre VARCHAR(100),                   
    publisher VARCHAR(255),               
    price DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY book_id
);

-- sample data for books table
INSERT INTO books (title, author, isbn, genre, publisher, price)
VALUES
    ('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Fiction', 'Scribner', 9.99),
    ('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'Classic', 'J.B. Lippincott & Co.', 8.99),
    ('1984', 'George Orwell', '9780451524935', 'Dystopian', 'Secker & Warburg', 12.99),
    ('The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 'Fiction', 'Little, Brown and Company', 5.99),
    ('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 'Fantasy', 'Houghton Mifflin Harcourt', 9.99);

-- perform functions as needed
SELECT * FROM books;