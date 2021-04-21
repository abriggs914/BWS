import datetime
from utility import *


TABLE_HEADER = ["Date", "Dealer", "Model", "Class", "Slot", "Market", "Freight"]

def table_format(d, m, s, k, f, c, t, dims):
    return "| " + " | ".join([
            str(t.isoformat()).ljust(dims[0]),
            d.title().ljust(dims[1]),
            m.upper().rjust(dims[2]),
            c.upper().rjust(dims[3]),
            percent(s, 3).rjust(dims[4]),
            percent(k, 3).rjust(dims[5]),
            money(f).rjust(dims[6])
        ]) + " |"

class Discount:

    def __init__(self, dealer, model, slot, market, freight, clazz, date):
        self.dealer = dealer
        self.model = model
        self.slot = float(slot)
        self.market = float(market)
        self.freight = float(freight)
        self.clazz = clazz
        self.date = datetime.date.fromisoformat(date)

    def table_entry(self, dims):
        return table_format(self.dealer, self.model, self.slot, self.market, self.freight, self.clazz, self.date, dims)

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

    def __eq__(self, d):
        return all([
            self.dealer.lower() == d.dealer.lower(),
            self.model.lower() == d.model.lower(),
            self.clazz.lower() == d.clazz.lower(),
            self.date == d.date,
            self.slot == d.slot,
            self.market == d.market,
            self.freight == d.freight
        ])

    def __repr__(self):
        # print("slot: " + str(self.slot) + ", t(): " + str(type(self.slot)))
        # print("market: " + str(self.market) + ", t(): " + str(type(self.market)))
        # print("freight: " + str(self.freight) + ", t(): " + str(type(self.freight)))
        return self.dealer + " (" + self.model + ") (" + percent(self.slot, 3) + ", " + percent(self.market, 3) + ", " + money(self.freight) + ")" 