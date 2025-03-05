use salesdata;
alter table sales 
add column Date_ Varchar(10),
add column Time_ Varchar(10),
add column month_n int (8),
add column month_name varchar(15),
add column day_name varchar(10),
add column Day_time varchar(15),
add column day_of_week int (8);

update sales
set
Date_=str_to_date(Date,'%d/%m/%Y'),
Time_=time_format(Time,"%T"),
month_name= monthname(date_),
month_n= month(date_),
day_name= dayname(date_),
day_of_week=dayofweek(date_), 
Day_time=(
case 
when Time_ between "00:00:00" and "12:00:00" then "Morning" 
when Time_ between "12:00:00" and "16:00:00" then "Afternoon"
else "Evening" 
end
);

alter table sales
	drop Date,
    drop Time
    ;
   
alter table sales
	Rename  column Date_ to Date, 
    Rename  column Time_ to Time,
	modify column city varchar(30) not null,
    modify column `Customer type` varchar(50) not null,
    modify column Gender varchar(50) not null,
    modify column `Product line` varchar(150) not null,
    modify column Payment varchar(50) not null
   ; 
 
 
/*     Tables   */ 
drop table if exists city; 
create table city as
select 
distinct(city) as city_name
from sales;

alter table city
add primary Key (city_name); 


drop table if exists Customer;
create table Customer as 
select  
distinct(`Customer type`) as Customer_type
from sales;   

alter table Customer
add primary Key (Customer_type);


drop table if exists Gender;
create table Gender as 
select  
distinct(Gender) as Gender
from sales;    

alter table Gender
add primary Key (Gender);


drop table if exists Product;
create table Product  as
select  
distinct(`Product line`) as Product
from sales;  

alter table Product
add primary Key (Product);


drop table if exists month ;
create table month as
select  
distinct(month_name) as  month_name,
month_n
from sales; 

alter table month
add primary Key (month_n);



create table Day_ as 
select  
distinct(day_name) as day_name,
day_of_WEEK
from sales  
Order by day_of_WEEK; 

drop table if exists day;
create table Day as 
select  
concat(day_of_WEEK,'-',day_name) as WeekDay,
day_name,
day_of_WEEK
from Day_ ; 



alter table day
add primary Key (day_of_WEEK);


drop table if exists Daytime;
create table Daytime as 
select  
distinct(Day_time) as Daytime
from sales;  
alter table Daytime
add primary Key (Daytime);


drop table if exists Payment;
create table Payment as 
select  
distinct(Payment) as Payment
from sales;  

alter table Payment
add primary Key (Payment);
