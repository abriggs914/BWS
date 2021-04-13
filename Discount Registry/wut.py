import csv
import easygui
from utility import *
from discount import Discount
import tkinter as tk
# import tksheet

discount_entries = []
dealers = []
dims = [0, 0, 0, 0, 0]


with open("discount_registry.csv") as f:
    f_dict = csv.DictReader(f)
    for entry in f_dict:
        print(entry)
        vals = list(entry.values())[:2] + list(map(lambda x: float(x) / 100, list(entry.values())[2:]))
        discount = Discount(*vals)
        print("discount", discount)
        discount_entries.append(discount)
        dims[0] = max(dims[0], len(discount.dealer.title()))
        dims[1] = max(dims[1], len(discount.model.upper()))
        dims[2] = max(dims[2], len(percent(discount.slot)))
        dims[3] = max(dims[3], len(percent(discount.market)))
        dims[4] = max(dims[4], len(money(discount.freight)))
    # discout_entries = {k: v for k, v in f_dict.items()}

class Application(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.pack()
        self.create_widgets()

    def create_widgets(self):
        self.hi_there = tk.Button(self)
        self.hi_there["text"] = "Hello World\n(click me)"
        self.hi_there["command"] = self.say_hi
        self.hi_there.pack(side="top")

        self.quit = tk.Button(self, text="QUIT", fg="red",
                              command=self.master.destroy)
        self.quit.pack(side="bottom")

    def say_hi(self):
        print("hi there, everyone!")

# root = tk.Tk()
# app = Application(master=root)
# app.mainloop()

print(dims)
def main_view():
    window_main = tk.Tk(className='Discount registry')
    listbox = None
    ctrl_btn_frame = None
    sort_btn_frame = None

    # listbox_1.insert(2, "Perl")
    # listbox_1.insert(3, "C")
    # listbox_1.insert(4, "PHP")
    # listbox_1.insert(5, "JSP")
    # listbox_1.insert(6, "Ruby")

    def init_listbox():
        
        myFont = tk.font.Font(family='consolas')
        listbox = tk.Listbox(window_main, selectmode=tk.EXTENDED, width=200)
        listbox['font'] = myFont

        for i, discount in enumerate(discount_entries):
            # print(discount.table_entry(dims))
            listbox.insert(i, discount.table_entry(dims))
        
        return listbox


    def init():
        global window_main, listbox, ctrl_btn_frame, sort_btn_frame
        window_main = tk.Tk(className='Discount registry')
        window_main.geometry('600x400')

        listbox = init_listbox()
        sort_btn_frame = tk.Frame(window_main)
        sort_btn_frame.pack(side=tk.TOP)

        btn_sort_dealer = tk.Button(sort_btn_frame, text='Sort by Dealer', command=sort_by_dealer)
        btn_sort_dealer.pack(side=tk.LEFT)

        btn_sort_model = tk.Button(sort_btn_frame, text='Sort by Model', command=sort_by_model)
        btn_sort_model.pack(side=tk.LEFT)

        btn_sort_slot = tk.Button(sort_btn_frame, text='Sort by Slot %', command=sort_by_slot)
        btn_sort_slot.pack(side=tk.LEFT)

        btn_sort_market = tk.Button(sort_btn_frame, text='Sort by Market %', command=sort_by_market)
        btn_sort_market.pack(side=tk.LEFT)

        btn_sort_freight = tk.Button(sort_btn_frame, text='Sort by Freight %', command=sort_by_freight)
        btn_sort_freight.pack(side=tk.LEFT)


        listbox.pack()


        ctrl_btn_frame = tk.Frame(window_main)
        ctrl_btn_frame.pack(side=tk.BOTTOM)

        btn_create = tk.Button(ctrl_btn_frame, text='Create', command=create_function)
        btn_create.pack(side=tk.LEFT)

        btn_edit = tk.Button(ctrl_btn_frame, text='Edit', command=edit_function)
        btn_edit.pack(side=tk.LEFT)

        btn_delete = tk.Button(ctrl_btn_frame, text='Delete', command=delete_function)
        btn_delete.pack(side=tk.LEFT)
        # btn_submit = tk.Button(window_main, text='Submit', command=submit_function)
        # btn_submit.pack()

        btn_quit = tk.Button(ctrl_btn_frame, text="QUIT", fg="red",
                                    command=window_main.destroy)
        btn_quit.pack(side=tk.TOP)

        return window_main

    def create_function():
        print('Create a new discount')

    def edit_function():
        selection = listbox.curselection()
        print('Edit a discount :', selection)

    def delete_function():
        selection = listbox.curselection()
        print('Delete a discount :', selection)

    def submit_function():
        selection = listbox.curselection()
        print('Listbox selection :', selection)

    def sort_by_dealer():
        stop_loop()
        init()
        discount_entries.sort(key=lambda d: d.dealer.lower())
        listbox = init_listbox()
        main_loop()

    def sort_by_model():
        stop_loop()
        init()
        discount_entries.sort(key=lambda d: d.model.lower())
        listbox = init_listbox()
        main_loop()

    def sort_by_slot():
        stop_loop()
        init()
        discount_entries.sort(key=lambda d: d.slot)
        listbox = init_listbox()
        main_loop()

    def sort_by_market():
        stop_loop()
        init()
        discount_entries.sort(key=lambda d: d.market)
        listbox = init_listbox()
        main_loop()

    def sort_by_freight():
        stop_loop()
        init()
        discount_entries.sort(key=lambda d: d.freight)
        listbox = init_listbox()
        main_loop()

    def stop_loop():
        ctrl_btn_frame.destroy()
        sort_btn_frame.destroy()
        window_main.destroy()

    def main_loop():
        window_main.mainloop()
    

    
    window_main = init()
    main_loop()
    # window_main.mainloop()


main_view()