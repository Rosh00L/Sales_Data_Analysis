import pandas as pd,re, itertools
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String, text
import numpy as np

import string
from collections import Counter
import nltk
from nltk.corpus import stopwords
from nltk.corpus import wordnet
from nltk.sentiment import SentimentIntensityAnalyzer
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import word_tokenize

'''''
nltk.download('punkt')
nltk.download('wordnet')
nltk.download('stopwords')
nltk.download('averaged_perceptron_tagger')
nltk.download('vader_lexicon')
nltk.download('punkt_tab')
nltk.download('averaged_perceptron_tagger_eng')
'''''


lemmatizer = WordNetLemmatizer()
stop_words = set(stopwords.words('english'))

# Credentials to database connection
hostname="localhost"
dbname="ecocapture"
uname="root"
pwd="rootroot"

# Create SQLAlchemy engine to connect to MySQL Database
engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))

Tbcomments = pd.read_sql( 
    "SELECT * FROM ecocapture.comment", 
    con=engine 
)

df=pd.DataFrame(Tbcomments).reset_index()
print (df)

df['clean_comments'] = df['comments'].fillna('')

def get_wordnet_pos(treebank_tag):
    """Map POS tag to first character used by WordNetLemmatizer"""
    if treebank_tag.startswith('J'):
        return wordnet.ADJ
    elif treebank_tag.startswith('V'):
        return wordnet.VERB
    elif treebank_tag.startswith('N'):
        return wordnet.NOUN
    elif treebank_tag.startswith('R'):
        return wordnet.ADV
    else:
        return wordnet.NOUN  # by default, treat as noun

def preprocess_text(comments):
    tokens = word_tokenize(comments)
    tokens = [word.lower() for word in tokens]
    tokens = [word for word in tokens if word.isalpha() or word in string.punctuation]
    pos_tags = nltk.pos_tag(tokens)
    tokens = [lemmatizer.lemmatize(word, get_wordnet_pos(pos)) for word, pos in pos_tags]
    tokens = [word for word in tokens if word not in stop_words]

    return " ".join(tokens)

df['processed_comments'] = df['clean_comments'].apply(preprocess_text)

sia = SentimentIntensityAnalyzer()

def get_sentiment(comments):
    sentiment_score = sia.polarity_scores(comments)['compound']
    if sentiment_score >= 0.05:
        return "Positive"
    elif sentiment_score <= -0.05:
        return "Negative"
    else:
        return "Neutral"
        
df['sentiment_comments'] = df['processed_comments'].apply(get_sentiment)


with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS sia"))

Sia_comments=df[["InputID","Traveller_ID","processed_comments","sentiment_comments"]].reset_index(drop=True)
Sia_comments=pd.DataFrame(Sia_comments).sort_values(by=("InputID"))
sia = pd.DataFrame(Sia_comments)
sia.to_sql('sia', engine, dtype={"InputID":Integer(), "Traveller_ID": Integer(),"processed_comments": String (9000), "sentiment_comments":String(10)}, if_exists='replace', index=False)
