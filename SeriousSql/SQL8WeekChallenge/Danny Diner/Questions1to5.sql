-- 1. What is the total amount each customer spent at the restaurant?
select 
	sales.customer_id,
	sum(menu.price) as Total
from sales
join menu on sales.product_id = menu.product_id
group by customer_id;

-- 2. How many days has each customer visited the restaurant?
select
	customer_id,
    count(distinct order_date) as total
from sales
group by customer_id;

-- 3. What was the first item from the menu purchased by each customer?
select 
	sales.customer_id,
    min(sales.order_date),
    menu.product_name
from sales
join menu on sales.product_id = menu.product_id
group by customer_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
with table_quatro as
(
select 
	sales.customer_id,
    sales.order_date,
    sales.product_id,
    menu.price,
    menu.product_name
from sales
inner join menu
on sales.product_id = menu.product_id
)

select count(*) as total, product_name
from table_quatro
group by product_name
order by total desc
limit 1;

-- 5. Which item was the most popular for each customer?
