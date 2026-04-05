-- dummy_tables.sql
-- Classroom demo schema + seed data for manual SQL JOIN practice

PRAGMA foreign_keys = ON;

-- Clean up if re-running
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

-- 1) Categories
CREATE TABLE categories (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- 2) Products
CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  price REAL NOT NULL,
  category_id INTEGER NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 3) Orders
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_name TEXT NOT NULL,
  order_date TEXT NOT NULL -- ISO format: YYYY-MM-DD
);

-- 4) Order items (pivot-like transaction table)
CREATE TABLE order_items (
  id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert categories
INSERT INTO categories (id, name) VALUES
  (1, 'Electronics'),
  (2, 'Books'),
  (3, 'Home & Kitchen'),
  (4, 'Stationery');

-- Insert products
INSERT INTO products (id, name, price, category_id) VALUES
  (1, 'Wireless Mouse', 25.00, 1),
  (2, 'Mechanical Keyboard', 70.00, 1),
  (3, 'SQL for Beginners', 18.50, 2),
  (4, 'Node.js in Practice', 28.00, 2),
  (5, 'Coffee Mug', 12.00, 3),
  (6, 'Notebook Set', 9.50, 4),
  (7, 'Desk Lamp', 35.00, 3),
  (8, 'Pen Pack', 5.00, 4);

-- Insert orders
INSERT INTO orders (id, customer_name, order_date) VALUES
  (1, 'Alice', '2026-03-01'),
  (2, 'Bob', '2026-03-02'),
  (3, 'Charlie', '2026-03-03'),
  (4, 'Diana', '2026-03-04');

-- Insert order items
INSERT INTO order_items (id, order_id, product_id, quantity) VALUES
  (1, 1, 1, 2),
  (2, 1, 3, 1),
  (3, 1, 8, 3),

  (4, 2, 2, 1),
  (5, 2, 5, 4),

  (6, 3, 4, 1),
  (7, 3, 6, 2),
  (8, 3, 7, 1),

  (9, 4, 1, 1),
  (10, 4, 2, 1),
  (11, 4, 3, 2),
  (12, 4, 5, 1);

-- Optional checks
SELECT 'categories' AS table_name, COUNT(*) AS rows FROM categories
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;
