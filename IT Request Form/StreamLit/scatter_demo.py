import streamlit as st
import altair as alt
from vega_datasets import data
import time

source = data.cars()
x = data.airports()
chart = st.empty()


for i in source.index:
    data_to_be_added = source.iloc[0: i + 1, :]

    x = alt.Chart(data_to_be_added).mark_circle(size=i * 10).encode(
        x='Horsepower',
        y='Miles_per_Gallon',
        color='Origin',
        tooltip=['Name', 'Origin', 'Horsepower', 'Miles_per_Gallon']
    ).interactive()

    time.sleep(0.2)

    chart.altair_chart(x)