Topic Name - SQL Basics
Topics - SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, AND, OR, NOT, Aliases (AS),

Topic Name - Joins
Topics - INNER JOIN, LEFT JOIN, RIGHT JOIN, SELF JOIN, JOIN with multiple tables, Records with no match (LEFT JOIN + NULL),

Topic Name - Aggregations
Topics - COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING, WHERE vs HAVING,

Topic Name - Subqueries
Topics - Subquery in WHERE, Subquery in SELECT, Correlated subquery, EXISTS vs IN vs NOT IN,

Topic Name - Window Functions
Topics - ROW_NUMBER(), RANK(), DENSE_RANK(), PARTITION BY, ORDER BY inside OVER(), Top N per group,

Topic Name - NULL Handling
Topics - IS NULL, IS NOT NULL, COALESCE, NULLIF,

Topic Name - Indexes
Topics - What is index, Single index, Composite index, When index helps, When index does NOT help,

Topic Name - Performance Optimization
Topics - EXPLAIN, EXPLAIN ANALYZE, Slow query identification, Pagination (LIMIT + OFFSET), Keyset pagination,

Topic Name - Common SQL Problems
Topics - Second highest salary, Duplicate detection, Records with no match, Top N per group, Finding missing records,

Topic Name - Project-Based SQL (IMPORTANT)
Topics - N+1 Problem (JPA context), Pagination strategies, Query optimization in real APIs
--------------------------------------------------------------------------------------------
## Second Highest Salary ⭐ MOST REPORTED

SELECT MAX(salary) FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);
--------------------------------------------------------------------------------------------
WHERE vs HAVING ⭐ DIRECTLY CONFIRMED ASKED

WHERE  → filters ROWS before grouping (works on individual records)
HAVING → filters GROUPS after aggregation (works on aggregated results)

WHERE cannot use aggregate functions.
HAVING can.

SELECT dept, COUNT(*) FROM employees
WHERE salary > 30000        -- filters rows first
GROUP BY dept;

-- HAVING: filter after group
SELECT dept, COUNT(*) FROM employees
GROUP BY dept
HAVING COUNT(*) > 5;  
--------------------------------------------------------------------------------------------
Find Employees With No Manager / Customers With No Orders

SELECT c.name FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;
--------------------------------------------------------------------------------------------
INNER JOIN vs LEFT JOIN

INNER JOIN → only matching rows from BOTH tables
LEFT JOIN  → ALL rows from left table + matching from right
             (unmatched right = NULL)

Use INNER when: you only want records that exist in both
Use LEFT when:  you want all records even if no match exists
--------------------------------------------------------------------------------------------
Find Duplicate Records

SELECT email, COUNT(*) as count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
--------------------------------------------------------------------------------------------
Department-Wise Highest Salary

SELECT dept, MAX(salary) as max_salary
FROM employees
GROUP BY dept
ORDER BY max_salary DESC;
--------------------------------------------------------------------------------------------
ROW_NUMBER / RANK / DENSE_RANK — Difference

ROW_NUMBER()  → always unique: 1, 2, 3, 4
RANK()        → ties get same rank, next rank skips: 1, 1, 3
DENSE_RANK()  → ties get same rank, no skip: 1, 1, 2

For second highest salary → use DENSE_RANK (handles ties)
For unique row numbering → use ROW_NUMBER
--------------------------------------------------------------------------------------------
Slow Query — What Do You Check First?

Step 1: Run EXPLAIN → check if full table scan (ALL) happening
Step 2: Check WHERE/JOIN columns — are they indexed?
Step 3: Check if query returns too many rows — add pagination
Step 4: Check data growth — table that was fast at 1K rows 
        is slow at 1M rows without index

Fix: CREATE INDEX idx_name ON table(column);
--------------------------------------------------------------------------------------------
What is an Index? When does it NOT help?

Index = shortcut for DB to find rows fast (like book index)

When index HELPS:
✅ SELECT with WHERE on indexed column
✅ JOIN on indexed foreign key
✅ ORDER BY on indexed column

When index does NOT help:
❌ Very small tables (full scan is faster)
❌ Low cardinality column (e.g., gender M/F — only 2 values)
❌ Frequent INSERT/UPDATE/DELETE — index update overhead
❌ Using function on indexed column: WHERE YEAR(date) = 2024
                                     (use date BETWEEN instead)
--------------------------------------------------------------------------------------------
N+1 Query Problem (JPA context — always asked if you mention Hibernate)

N+1 problem:
1 query to fetch 10 customers
+ 10 queries to fetch orders for each customer
= 11 queries total (should be 1-2)

Cause: @OneToMany with default LAZY loading + loop access

Fix:
1. JOIN FETCH in JPQL:
   "SELECT c FROM Customer c JOIN FETCH c.orders"
   
2. @EntityGraph annotation on repository method

3. @BatchSize(size=10) — fetches in batches not one-by-one
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Section 2: Scenario-Based Questions

Your query was fast last week, now takes 10 seconds

Strong answer:
1. Check if table data grew significantly
2. Run EXPLAIN → look for ALL (full scan) vs ref (index)
3. Check if recent schema change removed an index
4. Check if query changed — function wrapped around column?
5. Check DB load — concurrent queries competing for resources

Most likely cause: Missing index on a column thats now being 
filtered heavily as data grew.
--------------------------------------------------------------------------------------------
Find top 3 earners per department

SELECT dept, name, salary FROM (
    SELECT dept, name, salary,
           DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS rnk
    FROM employees
) ranked
WHERE rnk <= 3;

--------------------------------------------------------------------------------------------
Pagination — show records 21 to 30

-- Simple (OFFSET — slow at large pages)
SELECT * FROM orders
ORDER BY created_at DESC
LIMIT 10 OFFSET 20;

-- Better (Keyset — fast at any page)
SELECT * FROM orders
WHERE id > last_seen_id
ORDER BY id
LIMIT 10;

OFFSET pagination becomes slow at large offsets — it scans and discards rows. For production, keyset pagination is preferred

--------------------------------------------------------------------------------------------
Get employees who earn more than their department average

SELECT e.name, e.salary, e.dept
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) FROM employees
    WHERE dept = e.dept
);
--------------------------------------------------------------------------------------------
Your 5 Queries to Know Cold

-- 1. Second highest salary
SELECT MAX(salary) FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- 2. No orders (LEFT JOIN + NULL)
SELECT c.name FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

-- 3. Duplicate emails
SELECT email, COUNT(*) FROM users
GROUP BY email HAVING COUNT(*) > 1;

-- 4. Top earner per department
SELECT dept, name, salary FROM (
    SELECT *, DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) rn
    FROM employees
) t WHERE rn = 1;

-- 5. Department avg + filter above avg
SELECT name, salary FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept = e.dept);
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Practice Questions
-> Golden rule
Imagine 2 tables are there
left side - customers, right side - orders

when we say 
from customers c,
right join orders o 

that means customers is left table and orders is right table and we do right here, so orders rows will be printed

when we say 
from customers c,
left join orders o 

that means customers is left table and orders is right table and we do left here, so customers rows will be printed


Right Join

imagine we have orders and customers table
Query: Get all the customer and order details, if the city is delhi otherwise null

select  c.city, c.customer_id, o.order_id
from orders o
right join customers c on c.customer_id = o.customer_id
and c.city = 'Delhi'

if we write where then according to right join the right table customers will give only delhi
bu right join means the customers all rows should be printed 
so we have to use the and not where

with where - only the customers from delhi will be printed
with and - all customers will be printed but only the delhi customers will have order details, others will have null
--------------------------------------------------------------------------------------------
Left Join

find customer who never placed order
select c.customer_id, c.name
from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_code is null X

it will match the same customer_id in customers and orders table
so it will print the partial customer so
so left join means all customers should has to print
thats why we have to

select c.customer_id, c.name
from customers c
left join orders o on c.customer_id = o.customer_id
and o.order_code is not null

it means it will print all the customers as well as 
it will print null and not null values also 
and means both id and order code should not be null
--------------------------------------------------------------------------------------------
Inner join

only matching records from both tables will be printed

we can do aggregates and also we can do group by with inner join

total revenue for the customers

select c.customer_id, c.name
    sum(o.amout) as total_revenue
from customer c
inner join orders o
on c.customer_id = o.customer_id
group by c.customer_id;
--------------------------------------------------------------------------------------------
Subqueries refer the 
C:\Users\Lenovo\Desktop\Projects\Notes\SQL- Practise and Notes\Day-6 Subqueries.sql
--------------------------------------------------------------------------------------------
Window functions 

Over() - Just aaatch all the values and do the aggregate function on all the values

if we write 
select amount 
    sum(amount) as total_amount
from orders

then the aggregate function will give us the total amount of all the orders

but for every row we want to get the total amount of all the orders then we can use over()
select order_id, amounnt 
    sum(amount) over() as total_amount
    count(*) over() as total_orders
from orders

order_id amount total_amount total_orders
1        100     1000           3
2        200     1000           3
3        300     1000           3
// Like wise for all the rows total amount will be 1000
---------------------------------------------
Parition by
parition means, I know how group by works right
Group by will group the common values

similarly the value() above will be applied as mentioned above
Now the Partition is under under value() so it will be applied on the group opf values

it means

if we have north, south, east 
we will group by the region and then apply the parition so
the amount used by south people will be grouped and printed
the amount used by north  people will be grouped and printed
..

table:

order_id amount region total_amount_by_region
1        100     north 400
2        300     north 400
3        200     south 700
4        500     south 700 
5        400     east  400



select region, amount
    sum (amount) over(partition by region) as total_amount_by_region
from orders
order by region
--------------------------------------------------------------
Row Number
just it will give the row number

we used partition
so north region 1, 2, 3 rows
order_id amount region total_amount_by_region rank_in_region
1        100     north 400                   1
2        300     north 400                   2
3        200     south 700                   1
4        500     south 700                   2

SELECT
    order_id,
    region,
    amount,
    ROW_NUMBER() OVER (
        PARTITION BY region
        ORDER BY amount DESC
    ) AS rank_in_region
FROM sales_orders;

select * from(inner query) as dummy where row_number = 1 

Rank () is also same as row number
if two amounts is same then the rank is 1 , 1 and the 3 rd amount will be 3 not 2 because of the tie
Dense_Rank () is also same as row number
but if two amounts is same then the rank is 1 , 1 and the 3 rd amount will be 2 because of the tie
-----------------------------------------------------------------------------------------------------------------------------------------
=> You have orders and payments table. Show all orders — including those where payment was never made. 
For paid orders show payment amount, for unpaid show 0.

select o.order_id 
    coalesce(p.amount, 0) as payment_amount
from orders o
left join payments p on o.order_id = p.order_id
--------------------------------------------------------------
=> Find customers who placed orders but whose payment FAILED (status = 'FAILED'). Do not include customers with no payment at all.

select c.customer_id, c.customer_name
from customer c
inner join orders o on o.customer_id = c.customer_id
inner join payments p on p.payment_id = o.order_id
where p.status = 'FAILED'
--------------------------------------------------------------
=> You have employees and managers in the SAME table. Each employee has a manager_id. Show employee name and their managers name. Employees with no manager should still appear.
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
--------------------------------------------------------------
=> Three tables: students, courses, enrollments. Find students enrolled in BOTH 'Java' AND 'SQL' courses.

SELECT s.student_id, s.name
FROM students s
INNER JOIN enrollments e1
  ON s.student_id = e1.student_id
INNER JOIN courses c1 ON e1.course_id = c1.course_id AND c1.name = 'Java'
INNER JOIN enrollments e2
  ON s.student_id = e2.student_id
INNER JOIN courses c2 ON e2.course_id = c2.course_id AND c2.name = 'SQL';
--------------------------------------------------------------
=> Find customers who placed orders in January 2024 but did NOT place any orders in February 2024.
SELECT DISTINCT c.customer_id, c.name
FROM customers c
INNER JOIN orders jan
  ON c.customer_id = jan.customer_id
  AND jan.order_date BETWEEN '2024-01-01' AND '2024-01-31'
LEFT JOIN orders feb
  ON c.customer_id = feb.customer_id
  AND feb.order_date BETWEEN '2024-02-01' AND '2024-02-28'
WHERE feb.order_id IS NULL;
--------------------------------------------------------------
=> Show each department name and count of employees. Include departments with ZERO employees.
SELECT d.dept_name, COUNT(e.employee_id) AS emp_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;
--------------------------------------------------------------
Subqueries

Find employees who earn MORE than the average salary of their OWN department.
SELECT name, salary, dept
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept = e.dept
);
--------------------------------------------------------------
Find the department with the HIGHEST total salary bill.

SELECT dept
FROM employees
GROUP BY dept
ORDER BY SUM(salary) DESC
LIMIT 1;
--------------------------------------------------------------
=> find customers who have at least one order above ₹5000.

SELECT c.customer_id, c.name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
    AND o.amount > 5000
);
--------------------------------------------------------------
=> Using NOT EXISTS — find customers who have NEVER ordered.
SELECT c.customer_id, c.name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
);
--------------------------------------------------------------
=> Find employees whose salary is in the TOP 3 salary values company-wide (handle ties).
SELECT name, salary
FROM employees
WHERE salary IN (
    SELECT DISTINCT salary
    FROM employees
    ORDER BY salary DESC
    LIMIT 3
);
--------------------------------------------------------------
Window Functions

=> Rank employees by salary within each department. If tie — same rank, skip next rank.

SELECT name, dept, salary,
       RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS dept_rank

same but no skip in rank
SELECT name, dept, salary,
       DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS dept_rank
--------------------------------------------------------------
=> Get the HIGHEST paid employee from each department (handle ties — show all tied employees).
SELECT name, dept, salary
FROM (
    SELECT name, dept, salary,
           DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS dept_rank
    FROM employees
) t
WHERE dept_rank = 1;
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
