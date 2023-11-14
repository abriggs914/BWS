SELECT
	*
	,[GrandTotalOrders] + [GrandTotalOutQuotes] + [GrandTotalCancellations]
	,[GrandTotalOrders] + [GrandTotalOutQuotes] + [GrandTotalCancellations]
FROM (
	SELECT
			COUNT(*) AS [GrandTotalQuotes]
		FROM
			[v_SFC_OrdersData]
	) AS [A] 
	CROSS JOIN (
		SELECT
			COUNT(*) AS [GrandTotalOrders]
		FROM
			[v_SFC_OrdersData]
		WHERE
			[Date Declined] IS NULL
			AND [v_SFC_OrdersData].[QuoteOrderDate] IS NOT NULL
	) AS [B] 
	CROSS JOIN (
		SELECT
			COUNT(*) AS [GrandTotalCancellations]
		FROM
			[v_SFC_OrdersData]
		WHERE
			[Date Declined] IS NOT NULL
	) AS [C] 
	CROSS JOIN (
		SELECT
			COUNT(*) AS [GrandTotalOutQuotes]
		FROM
			[v_SFC_OrdersData]
		WHERE
			[Date Declined] IS NOT NULL
			AND [QuoteOrderDate] IS NULL
	) AS [D] 