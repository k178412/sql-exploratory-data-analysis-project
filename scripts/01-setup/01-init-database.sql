/*
Script: init_database.sql

Purpose:
Sets up the 'DataWarehouseAnalytics' database from scratch to ensure a clean environment.

Process Overview:
    - Drops the existing database if it already exists.
    - Creates a fresh instance of the database.
    - Defines the 'gold' schema.

Run this script before executing any data load or analysis scripts.
*/

use master;
go

if exists (select 1 from sys.databases where name = 'DataWarehouseAnalytics')
begin
	alter database DataWarehouseAnalytics set single_user with rollback immediate;
	drop database DataWarehouseAnalytics;
end;
go

create database DataWarehouseAnalytics;
go

use DataWarehouseAnalytics;
go

create schema gold;
go
