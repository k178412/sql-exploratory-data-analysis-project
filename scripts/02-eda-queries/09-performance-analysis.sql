/*
Performance Analysis

This script compares current value with target value and helps compare performance.
*/

--Analyze the yearly performance of subcategories by comparing each subcategories' sales to both its average sales and previous sales.
with cte as(
select
	p.subcategory,
	year(s.order_date) as year,
	sum(s.sales_amount) as total_sales,
	avg(sum(s.sales_amount)) over(partition by p.subcategory) as avg_sales,
	lag(sum(s.sales_amount),1,0) over(partition by p.subcategory order by year(s.order_date)) as prev_sales
from gold.fact_sales s
left join gold.dim_products p on p.product_key=s.product_key
where s.order_date is not null
group by p.subcategory, year(s.order_date)
)
select
	*,
	total_sales - avg_sales as diff_avg,
	case when total_sales - avg_sales > 0 then 'above avg'
				when total_sales - avg_sales < 0 then 'below avg'
				else 'same as avg'
	end as diff_avg_remark,
	total_sales - prev_sales as diff_prev,
	case when total_sales - prev_sales > 0 then 'above prev'
				when total_sales - avg_sales < 0 then 'below prev'
				else 'same as prev'
	end as diff_prev_remark
from cte
order by subcategory, year;
