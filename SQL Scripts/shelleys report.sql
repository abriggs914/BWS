USE BWSdb
GO

SELECT [Production Slots].[PSlotID#]
	, [Production Slots].[Quote#]
	, [Production Slots].[Slot Date]
	, [Production Slots].[Slot Types]
	, [Production Slots].NoDays
	, [Production Slots].[Slot Prod Line]
	, [Production Slots].Dealer
	, Products.Class
	, [Production Slots].[Model No]
	, Dealers.[COMPANY NAME]
	, [Production Slots].Hours
	, [Production Slots].[Slot Status]
	, [Production Slots].[Sold/Stock Status]
	, [Production Slots].[Slot Notes]
	, [Production Slots].DeleteFlag
	, [Production Slots].DeleteUser
	, Orders.[Serial Number]
	, Orders.[WO#]
	, Orders.[Delivery Date]
	, Orders.[Model No] AS ModelName
FROM (([Production Slots] LEFT JOIN Products ON [Production Slots].[Model No] = Products.[Model No]) LEFT JOIN Dealers ON [Production Slots].Dealer = Dealers.ID) INNER JOIN Orders ON [Production Slots].[Quote#] = Orders.[Quote#];
