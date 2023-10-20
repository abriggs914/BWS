
DECLARE
	@y AS INT=2024
	,@dealer AS INT=138
	,@version AS INT=1
	,@companyID AS INT=1

SELECT
	*
FROM
	[DealersV2]
WHERE 
	[ID] = @dealer
	--AND [CompanyID] = @companyID

SELECT
	*
FROM
	[DealersV2]
WHERE 
	[Initials] LIKE '%hale%'

exec sp_BudgetForecastV2_ForecastEditDataFetch @y, @dealer, @version, @companyID