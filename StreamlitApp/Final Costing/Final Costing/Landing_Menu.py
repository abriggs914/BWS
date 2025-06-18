import streamlit as st


st.set_page_config(
	layout="wide",
	page_title="BWSStreamlitLanding"
)


st.header("Welcome to BWS Streamlit Environment!")
st.subheader("Please select a page to visit:")


page_data = {
	"Landing_Menu.py": dict(
		label="Home",
		icon="🏠"
	),
	"pages/0_Authentication_Demo.py": dict(
		label="Auth Demo"
	),
	"pages/1_Inventory.py": dict(
		label="Inventory"
	),
	"pages/2_Monitoring_Schedule.py": dict(
		label="Monitoring Schedule"
	),
	"pages/3_Production_Tracker.py": dict(
		label="Production Tracker"
	),
	"pages/4_Sales_Map.py": dict(
		label="Sales Map"
	),
	"pages/5_Splash_Demo.py": dict(
		label="Splash Demo"
	),
	"pages/6_Copy PO Files.py": dict(
		label="Copy PO Files"
	),
	"pages/7_IT.py": dict(
		label="IT"
	),
	"pages/8_Streamlit_Guide.py": dict(
		label="Streamlit Guide"
	),
	"pages/9_Cost_Implosion_Export.py": dict(
		label="Cost Implosion Export"
	),
	"pages/10_Testing.py": dict(
		label="Testing"
	),
	"pages/11_Testing_IT.py": dict(
		label="Testing IT"
	),
	"pages/12_Part_Search.py": dict(
		label="Part Search"
	),
	"pages/13_Prod_Sched_Updater.py": dict(
		label="Prod Sched Updater"
	),
	"pages/14_Syspro.py": dict(
		label="Syspro"
	),
	"pages/Sales.py": dict(
		label="Sales"
	)
}

for file_name, data_page in page_data.items():
	label = data_page.get("label")
	icon = data_page.get("icon")
	st.page_link(file_name, label=label, icon=icon)

# st.page_link(file_name, label="Home", icon="🏠")
# st.page_link("pages/page_1.py", label="Page 1", icon="1️⃣")
# st.page_link("pages/page_2.py", label="Page 2", icon="2️⃣", disabled=True)
# st.page_link("http://www.google.com", label="Google", icon="🌎")