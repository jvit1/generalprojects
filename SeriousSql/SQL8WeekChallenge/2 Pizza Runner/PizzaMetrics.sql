USE pizza_runner;

-- A. PIZZA METRICS
-- How many pizzas were ordered?
SELECT COUNT(*) as total
FROM customer_orders;

-- How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) as total
FROM customer_orders;

-- How many successful orders were delivered by each runner?
select 
	runner_id,
    count(distinct(order_id)) as total 
from runner_orders
where cancellation is null
	or cancellation not in ("Restaurant Cancellation", "Customer Cancellation")
GROUP BY runner_id
order by total;

-- How many of each type of pizza was delivered?
select
	P.pizza_name,
    COUNT(*) as delivered
FROM customer_orders AS C
INNER JOIN runner_orders AS R
	ON c.order_id = r.order_id
INNER JOIN pizza_names AS P
	ON c.pizza_id = p.pizza_id
WHERE r.cancellation IS NULL OR
	r.cancellation NOT IN ("Restaurant Cancellation", "Customer Cancellation")
GROUP BY pizza_name;

-- How many Vegetarian and Meatlovers were ordered by each customer?
SELECT
	customer_id,
    SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meatlovers,
    SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian
FROM customer_orders
GROUP BY customer_id;

-- What was the maximum number of pizzas delivered in a single order?
WITH maximum as(
	SELECT
		order_id,
        COUNT(*) as pizza_count,
        RANK() OVER(ORDER BY COUNT(*) DESC) AS count_rank
	FROM customer_orders as C
    WHERE EXISTS(
		SELECT order_id FROM runner_orders as R
        WHERE R.order_id = C.order_id
        AND (
			r.cancellation is NULL OR
            r.cancellation NOT IN ('Restaurant Cancellation','Customer Cancellation')
		)
	)
GROUP BY order_id
)
SELECT pizza_count FROM maximum WHERE count_rank = 1;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- How many pizzas were delivered that had both exclusions and extras?
WITH clean_orders AS(
	SELECT
		order_id,
        customer_id,
        pizza_id,
        CASE WHEN exclusions IN ('null' ,"") THEN NULL ELSE exclusions END AS exclusions,
        CASE WHEN extras IN ('null', "") THEN NULL ELSE extras END AS extras,
        order_time
	FROM customer_orders
)
SELECT COUNT(*) as exclusions_and_extras
FROM clean_orders
WHERE exclusions IS NOT NULL AND extras IS NOT NULL;
    
-- What was the total volume of pizzas ordered for each hour of the day?
-- What was the volume of orders for each day of the week?