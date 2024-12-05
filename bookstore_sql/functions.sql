CREATE OR REPLACE PROCEDURE add_book_to_order(
    p_customer_id INT,   
    p_book_id INT,       
    p_quantity INT,      
    p_store_id INT       
)
LANGUAGE plpgsql
AS
$$
DECLARE
    v_stock_level INT;
    v_price DECIMAL(10, 2);
    v_subtotal DECIMAL(10, 2);
    v_order_id INT;
    v_current_total DECIMAL(10, 2);
    v_shipping_address TEXT;
BEGIN
    SELECT stock_level INTO v_stock_level
    FROM book_inventory
    WHERE book_id = p_book_id 
      AND store_id = p_store_id;

    IF v_stock_level IS NULL THEN
        RAISE EXCEPTION 'Book_id % not available in store %', p_book_id, p_store_id;
    END IF;

    IF v_stock_level < p_quantity THEN
        RAISE EXCEPTION 'Not enough stock for book_id % in store %', p_book_id, p_store_id;
    END IF;

    SELECT price INTO v_price
    FROM books
    WHERE book_id = p_book_id;

    v_subtotal := v_price * p_quantity;

    SELECT order_id, shipping_address INTO v_order_id, v_shipping_address
    FROM orders
    WHERE customer_id = p_customer_id
      AND store_id = p_store_id
      AND status IN ('Pending', 'Processing')
    LIMIT 1;

    IF v_order_id IS NOT NULL THEN
        INSERT INTO order_items (order_id, book_id, quantity, subtotal)
        VALUES (v_order_id, p_book_id, p_quantity, v_subtotal);

        SELECT total_amount INTO v_current_total
        FROM orders
        WHERE order_id = v_order_id;

        UPDATE orders
        SET total_amount = v_current_total + v_subtotal,
            updated_at = NOW()
        WHERE order_id = v_order_id;

        RAISE NOTICE 'Book added to existing Order ID: %, Total Amount: %', v_order_id, 
            (SELECT total_amount FROM orders WHERE order_id = v_order_id);

    ELSE
        SELECT address INTO v_shipping_address
        FROM customers
        WHERE customer_id = p_customer_id;

        IF v_shipping_address IS NULL THEN
            RAISE EXCEPTION 'No shipping address found for customer_id %', p_customer_id;
        END IF;

        INSERT INTO orders(customer_id, store_id, total_amount, status, shipping_address)
        VALUES (p_customer_id, p_store_id, v_subtotal, 'Pending', v_shipping_address)
        RETURNING order_id INTO v_order_id;

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

SELECT * FROM books_view WHERE store_id = 1;

SELECT * FROM book_inventory_view WHERE store_id = 1;
