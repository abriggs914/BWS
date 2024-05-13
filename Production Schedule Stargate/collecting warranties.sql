USE SysproCompanyS
GO


DECLARE @warJobs AS TABLE (
	[ID] INT IDENTITY(0, 1), 
	[Job] NVARCHAR(MAX), 
	[LastVin] NVARCHAR(MAX)
);

INSERT INTO @warJobs ([Job], [LastVin]) VALUES
('3000236', '9747'),
('30000239', '9756'),
('30000210', 'RM000184'),
('30000235', '3202')



SELECT
	'H' AS [H]
	,*
FROM
	[SysproCompanyS].[dbo].[WipMaster] AS [WC]
INNER JOIN
	@warJobs [WAR] 
ON
	--[WIP].[Job] = [WAR].[Job]
	[WC].[Job] = [WAR].[Job] 
	--OR RIGHT([WC].[Serial Number], LEN([WAR].[LastVin])) = [WAR].[LastVin] COLLATE DATABASE_DEFAULT
LEFT JOIN
	[BWSdb].[dbo].[OrdersV2] [O2]
ON
	[WAR].[LastVin] = RIGHT([O2].[Serial Number], 4) COLLATE DATABASE_DEFAULT




SELECT
	'A' AS [A]
	,*
FROM
--	[WipJobAllLab] AS [WIP]
	[BWSdb].[dbo].[OrdersV2] AS [ORD]
INNER JOIN
	@warJobs [WAR] 
ON
	--[WIP].[Job] = [WAR].[Job]
	CAST([ORD].[WO#] AS NVARCHAR(MAX)) = [WAR].[Job] 
	OR RIGHT([ORD].[Serial Number], LEN([WAR].[LastVin])) = [WAR].[LastVin] COLLATE DATABASE_DEFAULT


SELECT
	'B' AS [B]
	,*
FROM
	[Stargatedb].[dbo].[Warranty Claims] AS [WC]
INNER JOIN
	@warJobs [WAR] 
ON
	--[WIP].[Job] = [WAR].[Job]
	CAST([WC].[WO#] AS NVARCHAR(MAX)) = [WAR].[Job] 
	OR RIGHT([WC].[Serial Number], LEN([WAR].[LastVin])) = [WAR].[LastVin] COLLATE DATABASE_DEFAULT


SELECT
	'C' AS [C]
	,*
FROM
	[SysproCompanyS].[dbo].[WipMaster] AS [WC]
INNER JOIN
	@warJobs [WAR] 
ON
	--[WIP].[Job] = [WAR].[Job]
	[WC].[Job] = [WAR].[Job] 
	--OR RIGHT([WC].[Serial Number], LEN([WAR].[LastVin])) = [WAR].[LastVin] COLLATE DATABASE_DEFAULT


	
SELECT
	'D' AS [D]
	,*
FROM
	[Stargatedb].[dbo].[Warranty Claims] AS [WC]

	
SELECT
	'E' AS [E]
	,*
FROM
	[SysproCompanyS].[dbo].[WipMaster] AS [WM]
WHERE
	(LEFT([Job], 1) = '3')
	OR (ISNULL([JobClassification], '') = 'WAR')
ORDER BY
	[Job]
;


SELECT
	'F' AS [F]
	,*
FROM
	[Stargatedb].[dbo].[Warranty Claims] AS [WC]



	
SELECT
	'G' AS [G]
	,[O].[WO#]
	,[O].[Serial Number]
	,*
FROM
	[SysproCompanyS].[dbo].[WipMaster] AS [WM]
FULL JOIN
	[BWSdb].[dbo].[OrdersV2] AS [O]
ON
	RIGHT(ISNULL([WM].[StockDescription], '    '), 4) COLLATE DATABASE_DEFAULT = RIGHT(ISNULL([O].[Serial Number], '    '), 4)
WHERE
	((LEFT([Job], 1) = '3')
	OR (ISNULL([JobClassification], '') = 'WAR'))
	AND ([O].[Serial Number] IS NOT NULL)
ORDER BY
	[WM].[Job]
;