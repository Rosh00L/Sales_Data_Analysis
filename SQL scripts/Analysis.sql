
SELECT SUM(Total) AS Total_Sales
FROM ref_sales;

SELECT avg(Total) AS avg_Sales
FROM ref_sales;

SELECT 
`Invoice ID`
FROM ref_sales
group by `Invoice ID`
HAVING COUNT(`Invoice ID`) >1
;

/* Generic Question
1.How many unique cities does the data have? */
select
distinct city,
Branch
from ref_sales; 

/* Product Analysis
-- 1. How many unique product lines does each city and branch have?*/
select
city,
Branch,
count(distinct `Product line`)
from ref_sales
group by city,Branch
; 

-- 2. What is the most common payment method?
select
Payment,
count(Payment) as Payment_cnt
from ref_sales
group by Payment
order by Payment_cnt desc
;

-- 3. What is the most selling product line?
select 
`Product line`,
sum(`Quantity`) as qty 
from ref_sales
group by `Product line`
order by qty desc
;

-- 4. What is the total revenue by month?
select
month_name as month,
sum(total) as Revenue 
from ref_sales
group by month_name
order by Revenue desc
; 

-- 5. What month had the largest COGS?

select
month_name as month,
sum(cogs) as cogs_sum
from ref_sales
group by month_name
order by cogs_sum desc
;

-- 6. What product line had the largest revenue?
select
`Product line`,
sum(total) as Revenue
from ref_sales
group by `Product line`
order by Revenue desc
; 

-- 7. What is the city with the largest revenue?

select
city,
sum(total) as Revenue
from ref_sales
group by city
order by Revenue desc
; 

-- 8. What product line had the largest VAT?

select
`Product line`,
sum(`Tax 5%`) as VAT_sum
from ref_sales
group by `Product line`
order by VAT_sum desc
; 

-- 10. Which branch sold more products than average product sold?
/*select
Branch,
sum(`Quantity`) as Qty,
avg(`Quantity`) as AvgQty
from ref_sales
group by Branch
-- having sum(Quantity) > (select avg(`Quantity`) from  ref_sales ) 
;
*/

select
Branch,
sum(`Quantity`) as Qty
-- avg(`Quantity`) as AvgQty
from ref_sales
group by Branch
 having sum(Quantity) > (select avg(`Quantity`) from  ref_sales ) 
;


select
avg(`Quantity`) as AvgQty
from ref_sales
-- having sum(Quantity) > (select avg(`Quantity`) from  ref_sales ) 
; 

-------- -----1. Number of sales made in each time of the day per weekday--------
select
 Day_time,
    count(*) as total_sales
from ref_sales
group by Day_time
order by total_sales desc;


-- 11. What is the most common product line by gender?

-- 12. What is the average rating of each product line?