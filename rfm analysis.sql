
----------------------------RFM Segmentation-------------------------------------


WITH  PERCENTILE as (
SELECT CUSTOMER_ID, PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY INACTIVE_DAYS) OVER() AS P66_R,
PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY INACTIVE_DAYS) OVER() AS P33_R,
PERCENTILE_CONT(0.45) WITHIN GROUP (ORDER BY TOTAL_SPENT) OVER() AS P45_M,
PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY TOTAL_SPENT) OVER() AS P95_M
FROM customers_360_Final
),RFM AS (
SELECT c.Customer_id,
CASE WHEN Inactive_Days >P66_R THEN 1
WHEN Inactive_Days > P33_R AND  Inactive_Days <=P66_R THEN 2
ELSE 3 End as 'Recency',
CASE WHEN Total_orders >= 4 THEN 3
WHEN Total_orders > 2 AND Total_orders< 4 THEN 2
ELSE 1 END AS 'Frequency',
CASE WHEN Total_Spent > P95_M THEN 3
WHEN Total_Spent <= P95_M AND Total_Spent>P45_M THEN 2
ELSE 1 END AS 'MONETORY'

FROM customers_360_Final AS C JOIN PERCENTILE AS P ON 
P.CUSTOMER_ID = C.Customer_id
)
,rfm_score as (
SELECT Customer_id,(Recency+Frequency+MONETORY) AS RFM_SCORE FROM RFM)---,
----cust_with_segmentation as(

select c.*,s.RFM_SCORE, CASE WHEN RFM_SCORE > 6 THEN 'PLATINUM'  WHEN RFM_SCORE >=5 AND RFM_SCORE <=6 THEN 'GOLD'
 WHEN RFM_SCORE =4 THEN 'SILVER' ELSE 'LOW VALUE' END AS 'CUSTOMER_SEGMENTATION'
from rfm_score as s
join customers_360_Final as c on c.Customer_id = s.Customer_id
)

select CUSTOMER_SEGMENTATION,
COUNT(Customer_id) as Total_cusatomers,
ROUND(SUM(Total_Spent),0) as Total_spent,
SUM(Total_Discount_Recieved) Discount
from cust_with_segmentation
group by CUSTOMER_SEGMENTATION
order by Total_cusatomers

--------------------------Discount vs Non Discount Seekers----------------


WITH DISCOUNT_SEGMENTATION AS (
Select *,
CASE WHEN Total_Discount_Recieved > 0 THEN 'DISCOUNT SEEKER'
ELSE 'NON DISCOUNT SEEKER' END AS 'DISCOUNT_SEGMENT' 
from customers_360_Final
)
SELECT DISCOUNT_SEGMENT,
Gender,
COUNT(Customer_id) TOTAL_CUSTOMERS, round(SUM(total_spent),2) as Total_spent,
SUM(total_spent)*100/ (SELECT SUM(Total_Spent)  FROM DISCOUNT_SEGMENTATION) AS Revenue_contribution,
COUNT(Customer_id) *100.0/ (SELECT COUNT(Customer_id) FROM DISCOUNT_SEGMENTATION) AS PERCENTAGE_DISCOUNT_SEGMENT
FROM DISCOUNT_SEGMENTATION
GROUP BY DISCOUNT_SEGMENT, Gender
ORDER BY DISCOUNT_SEGMENT



-------------------------------------Channel Wise Analysis-------------------------------
SELECT * FROM orders_360_final


SELECT Channel_used, COUNT(Order_id) AS Total_Orders,
SUM(Total_Amount) AS Total_Revenue,
COUNT(Order_id)*100.0/ (SELECT COUNT(Order_id) FROM orders_360_final) AS ORDERS_PERCENTAGE,
SUM(Total_Amount)*100.0/ (SELECT SUM(Total_Amount) FROM orders_360_final) AS REVENUE_PERCENTAGE

FROM orders_360_final
GROUP BY Channel_used



------------

SELECT customer_state, 
ROUND(COUNT(Customer_id)*100.0/(SELECT COUNT(*) FROM orders_360_final),2) AS PERCENTAGE_COUNT 
FROM customers_360_Final
GROUP BY customer_state

select case when Avg_rating_per_customer >=4.5 then 'High rated'
else 'low rated' end as rating_bucket
from stores_360_final


select * from stores_360_final



select s.store_id, round(avg(Customer_Satisfaction_Score),2) as Average_Rating from OrderReview_Ratings as o 
join Finalised_Records_1 as f on o.order_id=f.order_id
join stores_360_final as s on s.store_id= f.Delivered_StoreID
group by s.store_id


Select store_id, round(sum(Total_sales),2)as Total_Revenue_Generated,
SUM(c.Total_orders) as Total_orders
from stores_360_final as s join Finalised_Records_1 as f on f.Delivered_StoreID= s.store_id
join customers_360_Final as c on c.Customer_id= f.Customer_id
Group by store_id
order by Total_orders


----------Todal Oreders and revenue Category wise

select Category, 
COUNT(o.Order_id) as Total_orders ,
Round(SUM(o.Total_Amount),2) as Total_Revenue 
from Finalised_Records_1 as f
join orders_360_final as o
on o.Order_id =f.order_id
group by Category
order by Total_Revenue desc

-----------total orders and revenue months and years 

SELECT FORMAT(cast(Bill_date_timestamp as datetime), 'MM-yyyy') as Months,
round(sum(Total_Amount),2) as Total_Revenue, COUNT(Order_id) as Total_orders, 
sum(Total_Amount) *100.0/(select sum(Total_Amount) from orders_360_final) as Percentage_of_Total_Revenue,
COUNT(Order_id) *100.0/(select COUNT(Order_id) from orders_360_final) as Percentage_of_Total_Orders
FROM orders_360_final
Group by 
FORMAT(cast(Bill_date_timestamp as datetime), 'MM-yyyy') order by MONTHs

SELECT * FROM orders_360_final
-----------------------Orders and Revenue by day of week------------------

SELECT Day_of_week,
ROUND(SUM(Total_Amount),2) AS TOTAL_REVENUE, 
COUNT(ORDER_ID) AS TOTAL_ORDERS,
---------SUM(Total_Amount)*100.0/(SELECT SUM(Total_Amount) FROM orders_360_final) AS PROFIT_PERCENTAGE,
COUNT(ORDER_ID)*100.0/(SELECT COUNT(ORDER_ID) FROM orders_360_final) AS ORDER_PERCENTAGE
FROM orders_360_final
GROUP BY Day_of_week

SELECT  FROM orders_360_final



SELECT DISTINCT Category , count(distinct product_id) as proud FROM Finalised_Records_1
group by Category
order by proud desc

 select top 5  product_id, COUNT(product_id) as Total_products,  COUNT(product_id)*100.0/(select COUNT(product_id) from Finalised_Records_1) as percentage_contri from Finalised_Records_1
 group by product_id
 order by Total_products desc



 select * from stores_360_final
 select product_id,  from Finalised_Records_1

 Select store_id ,
 sum(Total_sales)*100.0/ (select sum(Total_sales) from stores_360_final ) as sales_percentage, 
 sum(Total_products_sold)*100.0/(select sum(Total_products_sold) from stores_360_final ) as orders_percentage  from stores_360_final
 group by store_id
 order by sales_percentage desc


  select seller_state, count(store_id) from stores_360_final
  group by seller_state