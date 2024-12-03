CREATE OR REPLACE PROCEDURE create_analytics(p_days INT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO sales_analytics (date, total_sales, total_transactions, average_sale_amount, sales_by_credit_card, sales_by_cash)
    SELECT CURRENT_DATE,
           COALESCE(SUM(total_amount), 0),
           COALESCE(COUNT(sale_id), 0),
           COALESCE(AVG(total_amount), 0),
           COALESCE(SUM(CASE WHEN payment_method = 'Credit Card' THEN total_amount ELSE 0 END), 0),
           COALESCE(SUM(CASE WHEN payment_method = 'Cash' THEN total_amount ELSE 0 END), 0)
    FROM sales
    WHERE sale_date >= CURRENT_DATE - (p_days * INTERVAL '1 day');
END;
$$;