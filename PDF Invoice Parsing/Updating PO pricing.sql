USE SysproCompanyA
GO

SELECT
	[PurchaseOrder]
	,[MStockCode]
FROM
	[PorMasterDetail]
GROUP BY
	[PurchaseOrder]
	,[MStockCode]
ORDER BY
	--[PurchaseOrder]
	[MStockCode]

SELECT
	*
FROM
	[PorMasterDetail]
WHERE
	RIGHT([PurchaseOrder], 6) IN (
		'246898',
		'141933'
	)

SELECT
	*
FROM
	[PorMasterDetail]
WHERE
	[MStockCode] IN (
		'00108-40944457',
		'00108-40944457',
		'00108-40944457',
		'00108-40944457'

		,
		'40944457',
		'40944457',
		'40944457',
		'40944457'
	)
	AND
	RIGHT([PurchaseOrder], 6) IN (
		'246898',
		'141933'
	)
ORDER BY
	[PurchaseOrder]