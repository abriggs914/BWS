USE BWSdb
GO

SELECT
	*
	--,[v_SFC_BWSUnionSTGOrders].[StockCode]
FROM
	[v_SFC_BWSUnionSTGOrders]
WHERE
	[Orders_SerialNumber] = '2SVS6B443RM000020'

SELECT
	*
	,[Orders_Discount1]
FROM
	[v_SFC_BWSUnionSTGOrders]
WHERE
	[v_SFC_BWSUnionSTGOrders].[Orders_WO] = '10014695'

-----------------------------------------------------

SELECT * FROM [Orders] WHERE [Serial Number] = '2XBB6EY35SA000137'


SELECT
	(CASE WHEN [OriginTable] = 'Order Options' OR [OriginTable] = 'Order OptionsV2' THEN 'Option' ELSE 'NPO' END) AS [OptionType]
	,[USSale]
	,[OptionDescription]
	,[OptionWeight]
	,[OptionDrawPartNum]
	,[OptionPrice]
	,[OptionCost]
	,[OptionNo]
	,[OptionSections]
	,[OptionSortSe]
	--,*
FROM
	[v_SFC_OrdersDataOptions]
WHERE
	[CompanyID] = 1
	AND [Quote] = 'SG101388'
ORDER BY
	[OptionSortSe]
	,[OptionDescription]
;

SELECT
	*
FROM
	[Custom WorkV2]
WHERE
	[SGQuote] = 'SG101388'