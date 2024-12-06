-- Test 1: Test the update_stock_on_order_complete trigger
-- Simulate completing an order
UPDATE orders
SET status = 'Completed', updated_at = NOW()
WHERE order_id = 1;

-- Check the book inventory to see if stock levels were updated correctly
SELECT * FROM book_inventory;

-- Test 2: Test the enforce_minimum_stock_level trigger
-- Try to update the stock to a value lower than the minimum
UPDATE book_inventory
SET stock_level = 0
WHERE book_id = 1;

-- Test 3: Test the update_stock_after_restock trigger
-- Simulate a restock order
INSERT INTO restock_orders (book_id, store_id, quantity)
VALUES (1, 1, 10);

-- Check the book inventory to see if stock levels were updated correctly
SELECT * FROM book_inventory;

-- Test 4: Test the log_stock_movement trigger
-- Update book inventory to simulate a sale
UPDATE book_inventory
SET stock_level = 5
WHERE book_id = 1 AND store_id = 1;

-- Check the stock movements table to verify the log
SELECT * FROM stock_movements;

-- Test 5: Test the update_order_status_on_sale_completed trigger
-- Simulate the sale completion
INSERT INTO sales (order_id, total_amount, payment_method, status)
VALUES (1, 100.00, 'Credit Card', 'Completed');

-- Check the orders table to see if order status was updated, should be processing
SELECT * FROM orders;

-- Test 6: Test the notify_low_stock trigger
-- Set stock below the threshold to trigger low stock notification
UPDATE book_inventory
SET stock_level = 0
WHERE book_id = 1 AND store_id = 1;

-- Check the restock notices table for the generated notification
SELECT * FROM restock_notices;
