import tkinter

import pandas

from grid_manager import GridManager
from tkinter_utility import *
from stg_queries import *
from menus import AddItemMenu


class InventoryApp(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.df_inventory_master = None
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
                self.df_inventory_master,
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

        self.level_add_menu = None
        self.new_item_save_state = tkinter.Variable(self, value={})

        # self.tv_l1, self.l1 = label_factory(self, tv_label="Label 1")
        self.frame_button_bar_1 = tkinter.Frame(self)

        self.tv_btn_add_new_item,\
        self.btn_add_new_item\
            = button_factory(
                self.frame_button_bar_1,
                tv_btn="+",
                kwargs_btn={
                    "command": self.click_add_new_item
                }
        )

        self.gm1 = GridManager()
        self.gm1.grid_widgets([
            [
                self.frame_button_bar_1
            ]
        ])
        self.gm2 = GridManager()
        self.gm2.grid_widgets([
            [
                self.btn_add_new_item
            ]
        ])

    def populate_data(self):
        self.df_inventory_master = connect(**SQL_V_TOOLSANDEQUIP)
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
