


/*
BEGIN TRAN;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([MeetingID], [Quote], [ResolvedBy], [DateResolved]) VALUES
(8, 31210, 'Avery Briggs', '2025-03-05 14:30'),
(8, 31211, 'Avery Briggs', '2025-03-05 14:31'),
(8, 31212, 'Avery Briggs', '2025-03-05 14:32')

ROLLBACK;
COMMIT;
*/


-- Meeting Quotes 2025-03-05
--


/*
BEGIN TRAN;


	

SELECT
	[WO Review Date]
	,[WO Reviewed]
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	[O].[Quote#] IN (
	
31210,
31211,
31212
	)
;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Review Date] = '2025-03-05 14:30'
	,[WO Reviewed] = 1
WHERE
	[Quote#] IN (
	
		31210,
		31211,
		31212
	)
;

SELECT
	[WO Review Date]
	,[WO Reviewed]
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	[O].[Quote#] IN (
	
31210,
31211,
31212
	)

ROLLBACK;
COMMIT;
*/