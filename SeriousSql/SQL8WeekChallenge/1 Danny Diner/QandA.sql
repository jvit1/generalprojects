-- CASE STUDY 1: DANNY'S DINER --
use dannydiner;
-- What is the total amount each customer spent at the restaurant?
select 
	sales.customer_id,
	sum(menu.price) as Total
from sales
join menu on sales.product_id = menu.product_id
group by customer_id
order by customer_id asc;

-- How many days has each customer visited the restaurant?
SELECT
  customer_id,
  COUNT(DISTINCT order_date) AS total
FROM sales
GROUP BY customer_id;

-- What was the first item purchased by each customer?
WITH first_order AS(
	SELECT
    sales.customer_id,
    menu.product_name,
    row_number() OVER(
    partition by sales.customer_id
    ORDER BY sales.order_date, menu.product_id
    ) AS item_order
FROM sales
JOIN menu ON sales.product_id = menu.product_id
)

SELECT * FROM first_order
WHERE item_order = 1;

-- What is the most purchased item on the menu and how many times was it purchased?
SELECT
	menu.product_name,
    COUNT(sales.product_id) as total
FROM sales
INNER JOIN menu ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY total DESC
LIMIT 1;

-- What was the most popular item for each customer?
WITH popular as(
select
	sales.customer_id,
    menu.product_name,
    count(sales.product_id) as total,
    rank() over(
    partition by sales.customer_id
    order by count(sales.product_id) DESC)
    as item_rank
    FROM sales
    inner join menu on sales.product_id = menu.product_id
    GROUP BY sales.customer_id, menu.product_name)
    
    SELECT customer_id,
    product_name
    total
    FROM popular
    WHERE item_rank = 1;
    
    -- Create a temp table to check if the customer is a member or not (member_validation). This will help with later questions.
    drop table if exists mem_validate;
    create temporary table mem_validate
    as select
    sales.customer_id,
    sales.order_date,
    menu.product_name,
    menu.price,
    members.join_date,
    case when members.join_date <= sales.order_date then "Y"
    ELSE "N"
    END AS membership
    
    FROM sales
    INNER join menu ON sales.product_id = menu.product_id
    LEFT JOIN members ON sales.customer_id = members.customer_id
    WHERE join_date is not null
    ORDER by sales.customer_id,
    sales.order_date;
    
    select *
    from mem_validate;
    
-- Which item was first purchased after becoming a member?
with first_purchase as(
select
mem_validate.customer_id,
mem_validate.product_name,
mem_validate.join_date,
rank() over(
partition by mem_validate.customer_id
order by mem_validate.order_date) as item_rank
from mem_validate
where membership = "Y"
)

select *
from first_purchase
where item_rank = 1; 

-- Which item was purchased just before becoming a member?
with before_mem as(
select mem_validate.customer_id,
mem_validate.product_name,
mem_validate.join_date,
rank() over(
partition by mem_validate.customer_id
order by mem_validate.order_date desc)
as item_rank
from mem_validate
where membership = "N")

select *
from before_mem
where item_rank = 1;

-- What is the total items and amount spent before becoming a member?
with spent_before as(
select
customer_id,
product_name,
order_date,
price,
rank() over(partition by customer_id
order by order_date desc)
as item_order
FROM mem_validate
where membership ='N'
)

select
customer_id,
count(*) as total_item,
sum(price) as total
from spent_before
group by customer_id
order by customer_id;

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT customer_id,
	sum(case when product_name ='sushi' then (price*10*2)
    else (price*10)
    end) as points
from sales
left join menu on sales.product_id = menu.product_id
group by customer_id
order by customer_id;

-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT 
	customer_id,
    SUM(
      CASE 
      	WHEN product_name = 'sushi' THEN (price*10*2)
      	WHEN order_date BETWEEN join_date AND (join_date + 6)
      		THEN (price*10*2)
      ELSE (price*10)
      END
    ) AS points  	
FROM mem_validate
WHERE order_date < '2021-02-01'
GROUP BY customer_id
ORDER BY points DESC;