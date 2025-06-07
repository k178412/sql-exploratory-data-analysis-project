/*
Script: 04-dates-table.sql

Purpose:
Creates the dim_dates table in the 'gold' schema to support calendar-based analysis.

Process Overview:
    - Drops the existing dim_dates table to ensure a clean setup.
    - Defines the dim_dates table with key date attributes for time-based analytics.
    - Uses a recursive CTE to populate the table with dates spanning the range in fact_sales.
    - Updates each date with additional details like weekday names, month abbreviations, and period start dates.

This table enables effective time-based slicing and dicing of sales and other data.
*/

-- Drop the existing dim_dates table if it exists to start fresh
drop table gold.dim_dates;
go

-- Create the dim_dates table with necessary columns for date attributes
create table gold.dim_dates (
	date_key date,
	calendar_year int,
	month_no int,
	month_short varchar(10),
	day_name varchar(20),
	day_of_week int,
	start_of_year date,
	start_of_quarter date,
	start_of_month date,
	start_of_week date,
	weekend varchar(20)
);
go

-- Use a recursive CTE to generate a list of all dates between the min and max order_date in fact_sales
with cte_dates as(
	select 
		min(order_date) as dates,
		max(order_date) as last_date
	from gold.fact_sales
	union all
	select 
		dateadd(day, 1, dates),
		last_date
	from cte_dates
	where dates < last_date
)
insert into gold.dim_dates (date_key)
select dates from cte_dates
option (maxrecursion 10000);
go

-- Update the dim_dates table to add detailed date attributes like year, month, day name, and period start dates
update gold.dim_dates
set
	calendar_year = year(date_key),
	month_no = month(date_key),
	month_short = left(datename(month, date_key), 3),
	day_name = datename(weekday, date_key),
	day_of_week = ((datepart(weekday, date_key) + 5) % 7) + 1,
	start_of_year = datetrunc(year, date_key),
	start_of_quarter = datetrunc(quarter, date_key),
	start_of_month = datetrunc(month, date_key),
	start_of_week = dateadd(day, -((datepart(weekday, date_key) + @@datefirst - 2) % 7), date_key),
	weekend = case when ((datepart(weekday, date_key) + 5) % 7) + 1 in (6, 7) then 'weekend'
								 else 'weekday'
						end;
go

-- Verify the contents of the dim_dates table
select * from gold.dim_dates;
go
