import easygui
from utility import *
import tkinterdnd2
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


        self.decompile_button = Button(self.demo_frame, text="Decompile", fg="red", bg="#c2c2c2", command=self.decompile)
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

    # def create_pdf(self, file_name):
    #     MAX_Y = 297
    #     MAX_X = 210
    #     MARGIN_LINES_WIDTH = 2
    #     MARGIN_LINES_MARGIN = 4
    #     TITLE_HEIGHT = 6
    #     TITLE_MARGIN = 4
    #     TXT_MARGIN = 5
    #     TABLE_MARGIN = 2
    #     FOOTER_MARGIN = 10
    #     ori = "L"
    #
    #     if ori == "L":
    #         MAX_X, MAX_Y = MAX_Y, MAX_X
    #
    #     pdf = PDF(file_name, orientation=ori, unit='mm', format='A4')
    #     pdf.set_auto_page_break(True, margin=5)
    #     pdf.set_title("Dealer Delivery Reports")
    #     pdf.set_author('Avery Briggs')
    #     pdf.add_page()
    #
    #     # pdf.margin_lines(MARGIN_LINES_MARGIN, MARGIN_LINES_MARGIN, MAX_X - (2 * MARGIN_LINES_MARGIN),
    #     # 				 MAX_Y - (2 * MARGIN_LINES_MARGIN), BWS_RED, WHITE)
    #     pdf.margin_border(BWS_RED, WHITE)
    #     pdf.titles("Dealer Delivery Reports", MARGIN_LINES_WIDTH + MARGIN_LINES_MARGIN,
    #                TITLE_MARGIN + MARGIN_LINES_WIDTH + MARGIN_LINES_MARGIN,
    #                MAX_X - (2 * (MARGIN_LINES_WIDTH + MARGIN_LINES_MARGIN)), TITLE_HEIGHT, BWS_BLACK)
    #
    #     # TABLE_X = 5 + MARGIN_LINES_WIDTH + TABLE_MARGIN
    #     # TABLE_Y = 10 + MARGIN_LINES_WIDTH + TABLE_MARGIN
    #
    #     TABLE_W = (MAX_X - (2 * (MARGIN_LINES_WIDTH + MARGIN_LINES_MARGIN)) - (2 * TABLE_MARGIN))
    #
    #     TABLE_X = TABLE_MARGIN + MARGIN_LINES_WIDTH + MARGIN_LINES_MARGIN
    #     TABLE_Y = TABLE_MARGIN + MARGIN_LINES_WIDTH + TITLE_HEIGHT + TITLE_MARGIN
    #
    #     # TABLE_LEFT_MARGIN = 6
    #     TITLE_V_MARGIN = 5
    #
    #     table1 = pdf.table(
    #         title="Need Adjusted",
    #         x=TABLE_X,
    #         y=TABLE_Y,
    #         w=TABLE_W,
    #         contents=data,
    #         desc_txt="The following quotes should have their estimated delivery dates edited in Access:",
    #         # contents=random_test_set(453),
    #         header_colours=[GRAY_30, BLACK],
    #         colours=[[WHITE, GRAY_69],
    #                  [BLACK]],
    #         show_row_names=True,
    #         include_top_doc_link=True,
    #         new_page_for_table=False,
    #         row_name_col_lbl="Dealer",
    #         start_with_header=True,
    #         cell_border_style=1,
    #         col_align={"Dealer": "L"},
    #         top_margin=2,
    #         col_widths={"Dealer": 3 / 24, "P": 1 / 24, "F": 1 / 24}
    #     )
    #
    #     pdf.time_stamp()
    #     pdf.output(file_name, 'F')
    #     webbrowser.open(file_name)

    def decompile(self):
        files = self.listbox.get(0, last=END)
        print("files:", files)
        # TODO this needs attention
        for file_n in files:
            print("EXEC:", ('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n)))
            # os.system('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n))

    def run(self):
        self.mainloop()


if __name__ == "__main__":

    root = tkinterdnd2.Tk()
    root.title("CSV to PDF")
    WIDTH = 1100
    DIMS = "{}x{}".format(WIDTH, int(round(WIDTH * (6 / 9))))
    root.geometry(DIMS)
    root.config(bg='#fcb103')
    app = App(root)
    app.run()


# if __name__ == '__main__':
#     files = easygui.fileopenbox("Select a Database file", "File Selection", filetypes="*.accdb, *.mdb", multiple=True)
#     print(files)
