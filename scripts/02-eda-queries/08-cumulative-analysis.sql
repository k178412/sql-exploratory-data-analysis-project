/*
Cumulative Analysis

This script analyzes aggregated/cumulative data trends over time.
It helps to understand whether our business is growing or declining.
*/

--Find total sales, running_total_sales, moving_average, percent difference from previous sales
select
	d.start_of_month,
	sum(s.sales_amount) as total_sales,
	sum(sum(s.sales_amount)) over(order by d.start_of_month) as running_total_sales,
	avg(avg(s.price)) over(order by d.start_of_month) as moving_avg_price
from gold.dim_dates d
left join gold.fact_sales s on s.order_date = d.date_key
group by d.start_of_month
order by d.start_of_month;
