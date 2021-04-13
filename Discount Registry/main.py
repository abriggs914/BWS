import csv
import easygui
from utility import *
from discount import Discount
import tkinter as tk
# import tksheet

discount_entries = []
dealers = []
dims = [0, 0, 0, 0, 0]
sort_status = None


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
    window_main = tk.Tk(className='Tkinter - TutorialKart')
    window_main.geometry('600x400')
    myFont = tk.font.Font(family='consolas')

    entry_var_search = tk.StringVar()
    search_radio_input = tk.IntVar()
    radio_var_dealer = 1
    radio_var_model = 2
    first_player_option_1 = 1
    first_player_option_2 = 2
    first_player_option_3 = 3
    
    # listbox_1.insert(2, "Perl")
    # listbox_1.insert(3, "C")
    # listbox_1.insert(4, "PHP")
    # listbox_1.insert(5, "JSP")
    # listbox_1.insert(6, "Ruby")

    def clear_data(listbox):
        listbox.delete(0, len(discount_entries))

    def add_data(listbox):
        for i, discount in enumerate(discount_entries):
            # print(discount.table_entry(dims))
            listbox.insert(i, discount.table_entry(dims))

    def init_listbox():
        
        listbox = tk.Listbox(window_main, selectmode=tk.EXTENDED, width=200)
        listbox['font'] = myFont

        add_data(listbox)
        
        return listbox

    listbox = init_listbox()

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
        global sort_status
        rev = sort_status == sort_by_dealer
        if rev:
            rev = rev if discount_entries[0].dealer.lower() < discount_entries[-1].dealer.lower() else not rev
        discount_entries.sort(key=lambda d: d.dealer.lower(), reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_dealer

    def sort_by_model():
        global sort_status
        rev = sort_status == sort_by_model
        if rev:
            rev = rev if discount_entries[0].model.lower() < discount_entries[-1].model.lower() else not rev
        discount_entries.sort(key=lambda d: d.model.lower(), reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_model

    def sort_by_slot():
        global sort_status
        rev = sort_status == sort_by_slot
        if rev:
            rev = rev if discount_entries[0].slot < discount_entries[-1].slot else not rev
        discount_entries.sort(key=lambda d: d.slot, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_slot

    def sort_by_market():
        global sort_status
        rev = sort_status == sort_by_market
        if rev:
            rev = rev if discount_entries[0].market < discount_entries[-1].market else not rev
        discount_entries.sort(key=lambda d: d.market, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_market

    def sort_by_freight():
        global sort_status
        rev = sort_status == sort_by_freight
        if rev:
            rev = rev if discount_entries[0].freight < discount_entries[-1].freight else not rev
        discount_entries.sort(key=lambda d: d.freight, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_freight

    def submit_search():
        print("performing search")
    
    print("sort_status:", sort_status)
    print("dir:", dir())
    
    mod_btn_frame = tk.Frame(window_main)
    mod_btn_frame.pack(side=tk.TOP)

    sort_btn_frame = tk.Frame(mod_btn_frame)
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


    search_btn_frame = tk.Frame(mod_btn_frame)
    search_btn_frame.pack(side=tk.BOTTOM)

    fg = "gray91"
    bg = "DarkOrange1"

    search_entry = tk.Entry(
		search_btn_frame,
		width=35,
		bg=bg,
		fg=fg,
		font=myFont,
		textvariable=entry_var_search
	)
    search_entry.pack(side=tk.LEFT)
    
    radio_btn_dealer = tk.Radiobutton(
		search_btn_frame,
		text="Dealer",
		bg=bg,
		fg=fg,
		font=myFont,
		variable=search_radio_input,
		value=radio_var_dealer,
		indicatoron = 0
	)
    radio_btn_dealer.pack(side=tk.LEFT)
    
    radio_btn_model = tk.Radiobutton(
		search_btn_frame,
		text="Model",
		bg=bg,
		fg=fg,
		font=myFont,
		variable=search_radio_input,
		value=radio_var_model,
		indicatoron = 0
	)
    radio_btn_model.pack(side=tk.LEFT)

    btn_submit_search = tk.Button(search_btn_frame, text='Search', command=submit_search)
    btn_submit_search.pack(side=tk.LEFT)
    

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
    
    window_main.mainloop()


main_view()