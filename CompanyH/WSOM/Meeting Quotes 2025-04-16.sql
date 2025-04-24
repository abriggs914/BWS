SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]

-- Meeting Quotes 2025-04-16
-- MeetingID=14


BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1,
	[WO Review Date] = '2025-04-16 14:30'
WHERE
	[Quote#] IN (
	31265,
	31351,
	31360,
	31364,
	31367,
	31370,
	31372,
	31374,
	31375,
	31377,

	31110,
	31280,
	31281,
	31282,
	31283,
	31284,
	31285,
	31286,
	31287,
	31288,
	31289,
	31290,
	31291,
	31292,
	31293,
	31294,
	31295,
	31296,
	31297,
	31298,
	31299,
	31300
)
;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([Quote], [MeetingID], [DateResolved], [ResolvedBy]) VALUES
	(31265, 14, '2025-04-16 14:30', 'Avery Briggs'),
	(31351, 14, '2025-04-16 14:31', 'Avery Briggs'),
	(31360, 14, '2025-04-16 14:32', 'Avery Briggs'),
	(31364, 14, '2025-04-16 14:33', 'Avery Briggs'),
	(31367, 14, '2025-04-16 14:34', 'Avery Briggs'),
	(31370, 14, '2025-04-16 14:35', 'Avery Briggs'),
	(31372, 14, '2025-04-16 14:36', 'Avery Briggs'),
	(31374, 14, '2025-04-16 14:37', 'Avery Briggs'),
	(31375, 14, '2025-04-16 14:38', 'Avery Briggs'),
	(31377, 14, '2025-04-16 14:39', 'Avery Briggs'),

	(31110, 14, '2025-04-16 14:40', 'Avery Briggs'),
	(31280, 14, '2025-04-16 14:41', 'Avery Briggs'),
	(31281, 14, '2025-04-16 14:42', 'Avery Briggs'),
	(31282, 14, '2025-04-16 14:43', 'Avery Briggs'),
	(31283, 14, '2025-04-16 14:44', 'Avery Briggs'),
	(31284, 14, '2025-04-16 14:45', 'Avery Briggs'),
	(31285, 14, '2025-04-16 14:46', 'Avery Briggs'),
	(31286, 14, '2025-04-16 14:47', 'Avery Briggs'),
	(31287, 14, '2025-04-16 14:48', 'Avery Briggs'),
	(31288, 14, '2025-04-16 14:49', 'Avery Briggs'),
	(31289, 14, '2025-04-16 14:50', 'Avery Briggs'),
	(31290, 14, '2025-04-16 14:51', 'Avery Briggs'),
	(31291, 14, '2025-04-16 14:52', 'Avery Briggs'),
	(31292, 14, '2025-04-16 14:53', 'Avery Briggs'),
	(31293, 14, '2025-04-16 14:54', 'Avery Briggs'),
	(31294, 14, '2025-04-16 14:55', 'Avery Briggs'),
	(31295, 14, '2025-04-16 14:56', 'Avery Briggs'),
	(31296, 14, '2025-04-16 14:57', 'Avery Briggs'),
	(31297, 14, '2025-04-16 14:58', 'Avery Briggs'),
	(31298, 14, '2025-04-16 14:59', 'Avery Briggs'),
	(31299, 14, '2025-04-16 15:00', 'Avery Briggs'),
	(31300, 14, '2025-04-16 15:01', 'Avery Briggs')
	

ROLLBACK;
COMMIT;
