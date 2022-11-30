import tkinter

import pandas

from top_level_scan_handler import TopLevelScanHandler
from grid_manager import GridManager
from colour_utility import *
from tkinter_utility import *
from inventory_queries import *
from menus import AddItemMenu, TopLevelDNDMenu
from utility import alpha_seq, dict_print, replace_timestamp_datetime
from dnd_onv_states import DNDItemManagerStatus


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
        self.df_buildings = None
        self.df_locations = None
        self.df_customers = None
        self.df_departments = None
        self.df_loc_emp_bld_dpt = None
        self.df_v_serial_indication = None

        self.populate_data()

        self.data_current = tkinter.Variable(self, value={})

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
                ,self.df_buildings
                ,self.df_locations
                ,self.df_customers
                ,self.df_departments
                ,self.df_loc_emp_bld_dpt
                ,self.df_v_serial_indication
            ]
             ]), "Error loading some data."

        self.tl_add_menu = None
        self.tl_dnd_menu = None
        self.data_tl_dnd_menu = None

        self.new_item_save_state = tkinter.Variable(self, value={})

        self.tv_label_input = tkinter.StringVar(self, value="Scan a Barcode Here:")
        self.label_scan_input = tkinter.Label(self, textvariable=self.tv_label_input)
        self.entry_scan_input = ScannableEntry(self)

        print(f"after creation")
        print(f"{self.bind()=}")
        print(f"{self.entry_scan_input.entry.bind()=}")

        self.entry_scan_input.set_scan_pass_through()

        # self.tv_entry_barcode = tkinter.StringVar(self, value="")
        # self.entry_barcode = tkinter.Entry(
        #     self,
        #     textvariable=self.tv_entry_barcode,
        #     state="disabled",
        #     font=("Code39AzaleaNarrow3", 14)
        # )

        self.label_scan_input.pack()
        self.entry_scan_input.pack()

        self.entry_scan_input.validated_text.trace_variable("w", self.submit_scan)

        self.bind_demo_keys()

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
        self.df_buildings = connect(**SQL_ITI_BUILDINGS)
        self.df_locations = connect(**SQL_ITI_LOCATIONS)
        self.df_customers = connect(**SQL_ITR_CUSTOMERS)
        self.df_departments = connect(**SQL_DEPARTMENTS)

        self.df_loc_emp_bld_dpt = pandas.merge(
            pandas.merge(
                pandas.merge(
                    self.df_locations,
                    self.df_customers,
                    left_on="EmployeeAssigned",
                    how="left",
                    right_on="CustomerID",
                    suffixes=("_[ITI Locations]", "_[ITR Customers]")
                ),
                self.df_buildings,
                left_on="BuildingID",
                how="left",
                right_on="ID",
                suffixes=("_[A]", "_[ITI Buildings]")
            ),
            self.df_departments,
            how="left",
            left_on="Department",
            right_on="DeptID",
            suffixes=("_[B]", "_[Dept]")
        )

        self.df_loc_emp_bld_dpt.rename(
            columns={
                'Name_x': 'Loc. Name',
                'Name': 'Bldng',
                'Name_y': 'Emp. Name'
            },
            inplace=True
        )

        self.df_v_serial_indication = connect(**SQL_V_ITI_SERIAL_INDICATION)

        # self.df_loc_emp_bld_dpt = pandas.merge(
        #     pandas.merge(
        #         pandas.merge(
        #             pandas.merge(
        #                 self.df_locations,
        #                 self.df_customers,
        #                 left_on="EmployeeAssigned",
        #                 how="left",
        #                 right_on="CustomerID",
        #                 suffixes=("_[ITI Locations]", "_[ITR Customers]")
        #             ),
        #             self.df_buildings,
        #             left_on="BuildingID",
        #             how="left",
        #             right_on="ID",
        #             suffixes=("_[A]", "_[ITI Buildings]")
        #         ),
        #         self.df_departments,
        #         how="left",
        #         left_on="Department",
        #         right_on="DeptID",
        #         suffixes=("_[B]", "_[Dept]")
        #     ),
        #     self.df_serial_indication,
        #     left_on=
        #
        # self.df_loc_emp_bld_dpt.rename(
        #     columns={
        #         'Name_x': 'Loc. Name',
        #         'Name': 'Bldng',
        #         'Name_y': 'Emp. Name'
        #     },
        #     inplace=True
        # )

    def bind_demo_keys(self):
        self.bind("<Control-Shift-KeyPress-Q>", self.insert_demo_value_main_menu)
        self.bind("<Control-Shift-KeyPress-q>", self.insert_demo_value_main_menu)

        # New item
        self.bind("<Control-Shift-KeyPress-W>", self.insert_demo_value_new_item)
        self.bind("<Control-Shift-KeyPress-w>", self.insert_demo_value_new_item)

    def unbind_demo_keys(self):
        self.unbind("<Control-Shift-KeyPress-Q>")
        self.unbind("<Control-Shift-KeyPress-q>")

        # New item
        self.unbind("<Control-Shift-KeyPress-W>")
        self.unbind("<Control-Shift-KeyPress-w>")

    def bind_demo_keys_tl_dnd(self):
        # Status
        self.tl_dnd_menu.bind("<Control-Shift-KeyPress-Q>", self.insert_demo_value_tl_dnd_menu_status)
        self.tl_dnd_menu.bind("<Control-Shift-KeyPress-q>", self.insert_demo_value_tl_dnd_menu_status)

        # Locations
        self.tl_dnd_menu.bind("<Control-Shift-KeyPress-W>", self.insert_demo_value_tl_dnd_menu_location)
        self.tl_dnd_menu.bind("<Control-Shift-KeyPress-w>", self.insert_demo_value_tl_dnd_menu_location)

    def unbind_demo_keys_tl_dnd(self):
        # Status
        self.tl_dnd_menu.unbind("<Control-Shift-KeyPress-Q>")
        self.tl_dnd_menu.unbind("<Control-Shift-KeyPress-q>")

        # Locations
        self.tl_dnd_menu.unbind("<Control-Shift-KeyPress-Q>")
        self.tl_dnd_menu.unbind("<Control-Shift-KeyPress-q>")

    def bind_demo_keys_tl_add(self):
        # Status
        self.tl_add_menu.bind("<Control-Shift-KeyPress-Q>", self.insert_demo_value_tl_add_menu_status)
        self.tl_add_menu.bind("<Control-Shift-KeyPress-q>", self.insert_demo_value_tl_add_menu_status)

        # Locations
        self.tl_add_menu.bind("<Control-Shift-KeyPress-W>", self.insert_demo_value_tl_add_menu_location_server_room)
        self.tl_add_menu.bind("<Control-Shift-KeyPress-w>", self.insert_demo_value_tl_add_menu_location_server_room)
        self.tl_add_menu.bind("<Control-Shift-KeyPress-R>", self.insert_demo_value_tl_add_menu_location_averys_office)
        self.tl_add_menu.bind("<Control-Shift-KeyPress-r>", self.insert_demo_value_tl_add_menu_location_averys_office)

    def unbind_demo_keys_tl_add(self):
        # Status
        self.tl_add_menu.unbind("<Control-Shift-KeyPress-Q>")
        self.tl_add_menu.unbind("<Control-Shift-KeyPress-q>")

        # Locations
        self.tl_add_menu.unbind("<Control-Shift-KeyPress-Q>")
        self.tl_add_menu.unbind("<Control-Shift-KeyPress-q>")

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
        """Root scan in listener"""
        print(f"root.submit scan")
        scan_in = self.entry_scan_input.validated_text.get()
        if scan_in:
            scan_in = "*" + self.entry_scan_input.validated_text.get() + "*"
            # self.tv_entry_barcode.set(scan_in)
            print(f"{scan_in=}")
            is_indication_result = self.is_indication_serial(scan_in)
            is_indication = not is_indication_result.empty  # this serial was found in the list of known serial indications.
            print(f"{is_indication=}")
            # print(f"{is_indication_result=}")
            if not is_indication:
                self.unbind_demo_keys()
                self.entry_scan_input.stop_scan_pass_through()
                is_known_item_result = self.is_known_serial(scan_in[1:-1])
                is_known_item = not is_known_item_result.empty  # this serial was found in the list of known item serials.
                print(f"{is_known_item=}")
                if is_known_item:
                    # open dnd menu to handle the movements
                    self.open_dnd(scan_in[1:-1])
                else:
                    if len(scan_in[1:-1]) == 10:
                        print(f"make a new entry with {scan_in=}")
                        self.begin_create_new_item()
            else:
                messagebox.showinfo(title="Scan in", message="This serial is an indication serial")

    def begin_create_new_item(self):
        print("CREATE NEW ITEM")
        print(f"begin_create_new_item")
        print(f"{self.bind()=}")
        print(f"{self.entry_scan_input.entry.bind()=}")
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
        self.tl_add_menu = AddItemMenu(
            self,
            spin_values_uom=values_uom,
            spin_values_type=values_type,
            spin_values_cond=values_condition,
            spin_values_computer=values_computer,
            spin_values_peripherals=values_peripherals,
            spin_values_network=values_network,
            spin_values_wire=values_wire,
            spin_values_unknown=values_unknown,
            df_locations=self.df_loc_emp_bld_dpt,
            save_state=save_state
        )
        self.tl_add_menu.status.trace_variable("w", self.submit_new_item)
        self.tl_add_menu.entry_scannable_input.text.trace_variable("w", self.tl_add_menu_update_serial_scan)
        self.tl_add_menu.quit_condition.trace_variable("w", update_tl_add_menu_quit_condition)

        self.tl_add_menu.treeview_location.bind("<<TreeviewSelect>>", self.tl_add_menu_treeview_select)
        self.unbind_demo_keys()
        self.bind_demo_keys_tl_add()
        apply_state(self.entry_scan_input, "disabled", "down")
        self.tl_add_menu.protocol("WM_DELETE_WINDOW", self.closing_tl_add)
        # self.tl_add_menu.mainloop()
        # self.accepting_bool.set(True)

    def is_status_indication_serial(self, serial_in):
        return self.df_serial_indication[(self.df_serial_indication["Serial"] == serial_in) & (self.df_serial_indication["TableName"] == "ITI Status")]

    def is_location_indication_serial(self, serial_in):
        return self.df_serial_indication[(self.df_serial_indication["Serial"] == serial_in) & (self.df_serial_indication["TableName"] == "ITI Locations")]

    def is_indication_serial(self, serial_in):
        return self.df_serial_indication[self.df_serial_indication["Serial"] == serial_in]

    def is_known_serial(self, serial_in):
        return self.df_iti_item[self.df_iti_item["Serial"] == serial_in]

    def gather_dnd_data(self, scan_in):
        # only known item serials should be used at this point.
        data = self.is_known_serial(scan_in)
        print(f"{data=}, {type(data)=}")
        # result = {}
        # row = data.iloc[0]
        result = dict(zip(data.keys().tolist(), data.values[0].tolist()))
        if result["ID"]:
            idx = result['ID'] - 1
        if result["Condition"]:
            idx = result['Condition'] - 1
            result.update({"ConditionName": self.df_condition.iloc[idx]["Name"]})
        if result["Status"]:
            idx = result['Status'] - 1
            result.update({"StatusName": self.df_status.iloc[idx]["Name"]})
        if result["Type"]:
            idx = result['Type'] - 1
            result.update({"TypeName": self.df_type.iloc[idx]["Name"]})

        location_id = result["LocationID"]

        # locationID, Name, Floor#, gridRow, gridCol, Description, EmployeeAssigned
        # BuildingID, Name, Address, Province, Floors
        row_location = self.df_locations[self.df_locations["ID"] == location_id]
        if not row_location.empty:
            row_location = dict(zip(row_location.keys().tolist(), row_location.values[0].tolist()))
            result.update({
                "location_name": row_location["Name"],
                "location_floor": int(row_location["FloorNumber"]),
                "location_g_row": row_location["GridRow"],
                "location_g_col": row_location["GridCol"],
                "location_desc": row_location["Description"],
                "location_emp_assigned": row_location["EmployeeAssigned"],
                "BuildingID": row_location["BuildingID"]
            })
            building_id = result["BuildingID"]
            row_building = self.df_buildings[self.df_buildings["ID"] == building_id]
            if not row_building.empty:
                row_building = dict(zip(row_building.keys().tolist(), row_building.values[0].tolist()))
                result.update({
                    "building_name": row_building["Name"],
                    "building_address": row_building["Address"],
                    "building_province": row_building["Province"],
                    "building_floors": int(row_building["Floors"])
                })

            employee_id = result["location_emp_assigned"]
            row_employee = self.df_customers[self.df_customers["CustomerID"] == employee_id]
            if not row_employee.empty:
                row_employee = dict(zip(row_employee.keys().tolist(), row_employee.values[0].tolist()))
                result.update({
                    "employee_name": row_employee["Name"],
                    "employee_department": row_employee["Department"],
                    "employee_company": row_employee["Company"],
                    "employee_email": row_employee["Email"],
                    "employee_work_phone": row_employee["WorkPhone"],
                    "employee_active": row_employee["Active"]
                })

                department_id = result["employee_department"]
                row_department = self.df_departments[self.df_departments["DeptID"] == department_id]
                if not row_department.empty:
                    row_department = dict(zip(row_department.keys().tolist(), row_department.values[0].tolist()))
                    result.update({
                        "department_name": row_department["Dept"]
                    })

        sub_type_id = result["SubType"] - 1
        # sub_type_row_data = self.df_type.iloc[sub_type_id]
        df = eval(f"self.df_{result['TypeName']}".lower())
        print(f"{df=}")
        result.update({"SubTypeName": df.iloc[sub_type_id]["Name"]})

        qty_unknown = 1 if result["IsMissing"] not in [None, "None", 0] else 0
        qty_cart = 1
        qty_in_use = 1 if result["IsAssigned"] not in [None, "None", 0] else 0
        qty_broken = 1 if result["IsBroken"] not in [None, "None", 0] else 0
        qty_disposed = 1 if result["IsActive"] in [None, "None", 0, False, "False"] else 0
        qty_server = 1 if sum([qty_unknown, qty_in_use, qty_broken, qty_disposed]) == 0 else 0

        if location_name := result.get("location_name") is not None:
            if location_name == "Server Room":
                qty_locations_server, qty_locations_known, qty_locations_unknown = 1, 0, 0
            else:
                qty_locations_server, qty_locations_known, qty_locations_unknown = 0, 1, 0
        else:
            qty_locations_server, qty_locations_known, qty_locations_unknown = 0, 0, 1

        result.update({
            "qty_unknown": qty_unknown,
            "qty_cart": qty_cart,
            "qty_server": qty_server,
            "qty_in_use": qty_in_use,
            "qty_broken": qty_broken,
            "qty_disposed": qty_disposed,

            "qty_locations_server": qty_locations_server,
            "qty_locations_known": qty_locations_known,
            "qty_locations_unknown": qty_locations_unknown
        })

        print(f"Gathered result '{result}'")
        return result

    def open_dnd(self, scan_in):
        print(f"open_dnd")
        print(f"{self.bind()=}")
        print(f"{self.entry_scan_input.entry.bind()=}")
        self.tl_dnd_menu = TopLevelDNDMenu(self, self.df_status, self.df_serial_indication, omit_status_shopping_cart=True)
        self.tl_dnd_menu.protocol("WM_DELETE_WINDOW", self.closing_tl_dnd)
        # self.tl_dnd_menu.bind("<Destroy>", self.closing_tl_dnd)
        self.data_tl_dnd_menu = {
            "server_room": self.tl_dnd_menu.canvas_dnd_status.iv_server_room_number.get(),
            "use_number": self.tl_dnd_menu.canvas_dnd_status.iv_in_use_number.get(),
            "broken": self.tl_dnd_menu.canvas_dnd_status.iv_broken_number.get(),
            "disposed": self.tl_dnd_menu.canvas_dnd_status.iv_disposed_number.get(),
            "shopping_cart": self.tl_dnd_menu.canvas_dnd_status.iv_shopping_cart_number.get()
        }
        data_in = self.gather_dnd_data(scan_in)
        results = {k: v for k, v in data_in.items()}
        results["scan_in"] = scan_in
        self.data_current.set(results)

        self.tl_dnd_menu.set_data(data_in)
        apply_state(self.entry_scan_input, "disabled", "down")
        # self.tl_dnd_menu.entry_scannable.set_scan_pass_through()
        self.tl_dnd_menu.canvas_dnd_status.locked_for_animation.trace_variable("w", self.tl_dnd_menu_canvas_dnd_update_lock_animation)
        self.tl_dnd_menu.canvas_dnd_status.status.trace_variable("w", self.tl_dnd_menu_canvas_dnd_status_update)
        self.tl_dnd_menu.canvas_dnd_locations.status.trace_variable("w", self.tl_dnd_menu_canvas_dnd_locations_update)
        # self.tl_dnd_menu.mainloop()
        self.bind_demo_keys_tl_dnd()
        # self.tl_dnd_menu.bind("<Control-Shift-KeyPress-Q>", self.insert_demo_value_tl_dnd_menu)
        # self.tl_dnd_menu.bind("<Control-Shift-KeyPress-q>", self.insert_demo_value_tl_dnd_menu)

        self.tl_dnd_menu.entry_scannable.validated_text.trace_variable("w", self.tl_dnd_menu_update_entry_scannable)

        self.tl_dnd_menu.focus()
        print(dict_print(self.tl_dnd_menu.entry_scannable.__dict__, 'A'))
        self.tl_dnd_menu.entry_scannable.configure(state="disabled")
        print(f"{dir(self.tl_dnd_menu.entry_scannable)=}")
        print(dict_print(self.tl_dnd_menu.entry_scannable.__dict__, 'B'))

    def tl_dnd_menu_canvas_dnd_update_lock_animation(self, *args):
        locked = self.tl_dnd_menu.canvas_dnd_status.locked_for_animation.get()
        if locked:
            self.tl_dnd_menu.entry_scannable.configure(state="readonly")
            self.unbind_demo_keys_tl_dnd()
        else:
            self.tl_dnd_menu.entry_scannable.configure(state="normal")
            self.bind_demo_keys_tl_dnd()

    def tl_dnd_menu_update_entry_scannable(self, *args):
        scan_in = "*" + self.tl_dnd_menu.entry_scannable.validated_text.get() + "*"
        print(f"{scan_in=}")
        if scan_in:
            df_is_indication = self.is_indication_serial(scan_in)
            is_indication = not df_is_indication.empty
            print(f"{df_is_indication=}")
            if is_indication:
                df_is_status = self.is_status_indication_serial(scan_in)
                is_status = not df_is_status.empty
                print(f"{df_is_status=}")
                if is_status:
                    scanned_status_col_names = df_is_status["ColName"].tolist()
                    if len(scanned_status_col_names) != 1:
                        raise Exception(f"Error more than 1 record returned.")
                    else:
                        scanned_status_col_name = scanned_status_col_names[0]
                        print(f"{scanned_status_col_name=}")
                        match scanned_status_col_name:
                            case "UNKNOWN":
                                state_to = "unknown"
                            case "Storage":
                                state_to = "server"
                            case "In Service":
                                state_to = "in_use"
                            case "Out of Service":
                                apply_state(self, "disabled", direction="down")
                                options = ["Broken", "Disposed"]

                                ans = options[int(CustomMessageBox(
                                    "Broken or Disposed?",  # title
                                    "Is this item broken or being disposed?",  # msg
                                    None,  # x
                                    None,  # y
                                    *options,  # b1 &  b2
                                ).choice) - 1]

                                apply_state(self, "normal", direction="down")
                                apply_state(self.entry_scan_input, "disabled", direction="down")
                                print(f"{ans=}")
                                state_to = ans.lower()
                            case _:
                                raise Exception(f"Error, unknown state scanned. {scanned_status_col_name=}")
                    quantities = {
                        "in_use": self.tl_dnd_menu.canvas_dnd_status.iv_in_use_number.get(),
                        "server": self.tl_dnd_menu.canvas_dnd_status.iv_server_room_number.get(),
                        "unknown": self.tl_dnd_menu.canvas_dnd_status.iv_unknown_number.get(),
                        "broken": self.tl_dnd_menu.canvas_dnd_status.iv_broken_number.get(),
                        "disposed": self.tl_dnd_menu.canvas_dnd_status.iv_disposed_number.get()
                    }
                    if sum(quantities.values()) != 1:
                        raise Exception("Error, unable to tell where this is coming from.")

                    filtered = {k: v for k, v in quantities.items() if v > 0}
                    state_from = list(filtered.keys())[0]
                    self.tl_dnd_menu.canvas_dnd_status.submit_animation(state_from, state_to)
                else:
                    df_is_location = self.is_location_indication_serial(scan_in)
                    is_location = not df_is_location.empty
                    if is_location:

                        ##############################################################
                        ##############################################################
                        ##############################################################

                        scanned_location_col_names = df_is_location["ColName"].tolist()
                        if len(scanned_location_col_names) != 1:
                            raise Exception(f"Error more than 1 record returned.")
                        else:
                            scanned_location_col_name = scanned_location_col_names[0]
                            print(f"{scanned_location_col_name=}")
                            match scanned_location_col_name:
                                case "Server Room":
                                    state_to = "server"
                                case "UNKNOWN" | None:
                                    state_to = "unknown"
                                case _:
                                    state_to = "known"

                            quantities = {
                                "known": self.tl_dnd_menu.canvas_dnd_locations.iv_known_number.get(),
                                "server": self.tl_dnd_menu.canvas_dnd_locations.iv_server_room_number.get(),
                                "unknown": self.tl_dnd_menu.canvas_dnd_locations.iv_unknown_number.get()
                            }
                            if sum(quantities.values()) != 1:
                                raise Exception("Error, unable to tell where this is coming from.")

                            filtered = {k: v for k, v in quantities.items() if v > 0}
                            state_from = list(filtered.keys())[0]
                            self.tl_dnd_menu.canvas_dnd_locations.submit_animation(state_from, state_to)
                            # self.tl_dnd_menu.canvas_dnd_locations.animate(state_from, state_to)

                            # match scanned_location_col_name:
                            #     case "UNKNOWN":
                            #         state_to = "unknown"
                            #     case "Storage":
                            #         state_to = "server"
                            #     case "In Service":
                            #         state_to = "in_use"
                            #     case "Out of Service":
                            #         apply_state(self, "disabled", direction="down")
                            #         options = ["Broken", "Disposed"]
                            #
                            #         ans = options[int(CustomMessageBox(
                            #             "Broken or Disposed?",  # title
                            #             "Is this item broken or being disposed?",  # msg
                            #             None,  # x
                            #             None,  # y
                            #             *options,  # b1 &  b2
                            #         ).choice) - 1]
                            #
                            #         apply_state(self, "normal", direction="down")
                            #         apply_state(self.entry_scan_input, "disabled", direction="down")
                            #         print(f"{ans=}")
                            #         state_to = ans.lower()
                            #     case _:
                            #         raise Exception(f"Error, unknown state scanned. {scanned_status_col_name=}")
                        # quantities = {
                        #     "in_use": self.tl_dnd_menu.canvas_dnd_status.iv_in_use_number.get(),
                        #     "server": self.tl_dnd_menu.canvas_dnd_status.iv_server_room_number.get(),
                        #     "unknown": self.tl_dnd_menu.canvas_dnd_status.iv_unknown_number.get(),
                        #     "broken": self.tl_dnd_menu.canvas_dnd_status.iv_broken_number.get(),
                        #     "disposed": self.tl_dnd_menu.canvas_dnd_status.iv_disposed_number.get()
                        # }
                        # if sum(quantities.values()) != 1:
                        #     raise Exception("Error, unable to tell where this is coming from.")
                        #
                        # filtered = {k: v for k, v in quantities.items() if v > 0}
                        # state_from = list(filtered.keys())[0]
                        # self.tl_dnd_menu.canvas_dnd_status.animate(state_from, state_to)
                        # state_from = "FROM"
                        # state_to = "TO"
                        # self.tl_dnd_menu.canvas_dnd_locations.animate(state_from, state_to)

                        ##############################################################
                        ##############################################################
                        ##############################################################

                    else:
                        print(f"Scanned indication serial is not a location, '{scan_in}'")
                    print(f"Scanned indication serial is not a status, '{scan_in}'")
            else:
                print(f"Scanned serial is not an indication serial, '{scan_in}'")

    def closing_tl_dnd(self):
        if self.tl_dnd_menu.is_dirty():
            print("DIRTY!!!")
        assert isinstance(self.tl_dnd_menu, tkinter.Toplevel)
        self.tl_dnd_menu.destroy()
        apply_state(self.entry_scan_input, "normal", "down")
        self.bind_demo_keys()
        self.entry_scan_input.set_bindings()
        self.entry_scan_input.set_listeners()
        self.entry_scan_input.set_scan_pass_through()

        self.entry_scan_input.accepting_counter.set(self.entry_scan_input.accepting_counter_reset)
        self.entry_scan_input.valid_submission.set(False)
        self.entry_scan_input.validated_text.set("")

        self.focus()
        print(f"{self.bind()=}")
        print(f"{self.entry_scan_input.entry.bind()=}")

    def closing_tl_add(self):
        print(f"closing tl_add_menu")
        apply_state(self.entry_scan_input, "normal", "down")
        self.tl_add_menu.destroy()
        self.bind_demo_keys()
        self.entry_scan_input.set_bindings()
        self.entry_scan_input.set_listeners()
        self.entry_scan_input.set_scan_pass_through()

        self.entry_scan_input.accepting_counter.set(self.entry_scan_input.accepting_counter_reset)
        self.entry_scan_input.valid_submission.set(False)
        self.entry_scan_input.validated_text.set("")

        self.focus()
        print(f"{self.bind()=}")
        print(f"{self.entry_scan_input.entry.bind()=}")

    def tl_dnd_menu_canvas_dnd_status_update(self, *args):
        print(dict_print(eval(self.tl_dnd_menu.canvas_dnd_status.status.get()), "self.tl_dnd_menu.canvas_dnd_status.status.get()"))
        data = eval(self.tl_dnd_menu.canvas_dnd_status.status.get())
        data = {"qty_" + k: v for k, v in data.items()}
        print(dict_print(data, "tl_dnd_menu_canvas_dnd_status_update"))
        old = eval(replace_timestamp_datetime(self.tl_dnd_menu.tv_set_data.get(), col_in_question="DateCreated"))
        old.update(data)
        self.tl_dnd_menu.tv_set_data.set(old)

    def tl_dnd_menu_canvas_dnd_locations_update(self, *args):
        print(dict_print(eval(self.tl_dnd_menu.canvas_dnd_locations.status.get()), "self.tl_dnd_menu.canvas_dnd_status.status.get()"))
        data = eval(self.tl_dnd_menu.canvas_dnd_locations.status.get())
        data = {"qty_" + k: v for k, v in data.items()}
        print(dict_print(data, "tl_dnd_menu_canvas_dnd_locations_update"))
        old = eval(replace_timestamp_datetime(self.tl_dnd_menu.tv_set_data.get(), col_in_question="DateCreated"))
        old.update(data)
        self.tl_dnd_menu.tv_set_data.set(old)

    def insert_demo_value_new_item(self, event):
        # W
        self.entry_scan_input.text.set("1000000006")
        event.char = self.entry_scan_input.text.get()
        self.entry_scan_input.return_text(event)

    def insert_demo_value_main_menu(self, event):
        # Q
        # self.entry_scan_input.text.set("0000000250")
        self.entry_scan_input.text.set("")
        self.entry_scan_input.text.set("0000000100")
        event.char = self.entry_scan_input.text.get()
        self.entry_scan_input.return_text(event)

    def insert_demo_value_tl_dnd_menu_status(self, event):
        # self.entry_scan_input.text.set("0000000250")
        # self.tl_dnd_menu.entry_scannable.text.set("9000000009")  # In Service (ITI Status)
        # self.tl_dnd_menu.entry_scannable.text.set("9000000003")  # Used (ITI Condition)
        # self.tl_dnd_menu.entry_scannable.text.set("9000000010")  # Out of Service (ITI Status)
        self.tl_dnd_menu.entry_scannable.text.set("9000000007")  # Unkown (ITI Status)
        self.tl_dnd_menu.entry_scannable.return_text(event)

    def insert_demo_value_tl_dnd_menu_location(self, event):
        # self.entry_scan_input.text.set("0000000250")
        # self.tl_dnd_menu.entry_scannable.text.set("9000000009")  # In Service (ITI Status)
        # self.tl_dnd_menu.entry_scannable.text.set("9000000003")  # Used (ITI Condition)
        # self.tl_dnd_menu.entry_scannable.text.set("9000000010")  # Out of Service (ITI Status)
        self.tl_dnd_menu.entry_scannable.text.set("9000000060")  # Server Room (ITI Locations)
        self.tl_dnd_menu.entry_scannable.return_text(event)

    def insert_demo_value_tl_add_menu_status(self, event):
        self.tl_add_menu.entry_scannable_input.text.set("9000000010")  # Out of Service (ITI Status)
        self.tl_add_menu.entry_scannable_input.return_text(event)

    def insert_demo_value_tl_add_menu_location_server_room(self, event):
        self.tl_add_menu.entry_scannable_input.text.set("9000000060")  # Server Room (ITI Locations)
        self.tl_add_menu.entry_scannable_input.return_text(event)

    def insert_demo_value_tl_add_menu_location_averys_office(self, event):
        self.tl_add_menu.entry_scannable_input.text.set("9000000062")  # Server Room (ITI Locations)
        self.tl_add_menu.entry_scannable_input.return_text(event)

    def submit_new_item(self, *args):
        print(f"New Item Submission:")
        all_keys = self.tl_add_menu.valid_status_keys
        data_status = eval(self.tl_add_menu.status.get())
        data_valid = eval(self.tl_add_menu.valid.get())
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
                print(f"A save unfinished work for next opening")
                self.new_item_save_state.set(data_valid)
        else:
            # save unfinished work for next opening
            print(f"B save unfinished work for next opening")
            self.new_item_save_state.set(data_valid)
        print(f"{data_status=}\n{data_valid=}")

    def tl_add_menu_update_serial_scan(self, *args):
        print(f"{args=}")
        widget = self.tl_add_menu.entry_scannable_input
        var = widget.text
        val = var.get()
        print(f"{widget=}, {var=}, {val=}")
        df_is = self.is_indication_serial(f"*{val}*")
        is_df_is = not df_is.empty
        # if not (df_is := self.is_indication_serial(val)).empty:
        print(f"{df_is=}, {is_df_is=}")
        if is_df_is:
            table = df_is["TableName"].tolist()[0]
            row_id = df_is["RowID"].tolist()[0]
            col_val = df_is["ColName"].tolist()[0]

            df_loc = self.df_v_serial_indication[(self.df_v_serial_indication["TableName"] == table) & (self.df_v_serial_indication["RowID"] == row_id)]
            if not df_loc.empty:
                if df_loc.shape[0] == 1:
                    print(f"{df_loc=}")
                    print(f"{self.df_loc_emp_bld_dpt.columns=}")
                    print(f"{self.df_loc_emp_bld_dpt=}")
                    assert isinstance(df_loc, pandas.DataFrame)
                    # row = df_loc.tolist()[0]
                    row_number, row = list(df_loc.iterrows())[0]
                    serial_id = row["SerialID"]
                    row_id = row["RowID"]
                    row_x = self.df_loc_emp_bld_dpt[self.df_loc_emp_bld_dpt["ID_[A]"] == row_id]
                    print(f"{table=}, {row_id=}, {col_val=}, {row=}, {serial_id=}, {row_x=}")
                    match table:
                        case "ITI Locations":
                            self.tl_add_menu.treeview_location.selection_set(f"C_{row_id - 1}")
                        case "ITI Type":
                            type_id = int(list(self.df_type[self.df_type["ID"] == row_id].iterrows())[0][1]["ID"])
                            print(f"{type_id=}")
                            type_name = self.tl_add_menu.spin_values_type["names"][type_id - 1]
                            self.tl_add_menu.tv_spin_type.set(type_name)
                        case "ITI Condition":
                            condition_id = int(list(self.df_condition[self.df_condition["ID"] == row_id].iterrows())[0][1]["ID"])
                            condition_name = self.tl_add_menu.spin_values_cond["names"][condition_id - 1]
                            self.tl_add_menu.tv_spin_cond.set(condition_name)
                        case "ITI UOM":
                            uom_id = int(list(self.df_uom[self.df_uom["ID"] == row_id].iterrows())[0][1]["ID"])
                            uom_name = self.tl_add_menu.spin_values_type["names"][uom_id - 1]
                            self.tl_add_menu.tv_spin_uom.set(uom_name)
                        case "ITI Unknown":
                            self.tl_add_menu.tv_spin_type.set("UNKNOWN")
                            item_sub_type_id = int(list(self.df_unknown[self.df_unknown["ID"] == row_id].iterrows())[0][1]["ID"])
                            item_sub_type = self.tl_add_menu.spin_values_unknown["names"][item_sub_type_id - 1]
                            self.tl_add_menu.tv_spin_subtype.set(item_sub_type)
                        case "ITI Computer":
                            self.tl_add_menu.tv_spin_type.set("Computer")
                            item_sub_type_id = int(list(self.df_computer[self.df_computer["ID"] == row_id].iterrows())[0][1]["ID"])
                            item_sub_type = self.tl_add_menu.spin_values_computer["names"][item_sub_type_id - 1]
                            self.tl_add_menu.tv_spin_subtype.set(item_sub_type)
                        case "ITI Peripherals":
                            self.tl_add_menu.tv_spin_type.set("Peripherals")
                            item_sub_type_id = int(list(self.df_peripherals[self.df_peripherals["ID"] == row_id].iterrows())[0][1]["ID"])
                            item_sub_type = self.tl_add_menu.spin_values_peripherals["names"][item_sub_type_id - 1]
                            self.tl_add_menu.tv_spin_subtype.set(item_sub_type)
                        case "ITI Network":
                            self.tl_add_menu.tv_spin_type.set("Network")
                            item_sub_type_id = int(list(self.df_network[self.df_network["ID"] == row_id].iterrows())[0][1]["ID"])
                            item_sub_type = self.tl_add_menu.spin_values_network["names"][item_sub_type_id - 1]
                            self.tl_add_menu.tv_spin_subtype.set(item_sub_type)
                        case "ITI Wire":
                            self.tl_add_menu.tv_spin_type.set("Wire")
                            item_sub_type_id = int(list(self.df_wire[self.df_wire["ID"] == row_id].iterrows())[0][1]["ID"])
                            item_sub_type = self.tl_add_menu.spin_values_wire["names"][item_sub_type_id - 1]
                            self.tl_add_menu.tv_spin_subtype.set(item_sub_type)
                        case _:
                            print("Error...")
                else:
                    print(f"tl_add_menu_update_serial_scan, df_loc returned more than one record.")
            else:
                print(f"tl_add_menu_update_serial_scan, df_loc returned empty dataframe.")
        else:
            print(f"tl_add_menu_update_serial_scan, please use an indication serial here.")

    def tl_add_menu_treeview_select(self, event):
        """Treeview of location choices updated in top level add menu."""
        print(f"{event=}")
        tree = event.widget
        selection = [tree.item(item)["text"] for item in tree.selection()]
        print(f"{selection=}")
        valid = eval(self.tl_add_menu.valid.get())
        print(f"{valid=}")
        idx_treeview = int(selection[0].split("_")[-1])
        print(f"{idx_treeview=}")
        valid.update({"locationID": idx_treeview})
        self.tl_add_menu.valid.set(valid)
        print(dict_print(eval(self.tl_add_menu.valid.get()), "tl_add_menu.valid"))

    def update_tl_add_menu_quit_condition(self):
        """tl_add_menu has a new reason to quit"""
        quit_status = self.tl_add_menu.quit_condition.get()
        if quit_status:
            self.tl_add_menu.destroy()
            self.tl_add_menu.quit_condition.set("")
