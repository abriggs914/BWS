import datetime
import tkinter
from colour_utility import *
import pytz

import win32com.client
import dateutil.parser
#other libraries to be used in this script
import os

import easygui
from utility import *
# import tkinterdnd2
from tkinter import *
import tkinter.filedialog as filedialog

import os

# FILE_DELIM = " ##### "
#
#
# class App(Frame):
#     def __init__(self, master=None):
#         super().__init__(master)
#         self.pack(pady=35, padx=35)
#
#         self.pdf = None
#
#         self.dnd_frame = Frame(self)
#         self.listbox_frame = Frame(self.dnd_frame)
#         self.btn_frame = Frame(self.dnd_frame)
#         self.demo_frame = Frame(self)
#         self.preview_frame = Frame(self.demo_frame)
#         self.demo_btn_frame = Frame(self.demo_frame)
#         self.dnd_frame.pack()
#         self.listbox_frame.pack(side=TOP)
#         self.btn_frame.pack(side=TOP)
#         self.demo_frame.pack()
#         self.preview_frame.pack(side=LEFT)
#         self.demo_btn_frame.pack(side=RIGHT)
#
#         # DND Listbox
#         self.listbox = Listbox(self.listbox_frame, selectmode=EXTENDED, width=150, height=20)
#         self.listbox.pack(fill=X, side=LEFT)
#         self.listbox.drop_target_register(tkinterdnd2.DND_FILES)
#         self.listbox.dnd_bind('<<Drop>>', self.add_to_listbox)
#
#         # DND Listbox control buttons
#         self.clear_listbox_button = Button(self.btn_frame, text="Clear All", fg="red", bg="#c2c2c2", command=self.clear_listbox)
#         self.clear_listbox_button.pack(side=LEFT)
#         self.clear_selected_button = Button(self.btn_frame, text="Clear Selected", fg="red", bg="#c2c2c2", command=self.clear_selected)
#         self.clear_selected_button.pack(side=LEFT)
#         self.browse_files_button = Button(self.btn_frame, text="Browse Files", fg="red", bg="#c2c2c2", command=self.browse_files)
#         self.browse_files_button.pack(side=LEFT)
#
#
#         self.decompile_button = Button(self.demo_frame, text="Decompile", fg="red", bg="#c2c2c2", command=self.parse)
#         self.decompile_button.pack(side=TOP)
#
#         # # Preview Demo
#         # DEMO_WIDTH = 250
#         # DEMO_HEIGHT = int(round(DEMO_WIDTH * (11 / 8.5)))
#         # self.demo_canvas = Canvas(self.preview_frame, bg="#ffffff", width=DEMO_WIDTH, height=DEMO_HEIGHT)
#         # self.demo_canvas.pack()
#         #
#         # sbv = Scrollbar(
#         #     self.listbox_frame,
#         #     orient=VERTICAL
#         # )
#         # sbv.pack(side=RIGHT, fill=Y)
#         #
#         # self.listbox.configure(yscrollcommand=sbv.set)
#         # sbv.config(command=self.listbox.yview)
#
#     def add_to_listbox(self, event):
#         if event is None or not event:
#             return
#         print(dict_print(event, "event"))
#         if isinstance(event, dict):
#             file_strs = event["data"].split(FILE_DELIM)
#         else:
#             file_strs = event.data.split(FILE_DELIM)
#         for file_str in file_strs:
#             self.listbox.insert("end", file_str)
#
#     def clear_listbox(self):
#         self.listbox.delete(0, "end")
#
#     def clear_selected(self):
#         selected = list(self.listbox.curselection())
#         remaining = self.listbox.get(0, "end")
#         res = []
#         for i, v in enumerate(remaining):
#             if not selected or i != selected[0]:
#                 res.append(v)
#             else:
#                 selected.pop(0)
#         print("remaining ({})".format(len(remaining)), remaining)
#         print("selected ({})".format(len(selected)), selected)
#         print("res ({})".format(len(res)), res)
#
#         self.clear_listbox()
#         self.add_to_listbox({"data": " ".join(res)})
#
#     # Function for opening the
#     # file explorer window
#     def browse_files(self):
#         filename = list(filedialog.askopenfilenames(
#             initialdir="C:\\Users\\ABriggs\\Desktop\\Temp Access",
#             title="Select a File",
#             filetypes=(
#                 (
#                     "Database files",
#                     "*.accdb*"
#                 ),
#                 (
#                     "Database files",
#                     "*.mdb*"
#                 )
#             )
#         ))
#
#         # Change label contents
#         # label_file_explorer.configure(text="File Opened: " + filename)
#         self.add_to_listbox({"data": FILE_DELIM.join(filename)})
#         print("file_name:", filename)
#
#     # def decompile(self):
#     #     files = self.listbox.get(0, last=END)
#     #     print("files:", files)
#     #     # TODO this needs attention
#     #     for file_n in files:
#     #         print("EXEC:", ('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n)))
#     #         # os.system('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n))
#
#     def parse(self):
#         files = [fn.strip() for fn in self.listbox.get(0, last=END)]
#         print("files:", files)
#         # # TODO this needs attention
#         # for file_n in files:
#         #     print("EXEC:", ('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n)))
#         #     # os.system('cmd.exe \"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'.format(file_n))
#
#     def run(self):
#         self.mainloop()


# this is for reading text files ONLY
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


    # root = tkinterdnd2.Tk()
    # root.title("CSV to PDF")
    # WIDTH = 1100
    # DIMS = "{}x{}".format(WIDTH, int(round(WIDTH * (6 / 9))))
    # root.geometry(DIMS)
    # root.config(bg='#fcb103')
    # app = App(root)
    # app.run()

    def load_armstrong_emails(self, count=None):
        outlook = win32com.client.Dispatch('outlook.application')
        mapi = outlook.GetNamespace("MAPI")
        for account in mapi.Accounts:
            print(account)

        # verified
        armstrong_folder = mapi.Folders.Item("Avery Briggs").Folders.Item("Armstrong").Items
        # email = armstrong_folder.GetFirst()
        email = armstrong_folder.GetLast()
        email_items = {}
        i = 0

        # general updates come from infor@armcom.ca
        while email:
            try:
                print(f"i:{i}, email: {email}")
                email_data = dict()
                email_data['sent_on'] = getattr(email, 'SentOn', '<UNKNOWN>')
                email_data['sender'] = getattr(email, 'SenderEmailAddress', '<UNKNOWN>')
                email_data['receiver'] = getattr(email, 'to', '<UNKNOWN>')
                email_data['subject'] = getattr(email, 'subject', '<UNKNOWN>')
                email_data['cc'] = getattr(email, 'cc', '<UNKNOWN>')
                email_data['bcc'] = getattr(email, 'bcc', '<UNKNOWN>')
                email_data['body'] = getattr(email, 'body', '<UNKNOWN>')[:25]
                email_data["var1"] = tkinter.StringVar(value=email_data['sent_on'])  # date
                email_data["var2"] = tkinter.StringVar(value=email_data['subject'])  # subject
                email_data["var3"] = tkinter.StringVar(value=email_data['body'][:25])  # body[:25]
                email_data["col1"] = None  # date
                email_data["col2"] = None  # subject
                email_data["col3"] = None  # body[:25]
                email_items[i] = email_data
                print(f"\tdate: {email_data['sent_on']},\n\tfrom:\n\t{email_data['sender']},\n\tsubject:\n\t{email_data['subject']},\nbody: {email_data['body']}")
            except Exception as ex:
                print("Error processing mail", ex)
            i += 1
            if count is not None and i >= count:
                break
            email = armstrong_folder.GetPrevious()
            # email = armstrong_folder.GetNext()

        print(dict_print(email_items, "Email Items"))
        return email_items


class EmailParser(tkinter.Tk):

    def __init__(
        self,
        MAX_EMAILS=50000,
        WIDTH=900,
        HEIGHT=600

    ):
        super().__init__()
        self.MAX_EMAILS = MAX_EMAILS
        self.WIDTH, self.HEIGHT = WIDTH, HEIGHT
        self.geometry(f"{self.WIDTH}x{self.HEIGHT}")

        self.EMAIL_DATA = self.load_armstrong_emails()

        self.EMAIL_TABLE_COLOURS = [(rgb_to_hex((175, 175, 175)), rgb_to_hex((0, 0, 0))), (rgb_to_hex((255, 255, 255)), rgb_to_hex((0, 0, 0)))]
        self.BG_SELECTED_ROW = rgb_to_hex(LIGHTBLUE_2)
        self.BG_SELECTED_COL = rgb_to_hex(ORANGE)
        self.START_DATE = tkinter.StringVar()
        self.END_DATE = tkinter.StringVar()
        self.EMAIL_TABLE_HEADER = tkinter.StringVar(value="Emails:")
        self.SELECTED = {
            "row": None,
            "col": None,
            "mouse": None
        }

        self.F_date_widget = tkinter.Frame(self)
        self.F_date_buttons = tkinter.Frame(self.F_date_widget)
        self.F_date_labels = tkinter.Frame(self.F_date_widget)
        self.L_start_date = tkinter.Label(self.F_date_labels, text="Start Date:")
        self.L_end_date = tkinter.Label(self.F_date_labels, text="End Date:")
        self.TI_start_date = tkinter.Entry(self.F_date_buttons, textvariable=self.START_DATE)
        self.TI_end_date = tkinter.Entry(self.F_date_buttons, textvariable=self.END_DATE)

        self.F_email_table = tkinter.Frame(self)
        self.L_email_table_header = tkinter.Entry(self.F_email_table, textvariable=self.EMAIL_TABLE_HEADER)

        # list of alternating row EMAIL_TABLE_COLOURS (bg, fg)
        for i in range(clamp(0, len(self.EMAIL_DATA), self.MAX_EMAILS)):
            # only showing date, subject, and body[:25] -> 3 columns
            bg = self.EMAIL_TABLE_COLOURS[i % len(self.EMAIL_TABLE_COLOURS)][0]
            fg = self.EMAIL_TABLE_COLOURS[i % len(self.EMAIL_TABLE_COLOURS)][1]
            for j in range(3):
                var = self.EMAIL_DATA[i][f'var{j+1}']
                self.EMAIL_DATA[i][f'col{j+1}'] = tkinter.Entry(self.F_email_table, textvariable=var, bg=bg, fg=fg, width=50,
                                                      state="readonly", readonlybackground=bg)
                self.EMAIL_DATA[i][f'col{j+1}'].grid(row=i + 1, column=j + 1)
                self.EMAIL_DATA[i][f'col{j+1}'].bind("<Button-1>", self.click_email_table)

        self.L_start_date.pack()
        self.L_end_date.pack()
        self.TI_start_date.pack()
        self.TI_end_date.pack()
        self.F_date_buttons.pack(side=tkinter.RIGHT)
        self.F_date_labels.pack(side=tkinter.LEFT)
        self.F_date_widget.pack()

        self.F_email_table.pack()

    def load_armstrong_emails(self, count=None):
        outlook = win32com.client.Dispatch('outlook.application')
        mapi = outlook.GetNamespace("MAPI")
        for account in mapi.Accounts:
            print(account)

        # verified
        armstrong_folder = mapi.Folders.Item("Avery Briggs").Folders.Item("Armstrong").Items
        # email = armstrong_folder.GetFirst()
        email = armstrong_folder.GetLast()
        email_items = {}
        i = 0

        # general updates come from infor@armcom.ca
        while email:
            try:
                print(f"i:{i}, email: {email}")
                email_data = dict()
                email_data['sent_on'] = getattr(email, 'SentOn', '<UNKNOWN>')
                email_data['sender'] = getattr(email, 'SenderEmailAddress', '<UNKNOWN>')
                email_data['receiver'] = getattr(email, 'to', '<UNKNOWN>')
                email_data['subject'] = getattr(email, 'subject', '<UNKNOWN>')
                email_data['cc'] = getattr(email, 'cc', '<UNKNOWN>')
                email_data['bcc'] = getattr(email, 'bcc', '<UNKNOWN>')
                email_data['body'] = getattr(email, 'body', '<UNKNOWN>')[:25]
                email_data["var1"] = tkinter.StringVar(value=email_data['sent_on'])  # date
                email_data["var2"] = tkinter.StringVar(value=email_data['subject'])  # subject
                email_data["var3"] = tkinter.StringVar(value=email_data['body'][:25])  # body[:25]
                email_data["col1"] = None  # date
                email_data["col2"] = None  # subject
                email_data["col3"] = None  # body[:25]
                email_items[i] = email_data
                print(f"\tdate: {email_data['sent_on']},\n\tfrom:\n\t{email_data['sender']},\n\tsubject:\n\t{email_data['subject']},\nbody: {email_data['body']}")
            except Exception as ex:
                print("Error processing mail", ex)
            i += 1
            if count is not None and i >= count:
                break
            email = armstrong_folder.GetPrevious()
            # email = armstrong_folder.GetNext()

        print(dict_print(email_items, "Email Items"))
        return email_items

    def get_row(self, mouse):
        bounds = Rect2(self.F_email_table.winfo_rootx(), self.F_email_table.winfo_rooty(), self.F_email_table.winfo_width(), self.F_email_table.winfo_height())
        p = (mouse[1] - bounds.y) / bounds.h
        rows = clamp(0, len(self.EMAIL_DATA), self.MAX_EMAILS)
        print(f"mouse: {mouse}, bounds: ({bounds.x}, {bounds.y}), X ({bounds.w}x{bounds.h}), p: {p}, rows: {rows}, res: {int(p * rows)}")
        return int(p * rows)

    def get_col(self, mouse):
        bounds = Rect2(self.F_email_table.winfo_rootx(), self.F_email_table.winfo_rooty(), self.F_email_table.winfo_width(), self.F_email_table.winfo_height())
        p = (mouse[0] - bounds.x) / bounds.w
        cols = 3
        print(f"mouse: {mouse}, bounds: ({bounds.x}, {bounds.y}), X ({bounds.w}x{bounds.h}), p: {p}, cols: {cols}, res: {int(p * cols)}")
        return int(p * cols)

    def click_email_table(self, event):
        global SELECTED
        mouse = event.x_root, event.y_root
        # print(f"clicked table! mouse: {mouse}", dir(event))
        row_idx = self.get_row(mouse)
        col_idx = self.get_col(mouse)
        SELECTED.update({"row": row_idx, "col": col_idx, "mouse": mouse})
        for r in range(clamp(0, len(self.EMAIL_DATA), self.MAX_EMAILS)):
            if r == row_idx:
                # print(f"colouring: row: {r}, col: {BG_SELECTED_ROW}")
                for i in range(3):
                    self.EMAIL_DATA[r][f"col{i+1}"].config(readonlybackground=self.BG_SELECTED_ROW)
            else:
                bg = self.EMAIL_TABLE_COLOURS[r % len(self.EMAIL_TABLE_COLOURS)][0]
                fg = self.EMAIL_TABLE_COLOURS[r % len(self.EMAIL_TABLE_COLOURS)][1]
                # print(f"colouring: row: {r}: bg: {bg}")
                for i in range(3):
                    self.EMAIL_DATA[r][f"col{i+1}"].config(readonlybackground=bg)
            self.EMAIL_DATA[row_idx][f"col{col_idx+1}"].config(readonlybackground=self.BG_SELECTED_COL)
            for i in range(3):
                self.EMAIL_DATA[r][f"col{i+1}"].update()


class ArmstrongEmailBody:

    def __init__(self, body_in, delim_1="---  Fold Here  ---"):
        self.delim_1 = delim_1
        self.body_in = body_in

        self.parse()

    def parse(self):
        body = self.body_in
        spl_1 = body.split(self.delim_1)
        spl_2 = spl_1[-1].split("\n")


def load_armstrong_emails(count=None):
    outlook = win32com.client.Dispatch('outlook.application')
    mapi = outlook.GetNamespace("MAPI")
    for account in mapi.Accounts:
        print(account)

    armstrong_folder = mapi.Folders.Item("Avery Briggs").Folders.Item("Armstrong").Items
    # email = armstrong_folder.GetFirst()
    email = armstrong_folder.GetLast()
    email_items = {}
    i = 0

    # general updates come from infor@armcom.ca
    while email:
        try:
            print(f"i:{i}, email: {email}")
            email_data = dict()
            email_data['sent_on'] = dateutil.parser.parse(str(getattr(email, 'SentOn', '<UNKNOWN>')))
            email_data['T'] = type(email_data["sent_on"])
            email_data['sender'] = getattr(email, 'SenderEmailAddress', '<UNKNOWN>')
            email_data['receiver'] = getattr(email, 'to', '<UNKNOWN>')
            email_data['subject'] = getattr(email, 'subject', '<UNKNOWN>')
            email_data['cc'] = getattr(email, 'cc', '<UNKNOWN>')
            email_data['bcc'] = getattr(email, 'bcc', '<UNKNOWN>')
            email_data['body'] = getattr(email, 'body', '<UNKNOWN>') #[:25]
            # email_data["var1"] = tkinter.StringVar(value=email_data['sent_on'])  # date
            # email_data["var2"] = tkinter.StringVar(value=email_data['subject'])  # subject
            # email_data["var3"] = tkinter.StringVar(value=email_data['body'][:25])  # body[:25]
            email_data["col1"] = None  # date
            email_data["col2"] = None  # subject
            email_data["col3"] = None  # body[:25]
            email_items[i] = email_data
            print(f"\tdate: {email_data['sent_on']},\n\tfrom:\n\t{email_data['sender']},\n\tsubject:\n\t{email_data['subject']},\nbody: {email_data['body']}")
        except Exception as ex:
            print(f"Error processing mail\n\t{ex=}")
        i += 1
        if count is not None and i >= count:
            break
        email = armstrong_folder.GetPrevious()
        # email = armstrong_folder.GetNext()

    print(dict_print(email_items, "Email Items"))
    return email_items



if __name__ == "__main__":

    today = datetime.datetime.now()
    beginning_of_week = first_of_week(today)
    # today.replace(tzinfo=datetime.timezone.utc)
    # beginning_of_week.replace(tzinfo=datetime.timezone.utc)
    today.replace(tzinfo=pytz.utc)
    date_range = (beginning_of_week, today)
    emails = load_armstrong_emails()
    n_emails = len(emails)
    print(f"{emails=}")
    first_email_date = emails[0]['sent_on']
    last_email_date = emails[n_emails - 1]['sent_on']
    print(f"first= {first_email_date} to {last_email_date}")
    print(f"{datetime_is_tz_aware(first_email_date)=}\n{datetime_is_tz_aware(last_email_date)=}\n{datetime_is_tz_aware(date_range[0])=}\n{datetime_is_tz_aware(date_range[1])=}")

    print(f"{date_range=}")

    this_weeks = {k: v for k, v in emails.items() if beginning_of_week.timestamp() <= v["sent_on"].timestamp() <= today.timestamp()}
    this_weeks_keys = this_weeks.keys()
    print(f"{len(this_weeks)=}, {this_weeks=}")

    for email_key, email_data in this_weeks.items():
        # for key, data in email_data.items():
        sent_on = email_data["sent_on"]
        sender = email_data["sender"]
        receiver = email_data["receiver"]
        subject = email_data["subject"]
        cc = email_data["cc"]
        bcc = email_data["bcc"]
        body = email_data["body"]
        print(f"\t{sent_on=}\n\t{sender=}\n\t{receiver=}\n\t{subject=}\n\t{cc=}\n\t{bcc=}\n\t{body=}")



    # F_email_table


    # for i in range(50):
    #     try:
    #         lst = list(mapi.GetDefaultFolder(i).items)
    #         print(f"v: {len(list(mapi.GetDefaultFolder(i).items))}")
    #         for j in range(len(lst), len(lst)-25, -1):
    #             try:
    #                 print(f"i: {i}, j: {j}, v: ({str(lst[j])})")
    #             except:
    #                 continue
    #     except:
    #         print(f"i: {i} was a dud.")


    # inbox = mapi.GetDefaultFolder(6)
    # print(f"type: ({type(inbox)}), messages: ({inbox})")
    # armstrong_emails = mapi.GetDefaultFolder(6).Folders["Armstrong"]
    # armstrong_messages = armstrong_emails.Items
    # print(f"type: ({type(armstrong_messages)}), messages: ({armstrong_messages})")
    #
    # ae_1 = ArmstrongEmail(r"""C:\Users\ABriggs\Desktop\(80-01-0938) Account History Detail.msg""")
    # ae_1.parse()
