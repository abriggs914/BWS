USE SysproCompanyA
GO

-- Version 2023-06-21 12PM



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
	[WipJobAllLab].[WorkCentre]
	, [WorkCentreDesc]
	, ROW_NUMBER() OVER(
		PARTITION BY
			[Group]
		ORDER BY 
			[WorkCentreDesc]
	) AS [RowIdx]
	, MIN([Group]) AS [MinGroup]
	, SUM([WipJobAllLab].[RunTimeIssued]) AS [SRunTime]
--	, *
FROM
	[WipJobAllLab]
INNER JOIN
	[WipLabJnl]
ON
	[WipJobAllLab].[Job] = [WipLabJnl].[Job]
INNER JOIN
	@t
ON
	UPPER([WipJobAllLab].[WorkCentreDesc]) = UPPER([@t].[Dept])
WHERE
	[EntryDate] BETWEEN @sd AND @ed
GROUP BY
	[WipJobAllLab].[WorkCentre]
	, [WorkCentreDesc]
	, [Group]


--SELECT TOP 100
--	[WorkCentre]
--	, [WorkCentreDesc]
--	, *
--FROM
--	[WipJobAllLab]
--WHERE
--	[Job] BETWEEN ''
--;

SELECT DISTINCT
	[WorkCentre]
	, [WorkCentreDesc]
	, [Group]
--	, *
FROM
	[WipJobAllLab]
INNER JOIN
	@t
ON
	UPPER([WipJobAllLab].[WorkCentreDesc]) = UPPER([@t].[Dept])
ORDER BY
	[WorkCentreDesc]
;

SELECT
	[WorkCentre]
	, [WorkCentreDesc]
	, [RowIdx]
	, [MinGroup]
	, [SRunTime]
FROM (
	SELECT
		[WipJobAllLab].[WorkCentre]
		, [WorkCentreDesc]
		, ROW_NUMBER() OVER(
			PARTITION BY
				[Group]
			ORDER BY 
				[WorkCentreDesc]
		) AS [RowIdx]
		, MIN([Group]) AS [MinGroup]
		, SUM([WipJobAllLab].[RunTimeIssued]) AS [SRunTime]
	--	, *
	FROM
		[WipJobAllLab]
	INNER JOIN
		[WipLabJnl]
	ON
		[WipJobAllLab].[Job] = [WipLabJnl].[Job]
	INNER JOIN
		@t
	ON
		UPPER([WipJobAllLab].[WorkCentreDesc]) = UPPER([@t].[Dept])
	WHERE
		[EntryDate] BETWEEN @sd AND @ed
	GROUP BY
		[WipJobAllLab].[WorkCentre]
		, [WorkCentreDesc]
		, [Group]
) AS [A]
WHERE
	[RowIdx] = 1
GROUP BY
	[WorkCentre]
	, [WorkCentreDesc]
	, [RowIdx]
	, [MinGroup]
	, [SRunTime]
ORDER BY
	[WorkCentreDesc]


--SELECT TOP 100
--	*
--FROM
--	[WipLabJnl]
