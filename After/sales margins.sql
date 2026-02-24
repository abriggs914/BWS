SELECT
	*
FROM 
	[BWSdb].[dbo].[v_SAL_OrdersMargin] [OM]
WHERE
	[OM].[Quote Date] BETWEEN DATEADD(YEAR, -1, GETDATE()) AND DATEADD(YEAR, 1, GETDATE())

SELECT
	[WM].[Job]
FROM 
	[SysproCompanyA].[dbo].[WipMaster] [WM]
WHERE
	[WM].[JobTenderDate] BETWEEN DATEADD(YEAR, -1, GETDATE()) AND DATEADD(YEAR, 1, GETDATE())
GROUP BY
	[WM].[Job]
