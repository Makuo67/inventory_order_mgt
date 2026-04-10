-- Procedure for Handling Orders
CREATE OR REPLACE FUNCTION handle_inventory_on_order() RETURNS TRIGGER AS $$ BEGIN --- Check stock availability
    IF (
        SELECT quantity_remaining
        FROM inventory
        WHERE product_id = NEW.product_id
    ) < New.quantity THEN RAISE EXCEPTION 'Insufficient stock for product %',
    NEW.product_id;
END IF;
-- Deduct inventory
UPDATE inventory
SET quantity_remaining = quantity_remaining - NEW.quantity
WHERE product_id = NEW.product_id;
-- Log change
INSERT INTO inventory_log(product_id, change_amount, change_type)
VALUES (NEW.product_id, - NEW.quantity, 'Order');
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-------------
--- Trigger to handle inventory when order is placed
-------------
CREATE TRIGGER trg_order_item_inventory
AFTER
INSERT ON order_items FOR EACH ROW EXECUTE FUNCTION handle_inventory_on_order();
---------------
--- Procedure for placing orders
---------------
CREATE OR REPLACE FUNCTION place_order(p_customer_id INT, p_items JSONB) RETURNS INT AS $$
DECLARE new_order_id INT;
item JSONB;
BEGIN -- Create order
INSERT INTO orders (customer_id, total_amount, status)
VALUES (p_customer_id, 0, 'Pending')
RETURNING order_id INTO new_order_id;
-- Loop through items
FOR item IN
SELECT *
FROM jsonb_array_elements(p_items) LOOP
INSERT INTO order_items(order_id, product_id, quantity, purchase_price)
VALUES (
        new_order_id,
        (item->>'product_id')::INT,
        (item->>'quantity')::INT,
        (item->>'price')::DECIMAL
    );
-- Trigger fires here automatically
END LOOP;
-- Calculate total
UPDATE orders
SET total_amount = (
        SELECT SUM(quantity * purchase_price)
        FROM order_items
        WHERE order_id = new_order_id
    )
WHERE order_id = new_order_id;
RETURN new_order_id;
END;
$$ LANGUAGE plpgsql;
--------------------------
-- Trigger for restocking
-------------------------
CREATE OR REPLACE FUNCTION log_restock() RETURNS TRIGGER AS $$ BEGIN
INSERT INTO inventory_log(product_id, change_amount, change_type)
VALUES (
        NEW.product_id,
        NEW.quantity_remaining - OLD.quantity_remaining,
        'Restock'
    );
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--------------------------
-- Check stock after update
--------------------------
CREATE OR REPLACE FUNCTION check_low_stock() RETURNS TRIGGER AS $$ BEGIN -- Only act when quantity decreases or changes
    IF NEW.quantity_remaining <= NEW.reorder_level THEN -- Avoid duplicate unresolved alerts
    IF NOT EXISTS (
        SELECT 1
        FROM low_stock_alerts
        WHERE product_id = NEW.product_id
            AND is_resolved = FALSE
    ) THEN
INSERT INTO low_stock_alerts (
        product_id,
        current_quantity,
        reorder_level,
        alert_message
    )
VALUES (
        NEW.product_id,
        NEW.quantity_remaining,
        NEW.reorder_level,
        'Stock below reorder level'
    );
END IF;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-------------------------------------
-- Inventory Trigger for low stock
-----------------------------------
CREATE TRIGGER trg_low_stock_alert
AFTER
UPDATE OF quantity_remaining ON inventory FOR EACH ROW EXECUTE FUNCTION check_low_stock();