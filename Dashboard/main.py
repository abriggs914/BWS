from db_demo import *
import annual_labour_costs
import annual_productive_hours
import annual_cost_per_productive_hour
import monthly_labour_costs
import monthly_productive_hours
import monthly_cost_per_productive_hour


if __name__ == '__main__':
    pie_chart()
    annual_labour_costs.create()
    annual_productive_hours.create()
    annual_cost_per_productive_hour.create()
    monthly_labour_costs.create(start_date='2020-01-01', end_date='2021-12-31')
    monthly_productive_hours.create(start_date='2020-01-01', end_date='2021-12-31')
    monthly_cost_per_productive_hour.create(start_date='2020-01-01', end_date='2021-12-31')
