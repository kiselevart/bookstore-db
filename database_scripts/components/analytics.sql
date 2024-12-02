CREATE TABLE sales_analytics (
    analytics_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    total_sales DECIMAL(10, 2) NOT NULL,
    total_transactions INT NOT NULL,
    average_sale_amount DECIMAL(10, 2) NOT NULL,
    sales_by_credit_card DECIMAL(10, 2) NOT NULL,
    sales_by_cash DECIMAL(10, 2) NOT NULL
);

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

CALL create_analytics(7);