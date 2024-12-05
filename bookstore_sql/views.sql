CREATE OR REPLACE VIEW books_view AS
SELECT 
    b.title,
    b.author,
    b.genre,
    b.price
FROM 
    books b

CREATE OR REPLACE VIEW book_inventory_view AS
SELECT 
    bi.book_id,
    b.title,
    bi.store_id,
    bi.stock_level,
    bi.restock_threshold,
FROM 
    book_inventory bi
JOIN 
    books b ON bi.book_id = b.book_id;
