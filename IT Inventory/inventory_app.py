import tkinter

import pandas

from grid_manager import GridManager
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
        self.set_treeview_v_tools_and_equip()

        # # treeview v_iti_items
        self.chosen_columns_iti_items = ["Quantity", "Item", "Condition", "Status", "Type", "Computer", "Peripherals", "Wire", "Network", "Unknown", "UOM", "TotalConsumed", "TotalAdded"]
        self.column_display_width_iti_items = [30, 50, 75, 75, 75, 75, 75, 75, 75, 75, 75, 30, 75, 75]
        self.tv_label_treeview_iti_items = tkinter.StringVar(self, value="v_ITI_Items")
        self.set_treeview_v_iti_items()

        # treeview iti_invmaster
        self.chosen_columns_invmaster = ["Item", "Quantity", "UOM", "TotalConsumed", "Assigned", "Maintenance"]
        self.column_display_width_invmaster = [50, 250, 75, 75, 75]
        self.tv_label_treeview_invmaster = tkinter.StringVar(self, value="ITI InvMaster")
        self.set_treeview_v_invmaster()

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

        # #   drillview
        # self.frame_drillview.grid(row=2, column=0)

        # item manager bar
        self.frame_item_manager = tkinter.Frame(self)
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
        self.dnd_inventory_manager.grid()
        self.frame_item_manager_buttons.grid()
        self.frame_item_manager.grid(row=7, column=0)

        tv1, l1, tv2, e1 = entry_factory(self, tv_label="ENTRY")
        l1.grid()
        e1.grid()
        tv2.trace_variable("w", self.update_serial_input)

    def update_serial_input(self, *args):
        print(f"update_serial_input")

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
        self.level_add_menu.mainloop()

    def select_treeview_items(self, event):
        tree = event.widget
        selection = [tree.item(item)["text"] for item in tree.selection()]
        print(f"selected items: {selection=}, {tree=}")
        # messagebox.showinfo(title='Information', message=','.join(selection))

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

