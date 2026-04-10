---  Categories
INSERT INTO categories (category_name)
VALUES ('Electronics'),
    ('Apparel'),
    ('Utensils'),
    ('confectioneries'),
    ('Books');
-- Products
INSERT INTO products (product_name, category_id, price)
VALUES ('Laptop', 1, 1200.00),
    ('Charger', 1, 12.00),
    ('T-Shirt', 2, 20.00),
    ('Kimonos', 2, 35.00),
    ('Spoons', 3, 5.00),
    ('Pots', 3, 15.00),
    ('Chocolate Blue', 4, 30.00),
    ('Database Design Book', 5, 50.00),
    ('Intro to Data Engineering', 5, 25.00);
--- Customers
INSERT INTO customers (fullname, email, phone)
VALUES (
        'Alice Johnson',
        'alice@example.com',
        '123456789'
    ),
    ('Bob Smith', 'bob@example.com', '987654321'),
    (
        'Okeke Makuo',
        'okeke12@gmail.com',
        '23435436456'
    ),
    (
        'Hubert Apana',
        'hubert12@yahoo.com',
        '098876784223'
    ),
    (
        'Marius Okene',
        'okeke.marius@email.com',
        '88956895689452'
    );
---- Address
INSERT INTO addresses (customer_id, address_line1, city, country)
VALUES (6, '123 Main St', 'Kigali', 'Rwanda'),
    (7, '456 High St', 'Kigali', 'Rwanda'),
    (8, 'KK 129 St', 'Lagos', 'Nigeria'),
    (9, 'KG 123 St', 'Kigali', 'Nigeria'),
    (10, '458 High St', 'Kigali', 'Rwanda');
-- Inventory
INSERT INTO inventory (product_id, quantity_remaining, reorder_level)
VALUES (1, 10, 5),
    -- Laptop
    (2, 50, 10),
    -- Charger
    (3, 8, 5),
    --- Tshirt
    (4, 8, 5),
    --- Kimonos
    (5, 8, 5),
    --- SPoons
    (6, 8, 5),
    --- Pots
    (7, 8, 5),
    --- Chocolate Blue
    (8, 8, 5),
    -- Database Design Book
    (9, 10, 10);
-- Intro to Data Engineering