SELECT
	[WO#]
	,[NetCostCDN]
	,*
FROM
	[BWSdb].[dbo].[v_SAL_OrdersPricing]
WHERE
	([WO#] IN (
		10013852,
		10015640,
		10001574
	))
;
SELECT
	[WO#]
	,[NetCostCDN]
	,*
FROM
	[BWSdb].[dbo].[v_SAL_OrdersPricingV2]
WHERE
	([WO#] IN (
		10013852,
		10015640,
		10001574
	))