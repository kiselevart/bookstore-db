-- Checks if a book is in stock anywhere (helper)
CREATE OR REPLACE FUNCTION is_book_in_stock(p_book_id INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_level INT;
BEGIN
    SELECT stock_level INTO v_stock_level
    FROM book_inventory
    WHERE book_id = p_book_id
      AND stock_level > 0
    LIMIT 1;

    IF v_stock_level IS NOT NULL THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;

-- Checks if there is enough of a book in stock at a store (helper)
CREATE OR REPLACE FUNCTION check_stock_level(
    p_book_id INT,
    p_store_id INT,
    p_quantity INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_level INT;
BEGIN
    SELECT stock_level INTO v_stock_level
    FROM book_inventory
    WHERE book_id = p_book_id AND store_id = p_store_id;

    IF v_stock_level IS NULL THEN
        RAISE EXCEPTION 'Book_id % not available in store %', p_book_id, p_store_id;
    END IF;

    IF v_stock_level < p_quantity THEN
        RAISE EXCEPTION 'Not enough stock for book_id % in store %', p_book_id, p_store_id;
    END IF;

    RETURN TRUE;
END;
$$;

-- Calculates the subtotal for a book order (helper)
CREATE OR REPLACE FUNCTION calculate_subtotal(
    p_book_id INT,
    p_quantity INT
)
RETURNS DECIMAL(10, 2)
LANGUAGE sql
AS $$
SELECT price * p_quantity
FROM books
WHERE book_id = p_book_id;
$$;

-- Gets customer's pending order (helper)
CREATE OR REPLACE FUNCTION get_pending_order(
    p_customer_id INT,
    p_store_id INT
)
RETURNS TABLE(order_id INT, shipping_address TEXT)
LANGUAGE sql
AS $$
SELECT o.order_id, o.shipping_address
FROM orders o
WHERE o.customer_id = p_customer_id
  AND o.store_id = p_store_id
  AND o.status IN ('Pending', 'Processing')
LIMIT 1;
$$;

-- Creates an order for a customer
CREATE OR REPLACE FUNCTION create_new_order(
    p_customer_id INT,
    p_store_id INT,
    p_total_amount DECIMAL(10, 2)
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_shipping_address TEXT;
    v_order_id INT;
BEGIN
    SELECT address INTO v_shipping_address
    FROM customers
    WHERE customer_id = p_customer_id;

    IF v_shipping_address IS NULL THEN
        RAISE EXCEPTION 'No shipping address found for customer_id %', p_customer_id;
    END IF;

    INSERT INTO orders (customer_id, store_id, total_amount, status, shipping_address)
    VALUES (p_customer_id, p_store_id, p_total_amount, 'Pending', v_shipping_address)
    RETURNING order_id INTO v_order_id;

    RETURN v_order_id;
END;
$$;

CREATE OR REPLACE PROCEDURE add_book_to_order(
    p_customer_id INT,
    p_book_id INT,
    p_quantity INT,
    p_store_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_order_id INT;
    v_subtotal DECIMAL(10, 2);
BEGIN
    PERFORM check_stock_level(p_book_id, p_store_id, p_quantity);

    v_subtotal := calculate_subtotal(p_book_id, p_quantity);

    SELECT order_id INTO v_order_id
    FROM get_pending_order(p_customer_id, p_store_id);

    IF v_order_id IS NOT NULL THEN
        INSERT INTO order_items (order_id, book_id, quantity, subtotal)
        VALUES (v_order_id, p_book_id, p_quantity, v_subtotal);

        UPDATE orders
        SET total_amount = total_amount + v_subtotal,
            updated_at = NOW()
        WHERE order_id = v_order_id;

        RAISE NOTICE 'Book added to existing Order ID: %, Total Amount: %', v_order_id, 
            (SELECT total_amount FROM orders WHERE order_id = v_order_id);
    ELSE
        v_order_id := create_new_order(p_customer_id, p_store_id, v_subtotal);

        INSERT INTO order_items (order_id, book_id, quantity, subtotal)
        VALUES (v_order_id, p_book_id, p_quantity, v_subtotal);

        RAISE NOTICE 'New Order ID: % created for customer %', v_order_id, p_customer_id;
    END IF;
END;
$$;

-- CALL add_book_to_order(1, 1, 1, 2);

CREATE OR REPLACE PROCEDURE cancel_order(
    p_order_id INT
)
LANGUAGE plpgsql
AS
$$
DECLARE
    v_order_status TEXT;
    v_books CURSOR FOR 
        SELECT book_id, quantity 
        FROM order_items 
        WHERE order_id = p_order_id;
BEGIN
    SELECT status INTO v_order_status 
    FROM orders 
    WHERE order_id = p_order_id;

    IF v_order_status = 'Completed' THEN
        RAISE EXCEPTION 'Order has already been completed and cannot be canceled';
    END IF;

    UPDATE orders 
    SET status = 'Cancelled', updated_at = NOW() 
    WHERE order_id = p_order_id;

END;
$$;
-- CALL cancel_order(2);

-- Displays the book catalogue 
CREATE OR REPLACE FUNCTION select_books(p_genre TEXT DEFAULT NULL, p_min_price DECIMAL(10, 2) DEFAULT NULL, p_max_price DECIMAL(10, 2) DEFAULT NULL)
RETURNS TABLE (
    book_name TEXT,
    author TEXT,
    genre TEXT,
    price DECIMAL(10, 2)
)
LANGUAGE sql
AS $$
SELECT 
    title AS book_name,
    author,
    genre,
    price
FROM 
    books
WHERE 
    (p_genre IS NULL OR genre = p_genre)
    AND (p_min_price IS NULL OR price >= p_min_price)
    AND (p_max_price IS NULL OR price <= p_max_price);
$$;

-- SELECT * FROM select_books();

-- Get's the specified customer's order details
CREATE OR REPLACE FUNCTION get_orders_by_customer_with_items(p_customer_id INT)
RETURNS TABLE (
    order_id INT,
    order_date TIMESTAMP,
    total_amount DECIMAL(10, 2),
    status order_status,
    shipping_address TEXT,
    book_title TEXT,
    quantity INT
)
LANGUAGE sql
AS
$$
    SELECT 
        o.order_id,
        o.order_date,
        o.total_amount,
        o.status,
        o.shipping_address,
        b.title AS book_title,
        oi.quantity
    FROM 
        orders o
    JOIN 
        order_items oi ON o.order_id = oi.order_id
    JOIN 
        books b ON oi.book_id = b.book_id
    WHERE 
        o.customer_id = p_customer_id
    ORDER BY 
        o.order_date DESC, o.order_id, b.title;
$$;
-- SELECT * FROM get_orders_by_customer_with_items(1);

-- Gets the inventory of a specified store
CREATE OR REPLACE FUNCTION get_inventory_by_store(p_store_id INT)
RETURNS TABLE (
    book_id INT,
    book_title TEXT,
    author TEXT,
    stock_level INT,
    restock_threshold INT
)
LANGUAGE sql
AS
$$
    SELECT 
        bi.book_id,
        b.title AS book_title,
        b.author,
        bi.stock_level,
        bi.restock_threshold
    FROM 
        book_inventory bi
    JOIN 
        books b ON bi.book_id = b.book_id
    WHERE 
        bi.store_id = p_store_id
    ORDER BY 
        b.title;
$$;
-- SELECT * FROM get_inventory_by_store(1);

-- Finds books in stock by author
CREATE OR REPLACE FUNCTION find_books_by_author_in_stock(p_author TEXT)
RETURNS TABLE (
    book_id INT,
    book_title TEXT,
    author TEXT,
    price DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.book_id,
        b.title AS book_title,
        b.author,
        b.price
    FROM 
        books b
    WHERE 
        b.author = p_author
    AND 
        is_book_in_stock(b.book_id);  
END;
$$;

-- Search for book
CREATE OR REPLACE FUNCTION search_books_similar_to(p_search_query TEXT)
RETURNS TABLE (
    book_id INT,
    book_title TEXT,
    author TEXT,
    genre TEXT,
    price DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.book_id,
        b.title AS book_title,
        b.author,
        b.genre,
        b.price
    FROM 
        books b
    WHERE 
        LOWER(b.title) LIKE LOWER('%' || p_search_query || '%')
    OR
        LOWER(b.author) LIKE LOWER('%' || p_search_query || '%')
    OR
        LOWER(b.genre) LIKE LOWER('%' || p_search_query || '%')
    AND 
        is_book_in_stock(b.book_id);
    ORDER BY 
        b.title;
END;
$$;
