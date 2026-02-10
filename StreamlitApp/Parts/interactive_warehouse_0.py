



# Timestamp
# 202601051314



# # # img_path = r"G:\IT\Network Port Layout\BWS\Parts Room v0.png"
# # #
# # # # # import matplotlib.pyplot as plt
# # # # # import numpy as np
# # # # # from pdf2image import convert_from_path
# # # #
# # # # pdf_path = r"G:\IT\Network Port Layout\BWS\Parts Room v0.pdf"
# # # #
# # # # if __name__ == "__main__":
# # # #
# # # # 	# known_distance_ft = 12  # set this to your known real-world distance
# # # # 	#
# # # # 	# page = convert_from_path(pdf_path, dpi=300, first_page=1, last_page=1)[0]
# # # # 	# img = np.array(page)
# # # # 	#
# # # # 	# fig, ax = plt.subplots(figsize=(12, 8))
# # # # 	# ax.imshow(img)
# # # # 	# ax.set_title("Click TWO points that are a known real-world distance apart")
# # # # 	# pts = plt.ginput(2, timeout=0)  # click two points
# # # # 	# plt.close(fig)
# # # # 	#
# # # # 	# (x1, y1), (x2, y2) = pts
# # # # 	# dist_px = ((x2-x1)**2 + (y2-y1)**2) ** 0.5
# # # # 	# px_per_ft = dist_px / known_distance_ft
# # # # 	# grid_ft = 1.0  # 1-foot grid
# # # # 	# grid_px = px_per_ft * grid_ft
# # # # 	#
# # # # 	# h, w = img.shape[0], img.shape[1]
# # # # 	# fig, ax = plt.subplots(figsize=(12, 8))
# # # # 	# ax.imshow(img)
# # # # 	# ax.set_xlim(0, w)
# # # # 	# ax.set_ylim(h, 0)
# # # # 	#
# # # # 	# ax.set_xticks(np.arange(0, w+1, grid_px))
# # # # 	# ax.set_yticks(np.arange(0, h+1, grid_px))
# # # # 	# ax.grid(True)
# # # # 	# ax.set_title(f"Grid overlay (~{grid_ft} ft per square)")
# # # # 	#
# # # # 	# plt.tight_layout()
# # # # 	# plt.savefig("warehouse_grid_calibrated.png", dpi=300)
# # # # 	# plt.show()
# # # #
# # # # 	from PIL import Image
# # # #
# # # # 	img = Image.open(img_path)
# # # # 	img.rotate(0.6, expand=True, fillcolor="white").save("warehouse_sketch_deskew.png")
# # # #
# # # # 	import math
# # # # 	import json
# # # # 	import numpy as np
# # # # 	import matplotlib.pyplot as plt
# # # # 	import matplotlib.image as mpimg
# # # #
# # # # 	# Known distance between two clicked points (you choose what segment to click)
# # # # 	KNOWN_DISTANCE_FT = 10.0  # change this to match the real segment you click
# # # #
# # # # 	img = mpimg.imread(img_path)
# # # #
# # # # 	fig, ax = plt.subplots(figsize=(14, 9))
# # # # 	ax.imshow(img)
# # # # 	ax.set_title(
# # # # 		"Click 1) ORIGIN (0,0), then 2) point A, 3) point B (known distance).",
# # # # 		fontsize=12
# # # # 	)
# # # #
# # # # 	clicks = []
# # # #
# # # #
# # # # 	def onclick(event):
# # # # 		if event.xdata is None or event.ydata is None:
# # # # 			return
# # # # 		clicks.append((float(event.xdata), float(event.ydata)))
# # # # 		ax.plot(event.xdata, event.ydata, "ro")
# # # # 		ax.text(event.xdata + 5, event.ydata + 5, f"{len(clicks)}", color="red", fontsize=12)
# # # # 		fig.canvas.draw()
# # # #
# # # # 		if len(clicks) == 3:
# # # # 			fig.canvas.mpl_disconnect(cid)
# # # # 			origin = clicks[0]
# # # # 			a = clicks[1]
# # # # 			b = clicks[2]
# # # #
# # # # 			dist_px = math.dist(a, b)
# # # # 			px_per_ft = dist_px / KNOWN_DISTANCE_FT
# # # #
# # # # 			print("\n--- Calibration Results ---")
# # # # 			print(f"Origin (px): {origin}")
# # # # 			print(f"Point A (px): {a}")
# # # # 			print(f"Point B (px): {b}")
# # # # 			print(f"Distance A-B: {dist_px:.2f} px = {KNOWN_DISTANCE_FT} ft")
# # # # 			print(f"Pixels per foot: {px_per_ft:.4f} px/ft")
# # # # 			print(f"Feet per pixel: {1 / px_per_ft:.6f} ft/px")
# # # #
# # # # 			# Save calibration for next steps
# # # # 			calib = {
# # # # 				"image_path": img_path,
# # # # 				"origin_px": {"x": origin[0], "y": origin[1]},
# # # # 				"px_per_ft": px_per_ft,
# # # # 				"known_distance_ft": KNOWN_DISTANCE_FT,
# # # # 				"a_px": {"x": a[0], "y": a[1]},
# # # # 				"b_px": {"x": b[0], "y": b[1]},
# # # # 			}
# # # # 			with open("calibration.json", "w") as f:
# # # # 				json.dump(calib, f, indent=2)
# # # #
# # # # 			ax.set_title("Calibration saved to calibration.json. Close this window.", fontsize=12)
# # # #
# # # #
# # # # 	cid = fig.canvas.mpl_connect("button_press_event", onclick)
# # # # 	plt.show()
# # # #
# # # # 	import json
# # # # 	import numpy as np
# # # # 	import matplotlib.pyplot as plt
# # # # 	import matplotlib.image as mpimg
# # # #
# # # # 	with open("calibration.json", "r") as f:
# # # # 		calib = json.load(f)
# # # #
# # # # 	img = mpimg.imread(calib["image_path"])
# # # # 	origin_x = calib["origin_px"]["x"]
# # # # 	origin_y = calib["origin_px"]["y"]
# # # # 	px_per_ft = calib["px_per_ft"]
# # # #
# # # # 	GRID_FT = 2.0  # 2-foot grid
# # # #
# # # # 	grid_px = GRID_FT * px_per_ft
# # # #
# # # # 	fig, ax = plt.subplots(figsize=(14, 9))
# # # # 	ax.imshow(img)
# # # #
# # # # 	# Draw grid lines aligned to your chosen origin
# # # # 	w = img.shape[1]
# # # # 	h = img.shape[0]
# # # #
# # # # 	# vertical lines
# # # # 	x0 = origin_x
# # # # 	for x in np.arange(x0, w, grid_px):
# # # # 		ax.axvline(x, linewidth=0.5, linestyle="--")
# # # # 	for x in np.arange(x0, 0, -grid_px):
# # # # 		ax.axvline(x, linewidth=0.5, linestyle="--")
# # # #
# # # # 	# horizontal lines
# # # # 	y0 = origin_y
# # # # 	for y in np.arange(y0, h, grid_px):
# # # # 		ax.axhline(y, linewidth=0.5, linestyle="--")
# # # # 	for y in np.arange(y0, 0, -grid_px):
# # # # 		ax.axhline(y, linewidth=0.5, linestyle="--")
# # # #
# # # # 	ax.plot(origin_x, origin_y, "ro")
# # # # 	ax.text(origin_x + 5, origin_y + 5, "ORIGIN (0,0)", color="red")
# # # #
# # # # 	ax.set_title(f"Grid overlay: {GRID_FT} ft spacing")
# # # # 	ax.set_xticks([])
# # # # 	ax.set_yticks([])
# # # #
# # # # 	plt.tight_layout()
# # # # 	plt.savefig("warehouse_with_grid.png", dpi=200)
# # # # 	plt.show()
# # # #
# # # # 	import json
# # # # 	import matplotlib.pyplot as plt
# # # # 	import matplotlib.image as mpimg
# # # #
# # # # 	with open("calibration.json", "r") as f:
# # # # 		calib = json.load(f)
# # # #
# # # # 	img = mpimg.imread(calib["image_path"])
# # # # 	origin_x = calib["origin_px"]["x"]
# # # # 	origin_y = calib["origin_px"]["y"]
# # # # 	px_per_ft = calib["px_per_ft"]
# # # #
# # # # 	bins = []
# # # #
# # # # 	fig, ax = plt.subplots(figsize=(14, 9))
# # # # 	ax.imshow(img)
# # # # 	ax.set_title("Click a bin location; after each click, type the bin ID in the console.")
# # # # 	ax.set_xticks([])
# # # # 	ax.set_yticks([])
# # # #
# # # #
# # # # 	def px_to_ft(x_px, y_px):
# # # # 		# convert pixel to warehouse feet coords with origin and y-flip
# # # # 		x_ft = (x_px - origin_x) / px_per_ft
# # # # 		y_ft = (origin_y - y_px) / px_per_ft  # flipped
# # # # 		return x_ft, y_ft
# # # #
# # # #
# # # # 	def onclick(event):
# # # # 		if event.xdata is None or event.ydata is None:
# # # # 			return
# # # # 		x_px, y_px = float(event.xdata), float(event.ydata)
# # # #
# # # # 		bin_id = input("Enter bin ID (or blank to cancel this point): ").strip()
# # # # 		if not bin_id:
# # # # 			print("Skipped.")
# # # # 			return
# # # #
# # # # 		x_ft, y_ft = px_to_ft(x_px, y_px)
# # # # 		bins.append({"bin": bin_id, "x_ft": x_ft, "y_ft": y_ft, "x_px": x_px, "y_px": y_px})
# # # #
# # # # 		ax.plot(x_px, y_px, "ro")
# # # # 		ax.text(x_px + 5, y_px + 5, bin_id, fontsize=9)
# # # # 		fig.canvas.draw()
# # # #
# # # # 		with open("bins.json", "w") as f:
# # # # 			json.dump(bins, f, indent=2)
# # # #
# # # # 		print(f"Saved {len(bins)} bins to bins.json")
# # # #
# # # #
# # # # 	cid = fig.canvas.mpl_connect("button_press_event", onclick)
# # # # 	plt.show()
# # # #
# # # #
# # #
# # #
# # #
# # # if __name__ == "__main__":
# # # 	import matplotlib.pyplot as plt
# # # 	import matplotlib.image as mpimg
# # # 	from matplotlib.ticker import MultipleLocator
# # #
# # # 	# Your desired logical grid size
# # # 	N_COLS = 75  # x direction
# # # 	N_ROWS = 100  # y direction
# # #
# # # 	# Grid styling
# # # 	MAJOR_EVERY = 10  # bold grid line every 10
# # # 	MINOR_EVERY = 1  # light grid line every 1  (try 5 if too dense)
# # #
# # # 	img = mpimg.imread(img_path)
# # #
# # # 	fig, ax = plt.subplots(figsize=(10, 8))
# # #
# # # 	# Put image in "warehouse grid coordinates"
# # # 	# extent: left, right, bottom, top
# # # 	ax.imshow(img, extent=(0, N_COLS, 0, N_ROWS), origin="upper")
# # #
# # # 	# Major / minor tick locators
# # # 	ax.xaxis.set_major_locator(MultipleLocator(MAJOR_EVERY))
# # # 	ax.yaxis.set_major_locator(MultipleLocator(MAJOR_EVERY))
# # # 	ax.xaxis.set_minor_locator(MultipleLocator(MINOR_EVERY))
# # # 	ax.yaxis.set_minor_locator(MultipleLocator(MINOR_EVERY))
# # #
# # # 	# Draw grids
# # # 	ax.grid(which="major", linewidth=1.2)  # major lines thicker
# # # 	ax.grid(which="minor", linewidth=0.4)  # minor lines thinner
# # #
# # # 	# Limits and labels
# # # 	ax.set_xlim(0, N_COLS)
# # # 	ax.set_ylim(0, N_ROWS)
# # # 	ax.set_xlabel("Column")
# # # 	ax.set_ylabel("Row")
# # # 	ax.set_title("Warehouse Sketch + Logical Grid Overlay")
# # #
# # # 	plt.tight_layout()
# # # 	plt.savefig("warehouse_grid_overlay.png", dpi=200)
# # # 	plt.show()
# #
# #
# # import pandas as pd
# # from streamlit_utility import *
# #
# #
# # @st.cache_data(ttl=60*60, show_spinner=True)
# # def load_layout_data() ->  dict[str: pd.DataFrame]:
# # 	return pd.read_excel(pth_layout, ["Layout", "Legend"])
# #
# #
# # if __name__ == "__main__":
# #
# # 	st.set_page_config(layout="wide")
# #
# # 	pth_layout: str = r"G:\IT\Network Port Layout\BWS\Hawkins Warehouse Layout Rev3 202601050840.xlsx"
# # 	df_data = load_layout_data()
# # 	df_layout = df_data["Layout"]
# # 	df_legend = df_data["Legend"]
# #
# # 	k_stdf_parsed_legend: str = "key_stdf_parsed_legend"
# # 	display_df_paginated(
# # 		df=df_legend,
# # 		title="Legend Data",
# # 		key=k_stdf_parsed_legend
# # 	)
# #
# # 	k_stdf_parsed_layout: str = "key_stdf_parsed_layout"
# # 	display_df_paginated(
# # 		df=df_layout,
# # 		title="Layout Data",
# # 		key=k_stdf_parsed_layout
# # 	)
#
#
# import os
# import numpy as np
# import pandas as pd
# import .streamlit as st
# import matplotlib.pyplot as plt
# from matplotlib.ticker import MultipleLocator
# from openpyxl import load_workbook
# from openpyxl.styles.colors import COLOR_INDEX
#
# from streamlit_utility import *
#
#
# # -----------------------------
# # Color helpers (openpyxl)
# # -----------------------------
#
# def _normalize_hex_rgb(argb: str) -> str | None:
#     if not argb:
#         return None
#     s = str(argb).strip()
#     if len(s) == 8:  # ARGB
#         return "#" + s[2:].upper()
#     if len(s) == 6:
#         return "#" + s.upper()
#     return None
#
# def _openpyxl_color_to_hex(color) -> str | None:
#     """Best effort: works reliably when fills are explicit RGB (not theme)."""
#     if color is None:
#         return None
#
#     ctype = getattr(color, "type", None)
#
#     if ctype == "rgb":
#         return _normalize_hex_rgb(color.rgb)
#
#     if ctype == "indexed":
#         idx = getattr(color, "indexed", None)
#         if idx is None:
#             return None
#         try:
#             v = COLOR_INDEX[idx]
#             # v sometimes like 'FFRRGGBB' or '0xFFRRGGBB'
#             v = str(v).replace("0x", "").upper()
#             return _normalize_hex_rgb(v)
#         except Exception:
#             return None
#
#     # theme colors are harder; recommend setting explicit RGB fills in Excel
#     return None
#
# def _cell_fill_hex(ws, row: int, col: int) -> str | None:
#     cell = ws.cell(row=row, column=col)
#     fill = getattr(cell, "fill", None)
#     if fill is None:
#         return None
#     fg = getattr(fill, "fgColor", None)
#     return _openpyxl_color_to_hex(fg)
#
# def _hex_to_rgb01(hex_color: str) -> tuple[float, float, float]:
#     h = hex_color.lstrip("#")
#     return (int(h[0:2], 16) / 255.0, int(h[2:4], 16) / 255.0, int(h[4:6], 16) / 255.0)
#
# def _is_blank(hex_color: str | None) -> bool:
#     # openpyxl "no fill" often returns None; white sometimes '#FFFFFF'
#     if hex_color is None:
#         return True
#     return hex_color.upper() == "#FFFFFF"
#
#
# # -----------------------------
# # Data loading
# # -----------------------------
#
# @st.cache_data(ttl=60*60, show_spinner=True)
# def load_layout_data_excel_values(pth_layout: str) -> dict[str, pd.DataFrame]:
#     # Values only (your existing workflow)
#     return pd.read_excel(pth_layout, sheet_name=["Layout", "Legend"])
#
# @st.cache_data(ttl=60*60, show_spinner=True)
# def load_layout_cell_fills(
#     pth_layout: str,
#     layout_sheet: str = "Layout",
#     force_rows: int | None = None,
#     force_cols: int | None = None,
#     scan_max_rows: int = 500,
#     scan_max_cols: int = 500
# ) -> pd.DataFrame:
#     """
#     Returns a DataFrame of same shape as layout grid:
#     rows = Excel row numbers (1-based), cols = Excel column letters (A, B, C...),
#     values = fill hex color '#RRGGBB' or None.
#     """
#     wb = load_workbook(pth_layout, data_only=True)
#     ws = wb[layout_sheet]
#
#     # Determine bounds
#     if force_rows and force_cols:
#         nrows, ncols = force_rows, force_cols
#     else:
#         # detect by scanning for non-blank fills
#         max_r, max_c = 1, 1
#         for r in range(1, scan_max_rows + 1):
#             for c in range(1, scan_max_cols + 1):
#                 hx = _cell_fill_hex(ws, r, c)
#                 if hx and not _is_blank(hx):
#                     if r > max_r: max_r = r
#                     if c > max_c: max_c = c
#         nrows, ncols = max_r, max_c
#
#     # Build
#     col_labels = []
#     # Excel column letters
#     def int_to_excel_col(n: int) -> str:
#         out = []
#         while n > 0:
#             n, r = divmod(n - 1, 26)
#             out.append(chr(r + ord("A")))
#         return "".join(reversed(out))
#
#     col_labels = [int_to_excel_col(c) for c in range(1, ncols + 1)]
#     data = np.empty((nrows, ncols), dtype=object)
#
#     for r in range(1, nrows + 1):
#         for c in range(1, ncols + 1):
#             data[r - 1, c - 1] = _cell_fill_hex(ws, r, c)
#
#     df_fills = pd.DataFrame(data, index=np.arange(1, nrows + 1), columns=col_labels)
#     return df_fills
#
#
# # -----------------------------
# # Rendering
# # -----------------------------
#
# def render_fill_grid_matplotlib(
#     df_fills: pd.DataFrame,
#     major_every: int = 10,
#     minor_every: int = 1,
#     show_labels: bool = True
# ):
#     """
#     df_fills: index = Excel row numbers (1-based), columns = Excel col letters
#     """
#     nrows, ncols = df_fills.shape
#
#     # Build RGB image (default white)
#     img = np.ones((nrows, ncols, 3), dtype=float)
#     for r in range(nrows):
#         for c in range(ncols):
#             hx = df_fills.iat[r, c]
#             if hx and not _is_blank(hx):
#                 img[r, c, :] = _hex_to_rgb01(hx)
#
#     fig_w = max(10, ncols / 8)
#     fig_h = max(8, nrows / 10)
#     fig, ax = plt.subplots(figsize=(fig_w, fig_h))
#
#     # origin upper to match Excel row 1 at the top
#     ax.imshow(img, interpolation="nearest", origin="upper")
#
#     # Major/minor gridlines aligned to cell borders:
#     # draw at -0.5, 0.5, 1.5, ...
#     ax.set_xticks(np.arange(-0.5, ncols, major_every), minor=False)
#     ax.set_yticks(np.arange(-0.5, nrows, major_every), minor=False)
#     ax.set_xticks(np.arange(-0.5, ncols, minor_every), minor=True)
#     ax.set_yticks(np.arange(-0.5, nrows, minor_every), minor=True)
#
#     ax.grid(which="major", linewidth=1.2)
#     ax.grid(which="minor", linewidth=0.4)
#
#     if show_labels:
#         # label major ticks at cell indices (not borders)
#         major_x = list(range(0, ncols, major_every))
#         major_y = list(range(0, nrows, major_every))
#         ax.set_xticks(major_x)
#         ax.set_yticks(major_y)
#         ax.set_xticklabels([df_fills.columns[i] for i in major_x])
#         ax.set_yticklabels([str(df_fills.index[i]) for i in major_y])
#     else:
#         ax.set_xticks([])
#         ax.set_yticks([])
#
#     ax.set_xlabel("Excel Column")
#     ax.set_ylabel("Excel Row")
#     ax.set_title(f"Rendered Layout ({ncols} cols x {nrows} rows)")
#
#     plt.tight_layout()
#     return fig
#
#
# # -----------------------------
# # Streamlit app
# # -----------------------------
#
# if __name__ == "__main__":
#
#     st.set_page_config(layout="wide")
#
#     pth_layout: str = r"G:\IT\Network Port Layout\BWS\Hawkins Warehouse Layout Rev3 202601050840.xlsx"
#
#     df_data = load_layout_data_excel_values(pth_layout)
#     df_layout = df_data["Layout"]
#     df_legend = df_data["Legend"]
#
#     st.header("Warehouse Layout (Excel → Rendered Grid)")
#
#     # Your existing tables
#     c1, c2 = st.columns(2)
#
#     with c1:
#         display_df_paginated(df=df_legend, title="Legend Data", key="key_stdf_parsed_legend")
#     with c2:
#         display_df_paginated(df=df_layout, title="Layout Data (values)", key="key_stdf_parsed_layout")
#
#     st.divider()
#
#     # Controls for rendering
#     with st.sidebar:
#         st.subheader("Render Controls")
#         major_every = st.number_input("Major grid every N cells", min_value=2, max_value=50, value=10, step=1)
#         minor_every = st.number_input("Minor grid every N cells", min_value=1, max_value=25, value=1, step=1)
#         show_labels = st.checkbox("Show major tick labels", value=True)
#
#         st.subheader("Grid Size")
#         mode = st.radio("Bounds", ["Auto-detect by filled cells", "Force rows/cols"], index=0)
#
#         force_rows = None
#         force_cols = None
#         if mode == "Force rows/cols":
#             force_rows = st.number_input("Rows", min_value=10, max_value=500, value=100, step=5)
#             force_cols = st.number_input("Cols", min_value=10, max_value=500, value=75, step=5)
#
#     # Load fills (cached)
#     df_fills = load_layout_cell_fills(
#         pth_layout=pth_layout,
#         layout_sheet="Layout",
#         force_rows=int(force_rows) if force_rows else None,
#         force_cols=int(force_cols) if force_cols else None,
#     )
#
#     # Optional: show fills table (usually huge, so keep behind expander)
#     with st.expander("Show raw fill grid (hex colors)"):
#         display_df_paginated(df=df_fills, title="Layout Fill Colors", key="key_stdf_fill_grid")
#
#     # Render figure
#     fig = render_fill_grid_matplotlib(
#         df_fills=df_fills,
#         major_every=int(major_every),
#         minor_every=int(minor_every),
#         show_labels=show_labels
#     )
#
#     st.pyplot(fig, clear_figure=True)

from __future__ import annotations

import numpy as np
import pandas as pd
import streamlit as st
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import plotly.express as px
from streamlit_plotly_events import plotly_events

from streamlit_utility import *


def _norm_hex(h: str | None) -> str | None:
	if h is None:
		return None
	s = str(h).strip()
	if not s:
		return None
	if not s.startswith("#"):
		s = "#" + s
	if len(s) != 7:
		return None
	return s.upper()


def _hex_to_rgb01(hex_color: str) -> tuple[float, float, float]:
	h = hex_color.lstrip("#")
	return (int(h[0:2], 16) / 255.0, int(h[2:4], 16) / 255.0, int(h[4:6], 16) / 255.0)


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_layout_data(pth_layout: str) -> dict[str, pd.DataFrame]:
	return pd.read_excel(pth_layout, sheet_name=["Layout", "Legend", "Shelves", "ShelfSections"])


def build_legend_maps(df_legend: pd.DataFrame) -> tuple[dict[str, str], dict[str, str]]:
	"""
	Returns:
	  bg_map: key -> '#RRGGBB'
	  fg_map: key -> '#RRGGBB'
	Expects columns: Key, BG, FG (case-insensitive)
	"""
	cols = {c.lower(): c for c in df_legend.columns}
	k_col = cols.get("key")
	bg_col = cols.get("bg")
	fg_col = cols.get("fg")

	if not (k_col and bg_col):
		raise ValueError("Legend sheet must contain at least columns: Key, BG (and optionally FG).")

	bg_map: dict[str, str] = {}
	fg_map: dict[str, str] = {}

	for _, row in df_legend.iterrows():
		k = row.get(k_col)
		if pd.isna(k):
			continue
		key = str(k).strip().upper()
		if not key:
			continue

		bg = _norm_hex(row.get(bg_col))
		if bg:
			bg_map[key] = bg

		if fg_col:
			fg = _norm_hex(row.get(fg_col))
			if fg:
				fg_map[key] = fg

	return bg_map, fg_map


def render_layout_keys(
		df_layout: pd.DataFrame,
		bg_map: dict[str, str],
		*,
		default_bg: str = "#FFFFFF",
		major_every: int = 10,
		minor_every: int = 1,
		show_labels: bool = True,
		annotate_keys: bool = False,
) -> plt.Figure:
	"""
	df_layout should be a grid of keys. Any key not found in bg_map uses default_bg.
	"""
	nrows, ncols = df_layout.shape

	# Build RGB image from BG colors
	default_rgb = _hex_to_rgb01(_norm_hex(default_bg) or "#FFFFFF")
	img = np.zeros((nrows, ncols, 3), dtype=float)
	img[:, :, :] = default_rgb

	# Fill mapped colors
	for r in range(nrows):
		for c in range(ncols):
			v = df_layout.iat[r, c]
			if pd.isna(v):
				continue
			key = str(v).strip().upper()
			if not key:
				continue
			hx = bg_map.get(key)
			if hx:
				img[r, c, :] = _hex_to_rgb01(hx)

	# Figure size heuristic
	fig_w = max(10, ncols / 8)
	fig_h = max(8, nrows / 10)
	fig, ax = plt.subplots(figsize=(fig_w, fig_h))

	# origin='upper' matches Excel row 1 at top
	ax.imshow(img, interpolation="nearest", origin="upper")

	# Grid lines at cell borders: -0.5, 0.5, 1.5, ...
	ax.set_xticks(np.arange(-0.5, ncols, major_every), minor=False)
	ax.set_yticks(np.arange(-0.5, nrows, major_every), minor=False)
	ax.set_xticks(np.arange(-0.5, ncols, minor_every), minor=True)
	ax.set_yticks(np.arange(-0.5, nrows, minor_every), minor=True)

	ax.grid(which="major", linewidth=1.2)
	ax.grid(which="minor", linewidth=0.4)

	if show_labels:
		# Major tick labels (use df columns/index if they exist, else numbers)
		major_x = list(range(0, ncols, major_every))
		major_y = list(range(0, nrows, major_every))
		ax.set_xticks(major_x)
		ax.set_yticks(major_y)

		xlabels = [str(df_layout.columns[i]) for i in major_x] if df_layout.columns is not None else [str(i) for i in
																									  major_x]
		ylabels = [str(df_layout.index[i]) for i in major_y] if df_layout.index is not None else [str(i) for i in
																								  major_y]

		ax.set_xticklabels(xlabels, rotation=0)
		ax.set_yticklabels(ylabels)
	else:
		ax.set_xticks([])
		ax.set_yticks([])

	# Optional: annotate keys into each cell (can get very busy)
	if annotate_keys:
		for r in range(nrows):
			for c in range(ncols):
				v = df_layout.iat[r, c]
				if pd.isna(v):
					continue
				key = str(v).strip()
				if not key:
					continue
				ax.text(c, r, key, ha="center", va="center", fontsize=6)

	ax.set_xlabel("Column")
	ax.set_ylabel("Row")
	ax.set_title(f"Layout render ({ncols} cols x {nrows} rows)")

	plt.tight_layout()
	return fig


def overlay_shelf_sections(
	ax,
	df_sections: pd.DataFrame,
	bg_map: dict[str, str],
	*,
	alpha: float = 0.25,
	show_labels: bool = True,
):
	"""
	Draw rectangular shelf-section overlays on an existing matplotlib Axes.

	Expected df_sections columns:
	  Section, Group, X0, X1, Y0, Y1
	"""

	required = {"Section", "Group", "X0", "X1", "Y0", "Y1"}
	missing = required - set(df_sections.columns)
	if missing:
		raise ValueError(f"ShelfSections missing columns: {missing}")

	for _, row in df_sections.iterrows():
		section = str(row["Section"]).strip().upper()
		group = row["Group"]

		try:
			x0 = float(row["X0"])
			x1 = float(row["X1"])
			y0 = float(row["Y0"])
			y1 = float(row["Y1"])
		except Exception:
			continue

		width = x1 - x0
		height = y1 - y0

		# Section color (fallback if missing)
		hex_color = Colour(bg_map.get(section, "#000000")).inverse().hex_code

		rect = Rectangle(
			(x0 - 0.5, y0 - 0.5),   # align to grid cell edges
			width,
			height,
			linewidth=2,
			edgecolor=hex_color,
			facecolor=hex_color,
			alpha=alpha,
		)
		ax.add_patch(rect)

		if show_labels:
			label = f"{section}-{group}"
			ax.text(
				x0 + width / 2 - 0.5,
				y0 + height / 2 - 0.5,
				label,
				ha="center",
				va="center",
				fontsize=8,
				weight="bold",
				color="black",
			)


@st.cache_data(ttl=60*60, show_spinner=True)
def load_layout_data(pth_layout: str) -> dict[str, pd.DataFrame]:
	return pd.read_excel(
		pth_layout,
		sheet_name=["Layout", "Legend", "ShelfSections", "Shelves"]
	)


def find_section_at_point(df_sections: pd.DataFrame, x: float, y: float) -> pd.Series | None:
	hits = df_sections[
		(df_sections["X0"] <= x) & (x < df_sections["X1"]) &
		(df_sections["Y0"] <= y) & (y < df_sections["Y1"])
	]
	if hits.empty:
		return None
	# If overlaps exist, pick the smallest area match
	hits = hits.copy()
	hits["Area"] = (hits["X1"] - hits["X0"]) * (hits["Y1"] - hits["Y0"])
	hits = hits.sort_values(["Area", "ID"])
	return hits.iloc[0]


def layout_to_rgb_image(df_layout: pd.DataFrame, bg_map: dict[str, str], default_bg="#FFFFFF") -> np.ndarray:
	def norm_hex(h):
		s = str(h).strip()
		if not s.startswith("#"):
			s = "#" + s
		return s.upper()

	def hex_to_rgb01(hx):
		h = hx.lstrip("#")
		return np.array([int(h[0:2],16), int(h[2:4],16), int(h[4:6],16)], dtype=np.uint8)

	default_rgb = hex_to_rgb01(norm_hex(default_bg))

	nrows, ncols = df_layout.shape
	img = np.zeros((nrows, ncols, 3), dtype=np.uint8)
	img[:] = default_rgb

	vals = df_layout.to_numpy()
	for r in range(nrows):
		for c in range(ncols):
			v = vals[r, c]
			if v is None or (isinstance(v, float) and np.isnan(v)):
				continue
			key = str(v).strip().upper()
			if not key:
				continue
			hx = bg_map.get(key)
			if hx:
				img[r, c, :] = hex_to_rgb01(hx)

	return img


def build_plotly_map(
	img: np.ndarray,
	df_sections: pd.DataFrame,
	bg_map: dict[str, str],
	*,
	rotation_deg: int = 0,
	show_sections: bool = True,
	title: str = "Warehouse layout (click a section)",
):
	"""
	Render the warehouse layout image with optional shelf-section overlays.

	Parameters
	----------
	img : np.ndarray
		RGB image already rotated for display (H x W x 3)
	df_sections : pd.DataFrame
		ShelfSections dataframe. Must contain:
			- original columns: X0, X1, Y0, Y1
			- rotated columns:  X0r, X1r, Y0r, Y1r (when rotation != 0)
	bg_map : dict[str, str]
		Section letter -> '#RRGGBB'
	rotation_deg : int
		0, 90, 180, 270
	show_sections : bool
		Whether to draw section overlays
	title : str
		Plot title
	"""

	# --- base image ---
	fig = px.imshow(img, origin="upper")
	fig.update_layout(
		margin=dict(l=0, r=0, t=40, b=0),
		dragmode="pan",
		title=title,
	)

	fig.update_xaxes(title="Col", showgrid=True, zeroline=False)
	fig.update_yaxes(title="Row", showgrid=True, zeroline=False)

	if not show_sections or df_sections is None or df_sections.empty:
		return fig

	# --- choose which bounds to use ---
	use_rot = rotation_deg % 360 != 0
	x0c = "X0r" if use_rot else "X0"
	x1c = "X1r" if use_rot else "X1"
	y0c = "Y0r" if use_rot else "Y0"
	y1c = "Y1r" if use_rot else "Y1"

	missing = {x0c, x1c, y0c, y1c} - set(df_sections.columns)
	if missing:
		raise ValueError(
			f"ShelfSections missing required columns for rotation={rotation_deg}: {missing}"
		)

	# --- draw section rectangles ---
	for _, row in df_sections.iterrows():
		sec = str(row["Section"]).strip().upper()
		grp = row.get("Group", "")
		color = bg_map.get(sec, "#000000")

		try:
			x0 = float(row[x0c])
			x1 = float(row[x1c])
			y0 = float(row[y0c])
			y1 = float(row[y1c])
		except Exception:
			continue

		fig.add_shape(
			type="rect",
			x0=x0 - 0.5,
			x1=x1 - 0.5,
			y0=y0 - 0.5,
			y1=y1 - 0.5,
			line=dict(width=2, color=color),
			fillcolor=color,
			opacity=0.20,
			layer="above",
		)

		fig.add_annotation(
			x=(x0 + x1) / 2 - 0.5,
			y=(y0 + y1) / 2 - 0.5,
			text=f"{sec}-{grp}",
			showarrow=False,
			font=dict(size=10, color="black"),
		)

	return fig


def build_legend_bg_map(df_legend: pd.DataFrame) -> dict[str, str]:
	cols = {c.lower(): c for c in df_legend.columns}
	k_col = cols.get("key")
	bg_col = cols.get("bg")
	if not (k_col and bg_col):
		raise ValueError("Legend must contain columns Key and BG")

	bg_map = {}
	for _, r in df_legend.iterrows():
		k = r.get(k_col)
		bg = r.get(bg_col)
		if pd.isna(k) or pd.isna(bg):
			continue
		key = str(k).strip().upper()
		hx = str(bg).strip().upper()
		if not hx.startswith("#"):
			hx = "#" + hx
		if len(hx) == 7:
			bg_map[key] = hx
	return bg_map


def rotate_img(img: np.ndarray, rotation_deg: int) -> np.ndarray:
	rotation_deg = rotation_deg % 360
	if rotation_deg == 0:
		return img
	if rotation_deg == 90:   # clockwise
		return np.rot90(img, k=3)
	if rotation_deg == 180:
		return np.rot90(img, k=2)
	if rotation_deg == 270:  # counter-clockwise
		return np.rot90(img, k=1)
	raise ValueError("rotation_deg must be one of: 0, 90, 180, 270")


def rot_point_xy(x: float, y: float, W: int, H: int, rotation_deg: int) -> tuple[float, float]:
	r = rotation_deg % 360
	if r == 0:
		return x, y
	if r == 90:   # cw
		return (H - 1 - y), x
	if r == 180:
		return (W - 1 - x), (H - 1 - y)
	if r == 270:  # ccw
		return y, (W - 1 - x)
	raise ValueError("rotation_deg must be 0/90/180/270")


def inv_rot_point_xy(xr: float, yr: float, W: int, H: int, rotation_deg: int) -> tuple[float, float]:
	r = rotation_deg % 360
	if r == 0:
		return xr, yr
	if r == 90:   # inverse of cw is ccw
		return yr, (H - 1 - xr)
	if r == 180:
		return (W - 1 - xr), (H - 1 - yr)
	if r == 270:  # inverse of ccw is cw
		return (W - 1 - yr), xr
	raise ValueError("rotation_deg must be 0/90/180/270")


def rot_rect(df_sections: pd.DataFrame, W: int, H: int, rotation_deg: int) -> pd.DataFrame:
	"""
	Returns a copy of df_sections with rotated X0/X1/Y0/Y1 for plotting.
	Assumes df_sections uses X0<X1, Y0<Y1 in original coords.
	"""
	df = df_sections.copy()

	xs0, ys0 = [], []
	xs1, ys1 = [], []

	for _, row in df.iterrows():
		x0, x1, y0, y1 = float(row["X0"]), float(row["X1"]), float(row["Y0"]), float(row["Y1"])

		# transform the 4 corners and compute new bounds
		corners = [
			(x0, y0),
			(x0, y1),
			(x1, y0),
			(x1, y1),
		]
		rot_c = [rot_point_xy(x, y, W=W, H=H, rotation_deg=rotation_deg) for x, y in corners]
		xs = [p[0] for p in rot_c]
		ys = [p[1] for p in rot_c]

		xs0.append(min(xs))
		xs1.append(max(xs))
		ys0.append(min(ys))
		ys1.append(max(ys))

	df["X0r"] = xs0
	df["X1r"] = xs1
	df["Y0r"] = ys0
	df["Y1r"] = ys1
	return df



if __name__ == "__main__":

	st.set_page_config(layout="wide")

	pth_layout: str = r"G:\IT\Network Port Layout\BWS\Hawkins Warehouse Layout Rev3 202601050840.xlsx"

	df_data = load_layout_data(pth_layout)
	df_layout = df_data["Layout"]
	df_legend = df_data["Legend"]
	df_shelves = df_data["Shelves"]
	df_sections = df_data["ShelfSections"]
	df_layout.rename(columns={col: f"{i}" for i, col in enumerate(df_layout.columns)}, inplace=True)
	st.header("Warehouse Layout Renderer (Legend-driven colors)")

	# Show raw legend/layout tables as you already do
	c1, c2 = st.columns(2)
	with c1:
		display_df_paginated(df=df_legend, title="Legend Data", key="key_stdf_parsed_legend")
		display_df_paginated(df=df_shelves, title="Shelves Data", key="key_stdf_parsed_shelves")
	with c2:
		display_df_paginated(df=df_layout, title="Layout Data (keys)", key="key_stdf_parsed_layout")
		display_df_paginated(df=df_sections, title="Sections", key="key_stdf_parsed_sections")

	# Build maps
	try:
		bg_map, fg_map = build_legend_maps(df_legend)
	except Exception as e:
		st.error(str(e))
		st.stop()

	with st.sidebar:
		st.subheader("Render Controls")

		show_sections = st.checkbox("Show shelf sections", value=True)
		section_alpha = st.slider(
			"Section overlay opacity",
			min_value=0.05,
			max_value=0.6,
			value=0.25,
			step=0.05,
		)
		show_section_labels = st.checkbox("Label shelf sections", value=True)

		major_every = st.number_input("Major grid every N cells", min_value=2, max_value=50, value=10, step=1)
		minor_every = st.number_input("Minor grid every N cells", min_value=1, max_value=25, value=1, step=1)
		show_labels = st.checkbox("Show major labels", value=True)
		annotate_keys = st.checkbox("Write key text in cells (busy)", value=False)
		default_bg = st.text_input("Default BG (hex)", value="#FFFFFF")

		st.subheader("Diagnostics")
		show_unknown = st.checkbox("List layout keys missing from legend", value=True)

	# Diagnostics: unknown keys
	if show_unknown:
		layout_keys = set(
			str(v).strip().upper()
			for v in df_layout.to_numpy().ravel()
			if v is not None and not (isinstance(v, float) and np.isnan(v))
		)
		known_keys = set(bg_map.keys())
		unknown = sorted(k for k in layout_keys if k and k not in known_keys)
		if unknown:
			st.warning(f"{len(unknown)} layout keys are missing from Legend[Key].")
			st.write(unknown)
		else:
			st.success("All layout keys are present in the legend mapping.")

	fig = render_layout_keys(
		df_layout=df_layout,
		bg_map=bg_map,
		default_bg=default_bg,
		major_every=int(major_every),
		minor_every=int(minor_every),
		show_labels=show_labels,
		annotate_keys=annotate_keys,
	)

	ax = fig.axes[0]

	if show_sections:
		overlay_shelf_sections(
			ax=ax,
			df_sections=df_sections,
			bg_map=bg_map,
			alpha=section_alpha,
			show_labels=show_section_labels,
		)

	st.pyplot(fig, clear_figure=True)


	# st.set_page_config(layout="wide")
	#
	# pth_layout: str = r"G:\IT\Network Port Layout\BWS\Hawkins Warehouse Layout Rev3 202601050840.xlsx"
	#
	# df_data = load_layout_data(pth_layout)
	# df_layout = df_data["Layout"]
	# df_legend = df_data["Legend"]
	# df_sections = df_data["ShelfSections"]
	# df_shelves = df_data["Shelves"]
	#
	# bg_map = build_legend_bg_map(df_legend)
	#
	# with st.sidebar:
	# 	st.subheader("Map Controls")
	# 	show_sections = st.checkbox("Show section overlays", value=True)
	# 	default_bg = st.text_input("Default BG", value="#FFFFFF")
	# 	st.caption("Tip: click a section rectangle to inspect its shelves.")
	#
	# 	rotation_deg = st.selectbox("Rotation", [0, 90, 180, 270], index=0)
	#
	# # # Build map image + figure
	# img = layout_to_rgb_image(df_layout, bg_map, default_bg=default_bg)
	# fig = build_plotly_map(img, df_sections, bg_map, show_sections=show_sections)
	# # img0 = layout_to_rgb_image(df_layout, bg_map, default_bg=default_bg)
	# # H, W = img0.shape[0], img0.shape[1]
	# #
	# # img = rotate_img(img0, rotation_deg)
	# #
	# # # rotate sections for drawing only
	# # df_sections_plot = rot_rect(df_sections, W=W, H=H, rotation_deg=rotation_deg)
	# #
	# # fig = build_plotly_map(img, df_sections_plot, bg_map, show_sections=show_sections, use_rot_cols=True)
	# # # img0 = layout_to_rgb_image(df_layout, bg_map)
	# # # H, W = img0.shape[:2]
	# # #
	# # # img = rotate_img(img0, rotation_deg)
	# # # df_sections_plot = rot_rect(df_sections, W=W, H=H, rotation_deg=rotation_deg)
	# # # fig = build_plotly_map(
	# # # 	img=img,
	# # # 	df_sections=df_sections_plot,
	# # # 	bg_map=bg_map,
	# # # 	rotation_deg=rotation_deg,
	# # # 	show_sections=show_sections,
	# # # )
	#
	# # Click capture
	# st.subheader("Interactive Map")
	# clicked = plotly_events(fig, click_event=True, hover_event=False, select_event=False, override_height=800)
	#
	# # Display selection results
	# st.subheader("Selection")
	#
	# if clicked:
	# 	xr = float(clicked[0]["x"])
	# 	yr = float(clicked[0]["y"])
	#
	# 	# convert rotated click back to original coords
	# 	x, y = inv_rot_point_xy(xr, yr, W=W, H=H, rotation_deg=rotation_deg)
	# 	st.write({"clicked_col_x": x, "clicked_row_y": y})
	#
	# 	sec_row = find_section_at_point(df_sections, x=x, y=y)  # NOTE: original df_sections
	# 	if sec_row is None:
	# 		st.info("No ShelfSection contains that point.")
	# 	else:
	# 		sec = str(sec_row["Section"]).strip().upper()
	# 		grp = sec_row["Group"]
	# 		sec_id = sec_row.get("ID", None)
	#
	# 		st.success(f"Clicked Section: {sec}, Group: {grp}, ID: {sec_id}")
	#
	# 		# Filter shelves that belong to this section/group
	# 		# Your Shelves sheet columns: Section, ShelSection, Shelf, ShelfRow
	# 		cols = {c.lower(): c for c in df_shelves.columns}
	# 		col_section = cols.get("section")
	# 		col_group = cols.get("shelsection") or cols.get("shelfsection") or cols.get("group")
	#
	# 		if not (col_section and col_group):
	# 			st.warning("Shelves sheet must have columns like: Section and ShelSection (group).")
	# 		else:
	# 			df_hit = df_shelves[
	# 				(df_shelves[col_section].astype(str).str.strip().str.upper() == sec) &
	# 				(df_shelves[col_group] == grp)
	# 				].copy()
	#
	# 			if df_hit.empty:
	# 				st.info("No shelves defined for this section/group yet.")
	# 			else:
	# 				# Optional: sort
	# 				if "ShelfRow" in df_hit.columns:
	# 					df_hit = df_hit.sort_values(["ShelfRow", "Shelf"])
	# 				display_df_paginated(df_hit, title="Shelves in selected section", key="key_shelves_selected")
	#
	# 				# Floor-level highlights
	# 				if "ShelfRow" in df_hit.columns:
	# 					floor = df_hit[df_hit["ShelfRow"] == 0]
	# 					if not floor.empty:
	# 						st.write("Floor-level shelves (ShelfRow == 0):")
	# 						display_df_paginated(floor, title="Floor level", key="key_shelves_floor")
	# else:
	# 	st.info("Click a section overlay to see shelves in that space.")
