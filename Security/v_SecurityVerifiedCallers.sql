USE [BWSdb]
GO

/****** Object:  View [dbo].[v_SecurityVerifiedCallers]    Script Date: 2022-03-28 1:10:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

ALTER VIEW [dbo].[v_SecurityVerifiedCallers]
AS

SELECT
	ROW_NUMBER() OVER(
		ORDER BY [PhoneProvider]
	) AS [Row#]
	,[SecurityEmpID]
	,[Employee]
	,[BWSEmpID]
	,[PhoneNumber]
	,[PhoneProvider]
	,[TimeStamp]
FROM
	[BWSdb].[dbo].[SecurityEmpV1]
WHERE
	[PhoneNumber] IS NOT NULL
	AND [PhoneProvider] IS NOT NULL
GO


