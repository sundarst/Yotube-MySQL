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
    
1NF (First Normal Form) 
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

2NF(Second Normal Form)
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
    

*/