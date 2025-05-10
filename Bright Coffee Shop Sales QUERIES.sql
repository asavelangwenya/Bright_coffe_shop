SELECT * FROM brightlight_coffee_sales.bright_coffee_shop_sales;

-- UPDATING TABLE TO REMOVE ',' FROM UNIT PRICE AND REPLACE WIHT '.'
UPDATE bright_coffee_shop_sales
SET unit_price = REPLACE(unit_price, ',', '.')
WHERE unit_price LIKE '%,%';

-- COUNTING THE TOTAL NUMBER OF SALES PER STORE
SELECT store_id,
	store_location, 
COUNT(transaction_id) AS Number_of_Sales_Per_Store
FROM bright_coffee_shop_sales
GROUP BY store_id, Store_Location ;


-- CALCULATING TOTAL SALES PER STORE
SELECT * , 
	ROUND(transaction_qty * unit_price,2) AS Sales
FROM bright_coffee_shop_sales;

-- CALCULATING THE TOTAL REVENUE PER STORE
SELECT store_id,store_location, ROUND(SUM(transaction_qty * unit_price),2) SALES
  FROM bright_coffee_shop_sales
  GROUP BY store_id,store_location ;
  
-- GROUPING SALES BY TIME INTERVALS

SELECT 
    store_id,
    store_location,
    DATE(transaction_date) AS Transaction_date,
    HOUR(transaction_time) AS Transaction_time,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_sales
FROM bright_coffee_shop_sales
GROUP BY  store_id, store_location, transaction_date, Transaction_time
ORDER BY store_id, store_location,transaction_date, Transaction_time;


-- TOTAL SALES PER HOUR PER SHOP		   
SELECT
    store_id,
    Store_location,
    EXTRACT(HOUR FROM transaction_time) AS hour_of_day,
    ROUND(SUM(transaction_qty*unit_price),2) AS total_sales
FROM bright_coffee_shop_sales
GROUP BY store_id,Store_location,EXTRACT(HOUR FROM transaction_time)
ORDER BY store_id,hour_of_day DESC;

-- PEAK HOUR PER SHOP
WITH sales_by_hour AS 
(
    SELECT
        store_id,
        store_location,
        EXTRACT(HOUR FROM transaction_time) AS Peak_Hour,
        ROUND(SUM(transaction_qty*unit_price),2) AS total_sales
    FROM bright_coffee_shop_sales
    GROUP BY store_id,store_location,EXTRACT(HOUR FROM transaction_time)
)
	SELECT
    store_id,
    store_location,
    Peak_Hour,
    total_sales
	FROM 
(
    SELECT
        store_id,
        store_location,
        Peak_Hour,
        total_sales,
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY total_sales DESC) AS rank_
        
    FROM sales_by_hour
) ranked
WHERE rank_ = 1 ;


-- DETERMINING THE MOST PURCHASED PRODUCT

SELECT product_category,product_type,product_detail, COUNT(product_id)
FROM bright_coffee_shop_sales
GROUP BY product_category,product_type,product_detail
ORDER BY  COUNT(product_id) DESC;












