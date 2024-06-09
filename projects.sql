--Select all from table
select * from `km-revou-sql-class-416914.Portofolio.Coffee Sales` 
order by transaction_id;

--Count Total Transaction --> 149116
select count(transaction_id) as Total_Transaction from `km-revou-sql-class-416914.Portofolio.Coffee Sales`;

--Count Total Transaction per Hour
select extract(hour from transaction_time) as Hour, count(transaction_id) as Total_Transaction
from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
group by 1
order by 1;

--Count Total Transaction per Month
select extract(month from transaction_date) as Month, format_date('%B', transaction_date) as Month_Name ,count(transaction_id) as Total_Transaction
from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
group by 1,2
order by 1;

--Total Revenue
select cast(sum(transaction_qty * unit_price)as int64) as Total_Revenue
from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
order by 1;

--Average Unit Price
select round(avg(unit_price),2) as Average_Unit_Price
from `km-revou-sql-class-416914.Portofolio.Coffee Sales`;

--Product Quantity Sold and Revenue
select product_id, product_detail, product_type, product_category, sum(transaction_qty) as Total_Sold, cast(sum(transaction_qty * unit_price)as int64) as Total_Revenue
from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
group by 1,2,3,4
order by 6 desc;

--Product Category Quantity Sold and Revenue
select product_category, sum(transaction_qty) as Total_Sold, cast(sum(transaction_qty * unit_price)as int64) as Total_Revenue
from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
group by 1
order by 3 desc;

--Product Type Quantity Sold and Revenue
select product_type, product_category, sum(transaction_qty) as Total_Sold, cast(sum(transaction_qty * unit_price)as int64) as Total_Revenue
from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
group by 1,2
order by 4 desc;


--Store Location Sales
select store_id, store_location,sum(transaction_qty) as Total_Sold, cast(sum(transaction_qty * unit_price)as int64) as Total_Revenue
from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
group by 1,2
order by 4 desc;

--CTE Monthly Sales
with MonthlySales as(
  select
    extract(month from transaction_date) as Month
    ,format_date('%B',transaction_date) as Month_Name
    ,count(distinct transaction_id) as Total_Transaction
    ,sum(transaction_qty) as Total_Sold
    ,cast(sum(transaction_qty * unit_price) as int64) as Total_Revenue
  from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
  group by 1,2
  order by 1
)

  select
    Month
    ,Month_Name
    ,Total_Transaction
    ,Total_Sold
    ,Total_Revenue
  from
    MonthlySales



--CTE Monthly Sales with Most Sold Product
WITH MostSoldProduct AS (
  SELECT
    EXTRACT(MONTH FROM transaction_date) AS Month,
    FORMAT_DATE('%B', transaction_date) AS Month_Name,
    product_id AS Product_ID,
    product_detail AS Product_Name,
    product_type AS Product_Type,
    product_category AS Product_Category,
    SUM(transaction_qty) AS Total_Sold,
    CAST(SUM(transaction_qty * unit_price) AS INT64) AS Total_Revenue
  FROM `km-revou-sql-class-416914.Portofolio.Coffee Sales`
  GROUP BY 1, 2, 3, 4, 5, 6
),
  
MaxSold AS (
  SELECT
    Month,
    MAX(Total_Sold) AS Max_Sold
  FROM MostSoldProduct
  GROUP BY 1
)

SELECT
  Month
  ,Month_Name
  ,Product_ID
  ,Product_Name
  ,Product_Type
  ,Product_Category
  ,Total_Sold
  ,Total_Revenue
FROM MostSoldProduct
order by 1


SELECT
  msp.Month,
  msp.Month_Name,
  msp.Product_ID,
  msp.Product_Name,
  msp.Product_Type,
  msp.Product_Category,
  msp.Total_Sold,
  msp.Total_Revenue
FROM MostSoldProduct msp
JOIN MaxSold ms
ON msp.Month = ms.Month AND msp.Total_Sold = ms.Max_Sold
ORDER BY msp.Month;


-----------Analysis by Category-------------------
with CategorySales as(
  select
    extract(month from transaction_date) as Month
    ,format_date('%B', transaction_date) as Month_Name
    ,product_id as Product_ID
    ,product_detail as Product_Name
    ,product_type as Product_Type
    ,product_category as Product_Category
    ,sum(transaction_qty) as Total_Sold
    ,cast(sum(transaction_qty * unit_price) AS int64) as Total_Revenue
    from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
    group by 1,2,3,4,5,6
)

  select
    Month
    ,Month_Name
    ,Product_ID
    ,Product_Name
    ,Product_Type
    ,Product_Category
    ,Total_Sold
    ,Total_Revenue
  from CategorySales
  order by 3,4

  ------------------------------------------------------------------------

-----------Analysis by Category per Store-------------------

with CategorySales as(
  select
    extract(month from transaction_date) as Month
    ,format_date('%B', transaction_date) as Month_Name
    ,store_id as Store_ID
    ,store_location as Store_Location
    ,product_id as Product_ID
    ,product_detail as Product_Name
    ,product_type as Product_Type
    ,product_category as Product_Category
    ,sum(transaction_qty) as Total_Sold
    ,cast(sum(transaction_qty * unit_price) AS int64) as Total_Revenue
    from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
    group by 1,2,3,4,5,6,7,8
)

  select
    Month
    ,Month_Name
    ,Store_ID
    ,Store_Location
    ,Product_ID
    ,Product_Name
    ,Product_Type
    ,Product_Category
    ,Total_Sold
    ,Total_Revenue
  from CategorySales
  order by 5,6

  ----------------------------------------------------------------------


----Sales in Store Location-----------------------------

-------Lower Manhattan---------
select 
  extract(month from transaction_date) as month
  ,format_date('%B', transaction_date) as month_name
  ,store_id
  ,store_location
  ,product_category
  ,sum(transaction_qty) as Total_Sold
  from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
  where store_location = 'Lower Manhattan'
  group by 1,2,3,4,5
  order by 4,5 desc;
  ----------------------------

--------------------Hell's Kitchen------------------
select 
  extract(month from transaction_date) as month
  ,format_date('%B', transaction_date) as month_name
  ,store_id
  ,store_location
  ,product_category
  ,sum(transaction_qty) as Total_Sold
  from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
  where store_location = "Hell's Kitchen"
  group by 1,2,3,4,5
  order by 4,5 desc;
  ----------------------------

  --------------------Astoria------------------
  select
  extract(month from transaction_date) as month
  ,format_date('%B', transaction_date) as month_name
  ,store_id
  ,store_location
  ,product_category
  ,sum(transaction_qty) as Total_Sold
  from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
  where store_location = 'Astoria'
  group by 1,2,3,4,5
  order by 4,5 desc;
  ----------------------------
------------------------------------------------------------------

------------Peak Hour-------------------
select
  extract(hour from transaction_time) as Hour
  ,sum(transaction_qty) as Total_Sold
  ,count(transaction_id) AS Total_Transactions
from `km-revou-sql-class-416914.Portofolio.Coffee Sales`
group by 1
order by 1;
--------------------------------------------