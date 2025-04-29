SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-04-23
-- MeetingID=15


BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-04-23 14:30'
WHERE
	[Quote#] IN (
	31274,
	
	31405,
	31406,
	31407,

	31384,
	31387,

	31368,
	31393,
	31394,
	31395,
	31396,

	31388,

	31381,
	31382,
	31383,
	31392,
	31403
)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
	(31274, 15, '2025-04-23 14:30', 'Avery Briggs'),
	(31405, 15, '2025-04-23 14:31', 'Avery Briggs'),
	(31406, 15, '2025-04-23 14:32', 'Avery Briggs'),
	(31407, 15, '2025-04-23 14:33', 'Avery Briggs'),
	(31384, 15, '2025-04-23 14:34', 'Avery Briggs'),
	(31387, 15, '2025-04-23 14:35', 'Avery Briggs'),
	(31368, 15, '2025-04-23 14:36', 'Avery Briggs'),
	(31393, 15, '2025-04-23 14:37', 'Avery Briggs'),
	(31394, 15, '2025-04-23 14:38', 'Avery Briggs'),
	(31395, 15, '2025-04-23 14:39', 'Avery Briggs'),
	(31396, 15, '2025-04-23 14:40', 'Avery Briggs'),
	(31388, 15, '2025-04-23 14:41', 'Avery Briggs'),
	(31381, 15, '2025-04-23 14:42', 'Avery Briggs'),
	(31382, 15, '2025-04-23 14:43', 'Avery Briggs'),
	(31383, 15, '2025-04-23 14:44', 'Avery Briggs'),
	(31392, 15, '2025-04-23 14:45', 'Avery Briggs'),
	(31403, 15, '2025-04-23 14:46', 'Avery Briggs')
	

ROLLBACK;
COMMIT;
