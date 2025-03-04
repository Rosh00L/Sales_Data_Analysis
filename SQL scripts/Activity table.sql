
/**************************************************
Creating an activity table that holidaymakers engage in.
Please note that the activity table is generated only for the photography holidaymakers.  
/**************************************************/

USE ecocapture;
SET GLOBAL regexp_time_limit=100024;
 
ALTER table _photography
  DEFAULT CHARACTER SET utf8mb4,
  MODIFY photography VARCHAR(15)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;
    
ALTER table _no_photography
  DEFAULT CHARACTER SET utf8mb4,
  MODIFY photography VARCHAR(15)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;    

/*Wildlife_nature*************************************************/
CREATE TABLE Wildlife_nature AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Wildlife_nature
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('wildlife|wild life|safari|diving|snorking|leopard|leopards|elephant|elephants|peacock|bear|coral|whale|dolphin|nature|rainforest|animal|animals|monkey|lizard|butterfly|garden|reptile|snake|fish|Bats|Wetlands|Jungle|forest|flora|fauna|spider|owl|frogmouth|squirre|fowl|biolog|sinharaja|plants|naturalist|eagles|bird|birdlife|birding|birdwatching|magpie|birdsong|yala|wilpattu|buffalo|corals|plants|snails|geckos|deers|Game Camp|raptors|hornbills|turtles|waterfalls|water fall|reserve|udawalawe') THEN "wildlife_nature"
            ELSE " "
        END AS wildlife_nature
          FROM
       _photography A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Wildlife_nature="wildlife_nature"  
    ORDER BY act.InputID
    ;  
   
 /*Hiking_climbing*************************************************/   
CREATE TABLE Hiking_climbing AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Hiking_climbing
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('hike|hiking|walking|trekking|trek|climbing|rappaling|walked|stroll|nightlife|night life') THEN "Hiking_climbing"
            ELSE ' '
        END AS Hiking_climbing
          FROM
       _photography A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Hiking_climbing="Hiking_climbing"  
    ORDER BY act.InputID
    ;

    
    /**Biking_cycling**************************************************/
    CREATE TABLE Biking_cycling AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Biking_cycling
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('biking|cycling|motorbike') THEN "Biking_cycling"
            ELSE ' '
        END AS Biking_cycling
          FROM
       _photography A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Biking_cycling="Biking_cycling"  
    ORDER BY act.InputID
    ;
    
    /**Historical_Sites**************************************************/
    CREATE TABLE Historical_Sites AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Historical_Sites
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP ('ancient|ruing|archaeology|historical') THEN "Historical_Sites"
            ELSE ' '
        END AS Historical_Sites
          FROM
       _photography A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Historical_Sites="Historical_Sites"  
    ORDER BY act.InputID
    ;
    
     /**Beach_Water_Sports**************************************************/
    CREATE TABLE Beach_Water_Sports AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Beach_Water_Sports
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('surfing|diving|scuba|snorke|snorkeling|swim|swimming|boat|Boat trip|beach|rafting|canoe|Kayaking') THEN "Beach_Water_Sports"
            ELSE ' '
        END AS Beach_Water_Sports
          FROM
       _photography A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Beach_Water_Sports="Beach_Water_Sports"  
    ORDER BY act.InputID
    ;
    
    /** Sightseeing **************************************************/
    CREATE TABLE Sightseeing AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Sightseeing
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('sightsee|sightseeing|waterfall|abseil|skydiving|paramotor|paraglid|ATV|architecture|lake|landscape') THEN "Sightseeing"
            ELSE ' '
        END AS Sightseeing
          FROM
       _photography A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Sightseeing="Sightseeing"  
    ORDER BY act.InputID
    ;
    
    /**Religious**************************************************/
    CREATE TABLE Religious AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Religious
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('temple|church|mosques|synagogue|spiritual|praying|prayer|worship|ritual|Kovil|nallur kovil') THEN "Religious"
            ELSE ' '
        END AS Religious
          FROM
       _photography A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Religious="Religious"  
    ORDER BY act.InputID
    ;
    
	/**Relaxing**************************************************/
    CREATE TABLE Relaxing AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Relaxing
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER ('relax|relaxing|unwind|leisure|rejuvenat|bliss|retreat|resort|sanctuary|zen|solitude') THEN "Relaxing"
            ELSE ' '
        END AS Relaxing
          FROM
       _photography A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Relaxing="Relaxing"  
    ORDER BY act.InputID
    ;
    
	/**Romantic_holiday**************************************************/
    CREATE TABLE Romantic_holiday AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Romantic_holiday
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER ('anniversary|wedding|romantic|romance') THEN "Romantic_holiday"
            ELSE ' '
        END AS Romantic_holiday
          FROM
       _photography A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Romantic_holiday="Romantic_holiday"  
    ORDER BY act.InputID
    ;
    
  
DROP table if exists activity;    
create table activity as 
select * from  Beach_Water_Sports
union all   
select * from  Wildlife_nature
union all
select * from  Hiking_climbing
union all
select * from  Biking_cycling
union all
select * from  Historical_Sites
union all
select * from  Sightseeing
union all
select * from   Religious
union all
select * from  Relaxing
union all
select * from  Romantic_holiday;

 
alter table  activity
Rename Column Beach_Water_Sports to activity;

DROP table if exists Wildlife_nature;
DROP table if exists Hiking_climbing;
DROP table if exists Biking_cycling;
DROP table if exists Historical_Sites;
DROP table if exists Beach_Water_Sports;
DROP table if exists Sightseeing;
DROP table if exists Religious;
DROP table if exists Relaxing;
DROP table if exists Romantic_holiday;   
    