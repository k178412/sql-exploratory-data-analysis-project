/*
Script: part_to_whole_analysis.sql

This script analyzes how different product categories contribute to total sales.
It calculates total sales for each category, determines its percentage of overall revenue, and ranks categories based on their contribution.
*/

--Find which category contribute the most to total sale.

with cat_sales_cte as(
select
	p.category_name,
	sum(s.sales_amount) as total_sales,
	sum(sum(s.sales_amount)) over() as overall_sale
from gold.fact_sales s
left join gold.dim_products p on p.product_key = s.product_key
group by p.category_name
)
select
	category_name,
	total_sales,
	overall_sale,
	cast(cast(total_sales as decimal) / overall_sale * 100 as decimal(10,1)) as percent_of_overall_sale,
	dense_rank() over(order by cast(cast(total_sales as decimal) / overall_sale * 100 as decimal(10,1)) desc) as rn
from cat_sales_cte
order by total_sales desc;
