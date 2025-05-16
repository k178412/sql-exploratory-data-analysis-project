-->>PERFORMANCE ANALYSIS

--Analyze the yearly performance of products by comparing each product's sales to both its average sales and previous sales.
with total_sales_cte as(
select
	p.product_name,
	year(s.order_date) as order_year,
	sum(s.sales_amount) as total_sales
from gold.fact_sales s
left join gold.dim_products p on p.product_key = s.product_key
group by p.product_name, year(s.order_date)
)
select	
	product_name,
	order_year,
	total_sales,
	avg(total_sales) over(partition by product_name) as avg_sale,
	total_sales - avg(total_sales) over(partition by product_name) as avg_diff,
	 case when total_sales - avg(total_sales) over(partition by product_name) > 0 then 'above avg'
			   when total_sales - avg(total_sales) over(partition by product_name) < 0 then 'below avg'
	end as avg_diff_remark,
	lag(total_sales, 1, 0) over(partition by product_name order by order_year) as prev_sale,
	total_sales - lag(total_sales, 1, 0) over(partition by product_name order by order_year) as prevsale_diff,
	case when total_sales - lag(total_sales, 1, 0) over(partition by product_name order by order_year) > 0 then 'above prev sale'
			  when total_sales - lag(total_sales, 1, 0) over(partition by product_name order by order_year) < 0 then 'below prev sale'
	end as prevsale_diff_remark
from total_sales_cte
order by product_name, order_year;