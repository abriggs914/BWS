import tkinter

from dnd_onv_states import DNDItemManager
from grid_manager import GridManager
from tkinter_utility import *
from utility import alpha_seq, dict_print


class AddItemMenu(tkinter.Toplevel):

    def __init__(
            self,
            master,
            spin_values_uom,
            spin_values_type,
            spin_values_cond,
            spin_values_computer,
            spin_values_peripherals,
            spin_values_network,
            spin_values_wire,
            spin_values_unknown,
            width=500,
            height=500,
            save_state=None
    ):
        super().__init__(master)

        self.valid_status_keys_order = ["name", "type", "sub_type", "cost", "uom", "submission", "quantity", "description", "condition", "serial"]
        self.valid_status_keys = set(self.valid_status_keys_order)
        self.status = tkinter.Variable(self, value={})  # populate this only on successful exit.
        self.valid = tkinter.Variable(self, value={})  # populate this one in all other instances.
        self.accept_serial = tkinter.BooleanVar(self, value=False)

        self.spin_values_uom = self.validate_values_spin_uom(spin_values_uom)
        self.spin_values_type = self.validate_values_spin_type(spin_values_type)
        self.spin_values_cond = self.validate_values_spin_cond(spin_values_cond)
        self.spin_values_computer = self.validate_values_spin_computer(spin_values_computer)
        self.spin_values_peripherals = self.validate_values_spin_peripherals(spin_values_peripherals)
        self.spin_values_network = self.validate_values_spin_network(spin_values_network)
        self.spin_values_wire = self.validate_values_spin_wire(spin_values_wire)
        self.spin_values_unknown = self.validate_values_spin_unknown(spin_values_unknown)
        self.save_state = save_state

        self.namer = alpha_seq(1000, prefix="w_AIM_")

        self.WIDTH, self.HEIGHT = width, height
        self.geometry(f"{self.WIDTH}x{self.HEIGHT}")
        self.title("Add New ITI Inventory")

        self.tv_entry_scannable_input,\
        self.label_scannable_input,\
        self.tv_entry_scannable_input,\
        self.entry_scannable_input\
            = entry_factory(
                self,
                tv_label="Scannable"
        )

        self.tv_entry_scannable_input.trace_variable("w", self.update_serial_input)
        self.tv2_reset_value = 750
        self.tv2_counter = tkinter.IntVar(self, value=self.tv2_reset_value)

        self.accept_reset_value = 2500
        self.accept_counter = tkinter.IntVar(self, value=self.accept_reset_value)
        self.accepting_bool = tkinter.BooleanVar(self, value=True)

        # Cancel button
        self.tv_btn_cancel_creation, \
        self.btn_cancel_creation \
            = button_factory(
                self,
                tv_btn="cancel",
                kwargs_btn={
                    "name": next(self.namer),
                    "command": self.click_cancel_creation
                }
        )

        # Clear button
        self.tv_btn_clear_fields, \
        self.btn_clear_fields \
            = button_factory(
                self,
                tv_btn="clear fields",
                kwargs_btn={
                    "name": next(self.namer),
                    "command": self.click_clear_fields
                }
        )

        # Submit button
        self.tv_btn_submit, \
        self.btn_submit \
            = button_factory(
                self,
                tv_btn="submit",
                kwargs_btn={
                    "name": next(self.namer),
                    "command": self.click_submit_creation
                }
        )

        # Name Entry
        self.tv_lbl_entry_name, \
        self.lbl_entry_name, \
        self.tv_entry_name, \
        self.entry_name \
            = entry_factory(
                self,
                tv_label="Name:",
                kwargs_label={
                    "name": next(self.namer)
                },
                kwargs_entry={
                    "name": next(self.namer),
                    "justify": "center"
                }
        )

        # Description Entry
        self.tv_lbl_entry_desc, \
        self.lbl_entry_desc, \
        self.tv_entry_desc, \
        self.entry_desc \
            = entry_factory(
                self,
                tv_label="Description:",
                kwargs_label={
                    "name": next(self.namer)
                },
                kwargs_entry={
                    "name": next(self.namer)
                }
        )

        # UOM SpinBox
        self.tv_lbl_uom,\
        self.lbl_uom\
            = label_factory(
                self,
                tv_label="UoM:",
                kwargs_label={
                    "name": next(self.namer)
                }
        )
        self.tv_spin_uom = tkinter.StringVar(self)
        self.spin_uom = tkinter.Spinbox(
            self,
            name=next(self.namer),
            values=self.spin_values_uom["list_values"],
            textvariable=self.tv_spin_uom,
            justify="center"
        )

        # Type SpinBox
        self.tv_lbl_type, \
        self.lbl_type \
            = label_factory(
                self,
                tv_label="Type:",
                kwargs_label={
                    "name": next(self.namer)
                }
        )
        self.tv_spin_type = tkinter.StringVar(self)
        self.spin_type = tkinter.Spinbox(
            self,
            name=next(self.namer),
            values=self.spin_values_type["list_values"],
            textvariable=self.tv_spin_type,
            justify="center"
        )

        # SubType SpinBox
        self.tv_lbl_subtype, \
        self.lbl_subtype \
            = label_factory(
                self,
                tv_label="Sub-Type:",
                kwargs_label={
                    "name": next(self.namer)
                }
        )
        self.tv_spin_subtype = tkinter.StringVar(self)
        self.spin_subtype = tkinter.Spinbox(
            self,
            name=next(self.namer),
            values=self.spin_values_unknown["list_values"],
            textvariable=self.tv_spin_subtype,
            justify="center"
        )

        # Quantity SpinBox
        self.tv_lbl_qty,\
        self.lbl_qty\
            = label_factory(
                self,
                tv_label="Quantity:",
                kwargs_label={
                    "name": next(self.namer)
                }
        )
        self.tv_spin_qty = tkinter.StringVar(self)
        self.spin_qty = tkinter.Spinbox(
            self,
            name=next(self.namer),
            values=list(map(str, [1])),
            textvariable=self.tv_spin_qty,
            state="disabled",
            justify="center"
        )

        # Condition SpinBox
        self.tv_lbl_cond,\
        self.lbl_cond\
            = label_factory(
                self,
                tv_label="Condition:",
                kwargs_label={
                    "name": next(self.namer)
                }
        )
        self.tv_spin_cond = tkinter.StringVar(self)
        self.spin_cond = tkinter.Spinbox(
            self,
            name=next(self.namer),
            values=self.spin_values_cond["list_values"],
            textvariable=self.tv_spin_cond,
            justify="center"
        )

        self.tv_label_serial,\
        self.label_serial,\
        self.tv_entry_serial,\
        self.entry_serial\
            = entry_factory(
            self,
            tv_label="Scan Serial #",
            kwargs_label={
                "name":next(self.namer)
            },
            kwargs_entry={
                "name":next(self.namer)
            }
        )

        # Grid Manage Widgets
        self.gm1 = GridManager()
        self.gm1.grid_widgets([
            [
                self.lbl_entry_name,
                {
                    "widget": self.entry_name,
                    "columnspan": 2
                }
            ],
            [
                self.lbl_type,
                {
                    "widget": self.spin_type,
                    "columnspan": 2
                }
            ],
            [
                self.lbl_subtype,
                {
                    "widget": self.spin_subtype,
                    "columnspan": 2
                }
            ],
            [
                self.lbl_cond,
                {
                    "widget": self.spin_cond,
                    "columnspan": 2
                }
            ],
            [
                self.lbl_qty,
                {
                    "widget": self.spin_qty,
                    "columnspan": 2
                }
            ],
            [
                self.lbl_uom,
                {
                    "widget": self.spin_uom,
                    "columnspan": 2
                }
            ],
            [
                {
                    "widget": self.lbl_entry_desc,
                    "columnspan": 3
                }
            ],
            [
                {
                    "widget": self.entry_desc,
                    "columnspan": 3,
                    "sticky": "nsew"
                }
            ],
            [
                self.label_serial,
                {
                    "widget": self.entry_serial,
                    "columnspan": 2
                }
            ],
            [
                self.btn_cancel_creation,
                self.btn_clear_fields,
                self.btn_submit
            ]
        ])

        self.tv_spin_type.trace_variable("w", self.update_type)
        self.bind("<KeyPress>", self.change_key_press)

        if self.save_state:
            self.tv_entry_name.set(self.save_state.get("name", ""))
            self.tv_spin_type.set(self.save_state.get("type", "UNKNOWN"))
            self.tv_spin_subtype.set(self.save_state.get("sub_type", "UNKNOWN"))
            self.tv_spin_cond.set(self.save_state.get("condition", "UNKNOWN"))
            self.tv_spin_uom.set(self.save_state.get("uom", "UNKNOWN"))
            self.tv_entry_desc.set(self.save_state.get("description", ""))
            self.tv_spin_qty.set(self.save_state.get("quantity", ""))

    def validate_values_spin_uom(self, spin_values_uom):
        res = {
            "iids": [],
            "names": [],
            "suffixes": [],
            "list_values": []
        }
        for row in spin_values_uom:
            iid, name, suffix, *rest = row.split("||")
            res["iids"].append(iid)
            res["names"].append(name)
            res["suffixes"].append(suffix)
            res["list_values"].append(name)
        res["list_values"].sort(key=lambda v: "" if v == "UNKNOWN" else v)
        return res

    def validate_values_spin_type(self, spin_values_type):
        res = {
            "iids": [],
            "names": [],
            "list_values": []
        }
        for row in spin_values_type:
            iid, name, *rest = row.split("||")
            res["iids"].append(iid)
            res["names"].append(name)
            res["list_values"].append(name)
        res["list_values"].sort(key=lambda v: "" if v == "UNKNOWN" else v)
        return res

    def validate_values_spin_cond(self, spin_values_cond):
        res = {
            "iids": [],
            "names": [],
            "list_values": []
        }
        for row in spin_values_cond:
            iid, name, *rest = row.split("||")
            res["iids"].append(iid)
            res["names"].append(name)
            res["list_values"].append(name)
        res["list_values"].sort(key=lambda v: "" if v == "UNKNOWN" else v)
        return res

    def validate_values_spin_computer(self, spin_values_computer):
        res = {
            "iids": [],
            "names": [],
            "list_values": []
        }
        for row in spin_values_computer:
            iid, name, *rest = row.split("||")
            res["iids"].append(iid)
            res["names"].append(name)
            res["list_values"].append(name)
        res["list_values"].sort(key=lambda v: "" if v == "UNKNOWN" else v)
        return res

    def validate_values_spin_peripherals(self, spin_values_peripherals):
        res = {
            "iids": [],
            "names": [],
            "list_values": []
        }
        for row in spin_values_peripherals:
            iid, name, *rest = row.split("||")
            res["iids"].append(iid)
            res["names"].append(name)
            res["list_values"].append(name)
        res["list_values"].sort(key=lambda v: "" if v == "UNKNOWN" else v)
        return res

    def validate_values_spin_network(self, spin_values_network):
        res = {
            "iids": [],
            "names": [],
            "list_values": []
        }
        for row in spin_values_network:
            iid, name, *rest = row.split("||")
            res["iids"].append(iid)
            res["names"].append(name)
            res["list_values"].append(name)
        res["list_values"].sort(key=lambda v: "" if v == "UNKNOWN" else v)
        return res

    def validate_values_spin_wire(self, spin_values_wire):
        res = {
            "iids": [],
            "names": [],
            "list_values": []
        }
        for row in spin_values_wire:
            iid, name, *rest = row.split("||")
            res["iids"].append(iid)
            res["names"].append(name)
            res["list_values"].append(name)
        res["list_values"].sort(key=lambda v: "" if v == "UNKNOWN" else v)
        return res

    def validate_values_spin_unknown(self, spin_values_unknown):
        res = {
            "iids": [],
            "names": [],
            "list_values": []
        }
        for row in spin_values_unknown:
            iid, name, *rest = row.split("||")
            res["iids"].append(iid)
            res["names"].append(name)
            res["list_values"].append(name)
        res["list_values"].sort(key=lambda v: "" if v == "UNKNOWN" else v)
        return res

    def update_type(self, *args):
        ttype = self.tv_spin_type.get()
        iid = self.spin_values_type["names"].index(ttype) + 1
        self.tv_spin_subtype.set("UNKNOWN")
        match iid:
            case 2:
                # ITI Computer
                values = self.spin_values_computer["list_values"]
            case 3:
                # ITI Peripherals
                values = self.spin_values_peripherals["list_values"]
            case 4:
                # ITI Network
                values = self.spin_values_network["list_values"]
            case 5:
                # ITI Wire
                values = self.spin_values_wire["list_values"]
            case _:
                # ITI Unknown
                values = self.spin_values_unknown["list_values"]

        self.spin_subtype["values"] = values

    # def update_serial(self, *args):
    #     value = self.tv_entry_serial.get()
    #     if value:


    def validate(self):
        print(f"validate")
        name = self.tv_entry_name.get()
        description = self.tv_entry_desc.get()
        uom = self.tv_spin_uom.get()
        ttype = self.tv_spin_type.get()
        stype = self.tv_spin_subtype.get()
        cost = 0
        quantity = int(self.tv_spin_qty.get())
        condition = self.tv_spin_cond.get()
        serial = self.tv_entry_serial.get()
        keys = self.valid_status_keys
        valid = {"submission": False, "quantity": quantity, "description": description, "is_active": 1}

        # validating name field
        if name is not None and len(name):
            valid.update({"name": name})

        # validating type field
        if ttype is not None and len(ttype):
            ttype = self.spin_values_type["names"].index(ttype) + 1
            valid.update({"type": ttype})

        # validating subtype field
        if stype is not None and len(stype):
            match ttype:
                case 2:
                    stype = self.spin_values_computer["names"].index(stype)
                case 3:
                    stype = self.spin_values_peripherals["names"].index(stype)
                case 4:
                    stype = self.spin_values_network["names"].index(stype)
                case 5:
                    stype = self.spin_values_wire["names"].index(stype)
                case _:
                    stype = self.spin_values_unknown["names"].index(stype)
            stype += 1
            valid.update({"sub_type": stype})

        # validating uom field
        if uom is not None and len(uom):
            uom = self.spin_values_uom["names"].index(uom) + 1
            valid.update({"uom": uom})

        # validating condition field
        if condition is not None and len(condition):
            condition = self.spin_values_cond["names"].index(condition) + 1
            valid.update({"condition": condition})

        # validating cost
        valid.update({"cost": cost})

        # validating serial
        valid.update({"serial": serial})

        print(f"{valid=}, {(not keys.difference(valid))=}, {list(valid.values())=}")
        self.valid.set(valid)
        return not keys.difference(valid) and all([len(str(v)) != 0 for k, v in valid.items() if k != "description"])

    def click_clear_fields(self):
        print(f"click_clear_fields")
        self.tv_entry_name.set("")
        self.tv_spin_uom.set("UNKNOWN")
        self.tv_spin_type.set("UNKNOWN")
        self.tv_spin_subtype.set("UNKNOWN")
        self.tv_spin_cond.set("UNKNOWN")
        self.tv_entry_desc.set("")
        self.tv_entry_serial.set("")

    def click_cancel_creation(self):
        print(f"click_cancel_creation")
        self.validate()
        self.status.set(eval(self.valid.get()))
        self.destroy()

    def click_submit_creation(self):
        print(f"click_submit_creation")
        if self.validate():
            print(f"VALID!")
            valid = eval(self.valid.get())
            valid.update({"submission": True})
            self.status.set(valid)
            self.destroy()
        else:
            valid = eval(self.valid.get())
            print(f"<ELSE> HERE IS WHAT IS VALID\n {valid}")
            if valid.get("name", None) is None:
                self.entry_name.focus()

                # messagebox.showinfo(title="Error", message="Please enter a name first.")
        # if not self.valid_status_keys.difference(self.status.get()):
            # all keys validated correctly

    def set_unit_serial(self):
        valid = eval(self.valid.get())
        valid.update({"serial": self.tv_entry_serial.get()})
        self.status.set(valid)
        self.entry_serial.configure(foreground="black")
        self.accept_serial.set(True)

    def error_in_serial(self):
        self.entry_serial.configure(foreground="red")
        self.accept_serial.set(False)

    def change_key_press(self, *args):
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
                print(f"I WANT TO ADD MISSING CHAR {arg.char=} to str={self.tv_entry_scannable_input.get()=}")
                self.update_counter_in(arg.char, self.tv2_reset_value)
                # self.tv2.set(self.tv2.get())
                # self.tv2.set(self.tv2.get())
                self.accepting_bool.set(False)
            # self.e1.icursor("end")
                self.entry_scannable_input.focus()

    def update_serial_input(self, *args):
        print(f"update_serial_input, {self.tv_entry_scannable_input.get()}")
        self.tv2_counter.set(self.tv2_reset_value)
        self.count_down_serial_input()

    def count_down_serial_input(self, *args):
        v = self.tv2_counter.get()
        # print(f"{v=}")
        if v > 0:
            self.tv2_counter.set(v - 1)
            self.after(1, self.count_down_serial_input)
        elif v == 0:
            self.submit_serial_entry()
            self.tv2_counter.set(-1)

    def update_counter_in(self, char, t):
        if t <= 0:
            self.tv_entry_scannable_input.set(char + self.tv_entry_scannable_input.get())
            self.entry_scannable_input.icursor("end")
        else:
            self.after(1, self.update_counter_in, char, t - 1)

    def submit_serial_entry(self):
        print("submit_serial_entry")
        serial_in = self.tv_entry_scannable_input.get()
        print(f"FINALLY ==> ({len(serial_in)}), '{serial_in}'\n{type(serial_in)=}")


class TopLevelDNDMenu(tkinter.Toplevel):

    def __init__(
            self,
            master,
            df_status,
            df_serial_indication,
            omit_server=False,
            omit_in_use=False,
            omit_disposed=False,
            omit_broken=False,
            omit_shopping_cart=False,
            omit_unknown=False
    ):
        super().__init__(master)

        self.df_status = df_status
        self.df_serial_indication = df_serial_indication

        self.omit_server = omit_server
        self.omit_in_use = omit_in_use
        self.omit_disposed = omit_disposed
        self.omit_broken = omit_broken
        self.omit_shopping_cart = omit_shopping_cart
        self.omit_unknown = omit_unknown

        self.tv_set_data = tkinter.Variable(self, value={})

        self.frame_data_fields = tkinter.Frame(self)
        self.frame_data_fields_row_1 = tkinter.Frame(self.frame_data_fields)
        self.frame_data_fields_row_2 = tkinter.Frame(self.frame_data_fields)
        self.frame_data_fields_row_3 = tkinter.Frame(self.frame_data_fields)

        # column 1
        self.frame_data_fields_row_1_col_1 = tkinter.Frame(self.frame_data_fields_row_1)
        self.frame_data_fields_row_2_col_1 = tkinter.Frame(self.frame_data_fields_row_2)
        self.frame_data_fields_row_3_col_1 = tkinter.Frame(self.frame_data_fields_row_3)

        # column 2
        self.frame_data_fields_row_1_col_2 = tkinter.Frame(self.frame_data_fields_row_1)
        self.frame_data_fields_row_2_col_2 = tkinter.Frame(self.frame_data_fields_row_2)
        self.frame_data_fields_row_3_col_2 = tkinter.Frame(self.frame_data_fields_row_3)

        # column 3
        self.frame_data_fields_row_1_col_3 = tkinter.Frame(self.frame_data_fields_row_1)

        self.tv_label_item_name, self.label_item_name,\
        self.tv_entry_item_name, self.entry_item_name\
            = None, None, None, None

        self.tv_label_item_desc, self.label_item_desc,\
        self.tv_entry_item_desc, self.entry_item_desc\
            = None, None, None, None

        self.tv_label_item_condition, self.label_item_condition,\
        self.tv_entry_item_condition, self.entry_item_condition\
            = None, None, None, None

        self.tv_label_item_status, self.label_item_status,\
        self.tv_entry_item_status, self.entry_item_status\
            = None, None, None, None

        self.tv_label_item_type, self.label_item_type,\
        self.tv_entry_item_type, self.entry_item_type\
            = None, None, None, None

        self.tv_label_item_sub_type, self.label_item_sub_type,\
        self.tv_entry_item_sub_type, self.entry_item_sub_type\
            = None, None, None, None

        self.tv_label_item_is_active, self.label_item_is_active,\
        self.tv_entry_item_is_active, self.entry_item_is_active\
            = None, None, None, None

        self.init_data_fields()

        self.canvas_dnd = DNDItemManager(
            self,
            omit_server=self.omit_server,
            omit_in_use=self.omit_in_use,
            omit_disposed=self.omit_disposed,
            omit_broken=self.omit_broken,
            omit_shopping_cart=self.omit_shopping_cart,
            omit_unknown=self.omit_unknown
        )

        self.entry_scannable = ScannableEntry(self)
        self.entry_scannable.set_scan_pass_through()

        # Add widgets
        self.frame_data_fields.pack()

        self.frame_data_fields_row_1.pack()
        self.frame_data_fields_row_2.pack()
        self.frame_data_fields_row_3.pack()

        self.frame_data_fields_row_1_col_1.pack(side=tkinter.LEFT)
        self.label_item_name.pack(side=tkinter.LEFT)
        self.entry_item_name.pack(side=tkinter.LEFT)

        self.frame_data_fields_row_2_col_1.pack(side=tkinter.LEFT)
        self.label_item_desc.pack(side=tkinter.LEFT)
        self.entry_item_desc.pack(side=tkinter.LEFT)

        self.frame_data_fields_row_3_col_1.pack(side=tkinter.LEFT)
        self.label_item_condition.pack(side=tkinter.LEFT)
        self.entry_item_condition.pack(side=tkinter.LEFT)

        self.frame_data_fields_row_1_col_2.pack(side=tkinter.LEFT)
        self.label_item_status.pack(side=tkinter.LEFT)
        self.entry_item_status.pack(side=tkinter.LEFT)

        self.frame_data_fields_row_2_col_2.pack(side=tkinter.LEFT)
        self.label_item_type.pack(side=tkinter.LEFT)
        self.entry_item_type.pack(side=tkinter.LEFT)

        self.frame_data_fields_row_3_col_2.pack(side=tkinter.LEFT)
        self.label_item_sub_type.pack(side=tkinter.LEFT)
        self.entry_item_sub_type.pack(side=tkinter.LEFT)

        self.frame_data_fields_row_1_col_3.pack(side=tkinter.LEFT)
        self.label_item_is_active.pack(side=tkinter.LEFT)
        self.entry_item_is_active.pack(side=tkinter.LEFT)

        self.canvas_dnd.pack()
        self.entry_scannable.pack()

    def init_data_fields(self):
        self.tv_label_item_name, \
        self.label_item_name, \
        self.tv_entry_item_name, \
        self.entry_item_name \
            = entry_factory(
            self.frame_data_fields_row_1_col_1,
            tv_label="Item Name:",
            kwargs_entry={
                "justify": "center",
                "font": ("Arial", 14),
                "state": "disabled"
            }
        )

        self.tv_label_item_desc, \
        self.label_item_desc, \
        self.tv_entry_item_desc, \
        self.entry_item_desc \
            = entry_factory(
            self.frame_data_fields_row_2_col_1,
            tv_label="Item Description:",
            kwargs_entry={
                "justify": "center",
                "font": ("Arial", 14),
                "state": "disabled"
            }
        )

        self.tv_label_item_condition, \
        self.label_item_condition, \
        self.tv_entry_item_condition, \
        self.entry_item_condition \
            = entry_factory(
            self.frame_data_fields_row_3_col_1,
            tv_label="Condition:",
            kwargs_entry={
                "justify": "center",
                "font": ("Arial", 14),
                "state": "disabled"
            }
        )

        self.tv_label_item_status, \
        self.label_item_status, \
        self.tv_entry_item_status, \
        self.entry_item_status \
            = entry_factory(
            self.frame_data_fields_row_1_col_2,
            tv_label="Status:",
            kwargs_entry={
                "justify": "center",
                "font": ("Arial", 14),
                "state": "disabled"
            }
        )

        self.tv_label_item_type, \
        self.label_item_type, \
        self.tv_entry_item_type, \
        self.entry_item_type \
            = entry_factory(
            self.frame_data_fields_row_2_col_2,
            tv_label="Type:",
            kwargs_entry={
                "justify": "center",
                "font": ("Arial", 14),
                "state": "disabled"
            }
        )

        self.tv_label_item_sub_type, \
        self.label_item_sub_type, \
        self.tv_entry_item_sub_type, \
        self.entry_item_sub_type \
            = entry_factory(
            self.frame_data_fields_row_3_col_2,
            tv_label="Sub-Type:",
            kwargs_entry={
                "justify": "center",
                "font": ("Arial", 14),
                "state": "disabled"
            }
        )

        self.tv_label_item_is_active, \
        self.label_item_is_active, \
        self.tv_entry_item_is_active, \
        self.entry_item_is_active \
            = entry_factory(
            self.frame_data_fields_row_1_col_3,
            tv_label="Is Active:",
            kwargs_entry={
                "justify": "center",
                "font": ("Arial", 14),
                "state": "disabled"
            }
        )

    # def update_entry_scannable(self, *args):
    #     scan_in = self.entry_scannable.validated_text.get()
    #     if scan_in:
    #         result_is_status = self.is_status(scan_in)
    #         if not result_is_status.empty:
    #             self.canvas_dnd.animate()

    def is_status(self, scan_in):
        return self.df_serial_indication[self.df_serial_indication["Serial"] == scan_in]

    def set_data(self, data_in):
        self.tv_set_data.set(data_in)
        self.tv_entry_item_name.set(data_in.get("Name", "N/A"))
        self.tv_entry_item_desc.set(data_in.get("Description", "N/A"))
        self.tv_entry_item_condition.set(data_in.get("ConditionName", "N/A"))
        self.tv_entry_item_status.set(data_in.get("StatusName", "N/A"))
        self.tv_entry_item_type.set(data_in.get("TypeName", "N/A"))
        self.tv_entry_item_sub_type.set(data_in.get("SubTypeName", "N/A"))
        self.tv_entry_item_is_active.set(data_in.get("IsActive", "N/A"))

        qty_unknown = data_in.get("qty_unknown", 0)
        qty_cart = data_in.get("qty_cart", 0)
        qty_server = data_in.get("qty_server", 0)
        qty_in_use = data_in.get("qty_in_use", 0)
        qty_broken = data_in.get("qty_broken", 0)
        qty_disposed = data_in.get("qty_disposed", 0)

        self.canvas_dnd.iv_unknown_number.set(qty_unknown)
        self.canvas_dnd.iv_shopping_cart_number.set(qty_cart)
        self.canvas_dnd.iv_server_room_number.set(qty_server)
        self.canvas_dnd.iv_in_use_number.set(qty_in_use)
        self.canvas_dnd.iv_broken_number.set(qty_broken)
        self.canvas_dnd.iv_disposed_number.set(qty_disposed)

        print(dict_print(data_in, "Data_in"))

