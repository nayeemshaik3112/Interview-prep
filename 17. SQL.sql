 ===================================================================================
   FILE        : 17. SQL.sql
   PURPOSE     : Complete SQL / MySQL Interview Preparation
   TARGET ROLE : Java Backend Developer (3+ years) -- Accenture, Wipro, TCS, Infosys,
                 Capgemini, Cognizant, Deloitte, IBM, Wells Fargo, Startups, Product Cos
   AUTHOR NOTE : Practice this entire file in Beekeeper Studio / Docker MySQL.
                 Run the dataset section ONCE, then practice every query below it.
   =================================================================================== 


 ===================================================================================
   SECTION 0  --  DEEP RESEARCH CONCLUSION
   ===================================================================================
   (Compiled from Glassdoor / Reddit / Medium / GeeksForGeeks / LinkedIn /
    InterviewBit / Hirist / DataLemur / candidate interview experiences 2024-2026)

   --------------------------------------------------------------------------
   A.  WHAT LEVEL OF SQL IS ACTUALLY ASKED FOR 3+ YEARS JAVA BACKEND?
   --------------------------------------------------------------------------

   For SERVICE COMPANIES (TCS, Wipro, Infosys, Accenture, Capgemini, Cognizant,
   IBM, Deloitte):
       --> Strong BASIC + MEDIUM level is enough to crack.
       --> Heavy emphasis on: joins, group by, subqueries, Nth highest salary,
           duplicates, basic window functions, theory questions (PK/FK,
           normalization, index basics, DELETE vs TRUNCATE).
       --> SQL is usually 25-35% of the technical interview; the rest is
           Java/Spring/Microservices.

   For WELLS FARGO + similar mid-tier product/finance companies:
       --> Same as above + better optimization thinking + EXPLAIN plan basics +
           slightly harder window function questions (running totals, LAG/LEAD,
           partitioned ranks).

   For STARTUPS + PRODUCT companies:
       --> Real query-writing problems. Multi-table joins, window functions,
           CTEs, query optimization, index strategy questions. Sometimes
           moderate query tuning + execution plan reading.

   --------------------------------------------------------------------------
   B.  MOST REPEATED INTERVIEW PATTERNS (RANKED BY FREQUENCY)
   --------------------------------------------------------------------------
   1.  Second / Nth highest salary                         (asked ~90% interviews)
   2.  Department-wise max/min/avg salary                  (~85%)
   3.  Find / delete duplicate rows                        (~75%)
   4.  INNER vs LEFT JOIN difference + example             (~80%)
   5.  WHERE vs HAVING difference                          (~80%)
   6.  GROUP BY with COUNT/SUM + a HAVING filter           (~75%)
   7.  Employees who never received a bonus / order        (~70%)  (LEFT JOIN + IS NULL)
   8.  Self join -- employee & manager name                (~65%)
   9.  Correlated subquery vs normal subquery              (~60%)
   10. IN vs EXISTS                                        (~55%)
   11. UNION vs UNION ALL                                  (~50%)
   12. ROW_NUMBER vs RANK vs DENSE_RANK                    (~60% -- now rising fast)
   13. CTE basics (WITH clause)                            (~45%)
   14. DELETE vs TRUNCATE vs DROP                          (~70%)
   15. Primary key vs Unique key vs Foreign key            (~65%)
   16. Normalization 1NF / 2NF / 3NF                       (~55%)
   17. Index -- what / when / why / tradeoff               (~50%)
   18. ACID properties                                     (~45%)
   19. CASE WHEN to pivot rows                             (~35%)
   20. Running total / cumulative sum (window func)        (~30%)

   --------------------------------------------------------------------------
   C.  RARELY ASKED (DO NOT WASTE TIME)
   --------------------------------------------------------------------------
   - Recursive CTEs (asked only at high-end product companies)
   - PIVOT / UNPIVOT MySQL hacks (rare)
   - Triggers / Stored procedures DEEP internals (just know the definition)
   - Cursors
   - DBA-level optimizer internals, B-tree internals
   - Replication, sharding internals (mention if asked in system design)
   - Materialized views (PostgreSQL flavor; MySQL doesnt have native)
   - Window frames ROWS BETWEEN ... (asked at product companies only)

   --------------------------------------------------------------------------
   D.  TOP 5 CANDIDATE MISTAKES (KILLERS IN INTERVIEWS)
   --------------------------------------------------------------------------
   1. Confusing WHERE and HAVING -- using WHERE on aggregate.
   2. Forgetting GROUP BY columns that are in SELECT (non-aggregated).
   3. Using "SELECT *" in interview answer -- looks unprofessional.
   4. Forgetting that LEFT JOIN + WHERE on right table = INNER JOIN.
   5. Not handling NULL in NOT IN -- silently returns empty result.

   --------------------------------------------------------------------------
   E.  TRICKY INTERVIEWER FOLLOW-UPS (be ready)
   --------------------------------------------------------------------------
   - "What if salary table has duplicates?"
   - "What if there is no second highest?"
   - "Now solve it without LIMIT."
   - "Now solve it with a window function."
   - "Now make it return department-wise."
   - "Why is your query slow? How will you optimize?"
   - "What index would you add?"
   - "Does NOT IN handle NULLs correctly?"

   --------------------------------------------------------------------------
   F.  ONE FINAL CONCLUSION
   --------------------------------------------------------------------------
   Realistic SQL level required for 3+ years backend interviews:

       *** BASICS (must be perfect) + MEDIUM (must be fluent) +
           ONE LEVEL ABOVE (window functions + CTE + basic optimization). ***

   Thats it. Do NOT go DBA-deep. The Java/Spring portion of the interview
   matters far more than DBA-level SQL trivia.
   =================================================================================== 


 ===================================================================================
   SECTION 1  --  MASTER DATASET
   -----------------------------------------------------------------------------------
   ONE dataset. ALL queries in this file use it. Run this section ONCE.
   It has:
       - realistic backend-style tables (employees, departments, projects, salaries,
         customers, orders, claims, policies)
       - duplicates
       - NULL values
       - repeated salaries (for RANK vs DENSE_RANK demos)
       - realistic dates
       - foreign keys
   =================================================================================== 

-- Safety: drop in correct order (children first)
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS policies;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employee_projects;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- ---------------------------------------------------------------------------------
-- 1.1  departments
-- ---------------------------------------------------------------------------------
CREATE TABLE departments (
    dept_id     INT PRIMARY KEY,
    dept_name   VARCHAR(50) NOT NULL,
    location    VARCHAR(50)
);

INSERT INTO departments VALUES
(10, 'Engineering',   'Bengaluru'),
(20, 'Finance',       'Mumbai'),
(30, 'HR',            'Hyderabad'),
(40, 'Sales',         'Pune'),
(50, 'Marketing',     'Delhi'),
(60, 'Operations',    NULL);          -- NULL location on purpose

-- ---------------------------------------------------------------------------------
-- 1.2  employees   (note: duplicates, NULLs, repeated salaries, self-referencing manager)
-- ---------------------------------------------------------------------------------
CREATE TABLE employees (
    emp_id       INT PRIMARY KEY,
    emp_name     VARCHAR(50) NOT NULL,
    email        VARCHAR(100),
    dept_id      INT,
    manager_id   INT,                  -- self-reference to emp_id
    salary       DECIMAL(10,2),
    hire_date    DATE,
    bonus        DECIMAL(10,2),        -- nullable on purpose
    city         VARCHAR(50),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Seed (CEO has no manager)
INSERT INTO employees VALUES
(101, 'Rahul Sharma',    'rahul@corp.com',    10, NULL, 95000.00, '2019-03-15', 15000.00, 'Bengaluru'),
(102, 'Priya Singh',     'priya@corp.com',    10, 101,  72000.00, '2020-07-01', 8000.00,  'Bengaluru'),
(103, 'Amit Patel',      'amit@corp.com',     10, 101,  72000.00, '2020-09-12', NULL,     'Bengaluru'), -- duplicate salary, NULL bonus
(104, 'Sneha Reddy',     'sneha@corp.com',    10, 101,  60000.00, '2021-01-20', 5000.00,  'Hyderabad'),
(105, 'Vikram Kumar',    'vikram@corp.com',   20, NULL, 88000.00, '2018-05-10', 12000.00, 'Mumbai'),    -- another dept head
(106, 'Anjali Mehta',    'anjali@corp.com',   20, 105,  65000.00, '2021-06-15', 6000.00,  'Mumbai'),
(107, 'Karan Verma',     'karan@corp.com',    20, 105,  65000.00, '2022-02-01', NULL,     'Mumbai'),    -- duplicate salary
(108, 'Nisha Gupta',     'nisha@corp.com',    30, NULL, 55000.00, '2019-11-25', 4000.00,  'Hyderabad'),
(109, 'Rohan Joshi',     'rohan@corp.com',    30, 108,  48000.00, '2022-08-10', NULL,     'Hyderabad'),
(110, 'Pooja Iyer',      'pooja@corp.com',    40, NULL, 70000.00, '2020-04-05', 9000.00,  'Pune'),
(111, 'Arjun Nair',      'arjun@corp.com',    40, 110,  52000.00, '2023-01-15', 3000.00,  'Pune'),
(112, 'Divya Rao',       'divya@corp.com',    40, 110,  52000.00, '2023-03-20', NULL,     'Pune'),     -- duplicate salary
(113, 'Manish Tiwari',   'manish@corp.com',   50, NULL, 68000.00, '2021-10-11', 7000.00,  'Delhi'),
(114, 'Kavita Bansal',   'kavita@corp.com',   50, 113,  45000.00, '2023-07-01', NULL,     'Delhi'),
(115, 'Suresh Pillai',    NULL,               NULL, NULL, 40000.00, '2024-02-10', NULL,    'Chennai'), -- intentional: no dept, no email, no manager
(116, 'Rahul Sharma',    'rahul2@corp.com',   10, 101,  62000.00, '2022-11-05', 5500.00,  'Bengaluru'), -- duplicate NAME (different emp_id)
(117, 'Ayesha Khan',     'ayesha@corp.com',   60, NULL, 50000.00, '2023-12-01', NULL,     NULL),       -- dept 60 has no other employees
(118, 'Ravi Krishnan',   'ravi@corp.com',     20, 105,  92000.00, '2024-08-15', 8000.00,  'Mumbai');   -- earns MORE than manager Vikram (for Q8 demo)

-- ---------------------------------------------------------------------------------
-- 1.3  salaries  (salary history per employee -- for window function practice)
-- ---------------------------------------------------------------------------------
CREATE TABLE salaries (
    sal_id      INT PRIMARY KEY,
    emp_id      INT,
    salary      DECIMAL(10,2),
    from_date   DATE,
    to_date     DATE,                  -- NULL means currently active
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO salaries VALUES
(1, 101, 75000,  '2019-03-15', '2020-12-31'),
(2, 101, 85000,  '2021-01-01', '2022-12-31'),
(3, 101, 95000,  '2023-01-01', NULL),
(4, 102, 60000,  '2020-07-01', '2021-12-31'),
(5, 102, 72000,  '2022-01-01', NULL),
(6, 105, 70000,  '2018-05-10', '2020-12-31'),
(7, 105, 80000,  '2021-01-01', '2022-12-31'),
(8, 105, 88000,  '2023-01-01', NULL),
(9, 110, 55000,  '2020-04-05', '2022-03-31'),
(10,110, 70000,  '2022-04-01', NULL);

-- ---------------------------------------------------------------------------------
-- 1.4  projects + employee_projects  (many-to-many)
-- ---------------------------------------------------------------------------------
CREATE TABLE projects (
    project_id    INT PRIMARY KEY,
    project_name  VARCHAR(80),
    budget        DECIMAL(12,2),
    start_date    DATE
);

INSERT INTO projects VALUES
(1001, 'IVR Backend Modernization',  1500000, '2023-01-10'),
(1002, 'Claims Processing Engine',    900000, '2023-04-15'),
(1003, 'Customer 360 Dashboard',      600000, '2024-02-01'),
(1004, 'Payments Microservice',      1200000, '2024-05-20'),
(1005, 'Mobile Banking Revamp',      2000000, '2024-08-01');

CREATE TABLE employee_projects (
    emp_id      INT,
    project_id  INT,
    role        VARCHAR(40),
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO employee_projects VALUES
(101, 1001, 'Tech Lead'),
(102, 1001, 'Developer'),
(103, 1001, 'Developer'),
(104, 1001, 'QA'),
(102, 1002, 'Developer'),
(103, 1002, 'Developer'),
(105, 1003, 'Tech Lead'),
(106, 1003, 'Developer'),
(110, 1004, 'Tech Lead'),
(111, 1004, 'Developer'),
(112, 1004, 'Developer'),
(101, 1005, 'Architect'),
(113, 1005, 'Lead');

-- ---------------------------------------------------------------------------------
-- 1.5  customers + orders
-- ---------------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(60),
    city          VARCHAR(50),
    signup_date   DATE
);

INSERT INTO customers VALUES
(1, 'Acme Corp',         'Bengaluru', '2022-05-01'),
(2, 'Globex Ltd',        'Mumbai',    '2022-08-15'),
(3, 'Initech',           'Pune',      '2023-01-10'),
(4, 'Umbrella Pvt',      'Delhi',     '2023-03-22'),
(5, 'Stark Industries',  'Bengaluru', '2023-06-18'),
(6, 'Wayne Enterprises', 'Hyderabad', '2024-01-05'),
(7, 'No-Order Co',       'Chennai',   '2024-09-01'); -- never placed an order

CREATE TABLE orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    order_date   DATE,
    amount       DECIMAL(10,2),
    status       VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders VALUES
(5001, 1, '2024-01-15',  15000.00, 'DELIVERED'),
(5002, 1, '2024-03-10',   8000.00, 'DELIVERED'),
(5003, 1, '2024-07-22',  22000.00, 'DELIVERED'),
(5004, 2, '2024-02-05',  12000.00, 'CANCELLED'),
(5005, 2, '2024-06-30',   9500.00, 'DELIVERED'),
(5006, 3, '2024-04-12',   5000.00, 'PENDING'),
(5007, 3, '2024-08-18',   7500.00, 'DELIVERED'),
(5008, 4, '2024-05-25',  18000.00, 'DELIVERED'),
(5009, 5, '2024-09-09',   3000.00, 'DELIVERED'),
(5010, 5, '2024-10-01',  25000.00, 'DELIVERED'),
(5011, 5, '2024-11-15',  11000.00, 'PENDING'),
(5012, 6, '2024-11-20',   6000.00, 'DELIVERED');

-- ---------------------------------------------------------------------------------
-- 1.6  policies + claims  (insurance backend domain)
-- ---------------------------------------------------------------------------------
CREATE TABLE policies (
    policy_id      INT PRIMARY KEY,
    customer_id    INT,
    policy_type    VARCHAR(30),
    premium        DECIMAL(10,2),
    issued_on      DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO policies VALUES
(2001, 1, 'HEALTH',  25000, '2023-01-10'),
(2002, 1, 'AUTO',    15000, '2023-02-15'),
(2003, 2, 'HEALTH',  30000, '2023-04-20'),
(2004, 3, 'LIFE',    50000, '2023-06-25'),
(2005, 4, 'HEALTH',  22000, '2023-08-30'),
(2006, 5, 'AUTO',    18000, '2024-01-05'),
(2007, 5, 'LIFE',    45000, '2024-02-10'),
(2008, 6, 'HEALTH',  28000, '2024-04-15');

CREATE TABLE claims (
    claim_id      INT PRIMARY KEY,
    policy_id     INT,
    claim_amount  DECIMAL(10,2),
    claim_date    DATE,
    claim_status  VARCHAR(20),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

INSERT INTO claims VALUES
(3001, 2001, 10000, '2023-05-20', 'APPROVED'),
(3002, 2001,  5000, '2023-09-10', 'APPROVED'),
(3003, 2003, 18000, '2023-10-25', 'REJECTED'),
(3004, 2004, 25000, '2024-01-15', 'APPROVED'),
(3005, 2005,  8000, '2024-03-22', 'PENDING'),
(3006, 2006, 12000, '2024-05-10', 'APPROVED'),
(3007, 2007, 35000, '2024-07-18', 'PENDING'),
(3008, 2008,  9000, '2024-09-25', 'APPROVED'),
(3009, 2001,  3000, '2024-10-30', 'PENDING'); -- multiple claims on same policy

-- ---------------------------------------------------------------------------------
-- Quick sanity check (uncomment to verify after seeding)
-- ---------------------------------------------------------------------------------
-- SELECT 'departments' tbl, COUNT(*) n FROM departments
-- UNION ALL SELECT 'employees', COUNT(*) FROM employees
-- UNION ALL SELECT 'salaries', COUNT(*) FROM salaries
-- UNION ALL SELECT 'projects', COUNT(*) FROM projects
-- UNION ALL SELECT 'employee_projects', COUNT(*) FROM employee_projects
-- UNION ALL SELECT 'customers', COUNT(*) FROM customers
-- UNION ALL SELECT 'orders', COUNT(*) FROM orders
-- UNION ALL SELECT 'policies', COUNT(*) FROM policies
-- UNION ALL SELECT 'claims', COUNT(*) FROM claims;


 ===================================================================================
   SECTION 2  --  LEARNING NOTES  (Topic by Topic)
   -----------------------------------------------------------------------------------
   For each topic:
     - WHAT it is in plain words
     - INTERVIEWER EXPECTATION
     - REAL BACKEND USAGE (Spring/Hibernate context)
     - SYNTAX
     - WORKED EXAMPLES on our dataset
     - COMMON MISTAKES
     - FOLLOW-UP QUESTIONS interviewers love to ask
   =================================================================================== 


 -----------------------------------------------------------------------------------
   2.1  SELECT  +  WHERE  +  ORDER BY  +  LIMIT  +  DISTINCT
   -----------------------------------------------------------------------------------
   WHAT: Pull rows from a table; filter them; order them; limit count;
         remove duplicates.

   INTERVIEWER EXPECTATION: Pick exact columns (no SELECT *), use correct
         WHERE operators, know that ORDER BY ASC is default, LIMIT comes
         LAST, and DISTINCT works across the WHOLE row, not one column.

   REAL BACKEND USAGE: Every Spring Data JPA "findByXxx" finally becomes
         a SELECT ... WHERE ... ORDER BY ... LIMIT (PageRequest -> LIMIT/OFFSET).

   ORDER OF EXECUTION (very common follow-up):
         FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT
   ----------------------------------------------------------------------------------- 

-- (a) Basic select
SELECT emp_id, emp_name, salary FROM employees;

-- (b) Filter
SELECT emp_name, salary FROM employees WHERE dept_id = 10;

-- (c) Multiple conditions
SELECT emp_name, salary, city
FROM employees
WHERE dept_id = 10 AND salary > 60000;

-- (d) BETWEEN, IN, LIKE, IS NULL
SELECT emp_name, hire_date FROM employees WHERE hire_date BETWEEN '2020-01-01' AND '2021-12-31';
SELECT emp_name FROM employees WHERE city IN ('Bengaluru','Pune');
SELECT emp_name FROM employees WHERE emp_name LIKE 'A%';     -- starts with A
SELECT emp_name FROM employees WHERE emp_name LIKE '%a';     -- ends with a
SELECT emp_name FROM employees WHERE bonus IS NULL;          -- never write bonus = NULL

-- (e) ORDER BY (default ASC). LIMIT pagination.
SELECT emp_name, salary FROM employees ORDER BY salary DESC LIMIT 5;
SELECT emp_name FROM employees ORDER BY hire_date ASC LIMIT 5 OFFSET 5;  -- page 2

-- (f) DISTINCT applies to ENTIRE row in the SELECT list
SELECT DISTINCT city FROM employees;
SELECT DISTINCT dept_id, city FROM employees;   -- unique COMBINATIONS

-- COMMON MISTAKES:
--    1. WHERE bonus = NULL  -> always false. Use IS NULL.
--    2. SELECT DISTINCT col1, col2  -> people think it dedupes col1; it dedupes (col1,col2).
--    3. Forgetting LIMIT after ORDER BY when fetching "top N".
--    4. Using SELECT *  in interview answers -- bad form, hurts performance.

-- FOLLOW-UPS:
--    Q: "Difference between WHERE and HAVING?" -> HAVING filters AFTER GROUP BY.
--    Q: "How do you paginate?" -> LIMIT pageSize OFFSET pageSize*(pageNo-1).
--    Q: "What is the order of execution?" -> see comment above.


 -----------------------------------------------------------------------------------
   2.2  AGGREGATE FUNCTIONS + GROUP BY + HAVING
   -----------------------------------------------------------------------------------
   COUNT(), SUM(), AVG(), MIN(), MAX().

   KEY RULES (these are the BUGS interviewers test for):
     - COUNT(*) counts ALL rows (including NULLs).
     - COUNT(col) counts NON-NULL values of that column.
     - COUNT(DISTINCT col) counts distinct non-NULL values.
     - SUM/AVG ignore NULL automatically.
     - Every column in SELECT that is NOT inside an aggregate
       MUST appear in GROUP BY (strict mode).
     - WHERE filters BEFORE grouping; HAVING filters AFTER grouping.
     - HAVING is the ONLY place aggregates can live (apart from SELECT/ORDER BY).
   ----------------------------------------------------------------------------------- 

-- (a) Counts -- watch the NULL difference
SELECT COUNT(*) AS total_rows,
       COUNT(bonus) AS rows_with_bonus,         -- ignores NULLs
       COUNT(DISTINCT dept_id) AS distinct_depts
FROM employees;

-- (b) Department-wise average salary
SELECT dept_id, AVG(salary) AS avg_salary, COUNT(*) AS headcount
FROM employees
GROUP BY dept_id;

-- (c) Department-wise stats but ONLY for departments with > 2 employees
SELECT dept_id, COUNT(*) AS headcount, AVG(salary) AS avg_sal
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > 2;

-- (d) WHERE + GROUP BY + HAVING together (very common pattern)
SELECT dept_id, AVG(salary) AS avg_sal
FROM employees
WHERE hire_date >= '2020-01-01'      -- pre-filter rows BEFORE grouping
GROUP BY dept_id
HAVING AVG(salary) > 60000           -- filter groups AFTER aggregation
ORDER BY avg_sal DESC;

-- COMMON MISTAKES:
--    1. Selecting a non-grouped column ->  ONLY_FULL_GROUP_BY error in MySQL 8.
--    2. Using WHERE COUNT(*) > 2  -> illegal. Aggregates only in HAVING.
--    3. Forgetting NULL handling in COUNT(col) vs COUNT(*).

-- FOLLOW-UPS:
--    Q: "Why is your COUNT giving a different number than expected?"
--       -> Because of NULLs in the column counted.
--    Q: "Can HAVING be used without GROUP BY?"
--       -> Yes, but rare; it treats whole table as one group.


 -----------------------------------------------------------------------------------
   2.3  JOINS  --  the SINGLE most asked SQL topic for backend devs
   -----------------------------------------------------------------------------------
   INNER JOIN  : only matching rows from both sides
   LEFT JOIN   : all rows from LEFT  + matching from right (NULLs if no match)
   RIGHT JOIN  : all rows from RIGHT + matching from left  (NULLs if no match)
   FULL OUTER  : both sides (not supported natively in MySQL -- emulate with UNION)
   CROSS JOIN  : cartesian product (every row x every row)
   SELF JOIN   : a table joined with itself, using aliases

   ON vs USING vs NATURAL JOIN:
     - ON  : explicit. ALWAYS prefer this in interviews.
     - USING(col) : when both tables have the same column name.
     - NATURAL JOIN : auto-joins on same-named columns. DANGEROUS; avoid.
   ----------------------------------------------------------------------------------- 

-- (a) INNER JOIN -- employees with their department name
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

-- (b) LEFT JOIN -- ALL employees, even those without a dept (notice Suresh Pillai)
SELECT e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- (c) LEFT JOIN + IS NULL -- the classic "find missing" pattern
-- Customers who never placed an order:
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- (d) RIGHT JOIN -- departments that have NO employees
SELECT d.dept_name, e.emp_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;

-- (e) SELF JOIN -- employee and their manager's name
SELECT e.emp_name AS employee, m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- (f) FULL OUTER JOIN emulation in MySQL (since MySQL has no FULL JOIN)
SELECT e.emp_id, e.emp_name, d.dept_name
FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.emp_id, e.emp_name, d.dept_name
FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- (g) Multi-table join: employee, department, project, role
SELECT e.emp_name, d.dept_name, p.project_name, ep.role
FROM employees e
JOIN departments d        ON e.dept_id = d.dept_id
JOIN employee_projects ep ON e.emp_id  = ep.emp_id
JOIN projects p           ON ep.project_id = p.project_id;

-- COMMON MISTAKES:
--    1. LEFT JOIN + WHERE on right table's column  -> becomes INNER JOIN behaviour
--       (the NULLs get filtered out). Always put right-table filters in the ON clause
--       OR check IS NULL in WHERE deliberately.
--    2. Forgetting the JOIN condition -> accidental cross join, query explodes.
--    3. Duplicates in JOIN result: one-to-many relationship without aggregation.

-- FOLLOW-UPS:
--    Q: "Difference between INNER and LEFT JOIN?" -> see definitions above.
--    Q: "What if I filter the right table in WHERE on a LEFT JOIN?"
--       -> filter it in ON or test IS NULL.
--    Q: "Can a LEFT JOIN ever return MORE rows than the left table has?"
--       -> Yes, if the right table has multiple matches per left row.


 -----------------------------------------------------------------------------------
   2.4  SUBQUERIES (and CORRELATED subqueries)
   -----------------------------------------------------------------------------------
   Subquery = query inside another query.

     - SCALAR subquery     : returns 1 row, 1 column.  Use in SELECT/WHERE/= comparisons.
     - ROW subquery        : returns 1 row, many columns.
     - TABLE subquery      : returns many rows; use with IN / EXISTS / FROM.
     - CORRELATED subquery : references the outer querys columns; runs ONCE PER OUTER ROW.

   PERFORMANCE: correlated subqueries are usually slower than JOINs. Many can be
   rewritten as JOINs or window functions.
   ----------------------------------------------------------------------------------- 

-- (a) Scalar subquery in WHERE -- second highest salary (classic)
SELECT MAX(salary) AS second_highest
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- (b) Subquery in FROM (derived table)
SELECT dept_id, avg_sal
FROM (
    SELECT dept_id, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY dept_id
) AS t
WHERE avg_sal > 60000;

-- (c) Correlated subquery -- employees earning > avg salary of THEIR department
SELECT e.emp_name, e.salary, e.dept_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept_id = e.dept_id            -- outer reference => correlated
);

-- (d) Subquery in SELECT (scalar) -- show each emp + count of employees in their dept
SELECT e.emp_name,
       (SELECT COUNT(*) FROM employees x WHERE x.dept_id = e.dept_id) AS dept_size
FROM employees e;

-- COMMON MISTAKES:
--    1. Forgetting that subquery in WHERE col = (...) MUST return ONE value.
--    2. NOT IN with NULLs -> the whole result becomes empty / unexpected.
--       Prefer NOT EXISTS.
--    3. Correlated subqueries used where a JOIN would be much faster.


 -----------------------------------------------------------------------------------
   2.5  IN vs EXISTS vs NOT IN vs NOT EXISTS
   -----------------------------------------------------------------------------------
   IN       : checks if value is in a list / subquery result. Fine for small lists.
   EXISTS   : checks if subquery returns ANY row. Optimized for correlated lookups.
   NOT IN   : DANGER -> returns empty result if any value in subquery is NULL.
   NOT EXISTS: safe NULL behaviour; usually preferred.
   ----------------------------------------------------------------------------------- 

-- (a) IN -- customers who placed an order
SELECT customer_name FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);

-- (b) EXISTS -- same logic, correlated
SELECT c.customer_name
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- (c) Customers who never placed an order (use NOT EXISTS, NOT NOT IN)
SELECT c.customer_name
FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- FOLLOW-UP:
--   Q: "Which is faster, IN or EXISTS?"
--      Generally for LARGE subquery results -> EXISTS.
--      For small static lists -> IN. Modern optimizers often make this equivalent.


 -----------------------------------------------------------------------------------
   2.6  UNION vs UNION ALL
   -----------------------------------------------------------------------------------
   UNION     : combines two result sets, removes duplicates (does an implicit sort).
   UNION ALL : combines two result sets, keeps duplicates -> FASTER.
   Rule     : columns must MATCH in count and compatible types.
   ----------------------------------------------------------------------------------- 

-- All cities mentioned across employees and customers (unique)
SELECT city FROM employees WHERE city IS NOT NULL
UNION
SELECT city FROM customers;

-- Same but with duplicates kept (faster, no dedup)
SELECT city FROM employees WHERE city IS NOT NULL
UNION ALL
SELECT city FROM customers;

-- FOLLOW-UP:
--   Q: "When should you prefer UNION ALL?"
--      When you don't need duplicate removal -> avoid the sort/dedup cost.


 -----------------------------------------------------------------------------------
   2.7  CASE WHEN  (conditional logic inside SQL)
   -----------------------------------------------------------------------------------
   Like if/else for rows.  Used heavily for reporting and pivoting.
   ----------------------------------------------------------------------------------- 

-- (a) Bucket employees by salary band
SELECT emp_name, salary,
       CASE
           WHEN salary >= 80000 THEN 'HIGH'
           WHEN salary >= 60000 THEN 'MID'
           ELSE 'LOW'
       END AS salary_band
FROM employees;

-- (b) "Pivot" using CASE -- count of orders per status, one row total
SELECT
    SUM(CASE WHEN status = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered,
    SUM(CASE WHEN status = 'PENDING'   THEN 1 ELSE 0 END) AS pending,
    SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled
FROM orders;

-- (c) CASE inside ORDER BY -- custom sort order
SELECT emp_name, dept_id, salary
FROM employees
ORDER BY CASE dept_id WHEN 10 THEN 1 WHEN 20 THEN 2 ELSE 99 END;


 -----------------------------------------------------------------------------------
   2.8  NULL HANDLING  (silent killer in interviews)
   -----------------------------------------------------------------------------------
   - NULL means "unknown", not zero, not empty string.
   - Any arithmetic with NULL = NULL.
   - NULL = NULL is NOT true. Use IS NULL / IS NOT NULL.
   - COALESCE(a, b, c)  -> first non-NULL.
   - IFNULL(a, b)       -> MySQL specific, two args only.
   ----------------------------------------------------------------------------------- 

SELECT emp_name, bonus, COALESCE(bonus, 0) AS bonus_safe
FROM employees;

-- Total compensation, treating missing bonus as 0
SELECT emp_name, salary + COALESCE(bonus, 0) AS total_comp
FROM employees;

-- NULLs and aggregates -- AVG ignores NULL completely
SELECT AVG(bonus) AS avg_bonus,                 -- only non-null bonuses
       AVG(COALESCE(bonus,0)) AS avg_bonus_zero -- treats NULL as 0
FROM employees;


 -----------------------------------------------------------------------------------
   2.9  WINDOW FUNCTIONS  (must-know for 3+ yrs in 2025/2026)
   -----------------------------------------------------------------------------------
   Window functions compute a value ACROSS a window of rows, WITHOUT collapsing rows
   (unlike GROUP BY).

   Anatomy:
     func() OVER (PARTITION BY col ORDER BY col [frame])

   Most asked:
     ROW_NUMBER()  : 1,2,3,4 (no ties)
     RANK()        : 1,2,2,4 (gaps after ties)
     DENSE_RANK()  : 1,2,2,3 (no gaps)
     LEAD()/LAG()  : previous/next rows value
     SUM()/AVG() OVER  : running totals
   ----------------------------------------------------------------------------------- 

-- (a) Rank salaries within each department
SELECT emp_name, dept_id, salary,
       ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn,
       RANK()       OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk,
       DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS drnk
FROM employees;

-- (b) Top-paid employee per department -- using ROW_NUMBER
SELECT *
FROM (
    SELECT emp_name, dept_id, salary,
           ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn
    FROM employees
) t
WHERE rn = 1;

-- (c) Nth highest salary using DENSE_RANK (handles duplicate salaries cleanly)
SELECT emp_name, salary
FROM (
    SELECT emp_name, salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS drnk
    FROM employees
) t
WHERE drnk = 2;          -- change to N

-- (d) Running total of order amounts per customer
SELECT order_id, customer_id, order_date, amount,
       SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders
ORDER BY customer_id, order_date;

-- (e) Previous order amount for each customer (LAG)
SELECT order_id, customer_id, order_date, amount,
       LAG(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount
FROM orders;

-- KEY DIFFERENCE BETWEEN ROW_NUMBER / RANK / DENSE_RANK (asked verbatim):
--   Suppose salaries: 100, 90, 90, 80
--     ROW_NUMBER -> 1, 2, 3, 4   (arbitrary tie-break)
--     RANK       -> 1, 2, 2, 4   (gap)
--     DENSE_RANK -> 1, 2, 2, 3   (no gap)


 -----------------------------------------------------------------------------------
   2.10  CTE  (Common Table Expression)  --  the WITH clause
   -----------------------------------------------------------------------------------
   A named temporary result set that lives for one statement.  Improves readability.
   ----------------------------------------------------------------------------------- 

WITH dept_avg AS (
    SELECT dept_id, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY dept_id
)
SELECT e.emp_name, e.salary, d.avg_sal
FROM employees e
JOIN dept_avg d ON e.dept_id = d.dept_id
WHERE e.salary > d.avg_sal;

-- Multiple CTEs
WITH
high_paid AS (SELECT * FROM employees WHERE salary > 70000),
recent    AS (SELECT * FROM high_paid WHERE hire_date > '2020-01-01')
SELECT emp_name, salary FROM recent;

-- Recursive CTE (briefly -- rarely asked, but know it exists)
-- Build hierarchy: every employee with their full reporting chain depth.
WITH RECURSIVE hierarchy AS (
    SELECT emp_id, emp_name, manager_id, 1 AS lvl
    FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.emp_name, e.manager_id, h.lvl + 1
    FROM employees e JOIN hierarchy h ON e.manager_id = h.emp_id
)
SELECT * FROM hierarchy ORDER BY lvl, emp_id;


 -----------------------------------------------------------------------------------
   2.11  CONSTRAINTS  (theory but always asked)
   -----------------------------------------------------------------------------------
   PRIMARY KEY  : unique + NOT NULL, only ONE per table. Implicit unique index.
   UNIQUE       : enforces uniqueness, but allows ONE NULL (MySQL).
   NOT NULL     : value mandatory.
   FOREIGN KEY  : value must exist in parent table; supports CASCADE.
   CHECK        : MySQL 8+ supports it; constraint on column value range.
   DEFAULT      : default value when none supplied.

   PK vs UNIQUE -- highly asked.
       - PK: one per table, NOT NULL, often clustered index.
       - UNIQUE: many allowed, allows one NULL.
   ----------------------------------------------------------------------------------- 

-- Example
-- CREATE TABLE x (
--     id INT PRIMARY KEY AUTO_INCREMENT,
--     email VARCHAR(100) UNIQUE NOT NULL,
--     dept_id INT NOT NULL,
--     age INT CHECK (age >= 18),
--     status VARCHAR(10) DEFAULT 'ACTIVE',
--     FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
-- );


 -----------------------------------------------------------------------------------
   2.12  NORMALIZATION  (1NF, 2NF, 3NF) -- theory question, every service company
   -----------------------------------------------------------------------------------
   1NF: atomic columns, no repeating groups, no arrays/lists in cells.
   2NF: 1NF + every non-key column depends on the FULL primary key
        (eliminate partial dependency in composite keys).
   3NF: 2NF + no transitive dependency (non-key depends only on key, not other non-key).

   Quick mnemonic: "The key, the whole key, and nothing but the key."

   When do we DE-normalize?
     - For read-heavy reporting tables.
     - To avoid expensive joins on hot paths.
     - In data warehouses / OLAP.
   ----------------------------------------------------------------------------------- 


 -----------------------------------------------------------------------------------
   2.13  INDEXES  (concept-only, do NOT go into B-tree internals unless asked)
   -----------------------------------------------------------------------------------
   WHAT: A separate data structure (typically B+ tree) that lets the DB find rows
         without scanning the whole table.

   USE WHEN:
     - Columns frequently used in WHERE / JOIN / ORDER BY.
     - High-cardinality columns (many distinct values).

   AVOID:
     - Tiny tables.
     - Columns updated very frequently (each update rewrites the index).
     - Low-cardinality columns (e.g. boolean) unless used with a partial index.

   TYPES (just NAME them; thats enough):
     - Clustered (PK in InnoDB)
     - Non-clustered / Secondary
     - Composite / Multi-column
     - Unique
     - Full-text
     - Hash (MEMORY engine)

   COMPOSITE INDEX RULE (leftmost-prefix):
     If you have INDEX(a,b,c), it helps queries with WHERE a, WHERE a AND b,
     WHERE a AND b AND c -- but NOT WHERE b alone.

   EXPLAIN: prepend EXPLAIN to any SELECT to see how MySQL will execute it.
   Check: type=ALL (full scan, BAD), type=ref/range/eq_ref (good), key (which index used),
          rows (estimate), Extra=Using index (covering index, great).
   ----------------------------------------------------------------------------------- 

-- Adding indexes
-- CREATE INDEX idx_emp_dept ON employees(dept_id);
-- CREATE INDEX idx_emp_name ON employees(emp_name);
-- CREATE UNIQUE INDEX uk_emp_email ON employees(email);

-- Inspect a query plan
EXPLAIN SELECT * FROM employees WHERE dept_id = 10;


 -----------------------------------------------------------------------------------
   2.14  DELETE vs TRUNCATE vs DROP -- always asked
   -----------------------------------------------------------------------------------
   DELETE   : DML.  Removes rows by condition. Logged row-by-row. Triggers fire.
              Can be rolled back (within a transaction). Slow on huge tables.
   TRUNCATE : DDL.  Removes ALL rows. Resets AUTO_INCREMENT. Cannot have WHERE.
              No triggers. Cannot be rolled back in most engines. Much faster.
   DROP     : DDL.  Removes the entire table (structure + data + indexes).
   ----------------------------------------------------------------------------------- 


 -----------------------------------------------------------------------------------
   2.15  TRANSACTIONS + ACID  (theory, asked at almost every interview)
   -----------------------------------------------------------------------------------
   ACID:
     A - Atomicity   : all-or-nothing.
     C - Consistency : DB moves from one valid state to another.
     I - Isolation   : concurrent txns don't see each other's intermediate state.
     D - Durability  : once committed, persists even on crash.

   Isolation levels (low -> high) and their problems:
     READ UNCOMMITTED  -> dirty reads
     READ COMMITTED    -> non-repeatable reads possible
     REPEATABLE READ   -> phantom reads possible (MySQL InnoDB default)
     SERIALIZABLE      -> safest, slowest

   Springs @Transactional uses these levels via Isolation enum.
   ----------------------------------------------------------------------------------- 

-- Manual transaction
-- START TRANSACTION;
-- UPDATE employees SET salary = salary + 5000 WHERE emp_id = 102;
-- UPDATE employees SET salary = salary - 5000 WHERE emp_id = 103;
-- COMMIT;  -- or ROLLBACK;


 -----------------------------------------------------------------------------------
   2.16  OPTIMIZATION BASICS (just enough for 3+ yrs interview)
   -----------------------------------------------------------------------------------
   When the interviewer says "your query is slow, how do you optimize?", answer
   in this exact order:

     1. Run EXPLAIN. Look at type, rows, key, Extra.
     2. Add indexes on columns used in WHERE / JOIN / ORDER BY.
     3. Avoid SELECT * -- pick only required columns (helps covering index).
     4. Avoid functions on indexed columns in WHERE (e.g. WHERE YEAR(d)=2024
        prevents index use; use d BETWEEN '2024-01-01' AND '2024-12-31').
     5. Avoid leading wildcards in LIKE ('%abc' -- no index use).
     6. Replace correlated subqueries with JOINs or window functions.
     7. Use UNION ALL instead of UNION when duplicates are OK.
     8. Paginate with LIMIT/OFFSET; for very deep pages use keyset pagination.
     9. Batch writes; use bulk INSERT/UPDATE instead of N round trips.
    10. Consider denormalization or caching (Redis) for read-heavy hotspots.
   ----------------------------------------------------------------------------------- 


 ===================================================================================
   SECTION 3  --  50 MOST IMPORTANT SQL INTERVIEW QUESTIONS
   -----------------------------------------------------------------------------------
   For every question:
     - Q     : the exact question
     - A     : optimized answer (the one to write first)
     - ALT   : alternative solution if useful
     - ASKED : companies known to ask this/similar
     - TRAP  : common mistakes interviewers watch for
     - F-UP  : follow-up questions to expect
   =================================================================================== 


-- ============= Q1. Find the second highest salary ==============================
-- ASKED : Accenture, Wipro, TCS, Infosys, Cognizant, Capgemini, IBM, Wells Fargo, Deloitte
-- TRAP  : If there are duplicate top salaries, MAX(salary) approach handles ties
--         but LIMIT 1 OFFSET 1 does NOT.
-- F-UP  : "Now do Nth highest." / "Without LIMIT." / "Using window function."

-- A (safest, handles duplicates + returns NULL if no 2nd):
SELECT MAX(salary) AS second_highest
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- ALT (using LIMIT -- careful with duplicate top salary)
SELECT DISTINCT salary AS second_highest
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

-- ALT (window function -- the modern "senior" answer)
SELECT DISTINCT salary AS second_highest
FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 2;


-- ============= Q2. Find the Nth highest salary =================================
-- ASKED : Almost everyone. Accenture loves "make it a reusable function".
-- TRAP  : Use DENSE_RANK (not RANK / ROW_NUMBER) to handle duplicate salaries.

-- A:
SELECT DISTINCT salary
FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 3;     -- change to N

-- ALT (no window function -- older MySQL):
SELECT DISTINCT salary
FROM employees e1
WHERE 3 = (
    SELECT COUNT(DISTINCT salary)
    FROM employees e2
    WHERE e2.salary >= e1.salary
);


-- ============= Q3. Find department-wise highest salary ==========================
-- ASKED : TCS, Wipro, Infosys, Accenture, Capgemini, Wells Fargo
-- TRAP  : Returning just MAX(salary) per dept_id won't give the employee name.
--         You must JOIN back or use a window function.

-- A (window function, clean):
SELECT emp_name, dept_id, salary
FROM (
    SELECT emp_name, dept_id, salary,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 1;

-- ALT (classic join):
SELECT e.emp_name, e.dept_id, e.salary
FROM employees e
JOIN (
    SELECT dept_id, MAX(salary) AS max_sal
    FROM employees
    GROUP BY dept_id
) m ON e.dept_id = m.dept_id AND e.salary = m.max_sal;


-- ============= Q4. Find duplicate emails / rows in employees ====================
-- ASKED : Wipro, Infosys, Accenture, Cognizant
-- TRAP  : Returning every duplicate row vs only the duplicate VALUE.

-- A (find duplicate emp_name values):
SELECT emp_name, COUNT(*) AS cnt
FROM employees
GROUP BY emp_name
HAVING COUNT(*) > 1;

-- ALT (return the duplicate ROWS themselves):
SELECT *
FROM employees
WHERE emp_name IN (
    SELECT emp_name FROM employees GROUP BY emp_name HAVING COUNT(*) > 1
);


-- ============= Q5. DELETE duplicate rows, keep one ==============================
-- ASKED : TCS, Accenture, IBM. Tricky in MySQL because you can't UPDATE/DELETE
--         from the same table you SELECT from directly without a subquery wrapper.

-- A (keep the row with the smallest emp_id per duplicate emp_name):
DELETE e1 FROM employees e1
JOIN employees e2
  ON e1.emp_name = e2.emp_name
 AND e1.emp_id   > e2.emp_id;

-- ALT (window function approach -- harder to DELETE in MySQL; usually used to mark):
-- SELECT * FROM (
--     SELECT emp_id, emp_name,
--            ROW_NUMBER() OVER (PARTITION BY emp_name ORDER BY emp_id) AS rn
--     FROM employees
-- ) t WHERE rn > 1;


-- ============= Q6. Employees who never received a bonus ========================
-- ASKED : Capgemini, Cognizant, Wipro
-- TRAP  : Difference between NULL bonus and bonus = 0.

SELECT emp_name FROM employees WHERE bonus IS NULL;


-- ============= Q7. Customers who never placed an order =========================
-- ASKED : Accenture, IBM, Deloitte, Wells Fargo (very common e-commerce pattern)
-- TRAP  : NOT IN fails if subquery has NULLs; prefer LEFT JOIN+IS NULL or NOT EXISTS.

-- A (LEFT JOIN + IS NULL):
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- ALT (NOT EXISTS):
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);


-- ============= Q8. Employees earning more than their manager ===================
-- ASKED : Accenture, Infosys (classic self-join question)

SELECT e.emp_name AS employee, e.salary AS emp_sal,
       m.emp_name AS manager,  m.salary AS mgr_sal
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;


-- ============= Q9. Employees earning more than the AVG salary of THEIR dept ====
-- ASKED : Wipro, TCS, IBM (classic correlated subquery)

-- A (correlated subquery):
SELECT e.emp_name, e.dept_id, e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id
);

-- ALT (join with derived avg -- often faster):
SELECT e.emp_name, e.dept_id, e.salary
FROM employees e
JOIN (
    SELECT dept_id, AVG(salary) AS avg_sal
    FROM employees GROUP BY dept_id
) d ON e.dept_id = d.dept_id
WHERE e.salary > d.avg_sal;


-- ============= Q10. Department with the highest average salary =================
-- ASKED : Cognizant, Capgemini, Deloitte

SELECT dept_id, AVG(salary) AS avg_sal
FROM employees
GROUP BY dept_id
ORDER BY avg_sal DESC
LIMIT 1;


-- ============= Q11. Top 3 highest-paid employees per department ===============
-- ASKED : Wells Fargo, product companies, Accenture
-- TRAP  : Cannot do with simple GROUP BY. Window function required.

SELECT emp_name, dept_id, salary
FROM (
    SELECT emp_name, dept_id, salary,
           DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS drnk
    FROM employees
) t
WHERE drnk <= 3;


-- ============= Q12. Total order amount per customer + customer name ===========
-- ASKED : Everyone, in different domain wrappers

SELECT c.customer_id, c.customer_name, COALESCE(SUM(o.amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;


-- ============= Q13. Customers who placed more than 2 orders ===================
-- ASKED : TCS, Wipro, Cognizant

SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 2;


-- ============= Q14. Difference between INNER JOIN and LEFT JOIN ===============
-- ASKED : 80% of interviews -- be ready to answer in 30 seconds.
--
-- INNER JOIN returns only rows where the join condition matches in BOTH tables.
-- LEFT  JOIN returns ALL rows from the LEFT table and matching rows from right;
--            for non-matching right rows you get NULLs.
--
-- Example using our data:
SELECT e.emp_name, d.dept_name
FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id; -- 'Suresh Pillai' missing

SELECT e.emp_name, d.dept_name
FROM employees e LEFT  JOIN departments d ON e.dept_id = d.dept_id; -- 'Suresh Pillai' included with NULL dept


-- ============= Q15. WHERE vs HAVING =============================================
-- ASKED : 80% of interviews.
--
-- WHERE  filters individual ROWS  BEFORE  grouping. Cannot use aggregates.
-- HAVING filters GROUPS           AFTER   grouping. Can use aggregates.
--
-- Example: departments with total salary > 200000, excluding the 'HR' dept entirely.
SELECT dept_id, SUM(salary) AS total_sal
FROM employees
WHERE dept_id <> 30          -- WHERE filters out HR rows first
GROUP BY dept_id
HAVING SUM(salary) > 200000; -- HAVING filters the aggregated groups


-- ============= Q16. DELETE vs TRUNCATE vs DROP =================================
-- ASKED : 70% of interviews.
--   DELETE   : DML, removes rows by condition, can ROLLBACK, fires triggers, slow.
--   TRUNCATE : DDL, removes ALL rows, resets AUTO_INCREMENT, cannot ROLLBACK, no triggers, fast.
--   DROP     : DDL, removes the entire TABLE (schema + data + indexes).
--
-- F-UP: "Which is fastest?" -> TRUNCATE (it deallocates pages, not rows).
--       "Can DELETE be rolled back?" -> Yes, inside a transaction. TRUNCATE cannot in MyISAM,
--                                       but can in InnoDB on some versions (be honest: "Generally no").


-- ============= Q17. PRIMARY KEY vs UNIQUE KEY ==================================
-- ASKED : Almost every theory round.
--   PK : only ONE per table, NOT NULL, often the clustered index in InnoDB.
--   UQ : MANY allowed per table, allows ONE NULL (in MySQL).
--   Both create a unique index automatically.


-- ============= Q18. ROW_NUMBER vs RANK vs DENSE_RANK ===========================
-- ASKED : Capgemini, Deloitte, Wells Fargo, product companies.
-- Demo on our duplicate-salary employees (102 and 103 both have 72000):

SELECT emp_name, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn,
       RANK()       OVER (ORDER BY salary DESC) AS rnk,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS drnk
FROM employees WHERE dept_id = 10;
-- ROW_NUMBER: arbitrary among ties (1,2,3,...)
-- RANK:       same rank for ties + a gap after (..,2,2,4,..)
-- DENSE_RANK: same rank for ties + NO gap   (..,2,2,3,..)


-- ============= Q19. Find the running total of order amounts per customer ======
-- ASKED : Product companies, Wells Fargo (window function classic)

SELECT order_id, customer_id, order_date, amount,
       SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders
ORDER BY customer_id, order_date;


-- ============= Q20. Find the previous order amount for each customer (LAG) =====
-- ASKED : Mid-tier product companies, fintech

SELECT order_id, customer_id, order_date, amount,
       LAG(amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount,
       amount - LAG(amount,1) OVER (PARTITION BY customer_id ORDER BY order_date) AS delta
FROM orders;


-- ============= Q21. Departments and their employee count, INCLUDING empty depts =
-- ASKED : Wipro, Cognizant

SELECT d.dept_id, d.dept_name, COUNT(e.emp_id) AS emp_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;
-- Note: COUNT(e.emp_id) returns 0 for empty depts; COUNT(*) would return 1 (wrong).


-- ============= Q22. Departments that have NO employees ========================
-- ASKED : Capgemini, IBM

SELECT d.dept_id, d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;


-- ============= Q23. Number of employees hired each year =======================
-- ASKED : Reporting/dashboard interviews

SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS hired
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY hire_year;


-- ============= Q24. Employees hired in the last 12 months =====================
-- ASKED : Wells Fargo, fintech

SELECT emp_name, hire_date
FROM employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH);


-- ============= Q25. Find managers and the count of their direct reports =======
-- ASKED : Infosys, Accenture (self-join + aggregate)

SELECT m.emp_id AS manager_id, m.emp_name AS manager, COUNT(e.emp_id) AS reports
FROM employees m
JOIN employees e ON e.manager_id = m.emp_id
GROUP BY m.emp_id, m.emp_name;


-- ============= Q26. Employees without a manager (top of hierarchy) ============
SELECT emp_id, emp_name FROM employees WHERE manager_id IS NULL;


-- ============= Q27. Pivot orders by status (CASE WHEN) ========================
-- ASKED : Reporting interviews

SELECT customer_id,
       SUM(CASE WHEN status = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered,
       SUM(CASE WHEN status = 'PENDING'   THEN 1 ELSE 0 END) AS pending,
       SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled,
       COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;


-- ============= Q28. Top customer (by revenue) in each city ====================
-- ASKED : Product companies, Wells Fargo

SELECT *
FROM (
    SELECT c.city, c.customer_name, SUM(o.amount) AS revenue,
           RANK() OVER (PARTITION BY c.city ORDER BY SUM(o.amount) DESC) AS rnk
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.city, c.customer_name
) t
WHERE rnk = 1;


-- ============= Q29. Difference between UNION and UNION ALL ====================
-- ASKED : Almost every interview, asked verbatim.
--   UNION     : removes duplicates (does an implicit sort/dedupe -> slower).
--   UNION ALL : keeps duplicates (faster). Use when duplicates are impossible
--               or acceptable.


-- ============= Q30. Find employees whose name appears more than once =========
SELECT emp_name, COUNT(*) AS occurrences
FROM employees
GROUP BY emp_name
HAVING COUNT(*) > 1;


-- ============= Q31. Find the 2nd most expensive order per customer ============
-- ASKED : Product companies

SELECT *
FROM (
    SELECT order_id, customer_id, amount,
           DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS drnk
    FROM orders
) t
WHERE drnk = 2;


-- ============= Q32. Difference between IN and EXISTS ==========================
-- ASKED : 50%+ of interviews.
--   IN      : compares a value against a list / subquery RESULT. Whole subquery materializes.
--   EXISTS  : returns TRUE the moment the subquery finds ANY row -> often faster on big tables.
--   NOT IN  : DANGER: if subquery has a NULL, the entire result becomes empty.
--   NOT EXISTS: safe with NULLs -> preferred.
--
-- Demonstration: customers who placed at least one order.
SELECT customer_name FROM customers c WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);


-- ============= Q33. List employees and their dept; sort by dept then salary DESC
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name ASC, e.salary DESC;


-- ============= Q34. For each project, total salary cost of assigned employees ==
-- ASKED : Wipro, TCS (multi-join + aggregate)

SELECT p.project_id, p.project_name, SUM(e.salary) AS total_salary_cost
FROM projects p
JOIN employee_projects ep ON p.project_id = ep.project_id
JOIN employees e          ON ep.emp_id    = e.emp_id
GROUP BY p.project_id, p.project_name
ORDER BY total_salary_cost DESC;


-- ============= Q35. Approved claim total per customer =========================
-- ASKED : Wells Fargo, Deloitte (insurance/banking domain)

SELECT c.customer_id, c.customer_name,
       COALESCE(SUM(cl.claim_amount), 0) AS total_approved_claims
FROM customers c
JOIN policies p   ON c.customer_id = p.customer_id
LEFT JOIN claims cl ON p.policy_id = cl.policy_id AND cl.claim_status = 'APPROVED'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_approved_claims DESC;


-- ============= Q36. Policies with NO claims yet ================================
SELECT p.policy_id, p.policy_type
FROM policies p
LEFT JOIN claims cl ON p.policy_id = cl.policy_id
WHERE cl.claim_id IS NULL;


-- ============= Q37. Average claim amount by policy type =======================
SELECT p.policy_type, AVG(cl.claim_amount) AS avg_claim, COUNT(cl.claim_id) AS claim_count
FROM policies p
JOIN claims cl ON p.policy_id = cl.policy_id
GROUP BY p.policy_type;


-- ============= Q38. Use a CTE to get above-average earners ====================
WITH avg_pay AS (
    SELECT AVG(salary) AS avg_sal FROM employees
)
SELECT e.emp_name, e.salary
FROM employees e, avg_pay
WHERE e.salary > avg_pay.avg_sal;


-- ============= Q39. Difference between WHERE and ON in JOIN ===================
-- ASKED : Tricky question at Accenture / Wells Fargo.
-- Demo: customers with their DELIVERED orders -- want to KEEP customers even
--       if they have no DELIVERED order.

-- WRONG (filters out customers without delivered orders -- becomes INNER JOIN):
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'DELIVERED';

-- RIGHT (push the filter into ON):
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o
       ON c.customer_id = o.customer_id
      AND o.status = 'DELIVERED';


-- ============= Q40. Cumulative count of orders per day (running count) ========
SELECT order_date, COUNT(*) AS daily_orders,
       SUM(COUNT(*)) OVER (ORDER BY order_date) AS cumulative_orders
FROM orders
GROUP BY order_date
ORDER BY order_date;


-- ============= Q41. Show each employee's latest active salary =================
-- ASKED : HR-system / payroll backend interviews. Uses salary history table.

-- A (CTE approach):
WITH current_sal AS (
    SELECT emp_id, salary
    FROM salaries
    WHERE to_date IS NULL                 -- 'current' rows
)
SELECT e.emp_name, cs.salary AS current_salary
FROM employees e
JOIN current_sal cs ON e.emp_id = cs.emp_id;

-- ALT (window function -- most recent row per emp):
SELECT emp_name, salary
FROM (
    SELECT e.emp_name, s.salary,
           ROW_NUMBER() OVER (PARTITION BY s.emp_id ORDER BY s.from_date DESC) AS rn
    FROM employees e
    JOIN salaries s ON e.emp_id = s.emp_id
) t
WHERE rn = 1;


-- ============= Q42. Find employees whose salary has changed more than once ====
SELECT e.emp_id, e.emp_name, COUNT(s.sal_id) AS history_count
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
GROUP BY e.emp_id, e.emp_name
HAVING COUNT(s.sal_id) > 1;


-- ============= Q43. Optimize a slow query - what is your approach? ============
-- ASKED : EVERY backend interview at 3+ yrs. Don't write code; explain steps:
--
--   1. Run EXPLAIN, read 'type' / 'key' / 'rows' / 'Extra'.
--   2. Look for full table scans (type = ALL) and missing index hits (key = NULL).
--   3. Add indexes on columns used in WHERE / JOIN / ORDER BY.
--   4. Avoid SELECT *; pick exact columns to enable covering indexes.
--   5. Avoid functions on indexed columns:  YEAR(d) = 2024 -> rewrite with BETWEEN.
--   6. Avoid leading wildcards in LIKE.
--   7. Replace correlated subqueries with JOINs or window functions.
--   8. Paginate intelligently (keyset pagination beats LIMIT OFFSET on deep pages).
--   9. Batch and prepared statements to cut round-trips.
--  10. If still slow, consider caching (Redis) or denormalization on hot reads.


-- ============= Q44. Composite index leftmost-prefix rule =====================
-- ASKED : Wells Fargo, product companies.
-- If we have INDEX(dept_id, salary), which of these can use the index?
--
--   WHERE dept_id = 10                           -> YES (leftmost present)
--   WHERE dept_id = 10 AND salary > 60000        -> YES (uses both)
--   WHERE salary > 60000                         -> NO  (leftmost missing)
--   WHERE dept_id = 10 ORDER BY salary           -> YES (ordering follows index)


-- ============= Q45. Find orders where amount is above the customer's average ==
-- ASKED : Capgemini, Cognizant -- combined correlated + aggregate.

SELECT o.order_id, o.customer_id, o.amount
FROM orders o
WHERE o.amount > (
    SELECT AVG(amount) FROM orders WHERE customer_id = o.customer_id
);


-- ============= Q46. Three consecutive PENDING claims on the same policy ======
-- ASKED : Product companies / fintech (LAG-based pattern).

SELECT policy_id, claim_id, claim_date, claim_status
FROM (
    SELECT claim_id, policy_id, claim_date, claim_status,
           LAG(claim_status, 1) OVER (PARTITION BY policy_id ORDER BY claim_date) AS prev1,
           LAG(claim_status, 2) OVER (PARTITION BY policy_id ORDER BY claim_date) AS prev2
    FROM claims
) t
WHERE claim_status = 'PENDING' AND prev1 = 'PENDING' AND prev2 = 'PENDING';


-- ============= Q47. Total compensation = salary + bonus (handle NULL) ========
-- ASKED : Almost any payroll context. Tests NULL handling.

SELECT emp_name, salary, bonus, salary + COALESCE(bonus, 0) AS total_comp
FROM employees;
-- Without COALESCE, anyone with NULL bonus would have NULL total_comp -- bug.


-- ============= Q48. ACID and Isolation levels (theory) =======================
-- ASKED : 50% of 3+ yrs interviews.
--
-- ACID:
--   Atomicity   -> all statements in a txn succeed or all are rolled back.
--   Consistency -> txn brings DB from one valid state to another (constraints honored).
--   Isolation   -> concurrent txns appear to run in isolation.
--   Durability  -> once committed, survives crash (written to disk / log).
--
-- Isolation levels (problem fixed at each level):
--   READ UNCOMMITTED -> may see DIRTY reads.
--   READ COMMITTED   -> fixes dirty reads; still NON-REPEATABLE reads possible.
--   REPEATABLE READ  -> fixes non-repeatable reads; PHANTOM reads possible.
--                       (MySQL InnoDB default; uses gap locks to mitigate phantoms.)
--   SERIALIZABLE     -> fixes all anomalies, lowest concurrency, slowest.


-- ============= Q49. Stored procedures vs Functions (one-line answers) ========
-- ASKED : Theory rounds at Wipro/TCS/Accenture.
--   Procedure : can have IN/OUT/INOUT params, may not return a value, called with CALL,
--               can modify data, used for business logic.
--   Function  : returns a single value, called inside SELECT, generally deterministic,
--               restricted from modifying data in many DBs.


-- ============= Q50. View vs Materialized View (and MySQL's reality) ==========
-- ASKED : Deloitte, IBM.
--   View              : a stored SQL query; data is computed each time the view is queried.
--                       Useful for security (hide columns) and abstraction.
--   Materialized View : stores the RESULT physically; refreshed on demand or schedule.
--                       MySQL does NOT support materialized views natively -- you simulate
--                       them with a regular table refreshed by a job/event.


 ===================================================================================
   SECTION 4  --  QUICK REVISION CHEAT SHEET (last-minute review)
   =================================================================================== 


 EXECUTION ORDER:
   FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT

 JOIN MENTAL MODEL:
   INNER  -> overlap
   LEFT   -> all of left + matches
   RIGHT  -> all of right + matches
   FULL   -> everything (MySQL: emulate via UNION of LEFT and RIGHT)
   SELF   -> table joined with itself, alias mandatory
   CROSS  -> cartesian (every-with-every)

 WINDOW FUNCTIONS - ties demo (salaries 100, 90, 90, 80):
   ROW_NUMBER  -> 1,2,3,4
   RANK        -> 1,2,2,4   (gap)
   DENSE_RANK  -> 1,2,2,3   (no gap)

 NULL TRAPS:
   - WHERE col = NULL                 -> WRONG, always false.
   - WHERE col IS NULL                -> right.
   - NOT IN (subquery with NULL)      -> empty result. Use NOT EXISTS.
   - COUNT(col)                       -> ignores NULL. COUNT(*) doesnt.
   - AVG / SUM                        -> ignore NULL.
   - any arithmetic with NULL = NULL  -> wrap with COALESCE(col, 0).

 N-th HIGHEST SALARY -- the 3 weapons:
   1. MAX < MAX               -> 2nd only.
   2. LIMIT N-1, 1 + DISTINCT -> simple, sensitive to duplicates.
   3. DENSE_RANK() = N        -> safest, scales to any N.

 DUPLICATE ROWS -- the 3 patterns:
   - Find duplicate values    : GROUP BY col HAVING COUNT(*) > 1
   - Find duplicate rows      : the col IN (above) subquery
   - Delete duplicates        : self-join DELETE on a.id > b.id

 INDEX TRIGGERS:
   - WHERE / JOIN / ORDER BY column.
   - High cardinality.
   - Composite -> leftmost prefix rule.
   - Avoid: function on column, leading '%' wildcard, low-cardinality bool.

 PERFORMANCE STORY ARC (use this in interviews):
   "First I run EXPLAIN to see if it's hitting an index. If type=ALL, I look at
    WHERE/JOIN columns and add appropriate indexes. I also rewrite SELECT * into
    only the needed columns to allow covering indexes. If there's a correlated
    subquery, I'll usually rewrite it as a JOIN or a window function. For very
    large datasets I'd consider denormalization on read hotspots or a Redis cache."

 DELETE vs TRUNCATE vs DROP:
   DELETE   -> DML, WHERE, slow, rollback yes, triggers yes.
   TRUNCATE -> DDL, no WHERE, fast, rollback usually no, resets AUTO_INCREMENT.
   DROP     -> DDL, removes table entirely.

 PK vs UNIQUE:
   PK     -> one per table, NOT NULL.
   UNIQUE -> many per table, allows ONE NULL.

 ACID:
   A all-or-nothing  C valid state  I isolated  D persistent.
 ISOLATION LEVELS (problem each one solves):
   RU -> dirty,  RC -> non-repeatable, RR -> phantom (MySQL default), SER -> none.



 ===================================================================================
   SECTION 5  --  90-SECOND ELEVATOR ANSWERS  (memorize these verbatim)
   =================================================================================== 


 1.  "Difference between WHERE and HAVING?"
     -> WHERE filters rows before grouping. HAVING filters groups after aggregation.
        WHERE cannot use aggregate functions; HAVING can.

 2.  "Difference between INNER JOIN and LEFT JOIN?"
     -> INNER JOIN returns only matching rows from both tables. LEFT JOIN returns
        all rows from the left table plus matching rows from the right, with NULLs
        where there is no match.

 3.  "Difference between UNION and UNION ALL?"
     -> UNION removes duplicates and is slower because it sorts. UNION ALL keeps
        duplicates and is faster. Use UNION ALL when duplicates can't occur or
        don't matter.

 4.  "ROW_NUMBER vs RANK vs DENSE_RANK?"
     -> ROW_NUMBER gives each row a unique sequential number. RANK gives equal
        ranks to ties but leaves gaps. DENSE_RANK gives equal ranks to ties with
        no gaps.

 5.  "IN vs EXISTS?"
     -> IN compares against a list/result set. EXISTS short-circuits the moment
        the subquery returns any row, so it's usually faster for correlated
        lookups on large tables. Always prefer NOT EXISTS over NOT IN when NULLs
        are possible.

 6.  "DELETE vs TRUNCATE?"
     -> DELETE is DML, can have a WHERE clause, can be rolled back, fires triggers,
        is slow on big tables. TRUNCATE is DDL, removes all rows, resets
        AUTO_INCREMENT, generally cannot be rolled back, doesn't fire triggers,
        and is much faster.

 7.  "PK vs UNIQUE?"
     -> Both enforce uniqueness. A table can have only one PRIMARY KEY which is
        also NOT NULL. UNIQUE allows multiple per table and permits one NULL.

 8.  "What is normalization?"
     -> Organizing tables to reduce redundancy and improve integrity. 1NF: atomic
        columns. 2NF: no partial dependency on a composite key. 3NF: no transitive
        dependency. We sometimes denormalize for read-heavy reporting.

 9.  "ACID?"
     -> Atomicity, Consistency, Isolation, Durability -- the four guarantees of a
        reliable database transaction.

 10. "How would you optimize a slow query?"
     -> Run EXPLAIN, look at type/rows/key. Add indexes on WHERE/JOIN/ORDER BY
        columns. Avoid SELECT *. Avoid functions on indexed columns. Replace
        correlated subqueries with joins. Use UNION ALL when duplicates are fine.
        Paginate properly. Cache hot reads if needed.



 ===================================================================================
   END OF FILE.
   Practice this dataset and these 50 questions in Beekeeper Studio against Docker
   MySQL. Re-read the elevator answers the morning of your interview. Good luck.
   =================================================================================== 