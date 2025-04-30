SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-04-30
-- MeetingID=16


BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-04-30 14:30'
WHERE
	[Quote#] IN (
	31275,
	31362,
	31413,
	31414,
	31416,
	31419
)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
	(31275, 16, '2025-04-30 14:30', 'Avery Briggs'),
	(31362, 16, '2025-04-30 14:31', 'Avery Briggs'),
	(31413, 16, '2025-04-30 14:32', 'Avery Briggs'),
	(31414, 16, '2025-04-30 14:33', 'Avery Briggs'),
	(31416, 16, '2025-04-30 14:34', 'Avery Briggs'),
	(31419, 16, '2025-04-30 14:35', 'Avery Briggs')
	

ROLLBACK;
COMMIT;
