
EXEC [BWSdb].[dbo].[sp_SerialNumberCalc] @quote=31247, @year=2026, @mode=3
SELECT * FROM [BWSdb].[dbo].[Orders] [O] WHERE [O].[Quote#] = 31247
SELECT * FROM [BWSdb].[dbo].[CompanySNInfo]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]
SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[Products]
SELECT * FROM [SysproCompanyA].[dbo].[InvMaster]


SELECT 
	[Class]
	,[ProductClass]
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	[BWSdb].[dbo].[Products] [P]
ON
	[O].[ProductID] = [P].[IDTrailer]
INNER JOIN
	[SysproCompanyA].[dbo].[WipMaster] [W]
ON
	CAST([O].[WO#] AS NVARCHAR(MAX)) = [W].[Job]
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [I]
ON
	[W].[StockCode] = [I].[StockCode]
GROUP BY
	[Class]
	,[ProductClass]
HAVING 
	COUNT(*) > 1