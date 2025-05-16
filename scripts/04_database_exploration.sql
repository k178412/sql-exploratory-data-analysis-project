/*
Script: database_exploration.sql

This script helps explore the database structure.
*/

--Explore all objetcs in the database
select * from information_schema.tables;

--Explore all columns in the database
select* from information_schema.columns;

--Explore columns for a specific table
select* from information_schema.columns
where table_name = 'dim_customers';
