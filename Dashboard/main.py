import datetime
import shutil

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

path = """\\server3\Projects\#IMPORTANT SCRIPT FOR LORI - For working on Senior Management Dashboard in SysproCompanyA (for stored procs, views, etc).sql"""


def create_graphs(clear_dir=False):
    date_path = datetime.datetime.now().isoformat().split("T")[0]
    if clear_dir:
        shutil.rmtree(date_path)
    start_date = '1950-01-01'
    start_date = '2050-01-01'
    end_date = '2100-12-31'
    print("<{}>".format(date_path))

    output_files = [
        # WORKING SET:
        # pie_chart(start_date=start_date, end_date=end_date,path=date_path),
        # annual_labour_costs.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_productive_hours.create(start_date=start_date, end_date=end_date, path=date_path),
        # annual_cost_per_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_labour_costs.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_productive_hours.create(start_date=start_date, end_date=end_date, path=date_path),
        # monthly_cost_per_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        #
        #
        #
        #
        # # should cap these at a decade date range.
        # # inaccurate data before 2012
        monthly_non_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_net_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_npp_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),

        # inaccurate data before 2012
        annual_non_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_net_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_npp_productive_hour.create(start_date=start_date, end_date=end_date, path=date_path),

        monthly_budget_vs_prod_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_budget_vs_prod_actual.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_budget_vs_prod_budget_actual.create(start_date=start_date, end_date=end_date, path=date_path),

        annual_budget_vs_prod_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_budget_vs_prod_actual.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_budget_vs_prod_budget_actual.create(start_date=start_date, end_date=end_date, path=date_path),

        monthly_manufacturing_variance.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_manufacturing_variance.create(start_date=start_date, end_date=end_date, path=date_path),

        annual_consumables_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_consumables_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_consumables_budget_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),

        monthly_consumables_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_consumables_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_consumables_budget_budget_consumables.create(start_date=start_date, end_date=end_date, path=date_path),

        annual_labour_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_labour_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_labour_budget_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),

        monthly_labour_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_labour_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_labour_budget_budget_labour.create(start_date=start_date, end_date=end_date, path=date_path),

        annual_material_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_material_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
        annual_material_budget_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),

        monthly_material_budget_budget.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_material_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_material_budget_budget_material.create(start_date=start_date, end_date=end_date, path=date_path),

        annual_overtime.create(start_date=start_date, end_date=end_date, path=date_path),
        monthly_overtime.create(start_date=start_date, end_date=end_date, path=date_path)
    ]
    print("\n\n\tFile Paths:\n" + "\n".join(output_files))

if __name__ == '__main__':
    start_time = datetime.datetime.now()

    create_graphs()

    end_time = datetime.datetime.now()
    diff = end_time - start_time
    print("\nProgram execution time:\n\t{} m : {} s: {} ms".format(diff.seconds // 60, diff.seconds % 60, diff.microseconds))
