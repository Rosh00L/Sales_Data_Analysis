/* Generic Question
1.How many unique cities does the data have? */
select
distinct city,
Branch
from sales; 


/* Product Analysis
-- 1. How many unique product lines does each city and branch have?*/
select
city,
Branch,
count(distinct `Product line`)
from sales
group by city,Branch
; 

-- 2. What is the most common payment method?
select
Payment,
count(Payment) as Payment_cnt
from sales
group by Payment
order by Payment_cnt desc
;

-- 3. What is the most selling product line?
select 
`Product line`,
sum(`Quantity`) as qty 
from sales
group by `Product line`
order by qty desc
;

-- 4. What is the total revenue by month?

select
month_name as month,
sum(total) as Revenue 
from sales
group by month_name
order by Revenue desc
; 

-- 5. What month had the largest COGS?

select
month_name as month,
sum(cogs) as cogs_sum
from sales
group by month_name
order by cogs_sum desc
;

-- 6. What product line had the largest revenue?
select
`Product line`,
sum(total) as Revenue
from sales
group by `Product line`
order by Revenue desc
; 

-- 7. What is the city with the largest revenue?

select
city,
sum(total) as Revenue
from sales
group by city
order by Revenue desc
; 

-- 8. What product line had the largest VAT?

select
`Product line`,
sum(`Tax 5%`) as VAT_sum
from sales
group by `Product line`
order by VAT_sum desc
; 

-- 10. Which branch sold more products than average product sold?
select
Branch,
avg(`Product line`) as prod_avg 
from sales
group by Branch
order by prod_avg
; 



-- 11. What is the most common product line by gender?

-- 12. What is the average rating of each product line?