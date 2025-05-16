-->> DIMENSIONS EXLPORATION

--Explore all countries customers come from
select distinct country from gold.dim_customers;

--Explore different categories we have
select distinct category_name from gold.dim_products;

select distinct category_name, subcategory from gold.dim_products;

select distinct category_name, subcategory, product_name from gold.dim_products;