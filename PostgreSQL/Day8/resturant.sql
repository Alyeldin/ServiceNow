CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity DECIMAL(10, 3) NOT NULL DEFAULT 0.000,
    unit VARCHAR(20) NOT NULL
);

CREATE TABLE menu_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE recipe (
    menu_item_id INTEGER NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
    ingredient_id INTEGER NOT NULL REFERENCES ingredients(id) ON DELETE RESTRICT,
    quantity DECIMAL(10, 3) NOT NULL CHECK (quantity > 0),
    unit VARCHAR(20) NOT NULL,
    PRIMARY KEY (menu_item_id, ingredient_id)
);

CREATE TABLE res_tables (
    id SERIAL PRIMARY KEY,
    number INTEGER NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'reserved', 'occupied'))
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    table_id INTEGER NOT NULL REFERENCES res_tables(id),
    status VARCHAR(20) NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'completed'))
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id INTEGER NOT NULL REFERENCES menu_items(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    UNIQUE (order_id, menu_item_id)
);

INSERT INTO ingredients (name, quantity, unit) VALUES
('Flour', 100.000, 'kg'),
('Tomato Sauce', 50.000, 'liter'),
('Mozzarella', 80.000, 'kg'),
('Olive Oil', 30.000, 'liter'),
('Chicken Breast', 60.000, 'kg'),
('Cheese', 40.000, 'kg'),
('Basil', 10.000, 'kg'),
('Garlic', 25.000, 'kg'),
('Onion', 30.000, 'kg'),
('Salt', 20.000, 'kg');

SELECT * FROM ingredients;

INSERT INTO menu_items (name, price) VALUES
('Margherita Pizza', 12.99),
('Grilled Chicken', 15.50),
('Caesar Salad', 8.99),
('Spaghetti Carbonara', 13.50),
('Fish and Chips', 14.99);

SELECT * FROM menu_items;

INSERT INTO recipe (menu_item_id, ingredient_id, quantity, unit) VALUES
(1, 1, 1.000, 'kg'),
(1, 2, 1.000, 'liter'),
(1, 3, 1.000, 'kg'),
(1, 7, 0.100, 'kg'),
(2, 5, 0.300, 'kg'),
(2, 4, 0.100, 'liter'),
(2, 10, 0.050, 'kg'),
(3, 6, 0.100, 'kg'),
(3, 10, 0.020, 'kg'),
(4, 1, 0.500, 'kg'),
(4, 6, 0.200, 'kg'),
(4, 10, 0.050, 'kg'),
(5, 1, 1.000, 'kg'),
(5, 4, 0.500, 'liter'),
(5, 10, 0.100, 'kg');

SELECT * FROM recipe;

INSERT INTO res_tables (number, status) VALUES
(1, 'available'),
(2, 'available'),
(3, 'reserved'),
(4, 'occupied'),
(5, 'available'),
(6, 'available');

SELECT * FROM res_tables;

INSERT INTO orders (table_id, status) VALUES
(4, 'open'),
(3, 'open'),
(1, 'completed'),
(2, 'open'),
(4, 'open');

SELECT * FROM orders;

INSERT INTO order_items (order_id, menu_item_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 2),
(2, 1, 1),
(3, 1, 1),
(4, 4, 1),
(4, 3, 2),
(5, 2, 2),
(5, 5, 1);

SELECT * FROM order_items;

--flow step by step
--step 1
SELECT id,number,status FROM res_tables
WHERE status = 'available'
ORDER BY number;

--step 2
INSERT INTO orders (table_id, status)
VALUES (4, 'open')
RETURNING id, table_id, status;

INSERT INTO order_items (order_id, menu_item_id, quantity)
VALUES (6, 1, 2), (6, 2, 1);

--step 3
SELECT itm.id,itm.order_id,m.name,itm.quantity
FROM order_items itm
JOIN menu_items m ON itm.menu_item_id = m.id
WHERE itm.order_id = 6;

--step 4
SELECT oi.order_id,m.name AS menu_item, oi.quantity AS quantity_ordered, r.ingredient_id,i.name AS ingredient_name,
r.quantity AS quantity_per_item, (oi.quantity * r.quantity) AS total_needed,i.quantity AS current_stock, i.unit,
CASE WHEN i.quantity >= (oi.quantity * r.quantity) THEN 'ok'ELSE 'insufficient items' END AS ingredient_status
FROM order_items oi
JOIN menu_items m ON oi.menu_item_id = m.id
JOIN recipe r ON m.id = r.menu_item_id
JOIN ingredients i ON r.ingredient_id = i.id
WHERE oi.order_id = 6
ORDER BY m.name, i.name;

--step 5
UPDATE ingredients
SET quantity = quantity - (
    SELECT COALESCE(SUM(oi.quantity * r.quantity), 0)
    FROM order_items oi
    JOIN recipe r ON oi.menu_item_id = r.menu_item_id
    WHERE oi.order_id = 6
    AND r.ingredient_id = ingredients.id
)
WHERE id IN (
    SELECT DISTINCT r.ingredient_id
    FROM order_items oi
    JOIN recipe r ON oi.menu_item_id = r.menu_item_id
    WHERE oi.order_id = 6
);

SELECT id,name,quantity,unit FROM ingredients ORDER BY name;

--step 6
SELECT o.id AS order_id, rt.number AS table_number, m.name AS menu_item, oi.quantity, o.status
FROM orders o
JOIN res_tables rt ON o.table_id = rt.id
JOIN order_items oi ON o.id = oi.order_id
JOIN menu_items m ON oi.menu_item_id = m.id
WHERE o.status = 'open'
ORDER BY o.id, m.name;