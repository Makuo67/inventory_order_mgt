DROP TABLE IF EXISTS customers,
products,
inventory,
orders,
order_items;
------------------
-- CustomersTable
------------------
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    fullname varchar(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CONSTRAINT chk_customers_email_format CHECK (
        email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ),
    phone VARCHAR(20)
);
------------------
-- Address Table
------------------
CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);
------------------
-- Products Table
------------------
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE
    SET NULL;
);
------------------
-- Categories Table
------------------
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL
);
------------------
-- Inventory Table
------------------
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL UNIQUE,
    quantity_remaining INT NOT NULL CHECK (quantity_remaining >= 0),
    reorder_level INT DEFAULT 10 CHECK (reorder_level >= 0),
    CONSTRAINT fk_inventory_products FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
------------------
-- Inventory Log Table
------------------
CREATE TABLE inventory_log (
    log_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    change_amount INT NOT NULL,
    change_type VARCHAR(20) NOT NULL CHECK (
        change_type IN ('Order', 'Restock', 'Adjustment')
    ),
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT inventory_log_product FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);
------------------
-- Orders Table
------------------
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('Pending', 'Shipped', 'Delivered')),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);
------------------
-- Order Items Table
------------------
CREATE TABLE order_items (
    order_items_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    purchase_price DECIMAL(10, 2) NOT NULL CHECK (purchase_price >= 0),
    CONSTRAINT fk_order_items_product FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_order_items_order FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE
);