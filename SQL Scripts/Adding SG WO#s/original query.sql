USE BWSdb
GO

DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '2020-08-01';
SET @ED = '2022-09-22';

SELECT
	--[SysproCompanyS].[dbo].[WipMaster].[Job] AS [A],
	CAST([Design].[WO#] AS varchar(25)) AS [B],
	Orders.[Quote#],
	Design.[WO#],
	Design.[Model No],
	Design.Width,
	Design.Spread,
	Design.Other,
	Orders.[PO Date],
	Design.Prom,
	([prod date]-50) AS Steel,
	([prod date]-55) AS Laser,
	([prod date]-21) AS [Product Drawings],
	Design.Comments,
	Design.Staff,
	Design.Complete,
	Design.[Prod Date],
	Orders.[Date Declined]
FROM
	Design 
	--LEFT JOIN
	--	[SysproCompanyS].[dbo].[WipMaster]
	--ON
	--	[SysproCompanyS].[dbo].[WipMaster].[Job] LIKE CAST([Design].[WO#] AS varchar(25))
INNER JOIN
	Orders
ON
	Design.[Quote#] = Orders.[Quote#]
WHERE
	(((Design.Complete)=0) 
	AND ((Design.[Prod Date]) Between @SD And @ED) 
	AND ((Orders.[Date Declined]) Is Null))
