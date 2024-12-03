CREATE OR REPLACE PROCEDURE add_book_to_order(
    p_customer_id INT,  -- Customer ID initiating the order
    p_book_id INT,      -- Book selected by the customer
    p_quantity INT      -- Quantity of the selected book
)
LANGUAGE plpgsql
AS
$$
DECLARE
    v_stock_level INT;
    v_price DECIMAL(10, 2);
    v_subtotal DECIMAL(10, 2);
    v_order_id INT;
    v_shipping_address TEXT;
BEGIN
    SELECT stock_level INTO v_stock_level
    FROM book_inventory
    WHERE book_id = p_book_id;

    IF v_stock_level < p_quantity THEN
        RAISE EXCEPTION 'Not enough stock for book_id %', p_book_id;
    END IF;

    SELECT address INTO v_shipping_address
    FROM customers
    WHERE customer_id = p_customer_id;

    IF v_shipping_address IS NULL THEN
        RAISE EXCEPTION 'No shipping address found for customer_id %', p_customer_id;
    END IF;

    SELECT price INTO v_price
    FROM books
    WHERE book_id = p_book_id;

    v_subtotal := v_price * p_quantity;

    SELECT order_id INTO v_order_id
    FROM orders
    WHERE customer_id = p_customer_id
    AND status IN ('Pending', 'Processing')
    LIMIT 1;

    IF v_order_id IS NULL THEN
        INSERT INTO orders(customer_id, total_amount, status, shipping_address)
        VALUES (p_customer_id, v_subtotal, 'Pending', v_shipping_address)
        RETURNING order_id INTO v_order_id;
    END IF;

    INSERT INTO order_items (order_id, book_id, quantity, subtotal)
    VALUES (v_order_id, p_book_id, p_quantity, v_subtotal);

    UPDATE book_inventory
    SET stock_level = stock_level - p_quantity,
        updated_at = NOW() 
    WHERE book_id = p_book_id;

    UPDATE orders
    SET total_amount = total_amount + v_subtotal,
        updated_at = NOW()  
    WHERE order_id = v_order_id;

    RAISE NOTICE 'Order ID: %, Total Amount: %', v_order_id, 
        (SELECT total_amount FROM orders WHERE order_id = v_order_id);
END;
$$;

CALL add_book_to_order(1, 1, 2);