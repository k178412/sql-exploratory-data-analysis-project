/*
Customers Report

Purpose:
This report consolidates key customer metrics to analyze purchasing behaviors and segmentation.

Highlights:
1. Displays essential details such as names, ages, and transaction history.
2. Segments customers into VIP, Regular, and New, along with age groups.
3. Provides customer-level metrics, including:
	Total orders
	Total sales
	Total quantity purchased
	Total products bought
	Customer lifespan (months)
4. Calculates key performance indicators (KPIs):
	Recency: Time since last purchase
	Average Order Value: Sales per order
	Average Monthly Spend: Spending trend over time

Usage:
	select * from report_customers;
*/

if object_id('report_customers', 'v') is not null
	drop view report_customers;
go

create or alter view report_customers as
with cte_customers_details as(
select
	c.customer_key,
	c.first_name,
	c.last_name,
	datediff(year, c.birth_date, getdate()) as age,
	count(distinct s.order_number) as total_orders,
	sum(s.sales_amount) as total_sales,
	sum(s.quantity) as total_quantity_purchased,
	count(distinct s.product_key) as total_products,
	max(s.order_date) as last_order,
	datediff(month, min(s.order_date), max(s.order_date)) as order_span
from gold.fact_sales s
left join gold.dim_customers c on c.customer_key = s.customer_key
group by c.customer_key,
				   c.first_name,
				   c.last_name,
				   datediff(year, c.birth_date, getdate())
),
cte_customers_segmentation as(
select
	customer_key,
	first_name,
	last_name,
	age,
	total_orders,
	total_sales,
	total_quantity_purchased,
	total_products,
	last_order,
	order_span,
	case when order_span > 12 and total_sales > 5000 then 'VIP'
			  when order_span > 12 and total_sales <= 5000 then 'Regular'
			  when order_span < 12 then 'New'
	end as customer_segment,
	case when age < 20 then 'under 20'
			  when age between 20 and 29 then '20-29'
			  when age between 30 and 39 then '30-39'
			  when age between 40 and 49 then '40-49'
			  else 'above 50'
	end as age_group
from cte_customers_details
),
cte_customers_kpis as(
select
	customer_key,
	first_name,
	last_name,
	age,
	total_orders,
	total_sales,
	total_quantity_purchased,
	total_products,
	last_order,
	order_span,	
	customer_segment,
	age_group,
	datediff(month, last_order, (select max(order_date) from gold.fact_sales)) as time_since_last_purchase,
	cast(cast(total_sales as decimal) / total_orders as decimal(10,2)) as avg_order_value,
	cast(cast(total_sales as decimal) / case when order_span = 0 then 1 else order_span end as decimal(10,2)) as avg_monthly_spend
from cte_customers_segmentation
)
select
	*
from cte_customers_kpis;
go
