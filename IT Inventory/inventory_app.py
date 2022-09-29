import tkinter

from grid_manager import GridManager
from tkinter_utility import *
from stg_queries import *


class InventoryApp(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.WIDTH, self.HEIGHT = 500, 500
        self.geometry(f"{self.WIDTH}x{self.HEIGHT}")
        self.title("BWS Inventory Manager")
        self.state("zoomed")

        self.tv_l1, self.l1 = label_factory(self, tv_label="Label 1")

        self.gm1 = GridManager()
        self.gm1.grid_widgets([
            [
                self.l1
            ]
        ])

        self.df_inventory_master = None
        self.populate_data()

    def populate_data(self):
        self.df_inventory_master = connect(**SQL_V_TOOLSANDEQUIP)

