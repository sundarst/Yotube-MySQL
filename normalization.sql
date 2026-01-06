CREATE SCHEMA yotube_normalization;
use yotube_normalization;
CREATE TABLE student_mark(student_id INT,student_name VARCHAR(100) NOT NULL,
course_id INT,cousre_name VARCHAR(100),student_mark INT,PRIMARY KEY(student_id,course_id));

ALTER TABLE student_mark RENAME COLUMN cousre_name TO course_name;
INSERT INTO student_mark(student_id,student_name,course_id,course_name,student_mark)VALUES(1,"Alice",101,"Maths",85);

INSERT INTO student_mark(student_id,student_name,course_id,course_name,student_mark)VALUES(2,"Bob",102,"Physics",90),
(3,"Charlie",103,"Chemistry",75),(4,"David",104,"Biology",88),(5,"Eva",105,"Computer Science",92);

SELECT * FROM student_mark;

CREATE TABLE student_list(student_id INT PRIMARY KEY,student_name VARCHAR(100));

INSERT INTO student_list(student_id,student_name)
SELECT DISTINCT	student_id,student_name FROM student_mark;

DELIMITER //
CREATE TRIGGER student_list_trigger
AFTER INSERT ON student_mark
FOR EACH ROW
BEGIN 
	INSERT INTO student_list(student_id,student_name)VALUES(NEW.student_id,NEW.student_name);
END //
DELIMITER ;

SELECT * FROM student_list;  

CREATE TABLE course_list(course_id INT PRIMARY KEY,course_name VARCHAR(100));
SELECT * FROM course_list;

INSERT INTO course_list(course_id,course_name)
SELECT DISTINCT course_id,course_name FROM student_mark;

#automatic sent data to course_list

DELIMITER //
CREATE TRIGGER course_list_trigger
AFTER INSERT ON student_mark
FOR EACH ROW
BEGIN
	INSERT INTO course_list(course_id,course_name)VALUES(NEW.course_id,NEW.course_name);
END //
DELIMITER ;

CREATE TABLE result(student_id INT,student_name VARCHAR(100),course_id INT,mark INT, 
PRIMARY KEY(student_id,course_id),
FOREIGN KEY (student_id) REFERENCES student_list(student_id),
FOREIGN KEY (course_id) REFERENCES course_list(course_id));

SELECT * FROM result;

DELIMITER //
CREATE TRIGGER result_trigger
AFTER INSERT ON student_mark
FOR EACH ROW
BEGIN
	INSERT INTO result(student_id,student_name,course_id,student_mark)VALUES(NEW.student_id,NEW.student_name,NEW.course_id,NEW.student_mark);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS result_trigger;
SELECT * from student_mark;
SELECT * FROM result;

#Data migration
INSERT INTO result(student_id,student_name,course_id,mark)
SELECT distinct student_id,student_name,course_id,student_mark FROM student_mark;

SELECT * FROM student_list;
	
SELECT s.student_id,c.course_id,m.student_mark
FROM student_mark m
JOIN student_list s ON s.student_id=m.student_id
JOIN course_list c ON c.course_id=m.course_id;
#_________________________________________________________________________________________________________________________________________

#3NF
CREATE  TABLE  result_3nf(student_id INT,course_id INT,mark INT,
PRIMARY KEY(student_id,course_id),
FOREIGN KEY (student_id) REFERENCES student_list(student_id),
FOREIGN KEY (course_id) REFERENCES course_list(course_id));


/*
1.Normalization  is a database schema design technique.By which an existing schema is modifyied
to minimize redundancy and dependency of data 

2.split the large table into small table .And  incress the clarity in organizing data

3.What is Advantage ?
    1.Eliminate Redundancy data      → Extra data not really needed
	2.Avoid Duplicate                → Same data repeated
    3.Data Consistency 			     -> Data values match correctly across systems
    4.Data Mantaince Easy
    5.Storage Efficient 
    
6. How many type of normalization ?
	* 1NF
    * 2NF
    * 3NF
    * BCNF
    * 4NF
    * 5NF
    
1)1NF (First Normal Form) 
	-> Each column is unique in 1NF
				(or)
    -> Each table cell should have Single value
    
	-------------------------------------
	Employee | Age | Department
	--------------------------------------
	Melvin   | 32  | Marketing, Sales
	Eduard   | 45  | Quality Assurance
	Alex     | 36  | Human Resource
    --------------------------------------
❌ Problem in this table
Department column has multiple values (Marketing, Sales)
This violates First Normal Form (1NF)
👉 Rule of 1NF
Each column must contain atomic (single) values

		Employee | Age | Department
	---------------------------------
	Melvin   | 32  | Marketing
	Melvin   | 32  | Sales
	Eduard   | 45  | Quality Assurance
	Alex     | 36  | Human Resource
____________________________________________________________________________________________________________________

1) 2NF(Second Normal Form)
			   _____________ Should satisfy 1NF	
    ----------/
			  \______________  Should not allowed Partial Dependency 
	? Happens when the primary key is composite (Made of 2 or more pk column)
    
    Ex Bad --> partial Dependency 
    Pk-->(student_id,course_id)
	marks table depends on both 
    
    Fix (Good 2NF)
	student -->(Student_id ,Student_name)
    course  -->(course_id,course_name)
	Marks   -->(Student_id,course_id,Marks)
    
    In 2NF, we start from a single table and split it into related tables to remove partial dependency. Easier viewing is a 
    benefit, not the goal.
______________________________________________________________________________________________________________________________
3)Third Normal Form (3NF)

			   _____________   Should satisfy 2NF	
    ----------/
			  \______________  Should not have Transitive Function 
              
    A--------------B yes
    B--------------C yes
    A--------------C No
    
    ----------------------------------
	| Situation              | 3NF?  |
	| ---------------------- | ----- |
	| PK → Non-key           | ✅ Yes |
	| (PK1, PK2) → Non-key   | ✅ Yes |
	| Non-key → Non-key      | ❌ No  |
	| PK → Non-key → Non-key | ❌ No  |
	|  (pk1,pk2,pk3)         |   yes |
    | Non-key → Prime-key    | yes   |
    ----------------------------------
    
    
1.If we should not followed this what heppend ?
---->Data base will have duplicate data inconsistency in (Update,insert,delete)

2.Why this design is CORRECT (3NF logic)

student_list → master table

course_list → master table

result_3nf → relation/transaction table

3.This is proper 3NF design:

No redundancy

No transitive dependency

Clear parent–child relationship

4. Visual memory
Index exists	             FK allowed
(student_id, course_id)	        ❌ course_id alone
(student_id)	                ✅
(course_id)                 	✅

_______________________________________________________________________________________________________________________________________
4)BCNF (Boyce codd Normal Form)

			   _____________   Strick version 3 NF	
    ----------/
			  \______________  also called as 3.5 NF

Even 3NF sometime share can still be inconsistency BCNF says
BCNF rule
	For every function dependency (X->Y) x must be a super key.if not BCNF is violation
    
3NF (SLIGHTLY RELAXED RULE)
	A table  in 3NF it for every X->Y at least one super key
    x is super key
        (or)
	Y is prime attribute
    
Normal Form	Condition
	3NF	X or Y  ----> must be a key
	BCNF	    ----> X must be a key
    
   1. BCNF says  table have only candidate key it was wrong understand
   2. coulmn must a candidate key 
   
Big Table in BCNF (Multiple Determinants)
EmployeeLogin
----------------------------------
emp_id        PRIMARY KEY
email         UNIQUE
username      UNIQUE
password
created_at

❌ Big table NOT in BCNF (for contrast)
EmployeeDept
----------------------------------
emp_id PRIMARY KEY
emp_name
dept_id
dept_name
    
✅ Correct:
A BCNF table can have many non-key columns.
BCNF does not limit the table to only keys.

Example (BCNF):

Student(student_id PK, name, place)

✅ Correct:

Column order has no meaning in normalization

BCNF does not care about “first column”

BCNF cares only about this rule:

For every functional dependency X → Y, X must be a super key


BCNF is about dependencies, not column position or number of columns.
Student
---------------------------
name
student_place
student_id   PRIMARY KEY 

BCNF depends only on functional dependencies, not on column order or how many columns the table has.

Every BCNF table is automatically 3NF.But not every 3NF is in BCNF 
The table is in 3NF because there is no transitive dependency .it is in BCNF because the primary key determines all the attribute


All the function dependencies satisfy BCNF must have primary key(mandatory) UK(option)

____________________________________________________________________________________________________________________________________________
5) 4NF
	
			   _____________   Should be in BCNF
    ----------/
			  \______________  It should not have multi value dependency(MVD)
              
              FOR one value A there are multiple independent value in B and cache C 
              B depends only A 
              c depends only A 
              
              But B and C are independly each other  this create redundancy
              
              Before 4 NF table have atleast 3 column .if not have 3 column not sastify
              
		Table 1
              student    Hobby        Language
              John      football      English
			  John      football      French
			  John      chess         English
			  John      chess         French
              
		Table 2 
			  student         Hobby
              John            Footbal
              john            chess
              
		Table 3
			 student            Language
             john                English
             john                french
             
             
             No redundancy
             No Multiple value dependency  This satisfies 4Nf
             
4NF remove multivalue dependencies A->B and A->C  exist then B and C must not be stored together in one table because they 
are independent 

3NF  remove transitive dependency (A->B->C)
4NF  remove multiple value dependency (A->B and A->C)
_________________________________________________________________________________________________________________________________________

Base De-Normalized Table
=========================
EmpId,EmpName,DepId,DepName,projId,ProjName,ManagerId,ManagerName
	
						Normilized Table
							   |
                               |
							  \ /
2NF 
|---------------|    | ------------------|   |--------------|    |------------------|
|Employee Table |    |Department Table   |   |Project Table |    |  Manager Table   |
|---------------|    |-------------------|   |--------------|    |------------------|
|   EmpId -p	|	 | 	     DepId -p	 |	 |	 ProjId  -p |    |   MangerId -p    |
|   EmpName		|	 |	     DepName	 |	 |	 ProjName   |    |  ManagerName     |
--------------------------------------------------------------------------------------
4NF 
Employee Project Table		Employee Department Table        Employee Manager Table 
EmpId-F                     EmpId -F                             EmpId-F 
DepId -F                    DepId  -F                            ManagerId -F  
projId 









*/