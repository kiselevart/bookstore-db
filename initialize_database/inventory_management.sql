-- Active: 1731980817378@@localhost@5431@inventorymanagement

-- initialization
CREATE DATABASE InventoryManagement;

-- creating table with relevant information
CREATE TABLE Books (
    BookID SERIAL PRIMARY KEY,              
    Title VARCHAR(255) NOT NULL,          
    Author VARCHAR(255) NOT NULL,          
    ISBN VARCHAR(13) UNIQUE NOT NULL,    
    Genre VARCHAR(100),                   
    Publisher VARCHAR(255),               
    StockLevel INT NOT NULL DEFAULT 0,     
    RestockThreshold INT NOT NULL DEFAULT 5,
    Price DECIMAL(10, 2) NOT NULL 
);

-- sample data
INSERT INTO Books (Title, Author, ISBN, Genre, Publisher, StockLevel, RestockThreshold)
VALUES
    ('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Fiction', 'Scribner', 10, 5),
    ('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'Classic', 'J.B. Lippincott & Co.', 3, 5),
    ('1984', 'George Orwell', '9780451524935', 'Dystopian', 'Secker & Warburg', 7, 5),
    ('The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 'Fiction', 'Little, Brown and Company', 2, 5),
    ('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 'Fantasy', 'Houghton Mifflin Harcourt', 0, 5);

-- perform functions as needed
SELECT * FROM Books;