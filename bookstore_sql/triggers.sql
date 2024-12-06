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
CREATE OR REPLACE TRIGGER after_order_complete
AFTER UPDATE OF status ON orders
FOR EACH ROW
WHEN (NEW.status = 'Completed' AND OLD.status != 'Completed')
EXECUTE FUNCTION update_stock_on_order_complete();

CREATE OR REPLACE FUNCTION enforce_minimum_stock_level()
RETURNS TRIGGER AS
$$
BEGIN
    -- want at least 1 book in stock always
    IF NEW.stock_level <= 1 THEN
        RAISE EXCEPTION 'No more stock for book_id % in store %', 
            NEW.book_id, NEW.restock_threshold;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER trigger_enforce_minimum_stock_level
BEFORE UPDATE ON book_inventory
FOR EACH ROW
EXECUTE FUNCTION enforce_minimum_stock_level();

CREATE OR REPLACE FUNCTION update_stock_after_restock()
RETURNS TRIGGER AS
$$
BEGIN
    UPDATE book_inventory
    SET stock_level = stock_level + NEW.quantity,
        updated_at = NOW()
    WHERE book_id = NEW.book_id AND store_id = NEW.store_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_update_stock_after_restock
AFTER INSERT ON restock_orders
FOR EACH ROW
EXECUTE FUNCTION update_stock_after_restock();

CREATE OR REPLACE FUNCTION log_stock_movement()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO stock_movements (book_id, store_id, movement_type, quantity, movement_date)
    VALUES (NEW.book_id, NEW.store_id, 
            CASE 
                WHEN TG_OP = 'INSERT' THEN 'Restock'::movement_type  
                WHEN TG_OP = 'UPDATE' AND NEW.stock_level < OLD.stock_level THEN 'Sale'::movement_type   
                WHEN TG_OP = 'UPDATE' AND NEW.stock_level > OLD.stock_level THEN 'Restock'::movement_type
                ELSE 'Adjustment'::movement_type
            END,
            ABS(NEW.stock_level - OLD.stock_level), CURRENT_TIMESTAMP);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER trigger_log_stock_movement
AFTER INSERT OR UPDATE ON book_inventory
FOR EACH ROW
EXECUTE FUNCTION log_stock_movement();

CREATE OR REPLACE FUNCTION update_order_status_on_sale_completed()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.status = 'Completed' THEN
        UPDATE orders
        SET status = 'Processing',
            updated_at = NOW()
        WHERE order_id = NEW.order_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER trigger_update_order_status_on_sale_completed
AFTER INSERT OR UPDATE ON sales
FOR EACH ROW
EXECUTE FUNCTION update_order_status_on_sale_completed();

CREATE OR REPLACE FUNCTION notify_low_stock()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.stock_level < NEW.restock_threshold THEN
        INSERT INTO restock_notices (book_id, store_id, stock_level, restock_threshold)
        VALUES (NEW.book_id, NEW.store_id, NEW.stock_level, NEW.restock_threshold);

        RAISE NOTICE 'Stock for book_id % at store_id % is below the restock threshold. Current stock: %, Threshold: %',
            NEW.book_id, NEW.store_id, NEW.stock_level, NEW.restock_threshold;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_notify_low_stock
AFTER UPDATE ON book_inventory
FOR EACH ROW
EXECUTE FUNCTION notify_low_stock();