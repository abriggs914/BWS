
SELECT
	[SGQuote]
	,[Model No]
	,[Serial Number]
	,[GVWR]
	--,[Date In Service]
	--,[Date Registered]
	--,[Date Requested]
	,[Delivery Date]
	--,[Finish Date]
	/*,[UnitQtyReqd]
	,[M].**/
	,RIGHT([Serial Number], 8) AS [Right8]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
ORDER BY
	[Delivery Date] DESC


SELECT
	RIGHT([Serial Number], 8) AS [Right8]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
GROUP BY
	RIGHT([Serial Number], 8)
HAVING 
	COUNT(*) > 1