-->> DATES EXPLORATION   (Exploring the boundaries of dates)

--Find the first and last order date
select 
	min(order_date) as first_order, 
	max(order_date) as last_order,
	datediff(year, min(order_date), max(order_date)) as order_range_year
from gold.fact_sales;

--Find the youngest and oldest customer
select
	min(birth_date) as oldest_cust_birthdate,
	datediff(year, min(birth_date), getdate()) as oldest_cust_age,
	max(birth_date) as youngest_cust_birthdate,
	datediff(year, max(birth_date), getdate()) as youngest_cust_age
from gold.dim_customers;