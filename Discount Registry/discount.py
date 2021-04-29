import datetime
import easygui
from models import Model
from models_writer import current, non_current
from utility import *


TABLE_HEADER = ["Date", "Dealer", "Model", "Class", "Slot", "Market", "Freight"]

def table_format(d, m, s, k, f, c, t, dims):
    return "| " + " | ".join([
            str(t.isoformat()).ljust(dims[0]),
            d.title().ljust(dims[1]),
            m.model_name.upper().rjust(dims[2]),
            c.upper().rjust(dims[3]),
            percent(s, 3).rjust(dims[4]),
            percent(k, 3).rjust(dims[5]),
            money(f).rjust(dims[6])
        ]) + " |"

class Discount:

    def __init__(self, dealer, model, slot, market, freight, date):
        self.dealer = dealer
        self.model = model
        self.slot = float(slot)
        self.market = float(market)
        self.freight = float(freight)
        self.date = datetime.date.fromisoformat(date)

    def table_entry(self, dims):
        return table_format(self.dealer, self.model, self.slot, self.market, self.freight, self.model.clazz, self.date, dims)

    def registry_entry(self):
        # dealer,model,slot,market,freight,date
        return ",".join(list(map(str, [
            self.dealer,
            self.model,
            self.slot * 100,
            self.market * 100,
            self.freight,
            self.date
        ])))

    # def new_model_entry(self):
    #     m = self.model
    #     c = self.clazz
    #     d = easygui.enterbox(msg="Describe this model \"" + m + "\"", title="Description")  #.ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current")
    #     s = easygui.ynbox(msg="Is this model current?", choices=["Current", "Non-current"], default_choice="Current", cancel_choice="Current", title="Status")
    #     s = current if s else non_current
    #     return Model(c, m, d, s)

    def __eq__(self, d):
        return all([
            self.dealer.lower() == d.dealer.lower(),
            self.model.model_name.lower() == d.model.model_name.lower(),
            self.model.clazz.lower() == d.model.clazz.lower()
        ])

    def __repr__(self):
        # print("slot: " + str(self.slot) + ", t(): " + str(type(self.slot)))
        # print("market: " + str(self.market) + ", t(): " + str(type(self.market)))
        # print("freight: " + str(self.freight) + ", t(): " + str(type(self.freight)))
        return self.dealer + " (" + str(self.model) + ") (" + percent(self.slot, 3) + ", " + percent(self.market, 3) + ", " + money(self.freight) + ")" 