/*
Script: dates_table.sql

This script creates the dim_dates table inside the gold schema for calendar-based analysis.
It first removes the existing table to start fresh. Then, it defines the table structure with columns for year, month, day, and important date attributes. 
A recursive CTE fills the table with dates based on the range in fact_sales. 
Finally, an update step adds details like weekdays, month names, and period start dates.
*/

drop table gold.dim_dates;
go

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

select * from gold.dim_dates;
go
