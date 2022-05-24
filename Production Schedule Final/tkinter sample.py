from tkinter import *

tk = Tk()
tk.geometry("500x500")
b1 = Button(tk, text="hey 1", command=lambda x=None: print("b1"))
b2 = Button(tk, text="hey 2", command=lambda x=None: print("b2"))
b3 = Button(tk, text="hey 3", command=lambda x=None: print("b3"))
b4 = Button(tk, text="hey 4", command=lambda x=None: print("b4"))
b5 = Button(tk, text="hey 5", command=lambda x=None: print("b5"))
b6 = Button(tk, text="hey 6", command=lambda x=None: print("b6"))
b7 = Button(tk, text="hey 7", command=lambda x=None: print("b7"))

if __name__ == '__main__':
    tk.grid()
    b1.grid(row=1, column=1)
    b2.grid(row=1, column=2)
    b3.grid(row=2, column=1)
    b4.grid(row=2, column=2)
    b5.grid(row=3, column=1)
    b6.grid(row=3, column=2)
    b7.grid(row=1, column=3, rowspan=3)
    tk.mainloop()
