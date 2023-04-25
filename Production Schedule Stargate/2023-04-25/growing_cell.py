import tkinter as tk


if __name__ == '__main__':

    root = tk.Tk()
    root.geometry(f"500x500")

    # create a 3x3 grid
    for i in range(3):
        for j in range(3):
            # create a label in each cell
            label = tk.Label(root, text=f"{i},{j}", borderwidth=1, relief="solid")
            label.grid(row=i, column=j, sticky="nsew") # set sticky option to "nsew"

    # create a button that will expand the center cell
    button = tk.Button(root, text="Expand", command=lambda: expand_cell(1, 1))
    button.grid(row=3, column=0, columnspan=3)

    def expand_cell(row, col):
        # remove the label from the center cell
        label = root.grid_slaves(row=row, column=col)[0]
        label.grid_forget()

        # create a new label that will expand to cover the neighboring cells
        new_label = tk.Label(root, text="Expanded", borderwidth=1, relief="solid")
        new_label.grid(row=row, column=col, rowspan=2, columnspan=2, sticky="nsew")

    root.mainloop()
