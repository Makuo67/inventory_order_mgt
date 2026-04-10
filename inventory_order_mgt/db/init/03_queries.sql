-- Order Summaries
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT o.order_id,
    o.customer_id,
    o.order_date,
    o.total_amount,
    COUNT(oi.order_items_id) AS number_of_items
FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id,
    o.customer_id,
    o.order_date,
    o.total_amount;
SELECT *
FROM customer_order_summary
WHERE customer_id = 1;
--- Low stock
CREATE OR REPLACE VIEW low_stock_report AS
SELECT p.product_id,
    p.product_name,
    i.quantity_remaining,
    i.reorder_level,
    (i.reorder_level - i.quantity_remaining) AS shortage
FROM inventory i
    JOIN products p ON i.product_id = p.product_id
WHERE i.quantity_remaining <= i.reorder_level;
SELECT *
FROM low_stock_report;
--- Customer spending
CREATE OR REPLACE VIEW customer_spending AS
SELECT c.customer_id,
    c.fullname,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id,
    c.fullname;
---- Spending Tiers
CREATE OR REPLACE VIEW customer_tiers AS
SELECT *,
    CASE
        WHEN total_spent >= 5000 THEN 'Gold'
        WHEN total_spent >= 1000 THEN 'Silver'
        ELSE 'Bronze'
    END AS tier
FROM customer_spending;
SELECT *
FROM customer_tiers;