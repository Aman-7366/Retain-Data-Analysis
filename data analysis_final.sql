select top 2 * from customers_360_final

select  * from orders_360_final
---Total Amount--
select sum(total_amount) as Total_amount from orders_360_final

-------Daywise sales distribution
select day_of_week, sum(total_amount) as Total_sales from orders_360_final group by day_of_week
----------Total Profit
select sum(o.total_profit) as Total_profit from orders_360_final as o
----------Total No Of Order Placed
select count(*) as Total_orders from orders_360_final as o
------Total Quantity------
select sum(o.quantity) as Total_items_sold from orders_360_final as o
--------Total Discount given-
select round(sum(discount),0) as Total_discount from orders_360_final as o
--------Average of Total Amount
select round(avg(total_amount),0) as Avg_amount_per_order from orders_360_final as o
---------Total Sales By Channel
select channel_used, 
sum(total_amount) as Total_sales
from orders_360_final as o
group by channel_used
------Total sales by Time of the day
select time_of_day,
sum(total_amount) as Total_sales 
from orders_360_final as o
group by time_of_day
order by Total_sales
----------Top 5 orders in terms of Total AMount
select top 5 order_id,
sum(total_amount) as Total_amount 
from orders_360_final as o
group by order_id
order by Total_amount desc


---------------------------------------------------------------------------Kpis------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
select 
count(*) as Total_orders,
sum(quantity) as Total_quantity_sold,
round(sum(total_amount),2) as Total_sales,
round(sum(discount),2) as Total_discount_given,
sum(items_with_discount) as Items_with_discount,
round(sum(total_cost),2) as Total_cost,
round(sum(total_profit),2) as Total_profit,
sum(orders_with_loss) as Total_loss_making_orders,
sum(orders_with_high_profit) as Total_high_profit_orders,
sum(distinct_categories) as Total_distinct_categories,
sum(weekend_trans_flag) as Weekend_orders,
sum(orders_with_discount) as Orders_with_discount,
round(avg(profit_margin_percent),2) as Avg_profit_margin_percent,
sum(Total_Amount)/ count(Order_id) as Avg_Revenue, AVG(Total_profit)
from orders_360_final


SELECT * from orders_360_final

select 
count(*) as Total_customers,
sum(total_quantity) as Total_items_bought,
round(sum(total_spent),2) as Total_spent,
round(sum(Total_Discount_Recieved),2) as Total_discount_received,
round(avg(Avg_rating_given),2) as Avg_rating, sum(Total_Spent)/ count(Customer_id) avg_spent_per_cust 
from customers_360_final

select * from stores_360_final

select 
count(*) as Total_stores,
round(sum(total_sales),2) as Total_sales,
count(distinct seller_state),
count(distinct city) as Total_stores_in_city
from stores_360_final
-----------------------------------------------------------------Kpis--------------------------------------------------------------------

-------------------no of orders by time of the day 
select time_of_day, 
count(order_id) as Total_orders 
from orders_360_final
group by time_of_day

------------------total sales and total orders by channel

select channel_used, 
count(*) as Order_count,
round(sum(total_amount),2) as Total_amount 
from orders_360_final
group by channel_used
----------------------sales by week(sun,mon,tue,wed,thu,fri,sat)
select day_of_week, 
count(order_id) as Total_orders, 
round(avg(total_amount),0) as Avg_sales from orders_360_final
group by day_of_week order by Total_orders desc
----------------------------------------------------customer segmentation (High value ,low value and medium value)

select 
case 
when total_spent > 1000 then 'high value'
when total_spent between 300 and 1000 then 'mid value'
else 'low value'
end as Customer_value,
count(*) as Customer_count
from customers_360_final
group by 
case 
when total_spent > 1000 then 'high value'
when total_spent between 300 and 1000 then 'mid value'
else 'low value'
end

select * from stores_360_final

---------weekdays vs weekend transactions
select round(sum(weekday_transactions),2) as Weekdays_orders, 
round(sum(weekend_transactions),2) as Weekend_orders from stores_360_final

select * from customers_360_final
------------------------- Top 5 customers in terms of sales
select top 5 custid as Customer_id,
round(sum(total_spent),2) as Total_spent
from customers_360_final 
group by custid 
order by Total_spent desc
-----------Top 5 order ids in terms of sales
select top 5 order_id , 
round(sum(total_amount),2) as Total_spent 
from orders_360_final 
group by order_id order by Total_spent desc
-------Gender proportion
select gender,
round(count(*) * 100.0 / (select count(*) from customers_360_final), 2) as Gender_percentage
from customers_360_final
group by gender
-------------------Gender level spent-------
select gender,
round(sum(total_spent),0) as Spent
from customers_360_final
group by gender 
order by Spent desc

------------------------Top 5 performing states in terms of  sales
select top 5 seller_state, 
round(sum(total_sales),0) as Total_sales
from stores_360_final 
group by seller_state 
order by Total_sales desc
--------------------Top 5 performing store ids
select top 5 store_id, 
round(sum(total_sales),0) as Total_sales
from stores_360_final 
group by store_id
order by Total_sales desc

select * from customers_360_final

------------no of Inactive customers--------

select 
count(case when inactive_days > 180 then custid end) as inactive_customer_count
from customers_360_final

--------------total sales and avg spent by states

select top 5 customer_city, 
count(*) as Customer_count, 
avg(total_spent) as Avg_spent 
from customers_360_final 
group by customer_city
order by Customer_count desc

-------------
----------One Time vs Repeat Buyer-------

select 
case when total_order_placed = 1 then 'one-time buyer' else 'repeat buyer' end as Customer_type,
count(*) as Customer_count,
round(avg(total_spent),0) as Avg_spent 
from customers_360_final 
group by 
case when total_order_placed = 1 then 'one-time buyer' else 'repeat buyer' end

--------------------Payment type used by diffrerent customers

select count(distinct case when credit_card_transactions > 0 then custid end) as Credit_card_users, 
count(distinct case when debit_card_transactions > 0 then custid end) as Debit_card_users,
count(distinct case when upi_transactions > 0 then custid end) as Upi_users,
count(distinct case when voucher_transactions > 0 then custid end) as Voucher_users
from customers_360_final

----------------Percentage of discount seeking customers

select 
count(case when transactions_with_discount > 0 then custid end) *100 / count(*) as Discount_percentage
from customers_360_final
-------------------percentage of overall customers by every states
select
customer_state,
count(*) * 100.0 / (select count(*) from customers_360_final) as Customer_percentage
from customers_360_final
group by customer_state

select * from customers_360_final

----------------churn Rate
select count(*) * 100 / (select count(*) from customers_360_final) as Churn_rate 
from customers_360_final where inactive_days > 182

---------- State wise percentage of male and female

with cte as (
select customer_state, 
count(*) as C_count 
from customers_360_final
group by customer_state
)
select Top 5
c.customer_state, c.gender, 
count(*) * 100.0 / c1.c_count as Gender_percentage 
from customers_360_final as c 
join cte as c1 on c1.customer_state = c.customer_state
group by c.customer_state, c.gender, c1.c_count
order by c.customer_state, c.gender


Select gender, count(*) *100/ (Select count(*) from customers_360_final) as Gender_count 
from customers_360_final
Group by gender




select * from orders_360_final

-------------High Rated Orders and low rated orders---------
Select case
when Avg_Ratings >= 4 then 'High Rated' Else 'Low Rated' End as Rating_slabs, count(*) as Orders
from orders_360_final
Group by case when Avg_Ratings >= 4 then 'High Rated' Else 'Low Rated' End 


Select 
case when Avg_Ratings  >=4 then 'High Rated' Else 'Low Rated' end as Rating_slabs
, count(*) As Total_orders  from orders_360_final group by case when Avg_Ratings  >=4 then 'High Rated' Else 'Low Rated' end

--------High Profit Vs Low Profit--------------------------

 
 Select
 case when Orders_with_high_profit = 1 then 'High Profitable Order' Else 'Low Profitable Order' end as Profit_Bucket,
 count(*) Total_orders
 from orders_360_final
 group by case when Orders_with_high_profit = 1 then 'High Profitable Order' Else 'Low Profitable Order' end




 select * from stores_360_final

 Select seller_state, count(store_id) as Total_Stores from stores_360_final
 group by seller_state
 order by Total_Stores desc 


 Select Top 5 store_id, Sum(Total_products_sold) As Products, Sum(Total_profit) As Profit from stores_360_final
 group by store_id
 order by profit desc
-----------------Observation : More then 50% of orders placed in evening between 6 pm to 11pm
 With Cte As (
 Select store_id, Sum(Total_products_sold) as Products_sold from stores_360_final
 Group by store_id), cte2 as

( Select s.store_id ,
Sum(Evening_orders) *100.0 / ct.Products_sold as Evening_orders_percentage from stores_360_final as s Join Cte as ct on ct.store_id= s.store_id
group by s.store_id
,ct.Products_sold)
 Select * from cte2 
 ----------Evening order percentage
 Select sum(Evening_orders) *100/ (Select  sum(Total_products_sold)from stores_360_final) as Everning_order_percentage from stores_360_final




 select * from Finalised_Records_1

 SELECT DISTINCT 
Category,
SUM(Total_Amount) AS Total_Revenue,
COUNT(DISTINCT order_id) AS Total_Orders
FROM Finalised_Records_1
GROUP BY Category
select * from order_360_final







 ------------- Category wise total sales and sales percentage

Select  category, round(sum(Total_Amount),2) as Revenue, 
round(sum(Total_Amount) *100 / (Select sum(Total_amount) from Finalised_Records_1),2) as Revenue_percentage
from Finalised_Records_1
 group by category
 order by Revenue desc

 ---------Most profitable category
 Select  category, round(sum(o.Total_profit),2) as Profit
from Finalised_Records_1 as f 
join order_360_final as o on o.Order_id = f.order_id
group by Category
------order by Profit desc

-----------MoM customers count

With cte as (
Select FORMAT(CAST(bill_date_timestamp AS DATETIME), 'MMM-yyyy') as Months,
count(c.custid) customers_count
from customers_360_final as c join Finalised_Records_1 as f
on f.Customer_id=c.custid
group by FORMAT(CAST(bill_date_timestamp AS DATETIME), 'MMM-yyyy')
) , cte2 as(
select Months, customers_count,
LAG(customers_count) over(order by Months) as Previous_months_cust,
customers_count - LAG(customers_count) over(order by Months) as MoM_Change

from cte)

select months,
--customers_count, Previous_months_cust,
MoM_Change, 
(MoM_Change*100/Previous_months_cust) as MOM_percentage_change from cte2


Select Top 10 Category, round(avg(Avg_rating),2) as ratings from Finalised_Records_1
group by Category
order by ratings desc


Select Top 10 Category, round(avg(Avg_rating),2) as ratings from Finalised_Records_1
group by Category
order by ratings 


select  seller_state,round( avg(Avg_rating),2) as Avg_ratings
from Finalised_Records_1
group by seller_state
order by Avg_ratings desc


select Top 5 Delivered_StoreID ,round( avg(Avg_rating),2) as Avg_ratings
from Finalised_Records_1
group by Delivered_StoreID
order by Avg_ratings desc

select Top 10 ,round( avg(Avg_rating),2) as Avg_ratings
from Finalised_Records_1
group by product_id
order by Avg_ratings desc



select Channel,round( avg(Avg_rating),2) as Avg_ratings from Finalised_Records_1
group by Channel
order by Avg_ratings desc


select Region, Channel, round( avg(Avg_rating),2) as Avg_ratings from Finalised_Records_1
group by Region,Channel
order by Region desc






SELECT FORMAT(CAST(Bill_date_timestamp AS datetime), 'MMM') AS Months,
ROUND(SUM(TOTAL_AMOUNT),2) AS Revenue, ROUND(SUM(TOTAL_AMOUNT)* 100/ (SELECT  SUM(Total_Amount)FROM order_360_final),2) AS Revenue_percentage
FROM order_360_final
GROUP BY FORMAT(CAST(Bill_date_timestamp AS datetime), 'MMM')


Select 
DATEPART(QUARTER,bill_date_timestamp) as Quarter,ROUND( Sum(total_amount) ,2 )as Revenue
from order_360_final
group by DATEPART(QUARTER,bill_date_timestamp)
order by Quarter



SELECT  Category, round(AVG(Avg_rating),2) Avg_Ratings FROM Finalised_Records_1
GROUP BY Category
order by Avg_Ratings desc

select Top 5 product_id, round(sum(Total_Amount),2) as Revenue from Finalised_Records_1
group by product_id
order by revenue desc

SELECT round(AVG(total_discount),2) AVG_DISCOUNT FROM customers_360_final

SELECT round(SUM(total_spent),2) AS Total_spent FROM customers_360_final


select Round(sum(Total_cost),2) as Total_Cost from order_360_final







Select avg(No_of_items) from orders_360_final

select count(  product_id)/ count( distinct order_id)  from Finalised_Records_1




with cte as (
select FORMAT(cast(Bill_date_timestamp as datetime), 'MMM-yyyy') as Months,
sum(Total_Amount) as Revenue
from orders_360_final
group by FORMAT(cast(Bill_date_timestamp as datetime), 'MMM-yyyy')
) , cte2 as 
--------select * from cte
(
select Months, Revenue, LAG(Revenue) over(order by Months) as previous_months from cte)
select Months, Revenue,previous_months, (previous_months - Revenue) as mom_change from cte2 


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'orders_360_final'

SELECT sum(Total_Amount) FROM orders_360_final

select sum(total_spent) from customers_360_finalA





select C.Gender,count(C.Gender) as Gender_count,
     SUM(O.) as Total_Amount, SUM(O.Total_Amount) * 100.0 / 
        (SELECT SUM(Total_Amount) FROM orders_360_final) AS pct_ctr
from customers_360_final as C
join  orders_360_final as O 
on C.custid = O.CUSTOMER_ID
group by C.Gender

SELECT
SELECT FROM customers_360_final  AS C JOIN orders_360_final AS O 
ON O




select sum(Discount)*100.0/sum(Total_Amount) as Discount_percentage_of_sales from Finalised_Records_1


select sum(Total_Amount)/sum(No_of_items) from orders_360_final

select * from orders_360_final


select sum(No_of_items) as Total_products_sold from orders_360_final


Select sum(Total_Amount)/ sum(No_of_items) from orders_360_final

select  distinct category from Finalised_Records_1
Select Top 1 product_id, sum(Total_Amount) as total from Finalised_Records_1
group by product_id
order by total desc
Select sum(profit) from Finalised_Records_1

select distinct Category from Finalised_Records_1
--------------CHURN RATE--------------
WITH PERCENTILE AS (
select Customer_id, PERCENTILE_CONT(0.40) WITHIN GROUP(ORDER BY INACTIVE_DAYS)OVER() AS P33
from customers_360_Final
) SELECT 
ROUND(CAST(SUM(CASE WHEN Inactive_Days > P33 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(DISTINCT C.Customer_ID) * 100, 2) AS Churn_Rate
FROM 
 PERCENTILE AS P JOIN customers_360_Final AS C 
ON P.CUSTOMER_ID = C.Customer_id

-------------------------RETENTION RATE---------------
WITH PERCENTILE AS (
select Customer_id, PERCENTILE_CONT(0.40) WITHIN GROUP(ORDER BY INACTIVE_DAYS)OVER() AS P33
from customers_360_Final
)-- , RETENTION_RATE AS ( 
SELECT 
ROUND(CAST(SUM(CASE WHEN Inactive_Days > P33 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(DISTINCT C.Customer_ID) * 100, 2) AS Churn_Rate
FROM 
 PERCENTILE AS P JOIN customers_360_Final AS C 
ON P.CUSTOMER_ID = C.Customer_id)
SELECT 100-CHURN_RATE FROM RETENTION_RATE


select count(distinct seller_state),count(distinct city) from stores_360_final


select Top 1 store_id, sum(Total_sales) as Total from stores_360_final
group by store_id
order by Total 

SELECT Channel, 
SUM(Total_Amount) AS TOTAL_REVENUE,
SUM(Total_Amount)*100.0/ (SELECT  SUM(Total_Amount) FROM Finalised_Records_1)
AS percentage_contri,
SUM(Total_Amount) OVER (ORDER BY Total_Amount DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Sales
FROM Finalised_Records_1
group by Channel
order by TOTAL_REVENUE desc


WITH ChannelRevenue AS (
    SELECT 
        Channel,
        SUM(Total_Amount) AS TOTAL_REVENUE
    FROM Finalised_Records_1
    GROUP BY Channel
),
WithPercentage AS (
    SELECT 
        Channel,
        TOTAL_REVENUE,
        TOTAL_REVENUE * 100.0 / SUM(TOTAL_REVENUE) OVER () AS percentage_contri
    FROM ChannelRevenue
),
FinalOutput AS (
    SELECT 
        *,
        SUM(TOTAL_REVENUE) OVER (ORDER BY TOTAL_REVENUE DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Sales
    FROM WithPercentage
)
SELECT *
FROM FinalOutput
ORDER BY TOTAL_REVENUE DESC


WITH ChannelRevenue AS (
    SELECT 
        Channel,
        SUM(Total_Amount) AS TOTAL_REVENUE
    FROM Finalised_Records_1
    GROUP BY Channel
),
WithPercentage AS (
    SELECT 
        Channel,
        TOTAL_REVENUE,
        TOTAL_REVENUE * 100.0 / SUM(TOTAL_REVENUE) OVER () AS percentage_contri
    FROM ChannelRevenue
),
WithCumulative AS (
    SELECT 
        *,
        SUM(percentage_contri) OVER (ORDER BY TOTAL_REVENUE DESC 
                                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_percentage
    FROM WithPercentage
)
SELECT *
FROM WithCumulative
ORDER BY TOTAL_REVENUE DESC;

WITH PAYMENT AS (
SELECT payment_type, ROUND(SUM(Payment_value),0) AS REVENUE   FROM orderpayments1
GROUP BY payment_type
)---, PERCENTAGE_ AS (
SELECT payment_type, REVENUE, REVENUE*100/SUM(REVENUE) OVER() AS PERCENTAGE_CONTRI FROM PAYMENT
SELECT * FROM PAYMENT
)


select Format(cast(Bill_date_timestamp as datetime), 'ddd') as Days_, round(avg(Total_Amount),2) as Average,
avg()
from Finalised_Records_1
group by Format(cast(Bill_date_timestamp as datetime), 'ddd')

select * from Finalised_Records_1


select Datepart(QUARTER,Bill_date_timestamp),Avg(total_amount) as Average_Sales  from Finalised_Records_1
group by Datepart(QUARTER,Bill_date_timestamp)


SELECT 
  FORMAT(cast(Bill_date_timestamp as datetime), 'yyyy') + '-Q' + 
  CAST(DATEPART(QUARTER, Bill_date_timestamp) AS VARCHAR) AS Year_Quarter,
  SUM(Total_Amount) as Total_Revenue,
  count(distinct order_id)*100.0/(select count(distinct order_id) from Finalised_Records_1) as orders_percentage
FROM Finalised_Records_1
group by FORMAT(cast(Bill_date_timestamp as datetime), 'yyyy') + '-Q' + 
  CAST(DATEPART(QUARTER, Bill_date_timestamp) AS VARCHAR)
  order by Year_Quarter


WITH QuarterData AS (
  SELECT 
    FORMAT(CAST(Bill_date_timestamp AS datetime), 'yyyy') + '-Q' + 
      CAST(DATEPART(QUARTER, Bill_date_timestamp) AS VARCHAR) AS Year_Quarter,
    COUNT(DISTINCT order_id) AS Order_Count,
    SUM(Total_Amount) AS Total_Revenue
  FROM Finalised_Records_1
  GROUP BY 
    FORMAT(CAST(Bill_date_timestamp AS datetime), 'yyyy') + '-Q' + 
      CAST(DATEPART(QUARTER, Bill_date_timestamp) AS VARCHAR)
)

SELECT 
  Year_Quarter,
  Total_Revenue,
  Order_Count * 100.0 / SUM(Order_Count) OVER () AS orders_percentage,
  Total_Revenue * 100.0 / SUM(Total_Revenue) OVER () AS revenue_percentage--,
  --SUM(Order_Count) OVER (ORDER BY Year_Quarter) * 100.0 / 
    --SUM(Order_Count) OVER () AS cumulative_orders_percentage,
  ---SUM(Total_Revenue) OVER (ORDER BY Year_Quarter) * 100.0 / 
    ---SUM(Total_Revenue) OVER () AS cumulative_revenue_percentage
FROM QuarterData
ORDER BY Year_Quarter;



select  customer_state, ROUND(sum(Total_Spent),0) as Total_spents,
sum(Total_Spent)*100.0/(select  sum(Total_Spent) from customers_360_Final) PERCENTAGE_OF_SPENT 
from customers_360_Final
GROUP BY customer_state
ORDER BY Total_spents DESC