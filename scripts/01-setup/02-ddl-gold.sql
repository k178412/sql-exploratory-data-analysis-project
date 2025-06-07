/*
Script: 02-ddl-gold.sql

Purpose:
Creates the core tables used for analysis in the 'gold' schema.

Process Overview:
    - Checks if the tables already exist and drops them if they do.
    - Creates dimension tables: dim_customers and dim_products
    - Creates the fact table: fact_sales
*/

if object_id('gold.dim_customers', 'u') is not null
  drop table gold.dim_customers;
go
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

if object_id('gold.dim_products', 'u') is not null
  drop table gold.dim_products;
go
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

if object_id('gold.fact_sales', 'u') is not null
  drop table gold.fact_sales;
go
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
