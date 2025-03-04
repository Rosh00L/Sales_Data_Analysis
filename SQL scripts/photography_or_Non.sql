/********************  ******************************
Creating Photography and Non Photography Holidays tables.
/**************************************************/

USE ecocapture;
SET GLOBAL regexp_time_limit=100024;
/******************** Photography Holidays ******************************/

DROP table if exists _photography;
CREATE table _photography AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.photography,
        act.Travel_Year,
		act.month,
        act.Comments
	from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
		B.Travel_Year as Travel_Year,
		B.month as month,
         LOWER(A.Comments) AS Comments,
          CASE
            WHEN LOWER(Comments) like LOWER('%photo%') or LOWER(Comments) REGEXP  LOWER('some beautiful pictures|swimming and pictures|picture friendly|take very nice pictures|taking pictures|pictures we did look great|took some pictures|take some lovely pictures|took a lot of pictures|nice pictures to take|took pictures|get some pretty pictures|place to have pictures|take some pictures|great for pictures|picture worthy moment|good for pictures|take pictures|take really nice pictures|nicer and for pictures|backdrop for pictures|get some pictures|picture opportunities|had a picture|amazing for good pictures|take some picture|panoramic pictures|reasonable picture of the process|take lots of pictures|taking picture|take a picture|pictures you can take|great pictures|good pictures|perfect for pictures|took lots of pictures|take nice pictures|take some great pictures|click pictures|check my pictures|stopped for picture|take tooooooooooo many pictures|take a tripod for better pictures!|take as many pictures|taken bunch of pictures|capture nice pictures|pictures are allowed|wanted to take pictures every|get a decent picture|to take picture|got a picture|got some really great pictures|got some fantastic pictures|did take some nice pictures|lots of pictures|get some incredible pictures|place for some good pictures|time to take fantastic pictures|capture fabulous pictures|we had nice pictures|time to take a lot of pictures|plenty of time to take pictures|took some really nice pictures|with all the pictures|took some nice pictures|you can have pictures|can click pictures|we took a few pictures|some pictures attached|i wanted a picture|some pictures attached|take a picture with them|could take a pictures|i look at the lovely pictures|we took some pictures|great picture opportunities|close up pictures|took many pictures|some good pictures|click a few pictures|could take a picture|take several pictures|we got great pictures|snap a picture|some amazing pictures|view for pictures|phenomenal pictures|stop fot a picture|can take lot of pictures|capturing pictures|picture perfect experience|do some pictures|take few pictures|take a bunch of pictures|place to make pictures|decent picture|site for some pictures|click goreat pictures|nice for a picture|area for pictures|take a few pictures|taken pictures|close enough for pictures|have beautiful pictures|take a nice picture|taking many pictures|monks for a picture|every corner demands a picture|love make pictures|picture perfect!|great picture spot|picturesque stroll|picture-taking|can take pictures|take some beautiful snaps|click a lot of pics|click loads of pics|lots of pics|took pics|taking pics|clicked fews pics|pic of the waterfall|mountains pics|take some pics|click a lot of pics|many pics|lovely pics|nice for clicks|around for clicks|options for clicks|cameras clicking|some good clicks|click a pic|clicking some pics|fabulous pics|snapshot worthy|wonderful snap|lot of snaps|take snaps|camera|snap a picture|some snaps|snapping breathtaking pics|snapshot|bird watching')
			THEN "Photography"
            ELSE ' '
        END AS photography
          FROM Comment A
       LEFT JOIN
		dateall B ON A.InputID = B.InputID 
       ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.photography="Photography"  
    ORDER BY act.InputID
    ;
/**************************************************/    
/********************* Non-Photography Holidays ****/
DROP table if exists _No_photography;
CREATE table _No_photography AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.photography,
        act.Travel_Year,
		act.month,
        act.Comments
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
        B.Travel_Year as Travel_Year,
		B.month as month,
         LOWER(A.Comments) AS Comments,
          CASE
            WHEN LOWER(Comments) NOT REGEXP LOWER('some beautiful pictures|swimming and pictures|picture friendly|take very nice pictures|taking pictures|pictures we did look great|took some pictures|take some lovely pictures|took a lot of pictures|nice pictures to take|took pictures|get some pretty pictures|place to have pictures|take some pictures|great for pictures|picture worthy moment|good for pictures|take pictures|take really nice pictures|nicer and for pictures|backdrop for pictures|get some pictures|picture opportunities|had a picture|amazing for good pictures|take some picture|panoramic pictures|reasonable picture of the process|take lots of pictures|taking picture|take a picture|pictures you can take|great pictures|good pictures|perfect for pictures|took lots of pictures|take nice pictures|take some great pictures|click pictures|check my pictures|stopped for picture|take tooooooooooo many pictures|take a tripod for better pictures!|take as many pictures|taken bunch of pictures|capture nice pictures|pictures are allowed|wanted to take pictures every|get a decent picture|to take picture|got a picture|got some really great pictures|got some fantastic pictures|we did take some nice pictures|lots of pictures|get some incredible pictures|place for some good pictures|time to take fantastic pictures|capture fabulous pictures|we had nice pictures|time to take a lot of pictures|plenty of time to take pictures|took some really nice pictures|with all the pictures|took some nice pictures|you can have pictures|can click pictures|we took a few pictures|some pictures attached|i wanted a picture|some pictures attached|take a picture with them|could take a pictures|i look at the lovely pictures|we took some pictures|great picture opportunities|close up pictures|took many pictures|some good pictures|click a few pictures|could take a picture|take several pictures|we got great pictures|snap a picture|some amazing pictures|view for pictures|phenomenal pictures|stop fot a picture|can take lot of pictures|capturing pictures|picture perfect experience|do some pictures|take few pictures|take a bunch of pictures|place to make pictures|decent picture|site for some pictures|click goreat pictures|nice for a picture|area for pictures|take a few pictures|taken pictures|close enough for pictures|have beautiful pictures|take a nice picture|taking many pictures|monks for a picture|every corner demands a picture|love make pictures|picture perfect!|great picture spot|picturesque stroll|picture-taking|can take pictures|take some beautiful snaps|click a lot of pics|click loads of pics|lots of pics|took pics|taking pics|clicked fews pics|pic of the waterfall|mountains pics|take some pics|click a lot of pics|many pics|lovely pics|nice for clicks|around for clicks|options for clicks|cameras clicking|some good clicks|click a pic|clicking some pics|fabulous pics|snapshot worthy|wonderful snap|lot of snaps|take snaps|camera|snap a picture|some snaps|snapping breathtaking pics|snapshot|bird watching')
			and LOWER(Comments) not like LOWER('%photo%') 
			THEN "No photography"
            ELSE "Photography"
        END AS photography
          FROM
       Comment A
          LEFT JOIN
	dateall B ON A.InputID = B.InputID 
    ORDER BY A.InputID AND A.Traveller_ID
	) AS act
    where act.photography="No photography" 
    ORDER BY act.InputID
    ;
    
/**************************************************/    