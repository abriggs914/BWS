

-- Approving meeting quotes from 2025-02-19
-- MeetingID = 6

BEGIN TRAN;

SELECT
	[Quote]
	, [WO Reviewed]
	, [WO Review Date]
	, [MN].[ResolutionDetails]
	, [MN].[DateResolved]
	, [MN].[ResolvedBy]
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	[BWSdb].[dbo].[WSOM_MeetingNotes] [MN]
ON
	[O].[Quote#] = [MN].[Quote]
WHERE
	[MN].[MeetingID] = 6
;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Review Date] = '2025-02-19 14:30'
	,[WO Reviewed] = 1
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	[BWSdb].[dbo].[WSOM_MeetingNotes] [MN]
ON
	[O].[Quote#] = [MN].[Quote]
WHERE
	[MN].[MeetingID] = 6
;

SELECT
	[Quote]
	, [WO Reviewed]
	, [WO Review Date]
	, [MN].[ResolutionDetails]
	, [MN].[DateResolved]
	, [MN].[ResolvedBy]
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	[BWSdb].[dbo].[WSOM_MeetingNotes] [MN]
ON
	[O].[Quote#] = [MN].[Quote]
WHERE
	[MN].[MeetingID] = 6


ROLLBACK;
COMMIT;