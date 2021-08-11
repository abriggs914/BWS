USE BWSdb
GO

-- Count # defects by location by employee over a date range.

DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '1900-01-01';
SET @ED = '2021-08-11';

SELECT
	[Location],
	[Name],
	COUNT(*) AS [# Defects],
	SUM([#FrontDefects]) AS [Total Line Front Defects],
	SUM([#RearDefects]) AS [Total Line Rear Defects],
	[#TotalDefects] AS [Total Line Defects]
FROM (
	SELECT
		[SysproCompanyA].[dbo].[BomEmployee].[Name],
		[DefectsSRC].[DefectID#],
		[DefectsSRC].[Input Date],
		[DefectsSRC].[WO#],
		[DefectsSRC].[#FrontDefects],
		[DefectsSRC].[#RearDefects],
		[DefectsSRC].[#Defects],
		[DefectsSRC].[Name] AS [Comment],
		[Defects_Location].[Location],
		[DefectsSRC].[LocationID],
		[DefectsSRC].[CauseID],
		[DefectsSRC].[EmployeeID],
		[DefectsSRC].[#TotalDefects] AS [#TotalDefects]
	FROM (
		SELECT
			[#TotalDefects],
			[Defects].*
		FROM 
			[Defects]
		INNER JOIN (
			SELECT
				[Defects].[LocationID],
				SUM([#Defects]) AS [#TotalDefects]
			FROM
				[Defects]
			WHERE
				[Defects].[Input Date] BETWEEN @SD AND @ED
			GROUP BY
				[Defects].[LocationID]
		) AS [LocationSrc]
		ON
			[LocationSrc].[LocationID] = [Defects].[LocationID]
	) AS [DefectsSRC]
	INNER JOIN
		[SysproCompanyA].[dbo].[BomEmployee]
	ON
		[DefectsSRC].[EmployeeID] = [SysproCompanyA].[dbo].[BomEmployee].[Employee]
	INNER JOIN
		[Defects_Location]
	ON
		[DefectsSRC].[LocationID] = [Defects_Location].[LocationID#]
	WHERE
		[DefectsSRC].[Input Date] BETWEEN @SD AND @ED
	GROUP BY
		[SysproCompanyA].[dbo].[BomEmployee].[Name],
		[DefectsSRC].[DefectID#],
		[DefectsSRC].[Input Date],
		[DefectsSRC].[WO#],
		[DefectsSRC].[#FrontDefects],
		[DefectsSRC].[#RearDefects],
		[DefectsSRC].[#Defects],
		[DefectsSRC].[Name],
		[Defects_Location].[Location],
		[DefectsSRC].[LocationID],
		[DefectsSRC].[CauseID],
		[DefectsSRC].[EmployeeID],
		[DefectsSRC].[#TotalDefects]
) AS [SrcTable]
GROUP BY
	[Location],
	[Name],
	[#TotalDefects]
ORDER BY
	[Location],
	[Name]