USE [BWSdb]
GO


DECLARE @prodStartDate AS DATETIME = '2022-02-28';
DECLARE @prodEndDate AS DATETIME;

SET @prodEndDate = '2022-03-02';

IF @prodEndDate IS NULL BEGIN

	SET @prodEndDate = DATEADD(HOUR, 23, DATEADD(MINUTE, 59, DATEADD(SECOND, 59, @prodStartDate)))

END


SELECT
	[Prod Date 1],
	[Prod Date 2],
	[Beam Date],
	[GN Date],
	[Other Date],
	*
FROM
	[BWSdb].[dbo].[dtProductionSchedule] 
WHERE
	[Prod Date 1] BETWEEN @prodStartDate AND @prodEndDate
	OR [Prod Date 2] BETWEEN @prodStartDate AND @prodEndDate
	OR [Beam Date] BETWEEN @prodStartDate AND @prodEndDate
	OR [GN Date] BETWEEN @prodStartDate AND @prodEndDate
	OR [Other Date] BETWEEN @prodStartDate AND @prodEndDate
;

SELECT
	[JobStartDate],
	*
FROM
	[SysproCompanyA].[dbo].[WipMaster]
WHERE
	[JobStartDate] BETWEEN @prodStartDate AND @prodEndDate
;

SELECT
	[PlannedStartDate],
	*
FROM
	[SysproCompanyA].[dbo].[WipJobAllLab]
WHERE
	[PlannedStartDate] BETWEEN @prodStartDate AND @prodEndDate
;

SELECT
	[PlannedStartDate],
	[Job],
	[Operation]
FROM
	[SysproCompanyA].[dbo].[WipJobAllLab]
WHERE
	[PlannedStartDate] BETWEEN @prodStartDate AND @prodEndDate
GROUP BY
	[PlannedStartDate],
	[Job],
	[Operation]
ORDER BY
	[Job],
	[Operation]
;


-- List of all planned jobs starting between startDate and endDate
SELECT
	MIN([PlannedStartDate]) AS [PlannedStartDate],
	[Job]
FROM
	[SysproCompanyA].[dbo].[WipJobAllLab]
WHERE
	[PlannedStartDate] BETWEEN @prodStartDate AND @prodEndDate
GROUP BY
	[Job]
ORDER BY
	[Job]
;
