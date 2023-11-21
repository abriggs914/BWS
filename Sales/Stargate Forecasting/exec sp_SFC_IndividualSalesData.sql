USE BWSdb
GO

-- All data grouped by company, product, dealer, and salesperson
EXEC sp_SFC_IndividualSalesData
	@companyID=NULL
	,@dealerID=0
	,@productID=0
	,@salesPersonID=0
	,@allCompanies=NULL