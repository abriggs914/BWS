


SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-06-25
-- MeetingID=23


BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-06-25 14:30'
WHERE
	[Quote#] IN (
	31581,
	31540,
	31582,
	31602,
	31541,
	31603,
	31604,
	31605,
	31534,
	31600,
	31601,
	31562,
	31592,
	31591,
	31588,
	31537,
	31598,
	31599,
	31555,
	31596,
	31597,
	31580,
	31490,
	31495
)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
	(31581, 23, '2025-06-25 14:30', 'Avery Briggs'),
	(31540, 23, '2025-06-25 14:31', 'Avery Briggs'),
	(31582, 23, '2025-06-25 14:32', 'Avery Briggs'),
	(31602, 23, '2025-06-25 14:33', 'Avery Briggs'),
	(31541, 23, '2025-06-25 14:34', 'Avery Briggs'),
	(31603, 23, '2025-06-25 14:35', 'Avery Briggs'),
	(31604, 23, '2025-06-25 14:36', 'Avery Briggs'),
	(31605, 23, '2025-06-25 14:37', 'Avery Briggs'),
	(31534, 23, '2025-06-25 14:38', 'Avery Briggs'),
	(31600, 23, '2025-06-25 14:39', 'Avery Briggs'),
	(31601, 23, '2025-06-25 14:40', 'Avery Briggs'),
	(31562, 23, '2025-06-25 14:41', 'Avery Briggs'),
	(31592, 23, '2025-06-25 14:42', 'Avery Briggs'),
	(31591, 23, '2025-06-25 14:43', 'Avery Briggs'),
	(31588, 23, '2025-06-25 14:44', 'Avery Briggs'),
	(31537, 23, '2025-06-25 14:45', 'Avery Briggs'),
	(31598, 23, '2025-06-25 14:46', 'Avery Briggs'),		  
	(31599, 23, '2025-06-25 14:47', 'Avery Briggs'),
	(31555, 23, '2025-06-25 14:49', 'Avery Briggs'),
	(31596, 23, '2025-06-25 14:50', 'Avery Briggs'),
	(31597, 23, '2025-06-25 14:51', 'Avery Briggs'),
	(31580, 23, '2025-06-25 14:52', 'Avery Briggs'),
	(31490, 23, '2025-06-25 14:53', 'Avery Briggs'),
	(31495, 23, '2025-06-25 14:54', 'Avery Briggs')
ROLLBACK;
COMMIT;