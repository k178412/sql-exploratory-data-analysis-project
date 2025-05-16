/*
This script creates 
	A database 'DataWarehouseAnalytics',
	A schema 'gold',
	and 3 tables.
This script also checks if the database with the name 'DataWarehouseAnalytics' already exists,
and if it does then drop that database in that case and recreate a new one.
- dim_customers – Stores customer details like name, birthdate, and country.
- dim_products – Contains product information, including category and cost.
- fact_sales – Holds order details like sales amounts, quantities, and dates.

*/

use master;
go

if exists (select 1 from sys.databases where name = 'DataWarehouseAnalytics')
begin
	print char(10) + '-------------------------------------------------' + char(10);
	print '>Database ''DataWarehouseAnalytics'' already exists.';
	alter database DataWarehouseAnalytics set single_user with rollback immediate;
	drop database DataWarehouseAnalytics;
	print '>Existing database dropped.';
	print char(10) + '-------------------------------------------------' + char(10);
end;
go

create database DataWarehouseAnalytics;
print '>Fresh database ''DataWarehouseAnalytics'' created.';
go

use DataWarehouseAnalytics;
print '>Database ''DataWarehouseAnalytics'' is now in use.';
print char(10) + '-------------------------------------------------' + char(10);
go

create schema gold;
go
print '>Schema ''gold'' created.';
print char(10) + '-------------------------------------------------' + char(10);

create table gold.dim_customers (
	customer_key int,
	customer_id int,
	customer_number  varchar(50),
	first_name varchar(50),
	last_name varchar(50),
	gender varchar(50),
	marital_status varchar(50),
	birth_date date,
	country varchar(50),
	create_date date
);
go
print '>Table ''gold.dim_customers'' created.';

create table gold.dim_products (
	product_key int,
	product_id int,
	product_number varchar(50),
	product_name varchar(50),
	category_id varchar(50),
	category_name varchar(50),
	subcategory varchar(50),
	maintenance varchar(50),
	cost int,
	product_line varchar(50),
	start_date date
);
go
print '>Table ''gold.dim_products'' created.';

create table gold.fact_sales (
	order_number varchar(50),
	product_key int,
	customer_key int,
	order_date date,
	ship_date date,
	due_date date,
	sales_amount int,
	quantity int,
	price int
);
go
print '>Table ''gold.fact_sales'' created.';
print char(10) + '-------------------------------------------------' + char(10);




