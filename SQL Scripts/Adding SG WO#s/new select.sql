USE BWSdb
GO

DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '2020-08-01';
SET @ED = '2022-09-22';


SELECT
	[StockCode],
	[Src].*
FROM (
	SELECT
		Orders.[Quote#],
		Design.[WO#],
		Orders.[WO#] AS [Orders WO#],
		Orders.[Serial Number],
		Orders.[Customer WO#],
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
	INNER JOIN
		Orders
	ON
		Design.[Quote#] = Orders.[Quote#]
	WHERE
		(((Design.Complete)=0) 
		AND ((Design.[Prod Date]) Between @SD And @ED) 
		AND ((Orders.[Date Declined]) Is Null))
) AS [Src]
left outer join SysproCompanyS.dbo.WipMaster with (nolock) on 'WO' + left([Customer WO#], 4) collate Latin1_General_BIN = WipMaster.StockCode
ORDER BY
	[StockCode]
;


--SELECT * FROM [Orders]
--SELECT * FROM [Design]
--SELECT * FROM [SysproCompanyS].[dbo].[WipMaster]


--SELECT
--	REPLACE(LTRIM(REPLACE([SysproCompanyS].[dbo].[WipMaster].[Job], '0', ' ')), ' ', '0') AS [A],
--	CAST([Design].[WO#] AS VARCHAR(25)) AS [B],
--	*
--FROM
--	[Design]
--JOIN
--	[SysproCompanyS].[dbo].[WipMaster]
--ON
--	REPLACE(LTRIM(REPLACE([SysproCompanyS].[dbo].[WipMaster].[Job], '0', ' ')), ' ', '0') = CAST([Design].[WO#] AS VARCHAR(25))
	




--SELECT [WO#], * FROM [Design] ORDER BY [Prod Date] DESC
--SELECT [Job], [StockCode], * FROM [SysproCompanyS].[dbo].[WipMaster] ORDER BY [SysproCompanyS].[dbo].[WipMaster].[Job]
	




--SELECT CAST([Design].[WO#] AS VARCHAR(25)) AS [B], * FROM [Design] ORDER BY [Design].[WO#] DESC;
--SELECT REPLACE(LTRIM(REPLACE([Job], '0', ' ')), ' ', '0'), [StockCode], * FROM [SysproCompanyS].[dbo].[WipMaster] ORDER BY [SysproCompanyS].[dbo].[WipMaster].[Job] DESC;


--SELECT * FROM [SysproCompanyS].[dbo].[WipJobAllMat] ORDER BY [StockCode] DESC


select [SysproCompanyS].[dbo].[WipMaster].[StockCode] AS [A], * from Orders with (nolock)
left outer join SysproCompanyS.dbo.WipMaster with (nolock) on 'WO' + left([Serial Number], 4) collate Latin1_General_BIN = WipMaster.StockCode
where DealerID = 406

select [SysproCompanyS].[dbo].[WipMaster].[StockCode] AS [A], * from Orders with (nolock)
left outer join SysproCompanyS.dbo.WipMaster with (nolock) on 'WO' + left([Customer WO#], 4) collate Latin1_General_BIN = WipMaster.StockCode
where DealerID = 406