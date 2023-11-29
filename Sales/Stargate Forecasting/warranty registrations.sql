USE BWSdb
GO

SELECT
	[V].[OriginTable],
	[V].[Dealers_ID],
	[V].[Dealers_COMPANYNAME],
	COUNT([V].[Orders_DateRegistered]) AS [NumWarrantyRegistrations]
FROM
	[v_SFC_BWSUnionSTGOrders] AS [V]
WHERE
	[V].[Dealers_ID] IS NOT NULL
GROUP BY
	[V].[OriginTable],
	[V].[Dealers_ID],
	[V].[Dealers_COMPANYNAME]
ORDER BY
	[V].[Dealers_COMPANYNAME]

SELECT
	[OriginTable],
	SUM([NumWarrantyRegistrations]) AS [Total Registrations]
FROM (
	SELECT
		[V].[OriginTable],
		[V].[Dealers_ID],
		[V].[Dealers_COMPANYNAME],
		COUNT([V].[Orders_DateRegistered]) AS [NumWarrantyRegistrations]
	FROM
		[v_SFC_BWSUnionSTGOrders] AS [V]
	WHERE
		[V].[Dealers_ID] IS NOT NULL
	GROUP BY
		[V].[OriginTable],
		[V].[Dealers_ID],
		[V].[Dealers_COMPANYNAME]
) AS [A]
GROUP BY
	[OriginTable]

--SELECT * FROM [v_SFC_BWSUnionSTGOrders]