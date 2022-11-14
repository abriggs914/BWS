import tkinter

import pandas

from top_level_scan_handler import TopLevelScanHandler
from grid_manager import GridManager
from colour_utility import *
from tkinter_utility import *
from stg_queries import *
from menus import AddItemMenu, TopLevelDNDMenu
from utility import alpha_seq
from dnd_onv_states import DNDItemManager


class InventoryApp(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.title("ITI Inventory Manager")
        self.total_width, self.total_height = 300, 125
        self.geometry(f"{self.total_width}x{self.total_height}")

        self.df_v_tools_and_equip_unipoint = None
        self.df_v_iti_items = None
        self.df_iti_invmaster = None
        self.df_iti_item = None
        self.df_uom = None
        self.df_type = None
        self.df_status = None
        self.df_condition = None
        self.df_computer = None
        self.df_peripherals = None
        self.df_network = None
        self.df_wire = None
        self.df_unknown = None
        self.df_serial_indication = None

        self.populate_data()

        assert all(
            [isinstance(v, pandas.DataFrame) and not v.empty for v in [
                self.df_v_tools_and_equip_unipoint
                ,self.df_v_iti_items
                ,self.df_iti_invmaster
                ,self.df_uom
                ,self.df_type
                ,self.df_status
                ,self.df_condition
                ,self.df_computer
                ,self.df_peripherals
                ,self.df_network
                ,self.df_wire
                ,self.df_unknown
                ,self.df_serial_indication
                ,self.df_iti_item
            ]
             ]), "Error loading some data."

        self.tl_add_menu = None
        self.tl_dnd_menu = None
        self.data_tl_dnd_menu = None

        self.new_item_save_state = tkinter.Variable(self, value={})

        self.tv_label_input = tkinter.StringVar(self, value="Scan a Barcode Here:")
        self.label_scan_input = tkinter.Label(self, textvariable=self.tv_label_input)
        self.entry_scan_input = ScannableEntry(self)
        self.entry_scan_input.set_scan_pass_through()

        self.label_scan_input.pack()
        self.entry_scan_input.pack()

        self.entry_scan_input.validated_text.trace_variable("w", self.submit_scan)

        self.bind("<Control-Shift-KeyPress-Q>", self.insert_demo_value)

    def populate_data(self):
        self.df_v_tools_and_equip_unipoint = connect(**SQL_V_TOOLSANDEQUIP)
        self.df_v_iti_items = connect(**SQL_V_ITI_ITEMS)
        self.df_iti_invmaster = connect(**SQL_ITI_INVMASTER)
        self.df_iti_item = connect(**SQL_ITI_ITEM)
        self.df_uom = connect(**SQL_UOM)
        self.df_type = connect(**SQL_TYPE)
        self.df_status = connect(**SQL_STATUS)
        self.df_condition = connect(**SQL_CONDITION)
        self.df_computer = connect(**SQL_COMPUTER)
        self.df_peripherals = connect(**SQL_PERIPHERALS)
        self.df_network = connect(**SQL_NETWORK)
        self.df_wire = connect(**SQL_WIRE)
        self.df_unknown = connect(**SQL_UNKNOWN)
        self.df_serial_indication = connect(**SQL_ITI_SERIAL_INDICATION)

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

    def submit_scan(self, *args):
        scan_in = self.entry_scan_input.validated_text.get()
        if scan_in:
            scan_in = "*" + self.entry_scan_input.validated_text.get() + "*"
            print(f"{scan_in=}")
            is_indication_result = self.is_indication_serial(scan_in)
            is_indication = not is_indication_result.empty  # this serial was found in the list of known serial indications.
            print(f"{is_indication=}")
            # print(f"{is_indication_result=}")
            if not is_indication:
                is_known_item_result = self.is_known_serial(scan_in[1:-1])
                is_known_item = not is_known_item_result.empty  # this serial was found in the list of known item serials.
                print(f"{is_known_item=}")
                if is_known_item:
                    # open dnd menu to handle the movements
                    self.open_dnd(scan_in[1:-1])

    def begin_create_new_item(self):
        print("CREATE NEW ITEM")
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
        self.accepting_bool.set(True)

    def is_indication_serial(self, serial_in):
        return self.df_serial_indication[self.df_serial_indication["Serial"] == serial_in]

    def is_known_serial(self, serial_in):
        return self.df_iti_item[self.df_iti_item["Serial"] == serial_in]

    def gather_dnd_data(self, scan_in):
        # only known item serials should be used at this point.
        data = self.is_known_serial(scan_in)
        print(f"{data=}, {type(data)=}")
        result = {}
        row = data.iloc[0]
        result = dict(zip(data.keys().tolist(), data.values[0].tolist()))
        if result["ID"]:
            idx = result['ID']
        if result["Condition"]:
            idx = result['Condition']
            result.update({"ConditionName": self.df_condition.iloc[idx]["Name"]})
        if result["Status"]:
            idx = result['Status']
            result.update({"StatusName": self.df_status.iloc[idx]["Name"]})
        if result["Type"]:
            idx = result['Type']
            result.update({"TypeName": self.df_type.iloc[idx]["Name"]})
        return result

    def open_dnd(self, scan_in):
        self.tl_dnd_menu = TopLevelDNDMenu(self, omit_shopping_cart=True)
        self.data_tl_dnd_menu = {
            "server_room": self.tl_dnd_menu.canvas_dnd.iv_server_room_number,
            "use_number": self.tl_dnd_menu.canvas_dnd.iv_in_use_number,
            "broken": self.tl_dnd_menu.canvas_dnd.iv_broken_number,
            "disposed": self.tl_dnd_menu.canvas_dnd.iv_disposed_number,
            "shopping_cart": self.tl_dnd_menu.canvas_dnd.iv_shopping_cart_number
        }
        data_in = self.gather_dnd_data(scan_in)

        self.tl_dnd_menu.set_data(data_in)
        apply_state(self.entry_scan_input, "disabled", "down")
        # self.tl_dnd_menu.mainloop()

    def insert_demo_value(self, event):
        # self.entry_scan_input.text.set("0000000250")
        self.entry_scan_input.text.set("0000000100")
        self.entry_scan_input.return_text(event)
