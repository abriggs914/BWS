import datetime
import tkinter
from tkinter import ttk, messagebox

from colour_utility import rgb_to_hex, random_colour
from tkinter_utility import entry_factory, button_factory
from calendar_surface import CalendarSurface
from pyodbc_connection import connect
from utility import clamp, clamp_rect
from stg_queries import *
from unit import Unit
from colour_demo import ColourWidget


PROGRAM_MODE = "LIVE"
# PROGRAM_MODE = "TEST"


class App(tkinter.Tk):

    def __init__(self, TITLE="Stargate Production Scheduler", WIDTH=500, HEIGHT=500, start_date_in=datetime.datetime.now()):
        super().__init__()

        self.start_date = start_date_in
        self.df_production = None
        self.df_work_days = None
        self.populate_data()

        if self.df_production is None or self.df_work_days is None:
            tkinter.messagebox.showerror(title="Fatal", message="Error unable to load production data")
            quit()

        ###############################################################################################################
        # State variables
        ###############################################################################################################
        self.valid_app_states = ["IDLE", "DRAGGING", "SELECTED"]
        self._app_state = "IDLE"
        self.drag_tile_queue = []
        self.drag_text_queue = []
        self.drag_tile = None
        self.drag_text = None
        self.dragging_details = None
        self.select_tile = None
        self.select_text = None
        self.select_details = None

        self.TITLE = TITLE
        self.WIDTH = WIDTH
        self.HEIGHT = HEIGHT
        self.geometry(f"{self.WIDTH}x{self.HEIGHT}")
        self.state("zoomed")
        self.title(self.TITLE)
        self.update()
        self.window_width = self.winfo_width()
        self.window_height = self.winfo_height()

        self.frame_top_bar = tkinter.Frame(self)
        self.removed_quotes = []  # us this to track quotes removed from the combo list.
        self.tv_combo_unit_selection = tkinter.StringVar(self)

        can_w, can_h = int(self.window_width * 0.75), int(self.window_height * 0.65)
        self.frame_calendar_a = tkinter.Frame(self)
        self.frame_calendar_b = tkinter.Frame(self.frame_calendar_a)

        self.calendar_surface = CalendarSurface(self.frame_calendar_b, can_w, can_h, self.start_date)
        self.calendar_surface.populate_units(self.df_production)

        # self.combo_unit_selection = ttk.Combobox(self.frame_top_bar, values=self.dat_list_of_units(remove_placed=True), textvariable=self.tv_combo_unit_selection, state="readonly")
        self.combo_unit_selection = ttk.Combobox(self.frame_top_bar, values=self.dat_list_of_units(remove_placed=True), textvariable=self.tv_combo_unit_selection, state="readonly")
        self.tv_btn_insert_combo_choice, self.button_insert_combo_choice = button_factory(self.frame_top_bar, tv_btn="+")
        self.button_insert_combo_choice.config(command=self.click_insert_combo_choice)
        self.tv_btn_save_changes, self.button_save_changes = button_factory(self.frame_top_bar, tv_btn="save", kwargs_btn={"command": self.click_export_sql})
        self.tv_label_debug_app_state, self.debug_label_entry_app_state, self.tv_debug_app_state, self.debug_entry_app_state = entry_factory(self.frame_top_bar, tv_label="App State:", tv_entry=self.app_state, kwargs_entry={"state": "readonly"})
        self.tv_btn_export_sql, self.button_export_sql = button_factory(self.frame_top_bar, tv_btn="<", kwargs_btn={"command": self.click_undo})

        self.debug_tv_show_history, self.debug_show_history = button_factory(self.frame_top_bar, tv_btn="show history", kwargs_btn={"command": self.click_debug_show_history})

        # canvas and calendar objects
        # self.tv_btn_scroll_left, self.button_scroll_left = button_factory(self.frame_calendar_a, tv_btn="left", kwargs_btn={"command": self.click_left_scroll})
        # self.tv_btn_scroll_right, self.button_scroll_right = button_factory(self.frame_calendar_a, tv_btn="right", kwargs_btn={"command": self.click_right_scroll})

        self.frame_colour_coder = ColourWidget(self.frame_top_bar, dealers=self.dat_list_of_dealers())

        self.frame_colour_coder.status_code.trace_variable("w", self.colour_coder_update)

        for r, tile_row in enumerate(self.calendar_surface.tiles):
            for c, tile in enumerate(tile_row):
                self.calendar_surface.tag_bind(tile, "<Double-Button-1>", self.dbl_click_tile)

        self.calendar_scroll_bar = tkinter.Scrollbar(self.frame_calendar_b, orient="horizontal", command=self.calendar_surface.xview,)
        self.calendar_surface.configure(xscrollcommand=self.calendar_scroll_bar.set)

        ###############################################################################################################
        #   bind event handlers
        ###############################################################################################################
        self.calendar_surface.bind("<Button-1>", self.click_calendar_surface)
        self.calendar_surface.bind("<Button-3>", self.click_calendar_surface_left)
        self.calendar_surface.bind("<ButtonRelease-1>", self.release_calendar_surface)
        self.calendar_surface.bind("<Motion>", self.motion_calendar_surface)
        self.frame_calendar_b.bind('<Configure>', self.onFrameConfigure)
        # self.calendar_surface.bind_all("<MouseWheel>", lambda event: self.xview('scroll', int(-1*(event.delta/120)), 'units'))
        self.calendar_surface.bind("<MouseWheel>", lambda event: self.xview('scroll', int(-1*(event.delta/120)), 'units'))

        ###############################################################################################################
        #  pack widgets
        ###############################################################################################################
        self.frame_top_bar.pack()
        self.combo_unit_selection.pack()
        self.button_insert_combo_choice.pack()
        self.button_save_changes.pack()
        if PROGRAM_MODE == "TEST":
            self.debug_label_entry_app_state.pack()
            self.debug_entry_app_state.pack()
            self.debug_show_history.pack()
        self.button_export_sql.pack()
        self.frame_colour_coder.pack()

        self.frame_calendar_a.pack()
        self.frame_calendar_b.grid()
        self.calendar_surface.grid(row=1, column=1)
        self.calendar_scroll_bar.grid(row=2, column=1, sticky="ew")
        # self.button_scroll_left.pack(side=tkinter.LEFT)
        # self.button_scroll_right.pack(side=tkinter.RIGHT)

    def populate_data(self):
        """Mass Database Query 'Getter' Function. Should be called at the beginning of app execution, or using a thread."""
        self.df_production = connect(**SQL_ALL_DATED_STG_UNITS)
        self.df_work_days = connect(**SQL_ALL_STG_PROD_DAYS)

    def dat_list_of_units(self, remove_placed=False):
        units = self.calendar_surface.units
        # print(f"{units=}")
        print(f"{self.df_production['SGQuote'].values.tolist()[0]=}")
        print(f"{self.df_production['SGQuote'].values.tolist()[0][0]=}")
        # rem = (1 == (1 if not remove_placed else (1 if self.df_production["SGQuote"].values.tolist()[0][0] in units else 0)))
        # # (1 == (1 if not remove_placed else (1 if tup[0] not in units else 0)))
        # print(f"{rem=}")
        # lst = [tup[0] for tup in self.df_production["SGQuote"].values.tolist() if tup[0] is not None and (1 == (1 if not remove_placed else (1 if tup[0] in units else 0)))]
        lst = [tup[0] for tup in self.df_production["SGQuote"].values.tolist() if tup[0][0] is not None]
        print(f"{lst=}")
        if remove_placed:
            for unit_in, unit_o in units.items():
                # print(f"{unit_in=}")
                if unit_in not in [None, "none", ""]:
                    if unit_o.placed:
                        lst.remove(unit_in)
        lst.sort()
        return lst

    def dat_list_of_dealers(self):
        lst = list({tup[0] for tup in self.df_production["InputField2"].values.tolist() if tup[0] is not None})
        lst.sort()
        return lst

    def release_calendar_surface(self, event):
        print(f"release {event=}")
        x, y = event.x, event.y
        dt = self.drag_tile
        ddt = self.dragging_details
        ht = self.calendar_surface.tile_at_xy((x, y))
        dt_rc = self.calendar_surface.tile_to_rc(dt)
        ht_rc = self.calendar_surface.tile_to_rc(ht)
        print(f"{dt=}, {ht=}, {dt_rc=}, {ht_rc=}")
        if ht_rc:
            if ht_rc[0] != 0 and ht_rc[1] != 0:
                print(f"HERE A")
                if self.app_state == "DRAGGING":
                    print(f"HERE B")
                    if dt != ht:
                        print(f"HERE C")
                        # releasing a dragged tile over a new position
                        print(f"DDT: <{ddt=}>")
                        unit_in = ddt["unit_in"]
                        ft = ddt["from_tag"]
                        if unit_in:
                            # TODO double check that this day is not a weekend
                            print(f"HERE D")
                            if self.move_tile(ht, ft, unit_in):
                                self.app_state = "IDLE"
                                self.drag_tile = None
                                self.calendar_surface.itemconfigure(dt, state="hidden")
                                self.calendar_surface.itemconfigure(self.drag_text, state="hidden")
                    else:
                        #TODO investigate where a dragged tile goes when released over the same spot. ht == dt
                        # releasing a dragged tile on the same position.
                        self.app_state = "SELECTED"
                        self.select_details = {
                            "quote": ddt["quote"],
                            "unit_in": ddt["unit_in"],
                            "from_tag": ht
                        }
                        self.select_tile = dt
                        self.drag_tile = None
                        self.calendar_surface.itemconfigure(dt, state="hidden")
                        self.calendar_surface.itemconfigure(self.drag_text, state="hidden")
                else:
                    print(f"INVALID STATE")
        else:
            print(f"LET GO OFF CALENDAR")

    def click_calendar_surface_left(self, event):
        """Delete a tile when right-clicking the mouse over a valid unit."""
        print(f"{event=}")
        x, y = event.x, event.y
        rc = self.calendar_surface.rc_at_xy((x, y))
        if rc:
            r, c = rc
            if r > 0 and c > 0:
                unit_in = self.calendar_surface.tile_properties[r][c]["unit_in"]
                if unit_in:
                    self.removed_quotes.append(unit_in.SGQuote)
                    self.delete_tile(r, c, unit_in)

    def click_calendar_surface(self, event):
        print(f"click {event=}")
        x, y = event.x, event.y
        tile = self.calendar_surface.tile_at_xy((x, y))
        print(f"\t{x=}, {y=}, {tile=}")

        # drag tile, hover tile canvas tags and row columns
        dt = self.drag_tile
        ddt = self.dragging_details
        ht = self.calendar_surface.tile_at_xy((x, y))
        dt_rc = self.calendar_surface.tile_to_rc(dt)
        ht_rc = self.calendar_surface.tile_to_rc(ht)
        print(f"{dt=}, {ht=}, {dt_rc=}, {ht_rc=}")
        if tile is not None:
            if self.app_state == "IDLE":
                if ht_rc[0] != 0 and ht_rc[1] != 0:
                    # TODO double check that this day is not a weekend

                    self.app_state = "SELECTED"
                    self.calendar_surface.itemconfigure(tile, fill=self.calendar_surface.selected_colour)
                    self.select_tile = tile
                    self.select_details = {
                        "quote": self.tv_combo_unit_selection.get(),
                        "unit_in": self.calendar_surface.units[self.tv_combo_unit_selection.get()],
                        "from_tag": ht
                    }
                    self.calendar_surface.itemconfigure(self.drag_tile, state="normal")
                    self.calendar_surface.itemconfigure(self.drag_text, state="normal")

            elif self.app_state == "DRAGGING":

                self.app_state = "IDLE"
                # self.calendar_surface.it
                # TODO take the dragging tile data and insert it into the tile where the click was set.

                from_combo = self.dragging_details['from_tag'] is None
                drag_unit = ddt["unit_in"]
                ft = ddt["from_tag"]
                print(f"dt is overridden by {ft}")
                if from_combo:
                    if ht_rc[0] != 0 and ht_rc[1] != 0:
                        # TODO double check that this day is not a weekend
                        values = list(self.combo_unit_selection["values"])
                        values.remove(self.tv_combo_unit_selection.get())
                        self.removed_quotes.append(self.tv_combo_unit_selection.get())
                        self.combo_unit_selection.configure(values=values)
                        self.tv_combo_unit_selection.set("")
                        print("FROM COMBO")
                        success = self.overwrite_tile(ht, drag_unit)
                        if not success:
                            print(f"NOT SUCCESS")
                        # self.calendar_surface.itemconfigure(tile, fill=random_colour(rgb=False))
                else:
                    if ht_rc[0] != 0 and ht_rc[1] != 0:
                        if dt != ht:
                            if drag_unit:
                                # TODO double check that this day is not a weekend
                                self.move_tile(ht, ft, drag_unit)

                self.calendar_surface.itemconfigure(self.drag_tile, state="hidden")
                self.calendar_surface.itemconfigure(self.drag_text, state="hidden")
                self.drag_tile = None
            else:

                # self.app_state == "SELECTED"
                self.calendar_surface.itemconfigure(tile, fill=self.calendar_surface.selected_colour)
                self.select_tile = tile
                unit_in = self.calendar_surface.quote_at_xy((x, y))
                self.select_details = {
                    "quote": unit_in.SGQuote,
                    "unit_in": unit_in,
                    "from_tag": ht
                }

    def motion_calendar_surface(self, event):
        # print(f"motion {event=}")
        if self.app_state == "DRAGGING":
            dt = self.drag_tile
            # bbox = self.calendar_surface.bbox(dt)
            # cx, cy, cw, ch = self.calendar_surface.winfo_rootx(), self.calendar_surface.winfo_rooty(), self.calendar_surface.winfo_width(), self.calendar_surface.winfo_height()
            # # xe, ye = event
            #
            # # xe = event.x - (self.calendar_surface.tile_width / 2)
            # # ye = event.y - (self.calendar_surface.tile_height / 2)
            # # # mx = self.winfo_width() - (2 * self.calendar_surface.tile_width) - cx - (self.calendar_surface.tile_width / 1.5)
            # # # my = self.winfo_height() - (2 * self.calendar_surface.tile_height) - cy - (self.calendar_surface.tile_height / 1.5)
            # # mx = cx + self.calendar_surface.winfo_width() - (self.calendar_surface.tile_width / 1)
            # # my = cy + self.calendar_surface.winfo_height() - (self.calendar_surface.tile_height / 1)
            # # print(f"{bbox=}, {cx=}, {cy=}, {cw=}, {ch=}, {mx=}, {my=}, {xe=}, {ye=}")
            # # xe = clamp(0, xe, mx)
            # # ye = clamp(0, ye, my)

            x = self.calendar_surface.canvasx(event.x) - (self.calendar_surface.tile_width / 2)
            y = self.calendar_surface.canvasy(event.y) - (self.calendar_surface.tile_height / 2)
            # bbox = [
            #     self.calendar_surface.winfo_x(),
            #     self.calendar_surface.winfo_y(),
            #     self.calendar_surface.winfo_x() + self.calendar_surface.winfo_width() - (self.calendar_surface.tile_width / 2),
            #     self.calendar_surface.winfo_y() + self.calendar_surface.winfo_height() - (self.calendar_surface.tile_height / 2)
            # ]

            bbox = self.calendar_surface.bbox("all")
            xe = clamp(bbox[0], x, bbox[2])
            ye = clamp(bbox[1], y, bbox[3])
            self.calendar_surface.moveto(dt, xe, ye)
            self.calendar_surface.moveto(self.drag_text, xe, ye)
            #
            # x, y = event.x, event.y
            # bbox = self.calendar_surface.bbox("all")
            # new_rect = clamp_rect([x, y, self.calendar_surface.tile_width, self.calendar_surface.tile_height], bbox, maintain_inner_dims=True)
            # self.calendar_surface.moveto(self.drag_tile, new_rect[0], new_rect[1])
            #
            #
            # xe, ye = event.x - (self.calendar_surface.tile_width / 2), event.y - (self.calendar_surface.tile_height / 2)
            # mx, my = self.winfo_width() - (2 * self.calendar_surface.tile_width) - cx - (self.calendar_surface.tile_width / 1.5), self.winfo_height() - (2 * self.calendar_surface.tile_height) - cy - (self.calendar_surface.tile_height / 1.5)
            # print(f"{bbox=}, {cx=}, {cy=}, {cw=}, {ch=}, {mx=}, {my=}, {xe=}, {ye=}")
            # xe = clamp(0, xe, mx)
            # ye = clamp(0, ye, my)
            # self.calendar_surface.moveto(dt, xe, ye)
        elif self.app_state == "SELECTED":
            self.app_state = "DRAGGING"
            r_c = self.calendar_surface.rc_at_xy((self.calendar_surface.canvasx(event.x), self.calendar_surface.canvasy(event.y)))
            r_c = self.calendar_surface.rc_at_xy((event.x, event.y))
            if r_c:
                r, c = r_c
                unit_in = self.calendar_surface.tile_properties[r][c]["unit_in"]
                self.dragging_details = {
                    "quote": unit_in.SGQuote if unit_in else None,
                    "unit_in": unit_in,
                    "from_tag": self.select_details["from_tag"]
                }
                self.update()

    def scroll_calendar_surface(self, event):
        print(f"Scrolling: {event}")
        first = self.calendar_surface.bbox(self.calendar_surface.tiles[0][0])
        last = self.calendar_surface.bbox(self.calendar_surface.tiles[-1][-1])
        print(f"{first=}, {last=}")
        self.calendar_surface.xview_scroll(int(-1 * (event.delta / 120)), "units")

    def xview(self, *args):
        # https://stackoverflow.com/questions/63629407/tkinter-how-to-stop-scrolling-above-canvas-window
        if self.calendar_surface.xview() == (0.0, 1.0):
            return
        self.calendar_surface.xview(*args)

    def onFrameConfigure(self, event):
        self.calendar_surface.configure(scrollregion=self.calendar_surface.bbox('all'))

    def click_save_changes(self):
        print(f"SAVING")

    def click_insert_combo_choice(self):
        print(f"insert combo choice")
        if self.tv_combo_unit_selection.get():
            self.app_state = "DRAGGING"
            self.dragging_details = {
                "quote": self.tv_combo_unit_selection.get(),
                "unit_in": self.calendar_surface.units[self.tv_combo_unit_selection.get()],
                "from_tag": None
            }
            self.update()
        else:
            r_message = "You need to select a unit from the dropdown before you can place it."
            tkinter.messagebox.showerror(title="Selection Needed", message=r_message)
            self.combo_unit_selection.focus()

    def click_export_sql(self):
        sql_res = self.calendar_surface.export_tile_sql(self.removed_quotes)
        # print(f"SQL\n\n<{sql_res}>")
        tkinter.messagebox.showinfo(title="SQL Export", message="Data updated successfully!")

    def click_debug_show_history(self):
        print(f"self.calendar_surface.history:\n{self.calendar_surface.history}")

    def click_undo(self):
        undo_data = self.calendar_surface.undo()
        success, data = undo_data
        msg = data["msg"]
        match success:
            case 0:
                # failure
                tkinter.messagebox.showinfo(title="Undo", message="Nothing to undo!")
            case 1:
                # success
                # tkinter.messagebox.showinfo(title="Undo", message="Nothing to undo!")
                pass
            case 2:
                # 2 - success - but need to re-add a removed tile to the combo list.
                quote = data["quote"]
                if quote in self.removed_quotes:
                    new_list = list(self.combo_unit_selection["values"])
                    new_list.append(quote)
                    new_list.sort()
                    self.combo_unit_selection.configure(values=new_list)
                else:
                    print(f"{quote=} not found in {self.removed_quotes}")
            case 3:
                # 2 - success - but need to remove quote from combo list.
                quote = data["quote"]
                values = list(self.combo_unit_selection["values"])
                values.remove(quote)
                self.combo_unit_selection.configure(values=values)
            case 4:
                # 4 - success - but need to re-colour code
                unit_to = data["unit_to"]
                unit_from = data["unit_from"]
                self.colour_code_dealer(unit_to.InputField2_v2)
                self.colour_code_dealer(unit_from.InputField2_v2)
            case _:
                raise ValueError(f"Error undo not successful. Returned {success}\n{msg=}")
        print(f"{success}, {msg=}")

    def dbl_click_tile(self, event):
        # self.calendar_surface.dbl_click_tile(event)
        x, y = event.x, event.y
        tile = self.calendar_surface.tile_at_xy((x, y))
        print(f"Double click!, tile chosen: {tile}")
        if tile is not None:
            self.drag_tile = tile
            self.app_state = "DRAGGING"
            self.update()

    def update(self) -> None:
        if self.app_state == "DRAGGING":
            dt = self.drag_tile
            if dt is None:
                ts = self.calendar_surface.tile_space
                tw = self.calendar_surface.tile_width
                th = self.calendar_surface.tile_height
                x1, y1 = self.winfo_pointerxy()
                rx, ry = self.winfo_rootx(), self.winfo_rooty()
                wx, wy = self.winfo_x(), self.winfo_y()
                cx, cy = self.calendar_surface.winfo_rootx(), self.calendar_surface.winfo_rooty()
                print(f"{x1=}, {y1=}, {wx=}, {wy=}, {rx=}, {ry=}, {cx=}, {cy=}")
                x1 -= cx
                y1 -= cy
                self.clear_drag_tile_queue()
                self.clear_drag_text_queue()
                self.drag_tile = self.calendar_surface.create_rectangle(x1 - (tw / 2), y1, x1 + (tw / 2), y1 + th, fill=self.calendar_surface.drag_colour)
                self.drag_text = self.calendar_surface.create_text(x1, y1 + (th / 2), text=self.dragging_details["quote"], width=x1 + (tw / 2), fill="white")
                self.drag_tile_queue.append(self.drag_tile)
                self.drag_text_queue.append(self.drag_text)
                # self.drag_coordinates =
                dt = self.drag_tile
        super(App, self).update()

    def clear_drag_tile_queue(self):
        for tile in self.drag_tile_queue:
            self.calendar_surface.itemconfigure(tile, state="hidden")
        self.drag_tile_queue.clear()

    def clear_drag_text_queue(self):
        for text in self.drag_text_queue:
            self.calendar_surface.itemconfigure(text, state="hidden")
        self.drag_text_queue.clear()

    def move_tile(self, tag_to: int | str, tag_from: int | str, unit_in: Unit) -> bool:
        print(f"move_tile(self, tag_to: int | str, tag_from: int | str, unit_in: Unit) -> bool:")
        to_rc = self.calendar_surface.tile_to_rc(tag_to)
        from_rc = self.calendar_surface.tile_to_rc(tag_from)
        s1, s2 = False, False
        if to_rc:
            # TODO decide if this is a normal placement or a swa.
            r, c = from_rc
            tr, tc = self.calendar_surface.tile_to_rc(tag_to)
            unit_from = self.calendar_surface.tile_properties[tr][tc]["unit_in"]
            already_a_tile = unit_from is not None
            print(f"Moving a tile {r=}, {c=}, {already_a_tile=}, {unit_in=}, {self.calendar_surface.tile_properties[r][c]['unit_in']=}")
            if already_a_tile:
                s1 = self.overwrite_tile(tag_to, unit_in, undoable=False)
                s2 = self.overwrite_tile(tag_from, unit_from, undoable=False)
                self.calendar_surface.revert_colour(from_rc)
                self.calendar_surface.revert_colour(to_rc)
                self.colour_code_dealer(unit_in.InputField2_v2)
                self.colour_code_dealer(unit_from.InputField2_v2)
                # s2 = self.delete_tile(r, c, unit_in, unplace=False, undoable=False)
                self.calendar_surface.history.append(CalendarSurface.SwapUndoable(r, c, tr, tc, unit_from, unit_in))
            else:
                s1 = self.overwrite_tile(tag_to, unit_in, undoable=False)
                s2 = self.delete_tile(r, c, unit_in, unplace=False, undoable=False)
                self.calendar_surface.history.append(CalendarSurface.MovementUndoable(r, c, tr, tc, unit_in))
        return s1 and s2

    def delete_tile(self, r, c, unit_in, unplace=True, undoable=True) -> bool:
        print(f"delete_tile(self, r, c, unit_in, unplace=True) -> bool:")
        details = self.calendar_surface.tile_properties[r][c]
        string_vars = [
            tv_text_1 := details["text_1"],
            tv_text_2 := details["text_2"],
            tv_text_3 := details["text_3"],
            tv_text_4 := details["text_4"],
            tv_text_5 := details["text_5"]
        ]
        for sv in string_vars:
            sv.set("")
        self.calendar_surface.delete_tile(r, c, unplace=unplace)
        # self.calendar_surface.tile_properties[r][c]["unit_in"] = None
        if unit_in.SGQuote in self.removed_quotes:
            new_list = list(self.combo_unit_selection["values"])
            new_list.append(unit_in.SGQuote)
            new_list.sort()
            self.combo_unit_selection.configure(values=new_list)
        self.calendar_surface.revert_colour((r, c))
        if undoable:
            self.calendar_surface.history.append(CalendarSurface.DeletionUndoable(r, c, unit_in))
        return True

    def overwrite_tile(self, tag_in: int | str, unit_in: Unit, undoable: bool = True) -> bool:
        print(f"overwrite_tile(self, tag_in: int | str, unit_in: Unit) -> bool:")
        rc = self.calendar_surface.tile_to_rc(tag_in)
        if rc is not None:
            r, c = rc
            print(f"HERE E")
            # this tag was found, and it is a tile tag
            # self.calendar_surface.itemconfigure(tag_in, **details)
            details = self.calendar_surface.tile_properties[rc[0]][rc[1]]
            # tags = [
            #     tag_rect := details["tag_rect"],
            #     tag_t1 := details["t1_tag"],
            #     tag_t2 := details["t2_tag"],
            #     tag_t3 := details["t3_tag"],
            #     tag_t4 := details["t4_tag"],
            #     tag_t5 := details["t5_tag"]
            # ]
            string_vars = [
                tv_text_1 := details["text_1"],
                tv_text_2 := details["text_2"],
                tv_text_3 := details["text_3"],
                tv_text_4 := details["text_4"],
                tv_text_5 := details["text_5"]
            ]
            # update the tile text variables on the main screen
            # set the new unit_in to be recognized in self.calendar_surface
            text_order = self.calendar_surface.text_order
            keys = unit_in.__dict__.keys()
            for i, text_tv in enumerate(zip(text_order, string_vars)):
                text, tv = text_tv
                text = "_" + text
                value = text
                print(f"HERE\t{text=}, {keys=}")
                if text in keys:
                    value = getattr(unit_in, text, "N/A")
                print(f"\t\t{i=}, {text=} = {value=}, {tv.get()=}")
                tv.set(value)
                print(f"\t\t\t{tv.get()=}")
            self.calendar_surface.set_rc_with_unit(rc, unit_in)
            # print(f"{unit_in=}")
            # self.calendar_surface.tile_properties[r][c]["unit_in"] = unit_in
            dealer = unit_in.InputField2_v2
            if dealer:
                dealer_colour = self.frame_colour_coder.status[dealer]
                if dealer_colour and dealer_colour != "none":
                    self.calendar_surface.colour_code_dealer(dealer, dealer_colour)

            # tv_text_1.set()

            if undoable:
                self.calendar_surface.history.append(CalendarSurface.PlacementUndoable(r, c, unit_in))

            return True
        return False

    def colour_coder_update(self, var_name, index, mode):
        print(f"{var_name=}, {index=}, {mode=}, value={getattr(self.frame_colour_coder, 'status_code').get()}")
        info = eval(self.frame_colour_coder.status_code.get())
        self.calendar_surface.colour_code_dealer(info["dealer"], info["colour"])

    def colour_code_dealer(self, dealer_in):
        if dealer_in:
            dealer_colour = self.frame_colour_coder.status[dealer_in]
            if dealer_colour and dealer_colour != "none":
                self.calendar_surface.colour_code_dealer(dealer_in, dealer_colour)

    def get_app_state(self):
        return self._app_state

    def set_app_state(self, app_state_in):
        if app_state_in not in self.valid_app_states:
            raise ValueError(f"Error param 'app_state_in' is not a valid app state.\nMust be one of {self.valid_app_states}\nGot: {app_state_in}")
        self._app_state = app_state_in
        self.tv_debug_app_state.set(self.app_state)

    def del_app_state(self):
        del self._app_state

    app_state = property(get_app_state, set_app_state, del_app_state)
