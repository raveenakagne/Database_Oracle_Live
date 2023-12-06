REM   Script: assignment
REM   assignment

INSERT INTO Products (product_id, product_name, category_id, price) 
VALUES (1, 'Laptop', 101, 1200);

INSERT INTO Products (product_id, product_name, category_id, price) 
VALUES (2, 'Headphones', 102, 100);

CREATE TABLE Products ( 
    product_id NUMBER PRIMARY KEY, 
    product_name VARCHAR2(100), 
    category_id NUMBER, 
    price NUMBER 
);

CREATE TABLE Sales ( 
    sale_id NUMBER PRIMARY KEY, 
    product_id NUMBER, 
    sale_date DATE, 
    quantity NUMBER, 
    total_amount NUMBER 
);

INSERT INTO Sales (sale_id, product_id, sale_date, quantity, total_amount) 
VALUES (1001, 1, TO_DATE('2023-01-05', 'YYYY-MM-DD'), 3, 3600);

INSERT INTO Sales (sale_id, product_id, sale_date, quantity, total_amount) 
VALUES (1002, 2, TO_DATE('2023-01-10', 'YYYY-MM-DD'), 5, 500);

SELECT p.product_name, s.total_amount, 
       RANK() OVER (ORDER BY s.total_amount DESC) AS sales_rank 
FROM Sales s 
JOIN Products p ON s.product_id = p.product_id;

SELECT p.product_name, s.total_amount, 
       SUM(s.total_amount) OVER (PARTITION BY p.product_id ORDER BY s.sale_date) AS running_total 
FROM Sales s 
JOIN Products p ON s.product_id = p.product_id;

SELECT p.category_id, p.product_name, 
       MAX(s.quantity) OVER (PARTITION BY p.category_id) AS max_quantity, 
       MIN(s.quantity) OVER (PARTITION BY p.category_id) AS min_quantity 
FROM Sales s 
JOIN Products p ON s.product_id = p.product_id;

SELECT p.category_id, AVG(p.price) OVER (PARTITION BY p.category_id) AS avg_price 
FROM Products p;

SELECT p.product_name, s.total_amount 
FROM Sales s 
JOIN Products p ON s.product_id = p.product_id 
WHERE s.total_amount > ( 
    SELECT AVG(total_amount) FROM Sales 
);

SELECT p.category_id, s.sale_date, SUM(s.quantity) AS total_quantity, SUM(s.total_amount) AS total_amount 
FROM Products p 
JOIN Sales s ON p.product_id = s.product_id 
GROUP BY CUBE(p.category_id, s.sale_date);

SELECT p.category_id, s.sale_date, SUM(s.quantity) AS total_quantity, SUM(s.total_amount) AS total_amount 
FROM Products p 
JOIN Sales s ON p.product_id = s.product_id 
GROUP BY ROLLUP(p.category_id, s.sale_date);

