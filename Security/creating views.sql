/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [LogID]
      ,[LogDate]
      ,[EventID]
      ,[Log]
      ,[FollowUp]
      ,[FollowUpComplete]
      ,[FollowUpDate]
      ,[ReportedBy]
      ,[Status]
      ,[Comments]
      ,[TimeStamp]
  FROM [BWSdb].[dbo].[SecurityLogV1]

-- event counts by event by year
SELECT
	COUNT([LogID]) AS [# Events]
	,[SecurityLogEventsV1].[Event]
	,YEAR([LogDate]) AS [Year]
FROM
	[BWSdb].[dbo].[SecurityLogV1]
INNER JOIN
	[BWSdb].[dbo].[SecurityLogEventsV1]
ON
	[SecurityLogV1].[EventID] = [SecurityLogEventsV1].[EventID]
GROUP BY
	[SecurityLogEventsV1].[Event]
	,YEAR([LogDate])

-- event counts by event by year by month
SELECT
	COUNT([LogID]) AS [# Events]
	,[SecurityLogEventsV1].[Event]
	,YEAR([LogDate]) AS [Year]
	,MONTH([LogDate]) AS [Month]
FROM
	[BWSdb].[dbo].[SecurityLogV1]
INNER JOIN
	[BWSdb].[dbo].[SecurityLogEventsV1]
ON
	[SecurityLogV1].[EventID] = [SecurityLogEventsV1].[EventID]
GROUP BY
	[SecurityLogEventsV1].[Event]
	,YEAR([LogDate])
	,MONTH([LogDate])

-- event counts by event by month
SELECT
	COUNT([LogID]) AS [# Events]
	,[SecurityLogEventsV1].[Event]
	,MONTH([LogDate]) AS [Month]
FROM
	[BWSdb].[dbo].[SecurityLogV1]
INNER JOIN
	[BWSdb].[dbo].[SecurityLogEventsV1]
ON
	[SecurityLogV1].[EventID] = [SecurityLogEventsV1].[EventID]
GROUP BY
	[SecurityLogEventsV1].[Event]
	,MONTH([LogDate])


-- event counts by year
SELECT
	COUNT([LogID]) AS [# Events]
	,YEAR([LogDate]) AS [Year]
FROM
	[BWSdb].[dbo].[SecurityLogV1]
GROUP BY
	YEAR([LogDate])


-- event counts by month
SELECT
	COUNT([LogID]) AS [# Events]
	,MONTH([LogDate]) AS [Month]
FROM
	[BWSdb].[dbo].[SecurityLogV1]
GROUP BY
	MONTH([LogDate])