from utility import *

class Discount:

    def __init__(self, dealer, model, slot, market, freight):
        self.dealer = dealer
        self.model = model
        self.slot = float(slot)
        self.market = float(market)
        self.freight = float(freight)

    def table_entry(self, dims):
        return " | ".join([
            self.dealer.title().ljust(dims[0]),
            self.model.upper().rjust(dims[1]),
            percent(self.slot).rjust(dims[2]),
            percent(self.market).rjust(dims[3]),
            money(self.freight).rjust(dims[4]),
        ])

    def __repr__(self):
        print("slot: " + str(self.slot) + ", t(): " + str(type(self.slot)))
        print("market: " + str(self.market) + ", t(): " + str(type(self.market)))
        print("freight: " + str(self.freight) + ", t(): " + str(type(self.freight)))
        return self.dealer + " (" + self.model + ") (" + percent(self.slot) + ", " + percent(self.market) + ", " + money(self.freight) + ")" 