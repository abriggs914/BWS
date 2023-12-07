USE BWSdb
GO

SELECT
	[Orders_PromDrawing],
	[Products_PromoDrawing],
	[Products_PromoDrawingV2],
	*
FROM
	[v_SFC_BWSUnionSTGOrders]
WHERE
	[Orders_Quote] = '27841'


SELECT
	(CASE WHEN [Orders_DateDeclined] IS NOT NULL THEN 1 ELSE 0 END) AS [IsCancelled]
	,[Orders_DateDeclined]
	,[Orders_DeclineRejected]
	,*
FROM
	[v_SFC_BWSUnionSTGOrders]
WHERE
	[Orders_Quote] = '29835'