USE BWSdb
GO


EXEC sp_OrdersRecapByDealer_Scheduler
EXEC sp_OrdersRecapByDealer_SchedulerV2 -- Quotes VS Orders

EXEC sp_BudgetForecastV2_ApplyInputLive

exec [sp_BudgetForecastV2_RptByClassSpecificDealer V2] 2024, 138, 1, 1, 0
exec [sp_BudgetForecastV2_RptByClassSpecificDealer V2] 2024, 138, 1, 1, 1
--exec [sp_BudgetForecastV2_RptByClassSpecificDealer V2] 2024, 138, 1, 1, 1
EXEC sp_BudgetForecastV2_ForecastEditDataFetch 2024, 138, 1, 1

SELECT * FROM [SysproCompanyA].[dbo].[v_BOMCosting]
SELECT * FROM [SysproCompanyS].[dbo].[v_BOMCosting]


USE Stargatedb
GO


SELECT
	*
FROM
	[dtSalesPerformance]

USE BWSdb
GO
EXEC [sp_OrdersRecapByDealer_Scheduler]