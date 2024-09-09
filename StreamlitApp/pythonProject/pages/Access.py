import datetime

import pandas as pd
import streamlit as st
import plotly.express as px

from pages.pyodbc_connection import connect


ms_data = {
    "ms_user_choice": {
        "lbl": "Select User(s):",
        "df_key": "WindowsUser",
        "default": ["All"]
    },
    "ms_db_choice": {
        "lbl": "Select Database(s):",
        "df_key": "AccessDB",
        "default": ["All"]
    },
    "ms_start_form_choice": {
        "lbl": "Select Form(s):",
        "df_key": "FormAccessed",
        "default": ["All"]
    },
    "ms_ctl_choice": {
        "lbl": "Select Control(s):",
        "df_key": "CtlCaption",
        "default": ["All"]
    },
    "ms_dest_form_choice": {
        "lbl": "Select Destination Form(s):",
        "df_key": "DestinationForm",
        "default": ["All"]
    }
}


@st.cache_data(ttl=3600)
def load_access_events():
    return connect(
        sql="""

    SELECT
    	*
    FROM
    	[BWSdb].[dbo].[ADG Events]
    ;
            """
    )


def update_ms(key):
    if key not in st.session_state:
        return
    val = st.session_state.get(key, list())
    print(f"{key=}, {val=}")

    gather_graph_top_forms()


def check_ms_inputs() -> list[list[str]]:

    users = st.session_state.get("ms_user_choice", ms_data["ms_user_choice"]["default"])
    dbs = st.session_state.get("ms_db_choice", ms_data["ms_db_choice"]["default"])
    start_forms = st.session_state.get("ms_start_form_choice", ms_data["ms_start_form_choice"]["default"])
    controls = st.session_state.get("ms_ctl_choice", ms_data["ms_ctl_choice"]["default"])
    dest_forms = st.session_state.get("ms_dest_form_choice", ms_data["ms_dest_form_choice"]["default"])

    # for k, v in st.session_state.items():
    #     print(f"{k=}, {v=}")

    if "All" in users:
        users = [v for v in df_access_events[
            ms_data["ms_user_choice"]["df_key"]
        ].drop_duplicates().dropna().sort_values().values.tolist() if v]
    if "All" in dbs:
        dbs = [v for v in df_access_events[
            ms_data["ms_db_choice"]["df_key"]].drop_duplicates().dropna().sort_values().values.tolist() if v]
    if "All" in start_forms:
        start_forms = [v for v in df_access_events[
            ms_data["ms_start_form_choice"]["df_key"]].drop_duplicates().dropna().sort_values().values.tolist() if v]
    if "All" in controls:
        controls = [v for v in df_access_events[
            ms_data["ms_ctl_choice"]["df_key"]].drop_duplicates().dropna().sort_values().values.tolist() if v]
    if "All" in dest_forms:
        dest_forms = [v for v in df_access_events[
            ms_data["ms_dest_form_choice"]["df_key"]].drop_duplicates().dropna().sort_values().values.tolist() if v]

    return [users, dbs, start_forms, controls, dest_forms]


def gather_graph_top_forms() -> pd.DataFrame:
    global df_graph_top_forms

    lists = check_ms_inputs()
    users, dbs, start_forms, controls, dest_forms = lists
    if not all(lists):
        df_graph_top_forms = pd.DataFrame()
        print(f"EMPTYING")
    else:
        df_graph_top_forms = df_access_events.loc[
            (df_access_events["WindowsUser"].isin(users))
            & (df_access_events["AccessDB"].isin(dbs))
            & (df_access_events["FormAccessed"].isin(start_forms))
            & (df_access_events["CtlCaption"].isin(controls))
            & (df_access_events["DestinationForm"].isin(dest_forms))
        ]
        print(f"FILLING")
        print(f"{df_graph_top_forms}")

        df_graph_top_forms = df_graph_top_forms["DestinationForm"].value_counts().reset_index()
        df_graph_top_forms.columns = ["DestinationForm", "Count"]
        df_graph_top_forms.sort_values(by="Count", ascending=False, inplace=True)
        print(f"{df_graph_top_forms=}")

    return df_graph_top_forms


def gather_graph_top_users():
    global df_graph_top_users

    lists = check_ms_inputs()
    users, dbs, start_forms, controls, dest_forms = lists
    if not all(lists):
        df_graph_top_users = pd.DataFrame()
        print(f"EMPTYING")
    else:
        df_graph_top_users = df_access_events.loc[
            (df_access_events["WindowsUser"].isin(users))
            & (df_access_events["AccessDB"].isin(dbs))
            & (df_access_events["FormAccessed"].isin(start_forms))
            & (df_access_events["CtlCaption"].isin(controls))
            & (df_access_events["DestinationForm"].isin(dest_forms))
        ]
        print(f"FILLING")
        print(f"{df_graph_top_users=}")

        df_graph_top_users = df_graph_top_users["WindowsUser"].value_counts().reset_index()
        df_graph_top_users.columns = ["WindowsUser", "Count"]
        df_graph_top_users.sort_values(by="Count", ascending=False, inplace=True)
        print(f"{df_graph_top_users=}")

    return df_graph_top_users


def update_date_range(start_date=None, end_date=None):
    n = datetime.datetime.now().date()
    dr = st.session_state.get("date_range", (n + datetime.timedelta(days=-365), n))
    dr = list(map(lambda ts: ts.date() if isinstance(ts, pd.Timestamp) else ts, dr))
    # n = pd.Timestamp(datetime.datetime.now())
    # dr = st.session_state.get("date_range", (n + datetime.timedelta(days=-365), n))
    if start_date is None:
        start_date = dr[0]
    if end_date is None:
        end_date = dr[1]

    # start_date, end_date = list(map(lambda ts: ts.date(), [start_date, end_date]))
    start_date, end_date = min(start_date, end_date), max(start_date, end_date)

    # # if start_date + pd.DateOffset(years=1) < max_date:
    # if start_date + datetime.timedelta(days=365) < max_date:
    #     end_date = min(start_date + datetime.timedelta(days=1), max_date)
    #     # end_date = min(start_date + pd.DateOffset(years=1), max_date)
    # else:
    #     end_date = max_date
    # if (end_date - start_date).days > 365:
    #     if
    #     end_date =
    print(f"UPD {start_date=}, {end_date=}, {dr=}")
    print(f"{sl_start_date=}, {sl_end_date=}")
    st.session_state.date_range = (sl_start_date, sl_end_date)
    return start_date, end_date


if __name__ == '__main__':

    # n = datetime.datetime.now().date()
    n = pd.Timestamp(datetime.datetime.now())

    # Init session state values
    for key, def_val in {k: v["default"] for k, v in ms_data.items()}.items():
        if key not in st.session_state:
            st.session_state.setdefault(key, def_val)
    if "date_range" not in st.session_state:
        st.session_state.setdefault("date_range", (n + datetime.timedelta(days=-365), n))
        # st.session_state.setdefault("date_range", (n + pd.DateOffset(days=-365), n))

    # page configuration
    st.set_page_config(
        page_title="BWS Access Data",
        layout="wide"
    )

    # fetch data
    df_access_events = load_access_events()
    df_access_events["WindowsUser"] = df_access_events["WindowsUser"].fillna("").apply(lambda user: user.lower())
    df_access_events["DateCreated"] = pd.to_datetime(df_access_events["DateCreated"])
    # first_last_df = df_access_events.groupby(['WindowsUser', 'DateCreated']).agg(
    #     TimeStart=('DateCreated', 'min'),
    #     TimeEnd=('DateCreated', 'max')
    # ).reset_index()\
    dr = st.session_state.get("date_range", (n + datetime.timedelta(days=-365), n))
    # dr = st.session_state.get("date_range", (n + pd.DateOffset(days=-365), n))
    sd, ed = dr
    if not isinstance(sd, pd.Timestamp):
        sd = pd.Timestamp(sd)
    if not isinstance(ed, pd.Timestamp):
        ed = pd.Timestamp(ed)
    print(f"{sd=}, {ed=}")
    first_last_df = df_access_events.loc[
        (sd <= df_access_events["DateCreated"])
        & (df_access_events["DateCreated"] <= ed)
    ].groupby(
        by=[
            df_access_events['WindowsUser'],
            df_access_events['DateCreated'].dt.year.rename("Year"),
            df_access_events['DateCreated'].dt.month.rename("Month"),
            df_access_events['DateCreated'].dt.day.rename("Day")
        ]).agg(
            TimeStart=('DateCreated', 'min'),  # First (earliest) record for the day
            TimeEnd=('DateCreated', 'max')     # Last (latest) record for the day
        ).reset_index()
    # first_last_df["DateCreated"] = pd.to_datetime(first_last_df["DateCreated"])
    print(f"{first_last_df=}")
    with st.expander("first_last_date"):
        st.dataframe(first_last_df)

    df_graph_top_forms = gather_graph_top_forms()
    df_graph_top_users = gather_graph_top_users()

    # widget layout map
    layout = {
        "title_row": st.columns(1),
        "input_row": st.columns(1),
        "graph_row": st.columns(1)
    }

    # begin widget creation
    with layout["title_row"][0]:
        with st.expander("Access Events"):
            st.dataframe(df_access_events)

    with layout["input_row"][0]:
        for key, data in ms_data.items():
            options = df_access_events[data["df_key"]].drop_duplicates().dropna().sort_values().values.tolist()
            if "All" not in options:
                options.insert(0, "All")
            st.multiselect(
                data["lbl"],
                options=options,
                key=key,
                on_change=lambda key_=key: update_ms(key_)
            )

    with layout["graph_row"][0]:
        st.divider()
        print(f"ENCOUNTERED {df_graph_top_forms.head()=}")
        if df_graph_top_forms.empty:
            st.write("Please choose some valid inputs")
        else:
            st.write(f"Access history for selected inputs:")
            # st.bar_chart(
            #     df_graph_top_forms.set_index("Count"),
            #     # x="DestinationForm",
            #     # y="Count",
            #     y_label="Forms",
            #     x_label="# Accesses"
            # )
            # st.bar_chart(
            #     df_graph_top_forms.set_index("DestinationForm"),
            #     # x="DestinationForm",
            #     # y="Count",
            #     x_label="Forms",
            #     y_label="# Accesses"
            # )
            fig_top_used_forms = px.bar(
                df_graph_top_forms.head(max(5, int(df_graph_top_forms.shape[0] * 0.1))),
                x="DestinationForm",
                y="Count",
                labels={"DestinationForm": "Forms", "Count": "# Accesses"},
                title="Top 10% Used Forms:"
            )
            st.plotly_chart(fig_top_used_forms)
            fig_top_users = px.bar(
                df_graph_top_users.head(max(5, int(df_graph_top_users.shape[0] * 0.1))),
                x="WindowsUser",
                y="Count",
                labels={"WindowsUser": "User", "Count": "# Accesses"},
                title="Top 10% Users:"
            )
            st.plotly_chart(fig_top_users)

    min_date = df_access_events["DateCreated"].min().date()
    max_date = df_access_events["DateCreated"].max().date()
    print(f"{min_date=}, {type(min_date)=}")
    print(f"{max_date=}, {type(max_date)=}")
    print(f"{st.session_state.date_range=}")
    dr = list(map(lambda ts: ts.date() if isinstance(ts, pd.Timestamp) else ts, st.session_state.date_range))
    print(f"PLOTTING {dr=}")
    sl_start_date, sl_end_date = st.slider(
        "Select Date Range",
        min_value=min_date,
        max_value=max_date,
        # value=,
        # key=st.session_state.date_range,
        # value=st.session_state.date_range,
        value=list(map(lambda ts: ts.date() if isinstance(ts, pd.Timestamp) else ts, st.session_state.date_range)),
        format="YYYY-MM-DD",
        on_change=update_date_range
    )

    # Plot using Plotly Express timeline
    fig = px.timeline(
        first_last_df,
        x_start="TimeStart",
        x_end="TimeEnd",
        y="WindowsUser",
        color="WindowsUser",  # Optional: differentiate users by color
        title="User TimeOn Timeline"
    )

    # Update layout to make the timeline more readable
    fig.update_layout(
        xaxis_title="Time",
        yaxis_title="Windows User",
        showlegend=False,
        height=1600
    )

    # Display in Streamlit
    st.plotly_chart(fig)
