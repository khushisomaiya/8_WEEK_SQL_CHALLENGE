-- WEEK 1 DANNY'S DINER CASE STUDY SOLUTION
USE dannys_diner;

-- 1.What is the total amount each customer spent at the restaurant?
SELECT customer_id, 
		sum(price) as Total_Amount_Spent
FROM sales INNER JOIN menu ON sales.product_id = menu.product_id
GROUP BY customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT customer_id,
		COUNT(DISTINCT order_date)
FROM sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
 WITH orders AS
 (
	 SELECT customer_id, 
			product_name,
			order_date,
			DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS order_number
	FROM sales INNER JOIN menu ON sales.product_id = menu.product_id
)
SELECT customer_id,
		product_name AS First_Item
FROM orders
WHERE order_number = 1
GROUP BY customer_id,product_name;

-- 4.What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT product_name,
		COUNT(order_date) AS num_of_orders
FROM sales LEFT JOIN menu ON sales.product_id = menu.product_id
GROUP BY product_name
ORDER BY num_of_orders DESC
LIMIT 1;

-- 5.Which item was the most popular for each customer?
WITH number_of_purchases AS
(
	SELECT customer_id,
			product_name,
			COUNT(order_date) AS number_of_orders,
			DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(order_date) DESC) AS order_rank
	FROM sales LEFT JOIN menu ON sales.product_id = menu.product_id
	GROUP BY customer_id, product_name
)
SELECT customer_id,
		product_name,
        number_of_orders
FROM number_of_purchases
WHERE order_rank=1;

-- 6.Which item was purchased first by the customer after they became a member?
WITH customer_members AS
 (
	 SELECT sales.customer_id, 
			product_id,
			order_date,
			ROW_NUMBER() OVER(PARTITION BY sales.customer_id ORDER BY order_date) AS order_number
	FROM members INNER JOIN sales ON members.customer_id = sales.customer_id
	WHERE join_date < order_date
)
SELECT customer_members.customer_id,
		product_name AS First_Item
FROM customer_members
INNER JOIN menu ON customer_members.product_id = menu.product_id
WHERE order_number = 1
GROUP BY customer_id,product_name
ORDER BY customer_id;

-- 7.Which item was purchased just before the customer became a member?
WITH non_members AS
 (
	 SELECT sales.customer_id, 
			product_id,
			order_date,
			ROW_NUMBER() OVER(PARTITION BY sales.customer_id ORDER BY order_date DESC) AS order_number
	FROM members INNER JOIN sales ON members.customer_id = sales.customer_id
	WHERE join_date > order_date
)
SELECT non_members.customer_id,
		product_name AS First_Item
FROM non_members
INNER JOIN menu ON non_members.product_id = menu.product_id
WHERE order_number = 1
GROUP BY customer_id,product_name
ORDER BY customer_id;

-- 8.What is the total items and amount spent for each member before they became a member?
SELECT sales.customer_id, 
	   COUNT(sales.product_id) AS total_items,
	   SUM(price) AS amount_spent
FROM members INNER JOIN sales ON members.customer_id = sales.customer_id AND join_date > order_date
			INNER JOIN menu ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1;

-- 9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT customer_id,
		SUM(
        CASE
			WHEN product_name = 'sushi' THEN price*20
            ELSE price*10
		END
        ) AS points
FROM sales INNER JOIN menu ON sales.product_id = menu.product_id
GROUP BY customer_id
ORDER BY customer_id;

-- 10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT sales.customer_id,
		SUM(
        CASE
			WHEN order_date >= join_date AND order_date < DATE_ADD(join_date, INTERVAL 7 DAY) THEN PRICE*20
            ELSE
				CASE 
					WHEN product_name = 'sushi' THEN price*20
					ELSE price*10
				END
		END
        ) AS points
FROM members INNER JOIN sales ON members.customer_id = sales.customer_id 
		     INNER JOIN menu ON sales.product_id = menu.product_id
WHERE sales.order_date <= '2021-01-31' AND sales.customer_id IN ('A','B')
GROUP BY sales.customer_id
ORDER BY sales.customer_id;

-- BONUS QUESTION 1 Create a table with columns customer_id, order_date, product_name, price and member from available data. The member column should have values 'Y' or 'N' based on whether a customer is a member or not.
SELECT sales.customer_id,
		order_date,
        product_name,
        price,
        CASE 
			WHEN order_date >= join_date THEN 'Y'
            ELSE 'N'
		END AS member
FROM members RIGHT JOIN sales ON members.customer_id = sales.customer_id 
		     INNER JOIN menu ON sales.product_id = menu.product_id
ORDER BY sales.customer_id,order_date,product_name;

-- BONUS QUESTION 2 Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
WITH joined_table AS
(
	SELECT sales.customer_id,
			order_date,
			product_name,
			price,
			CASE 
				WHEN order_date >= join_date THEN 'Y'
				ELSE 'N'
			END AS member
	FROM members RIGHT JOIN sales ON members.customer_id = sales.customer_id 
				 INNER JOIN menu ON sales.product_id = menu.product_id
	ORDER BY sales.customer_id,order_date,product_name
)
SELECT *,
        CASE 
			WHEN member = 'Y' THEN DENSE_RANK() OVER(PARTITION BY customer_id,member ORDER BY order_date) 
            ELSE null
		END AS ranking
FROM joined_table
ORDER BY customer_id,order_date,product_name;
