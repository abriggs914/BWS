USE SysproCompanyA
GO

-- Version 2023-06-21 2PM



DECLARE @sd AS DATETIME = '2022-06-01';
DECLARE @ed AS DATETIME = '2023-06-01 23:59:59';
DECLARE @t AS TABLE([ID] INT IDENTITY(0 , 1), [Group] INT, [Dept] NVARCHAR(100));
INSERT INTO @t ([Group], [Dept]) VALUES
(0, 'AXLE & SUSPENSION'),
(1, 'BEAM ASSEMBLY'),
(2, 'Finish Shop'),
(3, 'Machine Shop'),
(4, 'Paint & Blast'),
(5, 'SUB ASSEMBLY'),
(6, 'trailer assembly')
;

SELECT
	[WipJobPost].[LWorkCentre]
	, [LWorkCentreDesc]
	, ROW_NUMBER() OVER(
		PARTITION BY
			[Group]
		ORDER BY 
			[LWorkCentreDesc]
	) AS [RowIdx]
	, MIN([Group]) AS [MinGroup]
	, SUM([WipJobPost].[LRunTimeHours]) AS [SRunTime]
--	, *
--FROM
	--[WipJobAllLab]
FROM
	[WipJobPost]
INNER JOIN
	[WipLabJnl]
ON
	[WipJobPost].[Job] = [WipLabJnl].[Job]
INNER JOIN
	@t
ON
	UPPER([WipJobPost].[LWorkCentreDesc]) LIKE '%' + UPPER([@t].[Dept]) + '%'
WHERE
	[EntryDate] BETWEEN @sd AND @ed
GROUP BY
	[WipJobPost].[LWorkCentre]
	, [LWorkCentreDesc]
	, [Group]
