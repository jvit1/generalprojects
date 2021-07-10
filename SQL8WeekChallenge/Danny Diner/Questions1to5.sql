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
    count(customer_id) as Visits
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
select
	menu.product_name,
    count(sales.order_date) as total
from menu
join sales on sales.product_id = menu.product_id
group by product_name;

-- 5. Which item was the most popular for each customer?