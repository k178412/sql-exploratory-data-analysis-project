-->>CHANGE OVER TIME ANALYSIS

--Performance of sales over time
select * from gold.dim_dates;
select * from gold.fact_sales;
select * from gold.dim_products;

--without using dates table
select
	year(order_date) as order_year,
	month(order_date) as order_month,
	sum(sales_amount) as total_sales
from gold.fact_sales
where order_date is not null
group by year(order_date), month(order_date)
order by year(order_date), month(order_date); 
--or
select
	datetrunc(month, order_date) as order_month,
	sum(sales_amount) as total_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date)
order by datetrunc(month, order_date);

--with dates table
select
	d.start_of_month,
	sum(s.sales_amount) as total_sales
from gold.dim_dates d
left join gold.fact_sales s on s.order_date = d.date_key
group by d.start_of_month
order by d.start_of_month;