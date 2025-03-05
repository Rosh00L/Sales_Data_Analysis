import pandas as pd
from string import printable
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String ,text
from sqlalchemy_utils import create_database, database_exists
import numpy as np

# Credentials to database connection
hostname="localhost"
dbname="SalesData"
uname="root"
pwd="rootroot"

# Create dataframe from source csv file ####

fileCSV=r"C:\Github_proj\Sales_Data_Analysis\Source\Sales Data.csv"
allRev = pd.read_csv(fileCSV,sep=',',encoding='latin')
sales=pd.DataFrame(allRev).reset_index()

engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))
if not database_exists(engine.url): create_database(engine.url)        

# Execute the DROP TABLE statement directly
with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS ref_sales"))


# Convert dataframe to sql table 
sales.to_sql('ref_sales', engine, if_exists='replace', index=False)
