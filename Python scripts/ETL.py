import pandas as pd
from string import printable
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String ,text
from sqlalchemy_utils import create_database, database_exists
import numpy as np

# Credentials to database connection
hostname="localhost"
dbname="ecocapture"
uname="root"
pwd="rootroot"

# Create dataframe from source csv file ####

fileCSV=r"C:\Github_proj\EcoCapture-Analytics\Source\Tourism and Travel Reviews Sri Lankan Destinations\Tourism and Travel Reviews Sri Lankan Destinations\Reviews.csv"
allRev = pd.read_csv(fileCSV,sep=',',encoding='latin')
DfRev=pd.DataFrame(allRev).reset_index()

DfRev['Traveller_ID']= DfRev['User_ID'].str.extract('(\d+)')
DfRev['Traveller_ID']=pd.to_numeric(DfRev['Traveller_ID'])

#~~~~ Generating primary key ID as traveller Reviews count Traveller_ID || Rev_count ~~~~~~~~~~~~~~~~~~~~~~#

DfRev['Index_']=DfRev['index'].astype(str)
DfRev['lengths'] = DfRev['Index_'].apply(len)
DfRev['IndexFix']=pd.to_numeric(DfRev['Index_'])

DfRev=DfRev.rename(columns={'Located_City':'City'})

Province = DfRev['Location'].str.split(",", n=1, expand=True)
DfRev['Province']=Province[1]

def fixId(DfRev):
    DfRev.loc[(DfRev['lengths']==5) ,'InputID']=pd.concat([DfRev['IndexFix']+40000]) 
    DfRev.loc[(DfRev['lengths']==4) ,'InputID']=pd.concat([DfRev['IndexFix']+40000])
    DfRev.loc[(DfRev['lengths']==3) ,'InputID']=pd.concat([DfRev['IndexFix']+30000])
    DfRev.loc[(DfRev['lengths']==2) ,'InputID']=pd.concat([DfRev['IndexFix']+20000])
    DfRev.loc[((DfRev['lengths']==1) & (DfRev['IndexFix']==0)), 'InputID']=pd.concat([DfRev['IndexFix']+10001])
    DfRev.loc[((DfRev['lengths']==1) & (DfRev['IndexFix']!=0)) ,'InputID']=pd.concat([10000+(DfRev['IndexFix']+1)])
   
fixId(DfRev)

DfReviews=pd.DataFrame(DfRev)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

UserData = DfReviews.drop_duplicates( 
  subset = ["Traveller_ID","User_Location","Travel_Date","Published_Date"], 
  keep = 'first').reset_index(drop = True).sort_values(by=['Traveller_ID',"User_Location"])

UserData["Traveller_Location"] = UserData["User_Location"].str.strip().str.title()
dfUserData=pd.DataFrame(UserData)


#^^^^^^^^^^^^^^^^^^^ Normalising country names reading from mapped xlsx file ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#

CountryMap=r'C:\Github_proj\EcoCapture-Analytics\Source\User_country_and_city_vf1.0.xlsx'

uCountry = pd.read_excel(CountryMap, sheet_name='Sheet1')
uCountry=uCountry.fillna('')

def copute_Country(uCountry):
  uCountry.loc[(uCountry['Country1'] !='') & (uCountry['Country3'] !='') ,'Traveller_Country']=uCountry['Country3']
  uCountry.loc[(uCountry['Country1'] =='' ) & (uCountry['Country2'] !='') ,'Traveller_Country']=uCountry['Country2']
  uCountry.loc[(uCountry['Country1'] !='') & (uCountry['Country3'] =='') ,'Traveller_Country']=uCountry['Country1']

copute_Country(uCountry)

uCountry=pd.DataFrame(uCountry).reset_index().drop(columns=(['Country1','Country2','Country3']))
uCountry['Traveller_Country']=uCountry['Traveller_Country'].str.strip()
uCountry.drop(columns=['index'], inplace=True)

uCountry.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\UserCountryList.xlsx',index=False)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#~~~~~~~~~~~~~~~~~~~~~~~~ Merging user country ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
dfUserData=pd.DataFrame(dfUserData).sort_values(by="Traveller_Location",ascending=True)
dfCountry=pd.DataFrame(uCountry).sort_values(by="Traveller_Location",ascending=True)
dfUserCoun= pd.merge(dfUserData, dfCountry, on="Traveller_Location", how="left")

dfUserCoun.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\UserCountryMer.xlsx',index=False)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

###^^^^^^^^^ All Travel Data,  Year + 'User_ID','Traveller_ID','Travel_Date','Traveller_Country','Rating','Text' ^^^^^^^^^^###
Date=DfReviews[["Traveller_ID","Travel_Date"]].drop_duplicates().reset_index(drop=True)
YM= Date['Travel_Date'].str.split("-", n=1, expand=True)
Date['Travel_Year']=YM[0].astype(int)
Date['Travel_Month']=YM[1]
Date['month'] = pd.to_datetime(Date['Travel_Month'], format='%m').dt.month_name()
dfDate=pd.DataFrame(Date)

dfUDConntry=pd.DataFrame(dfUserCoun).sort_values(by=['Traveller_ID','Travel_Date'],ascending=True)
dfYear=pd.DataFrame(dfDate).sort_values(by=['Traveller_ID','Travel_Date'],ascending=True)

dfUserYear= pd.merge(dfUDConntry, dfYear, on=['Traveller_ID','Travel_Date'], how="left")

TravelData=dfUserYear[['InputID','Traveller_ID','Traveller_Location','Travel_Date','Travel_Year','Travel_Month','month','Traveller_Country','Location_Name','City','Province','Location_Type',
                       "Published_Date","Title",'Rating',"Helpful_Votes",'Text']].sort_values(by='Travel_Year').reset_index()

TravelData.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\TravelData.xlsx',index=False)

################################ Tables ####################################################################

### traveller #######
dftraveller=TravelData[["InputID","Traveller_ID","Traveller_Location"]].reset_index(drop=True)
traveller=pd.DataFrame(dftraveller).sort_values(by=(['InputID','Traveller_ID']))

### traveller Country #######
dfCountry=TravelData[["Traveller_Location","Traveller_Country"]].reset_index(drop=True)
dfCountryNDup = dfCountry.drop_duplicates( 
  subset = ["Traveller_Location","Traveller_Country"], 
  keep = 'first').reset_index(drop = True).sort_values(by=['Traveller_Location','Traveller_Country'])
dfCountryNDup = dfCountryNDup.dropna(how='any',axis=0) 

country=pd.DataFrame(dfCountryNDup).sort_values(by=(['Traveller_Location','Traveller_Country'])).reset_index(drop=True)

### Dates #######
dftraveller=TravelData[["InputID","Traveller_ID",'Travel_Date', 'Travel_Year', 'Travel_Month','month',"Published_Date"]]
date=pd.DataFrame(dftraveller).sort_values(by=(['InputID','Traveller_ID']))

### Rating #######
dfRating=TravelData[["InputID","Traveller_ID","Location_Name","Rating"]].drop_duplicates()
rating=pd.DataFrame(dfRating).sort_values(by=("InputID"))

### User Text data #######
comments=TravelData[["InputID","Traveller_ID","Title","Text"]].drop_duplicates().reset_index(drop=True)

st = set(printable)
comments['Text'] = comments["Text"].apply(lambda x: ''.join([" " if ord(i) < 32 or ord(i) > 126 else i for i in x]))
comments=comments.rename(columns={'Text':'comments'})
comments=pd.DataFrame(comments).sort_values(by=("InputID"))

### Helpful_Votes ###
Helpful_Votes=TravelData[["InputID","Traveller_ID","Helpful_Votes"]].drop_duplicates().reset_index(drop=True)
votes=pd.DataFrame(Helpful_Votes).sort_values(by=("InputID"))

### Location #######
dfLocation=TravelData[["InputID","Traveller_ID","Location_Name","City","Province","Location_Type"]].drop_duplicates().reset_index(drop=True)
location=pd.DataFrame(dfLocation).sort_values(by=("InputID"))
location.rename(columns={'Location_Name': 'Location'}, inplace=True)

engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))
if not database_exists(engine.url): create_database(engine.url)        

# Execute the DROP TABLE statement directly
with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS traveller"))
    conn.execute(text("DROP TABLE IF EXISTS country"))
    conn.execute(text("DROP TABLE IF EXISTS dateall"))
    conn.execute(text("DROP TABLE IF EXISTS city"))
    conn.execute(text("DROP TABLE IF EXISTS rating"))
    conn.execute(text("DROP TABLE IF EXISTS location"))
    conn.execute(text("DROP TABLE IF EXISTS comment"))
    conn.execute(text("DROP TABLE IF EXISTS vote"))
  

# Convert dataframe to sql table 
traveller.to_sql('traveller', engine,dtype={"InputID":Integer(), "Traveller_ID": Integer(),"Traveller_Location": String (200)}, if_exists='replace', index=False)
country.to_sql('country', engine,dtype={"Traveller_Country":String (200),"Traveller_Location": String (200)}, if_exists='replace', index=False)
date.to_sql('dateall', engine,dtype={"InputID":Integer(),"Traveller_ID": Integer(),"Travel_Year": Integer(),"Travel_Month": Integer()}, if_exists='replace', index=False) 
location.to_sql('location', engine, dtype={"InputID":Integer(),"Traveller_ID": Integer(),"Town": String (200),"Province": String (200)}, if_exists='replace', index=False)
rating.to_sql('rating', engine,dtype={"InputID":Integer(),"Traveller_ID": Integer(),"Location_Name": String (200),"Rating": Integer()},  if_exists='replace', index=False)
votes.to_sql('vote', engine, dtype={"InputID":Integer(),"Traveller_ID": Integer(),"Helpful_Votes": Integer()}, if_exists='replace', index=False)
comments.to_sql('comment', engine, dtype={"InputID":Integer(), "Traveller_ID": Integer(),"Title": String (200), "text": String(90000)}, if_exists='replace', index=False)

