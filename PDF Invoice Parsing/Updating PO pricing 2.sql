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


----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------


SELECT
	*
FROM
	[PorMasterDetail]
WHERE
	RIGHT([PurchaseOrder], 6) IN (
		'135414',
		'145313'
		--,
		--'246898'
	)
ORDER BY
	[PurchaseOrder]


----------------------
----------------------


SELECT
	*
FROM
	[PorMasterDetail]
WHERE
	RIGHT([PurchaseOrder], 6) IN (
		'141933',
		'246898'
	)
ORDER BY
	[PurchaseOrder]