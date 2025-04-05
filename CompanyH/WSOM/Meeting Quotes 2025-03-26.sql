SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-03-26
-- MeetingID=11

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-03-26 14:30'
WHERE
	[Quote#] IN (
	31307,
	31260,
	31258,
	31238,
	31224,
	31222,
	31220
)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
	(31307, 11, '2025-03-26 14:30', 'Avery Briggs'),
	(31260, 11, '2025-03-26 14:31', 'Avery Briggs'),
	(31258, 11, '2025-03-26 14:32', 'Avery Briggs'),
	(31238, 11, '2025-03-26 14:33', 'Avery Briggs'),
	(31224, 11, '2025-03-26 14:34', 'Avery Briggs'),
	(31222, 11, '2025-03-26 14:35', 'Avery Briggs'),
	(31220, 11, '2025-03-26 14:36', 'Avery Briggs')
;

ROLLBACK;
COMMIT;
*/