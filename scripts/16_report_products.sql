/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Displays essential info such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

if object_id('report_products', 'v') is not null
	drop view report_products;
go

--Breaking all highlights in multiple CTEs to show them clearly. 
--(Note: Query will become more lengthy)

create or alter view report_products as
with cte_products_info as(
select
	product_key,
	product_name,
	category_name,
	subcategory,
	cost
from gold.dim_products
),
cte_products_aggregation as(
select
	p.product_key,
	p.product_name,
	p.category_name,
	p.subcategory,
	p.cost,
	count(distinct s.order_number) as total_orders,
	sum(s.sales_amount) as total_sales,
	sum(s.quantity) as total_quantity_sold,
	count(distinct s.customer_key) as distinct_customers,
	datediff(month, min(s.order_date), max(s.order_date)) as product_span,
	max(s.order_date) as last_order
from gold.fact_sales s
left join cte_products_info p on s.product_key = p.product_key
group by p.product_key,
				   p.product_name,
				   p.category_name,
				   p.subcategory,
				   p.cost
),
cte_products_segmentation as(
select
	product_key,
	product_name,
	category_name,
	subcategory,
	cost,
	total_orders,
	total_sales,
	total_quantity_sold,
	distinct_customers,
	product_span,
	last_order,
	case when total_sales > 1000000 then 'High-Performers'
			  when total_sales > 100000 then 'Mid-Performers'
			  else 'Low-Performers'
	end as product_segmentation
from cte_products_aggregation
),
cte_products_kpis as(
select
	product_key,
	product_name,
	category_name,
	subcategory,
	cost,
	total_orders,
	total_sales,
	total_quantity_sold,
	distinct_customers,
	product_span,	
	last_order,
	product_segmentation,
	datediff(month, last_order, (select max(order_date) from gold.fact_sales)) as months_since_last_sale,
	cast(cast(total_sales as decimal) / total_orders as decimal(10,2)) as avg_order_revenue,
	cast(cast(total_sales as decimal) / product_span as decimal(10,2)) as avg_month_revenue
from cte_products_segmentation
)
select
	*
from cte_products_kpis;
go



--Or, you can just merge those multiple CTEs work in one CTE. Query becomes short and precise.
/*
with cte_products as(
select
	p.product_key,
	p.product_name,
	p.category_name,
	p.subcategory,
	p.cost,
	count(distinct s.order_number) as total_orders,
	sum(s.sales_amount) as total_sales,
	sum(s.quantity) as total_quantity_sold,
	count(distinct s.customer_key) as distinct_customers,
	datediff(month, min(s.order_date), max(s.order_date)) as product_span,
	max(s.order_date) as last_order,
	case when sum(s.sales_amount) > 1000000 then 'High-Performers'
			  when sum(s.sales_amount) > 100000 then 'Mid-Performers'
			  else 'Low-Performers'
	end as product_segmentation
from gold.fact_sales s
left join gold.dim_products p on p.product_key=s.product_key
group by p.product_key,
				   p.product_name,
				   p.category_name,
				   p.subcategory,
				   p.cost
)
select
	product_key,
	product_name,
	category_name,
	subcategory,
	cost,
	total_orders,
	total_sales,
	total_quantity_sold,
	distinct_customers,
	product_span,	
	last_order,
	product_segmentation,
	datediff(month, last_order, (select max(order_date) from gold.fact_sales)) as months_since_last_sale,
	cast(cast(total_sales as decimal) / total_orders as decimal(10,2)) as avg_order_revenue,
	cast(cast(total_sales as decimal) / product_span as decimal(10,2)) as avg_month_revenue
from cte_products;
*/

