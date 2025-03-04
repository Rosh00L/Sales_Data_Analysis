
/**************************************************

Assigning primary keys.

/**************************************************/


ALTER TABLE ecocapture.traveller 
CHANGE COLUMN InputID InputID INT NOT NULL ,
CHANGE COLUMN Traveller_ID Traveller_ID INT NOT NULL ,
ADD PRIMARY KEY (InputID),
ADD UNIQUE INDEX InputID_UNIQUE (InputID ASC) VISIBLE;
;

ALTER TABLE ecocapture.country 
CHANGE COLUMN traveller_Location traveller_Location VARCHAR(200) NOT NULL ,
ADD PRIMARY KEY (traveller_Location),
ADD UNIQUE INDEX traveller_Location_UNIQUE (traveller_Location ASC) VISIBLE;
;

ALTER TABLE ecocapture.dateall 
CHANGE COLUMN InputID InputID INT NOT NULL ,
CHANGE COLUMN Traveller_ID Traveller_ID INT NOT NULL ,
ADD PRIMARY KEY (InputID),
ADD UNIQUE INDEX InputID_UNIQUE (InputID ASC) VISIBLE;
;

ALTER TABLE ecocapture.location 
CHANGE COLUMN InputID InputID INT NOT NULL ,
CHANGE COLUMN Traveller_ID Traveller_ID INT NOT NULL ,
ADD PRIMARY KEY (InputID),
ADD UNIQUE INDEX InputID_UNIQUE (InputID ASC) VISIBLE;
;

ALTER TABLE ecocapture.comment 
CHANGE COLUMN InputID InputID INT NOT NULL ,
CHANGE COLUMN Traveller_ID Traveller_ID INT NOT NULL ,
ADD PRIMARY KEY (InputID),
ADD UNIQUE INDEX InputID_UNIQUE (InputID ASC) VISIBLE;
;

ALTER TABLE ecocapture.rating 
CHANGE COLUMN InputID InputID INT NOT NULL ,
CHANGE COLUMN Traveller_ID Traveller_ID INT NOT NULL ,
ADD UNIQUE INDEX InputID_UNIQUE (InputID ASC) VISIBLE,
ADD PRIMARY KEY (InputID);
;

ALTER TABLE ecocapture.vote 
CHANGE COLUMN InputID InputID INT NOT NULL ,
CHANGE COLUMN Traveller_ID Traveller_ID INT NOT NULL ,
ADD PRIMARY KEY (InputID),
ADD UNIQUE INDEX InputID_UNIQUE (InputID ASC) VISIBLE;
;

ALTER TABLE ecocapture.sia 
CHANGE COLUMN InputID InputID INT NOT NULL ,
CHANGE COLUMN Traveller_ID Traveller_ID INT NOT NULL ,
ADD PRIMARY KEY (InputID),
ADD UNIQUE INDEX InputID_UNIQUE (InputID ASC) VISIBLE;
;

ALTER TABLE ecocapture.activity 
ADD INDEX InputID_idx (InputID ASC) VISIBLE;
;
ALTER TABLE ecocapture.activity 
ADD CONSTRAINT InputID
  FOREIGN KEY (InputID)
  REFERENCES ecocapture.traveller (InputID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;