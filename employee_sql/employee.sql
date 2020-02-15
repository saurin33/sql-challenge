COPY departments
(department_no, dept_name)
FROM '/Users/Shared/Docs/departments.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE departments
(
    department_no VARCHAR(20) PRIMARY KEY NOT NULL,
    dept_name VARCHAR(30)
);

COPY employees
(emp_no, birth_date, first_name, last_name, gender, hire_date)
FROM '/Users/Shared/Docs/employees.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE employees
(
    emp_no INT PRIMARY KEY,
    birth_date DATE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    hire_date DATE
);

COPY dept_emp
(emp_no, dept_no, from_date, to_date)
FROM '/Users/Shared/Docs/dept_emp.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE dept_emp
(
    id SERIAL PRIMARY KEY,
    emp_no INT,
    FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
    dept_no VARCHAR(20),
    from_date date,
    to_date date
);

COPY salaries
(emp_no, salary, from_date, to_date)
FROM '/Users/Shared/Docs/salaries.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE salaries
(
    emp_no INT PRIMARY KEY,
    salary INT,
    from_date DATE,
    to_date DATE
);

COPY dept_manager
(dept_no, emp_no, from_date, to_date)
FROM '/Users/Shared/Docs/dept_manager.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE dept_manager
(
    id SERIAL PRIMARY KEY,
    dept_no VARCHAR(20),
    emp_no INT,
    FOREIGN KEY(emp_no)REFERENCES employees(emp_no),
    from_date DATE,
    to_date DATE
);

COPY titles
(emp_no, title, from_date, to_date)
FROM '/Users/Shared/Docs/titles.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE titles
(
    id SERIAL PRIMARY KEY,
    emp_no INT,
    FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
    title VARCHAR(50),
    from_date DATE,
    to_date DATE
);
SELECT *
FROM departments;
SELECT *
FROM employees;

SELECT *
FROM dept_emp;
SELECT *
FROM dept_manager;

SELECT *
FROM salaries;
SELECT *
FROM titles;

SELECT
    e.emp_no,
    e.last_name,
    e.first_name,
    e.gender,
    s.salary
FROM employees e
    LEFT JOIN salaries s
    ON e.emp_no = s.emp_no;
--WHERE e.emp_no = 10002;

SELECT
    *
FROM employees
WHERE hire_date BETWEEN '01-01-1986' AND '12-31-1986';

--List the manager of each department with the following information: 
--department number, department name, the manager's employee number, 
--last name, first name, and start and end employment dates.

EXPLAIN ANALYZE
SELECT
    dm.dept_no,
    d.dept_name,
    dm.emp_no,
    e.last_name,
    e.first_name,
    dm.from_date,
    dm.to_date
FROM dept_manager dm
    LEFT JOIN departments d
    ON dm.dept_no = d.department_no
    LEFT JOIN employees e
    ON dm.emp_no = e.emp_no;

--List the department of each employee with the following information: employee number, 
--last name, first name, and department name.

SELECT
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
FROM employees e
    LEFT JOIN dept_emp de
    ON e.emp_no = de.emp_no
    LEFT JOIN departments d
    ON de.dept_no = d.department_no;

--List all employees whose first name is "Hercules" and last names begin with "B."
SELECT *
FROM employees
WHERE first_name = 'Hercules' AND last_name='B%'

--List all employees in the Sales department, including their employee number, 
--last name, first name, and department name.

SELECT
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
FROM employees e
    LEFT JOIN dept_emp de
    ON e.emp_no = de.emp_no
    LEFT JOIN departments d
    ON de.dept_no = d.department_no
WHERE d.dept_name = 'Sales';

--List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.

SELECT
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
FROM employees e
    LEFT JOIN dept_emp de
    ON e.emp_no = de.emp_no
    LEFT JOIN departments d
    ON de.dept_no = d.department_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';

--In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.

SELECT
    last_name,
    COUNT(last_name) AS total
FROM employees
GROUP BY last_name
ORDER BY total DESC;