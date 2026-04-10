---- Email validation
INSERT INTO customers (fullname, email)
VALUES ('Francis Peters', 'invalid-email');
-- Should FAIL (non-existent product)
INSERT INTO inventory (product_id, quantity_remaining)
VALUES (999, 10);
-- Place valid order
SELECT place_order(
        1,
        '[
        {"product_id": 1, "quantity": 2, "price": 1200},
        {"product_id": 3, "quantity": 1, "price": 50}
    ]'::jsonb
    );
--- Force low stock
UPDATE inventory
SET quantity_remaining = 4
WHERE product_id = 1;
---- Check alerts from the low stock
SELECT *
FROM low_stock_alerts;
--- Test duplicate prevention
UPDATE inventory
SET quantity_remaining = 4
WHERE product_id = 7;
-- Check
SELECT *
FROM low_stock_alerts;
--- Insufficient stock
SELECT place_order(
        1,
        '[
        {"product_id": 1, "quantity": 100, "price": 1200}
    ]'::jsonb
    );
---- Zero/Negative Quantity
INSERT INTO order_items (order_id, product_id, quantity, purchase_price)
VALUES (1, 1, 0, 100)