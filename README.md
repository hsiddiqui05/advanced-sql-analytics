# Employee Salary Analysis – MySQL

## 📌 Project Overview

This project demonstrates how to design and analyze an **employee salary database** using **MySQL**. It covers database creation, data cleaning, and advanced queries using **window functions, ranking, and conditional logic** to answer real business questions like:

* Who earns the highest salary in each department?
* Which employees are paid below their department’s average?
* How has salary growth changed year over year?
* What percentage of departmental salary is contributed by each employee?

---

## 🛠️ Tools & Technologies

* **Database:** MySQL
* **Schema:** `salary_analysis`
* **Concepts Used:**

  * DDL & DML (CREATE, ALTER, INSERT, UPDATE)
  * Window functions (ROW\_NUMBER, RANK, DENSE\_RANK, LAG, LEAD, SUM, AVG, MAX)
  * String functions (CONCAT, UPPER, LOWER, SUBSTRING)
  * Conditional logic (CASE statements)

---

## 📂 Database Design

**Table: `department`**

* `record_id` (Primary Key)
* `emp_id`
* `first_name`, `last_name`, `full_name`
* `dep_name`
* `salary`
* `hire_date`
* `email`

---

## 🔑 Key Features

* ✅ Standardized employee data by merging names and generating emails.
* ✅ Ranked employees by salary (ROW\_NUMBER, RANK, DENSE\_RANK).
* ✅ Identified highest-paid employees per department.
* ✅ Compared employee salaries with department averages.
* ✅ Tracked salary growth using **LAG/LEAD functions**.
* ✅ Categorized salaries into health bands (Green, Yellow, Red).

---

## 📊 Insights Generated

* Department-wise **top earners**.
* Employees **earning less than their department average**.
* **Year-over-year salary growth** trends.
* **Contribution %** of each employee’s salary to their department total.

---

## 🚀 Value of the Project

This project simulates a **real HR/Finance analytics scenario**, showing how SQL can be used to:

* Clean and standardize employee data.
* Answer complex workforce-related questions.
* Provide actionable insights for management decisions.

---
