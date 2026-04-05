-- dummy_author_books.sql
-- Quick import file for many-to-many demo: authors <-> books

PRAGMA foreign_keys = ON;

-- Clean up if re-running
DROP TABLE IF EXISTS author_books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS books;

-- 1) Authors
CREATE TABLE authors (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- 2) Books
CREATE TABLE books (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL UNIQUE
);

-- 3) Pivot table for many-to-many relationship
CREATE TABLE author_books (
  author_id INTEGER NOT NULL,
  book_id INTEGER NOT NULL,
  PRIMARY KEY (author_id, book_id),
  FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- Insert authors
INSERT INTO authors (id, name) VALUES
  (1, 'J.K. Rowling'),
  (2, 'Neil Gaiman'),
  (3, 'Terry Pratchett'),
  (4, 'Brandon Sanderson');

-- Insert books
INSERT INTO books (id, title) VALUES
  (1, 'Harry Potter and the Sorcerer''s Stone'),
  (2, 'Good Omens'),
  (3, 'American Gods'),
  (4, 'The Way of Kings'),
  (5, 'The Silent Harbor'),
  (6, 'Midnight Cartographer'),
  (7, 'The Glass Orchard'),
  (8, 'Clockwork Rain'),
  (9, 'Ashes of the North'),
  (10, 'The Last Ember Map'),
  (11, 'Velvet Labyrinth'),
  (12, 'River of Forgotten Stars'),
  (13, 'The Copper Lighthouse'),
  (14, 'Echoes Under Snow');

-- Insert pivot relationships (book can have multiple authors)
INSERT INTO author_books (author_id, book_id) VALUES
  (1, 1),
  (2, 2),
  (3, 2),
  (2, 3),
  (4, 4),

  (1, 5), (3, 5), (4, 5),
  (3, 6), (4, 6),
  (1, 7),
  (4, 8),
  (1, 9), (3, 9),
  (2, 10), (4, 10),
  (1, 11), (2, 11), (4, 11),
  (1, 12),
  (3, 13),
  (2, 14), (3, 14);

-- Optional quick verification
SELECT 'authors' AS table_name, COUNT(*) AS rows FROM authors
UNION ALL
SELECT 'books', COUNT(*) FROM books
UNION ALL
SELECT 'author_books', COUNT(*) FROM author_books;
