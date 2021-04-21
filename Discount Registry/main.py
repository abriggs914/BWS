import csv
import easygui
import datetime
from models import *
from utility import *
from discount import *
import tkinter as tk
from tkcalendar import Calendar
# import tksheet

admin=easygui.ynbox(msg="Run in ADMIN mode?", title="Admin Privileges", default_choice="No")  # allows a little more functionality  ! Beware of data consistency when using !

min_width = 1050
size = str(min_width) + 'x' + str(round(min_width * (6/9)))

original_entries = []  # Do not modify - contains the original contents from the file
discount_entries = []  # working entries, for display purposes only
dealers_entries = {} # holds a dictionary of dealers, with a list of indexes referencing original_entries
models_entries = {} # holds a dictionary of models, with a list of indexes referencing original_entries
class_entries = {} # holds a dictionary of classes, with a list of indexes referencing original_entries
dims = [0, 0, 0, 0, 0, 0, 0]
sort_status = None


def enable(frame):
    for child in frame.winfo_children():
        # print("t: {", type(child), "} child:", child)
        if type(child) == tk.Frame:
            enable(child)
        else:
            child.configure(state='normal')

def disable(frame):
    for child in frame.winfo_children():
        # print("t: {", type(child), "} child:", child)
        if type(child) == tk.Frame:
            disable(child)
        else:
            child.configure(state='disabled')


with open("discount_registry.csv") as f:
    f_dict = csv.DictReader(f)
    for i, entry in enumerate(f_dict):
        print(entry)
        # csv header
        #   dealer,model,slot,market,freight,date
        # app header
        #   Date, Dealer, Model, Class, Slot, Market, Freight
        vals = list(entry.values())
        vals = vals[:2] + list(map(lambda x: float(x) / 100, vals[2:4])) + vals[4:5] + ["IMPLEMENT CLASS"] + vals[5:]
        discount = Discount(*vals)

        if discount.dealer not in dealers_entries:
            dealers_entries[discount.dealer] = [i]
        else:
            dealers_entries[discount.dealer].append(i)

        if discount.model not in models_entries:
            models_entries[discount.model] = [i]
        else:
            models_entries[discount.model].append(i)

        if discount.clazz not in class_entries:
            class_entries[discount.clazz] = [i]
        else:
            class_entries[discount.clazz].append(i)

        print("discount", discount)
        original_entries.append(discount)
        discount_entries.append(discount)
        dims[0] = max(dims[0], len(str(discount.date)))
        dims[1] = max(dims[1], len(discount.dealer))
        dims[2] = max(dims[2], len(discount.model))
        dims[3] = max(dims[3], len(discount.clazz))
        dims[4] = max(dims[4], len(percent(discount.slot, 3)))
        dims[5] = max(dims[5], len(percent(discount.market, 3)))
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


def create_view(edit=False):
    global root, window_main
    # root['className'] = 'Create / Edit Discount'
    window_main.pack_forget()
    window_main.pack()

    today = datetime.date.today()
    label_names_list = ["Date", "Dealer", "Model", "Class", "Slot", "Market", "Freight"]
    label_names = dict(zip(label_names_list, [[] for i in label_names_list]))
    # root.geometry(size)
    window_create = tk.Frame(window_main)
    new_discount = None
    # window_create = tk.Frame(root)
    window_create.pack()



    font_1 = tk.font.Font(family='consolas')
    font_2 = tk.font.Font(family='consolas', weight='bold')
    fg = "gray84"
    bg = "red3"
    abg = "red4"
    afg = "gray84"
    sc = "red4"

    # date,dealer,model,class,slot,market,freight
    submit = tk.BooleanVar()
    entry_var_dealer = tk.StringVar()
    entry_var_model = tk.StringVar()
    entry_var_class = tk.StringVar()
    entry_var_slot = tk.DoubleVar()
    entry_var_market = tk.DoubleVar()
    entry_var_freight = tk.DoubleVar()
    
    selection_dealer = tk.StringVar()
    selection_model = tk.StringVar()
    selection_class = tk.StringVar()
    
    current_model_var = tk.IntVar()

    slot_var = tk.StringVar()
    market_var = tk.StringVar()
    freight_var = tk.StringVar()

    frame_labels = tk.Frame(window_create)
    frame_labels.pack(side=tk.LEFT)

    frame_entries = tk.Frame(window_create)
    frame_entries.pack(side=tk.RIGHT)

    combobox_model = None

    

    def status_change(*args):
        print("Status change")
        set_models()
    
    current_model_var.trace_add("write", status_change)
    

    def set_models():
        global combobox_model
        print("current_model_var:", current_model_var.trace_info())
        print("setting models, current_model_var:", current_model_var.get())
        combobox_model['values'] = [m for m in list(models_entries.keys()) if current_model_var.get() or by_models[m][2]]

    def main_loop():
        global combobox_model
        
        combobox_model = tk.ttk.Combobox(frame_entries, width = 27, textvariable = selection_model)

        # print("models_entries.keys():", models_entries.keys())
        # print("by_models:", by_models)
        # print(dict_print(by_models, "by_models"))
        # print("[by_models[m][2] for m in list(models_entries.keys())]:", [by_models[m][2] for m in list(models_entries.keys())])
        set_models()
        label_names["Model"].append(combobox_model)
        combobox_model.current()

        if admin:

            year = today.year
            month = today.month
            day = today.day
            cal = Calendar(frame_entries, selectmode = 'day',
                        year = year, month = month,
                        day = day)
            
            # cal.pack(pady = 20)
            
            def grad_date():
                date_in = datetime.datetime.strptime(cal.get_date(), "%m/%d/%y")
                date_in = date_in.strftime("%Y-%m-%d")
                date.config(text = "Selected Date is: " + date_in)
                print("Selected Date is: " + date_in)
                print("current_model_var: " + str(current_model_var.get()))
            
            # Add Button and Label
            btn_get_date = tk.Button(frame_entries, text = "Get Date",
                command = grad_date) 
            # btn_get_date.pack(pady = 20)
            
            date = tk.Label(frame_entries, text = "")
            # date.pack(pady = 20)

            label_names["Date"].append(cal)
            label_names["Date"].append(btn_get_date)
            label_names["Date"].append(date)

            current_checkbox = tk.Checkbutton(
                frame_entries,
                text="Include non-current models",
                variable=current_model_var, 
                bg=bg,
                fg=fg,
                font=font_1,
                onvalue=1,
                offvalue=0,
                indicatoron=1,
                activebackground=abg,
                activeforeground=afg,
                selectcolor=sc
            )
            label_names["Model"].append(current_checkbox)

        else:
            
            entry_date = tk.Entry(frame_entries, text=today)
            label_names["Date"].append(entry_date)
        
        # Combobox creation
        combobox_dealer = tk.ttk.Combobox(frame_entries, width = 27, textvariable = selection_dealer)
        combobox_dealer['values'] = list(dealers_entries.keys())
        label_names["Dealer"].append(combobox_dealer)
        combobox_dealer.current()
        
        combobox_class = tk.ttk.Combobox(frame_entries, width = 27, textvariable = selection_class)
        combobox_class['values'] = list(class_entries.keys())
        label_names["Class"].append(combobox_class)
        combobox_class.current()

        # validatecommand
        spinbox_slot = tk.Spinbox(
            frame_entries,
            to=100,
            from_=0,
            format="%.3f",
            textvariable=slot_var
        )
        label_names["Slot"].append(spinbox_slot)
        spinbox_market = tk.Spinbox(
            frame_entries,
            to=100,
            from_=0,
            textvariable=market_var
        )
        label_names["Market"].append(spinbox_market)
        spinbox_freight = tk.Spinbox(
            frame_entries,
            to=100,
            from_=0,
            textvariable=freight_var
        )
        label_names["Freight"].append(spinbox_freight)



            # window_create.rowconfigure(i, weight=1, minsize=300)
            #         window_create.columnconfigure(j, weight=1, minsize=100)

        # covered_cols = []
        for i, lbl_name in enumerate(label_names_list):
            entry_widget = label_names[lbl_name]
            if len(entry_widget) == 0:
                print("\t\tSKIPPED label_name:", lbl_name)
                continue
            lbl = tk.Label(frame_entries, text=lbl_name)
            lbl.grid(row=i, column=0, sticky="nsew", padx=5, pady=5)
            print("label_name:", lbl_name)
            for j, widget in enumerate(entry_widget):
                # if j not in covered_cols:
                #     covered_cols.append(j)
                # print("widget.size():", widget.size())
                widget.grid(row=i, column=1 + j, sticky="nsew", padx=5, pady=5)

        def q():
            global new_discount
            submit.set(True)
            d = "dealer"
            m = "model"
            s = 0
            k = 0
            f = 0
            c = "class"
            t = "2021-04-19"
            new_discount = Discount(d, m, s, k, f, c, t)

        btn_quit = tk.Button(window_create, text="QUIT", fg="red",
                                        command=q)
        btn_quit.pack(side=tk.BOTTOM)
        
        print("Before root.mainloop() in create_view")
        try:
            while not submit.get():
                root.update()
            #     pass
                # print("\tsubmit", submit.get())
                # root_create.draw()
                # root.update_idletasks()
                # root.update()
            print("After root.mainloop() in create_view")
            # root.destroy()
        except tk.TclError:
            print("_tkinter.TclError")

        return new_discount

    main_loop()
    disable(window_create)
    return new_discount


def freight_written(*args):
    print("Freight written", args)


def main_view():
    global root, window_main
    # root['className'] = 'Discount Registry'
    window_main.pack_forget()
    window_main.pack()
    window_view = tk.Frame(window_main)
    window_view.pack()
    # window_create = tk.Frame(root)
    listbox = None

    font_1 = tk.font.Font(family='consolas')
    font_2 = tk.font.Font(family='consolas', weight='bold')
    fg = "gray84"
    bg = "red3"
    abg = "red4"
    afg = "gray84"
    sc = "red4"

    check_btn_date = None
    check_btn_dealer = None
    check_btn_model = None
    check_btn_class = None
    check_btn_slot = None
    check_btn_market = None
    check_btn_freight = None
    search_entry = None

    entry_var_search = tk.StringVar()
    # search_check_input = tk.IntVar()
    check_var_date = tk.IntVar()
    check_var_dealer = tk.IntVar()
    check_var_model = tk.IntVar()
    check_var_class = tk.IntVar()
    check_var_slot = tk.IntVar()
    check_var_market = tk.IntVar()
    check_var_freight = tk.IntVar()

    # check_var_freight.trace_add("write", freight_written)
    
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
        listbox.insert(0, "| " + " | ".join(list(map(lambda x: pad_centre(x, dims[header.index(x)]), header))) + " |")
        for i, discount in enumerate(discount_entries):
            # print(discount.table_entry(dims))
            listbox.insert(i+1, discount.table_entry(dims))

    def init_listbox():
        
        listbox = tk.Listbox(window_view, selectmode=tk.EXTENDED, width=200)
        listbox['font'] = font_1

        add_data(listbox)
        
        return listbox

    def create_function():
        disable(window_view)
        print('Create a new discount')
        new_discount = create_view()
        print("new discount:", new_discount)
        enable(window_view)

    def edit_function():
        global listbox
        selection = listbox.curselection()
        if 0 in selection:
            selection.remove(0)
        print('Edit a discount :', selection)
        disable(window_view)
        new_discounts = []
        for sel in selection:
            new_discounts.append(create_view(edit=(discount_entries[sel])))
        print("edited discounts:", new_discounts)
        enable(window_view)

    def delete_function():
        global listbox
        selection = listbox.curselection()
        print('Delete a discount :', selection)

    def submit_function():
        global listbox
        selection = listbox.curselection()
        print('Listbox selection :', selection)

    def sort_by_date():
        global sort_status, listbox
        rev = sort_status == sort_by_date
        if rev:
            rev = rev if discount_entries[0].date < discount_entries[-1].date else not rev
        discount_entries.sort(key=lambda d: d.date, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_date

    def sort_by_dealer():
        global sort_status, listbox
        rev = sort_status == sort_by_dealer
        if rev:
            rev = rev if discount_entries[0].dealer.lower() < discount_entries[-1].dealer.lower() else not rev
        discount_entries.sort(key=lambda d: d.dealer.lower(), reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_dealer

    def sort_by_model():
        global sort_status, listbox
        rev = sort_status == sort_by_model
        if rev:
            rev = rev if discount_entries[0].model.lower() < discount_entries[-1].model.lower() else not rev
        discount_entries.sort(key=lambda d: d.model.lower(), reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_model

    def sort_by_class():
        global sort_status, listbox
        rev = sort_status == sort_by_class
        if rev:
            rev = rev if discount_entries[0].clazz < discount_entries[-1].clazz else not rev
        discount_entries.sort(key=lambda d: d.clazz, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_class

    def sort_by_slot():
        global sort_status, listbox
        rev = sort_status == sort_by_slot
        if rev:
            rev = rev if discount_entries[0].slot < discount_entries[-1].slot else not rev
        discount_entries.sort(key=lambda d: d.slot, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_slot

    def sort_by_market():
        global sort_status, listbox
        rev = sort_status == sort_by_market
        if rev:
            rev = rev if discount_entries[0].market < discount_entries[-1].market else not rev
        discount_entries.sort(key=lambda d: d.market, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_market

    def sort_by_freight():
        global sort_status, listbox
        rev = sort_status == sort_by_freight
        if rev:
            rev = rev if discount_entries[0].freight < discount_entries[-1].freight else not rev
        discount_entries.sort(key=lambda d: d.freight, reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_freight

    def submit_search():
        global discount_entries, listbox
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

        percentages = ["slot", "market"]
        monies = ["freight"]

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
                    if attr in percentages:
                        s = percent(float(s), 3)
                    if attr in monies:
                        s = money(float(s))
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
        reset_check_buttons()
        # print(dict_print(check_data, "res", number=True))

    
    def re_pop_entries():
        global listbox
        clear_data(listbox)
        repopulate_entries()
        add_data(listbox)


    def reset_check_buttons():
        global check_btn_date, check_btn_dealer, check_btn_model, check_btn_class, check_btn_slot, check_btn_market, check_btn_freight, search_entry
        checkbuttons = [check_btn_date, check_btn_dealer, check_btn_model, check_btn_class, check_btn_slot, check_btn_market, check_btn_freight]
        for btn in checkbuttons:
            btn.deselect()
        search_entry.delete(0, len(search_entry.get()))
        
    
    def main_loop():
        global listbox, check_btn_date, check_btn_dealer, check_btn_model, check_btn_class, check_btn_slot, check_btn_market, check_btn_freight, search_entry
        listbox = init_listbox()
        # print("sort_status:", sort_status)
        # print("dir:", dir())
        
        mod_btn_frame = tk.Frame(window_view)
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


        ctrl_btn_frame = tk.Frame(window_view)
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
                                    command=root.destroy)
        btn_quit.pack(side=tk.TOP)

        root.mainloop()

    main_loop()


root = tk.Tk(className='Discount Registry')
root.geometry(size)
window_main = tk.Frame(root)
window_main.pack()
main_view()