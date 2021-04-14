import csv
import easygui
from utility import *
from discount import *
import tkinter as tk
# import tksheet

original_entries = []  # Do not modify - contains the original contents from the file
discount_entries = []  # working entries, for display purposes only
dealers = []
dims = [0, 0, 0, 0, 0, 0, 0]
sort_status = None


with open("discount_registry.csv") as f:
    f_dict = csv.DictReader(f)
    for entry in f_dict:
        print(entry)
        # csv header
        #   dealer,model,slot,market,freight,date
        # app header
        #   Date, Dealer, Model, Class, Slot, Market, Freight
        vals = list(entry.values())
        vals = vals[:2] + list(map(lambda x: float(x) / 100, vals[2:5])) + ["IMPLEMENT CLASS"] + vals[5:]
        discount = Discount(*vals)
        print("discount", discount)
        original_entries.append(discount)
        discount_entries.append(discount)
        dims[0] = max(dims[0], len(str(discount.date)))
        dims[1] = max(dims[1], len(discount.dealer))
        dims[2] = max(dims[2], len(discount.model))
        dims[3] = max(dims[3], len(discount.clazz))
        dims[4] = max(dims[4], len(percent(discount.slot)))
        dims[5] = max(dims[5], len(percent(discount.market)))
        dims[6] = max(dims[6], len(money(discount.freight)))
    # discout_entries = {k: v for k, v in f_dict.items()}

original_entries.sort(key=lambda d: d.date, reverse=True)
discount_entries.sort(key=lambda d: d.date, reverse=True)

# class Application(tk.Frame):
#     def __init__(self, master=None):
#         super().__init__(master)
#         self.master = master
#         self.pack()
#         self.create_widgets()

#     def create_widgets(self):
#         self.hi_there = tk.Button(self)
#         self.hi_there["text"] = "Hello World\n(click me)"
#         self.hi_there["command"] = self.say_hi
#         self.hi_there.pack(side="top")

#         self.quit = tk.Button(self, text="QUIT", fg="red",
#                               command=self.master.destroy)
#         self.quit.pack(side="bottom")

#     def say_hi(self):
#         print("hi there, everyone!")

# root = tk.Tk()
# app = Application(master=root)
# app.mainloop()

print(dims)
def main_view():
    window_main = tk.Tk(className='Discout Registry')
    min_width = 1050
    size = str(min_width) + 'x' + str(round(min_width * (6/9)))
    window_main.geometry(size)
    font_1 = tk.font.Font(family='consolas')
    font_2 = tk.font.Font(family='consolas', weight='bold')

    entry_var_search = tk.StringVar()
    # search_check_input = tk.IntVar()
    check_var_date = tk.IntVar()
    check_var_dealer = tk.IntVar()
    check_var_model = tk.IntVar()
    check_var_class = tk.IntVar()
    check_var_slot = tk.IntVar()
    check_var_market = tk.IntVar()
    check_var_freight = tk.IntVar()
    
    # listbox_1.insert(2, "Perl")
    # listbox_1.insert(3, "C")
    # listbox_1.insert(4, "PHP")
    # listbox_1.insert(5, "JSP")
    # listbox_1.insert(6, "Ruby")

    def repopulate_entries():
        global discount_entries
        discount_entries = original_entries.copy()

    def clear_data(listbox):
        listbox.delete(0, len(discount_entries))

    def add_data(listbox):
        header = TABLE_HEADER
        listbox.insert(0, "| " + " | ".join(list(map(lambda x: pad_centre(x, dims[header.index(x)]), header))) + "|")
        for i, discount in enumerate(discount_entries):
            # print(discount.table_entry(dims))
            listbox.insert(i+1, discount.table_entry(dims))

    def init_listbox():
        
        listbox = tk.Listbox(window_main, selectmode=tk.EXTENDED, width=200)
        listbox['font'] = font_1

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

    def sort_by_date():
        global sort_status
        rev = sort_status == sort_by_date
        if rev:
            rev = rev if discount_entries[0].date < discount_entries[-1].date else not rev
        discount_entries.sort(key=lambda d: d.date, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_date

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

    def sort_by_class():
        global sort_status
        rev = sort_status == sort_by_class
        if rev:
            rev = rev if discount_entries[0].clazz < discount_entries[-1].clazz else not rev
        discount_entries.sort(key=lambda d: d.clazz, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_class

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
        global discount_entries
        print("\nperforming search")
        query = entry_var_search.get().lower()
        date = check_var_date.get()
        dealer = check_var_dealer.get()
        model = check_var_model.get()
        clazz = check_var_class.get()
        slot = check_var_slot.get()
        market = check_var_market.get()
        freight = check_var_freight.get()
        check_data = {
            "date": date,
            "dealer": dealer,
            "model": model,
            "clazz": clazz,
            "slot": slot,
            "market": market,
            "freight": freight,
        }

        none_selected = not any(list(check_data.values()))
        if none_selected:
            return

        filtered = []
        for entry in discount_entries:
            include = True
            matches = []
            i = 0
            for attr, val in check_data.items():
                i += 1
                if val:
                    print("\tchecking entry:", entry, ", at attr:", attr)
                    s = str(getattr(entry, attr)).lower()
                    if s not in query and query not in s:
                        include = False
                        # break
                    matches.append(include)
                if i != len(check_data):
                    include = True
                
                        # if the value is 1, then we want to include that name in the filtering process
            if any(matches):
                filtered.append(entry)
                print("NEW entry{ " + str(matches) + " }", entry)
        
        clear_data(listbox)
        discount_entries = filtered.copy()
        add_data(listbox)
        # print(dict_print(check_data, "res", number=True))

    
    def re_pop_entries():
        clear_data(listbox)
        repopulate_entries()
        add_data(listbox)
        
    
    # print("sort_status:", sort_status)
    # print("dir:", dir())
    
    mod_btn_frame = tk.Frame(window_main)
    mod_btn_frame.pack(side=tk.TOP)

    sort_btn_frame = tk.Frame(mod_btn_frame)
    sort_btn_frame.pack(side=tk.TOP)

    btn_sort_date = tk.Button(sort_btn_frame, text='Sort by Date', command=sort_by_date)
    btn_sort_date.pack(side=tk.LEFT)

    btn_sort_dealer = tk.Button(sort_btn_frame, text='Sort by Dealer', command=sort_by_dealer)
    btn_sort_dealer.pack(side=tk.LEFT)

    btn_sort_model = tk.Button(sort_btn_frame, text='Sort by Model', command=sort_by_model)
    btn_sort_model.pack(side=tk.LEFT)

    btn_sort_class = tk.Button(sort_btn_frame, text='Sort by Class', command=sort_by_class)
    btn_sort_class.pack(side=tk.LEFT)

    btn_sort_slot = tk.Button(sort_btn_frame, text='Sort by Slot %', command=sort_by_slot)
    btn_sort_slot.pack(side=tk.LEFT)

    btn_sort_market = tk.Button(sort_btn_frame, text='Sort by Market %', command=sort_by_market)
    btn_sort_market.pack(side=tk.LEFT)

    btn_sort_freight = tk.Button(sort_btn_frame, text='Sort by Freight %', command=sort_by_freight)
    btn_sort_freight.pack(side=tk.LEFT)


    search_btn_frame = tk.Frame(mod_btn_frame)
    search_btn_frame.pack(side=tk.BOTTOM)

    fg = "gray84"
    bg = "red3"
    abg = "red4"
    afg = "gray84"
    sc = "red4"

    search_entry = tk.Entry(
		search_btn_frame,
		width=35,
		bg=fg,
		fg=bg,
		font=font_2,
		textvariable=entry_var_search
	)
    search_entry.pack(side=tk.LEFT)
    
    check_btn_date = tk.Checkbutton(
		search_btn_frame,
		text="Date",
		bg=bg,
		fg=fg,
		font=font_1,
		variable=check_var_date,
		onvalue=1,
		offvalue=0,
		indicatoron = 0,
        activebackground=abg,
        activeforeground=afg,
        selectcolor=sc
	)
    check_btn_date.pack(side=tk.LEFT)
    
    check_btn_dealer = tk.Checkbutton(
		search_btn_frame,
		text="Dealer",
		bg=bg,
		fg=fg,
		font=font_1,
		variable=check_var_dealer,
		onvalue=1,
		offvalue=0,
		indicatoron = 0,
        activebackground=abg,
        activeforeground=afg,
        selectcolor=sc
	)
    check_btn_dealer.pack(side=tk.LEFT)
    
    check_btn_model = tk.Checkbutton(
		search_btn_frame,
		text="Model",
		bg=bg,
		fg=fg,
		font=font_1,
		variable=check_var_model,
		onvalue=1,
		offvalue=0,
		indicatoron = 0,
        activebackground=abg,
        activeforeground=afg,
        selectcolor=sc
	)
    check_btn_model.pack(side=tk.LEFT)
    
    check_btn_class = tk.Checkbutton(
		search_btn_frame,
		text="Class",
		bg=bg,
		fg=fg,
		font=font_1,
		variable=check_var_class,
		onvalue=1,
		offvalue=0,
		indicatoron = 0,
        activebackground=abg,
        activeforeground=afg,
        selectcolor=sc
	)
    check_btn_class.pack(side=tk.LEFT)
    
    check_btn_slot = tk.Checkbutton(
		search_btn_frame,
		text="Slot",
		bg=bg,
		fg=fg,
		font=font_1,
		variable=check_var_slot,
		onvalue=1,
		offvalue=0,
		indicatoron = 0,
        activebackground=abg,
        activeforeground=afg,
        selectcolor=sc
	)
    check_btn_slot.pack(side=tk.LEFT)
    
    check_btn_market = tk.Checkbutton(
		search_btn_frame,
		text="Market",
		bg=bg,
		fg=fg,
		font=font_1,
		variable=check_var_market,
		onvalue=1,
		offvalue=0,
		indicatoron = 0,
        activebackground=abg,
        activeforeground=afg,
        selectcolor=sc
	)
    check_btn_market.pack(side=tk.LEFT)
    
    check_btn_freight = tk.Checkbutton(
		search_btn_frame,
		text="Freight",
		bg=bg,
		fg=fg,
		font=font_1,
		variable=check_var_freight,
		onvalue=1,
		offvalue=0,
		indicatoron = 0,
        activebackground=abg,
        activeforeground=afg,
        selectcolor=sc
	)
    check_btn_freight.pack(side=tk.LEFT)

    btn_submit_search = tk.Button(search_btn_frame, text='Search', command=submit_search)
    btn_submit_search.pack(side=tk.LEFT)

    btn_repop_search = tk.Button(search_btn_frame, text='Show all entries', command=re_pop_entries)
    btn_repop_search.pack(side=tk.LEFT)
    

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