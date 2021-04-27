import csv
import datetime
from models import *
from utility import *
from discount import *
import tkinter as tk
from tkcalendar import Calendar
from models_writer import current, non_current
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

def hide(frame):
    for child in frame.winfo_children():
        # print("t: {", type(child), "} child:", child)
        if type(child) == tk.Frame:
            enable(child)
        else:
            child.configure(state=tk.HIDDEN)

def enable(frame):
    for child in frame.winfo_children():
        # print("t: {", type(child), "} child:", child)
        if type(child) == tk.Frame:
            enable(child)
        else:
            child.configure(state=tk.NORMAL)

def disable(frame):
    for child in frame.winfo_children():
        # print("t: {", type(child), "} child:", child)
        if type(child) == tk.Frame:
            disable(child)
        else:
            child.configure(state=tk.DISABLED)


def update_discounts(d):
    s = d.slot
    m = d.market
    f = d.freight
    for discount in original_entries:
        if discount == d:
            if any([
                s != discount.slot,
                m != discount.market,
                f != discount.freight,
            ]):

                print("CURRENT DISCOUNTS:\n" + "\n".join(list(map(str, original_entries))))
                raise ValueError("\n\n\tNeed to overwrite:\n\"" + str(discount) + "\"\n\twith:\n\"" + str(d) + "\"\n\n")
            else:
                # The entered values match existing records - no changes
                return

    append_discount(d)

def write_discount(d):
    with open("discount_registry.csv", 'r+') as f:
        f.write("\n" + d.registry_entry())
    read_entries()

def append_discount(d):
    with open("discount_registry.csv", 'a') as f:
        f.write("\n" + d.registry_entry())
    read_entries()

def read_entries():
    global original_entries, discount_entries, dealers_entries, models_entries, class_entries, dims
    original_entries = []  # Do not modify - contains the original contents from the file
    discount_entries = []  # working entries, for display purposes only
    dealers_entries = {} # holds a dictionary of dealers, with a list of indexes referencing original_entries
    models_entries = {} # holds a dictionary of models, with a list of indexes referencing original_entries
    class_entries = {} # holds a dictionary of classes, with a list of indexes referencing original_entries
    dims = [len(h) for h in TABLE_HEADER]
    with open("discount_registry.csv", 'r') as f:
        f_dict = csv.DictReader(f)
        for i, entry in enumerate(f_dict):
            print(entry)
            # csv header
            #   dealer,model,slot,market,freight,date
            # app header
            #   Date, Dealer, Model, Class, Slot, Market, Freight

            vals = list(entry.values())
            name_spl = vals[1].split(" ")
            model_name = name_spl[0].strip()
            model_class = name_spl[1].strip()[1:-1]
            m = DS.look_up_by_name(model_name, model_class)
            print("found:", m)
            vals = vals[:1] + [m] + list(map(lambda x: float(x) / 100, vals[2:4])) + vals[4:5] + ["IMPLEMENT CLASS"] + vals[5:]
            discount = Discount(*vals)
            print("discount: ", discount)
            print("discount.model:", discount.model)

            if discount.dealer not in dealers_entries:
                dealers_entries[discount.dealer] = [i]
            else:
                dealers_entries[discount.dealer].append(i)

            if discount.model not in models_entries:
                models_entries[DS.model_key(discount.model)] = [i]
            else:
                models_entries[DS.model_key(discount.model)].append(i)

            if discount.model.clazz not in class_entries:
                class_entries[discount.model.clazz] = [i]
            else:
                class_entries[discount.model.clazz].append(i)

            # print("discount", discount)
            original_entries.append(discount)
            discount_entries.append(discount)
            dims[0] = max(dims[0], len(str(discount.date)))
            dims[1] = max(dims[1], len(discount.dealer))
            dims[2] = max(dims[2], len(str(discount.model.model_name)))
            dims[3] = max(dims[3], len(discount.model.clazz))
            dims[4] = max(dims[4], len(percent(discount.slot, 3)))
            dims[5] = max(dims[5], len(percent(discount.market, 3)))
            dims[6] = max(dims[6], len(money(discount.freight)))
        # discout_entries = {k: v for k, v in f_dict.items()}

    original_entries.sort(key=lambda d: d.date, reverse=True)
    discount_entries.sort(key=lambda d: d.date, reverse=True)

    print("NEW DIMS:", dims)

def create_view(edit=False):
    global root, window_main
    new_discount = None
    # root['className'] = 'Create / Edit Discount'
    window_main.pack_forget()
    window_main.pack()

    today = datetime.date.today()
    label_names_list = ["Date", "Dealer", "Model", "Class", "Slot", "Market", "Freight"]
    label_names = dict(zip(label_names_list, [[] for i in label_names_list]))
    # root.geometry(size)
    window_create = tk.Frame(window_main)
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
    selection_date = tk.StringVar()
    
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
        # raise ValueError("Investigate the set_models function")
        set_models()
    
    current_model_var.trace_add("write", status_change)
    

    def set_models():
        global combobox_model
        print("current_model_var:", current_model_var.trace_info())
        print("setting models, current_model_var:", current_model_var.get())
        print("list(models_entries.keys()):", list(models_entries.keys()))
        tmn = "20ART"
        tmc = "TAGS"
        mlr = DS.look_up_by_name(tmn, tmc)
        print("model look up results:", mlr)
        print("current_model_var.get():", current_model_var.get(), "by_models[\"20ART\"][2]:", DS.by_model[str(mlr)][2], "current_model_var.get() or by_models[\"20ART\"][2]:", (current_model_var.get() or DS.by_model[str(mlr)][2]))
        # assert current_model_var.get() in by_models
        # print("\n\n\n\nASSERTION PASSED\n\n\n\n")
        # print("\nBY_MODELS:\n" + "\n".join(list(by_models.keys())))
        # print("LAST ENTRIES:", list(by_models.keys())[-5:])

        
        def ins(m):
            spl = m.split(" ")
            m = DS.look_up_by_name(spl[0].strip(), spl[1].strip()[1:-1])
            print("\tm", m)
            print("\t\tby_models[\"{0}\"]".format(m), m.status)
            # print("\t\tcurrent_model_var.get() {0}".format(type(current_model_var.get())), current_model_var.get(), "\n\t\tby_models[m][2] {0}".format(type(DS.by_model[str(DS.look_up_by_name(m))][2])), DS.by_model[str(DS.look_up_by_name(m))][2])
            # print("\t\tcurrent_model_var.get() or by_models[m][2]", (current_model_var.get() or DS.by_model[str(DS.look_up_by_name(m))][2]))
            return current_model_var.get() or m.status
                # combobox_model["values"] = combobox_model["values"] + [m] 


        combobox_model['values'] = [m for m in list(models_entries.keys()) if ins(m)]
        # combobox_model['values'] = []
        print("combobox_model[\"values\"] {0}:".format(type(combobox_model["values"])), combobox_model["values"])
        print("current_model_var.get()", current_model_var.get())
        # for m in list(models_entries.keys()):
            

    def main_loop():
        global combobox_model, new_discount
        
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
                        day = day, textvariable=selection_date,
                        firstweekday="sunday", date_pattern="y-mm-dd")
            # selection_date.set(datetime.datetime.strptime(cal.get_date(), "%m/%d/%y").strftime("%Y-%m-%d"))
            cal.selection_set(today)
            print("Init calendar:", cal.get_date())
            cal._display_selection()
            selection_date.set(cal.get_date())
            
            # cal.pack(pady = 20)
            
            def grad_date():
                # date_in = datetime.datetime.strptime(cal.get_date(), "%m/%d/%y")
                # date_in = date_in.strftime("%Y-%m-%d")
                date_in = cal.get_date()
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
        combobox_dealer = tk.ttk.Combobox(frame_entries, width=27, textvariable=selection_dealer)
        combobox_dealer['values'] = list(dealers_entries.keys())
        label_names["Dealer"].append(combobox_dealer)
        combobox_dealer.current()
        
        combobox_class = tk.ttk.Combobox(frame_entries, width=27, textvariable=selection_class)
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

        def save_quit():
            global new_discount
            try:
                d = selection_dealer.get()
                m = selection_model.get()
                s = slot_var.get()
                k = market_var.get()
                f = freight_var.get()
                c = selection_class.get()
                t = cal.get_date()

                model = DS.look_up_by_name(m, c)
                if model == None:
                    desc = easygui.enterbox(msg="Describe this model \"" + m + "\"", title="Description")  #.ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current")
                    stat = easygui.ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current", title="Status")
                    stat = current if s else non_current
                    model = Model(c, m, desc, stat)
                    DS.update(model)
                if not all([d, model, s, k, f, c, t]):
                    raise ValueError("Please check submission values")

                s = float(s) / 100
                k = float(k) / 100
                # t = datetime.datetime.strptime(t, "%m/%d/%y")
                # t = t.strftime("%Y-%m-%d")
                t = cal.get_date() 
                new_discount = Discount(d, model, s, k, f, c, t)
                submit.set(True)
                print("local new discount:", new_discount)
                print("local new discount:", new_discount.table_entry(dims))
            except TypeError:
                print("Type error")
            except ValueError:
                print("Value error")

        def q():
            submit.set(True)
            print("Quitting without saving")

        frame_btn = tk.Frame(window_create)
        frame_btn.pack(side=tk.BOTTOM)
        btn_save_quit = tk.Button(frame_btn, text="Save & Quit", fg="green",
                                        command=save_quit)
        btn_quit = tk.Button(frame_btn, text="Quit Without Saving", fg="red",
                                        command=q)
        btn_save_quit.pack(side=tk.LEFT)
        btn_quit.pack(side=tk.RIGHT)
        
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

        print("global new_discount:", new_discount)
        return new_discount

    new_discount = main_loop()
    # DS.update(new_discount.new_model_entry())
    print("global new_discount:", new_discount)
    # disable(window_create)
    window_create.destroy()
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
        if not discount_entries:
            return
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
        global listbox, by_models
        disable(window_view)
        print('Create a new discount')
        new_discount = create_view()
        did_update = False
        if new_discount:
            did_update = True
            update_discounts(new_discount)
        print("new discount {0}:".format(did_update), new_discount)
        # DS.adjust_models(new_discount)
        # read_entries()
        enable(window_view)
        clear_data(listbox)
        add_data(listbox)
        # by_models = create_by_model()
        # print("LAST ENTRIES:", list(by_models.keys())[-5:])

    def edit_function():
        global listbox
        selection = listbox.curselection()
        # if 0 in selection:
        #     selection.remove(0)
        # print('Edit a discount :', selection)
        # disable(window_view)
        # new_discounts = []
        # for sel in selection:
        #     new_discounts.append(create_view(edit=(discount_entries[sel])))
        # print("edited discounts:", new_discounts)
        # clear_data(listbox)
        # add_data(listbox)
        # enable(window_view)

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
        search_entry.delete(0, len(search_entry.get()))


    def reset_check_buttons():
        global check_btn_date, check_btn_dealer, check_btn_model, check_btn_class, check_btn_slot, check_btn_market, check_btn_freight, search_entry
        checkbuttons = [check_btn_date, check_btn_dealer, check_btn_model, check_btn_class, check_btn_slot, check_btn_market, check_btn_freight]
        for btn in checkbuttons:
            btn.deselect()
        # search_entry.delete(0, len(search_entry.get()))
        
    
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


if __name__ == "__main__":
    DS = DataSet()
    DS.init()
    read_entries()
    print(dims)
    root = tk.Tk(className='\Discount Registry')
    root.geometry(size)
    window_main = tk.Frame(root)
    window_main.pack()
    main_view()