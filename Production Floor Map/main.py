from tkinter_utility import *
from PIL import ImageTk,Image
import json



class WorkStation:

	def __init__(self, data: dict):
		self.name = data.get("name", "UNNAMED WORK STATION")
		self.is_cad_station = data.get("is_cad_station", False)
		self.number = data.get("number", None)
		self.row = data.get("row", None)
		self.col = data.get("col", None)
		

class App(tkinter.Tk):

	def __init__(self):
		super().__init__()

		########################
		#  Application title   #
		########################
		self.tv_title_app_full = tkinter.StringVar(self, value="Demo Tkinter App")
		self.tv_title_app_short = tkinter.StringVar(self, value="Demo App")
		self.title(self.tv_title_app_full.get())

		##############################
		#   Application dimensions   #
		##############################
		self.calc_geometry = calc_geometry_tl("zoomed", largest=True, rtype=dict)  # full-screen application
		self.w_p_app, self.h_p_app = 2/3, 4/9
		# self.calc_geometry = calc_geometry_tl(self.w_p_app, self.h_p_app, largest=True, rtype=dict)  # dimensions above
		self.w_app, self.h_app = self.calc_geometry["width"], self.calc_geometry["height"]
		self.w_canvas_map, self.h_canvas_map = self.w_app * 0.75, self.h_app * 0.75
		
		print(f"{self.calc_geometry=}")
		if (geo := self.calc_geometry["geometry"]) == "zoomed":
			self.state(geo)
		else:
			self.geometry(geo)

        #############################
        #   Begin widget creation   #
        #############################
		"""
		self.tv_lbl_demo, self.lbl_demo = label_factory(
			self,
			tv_label="Hello World!",
			kwargs_label={
				"bg": Colour("#CA98A3").hex_code,
				"fg": Colour("#5A090A").hex_code,
				"font": ("Arial", 30, "bold")
			}
		)
		"""
		
		self.json_layout_file = "hawkins_layout_2024_05_29.json"
		with open(self.json_layout_file, "r") as f:
			json_data = json.load(f)
			# self.map_file = "\\\\bwsfp01\\public\\IT\\Resource\\Images\\production_floor_map_2024_05_29_marked.jpg"
			self.map_file = json_data["work_stations"]["settings"]["map_file"]
			self.width_cell = json_data["work_stations"]["settings"]["width_cell"]
			self.height_cell = json_data["work_stations"]["settings"]["height_cell"]
			self.list_stations = [WorkStation(data) for data in json_data["work_stations"]["stations"]]
			
		self.frame_button_bar = tkinter.Frame(self)
		self.frame_ctl_checks = tkinter.Frame(self.frame_button_bar)
		
		self.list_tv_ctl_checks, self.list_ctl_checks = checkbox_factory(
			self.frame_ctl_checks,
			buttons=[
				("Show Grid-Lines", self.update_show_grid_lines),
				("Show Station Markers", self.update_show_station_markers)
			]
		)
		
		ww = checkbox_factory(
			self.frame_ctl_checks,
			buttons=[
				("Show Grid-Lines", self.update_show_grid_lines),
				("Show Station Markers", self.update_show_station_markers)
			],
			rtype=dict
		)
		
		print(f"{ww=}")
		
		self.canvas_map = tkinter.Canvas(
			self,
			width=self.w_canvas_map,
			height=self.h_canvas_map
		)
		self.img_prod_floor_hawkins_map = Image.open(self.map_file)
		self.img_prod_floor_hawkins_map = self.img_prod_floor_hawkins_map.resize(
			(
				int(self.w_canvas_map),
				int(self.h_canvas_map)
			),
			Image.LANCZOS
		)
		self.photo_prod_floor_hawkins_map = ImageTk.PhotoImage(self.img_prod_floor_hawkins_map)
		self.canvas_map.create_image(
			0,
			0,
			anchor=tkinter.NW,
			image=self.photo_prod_floor_hawkins_map
		)
		
		self.colour_dot = Colour("#B0FFCF")
		self.width_dot, self.height_dot = 12, 12
		self.dot = self.canvas_map.create_oval(
			(-2 * self.width_dot) - (self.width_dot / 2),
			(-2 * self.height_dot) - (self.height_dot / 2),
			(-2 * self.width_dot) + (self.width_dot / 2),
			(-2 * self.height_dot) + (self.height_dot / 2),
			fill=self.colour_dot.hex_code
		)
		
		self.width_line_vertical = 2
		self.colour_line_vertical = Colour("#963232")
		self.width_line_horizontal = 2
		self.colour_line_horizontal = Colour("#323296")
		
		self.lines_vertical = list()
		for i in range(0, int(self.w_canvas_map), self.width_cell):
			self.lines_vertical.append(
				self.canvas_map.create_line(
					0 + (i * self.width_cell),
					0,
					0 + (i * self.width_cell),
					self.h_canvas_map,
					fill=self.colour_line_vertical.hex_code,
					width=self.width_line_vertical
				)
			)
		
		self.lines_horizontal = list()
		for i in range(0, int(self.h_canvas_map), self.height_cell):
			self.lines_horizontal.append(
				self.canvas_map.create_line(
					0,
					0 + (i * self.height_cell),
					self.w_canvas_map,
					0 + (i * self.height_cell),
					fill=self.colour_line_horizontal.hex_code,
					width=self.width_line_horizontal
				)
			)
			
		self.n_cols, self.n_rows = len(self.lines_vertical) + 1, len(self.lines_vertical) + 1
		self.curr_col = tkinter.IntVar(self, value=-1)
		self.curr_row = tkinter.IntVar(self, value=-1)

		# self.columnconfigure(0, weight=1)
		self.grid_widgets()
		
		self.n_clicks = tkinter.IntVar(self, value=0)
		self.canvas_map.tag_raise(self.dot)
		self.canvas_map.bind("<Motion>", self.motion_canvas_map)
		self.canvas_map.bind("<Button-1>", self.click_canvas_map)
		
		self.draw_station_squares()

	def grid_widgets(self):
		r, c, rs, cs, ix, iy, x, y, s = grid_keys()
		# self.lbl_demo.grid(**{r: 0, c: 0, s: "nsew"})
		self.frame_button_bar.grid(**{r:0, c:0, s:"nsew"})
		self.frame_ctl_checks.grid(**{r:0, c:0, s:"nsew"})
		for i, btn in enumerate(self.list_ctl_checks):
			btn.grid(**{r: 0, c:i})
		self.canvas_map.grid(**{r:1, c:0, s:"nsew"})
		# self.columnconfigure(0, weight=1)
		
	def get_line_idxs(self, ex, ey):
		return int(ey / (self.height_cell ** 2)), int(ex / (self.width_cell ** 2))
		
	def get_event_lines(self, event):
		ex, ey = event.x, event.y
		idx_h, idx_v = self.get_line_idxs(ex, ey)
		
		lines_h = self.lines_horizontal[idx_h:idx_h + 2]
		lines_v = self.lines_vertical[idx_v:idx_v + 2]
		return lines_h, lines_v
		
	def update_show_grid_lines(self, *args):
		print(f"update_show_grid_lines v={self.list_tv_ctl_checks[0].get()}")
		
	def update_show_station_markers(self, *args):
		print(f"update_show_station_markers v={self.list_tv_ctl_checks[1].get()}")
		
	def draw_station_squares(self):
		for i, station in enumerate(self.list_stations):
			name = station.name
			idx_h = station.row
			idx_v = station.col
			# lines_h = self.lines_horizontal[idx_h:idx_h + 2]
			# lines_v = self.lines_vertical[idx_v:idx_v + 2]
			line_top = self.lines_horizontal[idx_h]
			line_left = self.lines_vertical[idx_v]
			bbox_top = self.canvas_map.bbox(line_top)
			bbox_left = self.canvas_map.bbox(line_left)
			w_line_top = self.width_line_horizontal
			w_line_left = self.width_line_vertical
			
			bbox = (
				bbox_left[0] + w_line_left,
				bbox_top[1] + w_line_top,
				bbox_left[0] + (self.width_cell ** 2) + w_line_left,
				bbox_top[1] + (self.height_cell ** 2) + w_line_top
			)
			
			"""bbox = (
				i * 20,
				bbox_top[1],
				i * 20 + self.width_cell,
				bbox_top[1] + self.height_cell
			)"""
			
			print(f"{name=}, {idx_h=}, {idx_v=}, {bbox=}")
			
			self.canvas_map.create_rectangle(
				*bbox,
				#fill=random_colour(rgb=False)
				fill="#FF0000"
			)
				
		
	def motion_canvas_map(self, event):
		ex, ey = event.x, event.y
		idx_h, idx_v = self.get_line_idxs(ex, ey)
		self.canvas_map.coords(
			self.dot,
			ex - (self.width_dot / 2),
			ey - (self.height_dot / 2),
			ex + (self.width_dot / 2),
			ey + (self.height_dot / 2)
		)
		
		lines_h, lines_v = self.get_event_lines(event)
			
		for line in self.lines_horizontal:
			self.canvas_map.itemconfigure(
				line,
				fill=self.colour_line_horizontal.hex_code
			)
			
		for line in self.lines_vertical:
			self.canvas_map.itemconfigure(
				line,
				fill=self.colour_line_vertical.hex_code
			)
		
		for line in lines_h:
			self.canvas_map.itemconfigure(
				line,
				fill=self.colour_line_horizontal.brightened(0.4).hex_code
			)
		
		for line in lines_v:
			self.canvas_map.itemconfigure(
				line,
				fill=self.colour_line_vertical.brightened(0.4).hex_code
			)
		
		changed = False
		if self.curr_col.get() != idx_v:
			self.curr_col.set(idx_v)
			changed = True
		if self.curr_row.get() != idx_h:
			self.curr_row.set(idx_h)
			changed = True
		
		#if changed:
		#	print(f"{ex=}, {ey=}, {idx_h=}, {idx_v=}")
		
	def click_canvas_map(self, event):
		self.n_clicks.set(self.n_clicks.get() + 1)
		ex, ey = event.x, event.y
		idx_h, idx_v = self.get_line_idxs(ex, ey)
		# lines_h, lines_v = self.get_event_lines(event)
		print(f"#{str(self.n_clicks.get()).rjust(3)} | row={idx_h}, col={idx_v}")
					


if __name__ == '__main__':
	app = App()
	app.mainloop()
