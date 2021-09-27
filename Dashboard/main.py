import datetime
from pdf_writer import *

from db_demo import *
import annual_labour_costs
import annual_productive_hours
import annual_cost_per_productive_hour
import monthly_labour_costs
import monthly_productive_hours
import monthly_cost_per_productive_hour
import monthly_non_productive_hour
import monthly_net_productive_hour
import monthly_npp_productive_hour
import annual_non_productive_hour
import annual_net_productive_hour
import annual_npp_productive_hour
import monthly_budget_vs_prod_budget
import monthly_budget_vs_prod_actual
import monthly_budget_vs_prod_budget_actual
import annual_budget_vs_prod_budget
import annual_budget_vs_prod_actual
import annual_budget_vs_prod_budget_actual
import monthly_manufacturing_variance
import annual_manufacturing_variance
import annual_consumables_budget_budget
import annual_consumables_budget_consumables
import annual_consumables_budget_budget_consumables
import monthly_consumables_budget_budget
import monthly_consumables_budget_consumables
import monthly_consumables_budget_budget_consumables
import annual_labour_budget_budget
import annual_labour_budget_labour
import annual_labour_budget_budget_labour
import monthly_labour_budget_budget
import monthly_labour_budget_labour
import monthly_labour_budget_budget_labour
import annual_material_budget_budget
import annual_material_budget_material
import annual_material_budget_budget_material
import monthly_material_budget_budget
import monthly_material_budget_material
import monthly_material_budget_budget_material
import annual_overtime
import monthly_overtime
import annual_rework
import monthly_rework
import annual_attendance
import monthly_attendance
import annual_past_due_wos
import monthly_past_due_wos
import annual_inventory
import monthly_inventory
import annual_wip
import monthly_wip
import annual_g1_inventory
import annual_g1_cost_of_sales_inventory
import annual_g1_inventory_cost_of_sales
import annual_g1_inventory_turnover_days
import annual_g1_receivables
import annual_g1_cost_of_sales_receivables
import annual_g1_receivables_cost_of_sales
import annual_g1_receivables_turnover_days
import annual_g1_payables
import annual_g1_purchases_payables
import annual_g1_payables_purchases
import annual_g1_payables_turnover_days
import cycle_excess_money
import cycle_excess_percent

path = """\\server3\Projects\#IMPORTANT SCRIPT FOR LORI - For working on Senior Management Dashboard in SysproCompanyA (for stored procs, views, etc).sql"""


def create_graphs(date_path=None, clear_dir=False):
    if date_path is None:
        date_path = datetime.datetime.now().isoformat().split("T")[0]
    if clear_dir:
        shutil.rmtree(date_path)
    start_date = '1950-01-01'
    # start_date = '2050-01-01'
    end_date = '2100-12-31'
    print("<{}>".format(date_path))

    output_files = [
        # # WORKING SET:
        # pie_chart(start_date=start_date, end_date=end_date,path=date_path),
        # annual_labour_costs.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_productive_hours.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_cost_per_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_labour_costs.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_productive_hours.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_cost_per_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # # should cap these at a decade date range.
        # # inaccurate data before 2012
        # monthly_non_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_net_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_npp_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # # inaccurate data before 2012
        # annual_non_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_net_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_npp_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # monthly_budget_vs_prod_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_budget_vs_prod_actual.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_budget_vs_prod_budget_actual.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_budget_vs_prod_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_budget_vs_prod_actual.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_budget_vs_prod_budget_actual.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # monthly_manufacturing_variance.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_manufacturing_variance.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_consumables_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_consumables_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_consumables_budget_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # monthly_consumables_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_consumables_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_consumables_budget_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_labour_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_labour_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_labour_budget_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # monthly_labour_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_labour_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_labour_budget_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_material_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_material_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_material_budget_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # monthly_material_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_material_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_material_budget_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_overtime.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_overtime.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_rework.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_rework.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_attendance.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_attendance.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_past_due_wos.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_past_due_wos.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_inventory.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_inventory.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_wip.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_wip.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_g1_inventory.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_g1_cost_of_sales_inventory.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_g1_inventory_cost_of_sales.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_g1_inventory_turnover_days.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_g1_receivables.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_g1_cost_of_sales_receivables.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_g1_receivables_cost_of_sales.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_g1_receivables_turnover_days.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        # annual_g1_payables.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_g1_purchases_payables.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_g1_payables_purchases.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_g1_payables_turnover_days.create(start_date=start_date, end_date=end_date, path=date_path),

        cycle_excess_money.create(start_date=start_date, end_date=end_date, path=date_path),
        cycle_excess_percent.create(start_date=start_date, end_date=end_date, path=date_path)
    ]
    print("\n\n\tFile Paths:\n" + "\n".join(output_files))

    FILE_NAME = 'Dashboard Outputs.pdf'
    pdf = PDF(FILE_NAME, orientation='L', unit='mm', format='A4')
    pdf.set_auto_page_break(True, margin=5)
    pdf.set_title("Dashboard Outputs")
    pdf.set_author('Avery Briggs')
    TITLE_WIDTH = pdf.w * 0.85

    for file_name in output_files:
        pdf.add_page()
        # pdf.margin_lines(MARGIN_LINES_MARGIN, MARGIN_LINES_MARGIN, MAX_X - (2 * MARGIN_LINES_MARGIN),
        #                  MAX_Y - (2 * MARGIN_LINES_MARGIN), BWS_RED, WHITE)
        pdf.margin_border(BWS_RED, WHITE)
        strip_file_name = file_name.split("/")[-1].split(".png")[0].strip()
        pdf.titles(strip_file_name, (pdf.w - TITLE_WIDTH) / 2, 10, TITLE_WIDTH, TITLE_HEIGHT, BWS_BLACK)

        # date = datetime.datetime.now()
        # pdf.texts(
        #     MARGIN_LINES_WIDTH + MARGIN_LINES_MARGIN + TXT_MARGIN,
        #     TABLE_MARGIN + MARGIN_LINES_WIDTH + TITLE_HEIGHT + TITLE_MARGIN,
        #     0,
        #     10,
        #     "Prepared at {} on {}".format(
        #         datetime.datetime.strftime(date, "%I:%M:%S %p"),
        #         datetime.datetime.strftime(date, "%Y-%m-%d")
        #     ),
        #     font=('Arial', '', 10)
        # )

        print("adding image:", file_name)
        pdf.add_image(file_name, 10, 15, pdf.w * 0.985, pdf.h * 0.875, "")

        pdf.time_stamp()
    pdf.output(FILE_NAME, 'F')
    pdf.open_in_browser()

if __name__ == '__main__':
    start_time = datetime.datetime.now()

    create_graphs()

    end_time = datetime.datetime.now()
    diff = end_time - start_time
    print("\nProgram execution time:\n\t{} m : {} s: {} ms".format(diff.seconds // 60, diff.seconds % 60, diff.microseconds))
