exec [sp_BudgetForecastV2_RptByClassSpecificDealer V2] 2024, 330, 1, 1

EXEC sp_BudgetForecastV2_ForecastInput @fiscalyear=2023, @dealerid=330, @version=NULL, @companyID=1
