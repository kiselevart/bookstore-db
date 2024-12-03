CREATE OR REPLACE FUNCTION update_stock_on_order_complete()

RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.status = 'Completed' AND OLD.status != 'Completed' THEN
        UPDATE book_inventory
        SET stock_level = stock_level - oi.quantity
        FROM order_items oi
        WHERE oi.order_id = NEW.order_id
          AND oi.book_id = book_inventory.book_id;

        UPDATE book_inventory
        SET updated_at = NOW()
        WHERE book_id IN (SELECT book_id FROM order_items WHERE order_id = NEW.order_id);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;