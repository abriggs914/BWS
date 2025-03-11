SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-02-25 14:30'
WHERE
	[Quote#] IN (31166, 31182, 31185)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
(31166, 7, '2025-02-25 14:30', 'Avery Briggs'),
(31182, 7, '2025-02-25 14:31', 'Avery Briggs'),
(31185, 7, '2025-02-25 14:32', 'Avery Briggs')
;

ROLLBACK;
COMMIT;
*/