CREATE TRIGGER after_order_complete
AFTER UPDATE OF status ON orders
FOR EACH ROW
WHEN (NEW.status = 'Completed' AND OLD.status != 'Completed')
EXECUTE FUNCTION update_stock_on_order_complete();