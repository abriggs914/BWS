from tkinter import Frame, StringVar, Button, Label, Text, Entry, N, END, Tk
from utility import money

def updated_costing(cost, margin=30, FE=1.245, increase=0):
	cost *= (1 + (increase / 100))
	margin = (100 - margin) / 100
	return (cost, {
		"COST": money(cost),
		"CDN": money((cost / margin) if cost >= 0 else (cost * margin)),
		"US": money(((cost / margin) if cost >= 0 else (cost * margin)) / FE)
	})

class App(Frame):

    def __init__(self, master=None):
        super().__init__(master)
        self.pack(pady=35, padx=35)

        self.cost = StringVar()
        self.margin = StringVar()
        self.increase = StringVar()
        self.exchange = StringVar()
        self.calculated_cost = StringVar()

        self.current_cost_btn = Button(self, text="use calculated cost", command=self.use_calculated_cost)
        self.label_cost = Label(self, text="Cost")
        self.entry_cost = Entry(self, textvariable=self.cost)
        self.label_margin = Label(self, text="% Margin")
        self.entry_margin = Entry(self, textvariable=self.margin)
        self.label_increase = Label(self, text="% Increase")
        self.entry_increase = Entry(self, textvariable=self.increase)
        self.label_exchange = Label(self, text="Exchange")
        self.entry_exchange = Entry(self, textvariable=self.exchange)

        self.text_display = Text(self, height = 5, width = 20)

        self.btn_sub = Button(self, text="submit", command=self.submit)
        self.btn_clear = Button(self, text="clear", command=self.clear_fields)

        self.label_cost.grid(column=0, row=0, sticky=N)
        self.entry_cost.grid(column=1, row=0, sticky=N)
        self.label_margin.grid(column=0, row=1, sticky=N)
        self.entry_margin.grid(column=1, row=1, sticky=N)
        self.label_increase.grid(column=0, row=2, sticky=N)
        self.entry_increase.grid(column=1, row=2, sticky=N)
        self.label_exchange.grid(column=0, row=3, sticky=N)
        self.entry_exchange.grid(column=1, row=3, sticky=N)
        
        self.text_display.grid(column=0, row = 4, columnspan=2, sticky=N)

        self.current_cost_btn.grid(column=0, row=5, columnspan=2, stick=N, pady=5)
        self.btn_sub.grid(column=0, row=6, columnspan=2, sticky=N, pady=5)
        self.btn_clear.grid(column=0, row=7, columnspan=2, sticky=N, pady=5)

    def use_calculated_cost(self):
        if self.calculated_cost.get():
            self.cost.set("%.2f" % float(self.calculated_cost.get()))
        else:
            self.text_display.delete('1.0', END)
            self.text_display.insert('1.0', "Invalid")

    def run(self):
        self.mainloop()

    def clear_fields(self):
        self.cost.set("")
        self.margin.set("")
        self.increase.set("")
        self.exchange.set("")
        self.text_display.delete('1.0', END)

    def submit(self):
        self.text_display.delete('1.0', END)
        c = self.cost.get()
        m = self.margin.get()
        i = self.increase.get()
        e = self.exchange.get()

        try:
            if all([c, m, i, e]):
                c = float(c)
                m = float(m)
                i = float(i)
                e = float(e)
                
                val, vals = updated_costing(c, m, e, i)
                result = "\n".join([k.ljust(6) + v for k, v in vals.items()])
                self.calculated_cost.set(val)
                self.text_display.insert('1.0', result)

                # print("cost    ", money(c))
                # print("margin  ", money(m))
                # print("increase", money(i))
                # print("exchange", money(e))
                # print("results:\n" + result)
            else:
                raise ValueError
        except ValueError:
                self.text_display.insert('1.0', "Invalid")

if __name__ == "__main__":
    root = Tk(className="\Price Calculator")
    app = App(root)
    app.run()