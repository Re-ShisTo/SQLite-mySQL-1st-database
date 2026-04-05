# SQLite JOIN Examples (Classroom Demo)

Use these commands in your terminal:

```bash
# Create + seed tables
sqlite3 database.sqlite3 < dummy_tables.sql

# Open interactive SQLite shell
sqlite3 database.sqlite3
```

Inside SQLite shell, you can enable headers:

```sql
.headers on
.mode column
```

## 1) INNER JOIN: products with their category

```sql
SELECT
  p.id,
  p.name AS product,
  p.price,
  c.name AS category
FROM products p
INNER JOIN categories c ON c.id = p.category_id
ORDER BY p.id;
```

## 2) INNER JOIN (3 tables): order line details

```sql
SELECT
  o.id AS order_id,
  o.customer_name,
  p.name AS product,
  oi.quantity,
  p.price,
  (oi.quantity * p.price) AS line_total
FROM orders o
INNER JOIN order_items oi ON oi.order_id = o.id
INNER JOIN products p ON p.id = oi.product_id
ORDER BY o.id, oi.id;
```

## 3) LEFT JOIN: list all categories (even if no products)

```sql
SELECT
  c.id,
  c.name AS category,
  p.name AS product
FROM categories c
LEFT JOIN products p ON p.category_id = c.id
ORDER BY c.id, p.id;
```

## 4) LEFT JOIN + GROUP BY: number of products per category

```sql
SELECT
  c.id,
  c.name AS category,
  COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON p.category_id = c.id
GROUP BY c.id, c.name
ORDER BY c.id;
```

## 5) JOIN + GROUP BY: total amount per order

```sql
SELECT
  o.id AS order_id,
  o.customer_name,
  o.order_date,
  SUM(oi.quantity * p.price) AS order_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
GROUP BY o.id, o.customer_name, o.order_date
ORDER BY o.id;
```

## 6) JOIN + WHERE: orders containing a specific product

```sql
SELECT DISTINCT
  o.id AS order_id,
  o.customer_name,
  o.order_date
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
WHERE p.name = 'Wireless Mouse'
ORDER BY o.id;
```

## 7) Self-practice query ideas

```sql
-- A) Find top 3 best-selling products by quantity
-- B) Find customers who ordered from more than 2 categories
-- C) Find average order value
```

## 8) Author-Book many-to-many JOIN examples

First import the author-book dummy file:

```bash
sqlite3 database.sqlite3 < dummy_author_books.sql
```

### 8.1 INNER JOIN: all author-book pairs

```sql
SELECT
  a.id AS author_id,
  a.name AS author,
  b.id AS book_id,
  b.title AS book
FROM author_books ab
JOIN authors a ON a.id = ab.author_id
JOIN books b ON b.id = ab.book_id
ORDER BY a.id, b.id;
```

### 8.2 LEFT JOIN: all authors with books (including authors with zero books)

```sql
SELECT
  a.id,
  a.name AS author,
  b.title AS book
FROM authors a
LEFT JOIN author_books ab ON ab.author_id = a.id
LEFT JOIN books b ON b.id = ab.book_id
ORDER BY a.id, b.id;
```

### 8.3 GROUP BY: number of books per author

```sql
SELECT
  a.id,
  a.name AS author,
  COUNT(ab.book_id) AS total_books
FROM authors a
LEFT JOIN author_books ab ON ab.author_id = a.id
GROUP BY a.id, a.name
ORDER BY total_books DESC, a.id;
```

### 8.4 Search books by author name

```sql
SELECT
  b.id,
  b.title
FROM books b
JOIN author_books ab ON ab.book_id = b.id
JOIN authors a ON a.id = ab.author_id
WHERE a.name = 'Neil Gaiman'
ORDER BY b.id;
```

### 8.5 Search authors by book title

```sql
SELECT
  a.id,
  a.name
FROM authors a
JOIN author_books ab ON ab.author_id = a.id
JOIN books b ON b.id = ab.book_id
WHERE b.title = 'Good Omens'
ORDER BY a.id;
```

### 8.6 GROUP BY: books that have multiple authors (co-authored)

```sql
SELECT
  b.id,
  b.title,
  COUNT(ab.author_id) AS author_count
FROM books b
JOIN author_books ab ON ab.book_id = b.id
GROUP BY b.id, b.title
HAVING COUNT(ab.author_id) > 1
ORDER BY author_count DESC, b.id;
```

## 9) Students-Subjects-Marks JOIN examples

First import the dataset:

```bash
sqlite3 database.sqlite3 < dummy_students_subjects_marks.sql
```

### 9.1 INNER JOIN: all marks with student and subject names

```sql
SELECT
  st.id AS student_id,
  st.name AS student,
  sb.name AS subject,
  m.mark
FROM marks m
JOIN students st ON st.id = m.student_id
JOIN subjects sb ON sb.id = m.subject_id
ORDER BY st.id, sb.id;
```

### 9.2 Average marks per student

```sql
SELECT
  st.id,
  st.name AS student,
  ROUND(AVG(m.mark), 2) AS avg_mark
FROM students st
JOIN marks m ON m.student_id = st.id
GROUP BY st.id, st.name
ORDER BY avg_mark DESC, st.id;
```

### 9.3 Average marks per subject

```sql
SELECT
  sb.id,
  sb.name AS subject,
  ROUND(AVG(m.mark), 2) AS avg_mark
FROM subjects sb
JOIN marks m ON m.subject_id = sb.id
GROUP BY sb.id, sb.name
ORDER BY avg_mark DESC, sb.id;
```

### 9.4 Highest scorer in each subject

```sql
SELECT
  sb.name AS subject,
  st.name AS student,
  m.mark
FROM marks m
JOIN students st ON st.id = m.student_id
JOIN subjects sb ON sb.id = m.subject_id
WHERE (m.subject_id, m.mark) IN (
  SELECT subject_id, MAX(mark)
  FROM marks
  GROUP BY subject_id
)
ORDER BY sb.id, st.id;
```

### 9.5 Students scoring below 40 in any subject

```sql
SELECT
  st.name AS student,
  sb.name AS subject,
  m.mark
FROM marks m
JOIN students st ON st.id = m.student_id
JOIN subjects sb ON sb.id = m.subject_id
WHERE m.mark < 40
ORDER BY m.mark ASC, st.id;
```

### 9.6 Total marks and percentage per student

```sql
SELECT
  st.id,
  st.name AS student,
  SUM(m.mark) AS total_marks,
  ROUND(SUM(m.mark) * 100.0 / (COUNT(*) * 100), 2) AS percentage
FROM students st
JOIN marks m ON m.student_id = st.id
GROUP BY st.id, st.name
ORDER BY percentage DESC, st.id;
```
