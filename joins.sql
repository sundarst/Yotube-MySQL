CREATE SCHEMA yotube_mysql_joints;
use yotube_mysql_joints;

CREATE TABLE employee(employee_id INT primary key,name VARCHAR(100),department_id int);
INSERT INTO employee(employee_id,name,department_id)VALUES(1,"Alice",1);

INSERT INTO employee(employee_id,name,department_id)VALUES(2,"Bob",2),(3,"Charlie",1),(4,"David",3);
INSERT INTO employee(employee_id,name,department_id)VALUES(5,"eve",null);

SHOW TABLES;
SELECT * FROM employee;
CREATE TABLE departments(department_id INT primary key,department_name VARCHAR(100));
INSERT INTO departments(department_id,department_name)VALUES(1,"HR");
INSERT INTO departments(department_id,department_name)VALUES(2,"Engineering"),(3,"Marketing");
INSERT INTO departments(department_id,department_name)VALUES(4,"Finance");
SHOW TABLES;
SELECT * FROM departments;

#Inner Join
SELECT e.name,d.department_name
FROM employee e INNER JOIN departments d
ON e.department_id=d.department_id;

#LEFT JOIN 
SELECT e.name,d.department_name
FROM employee e LEFT JOIN departments d
ON e.department_id=d.department_id;

#RIGHT
SELECT employee.name,departments.department_name
FROM employee RIGHT JOIN departments
ON employee.department_id=departments.department_id;

#FULL OUTER JOIN
SELECT e.name,d.department_name
FROM employee e LEFT JOIN departments d
ON e.department_id=d.department_id
UNION
SELECT e.name,d.department_name
FROM employee e RIGHT JOIN departments d
ON e.department_id=d.department_id;

#CROSS JOIN
SELECT e.name,d.department_name
FROM employee e CROSS JOIN departments d;

ALTER TABLE employee ADD COLUMN(manager_id int);
UPDATE  employee SET manager_id=3 WHERE employee_id=1;
UPDATE employee SET manager_id=3 WHERE employee_id=2;
UPDATE employee SET manager_id=4 WHERE employee_id=3;
UPDATE employee SET manager_id=4 WHERE employee_id=4;

SELECT * FROM employee;

#SELF JOIN
SELECT e1.name AS employee ,e2.name AS manager
FROM employee e1,employee e2
WHERE e1.manager_id=e2.employee_id
AND e1.employee_id<e2.employee_id;












/*
1.What is Joints
*)In Real world data is store in seperated table for organization and efficiency
*)Insted of putting everythink in one table we split data into small related table
(By allowing use of normalized database structure.where data is split into different tables to reduce redundany )
Jonts help in efficiently managing and ordanizing data

2.Joint are used conjuction with Group by and aggregation function like (COUNT ,SUM,AVG) to perform comprehensive data analysis

3.Type of joining Table 
	1)Inner Join
    2)Left Join
    3)Right Join
    4)Full Outer Join
    5)Cross Join
    6)Self Join
    
---->Default Join is Inner Join
---->For joint column name not need to equal but balue should equal
1.Inner Join
	Select record that have macthing value in both tables
    _____________________________________
	|				|  |				|	
	|  left         |  |  right         |
    |               |  |                |
	|_______________|__|________________|

Syntax:
SELECT column_name From table1 Inner Join table2
ON
table1.column_name = table2.column_name

SELECT employee.name,department.department_name
FROM employee INNER JOIN department
ON employee.department_id=department.department_id

Join Three table
----------------------
SELECT table1.column_name,table2.column_name,table3.column_name
FROM ((Table1name 
INNER JOIN Table2 ON table1.column_name=table2.column_name)
INNER JOIN table3 ON table1.column_name=table3.column_name); 

2.Left Join 
	Select record all the record from the left table(table 1) and matching record if any from right table (table 2)

	_____________________________________
	|				|  |				|	
	|  left         |  |  right         |
    |               |  |                |
	|_______________|__|________________|
    
Syntax:
	SELECT table1.column_name,table2.column_name
    FROM table1
    LEFT JOIN table2
    ON table1.column_name=table2.column_name
    
3.Right join
    	Select record all the record from the right table(table 2) and matching record if any from left table (table 1)

	_____________________________________
	|				|  |				|	
	|  left         |  |  right         |
    |               |  |                |
	|_______________|__|________________|
    
Syntax:
	SELECT table1.column_name,table2.column_name
    FROM table1
    LEFT JOIN table2
    ON table1.column_name=table2.column_name
    
 4.Full Outer Join
	_____________________________________
	|				|  |				|	
	|  left         |  |  right         |
    |               |  |                |
	|_______________|__|________________|
    
    Syntax:
    SELECT  column_name
    FROM table 1
    FULL OUTER JOIN table 2
    ON table1.column_name=table2.column_name
    WHERE condition;
    
Can we write full outer join directly in Mysql ?
	No my sql does not support the full outer join keyword
if try this:
	you will get an erro in MYSQL
    
What to do in Mysql ?
LEFT JOIN
UNION
RIGHT JOIN

Query:
SELECT employee.name,department.departmentId
FROM employee
LEFT JOIN departments
ON employees.departmentId=departments.departmentId
UNION
SELECT employee.name,department.departmentId
FROM employee
RIGHT JOIN departments
ON employees.departmentId=departments.departmentId

5.Cross Join
Matches every row of one table with every row of another tables
return vaer large sets

Realtime project
1)E-commerce peoduct variants
T-shirt size (S,M,L,XL) colour (Red,Blue,Black)

Query:
SELECT s.size,c.colour
FROM size s
CROSS JOIN colour c

2)Cinema Ticket Booking System (cinema partner project)
	you have table of threater screen and table on showing timing
    
    
6.SELF JOIN
A self join is when you join table itself to compare row in same table 
syntax:
	SELECT t1.name as column_name,t2.name as column_name
    from table_name t1, sameTable_name t2
    
Query:
	SELECT a.name AS employees,b.name AS manager
    FROM employees a,employees b
    WHERE 
    a.manager_id=b.employee_id
    AND a.employee_id< b.employee_id
    
    
    Self join means joining a table with itself using INNER / LEFT join with aliases — it is not a new join type.
    
    AND: 
    to remove 
    self match 
    duplicate
    
    can achieve width range of data retrievl senarious from simple to complex
    
    
    




*/