USE BWSdb
GO


SELECT
	*
FROM
	[v_SFC_BWSUnionSTGOrders]
;

--------------------------------------------------------------------------------------------------------------

-- Date Quote
-- Date Order
-- Date Beam
-- Date GNK
-- Date Prod
-- Date Finish
-- Date Available
-- Date Shipped
-- Date Delivered
-- Date In Service
-- Date Registered
-- Date Cancelled


SELECT
	(CASE WHEN ([V].[Orders_DateDeclined] IS NOT NULL) AND ([V].[Orders_DeclineRejected] <> 4) THEN 1 ELSE 0 END) AS [IsCancelled]
	,[Orders_DateQuote]
	,[Orders_DateOrder]
	,[V].[dtProdSched_DateBeam]
	,[V].[dtProdSched_DateGN]
	,ISNULL([V].[dtProdSched_DateProd1], [V].[dtProdSched_DateProd2]) AS [dtProdSched_DateProd]
	,[Orders_DateFinish]
	,[Orders_DateAvailable]
	,[Orders_DateShipped]
	,[Orders_DateDelivery]
	,[Orders_DateInService]
	,[Orders_DateRegistered]
	,[Orders_DateDeclined]
FROM
	[v_SFC_BWSUnionSTGOrders] AS [V]
WHERE
	[V].[Orders_Quote] = '25645'
;