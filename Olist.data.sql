USE April_Data_Challenge;

--FIXING OLIST_CUSTOMERS TABLE

SELECT *, upper(substring(customer_city,1,1))+ lower(substring(customer_city,2,len(customer_city))) AS customer_city_fixed
FROM olist_customers

UPDATE olist_customers
SET customer_city=
upper(substring(customer_city,1,1))+ lower(substring(customer_city,2,len(customer_city)))





--FIXING OLIST_GEOLOCATION

SELECT *, upper(substring(geolocation_city,1,1))+ lower(substring(geolocation_city,2,len(geolocation_city))) AS geolocation_fixed
FROM olist_geolocation

--changing first lettter of geolocation_city to upper case
UPDATE olist_geolocation
SET geolocation_city=
upper(substring(geolocation_city,1,1))+ lower(substring(geolocation_city,2,len(geolocation_city)))

--identifying special characters in geolocation_city column
SELECT geolocation_city
FROM olist_geolocation
GROUP BY geolocation_city


--rplacing special charcters in geolocation_city column
UPDATE Olist_geolocation
SET geolocation_city=
replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(geolocation_city,'ê','e'), 
'ç', 'c'), 'ó', 'o'), 'â','a'),'ã','a'),'á','a'), 'é', 'e'), 'ô','o'),'ú','u'),'í','i'),
'õ','o'),'d''avila','davila'),'Sant''ana','Santana'),'d''alianca', 'dalianca') 



--FIXING OLIST_ORDER-ITEMS

SELECT*, 
CONVERT(date,shipping_limit_date) AS shipping_date,
CONVERT(Time,shipping_limit_date) AS shipping_time
FROM olist_order_items

----
ALTER TABLE olist_order_items
ADD shipping_date Date

UPDATE olist_order_items
SET shipping_date= CONVERT(date,shipping_limit_date)
----
ALTER TABLE olist_order_items
ADD shipping_time Time

UPDATE olist_order_items
SET shipping_time= CONVERT(Time,shipping_limit_date)

--Checking / Deleting duplicate values from olist_order_items table

SELECT order_id, count(*)
FROM olist_order_items
group by order_id
having count(*)>1

----
WITH CTE AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY order_id 
ORDER BY (SELECT 0)) AS RN
FROM olist_order_items
)

DELETE FROM cte
WHERE RN>1




--FIXING OLIST_ORDER_PAYMENTS
--Checking / Deleting duplicate values from order_payments table

SELECT order_id, count(*)
FROM olist_order_payments
group by order_id
having count(*)>1

-------
WITH CTE AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY order_id 
ORDER BY (SELECT 0)) AS RN
FROM olist_order_payments
)

DELETE FROM CTE 
WHERE RN>1



--FIXING OLIST_ORDER_REVIEWS

SELECT *,
CONVERT(date,review_creation_date) AS Review_created_date,
CONVERT(time,review_creation_date) AS Review_created_time,
CONVERT(date,review_answer_timestamp) AS Review_answer_date,
CONVERT(time,review_answer_timestamp) AS Review_answer_time,
CASE WHEN review_comment_title IS NULL THEN 'Other' ELSE review_comment_title END AS review_comment_title_fixed,
CASE WHEN review_comment_message IS NULL THEN 'Other' ELSE review_comment_message END AS review_comment_message_fixed
FROM olist_order_reviews
----
ALTER TABLE olist_order_reviews
ADD Review_created_date Date

UPDATE olist_order_reviews
SET Review_created_date= CONVERT(Date,review_creation_date)

----
ALTER TABLE olist_order_reviews
ADD Review_created_time Time

UPDATE olist_order_reviews
SET Review_created_time= CONVERT(Time,review_creation_date)
----
ALTER TABLE olist_order_reviews
ADD Review_answer_date Date

UPDATE olist_order_reviews
SET review_answer_date = CONVERT(Date,review_answer_timestamp)
----

ALTER TABLE olist_order_reviews
ADD Review_answer_time Time

UPDATE olist_order_reviews
SET review_answer_time = CONVERT(Time,review_answer_timestamp)

----
UPDATE olist_order_reviews
SET review_comment_title =CASE WHEN review_comment_title IS NULL THEN 'Other' ELSE review_comment_title END 
----
UPDATE olist_order_reviews
SET review_comment_message =CASE WHEN review_comment_message IS NULL THEN 'Other' ELSE review_comment_message END 
-----
UPDATE olist_order_reviews
SET review_comment_title=
upper(substring(review_comment_title,1,1))+ lower(substring(review_comment_title,2,len(review_comment_title)))

UPDATE olist_order_reviews
SET review_comment_message=
upper(substring(review_comment_message,1,1))+ lower(substring(review_comment_message,2,len(review_comment_message)))


--Checking / Deleting duplicate values from order_reviews table

SELECT review_id, count(*)
from olist_order_reviews
group by review_id
having count(*) >1
---

WITH CTE AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY review_id 
ORDER BY (SELECT 0)) AS RN
FROM olist_order_reviews
)

DELETE FROM CTE 
WHERE RN>1


--FIXING OLIST_ORDERS
ALTER TABLE olist_orders
ADD purchase_date Date

UPDATE olist_orders
SET purchase_date = CONVERT(Date, order_purchase_timestamp)
----
ALTER TABLE olist_orders
ADD purchase_time Time

UPDATE olist_orders
SET purchase_time = CONVERT(Time, order_purchase_timestamp)

----
ALTER TABLE olist_orders
ADD approved_date Date

UPDATE olist_orders
SET approved_date = CONVERT(Date, order_approved_at)
----
ALTER TABLE olist_orders
ADD approved_time Time

UPDATE olist_orders
SET approved_time = CONVERT(Time, order_approved_at)

----
ALTER TABLE olist_orders
ADD delivered_carrier_date Date

UPDATE olist_orders
SET delivered_carrier_date = CONVERT(Date, order_delivered_carrier_date)
----
ALTER TABLE olist_orders
ADD delivered_carrier_time Time

UPDATE olist_orders
SET delivered_carrier_time = CONVERT(Time, order_delivered_carrier_date)

----
ALTER TABLE olist_orders
ADD delivered_customer_date Date

UPDATE olist_orders
SET delivered_customer_date = CONVERT(Date, order_delivered_customer_date)
----
ALTER TABLE olist_orders
ADD delivered_customer_time Time

UPDATE olist_orders
SET delivered_customer_time = CONVERT(Time, order_delivered_customer_date)
----
ALTER TABLE olist_orders
ADD estimated_delivery_date Date

UPDATE olist_orders
SET estimated_delivery_date = CONVERT(Date, order_estimated_delivery_date)
----
ALTER TABLE olist_orders
ADD estimated_delivery_time Time

UPDATE olist_orders
SET estimated_delivery_time = CONVERT(Time, order_estimated_delivery_date)




--FIXING OLIST_PRODUCTS
SELECT *
FROM olist_products

UPDATE olist_products
SET product_category_name=
CASE WHEN product_category_name IS NULL THEN 'other' 
ELSE product_category_name 
END




--FIXING OLIST_SELLERS
SELECT *
FROM olist_sellers

UPDATE olist_sellers
SET seller_city =
UPPER(SUBSTRING(seller_city,1,1)) + LOWER(SUBSTRING(seller_city,2,LEN(seller_city)))
----



----------------------------------ANALYSIS-------------------------------
--1)What is the total revenue generated by Olist, and how has it changed over time?

---Total Revenue Generated
--(For this business question, we will take into consideration only orders that have status 'delivered' which shows that the customer has received the goods and the likely hood of a refund is very low)
SELECT SUM(payment_value) AS Total_Revenue_Generated
FROM olist_order_payments OP
JOIN olist_orders O
ON OP.order_id = O.order_id
WHERE O.order_status ='delivered'



---Revenue generated over time
SELECT O.purchase_date, SUM(OP.payment_value)AS Revenue_generated
FROM olist_order_payments OP 
LEFT JOIN olist_orders O
ON OP.order_id= O.order_id
WHERE O.order_status ='delivered'
GROUP BY O.purchase_date
ORDER BY O.purchase_date


--2) How many orders were placed on Olist, and how does this vary by month or season?

--Total oreders Placed 
SELECT COUNT( DISTINCT order_id)AS Total_orders
FROM olist_orders

---Total Orders placed by month
SELECT MONTH(purchase_date) AS Month_Number, DATENAME(MONTH, purchase_date) AS Month, COUNT(DISTINCT order_id) AS Total_orders
FROM olist_orders
GROUP BY  MONTH(purchase_date),DATENAME(MONTH, purchase_date)
ORDER BY  MONTH(purchase_date)


--3) What are the most popular product categories on Olist, and how do their sales volumes compare to each other?

--Top 10 most popular categories will be determind by the number of orders placed on the product category
SELECT CNT.product_category_name_english, Product_category_count
FROM (
SELECT OP.product_category_name, COUNT(*) AS Product_category_count
FROM olist_order_items OI
LEFT JOIN olist_products  OP
ON OI.product_id = OP. product_id
GROUP BY OP.product_category_name
ORDER BY  COUNT(*)   DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY
) PP
JOIN product_category_name_translation CNT
ON PP.product_category_name = CNT.product_category_name
ORDER BY 2 DESC 


--How do their sales volumes compare to each other
--(Taking into consideration that sale volume is the volume from delivered orders)
SELECT CNT.Product_category_name_english, CAST(Sales_volume*1.0 *100 / SUM(sales_volume) OVER() AS DECIMAL(5,2))  AS Compared_volume
FROM (
SELECT OP.product_category_name, COUNT(*) AS Sales_volume 
FROM olist_order_items OI
LEFT JOIN olist_products  OP
ON OI.product_id = OP. product_id
JOIN olist_orders O
ON OI.order_id = O.order_id
WHERE O.order_status = 'delivered'
GROUP BY OP.product_category_name
ORDER BY  COUNT(*)   DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY
) SV
JOIN product_category_name_translation CNT
ON SV.product_category_name = CNT.product_category_name
ORDER BY 2 DESC




--4)  What is the average order value (AOV) on Olist, and how does this vary by product category or payment method?
 
 --Average order value on olist
 SELECT  Avg(payment_value) AS AVG_ORDER_VALUE
 FROM olist_order_payments

 --How the AOV vary by product Category
 
 SELECT CNT.product_category_name_english, Average_order_value
 FROM(
 SELECT P.product_category_name, AVG(OP.payment_value) AS Average_order_value
 FROM  olist_order_items OI
LEFT JOIN olist_order_payments OP
 ON OI.order_id = OP. order_id
 LEFT JOIN olist_products P
 ON OI.product_id=P.product_id
 GROUP BY P.product_category_name
  ) AV
 JOIN product_category_name_translation CNT
ON AV.product_category_name = CNT.product_category_name
ORDER BY Average_order_value DESC

  --How the AOV vary by payment method
 SELECT payment_type, Average_order_value
 FROM (
 SELECT payment_type, AVG(payment_value)AS Average_order_value
  FROM olist_order_payments
  GROUP BY payment_type
  ) PM
  WHERE payment_type != 'not_defined'
  ORDER BY Average_order_value DESC
  
 
 --5) How many sellers are active on Olist, and how does this number change over time?
  --How many active sellers are on olist
  SELECT COUNT(DISTINCT seller_id) AS Number_of_Active_Sellers
  FROM olist_order_items OI
 
 --How Active Sellers change over time
  SELECT O.purchase_date, COUNT(DISTINCT seller_id) AS Number_of_Active_Sellers
  FROM olist_orders O
 LEFT JOIN olist_order_items OI
 ON O.order_id = OI.order_id
 GROUP BY O.purchase_date
 ORDER BY purchase_date

 --How it varies by Day of the Week
  SELECT  DATEPART(WEEKDAY, Purchase_date)AS Weekday_number, DATENAME (WEEKDAY, purchase_date) AS Weeday, COUNT(DISTINCT seller_id) AS Number_of_Active_Sellers
  FROM olist_orders O
 LEFT JOIN olist_order_items OI
 ON O.order_id = OI.order_id
 GROUP BY DATEPART(WEEKDAY, Purchase_date), DATENAME (WEEKDAY, purchase_date)
 ORDER BY DATEPART(WEEKDAY, Purchase_date) 



-- 6) What is the distribution of seller ratings on Olist, and how does this impact sales performance?

--Distribution of olist seller ratings
SELECT ORE. review_score, COUNT(OI.seller_id) AS Number_of_sellers
FROM olist_order_reviews ORE
JOIN olist_order_items OI
ON  ORE.order_id= OI.order_id
GROUP BY ORE. review_score
ORDER BY ORE. review_score DESC

--How does reviews impact sales
SELECT OI.seller_id,COUNT(OI.product_id)AS Numner_of_products_sold, AVG(ORE.review_score) AS Average_rating, AVG(OP.payment_value)AS Average_payment_value 
FROM olist_order_items OI
JOIN olist_order_payments OP
ON OI.order_id = OP.order_id
JOIN  olist_order_reviews ORE
ON OI.order_id= ORE.order_id
GROUP BY OI.seller_id


--7) How many customers have made repeated purchases on Olist, and what percentage of total sales do they account for?

  --Number of customers that have made repeated purchsases
  --(for this Business question, we considered purchases as orders that have been delivered)
SELECT COUNT(*) AS Number_of_customer_with_repeated_purchases
FROM(
SELECT customer_unique_id, count(*) AS Purchases 
FROM olist_orders O
JOIN olist_customers C
ON O.customer_id = C.customer_id
WHERE o.order_status = 'delivered'
GROUP BY customer_unique_id
having count(*)>1
) Cc

--Percentage of Total Sales of repeated purchases
--(for this Businees question, we take into consideration that only delivered orders are considered as sales made)

 SELECT SUM(purchases) AS Total_repeated_purchases
FROM(
SELECT  customer_unique_id, count(customer_unique_id) AS Purchases 
FROM olist_orders O
JOIN olist_customers C
ON O.customer_id = C.customer_id
WHERE o.order_status = 'delivered'
GROUP BY customer_unique_id
HAVING COUNT(customer_unique_id)>1
)AS CC 

--using the values gotten from the above query '5921' as the total repeated sales.
SELECT 5921* 100/ COUNT( customer_unique_id)AS pecetnage_repeated_purchases_over_total_sales
FROM olist_orders O
JOIN olist_customers C
ON O.customer_id = C.customer_id
WHERE  o.order_status = 'delivered'


--8) What is the average customer rating for products sold on Olist, and how does this impact sales performance?
SELECT  AVG(ORE.review_score) AS Average_customer_rating
FROM olist_order_items OI
JOIN olist_order_reviews ORE
ON OI.order_id= ORE.order_id
JOIN olist_orders O
ON OI.order_id = O.order_id
 WHERE O.order_status = 'delivered'




--9) What is the average order cancellation rate on Olist, and how does this impact seller performance?.

 --creating #temp table for cancelled orders
 CREATE TABLE #temp_cancelled(
 order_id nvarchar(max),
 Cancelled_orders int
)
--inserting cancelled orders in temp table
INSERT INTO #temp_cancelled
SELECT order_id, count(*) AS Cancelled_orders
 FROM olist_orders
 where order_status='canceled' 
 GROUP BY order_id

 --Finding Average order cancellation rate
 SELECT CAST(SUM(C.cancelled_orders)*1.0 *100/COUNT(O.order_id)AS DECIMAL(5,2)) AS Average_cancelation_rate
 FROM olist_orders O
 LEFT JOIN #temp_cancelled C
 ON O.order_id = C.order_id


--10) What are the top-selling products on Olist, and how have their sales trends changed over time?
--To get the top selling product, we take into consideration the number of total delivered orders on each product 
SELECT OI.product_id, Count(OI.product_id) AS Total_order
FROM olist_orders O
JOIN olist_order_items OI
ON O.order_id = OI.order_id
WHERE O.order_status= 'delivered'
GROUP BY OI.product_id
ORDER BY Count(OI.product_id) DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY

--Sales trend by month of by top-selling products

-- First we create a #temp table for the top selling products
CREATE TABLE #temp_top_selling(
product_id nvarchar(max),
Total_order int
)

--inserting top selling product into #temp_top_selling
INSERT INTO #temp_top_selling
SELECT OI.product_id, Count(OI.product_id) AS Total_order
FROM olist_orders O
JOIN olist_order_items OI
ON O.order_id = OI.order_id
WHERE O.order_status= 'delivered'
GROUP BY OI.product_id
ORDER BY Count(OI.product_id) DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY


--top_selling_products_trend_by_month
SELECT O.purchase_date,  DATENAME(MONTH, purchase_date) AS Month, TS.product_id, Count(TS.product_id) AS Total_order
FROM olist_order_items OI
JOIN olist_orders O
ON OI.order_id= O.order_id
JOIN #temp_top_selling TS
ON OI.product_id = TS.product_id
WHERE O.order_status= 'delivered'
GROUP BY O.purchase_date, TS.product_id
ORDER BY O.purchase_date


--11) Which payment methods are most commonly used by Olist customers, and how does this vary by product category or geographic region?

--Widely used payment method by olist customers
SELECT payment_type, COUNT(payment_type) AS number_of_times_used
FROM olist_order_payments
WHERE payment_type != 'not_defined'
GROUP BY payment_type
ORDER BY COUNT(payment_type) DESC


--How payment varies with product category
SELECT CNT.product_category_name_english, OP.payment_type, COUNT(OP.payment_type)AS Payment_type_usage_times
 FROM  olist_products P
 JOIN olist_order_items OI
 ON P.product_id = OI.product_id
 JOIN olist_order_payments OP
 ON OI.order_id = OP.order_id
 JOIN product_category_name_translation CNT
ON P.product_category_name = CNT.product_category_name
 GROUP BY  CNT.product_category_name_english, OP.payment_type
 ORDER BY COUNT(OP.payment_type) DESC

 

--How it varies with geographic location
  SELECT C.customer_city, OP.payment_type, COUNT(OP.payment_type)AS Payment_type_usage_times
  FROM olist_orders O
  JOIN  olist_customers C
  ON  O.customer_id = C.customer_id
  JOIN olist_order_payments OP
  ON O.order_id = OP. order_id
  GROUP BY C.customer_city, OP.payment_type
  ORDER BY COUNT(OP.payment_type) DESC
  

--13) Which product categories have the highest profit margins on Olist, and how can the company increase profitability across different categories?
--(since no information was given on the profit made for each product, we'll use the price and only consider product categories were their orders status is delivered).
SELECT CNT.product_category_name_english, SUM(OI.price) AS Profit
FROM olist_products P
JOIN  olist_order_items OI
ON P.product_id = OI.product_id
JOIN olist_orders O
ON OI.order_id = O.order_id
JOIN product_category_name_translation CNT
ON P.product_category_name = CNT.product_category_name
WHERE O.order_status = 'delivered'
GROUP BY CNT.product_category_name_english
ORDER BY SUM(OI.price) DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROW ONLY

--15 Geolocation having high customer density. Calculate customer retention rate according to geolocations.
   --Geolocation with the highest customer density
   SELECT customer_city, count(customer_id)AS customer_density
   FROM olist_customers
   GROUP BY customer_city
   ORDER BY count(customer_id) DESC
   OFFSET 0 ROWS
   FETCH NEXT 10 ROWS ONLY


--For customer retention rate, we take into consideration year 2017.
-----creating a temporary table for customers in 2017
--DROP TABLE IF EXISTS #temp_2017Jan
CREATE TABLE #temp_2017Jan(
customer_state varchar (10),
Customers int
)

CREATE TABLE #temp_2017Dec(
customer_state varchar (10),
Customers int
)

------inserting values into #temp_2017Jan
INSERT INTO #temp_2017Jan
SELECT C.customer_state, COUNT(DISTINCT C.customer_id)AS Customers
FROM olist_orders O
JOIN olist_customers C
ON O.customer_id = C.customer_id
WHERE o.order_status = 'delivered' and 
      O.purchase_date  between '2017-01-01' and '2017-01-31'
	  GROUP BY C.customer_state


------inserting values into #temp_2017Dec
INSERT INTO #temp_2017Dec
SELECT  C.customer_state, COUNT(DISTINCT C.customer_id)AS Customers
FROM olist_orders O
JOIN olist_customers C
ON O.customer_id = C.customer_id
WHERE o.order_status = 'delivered' and 
      O.purchase_date  between '2017-12-01' and '2017-12-31'
GROUP BY C.customer_state


----Determing the retention rate by geolocation
SELECT J.customer_state,D.customer_state,  SUM(J.customers) AS start_customers,SUM(D.customers)AS retained_customers,
     SUM(D.customers)*1.0 /SUM(J.customers)*100  AS  retention_rate
FROM #temp_2017Jan J
FULL JOIN #temp_2017Dec  D
ON J.customer_state = D.customer_state
Group BY J.customer_state, D.customer_state








;














