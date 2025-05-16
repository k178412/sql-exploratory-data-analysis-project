/*
Script: ddl_load_data.sql

This script loads data from CSV files into the 'gold' schema tables. 
Before inserting, it truncates the tables to clear old data. 
It then uses 'BULK INSERT' to efficiently load data into dim_customers, dim_products, and fact_sales, ensuring clean and updated tables.
*/

print char(10) + '-------------------------------------------------' + char(10);
print '>Truncating table ''gold.dim_customers''...';
truncate table gold.dim_customers;
go
print '>Bulk inserting data into ''gold.dim_customers''...';
bulk insert gold.dim_customers
from 'D:\Skills\SQL Data Warehouse Analytics Project\Datasets\gold.dim_customers.csv'
with (
	firstrow = 2,
	fieldterminator = ','
);
go
print char(10) + '-------------------------------------------------' + char(10);

print '>Truncating table ''gold.dim_products''...';
truncate table gold.dim_products;
go
print '>Bulk inserting data into ''gold.dim_products''...';
bulk insert gold.dim_products
from 'D:\Skills\SQL Data Warehouse Analytics Project\Datasets\gold.dim_products.csv'
with (
	firstrow = 2,
	fieldterminator = ','
);
go
print char(10) + '-------------------------------------------------' + char(10);

print '>Truncating table ''gold.fact_sales''...';
truncate table gold.fact_sales;
go
print '>Bulk inserting data into ''gold.fact_sales''...';
bulk insert gold.fact_sales
from 'D:\Skills\SQL Data Warehouse Analytics Project\Datasets\gold.fact_sales.csv'
with (
	firstrow = 2,
	fieldterminator = ','
);
go
print char(10) + '-------------------------------------------------' + char(10);


