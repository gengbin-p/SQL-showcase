-- Author: Gengbin Piao

-- TASK 1
CREATE TABLE employees
(emp_id INT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
job_position VARCHAR(50) NOT NULL,
salary NUMERIC(8, 2),
start_date DATE NOT NULL,
birth_date DATE NOT NULL,
store_id INT,
department_id INT,
manager_id INT);

CREATE TABLE departments
(department_id INT PRIMARY KEY,
department VARCHAR(50) NOT NULL,
division VARCHAR(50) NOT NULL);

-- TASK 2
ALTER TABLE employees
ALTER COLUMN department_id SET NOT NULL;

ALTER TABLE employees
ALTER COLUMN start_date SET DEFAULT CURRENT_DATE;

ALTER TABLE employees
ADD COLUMN end_date DATE;

ALTER TABLE employees
ADD CONSTRAINT birth_check CHECK(birth_date <= CURRENT_DATE);

ALTER TABLE employees
RENAME COLUMN job_position TO position_title;

-- TASK 3
INSERT INTO employees 
(emp_id,first_name,last_name,position_title,salary,start_date,birth_date,
store_id,department_id,manager_id,end_date)
VALUES
(1,'Morrie','Conaboy','CTO',21268.94,'2005-04-30','1983-07-10',1,1,NULL,NULL),
(2,'Miller','McQuarter','Head of BI',14614.00,'2019-07-23','1978-11-09',1,1,1,NULL),
(3,'Christalle','McKenny','Head of Sales',12587.00,'1999-02-05','1973-01-09',2,3,1,NULL),
(4,'Sumner','Seares','SQL Analyst',9515.00,'2006-05-31','1976-08-03',2,1,6,NULL),
(5,'Romain','Hacard','BI Consultant',7107.00,'2012-09-24','1984-07-14',1,1,6,NULL),
(6,'Ely','Luscombe','Team Lead Analytics',12564.00,'2002-06-12','1974-08-01',1,1,2,NULL),
(7,'Clywd','Filyashin','Senior SQL Analyst',10510.00,'2010-04-05','1989-07-23',2,1,2,NULL),
(8,'Christopher','Blague','SQL Analyst',9428.00,'2007-09-30','1990-12-07',2,2,6,NULL),
(9,'Roddie','Izen','Software Engineer',4937.00,'2019-03-22','2008-08-30',1,4,6,NULL),
(10,'Ammamaria','Izhak','Customer Support',2355.00,'2005-03-17','1974-07-27',2,5,3,'2013-04-14'),
(11,'Carlyn','Stripp','Customer Support',3060.00,'2013-09-06','1981-09-05',1,5,3,NULL),
(12,'Reuben','McRorie','Software Engineer',7119.00,'1995-12-31','1958-08-15',1,5,6,NULL),
(13,'Gates','Raison','Marketing Specialist',3910.00,'2013-07-18','1986-06-24',1,3,3,NULL),
(14,'Jordanna','Raitt','Marketing Specialist',5844.00,'2011-10-23','1993-03-16',2,3,3,NULL),
(15,'Guendolen','Motton','BI Consultant',8330.00,'2011-01-10','1980-10-22',2,3,6,NULL),
(16,'Doria','Turbat','Senior SQL Analyst',9278.00,'2010-08-15','1983-01-11',1,1,6,NULL),
(17,'Cort','Bewlie','Project Manager',5463.00,'2013-05-26','1986-10-05',1,5,3,NULL),
(18,'Margarita','Eaden','SQL Analyst',5977.00,'2014-09-24','1978-10-08',2,1,6,'2020-03-16'),
(19,'Hetty','Kingaby','SQL Analyst',7541.00,'2009-08-17','1999-04-25',1,2,6,NULL),
(20,'Lief','Robardley','SQL Analyst',8981.00,'2002-10-23','1971-01-25',2,3,6,'2016-07-01'),
(21,'Zaneta','Carlozzi','Working Student',1525.00,'2006-08-29','1995-04-16',1,3,6,'2012-02-19'),
(22,'Giana','Matz','Working Student',1036.00,'2016-03-18','1987-09-25',1,3,6,NULL),
(23,'Hamil','Evershed','Web Developper',3088.00,'2022-02-03','2012-03-30',1,4,2,NULL),
(24,'Lowe','Diamant','Web Developper',6418.00,'2018-12-31','2002-09-07',1,4,2,NULL),
(25,'Jack','Franklin','SQL Analyst',6771.00,'2013-05-18','2005-10-04',1,2,2,NULL),
(26,'Jessica','Brown','SQL Analyst',8566.00,'2003-10-23','1965-01-29',1,1,2,NULL);

INSERT INTO departments
(department_id, department, division)
VALUES
(1, 'Analytics', 'IT'),
(2, 'Finance', 'Administration'),
(3, 'Sales', 'Sales'),
(4, 'Website', 'IT'),
(5, 'Back Office', 'Administration');

-- Task 4
UPDATE employees
SET 
position_title = 'Senior SQL Analyst',
salary = 7200
WHERE 
first_name = 'Jack' AND last_name = 'Franklin';

UPDATE employees
SET
position_title = 'Customer Specialist'
WHERE
position_title = 'Customer Support';

UPDATE employees
SET
salary = salary * 1.06
WHERE
position_title = 'SQL Analyst' OR
position_title = 'Senior SQL Analyst';

SELECT ROUND(AVG(salary), 2)
FROM employees
WHERE position_title = 'SQL Analyst';

-- TASK 5
ALTER TABLE employees
ADD COLUMN manager VARCHAR(50);

UPDATE employees
SET manager = first_name || ' '|| last_name;

ALTER TABLE employees
ADD COLUMN is_active BOOLEAN;

UPDATE employees
SET is_active = CASE
					WHEN end_date IS NOT NULL THEN FALSE
					ELSE TRUE
				END;

CREATE VIEW v_employees_info
AS
SELECT * FROM employees;

-- TASK 6
SELECT 
ROUND(AVG(salary), 2) AS average_salary,
position_title
FROM
employees
GROUP BY position_title;

-- TASK 7
SELECT 
ROUND(AVG(salary), 2) AS average_salary,
d.division
FROM employees AS e
LEFT JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY d.division;

-- TASK 8
SELECT
emp_id,
first_name,
last_name,
position_title,
salary,
ROUND(AVG(salary) OVER(PARTITION BY position_title), 2) AS avg_position_salary
FROM employees
ORDER BY emp_id ASC;

SELECT
COUNT(CASE 
		WHEN salary < avg_position_salary THEN 1
		ELSE NULL
		END)
FROM 
(SELECT
emp_id,
first_name,
last_name,
position_title,
salary,
ROUND(AVG(salary) OVER(PARTITION BY position_title), 2) AS avg_position_salary
FROM employees
ORDER BY emp_id ASC);

-- TASK 9
SELECT
emp_id,
salary,
start_date,
SUM(salary) OVER(ORDER BY start_date) AS running_total_of_salary
FROM employees;

-- TASK 10
SELECT 
datetime, 
SUM(salary) OVER(ORDER BY datetime) AS running_total_of_salary
FROM(
	SELECT salary,
	start_date AS datetime
	FROM employees
	UNION ALL
	SELECT 
	-salary AS salary,
	end_date AS datetime FROM employees
	WHERE end_date IS NOT NULL);

-- TASK 11
SELECT
first_name,
position_title,
salary,
average_salary
FROM(
SELECT
first_name,
position_title,
salary,
RANK() OVER(PARTITION BY position_title ORDER BY salary DESC) as salary_rank,
ROUND(AVG(salary) OVER(PARTITION BY position_title), 2) as average_salary
FROM employees)
WHERE salary_rank = 1
ORDER BY position_title;

SELECT
first_name,
position_title,
salary,
average_salary
FROM(
SELECT
first_name,
position_title,
salary,
RANK() OVER(PARTITION BY position_title ORDER BY salary DESC) as salary_rank,
ROUND(AVG(salary) OVER(PARTITION BY position_title), 2) as average_salary
FROM employees)
WHERE salary_rank = 1 AND salary != average_salary
ORDER BY position_title;

-- TASK 12
SELECT 
division,
department,
position_title,
SUM(salary),
COUNT(*),
ROUND(AVG(salary), 2)
FROM employees AS e
LEFT JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY 
ROLLUP(
division,
department,
position_title
)
ORDER BY 1,2,3

-- TASK 13
SELECT 
emp_id,
position_title,
department,
salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC) as rank
FROM employees AS e
LEFT JOIN departments AS d
on e.department_id = d.department_id;

-- TASK 14
SELECT * FROM(
SELECT 
emp_id,
position_title,
department,
salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC) as rank
FROM employees AS e
LEFT JOIN departments AS d
on e.department_id = d.department_id)
WHERE rank = 1;

