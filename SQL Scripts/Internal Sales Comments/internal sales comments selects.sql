/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [OrderID]
      ,[SGQuote]
      ,[Quote Date]
      ,[Order Date]
      ,[WO#]
      ,[Sales Order#]
      ,[Model No]
      ,[InternalSalesComments]
      ,[InternalSalesCommentDate]
      ,[InternalSalesCommenter]
  FROM [BWSdb].[dbo].[OrdersV2]

  WHERE 
	[InternalSalesComments] IS NOT NULL
	OR [InternalSalesCommentDate] IS NOT NULL
	OR [InternalSalesCommenter] IS NOT NULL
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
[Quote#]
      ,[Quote Date]
      ,[Order Date]
      ,[WO#]
      ,[Sales Order#]
      ,[Model No]
      ,[InternalSalesComment]
      ,[InternalSalesCommentDate]
      ,[InternalSalesCommenter]
  FROM [BWSdb].[dbo].[Orders]
  

  WHERE 
	[InternalSalesComment] IS NOT NULL
	OR [InternalSalesCommentDate] IS NOT NULL
	OR [InternalSalesCommenter] IS NOT NULL