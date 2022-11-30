import tkinter

import pandas

from top_level_scan_handler import TopLevelScanHandler
from grid_manager import GridManager
from colour_utility import *
from tkinter_utility import *
from inventory_queries import *
from menus import AddItemMenu
from utility import alpha_seq
from dnd_onv_states import DNDItemManagerStatus


class InventoryApp(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.total_width, self.total_height = 300, 125
        self.geometry(f"{self.total_width}x{self.total_height}")

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
            ]
             ]), "Error loading some data."

        self.level_add_menu = None
        self.new_item_save_state = tkinter.Variable(self, value={})

        self.tv_label_serial_input, \
        self.label_serial_input,\
        self.tv_entry_serial_input, \
        self.entry_serial_input\
            = entry_factory(
                self,
                tv_label="Scan a serial number:",
                kwargs_entry={
                    "font": ("Arial", 16),
                    "justify": "center"
                }
        )

        self.x__0, \
        self.x__1,\
        self.x__3, \
        self.x__3\
            = entry_factory(
                self,
                tv_label="PLACEHOLDER",
                kwargs_entry={
                    "font": ("Arial", 16),
                    "justify": "center"
                }
        )

        self.tv_entry_serial_input.trace_variable("w", self.update_serial_input)
        self.tv2_reset_value = 750
        self.tv2_counter = tkinter.IntVar(self, value=self.tv2_reset_value)

        self.okay_to_rescan = tkinter.BooleanVar(self, value=True)
        self.okay_to_rescan_after_reset = 18000
        self.okay_to_rescan_after = tkinter.IntVar(self, value=0)

        self.accept_reset_value = 2500
        self.accept_counter = tkinter.IntVar(self, value=self.accept_reset_value)
        self.accepting_bool = tkinter.BooleanVar(self, value=True)
        self.serial_submission = tkinter.BooleanVar(self, value=False)
        self.serial_submission.trace_variable("w", self.update_serial_submission)

        # self.label_serial_input.grid(row=0, column=0, columnspan=1, rowspan=1)
        # self.entry_serial_input.grid(row=1, column=0, columnspan=1, rowspan=1)

        self.label_serial_input.pack(side=tkinter.TOP)
        self.entry_serial_input.pack(side=tkinter.TOP)
        self.x__1.pack(side=tkinter.TOP)
        self.x__3.pack(side=tkinter.TOP)

        self.bind("<KeyPress>", self.keypress)
        self.entry_serial_input.bind("<FocusIn>", self.update_entry_serial_input_focus)
        self.entry_serial_input.bind("<FocusOut>", self.update_entry_serial_input_focus)
        self.entry_serial_input.bind("<Return>", self.submit_entry_serial_input)

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

    def update_serial_input(self, *args):
        # print(f"update_serial_input, {self.tv2.get()}")
        self.tv2_counter.set(self.tv2_reset_value)
        self.count_down_serial_input()

    def count_down_serial_input(self, *args):
        v = self.tv2_counter.get()
        # print(f"{v=}")
        if v > 0:
            self.tv2_counter.set(v - 1)
            self.after(1, self.count_down_serial_input)
        elif v == 0:
            self.accepting_bool.set(False)
            self.submit_serial_entry()
            self.tv2_counter.set(-1)

    def submit_serial_entry(self, *args):
        if self.serial_submission.get():
            self.okay_to_rescan.set(False)
            self.okay_to_rescan_after.set(self.okay_to_rescan_after_reset)
            serial_in = self.tv_entry_serial_input.get()
            if serial_in:
                print(f"FINALLY ==> ({len(serial_in)}), '{serial_in}'\n{type(serial_in)=}")
                found = -1
                for idx, row in self.df_v_iti_items.iterrows():
                    # print(f"{row['Serial']=}, {type(row['Serial'])=}")
                    if row["Serial"] == serial_in:
                        found = idx
                self.accept_counter.set(self.tv2_reset_value)

                if found > -1:
                    foreground = rgb_to_hex(WILDERNESS_MINT)
                    row = self.df_v_iti_items.iloc[found]
                    print(f"found: {row=}")
                    self.handle_scan(found)
                    # self.accepting_bool.set(True)
                else:
                    foreground = rgb_to_hex(FIREBRICK_2)
                    ans = messagebox.askyesno("Serial Scan", f"Serial '{serial_in}' has not been entered yet.\nDo you want to create a new item with it?")
                    if ans:
                        self.begin_create_new_item()
                    else:
                        pass

                self.reset_accepting_vars()
                self.serial_submission.set(False)

                self.entry_serial_input.configure(foreground=foreground)

    def handle_scan(self, df_index):
        self.top_level_scan_handler = TopLevelScanHandler(self)
        row = self.df_v_iti_items.iloc[df_index]
        data = {
            "Quantity": row["Quantity"],
            "Assigned": row["Assigned"],
            "Maintenance": row["Maintenance"]
        }
        self.top_level_scan_handler.dnd_states.select_iti_item(data)
        # tv_entry_selected_item

    def update_serial_scan(self, *args):
        print(f"{args=}")
        # value = self.level_add_menu.tv_entry_serial.get()
        # if value:
        #     known_serials = self.df_v_iti_items["Serial"].unique()
        #     if value in known_serials:
        #         self.level_add_menu.error_in_serial()
        #         # raise ValueError(f"Error, this serial is already in use. {value=}")
        #         print(f"Error, this serial is already in use. '{value}'")
        #         return
        #
        # print(f"SERIAL AVAILABLE '{value}'")
        # self.level_add_menu.set_unit_serial()

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

    def update_counter_in(self, char):
        if self.accept_counter.get() <= 0:
            print(f"{self.entry_serial_input.focus_get()=}")
            self.tv_entry_serial_input.set(char + self.tv_entry_serial_input.get())
            self.entry_serial_input.icursor("end")
            self.serial_submission.set(True)
        else:
            self.after(1, self.update_counter_in, char)
            self.accept_counter.set(self.accept_counter.get() - 1)

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
                x = arg.widget != "<tkinter.Entry object .!entry>"
                character = arg.char if x else ""
                # character = arg.char
                print(f"{arg.widget=}, {str(self)=}, {x=}")
                # self.tv2.set(arg.char + self.tv2.get())
                print(f"I WANT TO ADD MISSING CHAR {character=} to str={self.tv_entry_serial_input.get()=}")
                self.update_counter_in(character)
                # self.tv2.set(self.tv2.get())
                # self.tv2.set(self.tv2.get())
                self.accepting_bool.set(False)
            # self.e1.icursor("end")
                self.entry_serial_input.focus()

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

    def count_down_serial_reset(self, *args):
        if self.okay_to_rescan_after.get() <= 0:
            self.okay_to_rescan.set(True)

    def update_serial_submission(self, *args):
        if self.serial_submission.get():
            self.after(1, self.count_down_serial_reset)
        else:
            self.okay_to_rescan_after.set(self.okay_to_rescan_after_reset)

    def update_entry_serial_input_focus(self, event):
        print(f"{event=}")

    def reset_accepting_vars(self):
        self.tv2_counter.set(self.tv2_reset_value)
        self.accept_counter.set(self.accept_reset_value)
        self.accepting_bool.set(True)

    def submit_entry_serial_input(self, *event):
        print(f"{event}")
