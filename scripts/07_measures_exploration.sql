-->> MEASURES EXPLORATION

--Find the total sales
select sum(sales_amount) as total_sales from gold.fact_sales;

--Find how many items are sold
select sum(quantity) as total_quantity from gold.fact_sales;

--Find the average selling price
select avg(price) as avg_price from gold.fact_sales;

--Find the total no. of orders
select count(distinct order_number) as total_orders from gold.fact_sales;

--Find the total no. of products
select count(distinct product_name) as total_products from gold.dim_products;

--Find the total no. of customers
select count(distinct customer_id) as total_customers from gold.dim_customers;

--Find the total no. of customers that has placed an order
select count(distinct customer_key) as TotalCustomers_WhoPlaceAnOrder from gold.fact_sales;

--Generate a report that shows all key metrics
select 'TotalSales' as Measure, sum(sales_amount) as Value from gold.fact_sales
union all
select 'TotalQuantity', sum(quantity) from gold.fact_sales
union all
select 'AvgPrice',  avg(price) from gold.fact_sales
union all
select 'TotalOrders', count(distinct order_number) from gold.fact_sales
union all
select 'TotalProducts', count(distinct product_name) from gold.dim_products
union all
select 'TotalCustomers', count(distinct customer_id) from gold.dim_customers
union all
select 'TotalCustomersWhoPlaceAnOrder', count(distinct customer_key) from gold.fact_sales;