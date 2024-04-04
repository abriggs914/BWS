from pyodbc_connection import connect
from sql_utility import parse_connection_data
from tkinter_utility import *
import warnings



# 2024-04-04 1624


class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.title_msgbox = "Server3 Table Column Finder"
        self.title(self.title_msgbox)
        self.geometry(calc_geometry_tl(0.45, 0.4))
        warnings.simplefilter("ignore")

        self.sel_col_names = {
            "TABLE_CATALOG": "CA_0",
            "TABLE_NAME": "CA_1",
            "COLUMN_NAME": "CA_2",
            "PRIMARY_KEY": "CA_3",
            "DATA_TYPE": "CA_4",
            "CHARACTER_MAXIMUM_LENGTH": "CA_5"
        }
        self.sql_table_template = """
        SELECT
	        [{CA_0}]
            ,[{CA_1}]
            ,[{CA_2}]
            ,(CASE WHEN [IS_NULLABLE] = 'NO' THEN 1 ELSE 0 END) AS [{CA_3}]
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
        self.sql_values_template = """SELECT * FROM [{TABLE}];"""

        self.list_databases = [
            "BWSdb",
            "StargateDB",
            "SysproCompanyA",
            "SysproCompanyS",
            "SysproCompanyL"
            ,
            "uniPoint_Live"
        ]

        self.rv_options = ["Column Names", "Values", "Anything"]

        self.tv_lbl_title, self.lbl_title = label_factory(
            self,
            "Enter a column name to search each table in the selected databases"
        )

        self.frame_dv_btns = tkinter.Frame(self)
        self.frame_db_btns = tkinter.Frame(self)
        self.tv_rb_dv, self.list_tv_rb_dv_bts, self.list_rb_dv_bts = radio_factory(
            self.frame_dv_btns,
            buttons=self.rv_options,
            default_value=0
        )
        self.list_tv_rb_db, self.list_rb_db_bts = checkbox_factory(
            self.frame_db_btns,
            buttons=self.list_databases,
            default_values=[True for _ in self.list_databases]
        )

        self.tv_lbl_search_input, self.lbl_search_input, self.tv_search_input, self.search_input = entry_factory(
            self,
            tv_label="Search Term:",
            kwargs_entry={
                "width": 100,
                "justify": tkinter.CENTER
            }
        )

        self.tv_btn_search, self.btn_search = button_factory(
            self,
            tv_btn="search",
            command=self.click_search
        )

        self.tv_btn_clear_search, self.btn_clear_search = button_factory(
            self,
            tv_btn="clear",
            command=self.click_clear_search
        )

        self.mc = MultiComboBox(
            self,
            pd.DataFrame(columns=self.sel_col_names),
            include_aggregate_row=False,
            include_searching_widgets=False
        )

        self.lbl_title.grid(row=0, column=0, columnspan=4)
        self.frame_dv_btns.grid(row=1, column=0, rowspan=2)
        self.frame_db_btns.grid(row=3, column=0, rowspan=2)
        for i, btn in enumerate(self.list_rb_dv_bts):
            btn.grid(row=i, column=0)
            if i > 0:
                btn.configure(state="disabled")
        for i, btn in enumerate(self.list_rb_db_bts):
            btn.grid(row=i, column=0)

        self.lbl_search_input.grid(row=1, column=1, columnspan=2)
        self.search_input.grid(row=2, column=1, columnspan=2)
        self.btn_clear_search.grid(row=3, column=1)
        self.btn_search.grid(row=3, column=2)
        self.mc.grid(row=4, column=1, columnspan=2)

    def get_selected_dbs(self):
        selected = []
        for i, btn in enumerate(self.list_tv_rb_db):
            if btn.get():
                selected.append(i)
        return selected

    def click_clear_search(self):
        self.tv_search_input.set("")
        self.mc.delete_item()

    def click_search(self):
        self.mc.delete_item()
        selected = self.get_selected_dbs()
        col_val_all = self.rv_options[self.tv_rb_dv.get()]
        inp = self.tv_search_input.get().lower()
        print(f"{inp=}, {selected=}")
        dfs = []
        if inp and selected:
            if col_val_all == self.rv_options[1]:
                messagebox.showinfo(
                    title=self.title_msgbox,
                    message="Search by value not supported yet."
                )

            elif col_val_all == self.rv_options[0]:
                ca = {v: k for k, v in self.sel_col_names.items()}
                for db_idx in selected:
                    db = self.list_databases[db_idx]
                    cd = parse_connection_data(db)
                    ca.update({"ST": inp})
                    sql = self.sql_table_template.format(**ca)
                    print(f"{inp=}\n{db=}\n{cd=}\n{ca=}")
                    print(f"SQL:\n{sql}")
                    df = connect(sql, **cd)
                    dfs.append(df)
                    print(f"{df=}")
                self.mc.add_new_item(pd.concat(dfs, ignore_index=True))
            else:
                messagebox.showinfo(
                    title=self.title_msgbox,
                    message="Search by value & column not supported yet."
                )


if __name__ == '__main__':
    app = App()
    app.mainloop()
