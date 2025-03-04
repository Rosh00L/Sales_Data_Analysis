import pandas as pd
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String ,text
import numpy as np
import csv

# Credentials to database connection
hostname="localhost"
dbname="ecocapture"
uname="root"
pwd="rootroot"

# Create dataframe

# Create SQLAlchemy engine to connect to MySQL Database
engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))


sql_traveler = pd.read_sql( 
    "SELECT * FROM ecocapture.traveller", 
    con=engine 
) 
sql_traveler.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\traveler.xlsx',index=False)

sql_country = pd.read_sql( 
    "SELECT * FROM ecocapture.country", 
    con=engine 
) 
sql_country.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\country.xlsx',index=False)

sql_date = pd.read_sql( 
    "SELECT * FROM ecocapture.dateall", 
    con=engine 
) 
sql_date.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\dateall.xlsx',index=False)

sql_location = pd.read_sql( 
    "SELECT * FROM ecocapture.location", 
    con=engine 
) 
sql_location.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\Location.xlsx',index=False)

sql_sia = pd.read_sql( 
    "SELECT * FROM ecocapture.sia",
    con=engine 
) 
sql_sia.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\sia.xlsx',index=False)

sql_act = pd.read_sql( 
    "SELECT * FROM ecocapture.activity",
con=engine 
) 
sql_act.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\activity.xlsx",index=False)

traveller_comments= pd.read_sql( 
    "SELECT * FROM ecocapture.comment",
con=engine 
) 
traveller_comments.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\comments.xlsx",index=False)

V_fromcountrydate= pd.read_sql( 
    "SELECT * FROM ecocapture.V_countrydate",
con=engine 
) 
V_fromcountrydate.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\V_countrydate.xlsx",index=False)    

V_photography_rating= pd.read_sql( 
    "SELECT * FROM ecocapture.V_photovisit_rating",
con=engine 
) 
V_photography_rating.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\photovisit_rating.xlsx",index=False)  

v_photographyvsnonall= pd.read_sql( 
    "SELECT * FROM ecocapture.v_photographyvsnonall",
con=engine 
) 
v_photographyvsnonall.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\photographyvsnonall.xlsx",index=False)  


v_photovisitcom_sia_rating= pd.read_sql( 
    "SELECT * FROM ecocapture.v_photovisitcom_sia_rating",
con=engine 
) 
v_photovisitcom_sia_rating.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\v_photovisitcom_sia_rating.xlsx",index=False)  

v_twocatstats= pd.read_sql( 
    "SELECT * FROM ecocapture.v_twocatstats",
con=engine 
) 
v_twocatstats.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\v_twocatstats.xlsx",index=False)  


''''
sql_Photogr_noDup = pd.read_sql( 
    "SELECT * FROM ecocapture._photovisit_ndup", 
    con=engine 
) 
sql_Photogr_noDup.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\_photovisit_ndup.xlsx',index=False)

sql_NoPhotogr_noDup = pd.read_sql( 
    "SELECT * FROM ecocapture._no_photography", 
    con=engine 
) 
sql_NoPhotogr_noDup.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\_no_photography.xlsx',index=False)

_traveller_country= pd.read_sql( 
    "SELECT * FROM ecocapture._traveller_country",
con=engine 
) 
_traveller_country.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\_traveller_country.xlsx",index=False)  

v_twocatstats= pd.read_sql( 
    "SELECT * FROM ecocapture.v_twocatstats",
con=engine 
) 
v_twocatstats.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\v_twocatstats.xlsx",index=False)  

'''''



