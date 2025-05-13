SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-05-07
-- MeetingID=17


BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-05-07 14:30'
WHERE
	[Quote#] IN (
	31313,
	31445,
	31183,
	31420,
	31426,
	31427,
	31428,
	31418,
	31424,
	31430
)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
	(31313, 17, '2025-05-07 14:30', 'Avery Briggs'),
	(31445, 17, '2025-05-07 14:30', 'Avery Briggs'),
	(31183, 17, '2025-05-07 14:30', 'Avery Briggs'),
	(31420, 17, '2025-05-07 14:30', 'Avery Briggs'),
	(31426, 17, '2025-05-07 14:30', 'Avery Briggs'),
	(31427, 17, '2025-05-07 14:30', 'Avery Briggs'),
	(31428, 17, '2025-05-07 14:30', 'Avery Briggs'),
	(31418, 17, '2025-05-07 14:30', 'Avery Briggs'),
	(31424, 17, '2025-05-07 14:30', 'Avery Briggs'),
	(31430, 17, '2025-05-07 14:30', 'Avery Briggs')
	

ROLLBACK;
COMMIT;
