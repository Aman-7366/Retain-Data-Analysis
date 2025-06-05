


----------------------------------------Customer 360--------------------------------
WITH Payments_Agg AS (
SELECT 
order_id,
COUNT(DISTINCT payment_type) AS Distinct_Payment_Types,
COUNT(CASE WHEN payment_type = 'Voucher' THEN 1 END) AS Voucher_Payments,
COUNT(CASE WHEN payment_type = 'Credit_Card' THEN 1 END) AS Credit_Payments,
COUNT(CASE WHEN payment_type = 'Debit_Card' THEN 1 END) AS Debit_Payments,
COUNT(CASE WHEN payment_type = 'UPI/Cash' THEN 1 END) AS UPI_CASH_Payments
FROM orderpayments1
GROUP BY order_id
)

SELECT * INTO customers_360_Final FROM(SELECT 
F.Customer_id,
customer_city,
customer_state,
Gender,
MIN(Bill_date_timestamp) AS First_Transaction_Date,
MAX(Bill_date_timestamp) AS Last_Transaction_Date,
DATEDIFF(Day, MIN(Bill_date_timestamp), MAX(Bill_date_timestamp)) AS Tenure,
DATEDIFF(DAY, MAX(Bill_date_timestamp), (SELECT MAX(Bill_date_timestamp) FROM Finalised_Records_1)) AS Inactive_Days,
COUNT(DISTINCT F.order_id) AS Total_orders,
SUM(Total_Amount) AS Total_Spent,
SUM(Discount) AS Total_Discount_Recieved,
SUM(Quantity) AS Total_Quantity,AVG(Avg_rating) as Avg_rating_given,
COUNT(DISTINCT product_id) AS Distinct_Products,
COUNT(DISTINCT Category) AS Distinct_Categories,
COUNT(CASE WHEN Discount > 0 THEN 1 END) AS Transactions_With_Discount,
COUNT(Channel) AS Channels_used,
COUNT(DISTINCT Delivered_StoreID) AS Distinct_Stores,
COUNT(DISTINCT seller_city) AS Distinct_Cities,
COUNT(CASE WHEN Channel = 'Instore' THEN 1 END) AS Instore_Transactions,
COUNT(CASE WHEN Channel = 'Online' THEN 1 END) AS Online_Transactions,
COUNT(CASE WHEN Channel = 'Phone Delivery' THEN 1 END) AS Phone_Transactions,
SUM(ISNULL(P.Distinct_Payment_Types,0)) AS Distinct_Payment_Types,
SUM(ISNULL(P.Voucher_Payments,0)) AS Voucher_Payments,
SUM(ISNULL(P.Credit_Payments,0)) AS Credit_card_Payments,
SUM(ISNULL(P.Debit_Payments,0)) AS Debit_card_Payments,
SUM(ISNULL(P.UPI_CASH_Payments,0)) AS UPI_CASH_Payments,
COUNT(CASE WHEN DATENAME(WEEKDAY, Bill_date_timestamp) IN ('Saturday', 'Sunday') THEN 1 END) AS Weekend_Transactions,
COUNT(CASE WHEN DATENAME(WEEKDAY, Bill_date_timestamp) NOT IN ('Saturday', 'Sunday') THEN 1 END) AS Weekday_Transactions,
COUNT(CASE WHEN DATEPART(MONTH, Bill_date_timestamp) IN (3, 4, 5, 6) THEN 1 END) AS Summer_Transactions,
COUNT(CASE WHEN DATEPART(MONTH, Bill_date_timestamp) IN (7, 8, 9) THEN 1 END) AS Rainy_Transactions,
COUNT(CASE WHEN DATEPART(MONTH, Bill_date_timestamp) IN (10, 11, 12, 1, 2) THEN 1 END) AS Winter_Transactions
FROM Finalised_Records_1 AS F
left JOIN Payments_Agg AS P ON F.order_id = P.order_id
GROUP BY 
    F.Customer_id, customer_city, customer_state, Gender) as o
---------------------------------------------------STORE 360-------------------
select * into stores_360_final from (
select 
s.storeid as store_id, s.seller_city as city,s.seller_state, count(distinct o.product_id) as Total_products_sold, 
  sum(o.quantity) as Total_quantity_sold, round(sum(o.total_amount),2) as Total_sales, sum(o.discount) as Total_discount_given,
count(case when o.discount > 0 then 1 end) as Items_with_discount,
round(sum(o.cost_per_unit * o.quantity),2) as Total_cost,
round(sum(o.total_amount - o.discount - (o.cost_per_unit * o.quantity)),2) as Total_profit,
count(case when (o.total_amount - o.discount - (o.cost_per_unit * o.quantity)) < 0 then 1 end) as Loss_making_orders,
count(case when (o.total_amount - o.discount - (o.cost_per_unit * o.quantity)) > 100 then 1 end) as High_profit_orders,
count(distinct o.category) as Distinct_categories,
count(case when datepart(weekday, o.bill_date_timestamp) in (1, 7) then 1 end) as Weekend_transactions,
sum(case when datepart(weekday, o.bill_date_timestamp) not  in (1, 7) then 1 end) as Weekday_transactions,
count(case when datepart(hour, o.bill_date_timestamp) between 18 and 23 then 1 end) as Evening_orders,
round(sum(case when datepart(weekday, o.bill_date_timestamp) in (1, 7) then o.total_amount end),0) as Weekend_sales,
round(sum(case when datepart(weekday, o.bill_date_timestamp) not in (1, 7) then o.total_amount end),0) as Weekday_sales,
round(avg(o.total_amount), 2) as Avg_order_value,
round(avg(o.total_amount - o.discount - (o.cost_per_unit * o.quantity)), 2) as Avg_profit_per_transaction,
round(sum(o.total_amount - o.discount - (o.cost_per_unit * o.quantity)) / count(distinct o.customer_id), 2) as Avg_profit_per_customer,
count(distinct o.customer_id) as Distinct_customers,
round(count(*) * 1.0 / count(distinct o.customer_id), 2) as Avg_customer_visits,
round(avg(o.avg_rating),0) as Avg_rating_per_customer,
count(distinct case when o.channel = 'online' then o.order_id end) as Online_orders,
count(distinct case when o.channel = 'offline' then o.order_id end) as Offline_orders,
count(distinct case when o.channel = 'Phone Delivery' then o.order_id end) as Phone_delivery_orders,
count(distinct o.channel) as Total_channels_used
from  storesinfo as s  join finalised_records_1 as o on o.Delivered_StoreID = s.StoreID
group by s.StoreID, s.seller_city,s.seller_state
) as s

-----------------------------------------------------------ORDERS 360------------------------------------------------------------
select * into orders_360_final from(

select 
o.order_id as Order_id,
 o.Bill_date_timestamp,
count(distinct o.product_id) as No_of_items,
sum(o.quantity) as Quantity,
round(sum(o.total_amount), 2) as Total_Amount,
sum(o.discount) as Discount,
count(case when o.discount > 0 then 1 end) as Items_with_discount,
round(sum(o.cost_per_unit * o.quantity), 2) as Total_cost, AVG(o.Avg_rating) as Avg_Ratings,
round(sum(o.total_amount  - (o.cost_per_unit * o.quantity)), 2) as Total_profit,
count(case when (o.total_amount - o.discount - (o.cost_per_unit * o.quantity)) < 0 then 1 end) as orders_with_loss,
count(case when (o.total_amount - o.discount - (o.cost_per_unit * o.quantity)) > 50 then 1 end) as Orders_with_high_profit,
count(distinct o.category) as Distinct_categories,
max(case when datepart(weekday, o.bill_date_timestamp) in (1, 7) then 1 else 0 end) as Weekend_trans_flag,
max(case when o.discount > 0 then 1 else 0 end) as Orders_with_discount,
round((sum(o.total_amount - o.discount - (o.cost_per_unit * o.quantity)) * 1.0 / nullif(sum(o.total_amount), 0)) * 100, 2) as Profit_margin_percent,
max(datename(weekday, o.bill_date_timestamp)) as Day_of_week,
max(case 
when datepart(hour, o.bill_date_timestamp) between 6 and 11 then 'Morning'
when datepart(hour, o.bill_date_timestamp) between 12 and 17 then 'Afternoon'
when datepart(hour, o.bill_date_timestamp) between 18 and 21 then 'Evening'
else 'Night'
end) as Time_of_day,
max(case 
when o.channel = 'Online' then 'Online'
when o.channel = 'instore' then 'Instore'
when o.channel = 'Phone Delivery' then 'Phone Delivery'
else 'Other'
end) as Channel_used
from finalised_records_1 o
group by o.order_id, o.Bill_date_timestamp) as o




		


















