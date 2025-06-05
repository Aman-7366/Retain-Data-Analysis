select * from Orders_tbl_dummy
with   Cust_order as (select A.Customer_id, A.Order_id, round(sum(A.Total_Amount),0) as Total_amt from Orders_tbl_dummy A
group by A.Customer_id, A.Order_id),

Orderpayment_grouped as(select  A.order_ID, round(sum(A.payment_value),0) as pay_value_total from OrderPayments_dummy
A group by A.Order_id),

Match_order as (select A.* from Cust_order as A inner join Orderpayment_grouped as B 
on A.Order_id =B.order_ID and A.Total_amt=B.pay_value_total)
 

select * into Matched_order_1 from Match_order

select * from Matched_order_1
select * from Orders_tbl_dummy



WITH Cust_order AS (
    SELECT 
        A.Customer_id, 
        A.Order_id, 
        Round(sum(A.Total_Amount),0) AS Total_amt 
    FROM 
        Orders A
    GROUP BY 
        A.Customer_id, 
        A.Order_id
),

Orderpayment_grouped AS (
    SELECT 
        A.Order_ID, 
        Round(sum(A.payment_value ),0) AS pay_value_total 
    FROM 
        OrderPayments_dummy A
    GROUP BY 
        A.Order_ID
),
--- We are right joining as we are having null values 
Null_list AS (
    SELECT 
        B.* ,
    FROM 
        Cust_order AS A 
    RIGHT JOIN 
        Orderpayment_grouped AS B 
    ON 
        A.Order_id = B.Order_ID 
        AND A.Total_amt = B.pay_value_total
    WHERE A.Customer_id IS NULL
) 

,
Remaining_ids as (SELECT 
    B.Customer_id ,B.Order_id,A.pay_value_total
FROM 
    Null_list  A inner join Orders_tbl_dummy B on A.Order_ID =B.Order_id and  A.pay_value_total = round(B.Total_Amount,0))	
	


	-----select * from Remaining_ids
select * into Remaining_orders_1 from Remaining_ids
select * from  Remaining_orders_1


-- Step i: CTE to get total amount per customer per order from Orders table
WITH Cust_order AS (
    SELECT 
        customer_id,
        order_id,
        ROUND(SUM(total_amount), 0) AS total_amt
    FROM Orders_tbl_dummy
    GROUP BY customer_id, order_id
),

-- Step ii: CTE to get total payment value per order from OrderPayments_dummy
Orderpayment_grouped AS (
    SELECT 
        order_id,
        ROUND(SUM(payment_value), 0) AS payment_amt
    FROM OrderPayments_dummy
    GROUP BY order_id
),

-- Step iii: Right join to find mismatches where total_amt ≠ payment_amt
Null_list AS (
    SELECT 
        opg.order_id,
        co.customer_id,
        co.total_amt,
        opg.payment_amt
    FROM Cust_order co
    RIGHT JOIN Orderpayment_grouped opg ON co.order_id = opg.order_id AND co.total_amt = opg.payment_amt
    WHERE co.customer_id IS NULL  -- Means there was no exact match in amounts
)
----------select * from null_list
,

-- Step iv: Join to get full customer and order info for mismatched orders
Remaining_ids 
AS (
    SELECT 
        o.customer_id,
        o.order_id,
        ROUND(SUM(o.total_amount), 0) AS total_amt,
        op.payment_amt
    FROM Orders_tbl_dummy o
    JOIN (
        SELECT order_id, payment_amt FROM Null_list
    ) AS op ON o.order_id = op.order_id
    GROUP BY o.customer_id, o.order_id, op.payment_amt
)

-- Step v: Store the final result in a new table
SELECT * INTO Remaining_orders_1 FROM Remaining_ids;
select  * from Remaining_orders_1
select r.order_id, round(payment_value,0), pay_value_total from Remaining_orders_1 as r join OrderPayments_dummy as op on 
op.order_id = r.order_id 

select * from OrderPayments_dummy where order_id ='713eda1fb337fff2cccfae60fd0b411e'
'00571ded73b3c061925584feab0db425'
9

with T1 as (select B.* from Matched_order_1 A inner join Orders_tbl_dummy B on A.Customer_id=B.Customer_id and A.Order_id =B.Order_id),
	T2 as (select a.* from Remaining_orders_1 A inner join  Orders_tbl_dummy B on A.Customer_id=B.Customer_id
	and A.Order_id =B.Order_id and A.pay_value_total=round(B.Total_Amount,0) ),

	T as (select * from T1 union all select * from T2 )

	select * from t
	Select * into NEW_ORDER_TABLE_1 from T
	select * from NEW_ORDER_TABLE_1
	where order_id ='d6f83d3377bbf1697831ea355301fb87'
	select * into cross_check from(
	select * from ORDERS_NEW
	where Customer_id not in 

	(select Customer_id from NEW_ORDER_TABLE_1)) a

	select *from cross_check

	select *,rank()over(partition by customer_id,order_id order by quantity desc) from ORDERS_NEW
	


Select * into Integrated_Table_1 from (select A.*, D.Category ,C.Avg_rating,E.seller_city ,E.seller_state,E.Region,F.customer_city,
F.customer_state,F.Gender from NEW_ORDER_TABLE_1 A  
	inner join (select A.ORDER_id,avg(A.Customer_Satisfaction_Score) as Avg_rating from OrderReview_Ratings A group by A.ORDER_id)
	as C on C.ORDER_id =A.Order_id 
	inner join productsinfo as D on A.product_id =D.product_id
	inner join (Select distinct * from Stores_Info) as E on A.Delivered_StoreID =E.StoreID
	inner join Customers as F on A.Customer_id =F.Custid) as T

Select * From Integrated_Table_1



Select * Into Finalised_Records_no from (
Select * From Integrated_Table_1

UNION ALL

(Select T.Customer_id,T.order_id,T.product_id,T.Channel,T.Delivered_StoreID,T.Bill_date_timestamp,
Sum(T.Net_QTY)as Quantity,T.Cost_Per_Unit,
T.MRP,T.Discount,SUM(Net_amount) as Total_Amount ,C.Category,F.Customer_Satisfaction_Score as Avg_rating,
G.seller_city,G.seller_state,G.Region,E.customer_city,E.customer_state,E.Gender
from (
Select Distinct A.*,(A.Total_Amount/A.Quantity) as Net_amount, (A.Quantity/A.Quantity) as Net_QTY From Orders A
join Orders B
on A.order_id = B.order_id
where A.Delivered_StoreID <> B.Delivered_StoreID 
) as T
Inner Join productsinfo C
on T.product_id = C.product_id
inner join orderpayments as D
on T.order_id = D.order_id
inner Join Customers As E
on T.Customer_id = E.Custid
inner join OrderReview_Ratings F
on T.order_id = F.order_id
inner join Stores_Info G
on T.Delivered_StoreID = G.StoreID
Group by T.Customer_id,T.order_id,T.product_id,T.Channel,T.Bill_date_timestamp,T.Cost_Per_Unit,T.Delivered_StoreID,
T.Discount,T.MRP,T.Total_Amount,T.Quantity,T.Net_amount,T.Net_QTY,C.Category,F.Customer_Satisfaction_Score,
G.seller_city,G.seller_state,G.Region,E.customer_city,E.customer_state,E.Gender) 
) AS x

select * from Finalised_Records_no
------------ Creating the Table and storing the above Code output to Add_records table------------

Select * into Add_records from (
Select T.Customer_id,T.order_id,T.product_id,T.Channel,T.Delivered_StoreID,T.Bill_date_timestamp,
Sum(T.Net_QTY)as Quantity,T.Cost_Per_Unit,
T.MRP,T.Discount,SUM(Net_amount) as Total_Amount ,C.Category,F.Customer_Satisfaction_Score as Avg_rating,
G.seller_city,G.seller_state,G.Region,E.customer_city,E.customer_state,E.Gender
from (
Select Distinct A.*,(A.Total_Amount/A.Quantity) as Net_amount, (A.Quantity/A.Quantity) as Net_QTY From Orders_tbl_dummy A
join Orders_tbl_dummy B
on A.order_id = B.order_id
where A.Delivered_StoreID <> B.Delivered_StoreID 
) as T
Inner Join productsinfo C
on T.product_id = C.product_id
inner join orderpayments as D
on T.order_id = D.order_id
inner Join Customers As E
on T.Customer_id = E.Custid
inner join OrderReview_Ratings F
on T.order_id = F.order_id
inner join Stores_Info G
on T.Delivered_StoreID = G.StoreID
Group by T.Customer_id,T.order_id,T.product_id,T.Channel,T.Bill_date_timestamp,T.Cost_Per_Unit,T.Delivered_StoreID,
T.Discount,T.MRP,T.Total_Amount,T.Quantity,T.Net_amount,T.Net_QTY,C.Category,F.Customer_Satisfaction_Score,
G.seller_city,G.seller_state,G.Region,E.customer_city,E.customer_state,E.Gender) a




Select * Into Finalised_Records_2 From (
Select * From Finalised_Records_no
except
---------------Checking whether the records in Add_records table are also available with Integratable_Table _1 
(Select A.* From Add_records A
inner Join Integrated_Table_1 B
on A.order_id = B.order_id) 
) x
----- We found some records thus these needed to be deleted so using the Except function from Finalised Records 
----- And storing the data into new table Finalised_Records_1 
Select * From Finalised_Records_1


Select * from Add_records

---- Example for you all how to use the data set if you want the distinct Order and calculation
Select Distinct order_id, Sum(Total_Amount) From Finalised_Records_1
Group by order_id


--Main Table :

Select * From Finalised_Records_

drop table Customers
select * into customer from (
select  distinct * from customers_dummy) as o

------ ASSIGN SAME CUSTOMER_ID WITH SAME ORDER_ID


with cte as (
SELECT *, 
Rank() OVER( PARTITION BY ORDER_ID ORDER BY Total_Amount desc ) as rn
FROM Orders_tbl_dummy
)

---select count (distinct Customer_id) from cte where rn >1
update o
SET o.customer_id = c.Customer_id from Orders_tbl_dummy as o
join cte as c on 
o.order_id=c.order_id
AND O.product_id = c.product_id
where rn =1

---keep only those records where quantity is high but everything is same and delete rest of them

WITH CTE AS (
    SELECT *,
        Rank() OVER (PARTITION BY order_id, customer_id, product_id ORDER BY quantity DESC) AS rn 
    FROM Orders_tbl_dummy
)

---Select * from CTE where rn > 1
DELETE o
FROM Orders_tbl_dummy o
JOIN cte c 
ON o.order_id = c.order_id 
AND o.customer_id = c.customer_id
AND o.product_id = c.product_id
AND o.quantity = c.quantity  -- Ensure we match exactly the same row
WHERE c.rn > 1;
----
----(10230 rows affected)


---- AGGIGN SAME STORE_ID WHERE ORDER_ID IS SAME 

with cte as (
select *,
Rank() over (partition by customer_id,order_id order by delivered_storeid ) as rn
from Orders_tbl_dummy

)
-----select * from cte where rn >1       -------------1110 such records
update o 
set o.delivered_storeid = c. delivered_storeid
from Orders_tbl_dummy as o join
cte as c on o.order_id =c.order_id
AND c.customer_id= o.customer_id
where rn > 1
---(2193 rows affected)

select * from Orders_test

------------------------
WITH mapped AS (
    SELECT *,Row_number () OVER (PARTITION BY  Order_id  ORDER BY customer_id)
		   AS rn     
    FROM Finalised_Records_1
    ) 
	select * from mapped where rn > 1

	select * from Finalised_Records_1 where order_id = 'd77096ce04b7912640d76928106b9ad7'

update Orders_tbl_dummy
set Delivered_StoreID = B.Updated_StoreID
from Finalised_Records_1 as A
inner join mapped_stores AS B
on A.Customer_id = B.customer_id and
	A.order_id = B.Order_id
WHERE A.Deliver
-------------------------
---CHANGING DATA_TYPE OF Bill_date_timestamp
select * from Finalised_Records_1
	UPDATE Finalised_Records_1
SET Bill_date_timestamp = FORMAT(TRY_CONVERT(DATETIME, Bill_date_timestamp, 101), 'dd-MM-yyyy HH:mm:ss')
WHERE TRY_CONVERT(DATETIME, Bill_date_timestamp, 101) IS NOT NULL;
with cte as (
select Bill_date_timestamp,TRY_CONVERT(datetime,Bill_date_timestamp,101) AS A,
TRY_CONVERT(datetime,Bill_date_timestamp,102) AS D,TRY_CONVERT(datetime,Bill_date_timestamp,103)
AS E,TRY_CONVERT(datetime,Bill_date_timestamp,104) AS F from Finalised_Records_1
)
select A from cte where A is not null

---DELETE THOSE RECORDS WHEN ORDERS NOT IN SPECIFIED TIME PERIOD

select * from ORDERS_NEW

SELECT * 
FROM Orders_tbl_dummy
WHERE BILL_DATE_TIMESTAMP NOT BETWEEN '2021-09-01' AND '2023-10-31';

---(3 rows affected)

select * from Orders_tbl_dummy
where Customer_id = '7751512805'

----UPDATING BILL_DATE_TIMESTAMP
7751512805
7751512805
9853219612
3334764558
2965609691
WITH CTE AS (
SELECT *,
RANK()OVER(PARTITION BY CUSTOMER_ID, ORDER_ID,Delivered_storeid ORDER BY BILL_DATE_TIMESTAMP )
AS RNK FROM Orders_tbl_dummy
)
---select * from CTE where rnk > 1
UPDATE O 
SET O.BILL_DATE_TIMESTAMP = C.BILL_DATE_TIMESTAMP
FROM Orders_tbl_dummy
AS O JOIN CTE AS C
ON O.CUSTOMER_ID=C.CUSTOMER_ID
AND O.ORDER_ID=C.ORDER_ID

WHERE RNK =1


--CHECK IF A CUSTOMER IN ORDERS TABLE BUT NOT IN CUSTOMER TABLE 
select * from ORDERS O 
LEFT JOIN CUSTOMERS AS C
ON C.Custid = O.CUSTOMER_ID
where 
o.order_id is null
--NO SUCH RECORDS

SELECT Customer_id FROM Orders_tbl_dummy
WHERE Customer_id NOT IN (SELECT CUSTID FROM Customer)

---CHECK IF ANY RECORDS IN ORDER TABLE BUT NOT IN ORDER PAYMENTS TABLE 
SELECT O.order_id,OP.order_id FROM NEW_ORDER_TABLE_1 o
LEFT JOIN OrderPayments AS OP
ON O.ORDER_ID = OP.order_id
WHERE OP.ORDER_ID IS NULL
--1 ORDER_ID NOT IN ORDERPAYMENT TABLE  'bfbd0f9bdef84302105ad712db648a6c'
DELETE FROM Orders_test WHERE order_id ='bfbd0f9bdef84302105ad712db648a6c'
SELECT order_id FROM Orders_test
WHERE order_id NOT IN (SELECT ORDER_ID FROM OrderPayments)

---KEEP THOSE RECORDS FOR WHICH TOTAL AMOUNT IN ORDERS TABLE MATCHED WITH PAYMENT VALUES IN ORDER_PAYMENT TABLE
WITH AGGREGATED_ORDERS AS (
SELECT CUSTOMER_ID, ORDER_ID,ROUND(SUM(Total_Amount),0) AS tOTAL FROM Orders_test AS O
GROUP BY O.order_id, Customer_id
)
, AGGREGATED_ORDERSPAYMENT AS (
SELECT order_id,ROUND(SUM(payment_value),0) AS pAYMENT FROM OrderPayments AS OP
GROUP BY OP.order_id)

, MATCHED AS (SELECT A.* FROM AGGREGATED_ORDERS AS A JOIN AGGREGATED_ORDERSPAYMENT AS P ON A.order_id=P.order_id)

--------------,orders_new_copy as (Select ot.* from orders_test as ot join MATCHED as m1 on ot.order_id = m1.order_id  select * from orders_new_copy
-------------select * into Matched_copy from (select * from MATCHED) as b
SELECT O.* FROM Orders_test AS O INNER JOIN MATCHED P 
    ON O.Order_id = P.Order_ID 
    AND ROUND(O.Total_Amount, 0) = P.tOTAL

                        --------------------------------------------------------------------------------

	/*SELECT O.* FROM Orders_test AS O JOIN MATCHED_R
	AS M ON O.order_id = M.ORDER_ID AND O.Customer_id = M.CUSTOMER_ID AND ROUND(O.Total_Amount, 0) = M.TOTAL
	SELECT * INTO ORDERS_NEW FROM(
	SELECT O.* FROM Orders_test AS O JOIN MATCHED_R
	AS M ON O.order_id = M.ORDER_ID  AND ROUND(O.Total_Amount, 0) = M.TOTAL) AS O
	SELECT * FROM Orders*/

	
                        --------------------------------------------------------------------------------


DELETE O
-------select * 
FROM Orders_test as o
JOIN OrderPayments AS OP 
ON O.ORDER_ID = OP.order_id
WHERE O.TOTAL_AMOUNT>0
AND
OP.payment_value = 0


--DELETED 6 RECORDS

--- orderpaymment table updated

 WITH CTE AS (
    SELECT order_id, payment_type,round( SUM(payment_value),0)
	aS Total_value
    FROM OrderPayments
    GROUP BY order_id, payment_type
)
UPDATE OP
SET OP.payment_value = C.Total_value
FROM OrderPayments AS OP
JOIN CTE AS C
ON OP.order_id = C.order_id
AND OP.payment_type = C.payment_type

SELECT * FROM OrderPayments

with cte as (select Customer_id, order_id, round(sum(total_amount),0) as Total_amt
from Orders_tbl_dummy group by order_id, Customer_id) ,
cte2 as (select order_id, round(sum(payment_value),0) as Total_val from OrderPayments_dummy group by order_id)
, cte3 as (select A.order_id, Total_amt, Total_val from cte as A join cte2 as B on A.order_id = B.order_id)


select * into mismatched from cte3
where total_amt <> total_val

select * from Orders_tbl_dummy where order_id not in
(select order_id from mismatched)

--- UPDATED WITH AVERAGE OF RATING SCORES FOR EAVH ORDERS
with cte as (
select order_id,AVG(Customer_Satisfaction_Score) as Rating_score
from OrderReview_Ratings
group by order_id
)
UPDATE O
SET O.ORDER_ID = C.ORDER_ID
FROM OrderReview_Ratings AS O JOIN cte AS C
ON C.order_id =O.order_id
AND C.Rating_score=O.Customer_Satisfaction_Score



/*SELECT * FROM OrderReview_Ratings
WHERE order_id= '25320e12b3d6e8f54f17389037588bba'*/

--UPDATING CATEGORY COLUMN  WITH OTERS WHERE CATEGORY IS  #N/A

UPDATE Productsinfo
SET Category = 'Others'
where Category = '#N/A'

---UPDATED NULL WITH MOD OF THAT COLUMN
UPDATE ProductsInfo
SET product_name_lenght = (SELECT TOP 1  product_name_lenght
FROM ProductsInfo
WHERE product_name_lenght IS NOT NULL
GROUP BY product_name_lenght
ORDER BY COUNT(*) DESC)
WHERE product_name_lenght IS NULL


UPDATE ProductsInfo
SET product_description_lenght = (SELECT TOP 1  product_description_lenght
FROM ProductsInfo
WHERE product_description_lenght IS NOT NULL
GROUP BY product_description_lenght
ORDER BY COUNT(*) DESC)
WHERE product_description_lenght IS NULL


UPDATE ProductsInfo
SET product_photos_qty = (SELECT TOP 1  product_photos_qty
FROM ProductsInfo
WHERE product_photos_qty IS NOT NULL
GROUP BY product_photos_qty
ORDER BY COUNT(*) DESC)
WHERE product_photos_qty IS NULL


UPDATE ProductsInfo
SET product_height_cm = (SELECT TOP 1  product_height_cm
FROM ProductsInfo
WHERE product_height_cm IS NOT NULL
GROUP BY product_height_cm
ORDER BY COUNT(*) DESC)
WHERE product_height_cm IS NULL

UPDATE ProductsInfo
SET product_length_cm = (SELECT TOP 1  product_length_cm
FROM ProductsInfo
WHERE product_length_cm IS NOT NULL
GROUP BY product_length_cm
ORDER BY COUNT(*) DESC)
WHERE product_length_cm IS NULL

UPDATE ProductsInfo
SET product_weight_g = (SELECT TOP 1  product_weight_g
FROM ProductsInfo
WHERE product_weight_g IS NOT NULL
GROUP BY product_weight_g
ORDER BY COUNT(*) DESC)
WHERE product_weight_g IS NULL

UPDATE ProductsInfo
SET product_width_cm = (SELECT TOP 1  product_width_cm
FROM ProductsInfo
WHERE product_width_cm IS NOT NULL
GROUP BY product_width_cm
ORDER BY COUNT(*) DESC)
WHERE product_width_cm IS NULL

select * from ORDERS_NEW
SELECT * FROM Productsinfo


-----store table without duplicates   stores_info1

select * into stores_info1
from
(

select 
distinct storeid, seller_city,seller_state,Region
from Store_info
group by 
storeid, seller_city,seller_state,Region
) as p


select * from stores_info1
select * from OrderPayments
select * from OrderReview_Ratings
select * from Customers
select* from orders
select * from Productsinfo
select * from Customers_360

---CREATING CUSTOMERS_360
CREATE TABLE Customers_360c (
    custid INT PRIMARY KEY, 
    customer_city VARCHAR(100),
    customer_state VARCHAR(100),
    Gender VARCHAR(10),

	
    Total_Orders INT,
	
    Total_Spent DECIMAL(18,2),
    Avg_Rating DECIMAL(5,2)
);

INSERT INTO Customers_360c (custid, customer_city, customer_state, Gender, Total_Orders, Total_Spent, Total_Payment, Avg_Rating)
SELECT 
    C.Custid,
    C.customer_city,
    C.customer_state,
    C.Gender,P.Category,
	COUNT(p.product_id) AS Total_products_purchased,
    COUNT(O.Order_ID) AS Total_Orders,
    SUM(O.Total_Amount) AS Total_Spent,
    ROUND(AVG(O2.Customer_Satisfaction_Score), 2) AS Avg_Rating
FROM Customer C
LEFT JOIN NEW_ORDER_TABLE O ON C.Custid = O.Customer_ID
LEFT JOIN OrderPayments OP ON O.Order_ID = OP.Order_ID
LEFT JOIN OrderReview_Ratings O2 ON O.Order_ID = O2.Order_ID
LEFT JOIN Productsinfo AS P ON P.product_id = O.product_id
GROUP BY C.Custid, C.customer_city, C.customer_state, C.Gender,P.Category;

select * from customer



--creating store_360

CREATE TABLE stores_360 (
storeid VARCHAR(50) PRIMARY KEY,
seller_city VARCHAR(255),
seller_state VARCHAR(255),
region VARCHAR(255),
Total_sales DECIMAL(18,2),
Total_products_sold INT,
Discount DECIMAL(18,2),
Total_orders INT
);
INSERT INTO stores_360 (storeid, seller_city, seller_state, region, Total_sales, Total_products_sold, Discount, Total_orders)
SELECT 
    CAST(s.storeid AS VARCHAR(50)),
    s.seller_city,
    s.seller_state,
    s.region,
    ROUND(SUM(o.Total_amount), 0) AS Total_sales,
    SUM(o.quantity) AS Total_products_sold,
    SUM(o.discount) AS Discount,
    COUNT(o.order_id) AS Total_orders
FROM store_info AS s 
LEFT JOIN orders AS o 
ON o.delivered_storeid = s.storeid
GROUP BY s.storeid, s.seller_city, s.seller_state, s.region
ORDER BY Total_sales DESC;



select * from stores_360

update stores_360
set total_sales =0
where total_sales is null

update stores_360
set total_products_sold = 0
where total_products_sold is null

update stores_360
set discount = 0
where discount is null

 select * from stores_360

 --creating orders_360

 CREATE TABLE order_360 (
    order_id VARCHAR(50), 
    customer_id BIGINT,
	product_id VARCHAR(50),
    category VARCHAR(255),
    Deliverd_storeid VARCHAR(50),
    Bill_date_timestamp DATETIME,  
    Total_Amount DECIMAL(18,2),
    Discount DECIMAL(18,2),
    Total_quantity INT,
    customer_rating DECIMAL(3,2)
);
INSERT INTO order_360 (order_id, customer_id,product_id, category, Deliverd_storeid, Bill_date_timestamp, Total_Amount, Discount,Total_Quantity, customer_rating)
SELECT 
    O.order_id,
   CAST(ROUND( O.customer_id,0) AS BIGINT) AS Customer_id,
	  O.product_id,  
    P.category,
    O.delivered_storeid,
    O.Bill_date_timestamp,  
    
    ROUND(SUM(O.total_amount), 2) AS Total_Amount,
    ROUND(SUM(O.discount), 2) AS Discount,
    SUM(O.quantity) AS Total_quantity,
    ROUND(AVG(ORR.Customer_Satisfaction_Score), 2) AS customer_rating
FROM ORDERS_NEW AS O
LEFT JOIN OrderPayments AS OP ON O.order_id = OP.order_id
LEFT JOIN OrderReview_Ratings AS ORR ON O.order_id = ORR.order_id
LEFT JOIN Productsinfo AS P ON O.product_id = P.product_id 
GROUP BY O.order_id, O.customer_id, O.delivered_storeid, O.Bill_date_timestamp, O.product_id, P.category;

select * from order_360
select * from customers_360
select * from stores_360



SELECT * FROM NEW_ORDER_TABLE
WHERE order_id = '00b1cb0320190ca0daa2c88b35206009'



	


	select * into check_2 from (select o.order_id,round(sum(Total_Amount),0) as T_m ,round(sum(payment_value),0) as values_ 
	from Orders_tbl_dummy as o  join OrderPayments_dummy as op
	on o.order_id=op.order_id
	group by o.order_id
	having round(sum(Total_Amount),0) = round(sum(payment_value),0)) as a

	
	with cte as (select order_id, round(sum(total_amount),0) as t_m from Orders_tbl_dummy group by order_id),
	cte2 as (select order_id ,round(sum(payment_value),0) as P_v  from OrderPayments_dummy group by order_id ),
	cte3 as (select a.order_id,sum(t_m) as t,sum(P_v) as p from cte as a join cte2 as b on a.order_id=b.order_id and a.t_m = b.P_v 
	group by a.order_id )
	select * into check_ from cte3

	
	
	select  * from check_
	where order_id not in(select order_id from check_2)


	with cte1 as (
	select customer_id , order_id, round(sum(Total_Amount),0) as Total_amt from Orders_tbl_dummy
	group by Customer_id, order_id
	),
	cte2 as (select order_id,  round(sum(payment_value),0) as Total_val from OrderPayments_dummy
	group by order_id)
,cte3 as	(select b.order_id,b.Total_val,a.Customer_id from cte1 as A 
right join cte2 as B on a.order_id=b.order_id and  a.Total_amt = b.Total_val
	where customer_id is null),
	cte4 as (select b.Customer_id,b.order_id,a.Total_val from cte3  as a inner join 
	Orders_tbl_dummy as b on a.order_id= b.order_id and a.Total_val = round(b.total_amount,0))

	select * into remaining_orders from cte4          
/*	I used a right join to compare the Orders and OrderPayments tables. This helped me find the order IDs 
that exist in the OrderPayments table but don’t have a matching record in the Orders table — either because
they are missing or their amounts don’t match.

Then, for those unmatched records, I joined them again with the Orders table, this time using both order_id and the
rounded amount to find any valid matches.

As a result, I was able to retrieve customer details for some of those previously 
unmatched orders, meaning they existed in the orders table, but maybe weren’t matched earlier due
to rounding or data inconsistency.
*/
---------------------------------------------------------------------------------------------------------------------------------------

	with cte1 as (select B.* from Matched_order_1 A inner join Orders_tbl_dummy B on A.Customer_id=B.Customer_id and A.Order_id =B.Order_id),
	cte2 as (select B.* from Remaining_orders A inner join  Orders_tbl_dummy B on A.Customer_id=B.Customer_id and A.Order_id =B.Order_id and A.Total_val=round(B.Total_Amount,0) ),

	cte3 as (select * from cte1 union all select * from cte2 )

	---select * from cte3
	Select * into NEW_ORDER_TABLE from cte3
	

	
		


		select * from NEW_ORDER_TABLE_1
		order by customer_id


		select * from OrderPayments_dummy
		where order_id not in (select order_id from Orders_tbl_dummy)


		UPDATE Finalised_Records_1
SET Category = 'Others'
where Category = '#N/A'


select * from Finalised_Records_1

SELECT 
    customer_id,
    MIN(billdatetimestamp) AS first_bill,
    MAX(billdatetimestamp) AS last_bill,
    DATEDIFF(DAY, MIN(billdatetimestamp), MAX(billdatetimestamp)) AS time_period_days
FROM 
    your_table_name
GROUP BY 
    customer_id


	select * from Finalised_Records_1 where Bill_date_timestamp not between '2021-09-01' and '2023-10-31'
	with cte as (

	select *, Dense_Rank() over(partition by customer_id,order_id order by bill_date_timestamp desc) as rn  from Finalised_Records_1)
	select * from cte where rn >1

	select * from Finalised_Records_1 


SELECT *, DENSE_RANK() OVER (PARTITION BY CUSTOMER_ID,ORDER_ID ORDER BY DELIVERED_STOREID) FROM Finalised_Recor



