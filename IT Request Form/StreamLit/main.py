import sys

import streamlit as st
#import plotly.express as px
import streamlit as st
import pandas as pd
import subprocess
import os

# Warning: to view this Streamlit app on a browser, run it with the following
#   command:
#
#     streamlit run C:/Users/ABriggs/Documents/BWS/IT Request Form/StreamLit/main.py [ARGUMENTS]
#     streamlit run main.py

# emojis: https://www.webfx.com/tools/emoji-cheat-sheet/
st.set_page_config(
    page_title="ITR Dashboard Example",
    page_icon=":bar_chart:",
    layout="wide"
)

if __name__ == '__main__':

    args = sys.argv
    if args:
        if len(args) == 1 or (len(args) > 1 and args[1] == "1"):

            df = pd.read_excel(
                io=r"Raw.xlsx",
                engine="openpyxl",
                sheet_name="Sheet1",
                skiprows=0,
                usecols="A:E",
                nrows=12
            )


            print(df)

            st.dataframe(df)

            st.sidebar.header("Please Filter Here:")
            filter_age = st.sidebar.multiselect(
                "Select an Age:",
                options=df["Age"].unique(),
                default=df["Age"].unique()
            )

            print(sys.argv)

            print("RESULT: " + os.popen(r"streamlit run main.py 1").read())
            # success = subprocess.run([r"C:\Users\ABriggs\AppData\Local\Microsoft\WindowsApps\python3.9.exe 'C:/Users/ABriggs/Documents/BWS/IT Request Form/StreamLit/main.py'"], stdout=subprocess.PIPE)
            # print(success.stdout)
