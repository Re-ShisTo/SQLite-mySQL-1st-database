-- dummy_students_subjects_marks.sql
-- Classroom demo schema + seed data for students, subjects, and marks

PRAGMA foreign_keys = ON;

-- Clean up if re-running
DROP TABLE IF EXISTS marks;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS subjects;

-- 1) Students
CREATE TABLE students (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

-- 2) Subjects
CREATE TABLE subjects (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- 3) Marks (junction table with score)
CREATE TABLE marks (
  student_id INTEGER NOT NULL,
  subject_id INTEGER NOT NULL,
  mark INTEGER NOT NULL CHECK (mark BETWEEN 20 AND 100),
  PRIMARY KEY (student_id, subject_id),
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Insert 10 students
INSERT INTO students (id, name) VALUES
  (1, 'Hasan'),
  (2, 'Arif'),
  (3, 'Ruman'),
  (4, 'Arun'),
  (5, 'Polash'),
  (6, 'Mamun'),
  (7, 'Jahid'),
  (8, 'Pritom'),
  (9, 'Manik'),
  (10, 'Shetu');

-- Insert 4 subjects
INSERT INTO subjects (id, name) VALUES
  (1, 'Mathematics'),
  (2, 'Physics'),
  (3, 'Chemistry'),
  (4, 'English');

-- Insert marks for every student in every subject.
-- Marks are randomly generated between 20 and 100 using SQLite random().
INSERT INTO marks (student_id, subject_id, mark)
SELECT
  st.id AS student_id,
  sb.id AS subject_id,
  (abs(random()) % 81) + 20 AS mark
FROM students st
CROSS JOIN subjects sb;

-- Optional verification
SELECT 'students' AS table_name, COUNT(*) AS rows FROM students
UNION ALL
SELECT 'subjects', COUNT(*) FROM subjects
UNION ALL
SELECT 'marks', COUNT(*) FROM marks;
