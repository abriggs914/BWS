import datetime
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

path = "\\server3\Projects\#IMPORTANT SCRIPT FOR LORI - For working on Senior Management Dashboard in SysproCompanyA (for stored procs, views, etc).sql"

if __name__ == '__main__':
    date_path = datetime.datetime.now().isoformat().split("T")[0]
    print("<{}>".format(date_path))
    pie_chart(path=date_path)
    annual_labour_costs.create(path=date_path)
    annual_productive_hours.create(path=date_path)
    annual_cost_per_productive_hour.create(path=date_path)
    monthly_labour_costs.create(start_date='2020-01-01', end_date='2021-12-31', path=date_path)
    monthly_productive_hours.create(start_date='2020-01-01', end_date='2021-12-31', path=date_path)
    monthly_cost_per_productive_hour.create(start_date='2020-01-01', end_date='2021-12-31', path=date_path)

    # should cap these at a decade date range.
    # inaccurate data before 2012
    monthly_non_productive_hour.create(start_date='1999-01-01', end_date='2022-12-31', path=date_path)
    monthly_net_productive_hour.create(start_date='1999-01-01', end_date='2022-12-31', path=date_path)
    monthly_npp_productive_hour.create(start_date='1999-01-01', end_date='2022-12-31', path=date_path)

    # inaccurate data before 2012
    annual_non_productive_hour.create(start_date='1999-01-01', end_date='2022-12-31', path=date_path)
    annual_net_productive_hour.create(start_date='1999-01-01', end_date='2022-12-31', path=date_path)
    annual_npp_productive_hour.create(start_date='1999-01-01', end_date='2022-12-31', path=date_path)

    monthly_budget_vs_prod_budget.create(start_date='1999-01-01', end_date='2022-12-31', path=date_path)
    monthly_budget_vs_prod_actual.create(start_date='1999-01-01', end_date='2022-12-31', path=date_path)
