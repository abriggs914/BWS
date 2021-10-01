import datetime
from utility import *
from pdf_writer import *

from db_demo import *
import queries
from graph_generator import *
# import annual_labour_costs
# import annual_productive_hours
# import annual_cost_per_productive_hour
# import monthly_labour_costs
# import monthly_productive_hours
# import monthly_cost_per_productive_hour
# import monthly_non_productive_hour
# import monthly_net_productive_hour
# import monthly_npp_productive_hour
# import annual_non_productive_hour
# import annual_net_productive_hour
# import annual_npp_productive_hour
# import monthly_budget_vs_prod_budget
# import monthly_budget_vs_prod_actual
# import monthly_budget_vs_prod_budget_actual
# import annual_budget_vs_prod_budget
# import annual_budget_vs_prod_actual
# import annual_budget_vs_prod_budget_actual
# import monthly_manufacturing_variance
# import annual_manufacturing_variance
# import annual_consumables_budget_budget
# import annual_consumables_budget_consumables
# import annual_consumables_budget_budget_consumables
# import monthly_consumables_budget_budget
# import monthly_consumables_budget_consumables
# import monthly_consumables_budget_budget_consumables
# import annual_labour_budget_budget
# import annual_labour_budget_labour
# import annual_labour_budget_budget_labour
# import monthly_labour_budget_budget
# import monthly_labour_budget_labour
# import monthly_labour_budget_budget_labour
# import annual_material_budget_budget
# import annual_material_budget_material
# import annual_material_budget_budget_material
# import monthly_material_budget_budget
# import monthly_material_budget_material
# import monthly_material_budget_budget_material
# import annual_overtime
# import monthly_overtime
# import annual_rework
# import monthly_rework
# import annual_attendance
# import monthly_attendance
# import annual_past_due_wos
# import monthly_past_due_wos
# import annual_inventory
# import monthly_inventory
# import annual_wip
# import monthly_wip
# import annual_g1_inventory
# import annual_g1_cost_of_sales_inventory
# import annual_g1_inventory_cost_of_sales
# import annual_g1_inventory_turnover_days
# import annual_g1_receivables
# import annual_g1_cost_of_sales_receivables
# import annual_g1_receivables_cost_of_sales
# import annual_g1_receivables_turnover_days
# import annual_g1_payables
# import annual_g1_purchases_payables
# import annual_g1_payables_purchases
# import annual_g1_payables_turnover_days
# import cycle_excess_money
# import cycle_excess_percent
#
# path = """\\server3\Projects\#IMPORTANT SCRIPT FOR LORI - For working on Senior Management Dashboard in SysproCompanyA (for stored procs, views, etc).sql"""
#
#
# def create_graphs(date_path=None, clear_dir=False):
#     if date_path is None:
#         date_path = datetime.datetime.now().isoformat().split("T")[0]
#     if clear_dir:
#         shutil.rmtree(date_path)
#     start_date = '1950-01-01'
#     # start_date = '2050-01-01'
#     end_date = '2100-12-31'
#     print("<{}>".format(date_path))
#
#     output_files = [
#         # WORKING SET:
#         pie_chart(start_date=start_date, end_date=end_date,path=date_path),
#         annual_labour_costs.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_productive_hours.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_cost_per_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_labour_costs.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_productive_hours.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_cost_per_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         # should cap these at a decade date range.
#         # inaccurate data before 2012
#         monthly_non_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_net_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_npp_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         # inaccurate data before 2012
#         annual_non_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_net_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_npp_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         monthly_budget_vs_prod_budget.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_budget_vs_prod_actual.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_budget_vs_prod_budget_actual.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_budget_vs_prod_budget.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_budget_vs_prod_actual.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_budget_vs_prod_budget_actual.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         monthly_manufacturing_variance.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_manufacturing_variance.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_consumables_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_consumables_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_consumables_budget_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         monthly_consumables_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_consumables_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_consumables_budget_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_labour_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_labour_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_labour_budget_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         monthly_labour_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_labour_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_labour_budget_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_material_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_material_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_material_budget_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         monthly_material_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_material_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_material_budget_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_overtime.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_overtime.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_rework.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_rework.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_attendance.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_attendance.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_past_due_wos.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_past_due_wos.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_inventory.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_inventory.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_wip.create(start_date=start_date, end_date=end_date, path=date_path),
#         monthly_wip.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_g1_inventory.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_g1_cost_of_sales_inventory.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_g1_inventory_cost_of_sales.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_g1_inventory_turnover_days.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_g1_receivables.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_g1_cost_of_sales_receivables.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_g1_receivables_cost_of_sales.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_g1_receivables_turnover_days.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         annual_g1_payables.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_g1_purchases_payables.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_g1_payables_purchases.create(start_date=start_date, end_date=end_date, path=date_path),
#         annual_g1_payables_turnover_days.create(start_date=start_date, end_date=end_date, path=date_path),
#
#         cycle_excess_money.create(start_date=start_date, end_date=end_date, path=date_path),
#         cycle_excess_percent.create(start_date=start_date, end_date=end_date, path=date_path)
#     ]
#     print("\n\n\tFile Paths:\n" + "\n".join(output_files))
#
#     FILE_NAME = 'Dashboard Outputs.pdf'
#     pdf = PDF(FILE_NAME, orientation='L', unit='mm', format='A4')
#     pdf.set_auto_page_break(True, margin=5)
#     pdf.set_title("Dashboard Outputs")
#     pdf.set_author('Avery Briggs')
#     TITLE_WIDTH = pdf.w * 0.85
#
#     for file_name in output_files:
#         pdf.add_page()
#         # pdf.margin_lines(MARGIN_LINES_MARGIN, MARGIN_LINES_MARGIN, MAX_X - (2 * MARGIN_LINES_MARGIN),
#         #                  MAX_Y - (2 * MARGIN_LINES_MARGIN), BWS_RED, WHITE)
#         pdf.margin_border(BWS_RED, WHITE)
#         strip_file_name = file_name.split("/")[-1].split(".png")[0].strip()
#         pdf.titles(strip_file_name, (pdf.w - TITLE_WIDTH) / 2, 10, TITLE_WIDTH, TITLE_HEIGHT, BWS_BLACK)
#
#         # date = datetime.datetime.now()
#         # pdf.texts(
#         #     MARGIN_LINES_WIDTH + MARGIN_LINES_MARGIN + TXT_MARGIN,
#         #     TABLE_MARGIN + MARGIN_LINES_WIDTH + TITLE_HEIGHT + TITLE_MARGIN,
#         #     0,
#         #     10,
#         #     "Prepared at {} on {}".format(
#         #         datetime.datetime.strftime(date, "%I:%M:%S %p"),
#         #         datetime.datetime.strftime(date, "%Y-%m-%d")
#         #     ),
#         #     font=('Arial', '', 10)
#         # )
#
#         print("adding image:", file_name)
#         pdf.add_image(file_name, 10, 15, pdf.w * 0.985, pdf.h * 0.875, "")
#
#         pdf.time_stamp()
#     pdf.output(FILE_NAME, 'F')
#     pdf.open_in_browser()


#query, output_filename, x_axis, title='', start_date='1900-01-01', end_date='2100-01-01', col=None,
# path=None, draw_title=False, x_lbl=None, y_lbl=None, formatter=IntFormatter
def gen_graphs(file_name=None, date_path=None, pdf_path=None, items=None, file_title=None, file_under_title=None, clear_dir=False, p_start_date=None, p_end_date=None, replace_pdf=False, cap=None, open_final=True, skip_empties=False, return_object=False):
    if date_path is None:
        date_path = datetime.datetime.now().isoformat().split("T")[0]
    if items is None:
        items = [d for d in dir(queries) if "QUERY__" in d]
    if cap is not None:
        items = items[:cap]
    # print("parsed items", items)
    item_count_a = len(items)
    output_files = []
    for i, q_obj_name in enumerate(items):
        query_data = eval("queries." + q_obj_name)
        query = query_data["query"]
        output_filename = query_data["output_filename"]
        x_axis = query_data["x_axis"]
        title = query_data["title"] if "title" in query_data else ""
        start_date = query_data["start_date"] if "start_date" in query_data else '1900-01-01'
        end_date = query_data["end_date"] if "end_date" in query_data else '2100-01-01'

        if p_start_date is not None:
            start_date = p_start_date

        if p_end_date is not None:
            end_date = p_end_date

        col = query_data["col"] if "col" in query_data else None
        path = query_data["path"] if "path" in query_data else None
        draw_title = query_data["draw_title"] if "draw_title" in query_data else False
        x_lbl = query_data["x_lbl"] if "x_lbl" in query_data else None
        y_lbl = query_data["y_lbl"] if "y_lbl" in query_data else None
        formatter = query_data["formatter"] if "formatter" in query_data else IntFormatter

        if path is None:
            path = date_path
        if clear_dir:
            shutil.rmtree(path)
        output_files.append((create_graph(query, output_filename, x_axis, title=title, start_date=start_date, end_date=end_date, col=col, path=path, draw_title=draw_title, x_lbl=x_lbl, y_lbl=y_lbl, formatter=formatter), (start_date, end_date, col)))
        message = "Successfully created graph \"{}\"".format(title)
        message = message.ljust(100, ".") + bar(i, item_count_a).rjust(21, ".")
        print(message)

    # print("\n\n\tRESULTING FILES:\n" + "\n".join([of[0] for of in output_files]))
    item_count_b = len(output_files)

    assert (item_count_b - item_count_a) == 0, "At least one query was parsed incorrectly and overwrote an existing image."

    file_name.replace(".pdf", "").replace("/", "\\")
    if file_name is None:
        FILE_NAME = '\\Dashboard Outputs'
    else:
        if file_name[0] != "\\":
            file_name = "\\" + file_name
        FILE_NAME = file_name




    if pdf_path is not None:
        date_path = date_path + ("" if pdf_path[0] == "\\" and date_path[-1] == "\\" else "\\") + pdf_path
        try:
            # if not date_path[-1] == '\\':
            #     date_path = date_path + '\\'
            if not os.path.isdir(date_path):
                    os.makedirs(date_path)
        except NotADirectoryError:
            print("Directory: \"{}\" not found.\nDefaulting to current directory.".format(path))
            date_path = ''
        except FileNotFoundError:
            print("Directory: \"{}\" not found.\nDefaulting to current directory.".format(path))
            date_path = ''




    FILE_NAME = date_path + FILE_NAME
    # if FILE_NAME[-4:] != ".pdf":
    #     FILE_NAME = FILE_NAME + ".pdf"
    if not replace_pdf:
        number_copies = 0
        og_name = FILE_NAME
        print("Trying not to overwrite the previous outputs.", FILE_NAME)
        print("os.path.exists(FILE_NAME)", os.path.exists(FILE_NAME + ".pdf"))
        while os.path.exists(FILE_NAME + ".pdf"):
            number_copies += 1
            og_name.replace(".pdf", "")
            FILE_NAME = og_name + " ({})".format(number_copies)
    if ".pdf" != FILE_NAME[-4]:
        FILE_NAME = FILE_NAME + ".pdf"
    print("\n\n\tCreating pdf \"{}\"...\n".format(FILE_NAME))
    pdf = PDF(FILE_NAME, orientation='L', unit='mm', format='A4')
    pdf.set_auto_page_break(True, margin=5)
    pdf.set_title("Dashboard Outputs")
    pdf.set_author('Avery Briggs')
    TITLE_WIDTH = pdf.w * 0.85

    # title page
    if file_title is None:
        out_file_title = "BWS Dashboard Charts"
    else:
        out_file_title = file_title
    if file_under_title is None:
        out_under_title = ""
    else:
        out_under_title = file_under_title

    pdf.add_page()
    pdf.margin_border(BWS_RED, WHITE)
    pdf.titles(out_file_title, (pdf.w - 200) / 2, (pdf.h - 100) / 2, 200, 100, BWS_BLACK, border=1,font=('Arial', 'B', 20))
    if out_under_title:
        pdf.titles(out_under_title, ((pdf.w - 75) / 2), 10 + ((pdf.h - 40) / 2), 75, 40, BWS_BLACK, font=('Arial', 'B', 16))
    pdf.time_stamp()

    # append a new page fpr each chart
    for file_name, params in output_files:
        if skip_empties:
            if file_name.split("/")[-1][:5] == "EMPTY":
                continue
        start_date, end_date, col = params
        pdf.add_page()
        pdf.margin_border(BWS_RED, WHITE)
        strip_file_name = file_name.split("/")[-1].split(".png")[0].strip()
        pdf.titles(strip_file_name, (pdf.w - TITLE_WIDTH) / 2, 10, TITLE_WIDTH, TITLE_HEIGHT, BWS_BLACK)
        if start_date is not None and start_date != "":
            start_date = date_str_format(start_date)
            end_date = date_str_format(end_date)
            pdf.titles("{} - {}".format(start_date, end_date), (pdf.w - (pdf.w * 0.21)) / 2, 6 + TITLE_HEIGHT, pdf.w * 0.21, TITLE_HEIGHT, font=('Arial', '', 10), colour=BWS_BLACK)

        # print("adding image:", file_name)
        pdf.add_image(file_name, 10, 14 + TITLE_HEIGHT, (pdf.w - TITLE_HEIGHT) * 0.96, pdf.h * 0.8, "")
        pdf.time_stamp()

    if not return_object:
        # save & show
        pdf.output(FILE_NAME, 'F')
        if open_final:
            pdf.open_in_browser()
    else:
        return pdf, (FILE_NAME, 'F')


if __name__ == '__main__':

    start_time = datetime.datetime.now()

    # Adjust these templates to pass generic formatting based on unique
    # graph style. i.e. by year / decade ...
    graphs_to_make = {
        "All Data": {
            "file_name": "All BWS data",
            "date_path": "Draft version 1",
            "pdf_path": "PDFs",
            "open_final": False
            # ,
            # "cap":1
        }
    }
    yearly_graph_data = {
            "file_under_title": "-- {} --",
            "file_name": "Data from {}",
            "p_start_date": "{}-01-01",
            "p_end_date": "{}-12-31",
            "skip_empties": True,
            "date_path": "Draft version 1",
            "pdf_path": "PDFs",
            "open_final": False
            # ,
            # "cap":1
    }
    decade_graph_data = {
            "file_under_title": "-- {} To {} --",
            "file_name": "Data from {} to {}",
            "p_start_date": "{}-01-01",
            "p_end_date": "{}-12-31",
            "skip_empties": True,
            "date_path": "Draft version 1",
            "pdf_path": "PDFs",
            "open_final": False
            # ,
            # "cap":1
    }

    yearly_graphs_to_make = {}
    for year in range(2005, 2022):
        t = {k: v for k, v in yearly_graph_data.items()}
        t.update({
            "file_under_title": yearly_graph_data["file_under_title"].format(year),
            "file_name": yearly_graph_data["file_name"].format(year),
            "p_start_date": yearly_graph_data["p_start_date"].format(year),
            "p_end_date": yearly_graph_data["p_end_date"].format(year)
        })
        yearly_graphs_to_make[str(year)] = t

    graphs_to_make.update(yearly_graphs_to_make)

    decade_graphs_to_make = {}
    for year in range(2005, 2026, 10):
        a = year - 5
        b = int(year) + 5
        t = {k: v for k, v in decade_graph_data.items()}
        t.update({
            "file_under_title": decade_graph_data["file_under_title"].format(a, b),
            "file_name": decade_graph_data["file_name"].format(a, b),
            "p_start_date": decade_graph_data["p_start_date"].format(a),
            "p_end_date": decade_graph_data["p_end_date"].format(b)
        })
        decade_graphs_to_make[str(year)] = t

    graphs_to_make.update(decade_graphs_to_make)

    print(dict_print(graphs_to_make, "Graphs to Make", number=True))

    # create_graphs()
    # gen_graphs(p_start_date="2021-09-21", p_end_date="2021-09-30")
    # gen_graphs(p_start_date="2021-01-01", p_end_date="2021-09-29")

    for output_file, graph_data in graphs_to_make.items():
        graph_data.update({"return_object": True, "date_path": "Draft Version 3"})
        pdf, save_args = gen_graphs(**graph_data)
        if "date_path" in graph_data and "pdf_path" in graph_data:
            x = "\\" if graph_data["pdf_path"][0] != "\\" and graph_data["date_path"][-1] != "\\" else ""
            none_path = graph_data["date_path"] + x + graph_data["date_path"]
        else:
            none_path = ""
        if "p_start_date" in graph_data and "p_end_date" in graph_data:
            p_start_date = graph_data["p_start_date"]
            p_end_date = graph_data["p_end_date"]

            pie_chart(start_date=p_start_date, end_date=p_end_date, path=none_path, pdf=pdf)
        else:
            pie_chart(path=none_path, pdf=pdf)
        pdf.output(*save_args)
        # print("Creating PDF: {}".format(output_file))

    end_time = datetime.datetime.now()
    diff = end_time - start_time
    print("\nProgram execution time:\n\t{} m : {} s: {} ms".format(diff.seconds // 60, diff.seconds % 60, diff.microseconds))
