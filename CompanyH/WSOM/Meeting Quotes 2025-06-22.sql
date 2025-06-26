


SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-06-22
-- MeetingID=22


BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-06-22 14:30'
WHERE
	[Quote#] IN (
	31557,
	31568,
	31558,
	31570,
	31545,
	31487,
	31550,
	31452,
	30846,
	31549,
	31465,
	31433,
	31434,
	31326,
	31308,
	31468,
	31435,

	-- did not pass
	31343,
	31484
)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
	(31557, 22, '2025-06-22 14:30', 'Avery Briggs'),
	(31568, 22, '2025-06-22 14:31', 'Avery Briggs'),
	(31558, 22, '2025-06-22 14:32', 'Avery Briggs'),
	(31570, 22, '2025-06-22 14:33', 'Avery Briggs'),
	(31545, 22, '2025-06-22 14:34', 'Avery Briggs'),
	(31487, 22, '2025-06-22 14:35', 'Avery Briggs'),
	(31550, 22, '2025-06-22 14:36', 'Avery Briggs'),
	(31452, 22, '2025-06-22 14:37', 'Avery Briggs'),
	(30846, 22, '2025-06-22 14:38', 'Avery Briggs'),
	(31549, 22, '2025-06-22 14:39', 'Avery Briggs'),
	(31465, 22, '2025-06-22 14:40', 'Avery Briggs'),
	(31433, 22, '2025-06-22 14:41', 'Avery Briggs'),
	(31434, 22, '2025-06-22 14:42', 'Avery Briggs'),
	(31326, 22, '2025-06-22 14:43', 'Avery Briggs'),
	(31308, 22, '2025-06-22 14:44', 'Avery Briggs'),
	(31468, 22, '2025-06-22 14:45', 'Avery Briggs'),
	(31435, 22, '2025-06-22 14:46', 'Avery Briggs'),
	
	(31343, 22, '2025-06-22 14:47', 'Avery Briggs'),
	(31484, 22, '2025-06-22 14:48', 'Avery Briggs')
	

ROLLBACK;
COMMIT;
