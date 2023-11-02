USE BWSdb
GO


SELECT [Budget Forecast V2 Master].Version FROM [Budget Forecast V2 Master] 
--WHERE 
--((([Budget Forecast V2 Master].Fiscal)=[Forms]![Class Budget Forecast By Dealer Parameters]![Fis]))
GROUP BY [Budget Forecast V2 Master].Version; 

SELECT * FROM [ITD Project Directory]

exec [sp_BudgetForecastV2_RptByClass_Dealer V2] 2024, 1, 1, 1
exec [sp_BudgetForecastV2_RptClassBudgetvsActualSummary V2] '2023', 1, 1, 0
exec [sp_BudgetForecastV2_RptClassBudgetvsActualSummary V2] '2024', 1, 1, 0
exec [sp_BudgetForecastV2_RptClassBudgetvsActualSummary V2] '2023', 1, 1, 1
exec [sp_BudgetForecastV2_RptClassBudgetvsActualSummary V2] '2023', 1, 1, 1