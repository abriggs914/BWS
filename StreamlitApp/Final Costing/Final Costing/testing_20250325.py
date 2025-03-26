from typing import Any, Union, List

import pandas as pd

import streamlit as st
from pyodbc_connection import *
from streamlit_utility import display_df

st.set_page_config(
	layout="wide",
	page_title="TESTING"
)


@st.cache_data()
def load_df(sql) -> pd.DataFrame:
	return connect(sql)


def top_n_with_other_bin2(
		df: pd.DataFrame,
		column: str | list[str] | Any,
		top_n: int = 3,
		other_label: str = "other",
		dropna: bool = False
) -> pd.DataFrame:
	"""
	Returns a DataFrame with the top N most frequent values in a column and groups the rest into an 'other' bin.

	Args:
		df (pd.DataFrame): The input DataFrame.
		column (str): Column name to analyze.
		top_n (int): Number of top values to keep.
		other_label (str): Label for the aggregated 'other' bin.

	Returns:
		pd.DataFrame: A DataFrame with 'Value', 'Count', and 'Proportion' columns.
	"""
	# Calculate counts and proportions
	counts = df[column].value_counts(dropna=dropna)
	proportions = df[column].value_counts(dropna=dropna, normalize=True)

	# Get top N values
	top_values = counts.head(top_n).index

	# Create result DataFrame
	top_df = pd.DataFrame({
		"Value": top_values,
		"Count": counts.loc[top_values].values,
		"Proportion": proportions.loc[top_values].values
	})

	# Handle 'other' values
	if len(counts) > top_n:
		other_count = counts.loc[~counts.index.isin(top_values)].sum()
		other_prop = proportions.loc[~proportions.index.isin(top_values)].sum()

		other_row = pd.DataFrame([{
			"Value": other_label,
			"Count": other_count,
			"Proportion": other_prop
		}])

		top_df = pd.concat([top_df, other_row], ignore_index=True)

	top_df["Value"] = top_df["Value"].apply(lambda v: list(v) if isinstance(v, tuple) else v)

	return top_df


def top_n_with_other_bin3(
	df: pd.DataFrame,
	column: Union[str, List[str]],
	top_n: int = 3,
	other_label: str = "other",
	group_by: Union[None, str, int, List[Union[str, int]]] = None,
	dropna: bool = False
) -> pd.DataFrame:
	"""
	Returns a DataFrame with the top N most frequent values in one or more columns and groups the rest into an 'other' bin.
	Optionally groups the result by one or more other columns before aggregation.

	Args:
		df (pd.DataFrame): The input DataFrame.
		column (str or list): Column name(s) to analyze.
		top_n (int): Number of top values to keep.
		other_label (str): Label for the aggregated 'other' bin.
		group_by (str/int/list): Column(s) to group by before value_counts.

	Returns:
		pd.DataFrame: A DataFrame with 'Group', 'Value', 'Count', and 'Proportion' columns.
	"""

	if isinstance(column, str):
		column = [column]

	if isinstance(group_by, (str, int)):
		group_by = [group_by]
	elif group_by is None:
		group_by = []

	# Convert int index to column names
	group_by_cols = [df.columns[i] if isinstance(i, int) else i for i in group_by]

	result_frames = []

	if group_by_cols:
		grouped = df.groupby(group_by_cols, dropna=dropna)
	else:
		grouped = [(None, df)]

	for group_vals, sub_df in grouped:
		group_keys = sub_df[column].astype(str).agg(" | ".join, axis=1)
		counts = group_keys.value_counts(dropna=dropna)
		proportions = group_keys.value_counts(dropna=dropna, normalize=True)

		top_values = counts.head(top_n).index

		group_str = (
			"_".join(str(val) for val in group_vals) if isinstance(group_vals, tuple)
			else str(group_vals)
		)

		group_df = pd.DataFrame({
			"Group": group_str if group_by else "All",
			"Value": top_values,
			"Count": counts.loc[top_values].values,
			"Proportion": proportions.loc[top_values].values
		})

		if len(counts) > top_n:
			other_count = counts.loc[~counts.index.isin(top_values)].sum()
			other_prop = proportions.loc[~proportions.index.isin(top_values)].sum()
			other_row = pd.DataFrame([{
				"Group": group_str if group_by else "All",
				"Value": f"{other_label}_{group_str}" if group_by else other_label,
				"Count": other_count,
				"Proportion": other_prop
			}])
			group_df = pd.concat([group_df, other_row], ignore_index=True)

		result_frames.append(group_df)

	return pd.concat(result_frames, ignore_index=True)


def top_n_with_other_bin4(
	data: pd.DataFrame,
	column: Union[str, List[str]],
	top_n: int = 3,
	other_label: str = "other",
	group_by: Union[None, str, int, List[Union[str, int]]] = None,
	dropna: bool = False,
	split_value: bool = True,
	split_group: bool = True,
	replace_value_col: bool = True
) -> pd.DataFrame:
	"""
	Returns a DataFrame with the top N most frequent values in one or more columns and groups the rest into an 'other' bin.
	Optionally groups the result by one or more other columns before aggregation.

	Args:
		data (pd.DataFrame): The input DataFrame.
		column (str or list): Column name(s) to analyze.
		top_n (int): Number of top values to keep.
		other_label (str): Label for the aggregated 'other' bin.
		group_by (str/int/list): Column(s) to group by before value_counts.
		split_value (bool): Whether to split the aggregated Value column back into original columns.
		split_group (bool): Whether to split the Group column back into original group_by columns.

	Returns:
		pd.DataFrame: A DataFrame with group info, original column(s), Count and Proportion.
	"""
	if isinstance(column, str):
		column = [column]

	if isinstance(group_by, (str, int)):
		group_by = [group_by]
	elif group_by is None:
		group_by = []

	group_by_cols = [data.columns[i] if isinstance(i, int) else i for i in group_by]
	result_records = []

	grouped = data.groupby(group_by_cols, dropna=dropna) if group_by_cols else [(None, data)]

	delim: str = " _||_ "
	value_name: str = "Value" if (replace_value_col or (len(column) > 1)) else column[0]

	# data_keys = [
	# 	"Group",
	# 	value_name,
	# 	"Count",
	# 	"Proportion"
	# ]

	# for group_vals, sub_df in grouped:
	# 	group_keys = sub_df[column].astype(str).agg(delim.join, axis=1)
	# 	counts = group_keys.value_counts(dropna=dropna)
	# 	proportions = group_keys.value_counts(dropna=dropna, normalize=True)
	# 	top_values = counts.head(top_n).index
	#
	# 	if isinstance(group_vals, tuple):
	# 		group_label = delim.join(str(v) for v in group_vals)
	# 	elif group_vals is not None:
	# 		group_label = str(group_vals)
	# 	else:
	# 		group_label = "All"
	#
	# 	group_df = pd.DataFrame(dict(zip(data_keys, [
	# 		group_label,
	# 		top_values,
	# 		counts.loc[top_values].values,
	# 		proportions.loc[top_values].values
	# 	])))
	#
	# 	if len(counts) > top_n:
	# 		other_count = counts.loc[~counts.index.isin(top_values)].sum()
	# 		other_prop = proportions.loc[~proportions.index.isin(top_values)].sum()
	# 		other_val = f"{other_label}_{group_label}" if group_by else other_label
	# 		data = dict(zip(data_keys, [
	# 			group_label,
	# 			other_val,
	# 			other_count,
	# 			other_prop
	# 		]))
	# 		group_df = pd.concat([
	# 			group_df,
	# 			pd.DataFrame([data])
	# 		], ignore_index=True)
	#
	# 	result_frames.append(group_df)
	#
	# final: pd.DataFrame = pd.concat(result_frames, ignore_index=True)

	for group_vals, sub_df in grouped:
		group_keys = sub_df[column].astype(str).agg(delim.join, axis=1)
		counts = group_keys.value_counts(dropna=dropna)
		proportions = group_keys.value_counts(dropna=dropna, normalize=True)
		top_values = counts.head(top_n).index

		if isinstance(group_vals, tuple):
			group_label = delim.join(str(v) for v in group_vals)
		elif group_vals is not None:
			group_label = str(group_vals)
		else:
			group_label = "All"

		for val in top_values:
			result_records.append({
				"Group": group_label,
				value_name: val,
				"Count": counts[val],
				"Proportion": proportions[val]
			})

		if len(counts) > top_n:
			other_count = counts.loc[~counts.index.isin(top_values)].sum()
			other_prop = proportions.loc[~proportions.index.isin(top_values)].sum()
			other_val = f"{other_label}_{group_label}" if group_by else other_label
			result_records.append({
				"Group": group_label,
				value_name: other_val,
				"Count": other_count,
				"Proportion": other_prop
			})

	final = pd.DataFrame(result_records)

	# print(f"A")
	# print(final)

	if split_value and len(column) > 1:
		value_split = final[value_name].str.split(delim, expand=True, regex=False)
		value_split.columns = column  # data_keys[:1] + column + data_keys[1:]
		data_keys = value_split.columns
		final = value_split.join(final.drop(columns=value_name))

	# print(f"B")
	# print(final)

	if split_group and len(group_by_cols) > 1:
		# test_a = final["Group"].str.split(delim, regex=False)
		# print(f"test_a")
		# print(test_a)
		group_split = final["Group"].str.split(delim, expand=True, regex=False)
		# print(f"test_b")
		# print(group_split)
		# # print(f"test_c")
		# # print(group_split.loc[~group_split[2].isna()])
		# print(f"group_split.columns")
		# print(f"{group_split.columns}")
		# print(f"group_split.group_by_cols")
		# print(f"{group_by_cols}")
		group_split.columns = group_by_cols  #  + data_keys[1:]
		final = group_split.join(final.drop(columns="Group"))

	# print(f"C")
	# print(final)

	return final



df = load_df("Order Standards")

st.write("df")
st.write(df)

cols = df.columns.tolist()
clbl_modelNo = "Model No"
clbl_group = "Group"
clbl_section = "Section"
clbl_sortG = "SortG"
clbl_sortSe = "SortSe"
clbl_description = "Description"

list_models = df[clbl_modelNo].dropna().unique().tolist()

print(top_n_with_other_bin2(
	df,
	[
		clbl_modelNo,
		clbl_group,
		clbl_sortG,
		clbl_section,
		clbl_sortSe,
		clbl_description
	]
))

selectbox_model = st.selectbox(
	label="Model:",
	options=list_models
)

if selectbox_model:
	df_model: pd.DataFrame = df.loc[df[clbl_modelNo] == selectbox_model]
	st.write("df_model")
	display_df(df_model)

	print(top_n_with_other_bin2(
		df_model,
		[
			clbl_group,
			clbl_sortG,
			clbl_description
			# ,
			# clbl_section,
			# clbl_sortSe
		]
	))

	list_model_groups = df_model[clbl_group].dropna().unique().tolist()

	selectbox_model_group = st.selectbox(
		label="Group:",
		options=list_model_groups
	)

	# st.write(top_n_with_other_bin2(
	# 	df_model_group_,
	# 	[
	# 		clbl_sortG
	# 		# ,
	# 		# clbl_section,
	# 		# clbl_sortSe
	# 	]
	# ))

	if selectbox_model_group:
		df_model_group: pd.DataFrame = df_model.loc[df_model[clbl_group] == selectbox_model_group]
		st.write("df_model_group")
		display_df(df_model_group)

		print(top_n_with_other_bin2(
			df_model_group,
			[
				clbl_sortG
				# ,
				# clbl_section,
				# clbl_sortSe
			]
		))

		cols_div0 = st.columns(2)
		with cols_div0[0]:
			for i, group in enumerate(list_model_groups):
				df_model_group_: pd.DataFrame = df_model.loc[df_model[clbl_group] == group]
				st.write(f"{i=}, {group=}")
				# st.write(df_model_group_)

				display_df(top_n_with_other_bin2(
					df_model_group_,
					[
						clbl_sortG
						# ,
						# clbl_description
						# ,
						# clbl_section,
						# clbl_sortSe
					]
				))
		with cols_div0[1]:
			display_df(top_n_with_other_bin3(
				df_model,
				column=[
					clbl_sortG
				],
				group_by=[
					clbl_group
				]
			))


display_df(
	top_n_with_other_bin4(
		data=df,
		column=clbl_sortG,
		group_by=[
			clbl_modelNo,
			clbl_group
		]
	),
"DF__4"
)

display_df(
	top_n_with_other_bin4(
		data=df,
		column=[
			clbl_sortSe
		],
		group_by=[
			clbl_modelNo,
			clbl_group,
			clbl_section
		],
		replace_value_col=False
	),
"DF__5"
)
