USE BWSdb
GO

SELECT
	*
FROM
	[Budget Forecast V2 Master]

SELECT
	*
FROM
	[Budget Forecast V2]

USE Stargatedb
GO

EXEC sp_BudgetForecastV2_ForecastInput
	@fiscalyear=2023
	, @dealerid=330
	, @version=12