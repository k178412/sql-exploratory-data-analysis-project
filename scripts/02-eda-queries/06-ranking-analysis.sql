/*
Script: ranking_analysis.sql

This script ranks products based on their sales performance.
*/

--Find 5 products generating highest revenue
select * from(
select
	p.product_name,
	sum(s.sales_amount) as total_revenue,
	dense_rank() over(order by sum(s.sales_amount) desc) as rn
from gold.fact_sales s
left join gold.dim_products p on s.product_key = p.product_key
group by p.product_name
)x
where rn<=5
order by total_revenue desc;

--Find 10 worst products in terms of sales
select
	top 10 with ties
	p.product_name,
	sum(s.sales_amount) as total_sales
from gold.fact_sales s
left join gold.dim_products p on s.product_key = p.product_key
group by p.product_name
order by total_sales;
