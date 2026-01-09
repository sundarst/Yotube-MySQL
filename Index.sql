/*
1.What is Index in MYSQL?
A index like an index page in a book
	---> without index MYSQL scan every row (slow)
	---->with Index MYSQL scan every row (Fast)
	---> Book --- Database table 
    ---> page number --- Row location
2.Index are use to retrive data from data base quickly

3.The users cannot see the index .They are just used to speed the search queries

4.Insert slow down INSERT|UPDATE|DELETE because index also update 

5.Why do we need an Index ?
person
Id  FirstName   LastName     Age
1    Ravi         kumar       25
2    Arun         kumar       30
3    siva         Raj         28

If you run 
SELECT * FROM person WHERE LastName='kumar';
--> with out index slow check every row 
--> with index fast directly find kumar 

1.CRAETE INDEX (Normal Index)
===============================
Syntax:
	CRAETE INDEX index_name ON table_name(c1,c2,c3);
    Example:
		CRAETE INDEX index_lastName ON person(lastName);
	--> Allows duplicate values
    --> speed up search using lastName
    
CRAETE UNIQUE INDEX 
====================
	Does not allowed duplicate index
    similar to unique constraint 
    
    Syntax:
    CREATE UNIQUE INDEX index_name ON table_name(c1,c2,c3);
    Example:
		CREATE UNIQUE INDEX idx_email ON Users(Email);
        
        two user not have same email id 
use in: username,phone,email 
not use in: lastname,city
2.Composite Index (Multiple columns)
======================================
when to use ? 
	When queries use more than one column in WHERE
    Example 
		CREATE INDEX idx_name  ON persons(lastname,firstname);
used for queries
	SELECT * FROM person 
    WHERE lastName='kumar' AND firstName='Ravi';
   --> Not efficient for only (firstname)

3.DROP INDEX (Remove Index)
==========================
Syntax:
	ALTER TABLE table_name DROP INDEX index_name
Example:
ALTER TABLE person DROP INDEX idx_name;

4.How to see Index in a Table
=============================
SHOW INDEX FROM person

this show 
index-name
column_name
unique name

5.When should you create an Index ?
		Columns used in :
			-->WHERE
            -->JOIN
            -->ORDER BY
            -->GROUP BY
            
Why INDEX is need ?
-->imagine the table has 1 lakhs rows
	SELECT * FROM users WHERE Email='abc@gmail.com';
    
    without INDEX
    .)DB scan all 1 lakh rows
    with INDEX
    .)find row immediately 
    
    CRAETE TABLE Users(UserId INT primary key,
    Name VARCHAR(50),
    Email VARCHAR(100),
    city VARCHAR(50)
    );
    
1.WHERE (Filtering)
===================
		SELECT * FROM Users WHERE city='chennai';
---> without Index check all users
---> with Index Find only chennai Users

CREATE INDEX idx_city Users(city);
-->purpose fast filtering 

2.JOIN (Matching tables)
=========================
CRAETE TABLE Orders(
	Order_id INT primary key,
    UserId INT,
    Amount DECIMAL(10,2));
    
	UserTable
    userId   Name
    1        Arun
    2        Bala
    3        chitra
    
    
Order Table
    orderId   userId   Amount
    101         1        500
    102         1        1200
    103         2        750 
    
    Joint Query:
    =============
    SELECT u.name,o.Amount
    FROM Users u
    JOIN Orders o
    ON u.userId=o.userId;
    
    CRAETE INDEX idx_userId ON Users(userId);
    
  Output
  Name   Amount
  Arun     500
  Arun     1200
  Bala     750
  
 import point: Index does not change the output
  
3.Index with ORDER BY(Sorting) A-Z
===================================
Index:
	CREATE INDEX idx_name ON User(Name);
    
Query:
	SELECT * FROM User ORDER BY name;
    
4.Index with Group By(Grouping)
User table:
===========
---------------------------------
userId    Name      City
---------------------------------
	1     Arun     chennai
    2     Bala     chennai
    3     chitra   Madurai
    4     Deepak   Chennai
    5     Esha     Madurai
----------------------------------
Group By qurey
==============

SELECT city COUNT(*) AS COUNT
FROM Users
Group By city;

output:
=======
-----------------
City      Count
------------------
chennai     3
madurai     2
------------------

CREATE INDEX idx_city ON Users(city);

Do Not Index:
==============
1)Small tables
2)column rarely search 
3)Column Frequenty INSER|UPDATE|DELETE
4)Column with few Unique value(like gender)




*/