import tkinter

import pandas as pd

from pyodbc_connection import connect
from sql_utility import parse_connection_data
from tkinter_utility import *


class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.sel_col_names = {
            "TABLE_CATALOG": "CA_0",
            "TABLE_NAME": "CA_1",
            "COLUMN_NAME": "CA_2",
            "PRIMARY_KEY": "CA_3",
            "DATA_TYPE": "CA_4",
            "CHARACTER_MAXIMUM_LENGTH": "CA_5"
        }
        self.sql_star_template = """
        SELECT
	        [{CA_0}]
            ,[{CA_1}]
            ,[{CA_2}]
            ,(CASE WHEN [IS_NULLABLE] = 'YES' THEN 1 ELSE 0 END) AS [{CA_3}]
            ,[{CA_4}]
            ,[{CA_5}]
        FROM
            INFORMATION_SCHEMA.COLUMNS
        WHERE
            LOWER([COLUMN_NAME]) LIKE '%{ST}%'
        ORDER BY
            [TABLE_NAME],
            [COLUMN_NAME]
        ;
        """

        self.list_databases = [
            "BWSdb",
            "StargateDB",
            "SysproCompanyA",
            "SysproCompanyS",
            "SysproCompanyL",
            "uniPoint_Live"
        ]
        # self.tv_rb_db, self.list_tv_rb_db, self.list_rb_db_bts = checkbox_factory(
        self.frame_db_btns = tkinter.Frame(self)
        self.list_tv_rb_db, self.list_rb_db_bts = checkbox_factory(
            self.frame_db_btns,
            buttons=self.list_databases,
            default_values=[True for _ in self.list_databases]
        )

        self.tv_lbl_search_input, self.lbl_search_input, self.tv_search_input, self.search_input = entry_factory(
            self,
            tv_label="Search Term:"
        )

        self.tv_btn_search, self.btn_search = button_factory(
            self,
            tv_btn="search",
            command=self.click_search
        )

        self.mc = MultiComboBox(
            self,
            pd.DataFrame(columns=self.sel_col_names),
            include_aggregate_row=False,
            include_searching_widgets=False
        )

        self.frame_db_btns.grid(row=0, column=0, rowspan=4)
        for i, btn in enumerate(self.list_rb_db_bts):
            btn.grid(row=i, column=0)

        self.lbl_search_input.grid(row=0, column=1)
        self.search_input.grid(row=1, column=1)
        self.btn_search.grid(row=2, column=1)
        self.mc.grid(row=3, column=1)

    def get_selected_dbs(self):
        selected = []
        for i, btn in enumerate(self.list_tv_rb_db):
            if btn.get():
                selected.append(i)
        return selected

    def click_search(self):
        self.mc.delete_item()
        selected = self.get_selected_dbs()
        inp = self.tv_search_input.get().lower()
        print(f"{inp=}, {selected=}")
        dfs = []
        if inp and selected:
            ca = {v: k for k, v in self.sel_col_names.items()}
            for db_idx in selected:
                db = self.list_databases[db_idx]
                cd = parse_connection_data(db)
                ca.update({"ST": inp})
                sql = self.sql_star_template.format(**ca)
                print(f"{inp=}\n{db=}\n{cd=}\n{ca=}\n{sql=}")
                df = connect(sql, **cd)
                dfs.append(df)
                print(f"{df=}")
            self.mc.add_new_item(pd.concat(dfs, ignore_index=True))


if __name__ == '__main__':
    app = App()
    app.mainloop()
