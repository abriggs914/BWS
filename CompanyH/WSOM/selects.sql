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
	*
FROM
	[BWSdb].[dbo].[WSOM_Meetings] [M]
INNER JOIN
	[BWSdb].[dbo].[WSOM_MeetingNotes] [N]
ON
	[M].[ID] = [N].[MeetingID]
WHERE
	[MeetingID] = 3



SELECT
	*
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	([Quote Date] >= '2025-01-30')
	OR([Order Date] >= '2025-01-30')