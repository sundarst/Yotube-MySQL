CREATE SCHEMA yotube_trigger;
use  yotube_trigger;
CREATE TABLE student(id int  PRIMARY KEY AUTO_INCREMENT,name VARCHAR(100),grade CHAR(1));

CREATE TABLE student_log(id INT PRIMARY KEY AUTO_INCREMENT,student_id INT NOT NULL,
action_time TIMESTAMP DEFAULT current_timestamp,
action VARCHAR(7));

#AFTER (INSERT)
DELIMITER //
CREATE TRIGGER after_student_insert
AFTER INSERT
ON student
FOR EACH ROW
BEGIN
INSERT INTO student_log(student_id,action)
VALUE(NEW.id,'INSERT');
END //
DELIMITER ;

INSERT INTO  student(name,grade)VALUES("shunmugasundaram","A");
INSERT INTO  student(name,grade)VALUES("sundar","A");

SELECT * FROM student_log;

#BEFORE (DELETE)
CREATE TABLE student_del(id INT PRIMARY KEY AUTO_INCREMENT,student_id INT NOT NULL,student_name VARCHAR(100),action VARCHAR(7));

DELIMITER //
CREATE TRIGGER before_delete_student
BEFORE DELETE ON student
FOR EACH ROW
BEGIN
	INSERT INTO student_del(student_id,name,grade,action)VALUE(OLD.id,OLD.name,OLD.grade,"DELETE");
END //
DELIMITER ;

DROP TRIGGER IF EXISTS before_delete_student;
SELECT * FROM student;

DELETE FROM student WHERE id =1;

SELECT * FROM student_del;

drop table student_del;














/*
1.What is Trigger ?
Trigger are specialized procedures that automatically respond to certain event on a table (or) view

2.What are evnt are use ?
These events inculde action such as INSER,UPDATE,DELETE

3.Triggers can be used to enforce complex business rules audit trails (or) synchronized data across table

Automating and making sure of integrity of data opeations(INSERT,UPDATE,DELETE)

Create Trigger
Syntax:
	CREATE TRIGGER trigger_name
    {Before |After} {INSERT|UPDATE|DELETE}
    ON table_name
    FOR EACH ROW
    BEGIN
		--- Syntax
	END;

*/