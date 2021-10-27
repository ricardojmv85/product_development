import streamlit as st  
import numpy as np
import pandas as pd 
import time 

st.title('This is my first app from Galileo Master!')
x = 4
st.write(x, ' square is ', x*x)

x, ' square is ', x**2

st.write('This is a Data Frame example')
st.write(pd.DataFrame({
    'Column A': ['A', 'B', 'C', 'D', 'E'],
    'Column B': [1, 2, 3, 4, 5]
}))


"""
# Title: This is a Title tag
This is other example for dataframes
"""

df = pd.DataFrame({
    'Column A': ['A', 'B', 'C', 'D', 'E'],
    'Column B': [1, 2, 3, 4, 5]
})

df

"""
## Show me some graphs
"""
df_to_plot = pd.DataFrame(
    np.random.randn(20, 3), columns=['Column A', 'Column B', 'Column C']
)

st.line_chart(df_to_plot)

"""
## Let's plot a map!
"""

df_lat_long = pd.DataFrame(
    np.random.randn(1000, 2) / [50, 50] + [37.76, -122.4],
    columns=['lat', 'lon']
)

st.map(df_lat_long)

if st.checkbox('show dataframe'):
    df_lat_long


"""
## Let's try some widgets

### 1. Slider
"""

x = st.slider('Select a value for X', min_value=1, max_value=100, value=4)
y = st.slider('Select a power value for X', min_value=0, max_value=5, value=2)
st.write(x, ' ^ = ', y, x**y)

"""
### What about options
"""

def test():
    st.write('Funcion ejecutada')


option_list = range(1, 11)
option = st.selectbox('Which number do you like best?', option_list, index=3, on_change=test)
st.write('Your favorite number is: ', option)


"""
### What about a progress bar
"""

label = st.empty()
progress_bar = st.progress(0)

for i in range(0, 101):
    label.text(f'The process is {i}%')
    progress_bar.progress(i)
    time.sleep(.01)

'The wait is done!'


st.sidebar.write("This is a sidebar")

option = st.sidebar.selectbox('Select a Side number', option_list, index=3, on_change=test)
st.sidebar.write('The selection is: ', option)

st.sidebar.write('Another slider')

another_slider = st.sidebar.slider('Select Range', 0.0, 100.0, (25.0, 75.0))

st.sidebar.write('The range selected is: ', another_slider)