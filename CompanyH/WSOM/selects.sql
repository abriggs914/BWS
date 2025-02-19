SELECT
	*
FROM
	[BWSdb].[dbo].[WSOM_Meetings]
SELECT
	*
FROM
	[BWSdb].[dbo].[hist_WSOM_Meetings]

SELECT
	*
FROM
	[BWSdb].[dbo].[WSOM_MeetingNotes]


SELECT
	*
FROM
	[BWSdb].[dbo].[ITD Project Directory]



SELECT
	[M].[ID]
	, [M].[DateMeeting]
	, [N].[ID]
	, [N].[Quote]
	, [N].[IssueDescription]
	, [N].[ResolvedBy]
	, [N].[DateResolved]
	, [N].[ResolutionDetails]
FROM
	[BWSdb].[dbo].[WSOM_Meetings] [M]
INNER JOIN
	[BWSdb].[dbo].[WSOM_MeetingNotes] [N]
ON
	[M].[ID] = [N].[MeetingID]
WHERE
	[MeetingID] <= 3
	AND ISNULL([DateResolved], '') = ''
	/*
	([MeetingID] = 3)
	OR (
		[MeetingID] < 3
		AND ISNULL([DateResolved], '') = ''
	)
	*/



SELECT
	*
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	([Quote Date] >= '2025-01-30')
	OR([Order Date] >= '2025-01-30')




DECLARE @m_id INT = 4
DECLARE @sd DATETIME;
DECLARE @ed DATETIME;
SELECT
	@sd = DATEADD(SECOND, -1, [BWSdb].[dbo].[Datify](YEAR([M].[DateMeeting]), MONTH([M].[DateMeeting]), DAY([M].[DateMeeting]), DEFAULT, DEFAULT, DEFAULT))
FROM
	[BWSdb].[dbo].[WSOM_Meetings] [M]
;
SELECT
	@ed = DATEADD(HOUR, 23, DATEADD(MINUTE, 59, DATEADD(SECOND, 62, DATEADD(DAY, 185, @sd))))
;
SELECT
	@m_id [MID]
	,@sd [SD]
	,@ed [ED]

SELECT 
	[Production].[Prod Date],
	[Orders].[Quote#],
	[Orders].[wo#],
	[Orders].[model No],
	[D].[COMPANY NAME],
	[Orders].[width],
	[Orders].[spread],
	[Sales Staff].[Sales Person],
	[Orders].[slot#],
	Orders.[WO Reviewed],
	[WSOM_Src].[MeetingID],
	[WSOM_Src].[DateMeeting],
	[WSOM_Src].[IssueDescription]
FROM (
		[BWSdb].[dbo].[Orders] 
	INNER JOIN
		[BWSdb].[dbo].[Production]
	ON
		[Orders].[Quote#] = [Production].[Quote#]
) 
INNER JOIN
	[BWSdb].[dbo].[Sales Staff]
ON 
	[Orders].[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
FULL OUTER JOIN (
	SELECT
		[M].[ID] AS [MeetingID]
		, [M].[DateMeeting]
		, [N].[ID] AS [MeetingNotesID]
		, [N].[Quote]
		, [N].[IssueDescription]
		, [N].[ResolvedBy]
		, [N].[DateResolved]
		, [N].[ResolutionDetails]
	FROM
		[BWSdb].[dbo].[WSOM_Meetings] [M]
	INNER JOIN
		[BWSdb].[dbo].[WSOM_MeetingNotes] [N]
	ON
		[M].[ID] = [N].[MeetingID]
	WHERE
		[MeetingID] <= @m_id
		AND ISNULL([DateResolved], '') = ''
) AS [WSOM_Src]
ON
	[Orders].[Quote#] = [WSOM_Src].[Quote]
LEFT JOIN
	[BWSdb].[dbo].[Dealers] [D]
ON
	[Orders].[DealerID] = [D].[ID]
WHERE (
	ISNULL([Orders].[WO Reviewed], 0) = 0)
	AND ([Production].[Prod Date] BETWEEN @sd AND @ed)
ORDER BY
	(CASE WHEN [WSOM_Src].[MeetingID] IS NULL THEN 1 ELSE 0 END)
	,[WSOM_Src].[MeetingID]
	,[Prod Date]
	,[Model No]
	,[Quote#]
;


SELECT
	[BWSdb].[dbo].[Datify](2025, 2, 5, DEFAULT, DEFAULT, DEFAULT)



SELECT
	*
	, DATEADD(SECOND, -1, [BWSdb].[dbo].[Datify](YEAR([M].[DateMeeting]), MONTH([M].[DateMeeting]), DAY([M].[DateMeeting]), DEFAULT, DEFAULT, DEFAULT))
	, DATEADD(HOUR, 23, DATEADD(MINUTE, 59, DATEADD(SECOND, 62, DATEADD(DAY, 185, 
		DATEADD(SECOND, -1, [BWSdb].[dbo].[Datify](YEAR([M].[DateMeeting]), MONTH([M].[DateMeeting]), DAY([M].[DateMeeting]), DEFAULT, DEFAULT, DEFAULT))
	))))
FROM
	[BWSdb].[dbo].[WSOM_Meetings] [M]