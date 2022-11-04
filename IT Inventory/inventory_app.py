import tkinter

import pandas

from top_level_scan_handler import TopLevelScanHandler
from grid_manager import GridManager
from colour_utility import *
from tkinter_utility import *
from stg_queries import *
from menus import AddItemMenu
from utility import alpha_seq
from dnd_onv_states import DNDItemManager


class InventoryApp(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.df_v_tools_and_equip_unipoint = None
        self.df_v_iti_items = None
        self.df_iti_invmaster = None
        self.df_uom = None
        self.df_type = None
        self.df_status = None
        self.df_condition = None
        self.df_computer = None
        self.df_peripherals = None
        self.df_network = None
        self.df_wire = None
        self.df_unknown = None

        self.populate_data()

        assert all(
            [isinstance(v, pandas.DataFrame) and not v.empty for v in [
                self.df_v_tools_and_equip_unipoint,
                self.df_v_iti_items,
                self.df_iti_invmaster,
                self.df_uom,
                self.df_type,
                self.df_status,
                self.df_condition,
                self.df_computer,
                self.df_peripherals,
                self.df_network,
                self.df_wire,
                self.df_unknown
            ]
        ]), "Error loading some data."

        self.WIDTH, self.HEIGHT = 500, 500
        self.geometry(f"{self.WIDTH}x{self.HEIGHT}")
        self.title("BWS Inventory Manager")
        self.state("zoomed")

        # self.namer = alpha_seq(1000, prefix="w_IA_")

        self.level_add_menu = None
        self.new_item_save_state = tkinter.Variable(self, value={})
        self.iv_selected_item = tkinter.IntVar(self, value=-1)

        # self.tv_l1, self.l1 = label_factory(self, tv_label="Label 1")
        # self.frame_drillview = tkinter.Frame(self, name=next(self.namer))
        # self.frame_button_bar_1 = tkinter.Frame(self, name=next(self.namer))
        # self.frame_treeview_tools_and_equip = tkinter.Frame(self, name=next(self.namer), width=self.WIDTH * 0.95)
        # self.frame_treeview_invmaster = tkinter.Frame(self, name=next(self.namer), width=self.WIDTH * 0.95)
        # self.frame_treeview_iti_items = tkinter.Frame(self, name=next(self.namer), width=self.WIDTH * 0.95)

        self.frame_button_bar_1 = tkinter.Frame(self, name="frame_button_bar")
        self.frame_treeview_tools_and_equip = tkinter.Frame(self, name="treeview_tools_and_equip", width=self.WIDTH * 0.95)
        self.frame_treeview_invmaster = tkinter.Frame(self, name="treeview_invmaster", width=self.WIDTH * 0.95)
        self.frame_treeview_iti_items = tkinter.Frame(self, name="treeview_iti_items", width=self.WIDTH * 0.95)

        # button add new
        self.tv_btn_add_new_item,\
        self.btn_add_new_item\
            = button_factory(
                self.frame_button_bar_1,
                tv_btn="+",
                kwargs_btn={
                    "name": "button_add_new_item",
                    "command": self.click_add_new_item
                }
        )

        # treeview tools and equipment
        self.chosen_columns_tools_and_equip = ["Equip_Desc", "Class", "Category", "Current_location", "Status", "Availability"]
        self.column_display_width_tools_and_equip = [250, 100, 100, 150, 50, 75]
        self.tv_label_treeview_tools_and_equip = tkinter.StringVar(self, value="v_Tools&Equip")

        # # treeview v_iti_items
        self.chosen_columns_iti_items = ["Quantity", "Item", "Condition", "Status", "Type", "Computer", "Peripherals", "Wire", "Network", "Unknown", "UOM", "TotalConsumed", "TotalAdded", "Assigned", "Maintenance", "UnknownStatus", "Serial"]
        self.column_display_width_iti_items = [30, 50, 75, 75, 75, 75, 75, 75, 75, 75, 75, 30, 75, 75]
        self.tv_label_treeview_iti_items = tkinter.StringVar(self, value="v_ITI_Items")

        # treeview iti_invmaster
        self.chosen_columns_invmaster = ["Item", "Quantity", "UOM", "TotalConsumed", "Assigned", "Maintenance"]
        self.column_display_width_invmaster = [50, 250, 75, 75, 75]
        self.tv_label_treeview_invmaster = tkinter.StringVar(self, value="ITI InvMaster")

        # #   drillview
        # self.frame_drillview.grid(row=2, column=0)

        # item manager bar
        self.frame_item_manager = tkinter.Frame(self)
        self.frame_item_manager_master_view = tkinter.Frame(self.frame_item_manager)

        self.frame_item_manager_buttons = tkinter.Frame(self.frame_item_manager)
        # +
        # -
        # in use    ->  server
        # server    ->  in use
        # in use    ->  broken
        # broken    ->  server
        # broken    ->  in use  ==  broken  ->  server  ->  in use
        # server    ->  dispose
        # in use    ->  dispose ==  in use  ->  server  ->  dispose
        self.dnd_inventory_manager = DNDItemManager(self.frame_item_manager_buttons)

        self.tv_label_selected_item,\
        self.label_selected_item,\
        self.tv_entry_selected_item,\
        self.entry_selected_item,\
            = entry_factory(
                self.frame_item_manager_master_view,
                tv_label="Selected:",
                kwargs_entry={
                    "state": "readonly"
                }
        )

        # self.dnd_inventory_manager.grid()
        self.frame_item_manager_buttons.grid()
        self.frame_item_manager.grid(row=7, column=0)
        self.frame_item_manager_master_view.grid()

        # self.pressed_keys = tkinter.StringVar(self, value="")

        self.tv1,\
        self.l1,\
        self.tv2,\
        self.e1 \
            = entry_factory(
                self,
                tv_label="ENTRY",
                kwargs_entry={
                    "justify": "center"
                }
        )
        self.tv2.trace_variable("w", self.update_serial_input)
        self.tv2_reset_value = 750
        self.tv2_counter = tkinter.IntVar(self, value=self.tv2_reset_value)

        self.accept_reset_value = 2500
        self.accept_counter = tkinter.IntVar(self, value=self.accept_reset_value)
        self.accepting_bool = tkinter.BooleanVar(self, value=True)
        # self.tv2_counter.trace_variable("w", self.count_down_serial_input)

        self.bind("<KeyPress>", self.keypress)

        self.top_level_scan_handler = None

        self.set_treeview_v_tools_and_equip()
        self.set_treeview_v_iti_items()
        self.set_treeview_v_invmaster()

        self.l1.grid()
        self.e1.grid()

        # place widgets
        self.frame_button_bar_1.grid(row=0, column=0)
        self.btn_add_new_item.grid(row=0, column=0)

        #   v_ToolsAndEquip
        self.frame_treeview_tools_and_equip.grid(row=1, column=0)
        self.label_treeview_tools_and_equip_name.grid(row=3, column=0)
        self.scrollbar_x_tools_and_equip.grid(row=4, column=0, sticky="ew")
        self.treeview_v_tool_and_equip.grid(row=5, column=0)
        self.scrollbar_y_tools_and_equip.grid(row=5, column=1, sticky="ns")

        #   v_iti_items
        self.frame_treeview_iti_items.grid(row=6, column=0)
        self.label_treeview_iti_items.grid(row=3, column=0)
        self.scrollbar_x_iti_items.grid(row=4, column=0, sticky="ew")
        self.treeview_v_iti_items.grid(row=5, column=0)
        self.scrollbar_y_iti_items.grid(row=5, column=1, sticky="ns")

        #   v_invmaster
        self.frame_treeview_invmaster.grid(row=6, column=2)
        self.label_treeview_invmaster.grid(row=3, column=2)
        self.scrollbar_x_invmaster.grid(row=4, column=2, sticky="ew")
        self.treeview_v_invmaster.grid(row=5, column=2)
        self.scrollbar_y_invmaster.grid(row=5, column=3, sticky="ns")

    def keypress(self, *args):
        print(f"key press {args=}")
        # arg, *rest = args
        # if arg.char.isalpha() or arg.char.isdigit():
        #     self.pressed_keys.set(self.pressed_keys.get() + arg.char)
        # self.tv2.set(self.pressed_keys.get())
        # self.update_serial_input(args)

        # arg, *rest = args
        # if arg.char.isalpha() or arg.char.isdigit():
        #     self.tv2.set(arg.char)

        # arg, *rest = args
        # if arg.char.isalpha() or arg.char.isdigit():
        #     self.e1.focus()

        arg, *rest = args
        if arg.char.isalpha() or arg.char.isdigit():
            if self.accepting_bool.get():
                # self.tv2.set(arg.char + self.tv2.get())
                print(f"I WANT TO ADD MISSING CHAR {arg.char=} to str={self.tv2.get()=}")
                self.update_counter_in(arg.char, self.tv2_reset_value)
                # self.tv2.set(self.tv2.get())
                # self.tv2.set(self.tv2.get())
                self.accepting_bool.set(False)
            # self.e1.icursor("end")
                self.e1.focus()

    def update_counter_in(self, char, t):
        if t <= 0:
            self.tv2.set(char + self.tv2.get())
            self.e1.icursor("end")
        else:
            self.after(1, self.update_counter_in, char, t - 1)

    def update_serial_input(self, *args):
        # print(f"update_serial_input, {self.tv2.get()}")
        self.tv2_counter.set(self.tv2_reset_value)
        self.count_down_serial_input()

    def submit_serial_entry(self, *args):
        serial_in = self.tv2.get()
        print(f"FINALLY ==> ({len(serial_in)}), '{serial_in}'\n{type(serial_in)=}")
        found = -1
        for idx, row in self.df_v_iti_items.iterrows():
            # print(f"{row['Serial']=}, {type(row['Serial'])=}")
            if row["Serial"] == serial_in:
                found = idx
        self.accept_counter.set(self.accept_reset_value)

        if found > 0:
            foreground = rgb_to_hex(WILDERNESS_MINT)
            row = self.df_v_iti_items.iloc[found]
            print(f"found: {row=}")
            self.handle_scan()
        else:
            foreground = rgb_to_hex(FIREBRICK_2)

        self.e1.configure(foreground=foreground)

    def count_down_serial_input(self, *args):
        v = self.tv2_counter.get()
        # print(f"{v=}")
        if v > 0:
            self.tv2_counter.set(v - 1)
            self.after(1, self.count_down_serial_input)
        elif v == 0:
            self.submit_serial_entry()
            self.tv2_counter.set(-1)

    def handle_scan(self):
        self.top_level_scan_handler = TopLevelScanHandler(self)
        # tv_entry_selected_item

    def populate_data(self):
        self.df_v_tools_and_equip_unipoint = connect(**SQL_V_TOOLSANDEQUIP)
        self.df_v_iti_items = connect(**SQL_V_ITI_ITEMS)
        self.df_iti_invmaster = connect(**SQL_ITI_INVMASTER)
        self.df_uom = connect(**SQL_UOM)
        self.df_type = connect(**SQL_TYPE)
        self.df_status = connect(**SQL_STATUS)
        self.df_condition = connect(**SQL_CONDITION)
        self.df_computer = connect(**SQL_COMPUTER)
        self.df_peripherals = connect(**SQL_PERIPHERALS)
        self.df_network = connect(**SQL_NETWORK)
        self.df_wire = connect(**SQL_WIRE)
        self.df_unknown = connect(**SQL_UNKNOWN)

    def submit_new_item(self, *args):
        print(f"New Item Submission:")
        all_keys = self.level_add_menu.valid_status_keys
        data_status = eval(self.level_add_menu.status.get())
        data_valid = eval(self.level_add_menu.valid.get())
        if not all_keys.difference(data_status.keys()) and data_status["submission"]:
            # all valid
            print(f"all valid")
            msg = f"Are you sure you want to add '{data_status['name']}' to ITI Items?"
            ans = messagebox.askyesnocancel(title="Inventory Addition", message=msg)
            if ans:
                insert_new_item(data_status)
                msg = f"Successfully added '{data_status['name']}' to ITI Items."
                messagebox.showinfo(title="Inventory Added", message=msg)
                self.new_item_save_state.set({})
                raise Exception("NEED TO REFRESH THE v_ITI_Items TREEVIEW")
            else:
                # save unfinished work for next opening
                print(f"save unfinished work for next opening")
                self.new_item_save_state.set(data_valid)
        else:
            # save unfinished work for next opening
            print(f"save unfinished work for next opening")
            self.new_item_save_state.set(data_valid)
        print(f"{data_status=}\n{data_valid=}")

    def get_values_spin_uom(self):
        res = []
        for i, row in self.df_uom.iterrows():
            iid = row["ID"]
            name = row["Name"]
            suffix = row["Suffix"]
            res.append("||".join(list(map(str, [iid, name, suffix]))))
        return res

    def get_values_spin_type(self):
        res = []
        for i, row in self.df_type.iterrows():
            iid = row["ID"]
            name = row["Name"]
            res.append("||".join(list(map(str, [iid, name]))))
        return res

    def get_values_spin_cond(self):
        res = []
        for i, row in self.df_condition.iterrows():
            iid = row["ID"]
            name = row["Name"]
            res.append("||".join(list(map(str, [iid, name]))))
        return res

    def get_values_spin_computer(self):
        res = []
        for i, row in self.df_computer.iterrows():
            iid = row["ID"]
            name = row["Name"]
            res.append("||".join(list(map(str, [iid, name]))))
        return res

    def get_values_spin_peripherals(self):
        res = []
        for i, row in self.df_peripherals.iterrows():
            iid = row["ID"]
            name = row["Name"]
            res.append("||".join(list(map(str, [iid, name]))))
        return res

    def get_values_spin_network(self):
        res = []
        for i, row in self.df_network.iterrows():
            iid = row["ID"]
            name = row["Name"]
            res.append("||".join(list(map(str, [iid, name]))))
        return res

    def get_values_spin_wire(self):
        res = []
        for i, row in self.df_wire.iterrows():
            iid = row["ID"]
            name = row["Name"]
            res.append("||".join(list(map(str, [iid, name]))))
        return res

    def get_values_spin_unknown(self):
        res = []
        for i, row in self.df_unknown.iterrows():
            iid = row["ID"]
            name = row["Name"]
            res.append("||".join(list(map(str, [iid, name]))))
        return res

    def click_add_new_item(self):
        values_uom = self.get_values_spin_uom()
        values_type = self.get_values_spin_type()
        values_condition = self.get_values_spin_cond()
        values_computer = self.get_values_spin_computer()
        values_peripherals = self.get_values_spin_peripherals()
        values_network = self.get_values_spin_network()
        values_wire = self.get_values_spin_wire()
        values_unknown = self.get_values_spin_unknown()
        save_state = eval(self.new_item_save_state.get())
        # print(f"{values_uom=}, {values_type}")
        self.level_add_menu = AddItemMenu(
            self,
            spin_values_uom=values_uom,
            spin_values_type=values_type,
            spin_values_cond=values_condition,
            spin_values_computer=values_computer,
            spin_values_peripherals=values_peripherals,
            spin_values_network=values_network,
            spin_values_wire=values_wire,
            spin_values_unknown=values_unknown,
            save_state=save_state
        )
        self.level_add_menu.status.trace_variable("w", self.submit_new_item)
        self.level_add_menu.tv_entry_serial.trace_variable("w", self.update_serial_scan)
        self.level_add_menu.mainloop()

    def select_treeview_items(self, event):
        tree = event.widget
        selection = [tree.item(item)["text"] for item in tree.selection()]
        print(f"selected items: {selection=}, {tree=}")
        print(f"{dir(tree)=}")
        print(f"{str(tree)=}")
        item = selection[0]
        # messagebox.showinfo(title='Information', message=','.join(selection))
        if str(tree) == ".treeview_iti_items.!treeview":

            if self.dnd_inventory_manager.made_dnd.get():
                in_use = self.dnd_inventory_manager.iv_in_use_number.get()
                broken = self.dnd_inventory_manager.iv_broken_number.get()
                disposed = self.dnd_inventory_manager.iv_disposed_number.get()
                server = self.dnd_inventory_manager.iv_server_room_number.get()
                item_id = self.iv_selected_item.get()
                print(f"\n\t\tmade_dnd\n{in_use=}\n{broken=}\n{disposed=}\n{server=}\n{item_id=}\n")

            self.dnd_inventory_manager.grid()
            row_name = self.treeview_v_iti_items.focus()
            row_data = self.treeview_v_iti_items.item(row_name)
            row_dict = dict(zip(self.chosen_columns_iti_items, row_data["values"]))
            print(f"{row_name=}")
            print(f"{row_data=}")
            item_name = row_dict["Item"]
            item_cond = row_dict["Condition"]
            print(f"{item_name=}, {item_cond=}")
            print(f"{self.level_add_menu=}")
            self.dnd_inventory_manager.select_iti_item(row_dict)
            self.iv_selected_item.set(item)

    def set_treeview_v_iti_items(self):
        # print(f"{self.chosen_columns_invmaster=}")
        self.tv_label_treeview_iti_items,\
        self.label_treeview_iti_items,\
        self.treeview_v_iti_items,\
        self.scrollbar_x_iti_items,\
        self.scrollbar_y_iti_items\
            = treeview_factory(
                self.frame_treeview_iti_items,
                self.df_v_iti_items,
                viewable_column_names=self.chosen_columns_iti_items,
                viewable_column_widths=self.column_display_width_iti_items,
                tv_label=self.tv_label_treeview_iti_items
        )

        self.treeview_v_iti_items.bind("<<TreeviewSelect>>", self.select_treeview_items)

    def set_treeview_v_invmaster(self):
        print(f"{self.chosen_columns_invmaster=}")
        self.tv_label_treeview_invmaster,\
        self.label_treeview_invmaster,\
        self.treeview_v_invmaster,\
        self.scrollbar_x_invmaster,\
        self.scrollbar_y_invmaster\
            = treeview_factory(
                self.frame_treeview_invmaster,
                self.df_iti_invmaster,
                viewable_column_names=self.chosen_columns_invmaster,
                viewable_column_widths=self.column_display_width_invmaster,
                tv_label=self.tv_label_treeview_invmaster
        )

        self.treeview_v_invmaster.bind("<<TreeviewSelect>>", self.select_treeview_items)

    def set_treeview_v_tools_and_equip(self):
        print(f"{self.chosen_columns_tools_and_equip=}")
        self.tv_label_treeview_tools_and_equip,\
        self.label_treeview_tools_and_equip_name,\
        self.treeview_v_tool_and_equip,\
        self.scrollbar_x_tools_and_equip,\
        self.scrollbar_y_tools_and_equip\
            = treeview_factory(
                self.frame_treeview_tools_and_equip,
                self.df_v_tools_and_equip_unipoint,
                viewable_column_names=self.chosen_columns_tools_and_equip,
                viewable_column_widths=self.column_display_width_tools_and_equip,
                tv_label=self.tv_label_treeview_tools_and_equip
        )

        self.treeview_v_tool_and_equip.bind("<<TreeviewSelect>>", self.select_treeview_items)

    def update_serial_scan(self, *args):
        value = self.level_add_menu.tv_entry_serial.get()
        if value:
            known_serials = self.df_v_iti_items["Serial"].unique()
            if value in known_serials:
                self.level_add_menu.error_in_serial()
                # raise ValueError(f"Error, this serial is already in use. {value=}")
                print(f"Error, this serial is already in use. '{value}'")
                return

        print(f"SERIAL AVAILABLE '{value}'")
        self.level_add_menu.set_unit_serial()

