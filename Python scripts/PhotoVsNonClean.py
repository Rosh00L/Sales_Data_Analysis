import pandas as pd

from scipy.stats import ttest_ind
from statsmodels.stats.weightstats import ztest as ztest
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

############# photography visitors ####################################################################
photo = pd.read_sql( 
    "SELECT * FROM ecocapture._photography", 
    con=engine 
) 
df_photo = pd.DataFrame(photo)
print(len(df_photo))

PhotoNoDup = df_photo.drop_duplicates( 
  subset = ["Traveller_ID","Travel_Year","month"], 
  keep = 'first').reset_index(drop = True).sort_values(by=['Traveller_ID',"photography"])

print(len(PhotoNoDup))

########### Non photography visitors ###################################################################

No_photo = pd.read_sql( 
    "SELECT * FROM ecocapture._no_photography", 
    con=engine 
) 
df_no_photo = pd.DataFrame(No_photo)
print(len(df_no_photo))

No_PhotoNoDup = df_no_photo.drop_duplicates( 
  subset = ["Traveller_ID","Travel_Year","month"], 
  keep = 'first').reset_index(drop = True).sort_values(by=['Traveller_ID',"photography"])
print(len(No_PhotoNoDup ))

########### Merge and removing photography visites from Non-photography visitors ####################

NoDup=PhotoNoDup.merge (No_PhotoNoDup, on=['Traveller_ID','Travel_Year','month'], how='right', indicator=True).query('_merge == "right_only"').drop('_merge', axis=1)

NoDup.rename(columns={'InputID_y':'InputID', 'Comments_y':'Comments','photography_y': 'photography'},inplace=True)
#print(NoDup)

df_no_dup_photo=NoDup[["InputID","Traveller_ID","photography","Travel_Year","month","Comments"]].reset_index(drop=True)
no_dup_photo=pd.DataFrame(df_no_dup_photo).sort_values(by=(['InputID','Traveller_ID']))
#print(no_dup_photo)

########### to_sql #################################################################################
with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS _no_photovisit_ndup"))
    conn.execute(text("DROP TABLE IF EXISTS _photovisit_ndup"))
    
no_dup_photo.to_sql('_no_photovisit_ndup', engine, dtype={"InputID":Integer(), "Traveller_ID": Integer(),"photography": String (15),"comments": String (9000)}, if_exists='replace', index=False)
PhotoNoDup.to_sql('_photovisit_ndup', engine, dtype={"InputID":Integer(), "Traveller_ID": Integer(),"photography": String (15),"comments": String (9000)}, if_exists='replace', index=False)
