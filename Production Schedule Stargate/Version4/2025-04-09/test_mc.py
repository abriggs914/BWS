import pandas as pd

from tkinter_utility import MultiComboBox
import tkinter as tk


if __name__ == "__main__":

	app = tk.Tk()

	frame = tk.Frame(app, width=800, height=600)

	data = pd.DataFrame([
		[1, "avery1", True, 1.301],
		[11, "avery2", True, 1.185],
		[100, "avery3", True, 1.224],
		[112, "avery4", True, 1.265],
		[1000, "avery5", True, 1.013],
		[10110, "avery6", True, 1.700]
	])
	data.columns = ["ID", "Name", "IsHuman", "Height (M)"]

	mc = MultiComboBox(
		frame,
		data=data,

		include_aggregate_row=False,
		include_drop_down_arrow=False,
		limit_to_list=False,
		allow_insert_ask=False,
		lock_result_col="ID",
		auto_grid=False,
		show_index_column=False
	)

	frame.grid()
	mc.grid_widget()
	app.mainloop()

