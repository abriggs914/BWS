SELECT
	*
FROM
	[v_SFC_BWSUnionSTGDealers]
WHERE
	[ID] = 395 OR [ID] = 3

SELECT
	*
FROM
	[v_SFC_BWSUnionSTGOrders]
--ORDER BY
--	[Orders_DateQuote]


	EXEC sp_SFC_IndividualSalesData
        @companyID=NULL
        ,@dealerID=-395
        ,@productID=NULL
        ,@salesPersonID=NULL
        ,@allCompanies=0;


	EXEC sp_SFC_IndividualSalesData
        @companyID=NULL
        ,@dealerID=-3
        ,@productID=NULL
        ,@salesPersonID=NULL
        ,@allCompanies=0;