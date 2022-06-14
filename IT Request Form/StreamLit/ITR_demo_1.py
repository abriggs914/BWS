

from colour_utility import *
import streamlit as st
import pandas as pd
import plotly.express as px
import pyodbc

@st.cache
def read_excel():

    def connect():
        df = None
        try:
            sql = "SELECT [IT Requests].*, [dept].[Dept] AS [DeptName], [IT Personnel].[Name] AS [ITPersonnelAssignedName] FROM [IT Requests] LEFT JOIN [Dept] ON [IT Requests].[Department] = [Dept].[DeptID] LEFT JOIN [IT Personnel] ON [IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]"
            cstr = "DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456"
            print("connecting...")
            conn = pyodbc.connect(cstr)
            print("querying...")
            df = pd.DataFrame(pd.read_sql_query(sql, conn))
            conn.close()
        except pyodbc.DatabaseError as de:
            print(f"DatabaseError\n{de}")
        return df

    return pd.read_excel(
        io=r"2022-06-13.xlsx",
        engine="openpyxl",
        sheet_name="Sheet1",
        skiprows=0,
        usecols="A:AF",
        nrows=700
    )
    # return connect()


if __name__ == "__main__":

    st.set_page_config(
            page_title="ITR Dashboard Example",
            page_icon=":bar_chart:",
            layout="wide"
        )




    df = read_excel()
    print("df\n", df)

    st.sidebar.header("Please Filter Here:")
    filter_department = st.sidebar.multiselect(
        "Select an Department:",
        options=df["DeptName"].unique(),
        default=df["DeptName"].unique()
    )
    # st.sidebar.markdown("OR")
    filter_type = st.sidebar.multiselect(
        "Select a Request Type:",
        options=df["RequestType"].unique(),
        default=df["RequestType"].unique()
    )
    # st.sidebar.markdown("OR")
    filter_subtype = st.sidebar.multiselect(
        "Select a Request Sub-Type:",
        options=df["RequestSubType"].unique(),
        default=df["RequestSubType"].unique()
    )
    print("filter_department:", filter_department)
    print("filter_type:", filter_type)
    print("filter_subtype:", filter_subtype)

    # low_age

    # mask = df.index == 0
    # df['mask'] = True
    # print(" VV MASK VV ")
    # print(df)
    # print(" ^^ MASK ^^ ")

    df_selection = df.query(
        "DeptName == @filter_department & RequestType == @filter_type & RequestSubType == @filter_subtype"
    )

    # df_selection = df.query(
    #     "@df[df['Department']] == @filter_department"
    # )

    # df_selection = df.query(
    #     "@df['Department'] == @filter_department | 'RequestType' == @filter_type | 'RequestSubType' == @filter_subtype"
    # )

    # df_selection = df.query(
    #     "'RequestType' == @filter_type | 'RequestSubType' == @filter_subtype"
    # )

    # df_selection = df.query(
    #     "'RequestSubType' == @filter_subtype"
    # )

    # print(sys.argv)

    # print(df)

    st.title(":bar_chart: ITR Streamlit demo")
    st.markdown("##")

    number_requests = df_selection["ITRequestID#"].count()
    hours_budgeted = round(df_selection["LabourEstimate"].sum(), 2)
    hours_issued = round(df_selection["LabourActual"].sum(), 2)
    hours_performance = f"{round(100 * hours_issued / hours_budgeted, 2)} %"
    col_1, col_2, col_3, col_4 = st.columns(4)
    with col_1:
        st.subheader("Number Requests:")
        st.subheader(f"{number_requests}")
    with col_2:
        st.subheader("Hours Budgeted:")
        st.subheader(f"{hours_budgeted}")
    with col_3:
        st.subheader("Hours Issued:")
        st.subheader(f"{hours_issued}")
    with col_4:
        st.subheader("Performance:")
        st.subheader(f"{hours_performance}")

    st.markdown("---")

    #
    # average_age = round(df_selection["Age"].mean(), 1)
    # average_weight = round(df_selection["Weight(kg)"].mean(), 1)
    # average_height = round(df_selection["Height(cm)"].mean(), 1)
    #
    # col_left, col_mid, col_right = st.columns(3)
    # with col_left:
    #     st.subheader("Average Age:")
    #     st.subheader(f"{average_age}")
    # with col_mid:
    #     st.subheader("Average Height(cm):")
    #     st.subheader(f"{average_height}")
    # with col_right:
    #     st.subheader("Average Weight(kg):")
    #     st.subheader(f"{average_weight}")
    #
    # st.markdown("---")
    #
    # # height and weight by age - scatter
    # # heights_by_age = (
    # #     df_selection.groupby(by=["Age"]).mean()[["Total"]].sort_values(by="Total")
    # # )
    # # fig_heights_by_age = px.scatter(
    # #     heights_by_age,
    # #     x="Age",
    # #     y=heights_by_age.index,
    # #     orientation="h",
    # #     title="<b>Heights by Age</b>",
    # #     template="plotly_white"
    # # )
    #
    # fig_heights_by_age = px.scatter(
    #     df_selection,
    #     x="Age",
    #     y="Height(cm)",
    #     template="plotly_white"
    # )
    #
    # fig_heights_by_age.update_layout(
    #     plot_bgcolor=rgb_to_hex(BWS_RED),
    #     xaxis=(dict(showgrid=False))
    # )
    #
    # fig_weights_by_age = px.scatter(
    #     df_selection,
    #     x="Age",
    #     y="Weight(kg)",
    #     template="plotly_white"
    # )
    #
    # fig_weights_by_age.update_layout(
    #     plot_bgcolor=rgb_to_hex(BWS_RED),
    #     xaxis=(dict(showgrid=False))
    # )
    #
    # # st.plotly_chart(fig_heights_by_age)
    # # st.plotly_chart(fig_weights_by_age)
    #
    # col_left, col_right = st.columns(2)
    # col_left.plotly_chart(fig_heights_by_age, use_container_width=True)
    # col_right.plotly_chart(fig_heights_by_age, use_container_width=True)

    hide_st_style = """<style>#MainMenu {visibility: hidden;} footer {visibility: hidden;} header {visibility: hidden;}</style>"""
    # st.markdown(hide_st_style, unsafe_allow_html=True)

    # st.dataframe(df_selection)
    print("selection")
    print(df_selection)
    # st.dataframe(df)

    # print("RESULT: " + os.popen(r"streamlit run main.py 1").read())
    # success = subprocess.run([r"C:\Users\ABriggs\AppData\Local\Microsoft\WindowsApps\python3.9.exe 'C:/Users/ABriggs/Documents/BWS/IT Request Form/StreamLit/main.py'"], stdout=subprocess.PIPE)
    # print(success.stdout)