use salesdata;

drop table if exists ref_sales;
create table ref_sales as
Select *
from storedata;

/* ######## Modifing source table for Fact table  creation ######## */

alter table ref_sales 
modify `Invoice ID` Varchar(11),
add column Date_ Varchar(10),
add column Time_ Varchar(10),
add column day_name varchar(10),
add column Day_time varchar(15),
add column Gender_ID varchar (1),
add column Productl_ID varchar(5),
add column Day_ID varchar(4),
add column Payment_ID varchar(5),
add column cityCode varchar(3),
add column Cust_type_id int
;

update ref_sales 
set
Date_=str_to_date(Date,'%d/%m/%Y'),
Time_=time_format(Time,"%T"),
day_name= dayname(date_),
cityCode=(
Case
when City='Old Kent Road' then "SE1"
when City='Hayes' then "UB3"
when City='Sutton' then "SM1"
end
),
Cust_type_id= ( 
case 
when `Customer type`="Member" then "101"
when `Customer type`="Normal" then "201"
end
), 
Day_time=(
case 
when Time_ between "00:00:00" and "12:00:00" then "Morning" 
when Time_ between "12:00:00" and "16:00:00" then "Afternoon"
else "Evening" 
end
),
Gender_ID=(case 
when Gender = "Male" then "M"
when Gender = "Female" then "F"
end
),
Productl_ID=(
case 
when `Product line` = "Health and beauty" then "HB001"
when `Product line` = "Electronic accessories" then "EA001"
when `Product line` = "Home and lifestyle" then "HL001"
when `Product line` = "Sports and travel" then "ST001"
when `Product line` = "Food and beverages" then "FB001"
when `Product line` = "Fashion accessories" then "FA001"
end
),
Payment=(
case when Total <=100 and Payment="Ewallet"  then "Contactless"
else Payment 
end
),
Payment_ID=(
case 
when Payment='Ewallet' then "EC101"
when Payment='Cash' then "CA101"
when Payment='Credit card' then "CC101"
when Payment='Contactless' then "CL101"
end
),
Day_ID=(
case 
when Day_time='Morning' then "100M"
when Day_time='Afternoon' then "200A"
when Day_time='Evening' then "300E"
end
)
;

alter table ref_sales 
	drop Date,
    drop Time
    ;
   
alter table ref_sales 
	Rename  column Date_ to Date, 
    Rename  column Time_ to Time,
	modify column city varchar(30) not null,
    modify column `Customer type` varchar(50) not null,
    modify column Gender varchar(50) not null,
    modify column `Product line` varchar(150) not null,
    modify column Payment varchar(50) not null
   ; 

/* ######## Fact Table ######## */
drop table if exists sales;
create table sales as
select
`Invoice ID`,
Branch,
cityCode,
Cust_type_id,
Gender_ID,
Productl_ID,
`Unit price`,
Quantity,
`Tax 5%`,
Total,
Payment_ID,
cogs,
`gross margin percentage`,
`gross income`,
Rating,
Date,
Time,
Day_ID
from ref_sales 
;

/* ######## Dimension tables ######## */ 
/*--------------------------------*/ 
drop table if exists city; 
create table city as
select 
distinct(city) as city_name,
cityCode
from ref_sales ;

alter table city
add primary Key (cityCode); 

/*-------------------------------------*/
drop table if exists Customer;
create table Customer as 
select  
distinct(`Customer type`) as `Customer type`,
Cust_type_id
from ref_sales ;   

alter table Customer
add primary Key (Cust_type_id);

/*-------------------------------------*/
drop table if exists Gender;
create table Gender as 
select  
distinct(Gender) as Gender,
Gender_ID
from ref_sales ;    

alter table Gender
add primary Key (Gender_ID);

/*-------------------------------------*/
drop table if exists Product;
create table Product  as
select  
distinct(`Product line`) as Product,
Productl_ID
from ref_sales ;  

alter table Product
add primary Key (Productl_ID);

/*-------------------------------------*/
drop table if exists Daytime;
create table Daytime as 
select  
distinct(Day_time) as Daytime,
Day_ID
from ref_sales ;  
alter table Daytime
add primary Key (DAY_ID);

/*-------------------------------------*/
drop table if exists Payment;
create table Payment as 
select  
distinct(Payment) as Payment,
Payment_ID
from ref_sales ;  

alter table Payment
add primary Key (Payment_ID);

/*----------- Adding primary foreign Keys --------------------------*/
alter table sales
add primary Key (`Invoice ID`),
add foreign key (Cust_type_id) references customer(Cust_type_id),
add foreign key (Gender_ID) references gender(Gender_ID),
add foreign key (Productl_ID) references product(Productl_ID),
add foreign key (Payment_ID) references payment(Payment_ID),
add foreign key (Day_ID) references daytime(Day_ID)
;


