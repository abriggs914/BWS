import pandas
import pandas as pd


CONDITION = {
    "UNKNOWN": 1,
    "New": 2,
    "Used": 3,
    "Repair Needed": 4,
    "Destroyed": 5,
    "Maintenance": 6
}

TYPE = {
    "UNKNOWN": 1,
    "Computer": 2,
    "Peripherals": 3,
    "Network": 4,
    "Wire": 5
}

SUBTYPES = {
    # computer
    "UNKNOWN": 1,
    "Laptop": 2,
    "Desktop": 3,
    "Engineering Tower": 4,
    "Micro PC": 5,
    "Micro Desktop": 6,
    "Phone": 7,
    "Tablet": 8,

    # network
    "Switch": 2,
    "Modem": 3,

    # peripherals
    "Bluetooth Mouse": 2,
    "Wireless Mouse": 3,
    "Wired Mouse": 4,
    "Bluetooth Keyboard": 5,
    "Wired Keyboard": 6,
    "Wireless Keyboard": 7,
    "Web Cameras": 8,
    "Mouse Pads": 9,
    "Monitors": 10,
    "Bluetooth Monitors": 11,
    "Wired Mouse + Keyboard Set": 12,
    "Wireless Mouse + Keyboard Set": 13,
    "Wired Headset": 14,
    "Wireless Headset": 15,
    "Thunderbolt USB-C Dock": 16,
    "USB-C Dock": 17,
    "Monitor Arm (Single)": 18,
    "Monitor Arm (Double)": 19,
    "Wired Speakers": 20,
    "Wireless Speakers": 21,
    "USB Numpad": 22,
    "SpaceMouse": 23,
    "AA Batteries": 24,
    "AAA Batteries": 25,

    # wire
    "Audio Video": 2,
    "Network": 3,
    "USB": 4,
    "Power": 5,
    "Back-Up Battery": 6,
    "Telephone": 7
}

TYPE_SUB_TYPE = [
    ("Peripherals", "Monitors"),
    ("Peripherals", "Monitors"),
    ("Peripherals", "Monitors"),
    ("Peripherals", "Monitors"),
    ("Peripherals", "Monitors"),
    ("Peripherals", "Monitors"),
    ("Peripherals", "Monitors"),
    ("Peripherals", "Monitors"),
    ("Peripherals", "Monitors"),
    ("Computer", "Micro PC"),
    ("Computer", "Desktop"),
    ("Computer", "Laptop"),
    ("Peripherals", "Wired Keyboard"),
    ("Peripherals", "Wired Mouse"),
    ("Peripherals", "Wireless Keyboard"),
    ("Peripherals", "Wireless Mouse"),
    ("Peripherals", "Wireless Mouse"),
    ("Peripherals", "Wired Mouse + Keyboard Set"),
    ("Peripherals", "Wireless Mouse + Keyboard Set"),
    ("Peripherals", "Wireless Mouse + Keyboard Set"),
    ("Peripherals", "Web Cameras"),
    ("Peripherals", "Web Cameras"),
    ("Peripherals", "Wired Headset"),
    ("Peripherals", "Wired Headset"),
    ("Wire", "Network"),
    ("Wire", "Network"),
    ("Wire", "Network"),
    ("Wire", "Network"),
    ("Wire", "Network"),
    ("Wire", "Network"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Network"),
    ("Wire", "Network"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "USB"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "USB"),
    ("Wire", "USB"),
    ("Wire", "USB"),
    ("Wire", "Telephone"),
    ("Wire", "Power"),
    ("Wire", "Power"),
    ("Wire", "Power"),
    ("Wire", "Power"),
    ("Peripherals", "Thunderbolt USB-C Dock"),
    ("Peripherals", "USB-C Dock"),
    ("Wire", "Power"),
    ("Wire", "Back-Up Battery"),
    ("Wire", "Back-Up Battery"),
    ("Wire", "USB"),
    ("Wire", "USB"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Audio Video"),
    ("Wire", "Telephone"),
    ("Wire", "Telephone"),
    ("Wire", "Telephone"),
    ("Peripherals", "Monitor Arm (Double)"),
    ("Peripherals", "Wired Speakers"),
    ("Peripherals", "USB Numpad"),
    ("Peripherals", "SpaceMouse"),
    ("Computer", "Phone"),
    ("Computer", "Phone"),
    ("Peripherals", "AA Batteries"),
    ("Peripherals", "AA Batteries"),
    ("Peripherals", "AAA Batteries"),
    ("Peripherals", "AAA Batteries"),
]


if __name__ == "__main__":
    df = pandas.read_excel(r"./Server Room Stock - May 27th.xlsx", sheet_name="Sheet1")
    if not df.empty:
        print(f"{df=}")
        print("INSERT INTO [ITI Item] ([Name], [Description], [IsActive], [Condition], [Status], [Type], [SubType]) VALUES")
        # Name, Description, IsActive, Condition, Status, Type, SubType, DateCreated
        for i, row in enumerate(df.iterrows()):
            r_num, row_data = row
            name = str(row_data["Inventory"]).replace("\n", " ")
            description = name + "\n" + str(row_data["Notes"])
            description = description.split("\nnan")[0].replace("\n", " ")
            is_active = 1
            condition = CONDITION[row_data["Condition"]]
            status = 1
            type_, sub_type = TYPE_SUB_TYPE[i]
            type_ = TYPE[type_]
            sub_type = SUBTYPES[sub_type]
            # print(f"{name.ljust(32)=}, {description.ljust(40)=}, {is_active=}, {condition=}, {status=}, {type_=}, {sub_type=}")
            print(f"('{name}', '{description}', {is_active}, {condition}, {status}, {type_}, {sub_type}),")



