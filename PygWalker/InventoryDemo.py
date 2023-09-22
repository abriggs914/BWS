from pyodbc_connection import *
from utility import *
import streamlit as st


def save_edit_form():
    # global dat_form_edit
    dat_form_edit["HardwareType"] = inp_hw_type
    dat_form_edit["BrandName"] = inp_b_name
    dat_form_edit["ModelName"] = inp_m_name
    dat_form_edit["Supplier"] = inp_supplier


def load_edit_form():
    # global dat_form_edit
    inp_hw_type.selected_value = dat_form_edit.get("HardwareType", "")
    inp_b_name.selected_value = dat_form_edit.get("BrandName", "")
    inp_m_name.selected_value = dat_form_edit.get("ModelName", "")
    inp_supplier.selected_value = dat_form_edit.get("Supplier", "")


dat_form_edit = dict()


df = connect("SELECT * FROM [ITI Inventory]")

lsts = [
    lst_hw_type := df["HardwareType"].unique().tolist(),
    lst_b_name := df["BrandName"].unique().tolist(),
    lst_m_name := df["ModelName"].unique().tolist(),
    lst_supplier := df["Supplier"].unique().tolist()
]

for lst in lsts:
    if None in lst:
        lst.remove(None)
    elif "None" in lst:
        lst.remove("None")

    lst.insert(0, "")

# begin Streamlit elements

st.title("BWS Inventory")

# nav_side_bar_main = st.sidebar()
lst_opt_sidebar_nav_radio = ["Edit", "Assign", "Move"]
STATE = lst_opt_sidebar_nav_radio[0]
sidebar_nav_radio = st.sidebar.radio("BWS Inventory", options=lst_opt_sidebar_nav_radio)

win_edit = st.empty()

# col0, col1, col2, col3 = win_edit.container().columns([2, 1, 1, 1])
# TODO replace the below with the above.
cols = win_edit.container().columns([2, 1, 1, 1])
col0: st.delta_generator.DeltaGenerator = cols[0]
col1: st.delta_generator.DeltaGenerator = cols[1]
col2: st.delta_generator.DeltaGenerator = cols[2]
col3: st.delta_generator.DeltaGenerator = cols[3]

inp_hw_type = col0.selectbox("Hardware Type:", lst_hw_type)
inp_b_name = col0.selectbox("Brand Name:", lst_b_name)
inp_m_name = col0.selectbox("Model Name:", lst_m_name)
inp_supplier = col0.selectbox("Supplier:", lst_supplier)

inp_tog_acquired_date = col1.toggle("Known")
inp_acquired_date = col1.date_input("Acquisition Date:")

with win_edit.container():
    _edit = sidebar_nav_radio == lst_opt_sidebar_nav_radio[0]
    _assign = sidebar_nav_radio == lst_opt_sidebar_nav_radio[1]
    _move = not any([_edit, _assign])

    if (STATE == lst_opt_sidebar_nav_radio[0]) and (not _edit):
        # save edit form before navigating away
        save_edit_form()

    if _edit:
        # Edit inventory
        load_edit_form()
        print("Edit")
    elif _assign:
        # Assign inventory
        win_edit.empty()
        print("Assign")
    else:
        # Move inventory
        win_edit.empty()
        print("Else")

# import time
# import random
# def skeleton():
#     left, right = st.columns(2)
#     with right:
#         numbers = st.empty()
#     return left, right, numbers
#
# left, right, numbers = skeleton()
# while True:
#     with right:
#         with numbers.container():
#             st.selectbox('food',random.sample(range(10, 40), 4))
#             time.sleep(2)
