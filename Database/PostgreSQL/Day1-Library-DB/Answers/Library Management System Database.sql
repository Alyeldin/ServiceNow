-- Full Library Management System

-- In a simple library system we have:

-- Authors,Books,Members,Borrow

-- ==========================Relations==================
-- Author → Books
-- One author can write many books(one to many)
-- Author 1 ------< Books

-- Member → Borrow
-- One member can borrow many books
-- Member 1 ------< Borrow

-- Books → Borrow
-- One book can be borrowed many times
-- Books 1 ------< Borrow

-- so member and books many to many

CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

CREATE TABLE members (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE borrow (
    id SERIAL PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

INSERT INTO authors (name)
VALUES
('J.K. Rowling'),
('George Orwell'),
('Dan Brown');

INSERT INTO books (title, author_id)
VALUES
('Harry Potter',1),
('1984',2),
('Animal Farm',2),
('Da Vinci Code',3);

INSERT INTO members (name,email)
VALUES
('Ali','ali@mail.com'),
('Sara','sara@mail.com'),
('Omar','omar@mail.com');

INSERT INTO borrow (member_id,book_id,borrow_date)
VALUES
(1,1,'2026-03-01'),
(2,2,'2026-03-02'),
(3,3,'2026-03-03');



INSERT INTO borrow (member_id,book_id,borrow_date)
VALUES (1,1,'2026-03-01')


-- task – Library Books database:

-- Create a new database
-- Create table books and categories using:
-- SERIAL primary key
-- VARCHAR, TEXT, NUMERIC, INTEGER, DATE, BOOLEAN, TIMESTAMPTZ
-- and one JSONB column

-- Constraints: PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK, DEFAULT

-- ALTER TABLE: add 1–2 new columns

