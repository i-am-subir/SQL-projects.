-- First, we are going to create a database called pizza_sales. 
-- Data was already uploaded to the data folder in the pizza sales, 
-- so we will import that data through the table data import wizard 
-- following the table names order_details, orders, pizza_types, and pizzas. 
-- Then we successfully created our database for the analysis.

-- Let's solve the following questions which were uploaded in the project overview.



-- ----------------------------------------------------------------------------------

show databases;

use pizza_sales;

-- ----------------------------------------------------------------------------------


-- Retrieve the total number of orders placed.


SELECT 
    COUNT(order_id) AS total_orders
FROM
    pizza_sales.orders;
    
    
-- -----------------------------------------------------------------------------------
    
    
 -- Calculate the total revenue generated from pizza sales.


SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Total_Revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.Pizza_id;
    
    
-- -------------------------------------------------------------------------------------    


-- Identify the highest-priced pizza.


SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;
    
    
-- ---------------------------------------------------------------------------------------


-- Identify the most common pizza size ordered.



SELECT 
    pizzas.size,
    COUNT(order_details.Order_details_ID) AS order_placed
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.Pizza_id
GROUP BY pizzas.size
ORDER BY order_placed DESC; 


-- ----------------------------------------------------------------------------------------


-- List the top 5 most ordered pizza types along with their quantities.



SELECT 
    pizza_types.name, SUM(order_details.quantity) AS Qty
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Qty DESC
LIMIT 5;


-- -----------------------------------------------------------------------------------------


-- Join the necessary tables to find the total quantity of each pizza category ordered.



SELECT 
    pizza_types.category, SUM(order_details.quantity) AS Qty
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.Pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Qty DESC;

-- ------------------------------------------------------------------------------------------


-- Determine the distribution of orders by hour of the day.



SELECT 
    HOUR(order_time) AS hours, COUNT(order_id) AS no_of_hours
FROM
    orders
GROUP BY hours;


-- -------------------------------------------------------------------------------------------

-- Join relevant tables to find the category-wise distribution of pizzas.


SELECT 
    category, COUNT(name) AS counts
FROM
    pizza_types
GROUP BY category;


-- --------------------------------------------------------------------------------------------


-- Group the orders by date and calculate the average number of pizzas ordered per day.



SELECT 
    ROUND(AVG(total_orders), 0) AS avg_
FROM
    (SELECT 
        orders.order_date AS date_,
            SUM(order_details.quantity) AS total_orders
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.Order_Id
    GROUP BY date_) AS Order_per_day
;


-- ----------------------------------------------------------------------------------------------


-- Determine the top 3 most ordered pizza types based on revenue.



SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.Pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- -------------------------------------------------------------------------------------------------


-- Calculate the percentage contribution of each pizza type to total revenue.



SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                0) AS total_revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.Pizza_id = pizzas.pizza_id) * 100,
            2) AS Percentage_on_revenue
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.Pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY category;


-- --------------------------------------------------------------------------------------------------


-- Analyze the cumulative revenue generated over time.



select date_, sum(revenue) over(order by date_) as cum_revenue
from
(select orders.order_date as date_ ,
sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by date_) as sales ;


-- ---------------------------------------------------------------------------------------------------


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.


select category,name, revenue, rank_ from
(select category, name, revenue, 
rank()  over(partition by category order by revenue desc) as rank_
from
(select  pizza_types.category, pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a )
as b
where rank_ <= 3
;


-- --------------------------------------------------------------------------------------------------











