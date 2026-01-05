


#timestamp 202601051603


from __future__ import annotations

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import plotly.express as px
from streamlit_plotly_events import plotly_events

from streamlit_utility import *


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

		bg = Colour(row.get(bg_col)).hex_code
		if bg:
			bg_map[key] = bg

		if fg_col:
			fg = Colour((row.get(fg_col))).hex_code
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
	default_rgb = Colour(Colour(default_bg).hex_code or "#FFFFFF").rgb_code
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
				img[r, c, :] = Colour(hx).rgb_code

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


# def overlay_shelf_sections(
# 	ax,
# 	df_sections: pd.DataFrame,
# 	bg_map: dict[str, str],
# 	*,
# 	alpha: float = 0.25,
# 	show_labels: bool = True,
# ):
# 	"""
# 	Draw rectangular shelf-section overlays on an existing matplotlib Axes.
#
# 	Expected df_sections columns:
# 	  Section, Group, X0, X1, Y0, Y1
# 	"""
#
# 	required = {"Section", "Group", "X0", "X1", "Y0", "Y1"}
# 	missing = required - set(df_sections.columns)
# 	if missing:
# 		raise ValueError(f"ShelfSections missing columns: {missing}")
#
# 	for _, row in df_sections.iterrows():
# 		section = str(row["Section"]).strip().upper()
# 		group = row["Group"]
#
# 		try:
# 			x0 = float(row["X0"])
# 			x1 = float(row["X1"])
# 			y0 = float(row["Y0"])
# 			y1 = float(row["Y1"])
# 		except Exception:
# 			continue
#
# 		width = x1 - x0
# 		height = y1 - y0
#
# 		# Section color (fallback if missing)
# 		hex_color = Colour(bg_map.get(section, "#000000")).darkened(0.5).hex_code
#
# 		rect = Rectangle(
# 			(x0 - 0.5, y0 - 0.5),   # align to grid cell edges
# 			width,
# 			height,
# 			linewidth=2,
# 			edgecolor=hex_color,
# 			facecolor=hex_color,
# 			alpha=alpha,
# 		)
# 		ax.add_patch(rect)
#
# 		if show_labels:
# 			label = f"{section}-{group}"
# 			ax.text(
# 				x0 + width / 2 - 0.5,
# 				y0 + height / 2 - 0.5,
# 				label,
# 				ha="center",
# 				va="center",
# 				fontsize=8,
# 				weight="bold",
# 				color="black",
# 			)


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
	default_rgb = Colour(default_bg).rgb_code

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
				img[r, c, :] = Colour(hx).rgb_code

	return img


def build_plotly_map(
	img: np.ndarray,
	df_sections: pd.DataFrame,
	bg_map: dict[str, str],
	*,
	rotation_deg: int = 0,
	show_sections: bool = True,
	selected_section_id: int | None = None,
	title: str = "Warehouse layout (click a section)",
	opacity: float = 0.3
):
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

	use_rot = rotation_deg % 360 != 0
	x0c = "X0r" if use_rot else "X0"
	x1c = "X1r" if use_rot else "X1"
	y0c = "Y0r" if use_rot else "Y0"
	y1c = "Y1r" if use_rot else "Y1"

	missing = {x0c, x1c, y0c, y1c} - set(df_sections.columns)
	if missing:
		raise ValueError(f"ShelfSections missing required columns for rotation={rotation_deg}: {missing}")

	if overlay_section:
		aisle_count = {}
		# --- draw all sections (base layer) ---
		for _, row in df_sections.iterrows():
			sec = str(row["Section"]).strip().upper()
			grp = row.get("Group", "")
			id_ = row.get("ID", "")
			color = bg_map.get(sec, "#000000")
			p_shelf = row.get("ParentShelf", "")

			x0 = float(row[x0c]); x1 = float(row[x1c])
			y0 = float(row[y0c]); y1 = float(row[y1c])

			bx_color = Colour(color).inverted().hex_code
			fig.add_shape(
				type="rect",
				x0=x0 - 0.5, x1=x1 - 0.5,
				y0=y0 - 0.5, y1=y1 - 0.5,
				line=dict(width=2, color=bx_color),
				fillcolor=bx_color,
				opacity=opacity,
				layer="above",
			)

			if not pd.isna(p_shelf):
				txt = f"{p_shelf}-{grp}"
			else:
				txt = f"aisle - {len(aisle_count) + 1}"
				if sec not in aisle_count:
					aisle_count[sec] = 1
			fig.add_annotation(
				x=(x0 + x1) / 2 - 0.5,
				y=(y0 + y1) / 2 - 0.5,
				text=txt,
				showarrow=False,
				font=dict(size=10, color="black"),
			)

	# --- highlight selected section (top layer) ---
	if selected_section_id is not None and "ID" in df_sections.columns:
		sel = df_sections[df_sections["ID"] == selected_section_id]
		if not sel.empty:
			row = sel.iloc[0]
			sec = str(row["Section"]).strip().upper()
			color = bg_map.get(sec, "#000000")

			x0 = float(row[x0c]); x1 = float(row[x1c])
			y0 = float(row[y0c]); y1 = float(row[y1c])

			# 1) glow-ish border (thicker, black)
			fig.add_shape(
				type="rect",
				x0=x0 - 0.5, x1=x1 - 0.5,
				y0=y0 - 0.5, y1=y1 - 0.5,
				line=dict(width=6, color="#000000"),
				fillcolor="rgba(0,0,0,0)",
				opacity=0.9,
				layer="above",
			)

			# 2) inner border (section color)
			fig.add_shape(
				type="rect",
				x0=x0 - 0.5, x1=x1 - 0.5,
				y0=y0 - 0.5, y1=y1 - 0.5,
				line=dict(width=3, color=color),
				fillcolor=color,
				opacity=0.35,  # slightly stronger fill for selected
				layer="above",
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
	st.set_page_config(layout="wide", page_title="Interactive Warehouse")

	if "selected_section_id" not in st.session_state:
		st.session_state["selected_section_id"] = None

	pth_layout: str = r"G:\IT\Network Port Layout\BWS\Hawkins Warehouse Layout Rev3 202601050840.xlsx"

	df_data = load_layout_data(pth_layout)
	df_layout = df_data["Layout"]
	df_legend = df_data["Legend"]
	df_sections = df_data["ShelfSections"]
	df_shelves = df_data["Shelves"]

	bg_map = build_legend_bg_map(df_legend)

	with st.sidebar:
		st.subheader("Map Controls")
		show_sections = st.checkbox("Show section overlays", value=True)
		default_bg = st.text_input("Default BG", value="#FFFFFF")
		st.caption("Tip: click a section rectangle to inspect its shelves.")

		rotation_deg = st.selectbox("Rotation", [0, 90, 180, 270], index=0)

		if st.button("Clear selection"):
			st.session_state["selected_section_id"] = None
			st.rerun()

		overlay_section = st.checkbox("Overlay Sections", value=False)

	img0 = layout_to_rgb_image(df_layout, bg_map)
	H, W = img0.shape[:2]

	img = rotate_img(img0, rotation_deg)
	df_sections_plot = rot_rect(df_sections, W=W, H=H, rotation_deg=rotation_deg)
	fig = build_plotly_map(
		img=img,
		df_sections=df_sections_plot,
		bg_map=bg_map,
		rotation_deg=rotation_deg,
		show_sections=show_sections,
		selected_section_id=st.session_state["selected_section_id"]
	)

	# Click capture
	st.subheader("Interactive Map")
	clicked = plotly_events(fig, click_event=True, hover_event=False, select_event=False, override_height=800)

	# Display selection results
	st.subheader("Selection")

	if clicked:
		xr = float(clicked[0]["x"])
		yr = float(clicked[0]["y"])

		# convert rotated click back to original coords
		x, y = inv_rot_point_xy(xr, yr, W=W, H=H, rotation_deg=rotation_deg)
		st.write({"clicked_col_x": x, "clicked_row_y": y})

		sec_row = find_section_at_point(df_sections, x=x, y=y)  # NOTE: original df_sections

		if sec_row is None:
			st.session_state["selected_section_id"] = None
			st.info("No ShelfSection contains that point.")
		else:
			st.session_state["selected_section_id"] = int(sec_row["ID"])
			sec = str(sec_row["Section"]).strip().upper()
			grp = sec_row["Group"]
			sec_id = sec_row.get("ID", None)

			st.success(f"Clicked Section: {sec}, Group: {grp}, ID: {sec_id}")

			# Filter shelves that belong to this section/group
			# Your Shelves sheet columns: Section, ShelfSection, Shelf, ShelfRow
			cols = {c.lower(): c for c in df_shelves.columns}
			col_section = cols.get("section")
			col_group = cols.get("shelfsectionid")
			st.write(f"{col_section}, {col_group}")
			if not (col_section and col_group):
				st.warning("Shelves sheet must have columns like: Section and ShelfSectionID (group).")
			else:
				df_hit = df_shelves[
					(df_shelves[col_section].astype(str).str.strip().str.upper() == sec) &
					(df_shelves[col_group] == sec_id)
					].copy()

				if df_hit.empty:
					st.info("No shelves defined for this section/group yet.")
				else:
					# Optional: sort
					if "ShelfRow" in df_hit.columns:
						df_hit = df_hit.sort_values(["ShelfRow", "Shelf"])
					display_df_paginated(df_hit, title="Shelves in selected section", key="key_shelves_selected")

					# Floor-level highlights
					if "ShelfRow" in df_hit.columns:
						floor = df_hit[df_hit["ShelfRow"] < 2]
						if not floor.empty:
							st.write("Floor-level shelves (ShelfRow < 2):")
							display_df_paginated(floor, title="Floor level", key="key_shelves_floor")
	else:
		st.info("Click a section overlay to see shelves in that space.")
