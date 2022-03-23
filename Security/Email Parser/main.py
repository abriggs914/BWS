import datetime

import easygui
from utility import *
# import tkinterdnd2
from tkinter import *
import tkinter.filedialog as filedialog

import os

FILE_DELIM = " ##### "


class App(Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.pack(pady=35, padx=35)

        self.pdf = None

        self.dnd_frame = Frame(self)
        self.listbox_frame = Frame(self.dnd_frame)
        self.btn_frame = Frame(self.dnd_frame)
        self.demo_frame = Frame(self)
        self.preview_frame = Frame(self.demo_frame)
        self.demo_btn_frame = Frame(self.demo_frame)
        self.dnd_frame.pack()
        self.listbox_frame.pack(side=TOP)
        self.btn_frame.pack(side=TOP)
        self.demo_frame.pack()
        self.preview_frame.pack(side=LEFT)
        self.demo_btn_frame.pack(side=RIGHT)

        # DND Listbox
        self.listbox = Listbox(self.listbox_frame, selectmode=EXTENDED, width=150, height=20)
        self.listbox.pack(fill=X, side=LEFT)
        self.listbox.drop_target_register(tkinterdnd2.DND_FILES)
        self.listbox.dnd_bind('<<Drop>>', self.add_to_listbox)

        # DND Listbox control buttons
        self.clear_listbox_button = Button(self.btn_frame, text="Clear All", fg="red", bg="#c2c2c2", command=self.clear_listbox)
        self.clear_listbox_button.pack(side=LEFT)
        self.clear_selected_button = Button(self.btn_frame, text="Clear Selected", fg="red", bg="#c2c2c2", command=self.clear_selected)
        self.clear_selected_button.pack(side=LEFT)
        self.browse_files_button = Button(self.btn_frame, text="Browse Files", fg="red", bg="#c2c2c2", command=self.browse_files)
        self.browse_files_button.pack(side=LEFT)


        self.decompile_button = Button(self.demo_frame, text="Decompile", fg="red", bg="#c2c2c2", command=self.parse)
        self.decompile_button.pack(side=TOP)

        # # Preview Demo
        # DEMO_WIDTH = 250
        # DEMO_HEIGHT = int(round(DEMO_WIDTH * (11 / 8.5)))
        # self.demo_canvas = Canvas(self.preview_frame, bg="#ffffff", width=DEMO_WIDTH, height=DEMO_HEIGHT)
        # self.demo_canvas.pack()
        #
        # sbv = Scrollbar(
        #     self.listbox_frame,
        #     orient=VERTICAL
        # )
        # sbv.pack(side=RIGHT, fill=Y)
        #
        # self.listbox.configure(yscrollcommand=sbv.set)
        # sbv.config(command=self.listbox.yview)

    def add_to_listbox(self, event):
        if event is None or not event:
            return
        print(dict_print(event, "event"))
        if isinstance(event, dict):
            file_strs = event["data"].split(FILE_DELIM)
        else:
            file_strs = event.data.split(FILE_DELIM)
        for file_str in file_strs:
            self.listbox.insert("end", file_str)

    def clear_listbox(self):
        self.listbox.delete(0, "end")

    def clear_selected(self):
        selected = list(self.listbox.curselection())
        remaining = self.listbox.get(0, "end")
        res = []
        for i, v in enumerate(remaining):
            if not selected or i != selected[0]:
                res.append(v)
            else:
                selected.pop(0)
        print("remaining ({})".format(len(remaining)), remaining)
        print("selected ({})".format(len(selected)), selected)
        print("res ({})".format(len(res)), res)

        self.clear_listbox()
        self.add_to_listbox({"data": " ".join(res)})

    # Function for opening the
    # file explorer window
    def browse_files(self):
        filename = list(filedialog.askopenfilenames(
            initialdir="C:\\Users\\ABriggs\\Desktop\\Temp Access",
            title="Select a File",
            filetypes=(
                (
                    "Database files",
                    "*.accdb*"
                ),
                (
                    "Database files",
                    "*.mdb*"
                )
            )
        ))

        # Change label contents
        # label_file_explorer.configure(text="File Opened: " + filename)
        self.add_to_listbox({"data": FILE_DELIM.join(filename)})
        print("file_name:", filename)

    # def decompile(self):
    #     files = self.listbox.get(0, last=END)
    #     print("files:", files)
    #     # TODO this needs attention
    #     for file_n in files:
    #         print("EXEC:", ('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n)))
    #         # os.system('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n))

    def parse(self):
        files = [fn.strip() for fn in self.listbox.get(0, last=END)]
        print("files:", files)
        # # TODO this needs attention
        # for file_n in files:
        #     print("EXEC:", ('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n)))
        #     # os.system('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n))

    def run(self):
        self.mainloop()


class ArmstrongEmail:

    def __init__(self, file_name):
        self.file_name = file_name

    def parse(self):
        with open(self.file_name, 'r') as f:
            lines = f.read()
            section_spliter = "-----------------------------------------------------------------------------"
            section_split = lines.split(section_spliter)
            print(section_split)
            print(len(section_split))
            transactions_section = section_split[-1]
            print("last section:", transactions_section)
            transaction_lines = transactions_section.split("\n")
            transaction_dates = {}
            curr_date = None
            for i, line in enumerate(transaction_lines):
                print("line:", line.strip()[:20].strip())
                try:
                    date = datetime.datetime.strptime(line.strip()[:20].strip(), "%m/%d %a %H:%M:%S%p")
                    curr_date = date
                    transaction_dates[date] = [i]
                except ValueError:
                    if curr_date is None:
                        if "None" not in transaction_dates:
                            transaction_dates["None"] = []
                        transaction_dates["None"].append(i)
                    else:
                        transaction_dates[curr_date].append(i)

            print(dict_print(transaction_dates))


if __name__ == "__main__":

    # root = tkinterdnd2.Tk()
    # root.title("CSV to PDF")
    # WIDTH = 1100
    # DIMS = "{}x{}".format(WIDTH, int(round(WIDTH * (6 / 9))))
    # root.geometry(DIMS)
    # root.config(bg='#fcb103')
    # app = App(root)
    # app.run()

    ae_1 = ArmstrongEmail(r"""C:\Users\abrig\Documents\BWS\BWS\Security\Email Parser\2022-03-22 Main Building.txt""")
    ae_1.parse()
