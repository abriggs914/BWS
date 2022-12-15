USE [BWSdb]
GO

/****** Object:  View [dbo].[v_UGMR All Data]    Script Date: 2022-12-15 8:55:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_UGMR All Data] AS

SELECT
	[User Happiness Rating].[UserHappyRatingID#]
      ,[User Happiness Rating].[UserName]
      ,[User Happiness Rating].[RatingDate]
      ,[User Happiness Rating].[Rating]
      ,[User Happiness Rating].[userhappyratingts]
      ,[User Happiness Rating].[RatingTime (DO NOT USE)]
      ,[User Happiness Rating].[RatingTime2]
      ,[User Happiness Rating].[Company] AS [UGMR Company],
	[ITR Customers].[CustomerID]
      ,[ITR Customers].[Name]
      ,[ITR Customers].[Department]
      ,[ITR Customers].[Company]
      ,[ITR Customers].[Email]
      ,[ITR Customers].[WorkPhone]
      ,[ITR Customers].[WorkExtension]
      ,[ITR Customers].[CellPhone]
      ,[ITR Customers].[HomePhone]
      ,[ITR Customers].[Active]
      ,[ITR Customers].[DateAdded]
      ,[ITR Customers].[LastActive]
      ,[ITR Customers].[WorkPhoneLastActive]
      ,[ITR Customers].[WorkExtensionLastActive]
      ,[ITR Customers].[CellPhoneLastActive]
      ,[ITR Customers].[HomePhoneLastActive],
	[Dept].[DeptID]
      ,[Dept].[BWS Code]
      ,[Dept].[Class]
      ,[Dept].[Grouping]
      ,[Dept].[Dept]
      ,[Dept].[Position]
      ,[Dept].[Budget]
      ,[Dept].[Authorized]
      ,[Dept].[Pay Scale]
      ,[Dept].[Comments]
	, CAST(CAST([RatingDate] AS NVARCHAR(10)) + ' ' + CAST([RatingTime2] AS NVARCHAR(10)) AS DATETIME) AS [UseThisDate]
FROM
	[User Happiness Rating]
LEFT JOIN
	[ITR Customers]
ON
	[User Happiness Rating].[UserName] = [ITR Customers].[Name]
LEFT JOIN
	[Dept]
ON	
	[ITR Customers].[Department] = [Dept].[DeptID]
GO


