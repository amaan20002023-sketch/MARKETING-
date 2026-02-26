select *  from CUSTOMERS
select * from GEO_LOCATION
select * from ORDER_ITEMS
select * from ORDER_PAYMENTS
select * from ORDER_REVIEW_RATINGS
select * from ORDERS
select * from PRODUCTS
select * from SELLERS

----- add column revenue---
alter table ORDER_ITEMS
add revenue float

update OT
SET REVENUE = OT.freight_value+OT.price
FROM ORDER_ITEMS OT

select * from ORDER_ITEMS
/*KPI*/

---TOTAL_REVENUE---
SELECT SUM(ot.price+ot.freight_value) as total_revenue FROM ORDER_ITEMS OT

---total_revenue where order is delivererd---

select SUM(ot.price+ot.freight_value) as total_revenue
from ORDER_ITEMS OT
LEFT JOIN ORDERS O
ON O.order_id = OT.order_id
WHERE O.order_status = 'DELIVERED'

--- TOTAL_NUMBER_OF_ORDER_----
SELECT COUNT(*) AS TOTAL_ORDERS FROM ORDER_ITEMS OT

------TOTAL_ORDER_MONTHLY---
SELECT MONTH(OT.shipping_limit_date) AS MONTHS, COUNT(*) AS TOTAL_ORDERS
FROM ORDER_ITEMS OT 
GROUP BY MONTH(OT.shipping_limit_date)
ORDER BY MONTHS ASC

----TOTAL_ORDER_MONTHLY_ORDER_STATUS_DELIVERD---
SELECT MONTH(OT.shipping_limit_date) AS MONTHS, COUNT(*) AS TOTAL_ORDERS
FROM ORDER_ITEMS OT 
INNER JOIN ORDERS O ON O.order_id = OT.order_id
WHERE O.order_status = 'DELIVERED'
GROUP BY MONTH(OT.shipping_limit_date)
ORDER BY MONTHS ASC

/*1. Perform Detailed exploratory analysis 
a. Define & calculate high level metrics like (Total Revenue, Total quantity, Total 
products, Total categories, Total sellers, Total locations, Total channels, Total 
payment methods etc…) */

SELECT COUNT(*) AS TOTAL_LOCATION FROM GEO_LOCATION
-
-----TOTAL_SELLER-------
SELECT COUNT(*) TOTAL_SELLER FROM SELLERS S
----DISTINCT_SELLER---
SELECT S.seller_id
, COUNT(*) TOTAL_SELLER FROM SELLERS S
GROUP BY S.seller_id
----SELLER_STATE----
SELECT DISTINCT S.seller_state FROM SELLERS S

----- SELLER_CITY----
SELECT DISTINCT S.seller_city FROM SELLERS S

-----TOTAL_CUOSTOMER-------
SELECT COUNT(*) TOTAL_SELLER FROM SELLERS S
----DISTINCT_SELLER---
SELECT DISTINCT C.customer_city
 FROM CUSTOMERS C
----CUSTOMER_STATE----
SELECT DISTINCT C.customer_state FROM CUSTOMERS C

--b. Understanding how many new customers acquired every month --
SELECT MONTH(O.order_estimated_delivery_date) AS MONTHS,
COUNT(*) AS TOTAL_CUSTOMER
FROM ORDERS O
WHERE O.order_status = 'delivered'
GROUP BY MONTH(O.order_estimated_delivery_date)
ORDER BY MONTHS ASC
---c. Understand the retention of customers on month on month basis --
WITH RETENTION_CUSTOMER AS (
                              SELECT MONTH(O.order_estimated_delivery_date) AS MONTHS,
                              COUNT(*) AS MONTHLY_CUSTOMERS,
                              LAG(COUNT(*)) OVER(ORDER BY MONTH(O.order_estimated_delivery_date)) AS RET
                              FROM ORDERS O
                              WHERE O.order_status = 'DELIVERED'
                              GROUP BY MONTH(O.order_estimated_delivery_date))
SELECT RC.*,RC.MONTHLY_CUSTOMERS-RC.RET AS CUSTOMER_RETENTION
FROM RETENTION_CUSTOMER RC

---d. How the revenues from existing/new customers on month on month basis--
  SELECT 
        MONTH(O.order_estimated_delivery_date) AS MONTHS,
        O.customer_id,
        OT.price+OT.freight_value
    FROM ORDERS O
    INNER JOIN ORDER_ITEMS OT
    ON OT.order_id = O.order_id
  
/*e. Understand the trends/seasonality of sales, quantity by category, location, month, 
week, day, time, channel, payment method etc…*/
---MOST USED PAYMENT_METHOD--
SELECT P.payment_type,COUNT(*) AS PAYMENT_FROM_EACH
FROM ORDER_PAYMENTS P
GROUP BY P.payment_type

/*f. Popular Products by month, seller, state, category.*/
----EACH PRODUCT ORDERS---
SELECT P.product_category_name,
COUNT(*) AS TOTAL_ORDER_EACH
FROM PRODUCTS P
INNER JOIN ORDER_ITEMS OT
ON OT.product_id = P.product_id
GROUP BY P.product_category_name
----MONTHLY_EACH_PRODUCT_ORDERS
SELECT P.product_category_name,
MONTH(OT.shipping_limit_date) AS MONTHS,COUNT(*) AS TOTAL_ORDER_EACH
FROM PRODUCTS P
INNER JOIN ORDER_ITEMS OT
ON OT.product_id = P.product_id
GROUP BY MONTH(OT.shipping_limit_date) ,P.product_category_name
ORDER BY MONTHS ASC

----MONTHLY_EACH_PRODUCT_ORDERS
SELECT P.product_category_name,
MONTH(OT.shipping_limit_date) AS MONTHS,COUNT(*) AS TOTAL_ORDER_EACH,
ROW_NUMBER () OVER (PARTITION BY MONTH(OT.shipping_limit_date) ORDER BY COUNT(*) DESC ) RANK_
FROM PRODUCTS P
INNER JOIN ORDER_ITEMS OT
ON OT.product_id = P.product_id
GROUP BY MONTH(OT.shipping_limit_date) ,P.product_category_name
ORDER BY MONTHS ASC

----TOP_SELLER_PRODUCTS--
SELECT TOP 5 S.seller_id,P.product_category_name,COUNT(*) AS TOTAL_ORDERS 
FROM SELLERS S
INNER JOIN ORDER_ITEMS OT
ON OT.seller_id = S.seller_id
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
GROUP BY S.seller_id,P.product_category_name
ORDER BY TOTAL_ORDERS DESC
----TOP_SELLER_STATE---------
SELECT TOP 5 S.seller_state,COUNT(*) AS TOTAL_ORDERS 
FROM SELLERS S
INNER JOIN ORDER_ITEMS OT
ON OT.seller_id = S.seller_id
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
GROUP BY S.seller_state
ORDER BY TOTAL_ORDERS DESC

----TOP5 SELLER_STATE WITH PRODUCT---
SELECT TOP 5 S.seller_state,P.product_category_name,COUNT(*) AS TOTAL_ORDERS 
FROM SELLERS S
INNER JOIN ORDER_ITEMS OT
ON OT.seller_id = S.seller_id
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
GROUP BY S.seller_state,P.product_category_name
ORDER BY TOTAL_ORDERS DESC

----TOP_SELLER_CITY---------
SELECT TOP 5 S.seller_city,COUNT(*) AS TOTAL_ORDERS 
FROM SELLERS S
INNER JOIN ORDER_ITEMS OT
ON OT.seller_id = S.seller_id
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
GROUP BY S.seller_city
ORDER BY TOTAL_ORDERS DESC

-----REVENUE-------
SELECT TOP 5 S.seller_city,SUM(OT.freight_value+OT.price) AS TOTAL_REVENUE
FROM SELLERS S
INNER JOIN ORDER_ITEMS OT
ON OT.seller_id = S.seller_id
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
GROUP BY S.seller_city
ORDER BY TOTAL_REVENUE DESC
-------TOP5 SELLER_CITY WITH PRODUCT---
SELECT TOP 5 S.seller_city,P.product_category_name,COUNT(*) AS TOTAL_ORDERS 
FROM SELLERS S
INNER JOIN ORDER_ITEMS OT
ON OT.seller_id = S.seller_id
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
GROUP BY S.seller_city,P.product_category_name
ORDER BY TOTAL_ORDERS DESC
-------REVENUE---------
SELECT TOP 5 S.seller_city,P.product_category_name,SUM(OT.freight_value+OT.price) AS TOTAL_REVENUE
FROM SELLERS S
INNER JOIN ORDER_ITEMS OT
ON OT.seller_id = S.seller_id
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
GROUP BY S.seller_city,P.product_category_name
ORDER BY TOTAL_REVENUE DESC

--------TOP_CUSTOMER_STATE_ORDERS---------
SELECT TOP 5 C.customer_state,COUNT(*) AS TOTAL_ORDERS 
FROM CUSTOMERS C
INNER JOIN ORDERS O
ON O.customer_id = C.customer_id
GROUP BY C.customer_state
ORDER BY TOTAL_ORDERS DESC

-----REVENUE-----
SELECT C.customer_state,SUM(OT.freight_value+OT.price) AS TOTAL_REVENUE 
FROM CUSTOMERS C
INNER JOIN ORDERS O
ON O.customer_id = C.customer_id
INNER JOIN ORDER_ITEMS OT
ON O.order_id = OT.order_id
GROUP BY C.customer_state
ORDER BY TOTAL_REVENUE DESC

--------TOP_CUSTOMER_CITY_ORDERS---------
SELECT TOP 5 C.customer_city,COUNT(*) AS TOTAL_ORDERS 
FROM CUSTOMERS C
INNER JOIN ORDERS O
ON O.customer_id = C.customer_id
GROUP BY C.customer_city
ORDER BY TOTAL_ORDERS DESC

-----REVENUE-----
SELECT C.customer_city,SUM(OT.freight_value+OT.price) AS TOTAL_REVENUE 
FROM CUSTOMERS C
INNER JOIN ORDERS O
ON O.customer_id = C.customer_id
INNER JOIN ORDER_ITEMS OT
ON O.order_id = OT.order_id
GROUP BY C.customer_city
ORDER BY TOTAL_REVENUE DESC

----HIGHEST_EACH PRODUCT_SALES_STATE--
SELECT * FROM        (  SELECT C.customer_state,P.product_category_name,
                      SUM(OT.freight_value+OT.price) AS TOTAL_REVENUE,
                      ROW_NUMBER() OVER(PARTITION BY C.customer_state ORDER BY SUM(OT.freight_value+OT.price) DESC) AS RANK_
                      FROM CUSTOMERS C
                      INNER JOIN ORDERS O
                      ON O.customer_id = C.customer_id
                      INNER JOIN ORDER_ITEMS OT
                      ON O.order_id = OT.order_id
                      INNER JOIN PRODUCTS P
                      ON P.product_id = OT.product_id
                      GROUP BY C.customer_state,P.product_category_name
                      ) AS JJ
                      WHERE RANK_ = 1
---List top 10 most expensive products sorted by price--
select TOP 10 P.product_category_name,OT.price
from ORDER_ITEMS OT
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
ORDER BY OT.price DESC

---Divide the customers into groups based on the revenue generated--
 SELECT JKL.*,CASE
                WHEN GROUPS = 1 THEN 'HIGH'
                WHEN GROUPS =2 THEN 'MEDIUM'
                WHEN GROUPS = 3 THEN 'LOW'
                ELSE 'N/A'
                END AS CATEGORY
                FROM   
                 (SELECT C.customer_id,SUM(OT.freight_value+OT.price) AS TOTAL_REVENUE,
                  NTILE(3) OVER(ORDER BY SUM(OT.freight_value+OT.price) DESC) AS GROUPS
                  FROM CUSTOMERS C
                  INNER JOIN ORDERS O
                  ON O.customer_id = C.customer_id
                  INNER JOIN ORDER_ITEMS OT
                  ON O.order_id = OT.order_id
                  GROUP BY C.customer_id
                  ) AS JKL
---Divide the customers into groups based on the revenue generated FROM EACH GROUP--
 SELECT TMTM.CATEGORY ,SUM(TMTM.TOTAL_REVENUE) AS TOTAL_GROUP_REVENUE
            FROM 
               (SELECT JKL.* ,
               CASE
                WHEN GROUPS = 1 THEN 'HIGH'
                WHEN GROUPS =2 THEN 'MEDIUM'
                WHEN GROUPS = 3 THEN 'LOW'
                ELSE 'N/A'
                END AS CATEGORY
                FROM   
                 (SELECT C.customer_id,SUM(OT.freight_value+OT.price) AS TOTAL_REVENUE,
                  NTILE(3) OVER(ORDER BY SUM(OT.freight_value+OT.price) DESC) AS GROUPS
                  FROM CUSTOMERS C
                  INNER JOIN ORDERS O
                  ON O.customer_id = C.customer_id
                  INNER JOIN ORDER_ITEMS OT
                  ON O.order_id = OT.order_id
                  GROUP BY C.customer_id
                  ) AS JKL) AS TMTM
                  GROUP BY TMTM.CATEGORY;

-----SAME QUESTION WITH CTE
WITH CUSTOMER_GROUP AS (SELECT C.customer_id,SUM(OT.freight_value+OT.price) AS TOTAL_REVENUE,
                        NTILE(3) OVER(ORDER BY SUM(OT.freight_value+OT.price) DESC) AS GROUPS
                        FROM CUSTOMERS C
                        INNER JOIN ORDERS O
                        ON O.customer_id = C.customer_id
                        INNER JOIN ORDER_ITEMS OT
                        ON O.order_id = OT.order_id
                        GROUP BY C.customer_id),
CATEGORY AS(SELECT CP.GROUPS,CASE
                WHEN GROUPS = 1 THEN 'HIGH'
                WHEN GROUPS =2 THEN 'MEDIUM'
                WHEN GROUPS = 3 THEN 'LOW'
                ELSE 'N/A'
                END AS CATEGORY,
              CP.TOTAL_REVENUE 
              FROM CUSTOMER_GROUP AS CP)
              SELECT CATEGORY, SUM(TOTAL_REVENUE) AS GROUP_REVENUE
              FROM CATEGORY
              GROUP BY CATEGORY
---b. Divide the sellers into groups based on the revenue generated---
SELECT AM.*, CASE 
                WHEN GROUPS = 1 THEN 'HIGH'
                WHEN GROUPS =2 THEN 'MEDIUM'
                WHEN GROUPS = 3 THEN 'LOW'
                ELSE 'N/A'
                END AS CATEGORY
                FROM (SELECT OT.seller_id,SUM(OT.freight_value+OT.price) AS TOTAL_SALE,
                        NTILE(3) OVER(ORDER BY SUM(OT.freight_value+OT.price)) AS GROUPS
                        FROM ORDER_ITEMS OT
                        GROUP BY OT.seller_id ) AS AM

---. Divide the sellers into groups based on the revenue generated FROM EACH GROUP---
WITH revenue_from_group AS (
    SELECT
        ot.seller_id,
        SUM(ot.freight_value + ot.price) AS total_sale,
        NTILE(3) OVER (
            ORDER BY SUM(ot.freight_value + ot.price) DESC
        ) AS grp
    FROM order_items ot
    GROUP BY ot.seller_id
),
categorized AS (
    SELECT
        seller_id,
        total_sale,
        CASE
            WHEN grp = 1 THEN 'HIGH'
            WHEN grp = 2 THEN 'MEDIUM'
            WHEN grp = 3 THEN 'LOW'
        END AS category
    FROM revenue_from_group
)
SELECT
    category,
    SUM(total_sale) AS revenue_from_each_group
FROM categorized
GROUP BY category
ORDER BY revenue_from_each_group DESC;

/*a. Which categories (top 10) are maximum rated & minimum rated? 
b. Which products (top10) are maximum rated & minimum rated? */
SELECT *
FROM ORDER_REVIEW_RATINGS ORR
----TOP10--
SELECT TOP 10 P.product_category_name,AVG(ORR.review_score) AS SCORE
FROM ORDER_ITEMS OT
INNER JOIN ORDER_REVIEW_RATINGS ORR
ON ORR.order_id = OT.order_id
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
GROUP BY P.product_category_name
ORDER BY SCORE DESC
---BOTTOM 5---
SELECT TOP 10 P.product_category_name,AVG(ORR.review_score) AS SCORE
FROM ORDER_ITEMS OT
INNER JOIN ORDER_REVIEW_RATINGS ORR
ON ORR.order_id = OT.order_id
INNER JOIN PRODUCTS P
ON P.product_id = OT.product_id
GROUP BY P.product_category_name
ORDER BY SCORE ASC
