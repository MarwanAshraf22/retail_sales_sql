-- Step 1: Create the table
CREATE TABLE retail_sales (
	transaction_id INT PRIMARY KEY,	
	sale_date DATE,	 
	sale_time TIME,	
	customer_id	INT,
	gender	VARCHAR(15),
	age	INT,
	category VARCHAR(15),	
	quantity	INT,
	price_per_unit FLOAT,	
	cogs	FLOAT,
	total_sale FLOAT
);

-- Step 2: View first 10 rows
SELECT * 
FROM retail_sales
LIMIT 10;

-- Step 3: Count total rows
SELECT COUNT(*) 
FROM retail_sales;

-- Step 4 & 5: Delete rows with NULLs using a CTE and JOIN condition
WITH null_rows AS (
	SELECT transaction_id
	FROM retail_sales
	WHERE transaction_id IS NULL
		OR sale_date IS NULL
		OR sale_time IS NULL
		OR customer_id IS NULL
		OR gender IS NULL
		OR age IS NULL
		OR category IS NULL
		OR quantity IS NULL
		OR price_per_unit IS NULL
		OR cogs IS NULL
		OR total_sale IS NULL
)
DELETE FROM retail_sales
USING null_rows
WHERE retail_sales.transaction_id = null_rows.transaction_id;

-- Step 6: View table after deletion
SELECT * 
FROM retail_sales;


-- Data Exploration
-- Number of Sales
SELECT COUNT(*) 
AS total_sales 
FROM retail_sales


-- Number of unique customers
SELECT COUNT(DISTINCT customer_id)
AS customers
FROM retail_sales

-- Number of Categories
SELECT COUNT(DISTINCT Category)
AS Category
FROM retail_sales


-- Data Analysis and Buisness Problems
-- Sales made on 05-11-2022

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022.
SELECT 
	*
FROM 
	retail_sales
WHERE 
	category = 'Clothing' 
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantity > 2

-- calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS net_sales,
	COUNT(*) AS order_count
FROM 
	retail_sales
GROUP BY 1

-- the average age of customers who purchased items from the 'Beauty' category.
SELECT
	category,
	ROUND(AVG(age),2) 
FROM
	retail_sales
WHERE 
	category='Beauty'
GROUP BY 1

-- all transactions where the total_sale is greater than 1000.
SELECT *
FROM 
	retail_sales
WHERE 
	total_sale > 1000

-- the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category,
	gender,
	count(*) as total_transactions
FROM 
	retail_sales
GROUP BY 1,2 
ORDER BY 1

-- the average sale for each month. Find out best selling month in each year+
WITH ranked_sales AS (
	SELECT
		EXTRACT(YEAR FROM sale_date) AS sale_year,
		EXTRACT(MONTH FROM sale_date) AS sale_month,
		AVG(total_sale) AS avg_monthly_sale,
		RANK() OVER (
			PARTITION BY EXTRACT(YEAR FROM sale_date) 
			ORDER BY AVG(total_sale) DESC
		) AS rank_in_year
	FROM 
		retail_sales
	GROUP BY  
		sale_year, sale_month
)
SELECT 
	sale_year,
	sale_month,
	avg_monthly_sale
FROM 
	ranked_sales
WHERE 
	rank_in_year = 1;

-- the top 5 customers based on the highest total sales 

SELECT 
	customer_id,
	SUM(total_sale) AS total_sale
FROM 
	retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- the number of unique customers who purchased items from each category.

SELECT 
	COUNT(DISTINCT (customer_id)) AS no_of_customer,
	category
FROM
	retail_sales
GROUP BY 2


-- create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH shift AS
	(
	SELECT
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shit_hour
	FROM
		retail_sales
)
SELECT 
	shit_hour,
	COUNT(*) as total_sales
FROM shift
GROUP BY shit_hour












































