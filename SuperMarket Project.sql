CREATE DATABASE Project_S;

USE Project_S;

-- import the csv file  

SELECT * FROM superstore;

-- need to create dimension tables so let's create each table with a primary key for any one column(id)
-- creating dimention Tables and inserting records into table by using subquery

-- DIM_CUSTOMER 

CREATE TABLE dim_Customer (
	Customer_id INT AUTO_INCREMENT PRIMARY KEY ,
    Customer_type varchar(100)
);

INSERT INTO dim_Customer ( Customer_type )				
( SELECT DISTINCT Customer_type FROM superstore);

SELECT * FROM dim_Customer;								-- source Table-1


-- DIM_PRODUCT

CREATE TABLE dim_Product(
	Product_id 	INT AUTO_INCREMENT PRIMARY KEY,
    Product_code VARCHAR(100),
    Product_line VARCHAR(100)
);

INSERT INTO dim_Products (Product_code , Product_line)
(SELECT DISTINCT Product_code , Product_line FROM superstore);

SELECT * FROM dim_Products;								-- source Table-2


-- DIM_LOCATION

CREATE TABLE dim_Location (
	Location_id INT AUTO_INCREMENT PRIMARY KEY ,
	City VARCHAR(100),
	Branch VARCHAR(30)
);

INSERT INTO dim_Location ( City, Branch)
( SELECT DISTINCT City, Branch FROM superstore);

SELECT * FROM dim_Location;								-- source Table-3


-- FACT_TABLE - target table

CREATE TABLE Fact_Table (
	Invoice_ID VARCHAR(50) NOT NULL,
    Location_id INT NOT NULL,
    Customer_id INT NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    Product_id INT NOT NULL,
    Unit_price DOUBLE NOT NULL,
    Quantity INT NOT NULL,
    Tax DOUBLE NOT NULL,
    Total DOUBLE NOT NULL,
    Date VARCHAR(30) NOT NULL,
    Time VARCHAR(20) NOT NULL,
    Payment VARCHAR(40) NOT NULL,
    cogs DOUBLE NOT NULL,
    gross_margin_percentage DOUBLE NOT NULL,
    gross_income DOUBLE NOT NULL,
    Rating DOUBLE NOT NULL
);

SELECT * FROM  Fact_Table;

INSERT INTO Fact_Table (
	Invoice_ID, Location_id, Customer_id, Gender, Product_id, Unit_price, Quantity, Tax, Total, Date, Time, Payment, cogs, gross_margin_percentage, gross_income, Rating)
(SELECT ss.Invoice_ID, dim_location.Location_id, dim_customer.Customer_id, ss.Gender, dim_products.Product_id, ss.Unit_price, ss.Quantity, ss.Tax, ss.Total, ss.Date, ss.Time, ss.Payment, ss.cogs, ss.gross_margin_percentage, ss.gross_income, ss.Rating
	FROM superstore AS ss

-- DIM_Location		- JOIN
JOIN dim_Location
ON ss.Branch = dim_location.Branch

-- DIM_customer		- JOIN
JOIN dim_customer
ON ss.Customer_type = dim_customer.Customer_type

-- DIM_products		- JOIN
JOIN dim_products
ON ss.Product_code = dim_products.Product_code);

SELECT * FROM Fact_Table; 

-- selecting a specific row in Fact_Table -by using Where

SELECT * FROM fact_table
WHERE Invoice_ID = '750-67-8428';

DROP TABLE superstore;