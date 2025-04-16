SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-04-09
-- MeetingID=13


BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-04-09 14:30'
WHERE
	[Quote#] IN (
	31315,
	31361,
	31352,
	31353,
	31354,
	31355,
	31356
)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
	(31315, 13, '2025-04-09 14:30', 'Avery Briggs'),
	(31361, 13, '2025-04-09 14:31', 'Avery Briggs'),
	(31352, 13, '2025-04-09 14:32', 'Avery Briggs'),
	(31353, 13, '2025-04-09 14:33', 'Avery Briggs'),
	(31354, 13, '2025-04-09 14:34', 'Avery Briggs'),
	(31355, 13, '2025-04-09 14:35', 'Avery Briggs'),
	(31356, 13, '2025-04-09 14:36', 'Avery Briggs')

ROLLBACK;
COMMIT;
