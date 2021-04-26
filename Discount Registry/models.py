import csv
import easygui
from models_writer import current, non_current
from utility import dict_print

# by_class = gen_by_class()

# def create_by_model():
#     res = {}
#     last = None
#     for clazz, vals in by_class.items():
#         # print("vals\t", vals)
#         for model_name, model_desc, status in vals:
#             last = model_name
#             res[model_name] = [clazz, model_desc, status] #  v[0][0]: [k] + list(v[1:])
#             # if model_name not in res:
#             # else:
#             #     old = res[model_name]
#             #     old_class = old[0]
                
#             #     edit_registry(model_name)
#             #     del res[model_name]


#     if last:
#         print("CREATING BY MODEL", res[last])
#     return res

# by_models = create_by_model()

# # print(dict_print(by_models, "By Model"))
# # print(dict_print(by_class, "By Class"))

# def split_by_status():
#     c, nc = [], []
#     for clazz, lst in by_class.items():
#         for model in lst:
#             # print("model\t", model)
#             model_abbr, model_name, status = model
#             if status == current:
#                 c.append(model)
#             elif status == non_current:
#                 nc.append(model)
#             else:
#                 raise ValueError("UNKNOWN status classification \"" + str(status) + "\"")
#     return c, nc

# current_models, non_current_models = split_by_status()

# print("{n} total classes".format(n=len(by_class)))
# print("{n} total models".format(n=len(current_models) + len(non_current_models)))
# print("{n} current models".format(n=len(current_models)))
# print("{n} non-current models".format(n=len(non_current_models)))

# print("current models[0]:", current_models[0])

# list_of_models = current_models + non_current_models

# def adjust_models(new_discount):
#     global by_class, by_models, current_models, non_current_models, list_of_models
#     c = new_discount.clazz
#     m = new_discount.model
#     d = easygui.enterbox(msg="Describe this model \"" + m + "\"", title="Description")  #.ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current")
#     s = easygui.ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current", title="Status")
#     s = 1 if s else 0
#     add_model(c, m, d, s)
    
#     by_class = gen_by_class()
#     current_models, non_current_models = split_by_status()
#     list_of_models = current_models + non_current_models
#     by_models = create_by_model()


# def get_by_models():
#     return by_models


class DataSetNotInitialized(Exception):
    def __init__(self, msg):
        super().__init__(msg)




class DataSet:

    def __init__(self):
        pass

    def init(self):
        self.read_entries()
        self.create_by_model()

    # Add a model and update the by_model, by_class, and models attributes
    def update(self, m):
        self.write_new_model(m)
        self.init()

    def read_entries(self):
        self.by_class = {}
        self.models = []
        with open("models.csv", 'r') as f:
            r = csv.DictReader(f)
            for row in r:
                lst = list(row.values())
                print("lst:\t", lst)
                # vals = lst[] + [current if lst[-1] == "True" or lst[-1] == "1" else non_current]
                # print("VALS:\t", dict(zip(["clazz", "model_name", "description", "status"], vals)))
                m = Model(*lst)
                self.models.append(m)
                if row["class"] in self.by_class:
                    self.by_class[row["class"]].append(m)
                else:
                    self.by_class[row["class"]] = [m]

        self.by_class["UNKOWN"] = []

        # for testing purposes
        with open("unknown entries.csv", 'r') as f:
            csvdict = csv.DictReader(f)
            for d in csvdict:
                # print(d)
                vals = (d["model"], d["description"], d["status"] == "current")
                m = Model("UNKNOWN", *vals)
                self.models.append(m)
                self.by_class["UNKOWN"].append(vals)

        # print(dict_print(self.by_class, "self.by_class after creation"))

    def create_by_model(self):
        if not hasattr(self, "models"):
            raise DataSetNotInitialized("Attribute \"models\" has not been initialized yet. Unable to create \"by_model\".")
        
        self.by_model = {self.model_key(m): (m.clazz, m.description, m.status) for m in self.models}
        # print(dict_print(self.by_model, "self.by_model after creation"))

        # self.by_model = {}
        # for m in self.models:
        #     m_name
        #     if m_name in self.by_model:
        #         old_m = self.by_model[m_name]
        #         del self.by_model[m_name]
        #         self.by_model[m_name + "<" ]
        #     self.by_model[] [m.clazz, m.description, m.Status] for m in self.models}

        # self.by_model = {}
        # last = None
        # for clazz, vals in self.by_class.items():
        #     # print("vals\t", vals)
        #     for model_name, model_desc, status in vals:
        #         last = model_name
        #         self.by_model[model_name] = [clazz, model_desc, status] #  v[0][0]: [k] + list(v[1:])
        #         # if model_name not in res:
        #         # else:
        #         #     old = res[model_name]
        #         #     old_class = old[0]
                    
        #         #     edit_registry(model_name)
        #         #     del res[model_name]


        # if last:
        #     print("CREATING BY MODEL", self.by_model[last])

    def model_key(self, m):
        return m.model_name + " <" + m.clazz.upper() + ">"

    def look_up_by_name(self, name, clazz):
        if not hasattr(self, "models"):
            raise DataSetNotInitialized("Attribute \"models\" has not been initialized yet. Unable to create \"by_model\".")

        n = name.lower()
        c = clazz.lower()
        # print("searching for: <" + n + "> <" + c + ">")
        for m in self.models:
            # print("\t\tm.model_name.lower():", m.model_name.lower(), "m.clazz.lower():", m.clazz.lower())
            # if m.model_name.lower() == n:
            #     print("\t\t\tMODEL EQUALS")
            # if m.clazz.lower() == c:
            #     print("\t\t\tCLASS EQUALS")
            if m.model_name.lower() == n and m.clazz.lower() == c:
                return m

    def write_new_model(self, m):
        with open("models.csv", 'a') as f:
            f.write("\n" + ",".join(list(map(str, [m.clazz, m.model_name, m.description, m.status]))))


class Model:
    def __init__(self, clazz, model_name, description, status):
        self.clazz = clazz.upper()
        self.model_name = model_name
        self.description = description
        self.status = status

    def __repr__(self):
        return self.model_name + " <" + self.clazz + ">"