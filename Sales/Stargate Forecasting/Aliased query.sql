SELECT 
	OrdersV2.[PO Date],
	OrdersV2.SGQuote,
	OrdersV2.[WO#],
	OrdersV2.[Model No],
	OrdersV2.Width,
	OrdersV2.Spread,
	BWSdb_DealersV2.Initials,
	BWSdb_DealersV2.[COMPANY NAME],
	BWSdb_DealersV2.CONTACT,
	BWSdb_DealersV2_SalesPeople.[Sales Person] AS DealerSP,
	BWSdb_CustomersV2.Customer,
	[Sales Staff].[Sales Person] AS BWSSP,
	OrdersV2.Price,
	OrdersV2.[Delivery Date],
	OrdersV2.Discount3_Name,
	OrdersV2.Discount3_Type,
	OrdersV2.Discount3,
	OrdersV2.[Volume Discount],
	OrdersV2.[Program Discount], 
	OrdersV2.Discount1_Name,
	OrdersV2.Discount1_Type,
	OrdersV2.Discount1,
	OrdersV2.Notes,
	OrdersV2.EngNotes,
	OrdersV2.[US Sale],
	OrdersV2.[Deck Length],
	OrdersV2.[Quote Date],
	OrdersV2.[Date Declined],
	OrdersV2.[Order Date]
FROM (
	(([Sales Staff]
	INNER JOIN (
		DealersV2 AS [BWSdb_DealersV2]
	INNER JOIN
		OrdersV2
	ON 
		BWSdb_DealersV2.ID=OrdersV2.DealerID
	)
	ON 
		[Sales Staff].[ID-SaleStaff]=OrdersV2.[Sale PersonID]) 
	LEFT JOIN 
		CustomersV2 AS [BWSdb_CustomersV2]
	ON
		OrdersV2.SGQuote=BWSdb_CustomersV2.SGQuote) 
	LEFT JOIN 
		DealersV2_SalesPeople AS [BWSdb_DealersV2_SalesPeople]
	ON 
		OrdersV2.DealerSalesPersonID=BWSdb_DealersV2_SalesPeople.DealersV2_SPID)
	LEFT JOIN
		DealersV2_SalesPersonBranch AS [BWSdb_DealersV2_SalesPersonBranch]
	ON 
		OrdersV2.DealerBranchID=BWSdb_DealersV2_SalesPersonBranch.DealersV2_SPBID
WHERE (
	((OrdersV2.[PO Date]) Is Null)
	AND ((OrdersV2.[WO#]) Is Null)
	AND ((OrdersV2.[Date Declined]) Is Null)
	AND ((OrdersV2.[Order Date]) Is Null)
)
	AND (
		([Quote Date] Between '2021-01-01' And '2023-11-03')
		--AND [COMPANY NAME] = 'Martin''s Peterbilt'
	)

ORDER BY
	[COMPANY NAME]
;
