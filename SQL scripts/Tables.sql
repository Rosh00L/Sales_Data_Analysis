use salesdata;

alter table sales 
add column Date_ Varchar(10),
add column Time_ Varchar(10),
add column month_name varchar(15),
add column day_name varchar(10),
add column Day_time varchar(15);


update sales
set

Date_=str_to_date(Date,'%d/%m/%Y'),
Time_=time_format(Time,"%T"),
month_name= monthname(date_),
day_name= dayname(date_),
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
    Rename  column Time_ to Time;
   