

exec [sp_BudgetForecastV2_RptByClassSpecificDealer V2]
	2024,
	138,
	1,
	1,
	1
	
exec [sp_BudgetForecastV2_RptByClass V2] 2024, 1, 1, 1
exec [sp_BudgetForecastV2_RptByClass V2] 2024, 1, 1, 0
exec [sp_BudgetForecastV2_RptByClass_Dealer V2] 2024, 1, 1.0, 0
exec [sp_BudgetForecastV2_RptByClass_Dealer V2] 2024, 1, 1.0, 1