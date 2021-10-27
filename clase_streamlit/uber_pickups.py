import streamlit as st  
import numpy as np  
import pandas as pd 

"""
# Uber Pickups Exercise
"""

url = 'https://s3-us-west-2.amazonaws.com/streamlit-demo-data/uber-raw-data-sep14.csv.gz'

@st.cache
def download_data(allow_output_mutation=True):
    return pd.read_csv(url, parse_dates=['Date/Time'])

nrow = st.sidebar.slider('No. rows to display:', 0, 10000, value=1000)
hour_range = st.sidebar.slider('Select hour range', 0, 23, (8, 5))
st.sidebar.write('Hours selected', hour_range[0], hour_range[1])

data = (download_data()
        .rename(columns={'Date/Time': 'date_time', 'Lat': 'lat', 'Lon': 'lon', 'Base': 'base'})
        .assign(date_time=lambda df: pd.to_datetime(df.date_time))
        .loc[lambda df: (df.date_time.dt.hour >= hour_range[0]) & (df.date_time.dt.hour <= hour_range[1])]
        .loc[1:nrow]
        ).sort_values(by='date_time')

st.write(data)
st.map(data)
st.bar_chart(np.histogram(data.date_time.dt.hour, 24, (0, 24))[0])