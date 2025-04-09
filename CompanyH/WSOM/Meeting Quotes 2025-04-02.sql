SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-04-02
-- MeetingID=12

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-04-02 14:30'
WHERE
	[Quote#] IN (
	31245,
	31328,
	31329,
	31332,
	31333,
	31336,
	31338,
	31339
)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
	(31245, 12, '2025-04-02 14:30', 'Avery Briggs'),
	(31328, 12, '2025-04-02 14:31', 'Avery Briggs'),
	(31329, 12, '2025-04-02 14:32', 'Avery Briggs'),
	(31332, 12, '2025-04-02 14:33', 'Avery Briggs'),
	(31333, 12, '2025-04-02 14:34', 'Avery Briggs'),
	(31336, 12, '2025-04-02 14:35', 'Avery Briggs'),
	(31338, 12, '2025-04-02 14:36', 'Avery Briggs'),
	(31339, 12, '2025-04-02 14:37', 'Avery Briggs')
;

ROLLBACK;
COMMIT;
*/