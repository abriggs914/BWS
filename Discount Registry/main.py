import csv
import time
import random
import datetime
import traceback
from models import *
from utility import *
from discount import *
import tkinter as tk
from tkcalendar import Calendar
from tkinter.scrolledtext import ScrolledText
from models_writer import current, non_current

# import tksheet

admin = easygui.ynbox(msg="Run in ADMIN mode?", title="Admin Privileges",
                      default_choice="No")  # allows a little more functionality  ! Beware of data consistency when using !
TRUE_FOR_NOW = True

root = None
min_width = 1050
size = str(min_width) + 'x' + str(round(min_width * (6 / 9)))

original_entries = []  # Do not modify - contains the original contents from the file
discount_entries = []  # working entries, for display purposes only
dealers_entries = {}  # holds a dictionary of dealers, with a list of indexes referencing original_entries
models_entries = {}  # holds a dictionary of models, with a list of indexes referencing original_entries
class_entries = {}  # holds a dictionary of classes, with a list of indexes referencing original_entries
dims = [0, 0, 0, 0, 0, 0, 0]
sort_status = None
new_discount = None
status_update = None
full_size = None
CREATE_BG = "lightsteelblue"
CREATE_BTN_BG = "lightslategray"
CREATE_LBL_BG = "lightslategray"
INFO_MSG_FG = "firebrick4"
IMPLEMENT_PROPOSED_FIELD = 0

font_1 = None
font_2 = None
font_3 = None
fg = "gray84"
bg = "red3"
abg = "red4"
afg = "gray84"
sc = "red4"


def discount_display_info():
    return "Showing {0} / {1} discount entries".format(len(discount_entries), len(original_entries))


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
        if isinstance(child, tk.Frame):
            enable(child)
        elif isinstance(child, tk.Scrollbar):
            continue
        else:
            child.configure(state=tk.NORMAL)


def disable(frame):
    for child in frame.winfo_children():
        # print("t: {", type(child), "} child:", child)
        if isinstance(child, tk.Frame):
            disable(child)
        elif isinstance(child, tk.Scrollbar):
            continue
        else:
            child.configure(state=tk.DISABLED)


def update_discounts(d):
    global status_update
    s = d.slot
    m = d.market
    f = d.freight
    for discount in original_entries:
        if discount == d:
            print("DISCOUNT FOUND IN ORIGINAL_ENTRIES")
            if any([
                s != discount.slot,
                m != discount.market,
                f != discount.freight,
            ]):

                print("CURRENT DISCOUNTS:\n" + "\n".join(list(map(str, original_entries))))
                # raise ValueError("\n\n\tNeed to overwrite:\n\"" + str(discount) + "\"\n\twith:\n\"" + str(d) + "\"\n\ntype(original_entries): " + str(type(original_entries)) + "\n\ntype(discount_entries): " + str(type(discount_entries)))
                update_discount(discount)
                status_update = "Updated discount: [\t" + str(discount) + "] to [" + str(d) + "\t]"
                append_discount(d)
                return
            else:
                # The entered values match existing records - no changes
                return
    print("DISCOUNT NOT FOUND IN ORIGINAL_ENTRIES")

    append_discount(d)
    status_update = "Created discount: [\t" + str(d) + "\t]"


def update_discount(d):
    header = "dealer,model,slot,market,freight,date"
    # if d in discount_entries:
    original_entries.remove(d)
    with open("discount_registry.csv", 'w') as f:
        f.write(header)
        for d in original_entries:
            f.write("\n" + d.registry_entry())

    original_entries.append(d)
    read_entries()


def append_discount(d):
    with open("discount_registry.csv", 'a') as f:
        f.write("\n" + d.registry_entry())
    read_entries()


def remove_discount(d):
    print("Removing discount entry: {0}".format(d))
    entries = {}
    targets = []
    with open("discount_registry.csv", 'r+') as f:
        # f_dict = csv.DictReader(f)
        lines = list(f.readlines())
        new_lines = []
        header = None
        print("lines:", lines)
        for i, line in enumerate(lines):
            print("\tline: <{0}>\n\tline.strip(): <{1}>\n\tline.strip().split(\",\"): <{2}>".format(line, line.strip(),
                                                                                                    line.strip().split(
                                                                                                        ",")))
            if i == 0:
                header = line.strip().split(",")
                continue
            entry = dict(zip(header, line.strip().split(",")))
            print("header:", header, ",line: <{0}>".format(line), ",entry:", entry)
            e_d = entry["dealer"]
            e_m = entry["model"]
            spl = e_m.split("<")
            e_c = spl[1][:-1].strip()
            print("spl: {0}, e_c: {1}, spl[0].strip(): <{2}>".format(spl, e_c, spl[0].strip()))
            e_m = DS.look_up_by_name(spl[0].strip(), e_c)
            if e_m == None:
                raise ValueError("Model look up returned None")
            d_d = d.dealer
            d_m = d.model
            d_c = d_m.clazz
            if all([
                e_d.lower() == d_d.lower(),
                e_m.model_name.lower() == d_m.model_name.lower(),
                e_c.lower() == d_c.lower(),
            ]):
                targets.append(entry)
            else:
                new_lines.append(",".join(list(entry.values())))
            entries["Entry {0}".format(i)] = list(entry.values())

        f.truncate(0)
        f.seek(0)
        f.write(",".join(header))
        for line in new_lines:
            print("writing line: {0}".format(line))
            f.write("\n" + line)
    print(dict_print(entries, "Entries"))
    print("Targeting:", targets)
    # raise ValueError("Stop here")
    read_entries()


def read_entries():
    global original_entries, discount_entries, dealers_entries, models_entries, class_entries, dims
    original_entries = []  # Do not modify - contains the original contents from the file
    discount_entries = []  # working entries, for display purposes only
    dealers_entries = {}  # holds a dictionary of dealers, with a list of indexes referencing original_entries
    models_entries = {}  # holds a dictionary of models, with a list of indexes referencing original_entries
    class_entries = {}  # holds a dictionary of classes, with a list of indexes referencing original_entries
    dims = [len(h) for h in TABLE_HEADER]
    with open("discount_registry.csv", 'r') as f:
        f_dict = csv.DictReader(f)
        for i, entry in enumerate(f_dict):
            print("entry:", entry)
            # csv header
            #   dealer,model,slot,market,freight,date
            # app header
            #   Date, Dealer, Model, Class, Slot, Market, Freight

            vals = list(entry.values())
            name_val = vals[1]
            name_spl = name_val.split("<")
            model_name = name_spl[0].strip()
            print("vals <{vals}>\nname_val: <{nv}>\nname_spl: <{ns}>\nmodel_name: <{mn}>".format(vals=vals, nv=name_val,
                                                                                                 ns=name_spl,
                                                                                                 mn=model_name))
            model_class = name_spl[1].strip()[0:-1]
            m = DS.look_up_by_name(model_name, model_class)
            # print("found:", m)
            vals = vals[:1] + [m] + list(map(lambda x: float(x) / 100, vals[2:4])) + vals[4:5] + vals[5:]
            print("\tvals:", vals)
            discount = Discount(*vals)
            print("discount: ", discount)
            print("discount.model:", discount.model)

            if discount.dealer not in dealers_entries:
                dealers_entries[discount.dealer] = [i]
            else:
                dealers_entries[discount.dealer].append(i)

            if discount.model not in models_entries:
                models_entries[discount.model] = [i]
            else:
                models_entries[discount.model].append(i)

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

    if TRUE_FOR_NOW or admin:
        load_all_models()
        load_all_classes()


def load_all_models():
    print("DS:", DS)
    # original_entries = []  # Do not modify - contains the original contents from the file
    # discount_entries = []  # working entries, for display purposes only
    # dealers_entries = {} # holds a dictionary of dealers, with a list of indexes referencing original_entries
    # models_entries = {} # holds a dictionary of models, with a list of indexes referencing original_entries
    for model in DS.models:
        # print("model:", model, "type(model):", type(model))
        if model not in models_entries:
            models_entries[model] = [-1]


def load_all_classes():
    # class_entries = {} # holds a dictionary of classes, with a list of indexes referencing original_entries
    for clazz in DS.by_class:
        if clazz not in class_entries:
            class_entries[clazz] = [-1]


# edit must be a discount object.
def create_view(edit=False):
    global root, window_main, status_update
    # root['className'] = 'Create / Edit Discount'
    window_main.pack_forget()
    window_main.pack()

    today = datetime.date.today()

    feedback_contents = []
    label_names_list = ["Date", "Dealer", "Model", "Class", "Slot", "Market", "Freight"]
    label_names = dict(zip(label_names_list, [[] for i in label_names_list]))
    # root.geometry(size)
    window_create = tk.Frame(window_main, bg=CREATE_BG)
    # window_create = tk.Frame(root)
    window_create.pack()

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
    feedback_var = tk.StringVar()

    frame_labels = tk.Frame(window_create, bg=CREATE_BG)
    frame_labels.pack(side=tk.LEFT)

    frame_entries = tk.Frame(window_create, bg=CREATE_BG)
    frame_entries.pack(side=tk.RIGHT)

    combobox_model = None
    status_update = "STATUS UPDATE"
    SEM = "Please check submission values.\n"

    def ins(m, override=False):
        # spl = m.split(" ")
        # print("m:", m, "spl",spl)
        # m = DS.look_up_by_name(spl[0].strip(), spl[1].strip()[1:-1])
        print("============================\n\tm.status", m.status, "\n\tcurrent_model_var.get():",
              current_model_var.get(), "\n\tOR", (current_model_var.get() or m.status))
        print("\t\tby_models[\"{0}\"]".format(m), m.status)
        # print("\t\tcurrent_model_var.get() {0}".format(type(current_model_var.get())), current_model_var.get(), "\n\t\tby_models[m][2] {0}".format(type(DS.by_model[str(DS.look_up_by_name(m))][2])), DS.by_model[str(DS.look_up_by_name(m))][2])
        # print("\t\tcurrent_model_var.get() or by_models[m][2]", (current_model_var.get() or DS.by_model[str(DS.look_up_by_name(m))][2]))
        if current_model_var.get() or m.status:
            print("INCLUDE")
        return current_model_var.get() or m.status or override
        # combobox_model["values"] = combobox_model["values"] + [m] 

    def status_change(*args):
        print("Status change")
        # raise ValueError("Investigate the set_models function")
        set_models()

    def model_chosen(*args):
        model_name = selection_model.get()
        print("selection_model.get()", model_name)
        if not selection_class.get():
            matching_models = [m for m in DS.models if m.model_name == model_name]
            print("matching models", matching_models)
            if len(matching_models) == 1:
                selection_class.set(matching_models[0].clazz)
            # else:

            # model = DS.look_up_by_name(name, clazz)
            # selection_class.set()
        print("Model selected or cleared")

    current_model_var.trace_add("write", status_change)
    selection_model.trace_add(("write", "unset"), model_chosen)

    def set_models():
        global combobox_model
        print("current_model_var:", current_model_var.trace_info())
        print("setting models, current_model_var:", current_model_var.get())
        print("list(models_entries.keys()):", list(models_entries.keys()))
        # tmn = "20ART"
        # tmc = "TAGS"
        # mlr = DS.look_up_by_name(tmn, tmc)
        # print("model look up results:", mlr)
        # print("current_model_var.get():", current_model_var.get(), "by_models[\"20ART\"][2]:", DS.by_model[str(mlr)][2], "current_model_var.get() or by_models[\"20ART\"][2]:", (current_model_var.get() or DS.by_model[str(mlr)][2]))
        # assert current_model_var.get() in by_models
        # print("\n\n\n\nASSERTION PASSED\n\n\n\n")
        # print("\nBY_MODELS:\n" + "\n".join(list(by_models.keys())))
        # print("LAST ENTRIES:", list(by_models.keys())[-5:])

        model_names = [m.model_name for m in models_entries.keys() if ins(m)]
        model_names.sort()
        combobox_model['values'] = model_names
        # combobox_model['values'] = []
        print("combobox_model[\"values\"] {0}:".format(type(combobox_model["values"])), combobox_model["values"])
        print("current_model_var.get()", current_model_var.get())
        # for m in list(models_entries.keys()):

    def main_loop():
        global combobox_model, new_discount

        # up = lambda *args: feedback_window.insert(tk.END, ".1")

        combobox_model = tk.ttk.Combobox(frame_entries, width=27, textvariable=selection_model)

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
            cal = Calendar(frame_entries, selectmode='day',
                           year=year, month=month,
                           day=day, textvariable=selection_date,
                           firstweekday="sunday", date_pattern="y-mm-dd")
            # selection_date.set(datetime.datetime.strptime(cal.get_date(), "%m/%d/%y").strftime("%Y-%m-%d"))
            cal.selection_set(today)
            print("Init calendar:", cal.get_date())
            cal._display_selection()
            selection_date.set(cal.get_date())

            # cal.pack(pady = 20)

            def cal_set_today():
                # date_in = datetime.datetime.strptime(cal.get_date(), "%m/%d/%y")
                # date_in = date_in.strftime("%Y-%m-%d")
                # date_in = cal.get_date()
                # date.config(text = "Selected Date is: " + date_in)
                # print("Selected Date is: " + date_in)
                # print("current_model_var: " + str(current_model_var.get()))
                cal.selection_set(datetime.datetime.today())

            # Add Button and Label
            btn_set_today = tk.Button(
                frame_entries,
                text="Today",
                command=cal_set_today,
                bg=CREATE_BTN_BG
            )
            # btn_get_date.pack(pady = 20)

            date = tk.Label(frame_entries, text="", bg=CREATE_LBL_BG)
            # date.pack(pady = 20)

            label_names["Date"].append(cal)
            label_names["Date"].append(btn_set_today)
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
        dealer_names = list(dealers_entries.keys())
        dealer_names.sort()
        combobox_dealer['values'] = dealer_names
        label_names["Dealer"].append(combobox_dealer)
        combobox_dealer.current()

        combobox_class = tk.ttk.Combobox(frame_entries, width=27, textvariable=selection_class)
        class_names = list(class_entries.keys())
        class_names.sort()
        combobox_class['values'] = class_names
        label_names["Class"].append(combobox_class)
        combobox_class.current()

        # validatecommand
        spinbox_slot = tk.Spinbox(
            frame_entries,
            to=100,
            from_=0,
            format="%.1f",
            textvariable=slot_var
        )
        label_names["Slot"].append(spinbox_slot)
        spinbox_market = tk.Spinbox(
            frame_entries,
            to=100,
            from_=0,
            format="%.1f",
            textvariable=market_var
        )
        label_names["Market"].append(spinbox_market)
        spinbox_freight = tk.Spinbox(
            frame_entries,
            to=100,
            from_=0,
            format="%.1f",
            textvariable=freight_var
        )
        label_names["Freight"].append(spinbox_freight)

        def focus_next_window(event):
            event.widget.tk_focusNext().focus()
            return ("break")

            # window_create.rowconfigure(i, weight=1, minsize=300)
            #         window_create.columnconfigure(j, weight=1, minsize=100)

        # covered_cols = []
        for i, lbl_name in enumerate(label_names_list):
            entry_widget = label_names[lbl_name]
            if len(entry_widget) == 0:
                print("\t\tSKIPPED label_name:", lbl_name)
                continue
            lbl = tk.Label(frame_entries, text=lbl_name, bg=CREATE_BG)
            lbl.grid(row=i, column=0, sticky="nsew", padx=5, pady=5)
            print("label_name:", lbl_name)
            for j, widget in enumerate(entry_widget):
                # if j not in covered_cols:
                #     covered_cols.append(j)
                # print("widget.size():", widget.size())
                widget.bind("<Tab>", focus_next_window)  # TODO: why doesn't this work?
                if not isinstance(widget, tk.Button):
                    widget.grid(row=i, column=1 + j, sticky="nsew", padx=5, pady=5)
                else:
                    widget.grid(row=i, column=1 + j, sticky="sw", padx=5, pady=5)

        def submit_entries(p_d=None, p_m=None, p_s=None, p_k=None, p_f=None, p_t=None):
            disc = None
            try:
                d = selection_dealer.get() if p_d == None else p_d
                m = selection_model.get() if p_m == None else p_m.model_name
                s = slot_var.get() if p_s == None else p_s
                k = market_var.get() if p_k == None else p_k
                f = freight_var.get() if p_f == None else p_f
                c = selection_class.get() if p_m == None else "" if not isinstance(p_m, Model) else p_m.clazz
                t = cal.get_date() if p_t == None else p_t

                for val in [d, m, c]:
                    val.replace(",", "")

                t_d, t_m, t_s, t_k, t_f, t_c, t_t = [True if item else False for item in [d, m, s, k, f, c, t]]
                print("\tVALUES\nm:", m, "\nc:", c, "\nt_c:", t_c, "\np_m:", p_m, "\ntype(p_m):", type(p_m))
                missing_entries = ""
                if not t_d and p_t == None:
                    missing_entries += "\n\tDealer field is blank."
                if not t_m and p_m == None:
                    missing_entries += "\n\tModel field is blank."
                if not t_c:
                    missing_entries += "\n\tClass field is blank."
                if not t_s and p_s == None:
                    missing_entries += "\n\tSlot field is blank."
                if not t_k and p_k == None:
                    missing_entries += "\n\tMarket field is blank."
                if not t_f and p_f == None:
                    missing_entries += "\n\tFreight field is blank."

                if not all([t_d, t_m, t_s, t_k, t_f, t_c, t_t]):
                    feedback(SEM + missing_entries, err=True)
                    raise ValueError()
                # if not t_t:
                #     feedback(SEM + "\tDealer field is blank.")
                #     raise ValueError()

                value_issues = ""
                if not isfloat(s):
                    value_issues += "\n\tSlot value must be a decimal number."
                if not isfloat(k):
                    value_issues += "\n\tMarket value must be a decimal number."
                if not isfloat(f):
                    value_issues += "\n\tFreight value must be a decimal number."
                if value_issues:
                    feedback(SEM + value_issues, err=True)
                    raise ValueError()

                print("not any([p_d, p_m, p_s, p_k, p_f, p_t])", (not any([p_d, p_m, p_s, p_k, p_f, p_t])))
                print("not validate_zeros(s, k, f)", (not validate_zeros(s, k, f)))
                if not any([p_d, p_m, p_s, p_k, p_f, p_t]) and not validate_zeros(s, k, f):
                    return
                # if all(list(map(lambda v: float(v) == 0, [s, k, f]))):
                #     reply = easygui.ynbox(msg="Are you sure you want to create a\ndiscount with all \'0\' values?", default_choice="No", cancel_choice="No", title="Discount Creation")
                #     if not reply:
                #         return

                model = p_m if isinstance(p_m, Model) else DS.look_up_by_name(m, c)
                do_update = False

                if model == None:
                    reply = easygui.ynbox(msg="Do you want to create a new model entry?", default_choice="No",
                                          cancel_choice="No", title="Model Creation")
                    if not reply:
                        return
                    desc = easygui.enterbox(msg="Describe this model \"" + m + "\" from class \"" + c + "\"",
                                            title="Description")  # .ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current")
                    stat = easygui.ynbox(msg="Is this model current?", choices=["Current", "Non-current"],
                                         default_choice="Current", cancel_choice="Current", title="Status")
                    stat = current if stat else non_current
                    # stat = non_current if stat else current
                    model = Model(c, m, desc, stat, IMPLEMENT_PROPOSED_FIELD)
                    print("model entry creation:", model.fields_list())
                    # raise ValueError("STOP")
                    do_update = True
                if not model:
                    feedback(SEM + "Please check submission values <not model>", err=True)
                    raise ValueError("Please check submission values")
                if do_update:
                    DS.update(model)

                s = float(s) / 100
                k = float(k) / 100
                # t = datetime.datetime.strptime(t, "%m/%d/%y")
                # t = t.strftime("%Y-%m-%d")
                t = cal.get_date()
                disc = Discount(d, model, s, k, f, t)
                submit.set(True)
                print("local new discount:", disc)
                print("local new discount:", disc.table_entry(dims))
                feedback("Discount creation successful! <{0}>".format(disc))
            except TypeError:
                print("Type error")
                # feedback("Please check submission values <TypeError>")
                traceback.print_exc()
            except ValueError:
                print("Value error")
                # feedback("Please check submission values <ValueError>")
                traceback.print_exc()
            return disc

        def validate_zeros(s, k, f):
            reply = True
            if all(list(map(lambda v: float(v) == 0, [s, k, f]))):
                reply = easygui.ynbox(msg="Are you sure you want to create a\ndiscount with all \"0\" values?",
                                      default_choice="No", cancel_choice="No", title="Discount Creation")
            return reply

        def save_quit():
            global new_discount
            new_discount = submit_entries()

        def q():
            submit.set(True)
            # time.sleep(2)
            print("Quitting without saving")
            feedback("Quitting without saving")

        def mass_apply():
            global new_discount, dealers_entries
            print("mass apply")
            d = selection_dealer.get()
            m = selection_model.get()
            c = selection_class.get()
            s = slot_var.get()
            k = market_var.get()
            f = freight_var.get()

            value_issues = ""
            if not isfloat(s):
                value_issues += "\n\tSlot value must be a decimal number."
            if not isfloat(k):
                value_issues += "\n\tMarket value must be a decimal number."
            if not isfloat(f):
                value_issues += "\n\tFreight value must be a decimal number."
            if value_issues:
                feedback(SEM + value_issues, err=True)
                raise ValueError()

            if not validate_zeros(s, k, f):
                return
            print("d: <{d}>, m: <{m}>, C: <{c}>".format(d=d, m=m, c=c))
            if d or c:
                new_discount = []
                new_model = None
                if d and c:

                    if d not in dealers_entries:
                        reply = easygui.ynbox(
                            msg="Dealer \"{0}\" not found.\nWould you like to create a new entry?".format(d),
                            default_choice="No", cancel_choice="No", title="Dealer Creation")
                        if reply:
                            dealers_entries[d] = [len(original_entries)]

                    if c not in DS.by_class and m:
                        reply = easygui.ynbox(
                            msg="Class \"{0}\" not found.\nWould you like to create a new entry?".format(c),
                            default_choice="No", cancel_choice="No", title="Dealer Creation")
                        if reply:
                            class_entries[c] = [len(original_entries)]

                            desc = easygui.enterbox(msg="Describe this model \"" + m + "\" from class \"" + c + "\"",
                                                    title="Description")  # .ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current")
                            stat = easygui.ynbox(msg="Is this model current?", choices=["Current", "Non-current"],
                                                 default_choice="Current", cancel_choice="Current", title="Status")
                            stat = current if stat else non_current
                            # stat = non_current if stat else current
                            new_model = Model(c, m, desc, stat, IMPLEMENT_PROPOSED_FIELD)
                            DS.update(new_model)

                            # DS.add_class(c, model)

                    # apply a given discount structure to each model within the given class for the given dealer
                    # "1% slot on all Tags"

                    if c in DS.by_class:
                        print("DS.by_class[c]:", DS.by_class[c])
                        models = [m_val for m_val in DS.by_class[c] if
                                  ins(m_val) or (True if m and m_val.model_name.lower() == m.lower() else False)]
                        if new_model != None:
                            models.append(new_model)
                        # for m_val in DS.by_class[c]:
                        #     print("m_val:", m_val, ", ins(m_val)", ins(m_val))
                        model_ref = {str(m_val): m_val for m_val in models}
                        print("models:", models)
                        print("model_ref:", model_ref)

                        if d in dealers_entries:
                            if len(models) > 1:
                                filtered_models = easygui.multchoicebox(
                                    msg="Apply Discount Structure:\n\t\"{0} % slot, {1} % market, and a {2} freight\"\nTo dealer \"{3}\"?\n\nNo selection defaults to all listed models.\n\nSelected Models will have this discount structure applied.".format(
                                        s, k, money(float(f)), d),
                                    title="Filter Models",
                                    choices=models,
                                    preselect=None
                                    # preselect=[i for i in range(len(models))]
                                )
                            else:
                                filtered_models = list(map(str, models))
                            print("filtered_models:", filtered_models)
                            filtered_models = [model_ref[m_val] for m_val in filtered_models]
                            print("filtered_models:", filtered_models)
                            if not filtered_models:
                                filtered_models = models.copy()
                            for model in filtered_models:
                                disc = submit_entries(p_d=d, p_m=model, p_t=datetime.datetime.today())
                                print("Found model: <{0}> for dealer: <{1}> when mass applying to class: <{2}>".format(
                                    model, d, c))
                                if disc == None:
                                    feedback("Error mass applying discount structure")
                                    return
                                new_discount.append(disc)
                        else:
                            print(
                                "Dealer: <{0}> not found in dealers_entries when mass applying to class: <{1}>".format(
                                    d, c))
                            # reply = easygui.ynbox(msg="No entries found for dealer \"{0}\".\nWould you like to create an entry?".format(d), default_choice="No", cancel_choice="No", title="Dealer Initialization")
                            feedback("No entries found for dealer \"{0}\".".format(d), err=True)
                    else:
                        print("Class: <{0}> not found in DS.by_class when mass applying".format(c))
                        feedback("No entries found for class \"{0}\".".format(c), err=True)
                        # if model.clazz.lower() == c.lower():

                elif d:
                    # apply a given discount structure to all models of all class within given dealer.
                    # "1% slot on all models"
                    print("Act on dealer <{0}>".format(d))
                    for clazz in DS.by_class:
                        for model in DS.by_class[clazz]:
                            if ins(model):
                                new_discount.append(submit_entries(p_d=d, p_m=model, p_t=datetime.datetime.today()))
                else:
                    feedback("No action.", err=True)
            else:
                feedback("No action.", err=True)

            # [d] => apply to all models within dealer
            # [d, c] => apply to all models within class within dealer

        def feedback(txt, err=False):
            if txt == None:
                raise ValueError("txt is None")
            feedback_window.configure(state='normal')
            if not feedback_contents or all([er for er, cont in feedback_contents]):
                feedback_contents.clear()
                print("Feedbackvar:", feedback_var.get())
                if feedback_var.get():
                    feedback_window.delete('1.0', tk.END)
                    feedback_var.set("")
            feedback_contents.append((err, txt))

            feedback_var.set(feedback_var.get() + txt + "\n")
            feedback_window.insert(tk.END, txt + "\n")
            feedback_window.configure(state='disabled')

        def clear_fields(*args):
            selection_dealer.set("")
            selection_model.set("")
            selection_class.set("")
            selection_slot.set(0)
            selection_market.set(0)
            selection_freight.set(0)

        frame_btn = tk.Frame(window_create, bg=CREATE_BG)
        frame_btn.pack(side=tk.BOTTOM)

        sub_frame_btn = tk.Frame(frame_btn, bg=CREATE_BG)
        sub_frame_btn.pack(side=tk.BOTTOM)

        btn_save_quit = tk.Button(
            sub_frame_btn,
            text="Save & Quit",
            fg="green",
            bg=CREATE_BTN_BG,
            font=font_2,
            command=save_quit
        )
        btn_quit = tk.Button(
            sub_frame_btn,
            text="Quit Without Saving",
            fg="red",
            bg=CREATE_BTN_BG,
            font=font_2,
            command=q
        )
        btn_mass_apply = tk.Button(
            sub_frame_btn,
            text="Mass Apply",
            fg="deepskyblue4",
            bg=CREATE_BTN_BG,
            font=font_2,
            command=mass_apply
        )
        btn_clear_fields = tk.Button(
            sub_frame_btn,
            text="Clear Fields",
            fg=fg,
            bg=bg,
            font=font_2,
            command=clear_fields
        )
        feedback_window = ScrolledText(frame_btn, width=100, height=10, bg="grey80", fg="red4", font=font_2)
        # feedback_window = tk.Text(frame_btn, width=100, height=10, bg="grey80", fg="red4", font=font_2)
        # text_area.bind('<KeyRelease>', lambda *args: update_feedback())
        # new_status_update("")
        feedback_window.pack(side=tk.BOTTOM)
        feedback("", err=True)
        btn_mass_apply.pack(side=tk.LEFT)
        btn_quit.pack(side=tk.LEFT)
        btn_save_quit.pack(side=tk.LEFT)
        btn_clear_fields.pack(side=tk.LEFT)

        if edit:
            e_model = edit.model
            e_dealer = edit.dealer
            e_date = edit.date
            e_freight = edit.freight
            e_slot = edit.slot * 100
            e_market = edit.market * 100

            selection_dealer.set(e_dealer)
            selection_date.set(e_date)
            selection_model.set(e_model.model_name)
            selection_class.set(e_model.clazz)
            slot_var.set(e_slot)
            market_var.set(e_market)
            freight_var.set(e_freight)

            feedback("Editing: <{0}>".format(edit))

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

        # up = lambda *args: feedback_window.insert(tk.END, ".1")
        # for i in range(10):
        #     up()
        # root.after(500, up)
        # root.after(500, up)
        # root.after(500, up)
        # root.after(500, up)
        # root.after(500, up)
        # root.after(500, up)
        # feedback_window.update()
        # time.sleep(10)

        # ts = time.time()
        # tn = time.time()
        # tp = tn - ts
        # while tp < 2:
        #     tn = time.time()
        #     tp = tn - ts
        #     feedback_window.insert(tk.END, ".1")
        #     print(".")

        print("global new_discount:", new_discount)
        return new_discount

    new_discount = main_loop()
    # DS.update(new_discount.new_model_entry())
    print("global new_discount:", new_discount)
    time.sleep(1.75)
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
    include_all_discounts = tk.IntVar()
    info_msg_var = tk.StringVar()

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
            if not include_all_discounts.get():
                if discount.slot == 0 and discount.market == 0 and discount.freight == 0:
                    continue
            # print(discount.table_entry(dims))
            listbox.insert(i + 1, discount.table_entry(dims))

    def init_listbox():
        listbox_frame = tk.Frame(window_view)
        listbox_frame.pack(side=tk.TOP)

        scrollbar = tk.Scrollbar(listbox_frame, orient="vertical")
        listbox = tk.Listbox(listbox_frame, selectmode=tk.EXTENDED, yscrollcommand=scrollbar.set, width=200)
        listbox['font'] = font_1

        scrollbar.config(command=listbox.yview)
        scrollbar.pack(side="right", fill="y")

        add_data(listbox)

        return listbox

    def new_status_update(txt):
        status_window.configure(state='normal')
        if txt is None:
            raise ValueError("txt is None")
        status_window.insert(tk.END, txt + "\n")
        status_window.configure(state='disabled')

    def create_function():
        global listbox, new_discount
        disable(window_view)
        print('Create a new discount')
        new_discount = create_view()
        did_update = False
        if new_discount:
            did_update = True
            if type(new_discount) != list:
                new_discount = [new_discount]
            for discount in new_discount:
                update_discounts(discount)
                new_status_update(status_update)
        print("new discount {0}:".format(did_update), new_discount)
        # DS.adjust_models(new_discount)
        # read_entries()
        enable(window_view)
        clear_data(listbox)
        add_data(listbox)
        info_msg_var.set(discount_display_info())
        # by_models = create_by_model()
        # print("LAST ENTRIES:", list(by_models.keys())[-5:])

    def edit_function():
        global listbox
        selection = list(listbox.curselection())
        if 0 in selection:
            selection.remove(0)
        selection = list(map(lambda x: x - 1, selection))
        print('Edit a discount :', selection)
        disable(window_view)
        new_discounts = []
        for sel in selection:
            new_discount = create_view(edit=discount_entries[sel])
            did_update = False
            if new_discount:
                did_update = True
                update_discounts(new_discount)
                new_status_update(status_update)

        enable(window_view)
        clear_data(listbox)
        add_data(listbox)

        #     new_discounts.append(create_view(edit=(discount_entries[sel])))
        # print("edited discounts:", new_discounts)
        # clear_data(listbox)
        # add_data(listbox)
        # enable(window_view)

    def delete_function():
        global listbox
        # selection = listbox.curselection()
        selection = list(listbox.curselection())
        if 0 in selection:
            selection.remove(0)
        selection = [x - 1 for x in selection]
        print("before deletion: ", listbox.get(0, listbox.size()))
        print("before clear: ", listbox.get(0, listbox.size()))
        clear_data(listbox)
        for sel in selection:
            print("discount_entries ({0})".format(len(discount_entries)), discount_entries)
            discount = discount_entries[sel]
            print("ATTEMPTING TO REMOVE DISCOUNT:", discount)
            discount_entries.remove(discount)
            original_entries.remove(discount)
            remove_discount(discount)

        print('Delete a discount :', selection)
        print("after clear: ", listbox.get(0, listbox.size()))
        add_data(listbox)
        print("after addition: ", listbox.get(0, listbox.size()))
        info_msg_var.set(discount_display_info())

    # def submit_function():
    #     global listbox
    #     selection = listbox.curselection()
    #     print('Listbox selection :', selection)

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
            rev = rev if discount_entries[0].model.model_name.lower() < discount_entries[
                -1].model.model_name.lower() else not rev
        discount_entries.sort(key=lambda d: d.model.model_name.lower(), reverse=rev)
        clear_data(listbox)
        add_data(listbox)
        sort_status = sort_by_model

    def sort_by_class():
        global sort_status, listbox
        rev = sort_status == sort_by_class
        if rev:
            rev = rev if discount_entries[0].model.clazz < discount_entries[-1].model.clazz else not rev
        discount_entries.sort(key=lambda d: d.model.clazz, reverse=rev)
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
                    # print("\tchecking entry:", entry, ", at attr:", attr)
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
                # print("NEW entry{ " + str(matches) + " }", entry)

        clear_data(listbox)
        discount_entries = filtered.copy()
        add_data(listbox)
        reset_check_buttons()
        # print(dict_print(check_data, "res", number=True))
        info_msg_var.set(discount_display_info())

    def toggle_include_all_discounts(*args):
        global listbox
        clear_data(listbox)
        add_data(listbox)

    def re_pop_entries():
        global listbox, search_entry
        clear_data(listbox)
        repopulate_entries()
        add_data(listbox)
        if search_entry.get():
            search_entry.delete(0, len(search_entry.get()))

    def reset_check_buttons():
        global check_btn_date, check_btn_dealer, check_btn_model, check_btn_class, check_btn_slot, check_btn_market, check_btn_freight, search_entry
        checkbuttons = [check_btn_date, check_btn_dealer, check_btn_model, check_btn_class, check_btn_slot,
                        check_btn_market, check_btn_freight]
        for btn in checkbuttons:
            btn.deselect()
        # search_entry.delete(0, len(search_entry.get()))

    def main_loop():
        global listbox, check_btn_date, check_btn_dealer, check_btn_model, check_btn_class, check_btn_slot, check_btn_market, check_btn_freight, search_entry, status_window
        # listbox = init_listbox()
        # print("sort_status:", sort_status)
        # print("dir:", dir())

        btns_frame = tk.Frame(window_view)
        btns_frame.pack(side=tk.TOP)

        mod_btn_frame = tk.Frame(btns_frame)
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

        btn_sort_freight = tk.Button(sort_btn_frame, text='Sort by Freight $', command=sort_by_freight)
        btn_sort_freight.pack(side=tk.LEFT)

        info_msg_var.set(discount_display_info())
        info_label = tk.Label(mod_btn_frame, text="", fg=INFO_MSG_FG, bg=CREATE_LBL_BG, textvariable=info_msg_var,
                              font=font_2, padx=20, pady=10)
        info_label.pack(side=tk.LEFT)

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
            indicatoron=0,
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
            indicatoron=0,
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
            indicatoron=0,
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
            indicatoron=0,
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
            indicatoron=0,
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
            indicatoron=0,
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
            indicatoron=0,
            activebackground=abg,
            activeforeground=afg,
            selectcolor=sc
        )
        check_btn_freight.pack(side=tk.LEFT)

        btn_submit_search = tk.Button(search_btn_frame, text='Search', command=submit_search)
        btn_submit_search.pack(side=tk.LEFT)

        btn_repop_search = tk.Button(search_btn_frame, text='Show all entries', command=re_pop_entries)
        btn_repop_search.pack(side=tk.LEFT)

        check_btn_include_all_discounts = tk.Checkbutton(
            search_btn_frame,
            text="Include discounts with only \'0\' entries",
            bg=bg,
            fg=fg,
            font=font_1,
            variable=include_all_discounts,
            onvalue=1,
            offvalue=0,
            indicatoron=1,
            activebackground=abg,
            activeforeground=afg,
            selectcolor=sc
        )
        include_all_discounts.trace_add("write", toggle_include_all_discounts)
        check_btn_include_all_discounts.pack(side=tk.LEFT)

        # listbox.pack()

        ctrl_btn_frame = tk.Frame(window_view)
        ctrl_btn_frame.pack(side=tk.BOTTOM)

        def cursor_enter(*args):
            chx = ["arrow", "circle", "clock", "cross", "dotbox", "exchange", "fleur", "heart", "heart", "man", "mouse",
                   "pirate", "plus", "shuttle", "sizing", "spider", "spraycan", "star", "target", "tcross", "trek",
                   "watch"]
            status_window.configure(cursor=random.choice(chx))

        def cursor_leave(*args):
            status_window.configure(cursor="circle")

        print("Fullsize: " + str(full_size))
        status_window = ScrolledText(ctrl_btn_frame, state='disabled', width=200, height=5, bg="lightblue4", fg="red4",
                                     font=font_2)
        status_window.bind("<Enter>", cursor_enter)
        status_window.bind("<Leave>", cursor_leave)
        # status_window = tk.Text(ctrl_btn_frame, state='disabled', width=200, height=5, bg="lightblue4", fg="red4", font=font_2)
        # new_status_update("")
        status_window.pack(side=tk.TOP)

        # status_window_2 = tk.Message(ctrl_btn_frame, msg="tk.Message")
        # status_window_2.pack()

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

        listbox = init_listbox()
        listbox.pack()
        root.mainloop()

    main_loop()


class FullScreenApp(object):
    def __init__(self, master, **kwargs):
        global full_size
        self.master = master
        pad = 3
        self._geom = '200x200+0+0'
        full_size = "{0}x{1}+0+0".format(master.winfo_screenwidth() - pad, master.winfo_screenheight() - pad)
        master.geometry(full_size)
        master.bind('<Escape>', self.toggle_geom)

    def toggle_geom(self, event):
        geom = self.master.winfo_geometry()
        print(geom, self._geom)
        self.master.geometry(self._geom)
        self._geom = geom


if __name__ == "__main__":
    try:
        # global root
        # root.mainloop()
        DS = DataSet()
        DS.init()
        read_entries()
        print(dims)
        root = tk.Tk(className='\Discount Registry')
        font_1 = tk.font.Font(family='consolas')
        font_2 = tk.font.Font(family='consolas', weight='bold')
        font_3 = tk.font.Font(family='consolas', weight='bold', size=16)
        app = FullScreenApp(root)
        # root.geometry(size)
        window_main = tk.Frame(root)
        window_main.pack()
        main_view()
    except:
        easygui.exceptionbox()
