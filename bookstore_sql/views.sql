CREATE OR REPLACE VIEW books_view AS
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.genre,
    b.price,
    bi.stock_level,
    bi.store_id
FROM 
    books b
JOIN 
    book_inventory bi ON b.book_id = bi.book_id;

CREATE OR REPLACE VIEW book_inventory_view AS
SELECT 
    bi.book_id,
    b.title,
    b.author,
    bi.store_id,
    bi.stock_level,
    bi.restock_threshold,
FROM 
    book_inventory bi
JOIN 
    books b ON bi.book_id = b.book_id;
