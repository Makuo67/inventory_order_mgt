from fastapi import FastAPI
import mysql.connector

app = FastAPI()


def get_db_connection():
    return mysql.connector.connect(
        host="",
        user="",
        password="",
        database=""
    )


@app.get("/top-customers")
def top_customers():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT c.name, SUM(oi.quantity * oi.unit_price) AS total_expenditure
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY c.customer_id
        ORDER BY total_expenditure DESC;
    """)
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return results


@app.get("/monthly-sales")
def monthly_sales():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(oi.quantity * oi.unit_price) AS monthly_sales
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.status IN ('Shipped', 'Delivered')
        GROUP BY month
        ORDER BY month;
    """)
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return results


@app.get("/products-never-ordered")
def unordered_products():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
        p.name 
        FROM products p
        LEFT JOIN order_items oi ON p.product_id = oi.product_id
        WHERE oi.product_id IS NULL;
    """)
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return results


@app.get("/avg-order-country")
def avg_order_country():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
        c.country,
        AVG(order_total) AS avg_order_value
        FROM (
            SELECT 
            o.order_id,
            o.customer_id,
            SUM(oi.quantity * oi.unit_price) AS order_total
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY o.order_id
        ) order_totals
        JOIN customers c ON c.customer_id = order_totals.customer_id
        GROUP BY c.country;
    """)
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return results


@app.get("/frequent-buyers")
def frequent_buyers():

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
        c.name,
        COUNT(o.order_id) AS total_orders
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        GROUP BY c.customer_id
        HAVING total_orders > 1;
    """)
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return results
