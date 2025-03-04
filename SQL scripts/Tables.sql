/**************************************************
Creating merge tables before import then into Tableau.
/**************************************************/

USE ecocapture;

/*** V_Countrydate table *********************************************************/ 
DROP table if exists _Traveller_country;
CREATE Table _Traveller_country AS
    SELECT 
		A.InputID,
		A.Traveller_ID,
        A.Traveller_Location,
        B.Traveller_Country
    FROM
        Traveller A
            LEFT JOIN
        country B ON A.Traveller_Location = B.Traveller_Location
        where Traveller_Country is not null 
        ORDER BY A.inputID
;   


DROP table if exists V_CountryDate;
CREATE Table  V_CountryDate AS
    SELECT 
       A.inputID, A.Traveller_ID,A.Traveller_Country, B.Travel_Date, B.Travel_Year, B.Travel_Month, B.month
    FROM
      _Traveller_country  A
		Left JOIN
        Dateall B ON A.inputID = B.inputID
ORDER BY A.inputID
;

/***Photography SIA Rating table *********************************************************/
DROP table if exists V_photoVisit_Rating;
CREATE Table  V_photoVisit_Rating  AS
    SELECT 
		A.InputID,
		A.Traveller_ID,
        A.activity,
        B.Traveller_Country,
        C.City,
        C.location_Type,
        E.Travel_Year,
        E.Travel_month,
        E.month,
        F.rating,
        D.sentiment_comments
	FROM
        activity A
	LEFT JOIN
		V_countrydate B ON A.InputID = B.InputID
	LEFT JOIN
		location C ON A.InputID = C.InputID
	LEFT JOIN
		sia D ON A.InputID = D.InputID  
	LEFT JOIN
		dateall E ON A.InputID = E.InputID  
	LEFT JOIN
		rating F ON A.InputID = F.InputID  
     /*where  activity='photography'*/
      where Traveller_Country !='Sri Lanka'
	ORDER BY A.InputID
     
;  

/***** Photography holiday vs non Photography holiday **********************/
DROP table if exists _PhotographyVSnon;
create Table _PhotographyVSnon as 
select * from  _Photovisit_ndup
union all   
select * from  _no_Photovisit_ndup
;
 
DROP table if exists V_PhotographyVSnonall;
create Table  V_PhotographyVSnonall as 
select 
		A.InputID,
		A.Traveller_ID,
        E.Traveller_Country,
        A.Photography,
        D.location_Type,
		B.Travel_Year,
        B.Travel_month,
        B.month,
        C.rating,
        F.sentiment_comments
	From  _PhotographyVSnon A
	LEFT JOIN 
	DATEALL B ON  A.InputID = B.InputID
    LEFT JOIN 
	Rating C ON A.InputID = C.InputID
    LEFT JOIN
	location D ON A.InputID = D.InputID
    LEFT JOIN
	V_countrydate E ON A.InputID = E.InputID
	LEFT JOIN
	sia F ON A.InputID = F.InputID  
    ORDER BY A.Photography,A.Traveller_ID
    ;


/***Photography rating and SIA *********************************************************/
DROP table if exists V_photoVisitCom_SIA_Rating;
CREATE Table  V_photoVisitCom_SIA_Rating  AS
    SELECT 
		A.InputID,
		A.Traveller_ID,
        A.activity,
        C.City,
        C.Location_Type,
		E.comments,
        F.rating,
        D.sentiment_comments,
        case
			when F.rating in(5,4) then "Positive"
			when  F.rating in(3) then "Natural"
			when  F.rating in(1,2) then "Nagative"
		end as RatingSIA
        
	FROM
        activity A
	LEFT JOIN
		location C ON A.InputID = C.InputID
	LEFT JOIN
		sia D ON A.InputID = D.InputID  
	LEFT JOIN
		rating F ON A.InputID = F.InputID 
    LEFT JOIN
		comment E ON A.InputID = E.InputID     
 	/*where  activity='photography'*/
	ORDER BY A.InputID
;  



/************ Additional checks **************************************************/
DROP table if exists V_twoCatStats;
 create Table  V_twoCatStats  as 
 select 
	stat.Photography,
    stat.Travel_Year,
    convert(AVG(stat.Traveller_count),decimal(9,4)) as TravelMean,
    convert(MAX(stat.Traveller_count),decimal(9,4)) as TravelMax,
    convert(MIN(stat.Traveller_count),decimal(9,4)) as TravelMin
    from ( 
    select
		Photography,
		Travel_Year,
        Traveller_ID,
		count(Traveller_ID) as Traveller_count
    /*MAX(Traveller_ID) as MAX_,
    MIN(Traveller_ID) as MIN_,
    STDDEV(Traveller_ID) as STDDEV*/
	from V_PhotographyVSnonall A
    where Traveller_Country !='Sri Lanka'
	group by  A.Photography,A.Travel_Year,A.Traveller_ID
   ) as stat
   group by  stat.Photography,stat.Travel_Year,stat.Traveller_ID
   ;
   
DROP table if exists _count;
 create Table  _count  as 
 select 
	Photography,
    count(Traveller_ID) as _allcount
    from V_PhotographyVSnonall A
    where Traveller_Country !='Sri Lanka'
	group by  A.Photography
  ; 
   
 /***************************************************************/  
 DROP table if exists _Y2018;
 create Table  _Y2018  as 
 select 
	Photography,
    count(TravelMax) as tot2018
    from V_twoCatStats
	where Travel_Year=2018
    group by Photography
   ; 
 
 DROP table if exists _Y2023;
 create Table  _Y2023  as 
 select 
	Photography,
   count(TravelMax) as tot2023
    from V_twoCatStats
    where Travel_Year=2023
    group by Photography
   ; 
 
 DROP table if exists V_twoCatsDiff;
 create Table  V_twoCatsDiff  as 
 select 
	per.Photography,
    per.tot2018,
    per.tot2023,
    per._allcount,
    per.Percent2018,
    per.Percent2023,
    per.Percent2023-per.Percent2018 as PerDff
    
   from(
    select  
    X.Photography,
    X.tot2018,
    Y.tot2023,
    Z._allcount,
    convert((X.tot2018/11318)*100,decimal(5,1)) as Percent2018, 
    convert((Y.tot2023/11318)*100,decimal(5,1)) as Percent2023
    from _Y2018 X
    left join
    _Y2023 Y on X.Photography= Y.Photography
    left join
     _count Z on X.Photography= Z.Photography 
   	 order by X.Photography
    ) as per 
    order by X.Photography
   ; 
     
   
 /***************************************************************/
 
DROP table if exists V_FrqCountry;
 create Table  V_FrqCountry  as 
 Select 
	stat.Photography,
    stat.sentiment_comments,
    stat.Traveller_Country,
    stat.Travel_Year,
    stat.CountryCount
    from
	( select 
	Photography,
    Traveller_Country,
    Travel_Year,
    sentiment_comments,
    count(Traveller_Country) as CountryCount
    from v_photographyvsnonall
    where Traveller_Country is not null
	group by  Photography,sentiment_comments,Traveller_Country,Travel_Year
    ) as stat
    where stat.Photography='photography' and stat.sentiment_comments = "Positive" and stat.CountryCount > 1
  order by stat.Traveller_Country,stat.CountryCount desc,stat.Travel_Year,stat.Photography
;  
/*


/*********** photoMean ******************/ 
DROP table if exists V_photoMean;
 create Table   V_photoMean  as 
 with PCountID as 
 (
 select
   Traveller_ID,
   count(Traveller_ID) as C_photo
from
 v_photographyvsnonall
 where
 Photography='photography'
 group by Traveller_ID
 )
  select
 A.Traveller_ID,
 A.Travel_Year,
 A.month,
 B.C_photo  
 from  v_photographyvsnonall A
 LEFT JOIN PCountID B ON A.Traveller_ID = B.Traveller_ID 
where
 Photography='photography'
;
 
 /*********** NphotoMean ******************/ 
DROP table if exists V_NphotoMean;
 create Table   V_NphotoMean  as 
 with NCountID as 
 (
 select
   Traveller_ID,
   count(Traveller_ID) as C_Nphoto
from
 v_photographyvsnonall
 where
 Photography='No photography'
 group by Traveller_ID
 )
  select
 A.Traveller_ID,
 A.Travel_Year,
 A.month,
 B.C_Nphoto
 from  v_photographyvsnonall A
 LEFT JOIN NCountID B ON A.Traveller_ID = B.Traveller_ID 
where
 Photography='No photography'
 ;

 DROP table if exists V_BothMean;
 create Table   V_BothMean  as 
 select
 A.Traveller_ID,
 A.Travel_Year,
 A.month,
 A.C_Nphoto,
 B.C_photo
 from   V_NphotoMean A
 LEFT JOIN
		V_photoMean B ON A.Traveller_ID=B.Traveller_ID
 WHERE B.C_photo is not null     
 ;
 
 /************/
 
DROP Table if exists _Traveller_country; 
DROP Table if exists _PhotographyVSnon; 
DROP table if exists _no_photography;
DROP table if exists _photography;
DROP table if exists _activity;
DROP table if exists _count;
DROP Table if exists _y2018;
DROP Table if exists _y2023;
DROP Table if exists v_nphotomean;
DROP Table if exists v_photomean;
DROP Table if exists v_photovisitcom_sia_rating;

/*DROP table if exists _photovisit_ndup;
DROP Table if exists v_nonmean;
DROP table if exists v_twocatstats;
DROP table if exists _no_photovisit_ndup;*/

