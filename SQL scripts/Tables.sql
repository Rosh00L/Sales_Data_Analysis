alter table sales add column Date_ Varchar(10);
update sales
set Date_=str_to_date(date,'%d/%m/%Y');

alter table sales
	drop date;
