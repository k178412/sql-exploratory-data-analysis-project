/*
Script: data_segmentation.sql

This script segments products and customers for analysis.
It classifies products into different cost ranges and counts how many fall into each category. 
It also groups customers based on their spending history and duration, categorizing them as VIP, Regular, or New.
*/

--Segment products into cost ranges and count how many products fall in each segment?

with cost_segments_cte as(
select
	product_name,
	cost,
	case when cost < 100 then 'below 100'
			  when cost between 100 and 500 then '100-500'
			  when cost between 501 and 1000 then '501-1000'
			  when cost between 1001 and 2000 then '1001-2000'
			  else 'above 2001'
	end as cost_segments
from gold.dim_products
)
select
	cost_segments,
	count(*) as prdcts_in_sgmnt
from cost_segments_cte
group by cost_segments
order by prdcts_in_sgmnt desc;


--Segment customers into 3 groups based on their spending behaviour:
--				VIP- Customers with atleast 12 months of history and spending of more than 5000
--				Regular- Customers with atleast 12 months of history and spending of 5000 and less
--				New- Customers with history less than 12 months
--and find total no. of customers by each group.

with customers_segment_cte as(
select
	c.customer_key,
	sum(s.sales_amount) as total_sales,
	min(s.order_date) as earliest_order,
	max(s.order_date) as latest_order,
	datediff(month, min(s.order_date), max(s.order_date)) as order_gap,
	case when datediff(month, min(s.order_date), max(s.order_date)) > 10 and sum(s.sales_amount) > 5000 then 'VIP'
	          when datediff(month, min(s.order_date), max(s.order_date)) > 10 and sum(s.sales_amount) <= 5000 then 'Regular'
			  when datediff(month, min(s.order_date), max(s.order_date)) < 10 then 'New'
	end as customers_segment
from gold.fact_sales s
left join gold.dim_customers c on c.customer_key=s.customer_key
group by c.customer_key
)
select
	customers_segment,
	count(*) as total_customers
from customers_segment_cte
group by customers_segment
order by total_customers desc;


