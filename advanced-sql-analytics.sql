use salary_analysis; -- used schema 

DROP TABLE IF EXISTS dep; -- This command safely deletes the table if it already exists, 
                           -- so that your script doesn't fail when run multiple times.

-- 1. create table 
create table dep  
(emp_id INT,
first_name varchar(50),
last_name varchar(50),
dep_name varchar (50),
salary INT);

-- 2. check table
select * from dep; -- table chack

-- 3. add column 
alter table dep 
add column hire_date date;

-- 4. insert rows in table
INSERT INTO dep 
(emp_id, first_name, last_name, dep_name, salary, hire_date) 
VALUES 
(1, 'arun', 'kumar', 'sales', 1000, '2012-01-10'),
(2, 'varun', 'kumar', 'sales', 2000, '2013-02-12'),
(3, 'rahul', 'singh', 'sales', 1000, '2015-12-05'),
(4, 'mukes', 'thankur', 'finance', 34000, '2010-12-16'),
(5, 'rohit', 'madan', 'sales', 3300, '2010-01-15'),
(6, 'arun', 'kumar', 'Marketing', 5000, '2012-12-11'),
(7, 'arun', 'sharma', 'sales', 4000, '2010-09-18'),
(8, 'mohit', '', 'marketing', 1000, '2016-05-26'),
(9, 'suman', 'saini', 'IT', 1000, '2009-12-20'),
(10, 'lucky', 'unknown', 'sales', 2000, '2011-01-01'),
(11, 'arun', 'kumar', 'HR', 5000, '2012-12-11'),
(12, 'nisha', 'gupta', 'HR', 4000, '2010-09-18'),
(13, 'monu', '', 'HR', 1000, '2016-05-26'),
(14, 'sonam', 'Ops', 'IT', 1000, '2009-12-20'),
(15, 'lucky', '', 'Ops', 2000, '2011-01-01');  


-- 5.check table
select * from dep;  

-- 6. merging 2 columns and changeing the first letter in upper case and remain are in lower case 
SELECT emp_id, first_name,last_name, 
concat( 
    UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(first_name, 2)), 
    ' ', 
    UPPER(LEFT(last_name, 1)), LOWER(SUBSTRING(last_name, 2))
) AS full_name,dep_name,salary,hire_date 
FROM dep;

-- 7. department-wise rank base on highest salary
select emp_id,first_name, salary,dep_name, 
row_number() over(partition by dep_name order by salary desc ) as rank_1 from dep;


-- 8. highest salary in every department
select * from  -- highest salary in every department
(select emp_id,first_name, salary,dep_name, 
row_number() over(partition by dep_name order by salary desc ) as rank_1 from dep) as highest_salary  
where rank_1 = 1 ;

-- 9. change dep_name from sales to finance
update dep 
set dep_name = 'finance'
where emp_id = 10;

-- 10. highest rank salary wise with rank function it skip ranking numbers after a tie.
SELECT 
    emp_id, first_name, last_name, dep_name, salary, hire_date,
    rank() OVER (PARTITION BY dep_name ORDER BY salary desc) AS salary_rank
FROM dep;

-- 11. highest rank salary wise with dense_rank function. it does not skip rank on tie.
SELECT 
    emp_id, first_name, last_name, dep_name, salary, hire_date,
    dense_rank() OVER (PARTITION BY dep_name ORDER BY salary desc) AS salary_rank
FROM dep;

-- 12. department wise average salary
select
    emp_id, first_name, last_name, dep_name, salary, hire_date,
	round(avg(salary) OVER (PARTITION BY dep_name),2) AS running_salary
FROM dep; 

-- 13. highest salary, average salary and all eployees how have their salaries more then their department average salary. 
select * from
 (SELECT 
    emp_id, first_name, last_name, dep_name, salary, hire_date,
    max(salary) OVER (PARTITION BY dep_name) AS highest_salary,
    round(avg(salary) OVER (PARTITION BY dep_name),2) AS avg_salary,
     round(avg(salary) OVER (PARTITION BY dep_name),2) - salary AS salary_diffrence
FROM dep) as aa where avg_salary >salary order by salary_diffrence desc ;

-- 14. added some row because we need multiple years to apply lag and lead functions.
INSERT INTO dep 
(emp_id, first_name, last_name, dep_name, salary, hire_date) 
VALUES 
(1, 'arun', 'kumar', 'sales', 2000, '2013-01-10'),
(2, 'varun', 'kumar', 'sales', 4000, '2014-02-12'),
(3, 'rahul', 'singh', 'sales', 2000, '2016-12-05'),
(4, 'mukes', 'thankur', 'finance', 35000, '2011-12-16'),
(5, 'rohit', 'madan', 'sales', 3900, '2011-01-15'),
(6, 'arun', 'kumar', 'Marketing', 5500, '2013-12-11'),
(7, 'arun', 'sharma', 'sales', 4900, '2011-09-18'),
(8, 'mohit', '', 'marketing', 2000, '2017-05-26'),
(9, 'suman', 'saini', 'IT', 2000, '2010-12-20'),
(10, 'lucky', 'unknown', 'sales', 2001, '2012-01-01'),
(11, 'arun', 'kumar', 'HR', 5300, '2013-12-11'),
(12, 'nisha', 'gupta', 'HR', 5000, '2011-09-18'),
(13, 'monu', '', 'HR', 2000, '2017-05-26'),
(14, 'sonam', 'Ops', 'IT', 5000, '2010-12-20'),
(15, 'lucky', '', 'Ops', 8000, '2012-01-01'); 

-- 15.check table
select * from dep;

-- 16. adding column for a unique indentifier as primary key
ALTER TABLE dep ADD COLUMN record_id INT AUTO_INCREMENT PRIMARY KEY;


-- 17. calculate last year salary vs current year salary growth.   
SELECT 
    emp_id, first_name, last_name, dep_name, salary, hire_date,
    lag(salary) OVER (PARTITION BY emp_id order by hire_date asc) AS previous_salary,
    lead(salary) OVER (PARTITION BY emp_id order by hire_date asc) AS next_salary,
    salary -  lag(salary) OVER (PARTITION BY emp_id order by hire_date asc) AS salary_growth
FROM dep  order by emp_id asc;

 -- 18. count how many employees have been hired before or at the 
 -- same time as each employee within the same department, based on the hire_date.
SELECT 
    emp_id, first_name, last_name, dep_name, hire_date,
    COUNT(*) OVER (PARTITION BY dep_name ORDER BY hire_date) AS hired_rank_within_department
FROM dep;

-- 19. calculates each employee's salary as a percentage of the total salary in their department.
SELECT 
    emp_id, first_name, last_name, dep_name,salary, hire_date,
    round(salary *100/sum(salary) OVER (PARTITION BY dep_name ),2) AS hired_before
FROM dep;

-- 20. selects employees who have the same salary as the previous employee in their department
SELECT 
    e1.first_name,
    e1.last_name,
    e1.dep_name,
    e1.salary AS current_salary,
    e2.salary AS previous_salary,
    e1.hire_date AS current_hire_date,
    e2.hire_date AS previous_hire_date
FROM 
    department e1
JOIN 
    department e2 
    ON e1.first_name = e2.first_name 
    AND (e1.last_name <=> e2.last_name)
    AND e1.dep_name = e2.dep_name
    AND e1.hire_date = DATE_ADD(e2.hire_date, INTERVAL 1 YEAR)
ORDER BY e1.first_name, e1.hire_date;

select * from dep; 

-- 21. change table name
alter table dep rename department;
select * from department;

-- 22. check tables in arti schema
show  tables;

-- 23. alter table to add first_name and last_name column for full_name
alter table department add column full_name varchar (30);

-- 24. update table to add first_name and last_name rows under full_name
UPDATE department
SET full_name = CONCAT(first_name, ' ', last_name)
WHERE full_name IS NULL;

-- 25. alter table to add email column for email
alter table department add column email varchar(40);

-- 26. update table to add fisrt_name and last_name and '@gmail.com' for generating basic email IDs
update department
set email = CONCAT(first_name, last_name,'@gmail.com')
where full_name is not null;

select * from department;

-- checking the salary status on the basis some conditions
select *, (case when salary >= 5000 then 'green'
when salary between 2000 and 4999 then 'yellow'
when salary <2000 then 'red'
else 'black' end) as salary_status from department;
 
 

