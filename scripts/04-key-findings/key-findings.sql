-- Key Findings

--1. Older Customers Drive the Most Orders
-- Customers aged 50 and above accounted for a majority of total orders (66%), while younger customers (30–39) contributed only 1%.

with cte as(
select
  age_group,
  sum(total_orders) as total_orders,
  sum(sum(total_orders)) over() as overall_orders
from report_customers
group by age_group
)
select
  *,
  cast((cast(total_orders as decimal)/overall_orders) * 100 as decimal(10,1)) as percent_of_overall_orders
from cte
order by percent_of_overall_orders desc;

--2. Low-Value Orders Dominate
-- Orders below $500 accounted for nearly 75% of all transactions, revealing a strong concentration of low-ticket purchases.

with cte1 as(
select
	 case when sales_amount > 2000 then 'above 2,000'
				when sales_amount between 1000 and 1999 then 'between 1000 and 1999'
				when sales_amount between 500 and 999 then 'between 500 and 999'
				when sales_amount < 500 then 'less than 500'
	end as sales_remark
from gold.fact_sales
),
cte2 as(
select
	sales_remark,
	count(*) as total_count,
	sum(count(*)) over() as overall_count
from cte1
group by sales_remark
)
select
	sales_remark,
	total_count,
	overall_count,
	cast(cast(total_count as decimal)/overall_count * 100 as decimal(10,1)) as percet_of_overall
from cte2
order by total_count desc;

--3. Average Sale Value Consistent Across Customer Group
-- Average sales ranged from $452 to $529 across all gender and marital status combinations, showing similar spending patterns.

select
	c.gender,
	c.marital_status,
	avg(s.sales_amount) as avg_sales_amount
from gold.fact_sales s
left join gold.dim_customers c on s.customer_key=c.customer_key
where c.gender != 'n/a'
group by c.gender, c.marital_status
order by c.gender, c.marital_status;

--4. Top Sales Contributors: US and Australia
-- Over 60% of total sales came from the United States (31.2%) and Australia (30.9%), making them the leading markets.

with cte as(
select
	c.country,
	sum(s.sales_amount) as total_sales,
	sum(sum(s.sales_amount)) over() as overall_sales
from gold.fact_sales s
left join gold.dim_customers c on s.customer_key=c.customer_key
where c.country != 'n/a'
group by c.country
)
select 
	*,
	cast(cast(total_sales as decimal)/overall_sales * 100 as decimal(10,1)) as percent_of_overall
from cte
order by total_sales desc;

--5. 2013 Was the Peak Sales Year
-- The year 2013 recorded the highest sales, making it the business’s best-performing year in the dataset.

select
	year(order_date) as year,
	sum(sales_amount) as total_sales,
	row_number() over(order by sum(sales_amount) desc) as rn
from gold.fact_sales
where year(order_date) is not null
group by year(order_date)

--6. Bikes Category Dominated Sales Across Years
-- Bikes consistently led all product categories, accounting for 96.46% of total sales highlighting Bikes as the company’s primary revenue driver year after year.

select
	year(s.order_date) as year,
	p.category_name,
	sum(s.sales_amount) as total_sales,
	row_number() over(partition by year(s.order_date) order by sum(s.sales_amount) desc)as rn
from gold.fact_sales s
left join gold.dim_products p on s.product_key=p.product_key
where year(s.order_date) is not null
group by p.category_name, year(s.order_date)
order by year(s.order_date), total_sales desc;
