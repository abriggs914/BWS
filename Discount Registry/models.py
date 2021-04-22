import csv
import easygui
from models_writer import *
from utility import dict_print

by_class = gen_by_class()
by_class["UNKOWN"] = []

# for testing purposes
with open("unknown entries.csv", 'r') as f:
    csvdict = csv.DictReader(f)
    for d in csvdict:
        # print(d)
        vals = (d["model"], d["description"], d["status"] == "current")
        by_class["UNKOWN"].append(vals)

def create_by_model():
    res = {}
    last = None
    for clazz, vals in by_class.items():
        print("vals\t", vals)
        for model_name, model_desc, status in vals:
            last = model_name
            res[model_name] = [clazz, model_desc, status] #  v[0][0]: [k] + list(v[1:])

    if last:
        print("CREATING BY MODEL", res[last])
    return res

by_models = create_by_model()

print(dict_print(by_models, "By Model"))
print(dict_print(by_class, "By Class"))

def split_by_status():
    c, nc = [], []
    for clazz, lst in by_class.items():
        for model in lst:
            print("model\t", model)
            model_abbr, model_name, status = model
            if status == current:
                c.append(model)
            elif status == non_current:
                nc.append(model)
            else:
                raise ValueError("UNKNOWN status classification \"" + str(status) + "\"")
    return c, nc

current_models, non_current_models = split_by_status()

print("{n} total classes".format(n=len(by_class)))
print("{n} total models".format(n=len(current_models) + len(non_current_models)))
print("{n} current models".format(n=len(current_models)))
print("{n} non-current models".format(n=len(non_current_models)))

print("current models[0]:", current_models[0])

list_of_models = current_models + non_current_models

def adjust_models(new_discount):
    global by_class, by_models, current_models, non_current_models, list_of_models
    c = new_discount.clazz
    m = new_discount.model
    d = easygui.enterbox(msg="Describe this model \"" + m + "\"", title="Description")  #.ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current")
    s = easygui.ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current", title="Status")
    s = 1 if s else 0
    add_model(c, m, d, s)
    
    by_class = gen_by_class()
    by_class["UNKOWN"] = []
    current_models, non_current_models = split_by_status()
    list_of_models = current_models + non_current_models
    by_models = create_by_model()
