/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10000000) [A].[LongLeadQuoteDetailsHistoryID#]
      ,[A].[LongLeadQuoteDetailsID]
      ,[A].[EventDatetime]
      ,[A].[EventType]
      ,[A].[UpdatedColumn]
      ,[A].[ValueBefore]
      ,[A].[ValueAfter]
      ,[A].[ChangedBy]
      ,[A].[LongLeadQuoteID#]
      ,[A].[PartClassID]
      ,[A].[Part Number]
      ,[A].[Quantity]
      ,[A].[Notes]
      ,[A].[LastUpdatedBy]

	  ,[B].[LongLeadQuoteDetailsID#]
      ,[B].[LongLeadQuoteID#]
      ,[B].[PartClassID]
      ,[B].[Part Number]
      ,[B].[Quantity]
      ,[B].[Notes]
      ,[B].[LastUpdatedBy]
      ,[B].[LastUpdated]

	  ,[C].[LongLeadQuoteID#]
      ,[C].[Unit Number]
      ,[C].[Quote Description]
      ,[C].[LastUpdatedBy]
      ,[C].[SGQuote]
      ,[C].[Stargate Syspro WO#]
      ,[C].[Stargate 4-Digit WO#]
      ,[C].[Stargate Serial Number]
  FROM [Stargatedb].[dbo].[LongLeadQuoteDetails_History] AS [A]
  INNER JOIN
	[LongLeadQuoteDetails] AS [B]
	ON 
	[A].[LongLeadQuoteDetailsID] = [B].[LongLeadQuoteDetailsID#]
  INNER JOIN
	[LongLeadQuoteMaster] AS [C]
	ON 
	[C].[LongLeadQuoteID#] = [B].[LongLeadQuoteID#]

WHERE
[SGQuote] = 'SG101171'
  ORDER BY 
      [EventDatetime] DESC