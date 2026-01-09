/*
Id  FirstName   LastName     Age
1    Ravi         kumar       25
2    Arun         kumar       30
3    siva         Raj         28
*/
CREATE SCHEMA yotube_mysql_index;
use yotube_mysql_index;
CREATE TABLE Person(personId INT AUTO_INCREMENT PRIMARY KEY,firstName VARCHAR(100),lastName VARCHAR(100),Age INT);
INSERT INTO Person(firstName,lastName,Age)VALUES("Ravi","Kumar",25);
INSERT INTO Person(firstName,lastName,Age)VALUES("Arun","Kumar",30),("Siva","Raj",28);
SELECT * FROM Person;

#1.CRAETE INDEX
CREATE INDEX idx_lastname ON Person(lastName);
SELECT * FROM Person WHERE lastName='kumar';

#2.Composite Index (Multiple columns)
CREATE INDEX idx_composite ON Person(lastName,firstName);

SELECT * FROM Person WHERE lastName='kumar' AND firstName='Arun';

CREATE INDEX idx_composites ON Person(lastName,firstName,Age);
SELECT * FROM Person WHERE lastName='Kumar' AND firstName='Ravi' AND Age='25';

#3.DROP INDEX (Remove Index)
#============================
ALTER TABLE Person DROP INDEX idx_composite;

#4.SHOW INDEX
#=============
SHOW INDEX FROM Person;


/*When should you create an Index ?
		Columns used in :
			-->WHERE
            -->JOIN
            -->ORDER BY
            -->GROUP BY*/
            
#1.WHERE (Filtering)

   CREATE TABLE Users(UserId INT primary key,
    Name VARCHAR(50),
    Email VARCHAR(100),
    city VARCHAR(50)
    );
    
    ALTER TABLE Users MODIFY  UserId INT AUTO_INCREMENT;
    INSERT INTO Users(Name,Email,city)VALUES("shunmuga","shunmuga@gmail.com","Chennai");
     INSERT INTO Users(Name,Email,city)VALUES("sundaram","sundaram@gmail.com","Chennai"),("kutty","kutty@gmail.com","Chennai"),
     ("naveen","naveen@gmail.com","Chennai");
     INSERT INTO Users(Name,Email,city)VALUES("Aakesh","aakesh@gmail.com","Chennai");
     INSERT INTO Users(Name,Email,city)VALUES("Raja","rajah@gmail.com","Germany");
     INSERT INTO Users(Name,Email,city)VALUES("shunmugasundaram","shunmugasundaram@gmail.com","New york city");

SELECT * FROM Users;
SELECT * FROM Users WHERE email='sundaram@gmail.com';

#CREATE INDEX
CREATE UNIQUE INDEX idx_email ON Users(email);     

SELECT * FROM Users WHERE email='shunmugasundaram@gmail.com';

#3.Index with ORDER BY(Sorting) A-Z
#======================================
SELECT * FROM Users ORDER BY Name;
#if we lakhs of data use index to sorting and search fast

CREATE INDEX idx_name ON Users(Name);

#4.Index with Group By(Grouping)
#====================================
SELECT city,COUNT(*) AS PersonCount FROM Users GROUP BY (city);
# IF table have lakhs of data create index for fast search

CREATE INDEX idx_city_count ON Users(city);

SELECT city,COUNT(*) AS Count FROM Users GROUP BY (city);

#2.JOIN (Matching tables)
#=========================
CREATE TABLE Orders(
	Order_id INT primary key,
    UserId INT,
    Amount DECIMAL(10,2),
    FOREIGN KEY (UserId) REFERENCES Users( UserId) 
    );
    
    SELECT * FROM Users;
    INSERT INTO Orders(Order_id,UserId,Amount)VALUES(101,1,1200);
	INSERT INTO Orders(Order_id,UserId,Amount)VALUES(102,2,500);
    INSERT INTO Orders(Order_id,UserId,Amount)VALUES(103,3,800);
    INSERT INTO Orders(Order_id,UserId,Amount)VALUES(104,4,1900);
    INSERT INTO Orders(Order_id,UserId,Amount)VALUES(105,1,1600);
    
    SELECT * FROM Orders;
    
     SELECT * FROM Users;
     
    SELECT u.Name,o.Order_ID,o.Amount
    FROM Users u
    INNER JOIN Orders o ON u.userId=o.userId;
    
	SELECT u.Name,u.userId,o.Order_ID,o.Amount
    FROM Users u
    INNER JOIN Orders o ON u.userId=o.userId;
    
    SELECT city,COUNT(*) AS Count FROM Users GROUP BY (city);
    
    SELECT UserId,SUM(Amount)AS totalAmount
    FROM Orders
    GROUP BY UserId;
    
    CREATE INDEX idx_join_userId ON Users(userId);
    
    SHOW INDEX FROM Users;