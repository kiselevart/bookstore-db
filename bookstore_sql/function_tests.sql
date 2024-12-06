-- Test for retrieving most popular books
SELECT * FROM get_most_popular_books(10);

-- Test for checking if a book is in stock anywhere
SELECT is_book_in_stock(1);

-- Test for checking stock level in a specific store
UPDATE book_inventory
SET stock_level = 10
WHERE book_id = 1 AND store_id = 1;

-- Should return true
SELECT check_stock_level(1, 1, 1);

-- Should raise an exception
DO $$
BEGIN
	PERFORM check_stock_level(1, 1, 100);
EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE 'Exception raised';
END $$;

-- Test for calculating the subtotal for a book order
SELECT calculate_subtotal(1, 2);

-- Test for getting a customer's pending order
SELECT * FROM get_pending_order(1, 1);

-- Test for creating a new order for a customer
SELECT create_new_order(1, 1, 100);

-- Test for adding a book to an existing order
SELECT * FROM orders WHERE customer_id = 5;
CALL add_book_to_order(5, 1, 2, 1);
SELECT * FROM orders WHERE customer_id = 5;

-- Test for canceling an order
SELECT * FROM orders;
CALL cancel_order(8);
SELECT * FROM orders;

-- Test for selecting books with filters
SELECT * FROM select_books('Fantasy');
SELECT * FROM select_books(NULL, 10, 50);

-- Test for getting inventory by store
SELECT * FROM get_inventory_by_store(1);

-- Test for generating a sales report by store for a specific date range
SELECT * FROM generate_sales_report('2024-01-01'::TIMESTAMP, '2024-12-31'::TIMESTAMP, ARRAY[1]);