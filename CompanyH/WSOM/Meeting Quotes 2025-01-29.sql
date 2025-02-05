
-- Meeting Quotes
-- 2025-02-04
-- From MeetingID=3

BEGIN TRAN;


DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [Q] INT, [Iss] NVARCHAR(MAX), [DateResolved] DATETIME, [ResolvedBy] NVARCHAR(MAX))
INSERT INTO @t ([Q], [Iss], [DateResolved], [ResolvedBy]) VALUES
(31006, NULL, '2025-01-29 14:31', 'Avery Briggs'),
(31007, NULL, '2025-01-29 14:32', 'Avery Briggs'),
(31008, NULL, '2025-01-29 14:33', 'Avery Briggs'),
(31009, NULL, '2025-01-29 14:34', 'Avery Briggs'),
(31010, NULL, '2025-01-29 14:35', 'Avery Briggs'),
(31012, NULL, '2025-01-29 14:36', 'Avery Briggs'),
(31013, NULL, '2025-01-29 14:37', 'Avery Briggs'),
(31014, NULL, '2025-01-29 14:38', 'Avery Briggs'),
(31015, NULL, '2025-01-29 14:39', 'Avery Briggs'),
(31016, NULL, '2025-01-29 14:40', 'Avery Briggs'),
(31017, NULL, '2025-01-29 14:41', 'Avery Briggs'),
(31018, NULL, '2025-01-29 14:42', 'Avery Briggs'),
(31019, NULL, '2025-01-29 14:43', 'Avery Briggs'),
(31020, NULL, '2025-01-29 14:44', 'Avery Briggs'),
(31021, NULL, '2025-01-29 14:45', 'Avery Briggs'),
(31022, NULL, '2025-01-29 14:46', 'Avery Briggs'),
(31023, NULL, '2025-01-29 14:47', 'Avery Briggs'),
(31024, NULL, '2025-01-29 14:48', 'Avery Briggs'),
(31025, NULL, '2025-01-29 14:49', 'Avery Briggs'),
(31026, NULL, '2025-01-29 14:50', 'Avery Briggs'),
(31027, NULL, '2025-01-29 14:51', 'Avery Briggs'),
(31028, NULL, '2025-01-29 14:52', 'Avery Briggs'),
(31029, NULL, '2025-01-29 14:53', 'Avery Briggs'),
(31030, NULL, '2025-01-29 14:54', 'Avery Briggs'),
(31031, NULL, '2025-01-29 14:55', 'Avery Briggs'),
(31032, NULL, '2025-01-29 14:56', 'Avery Briggs'),
(31033, NULL, '2025-01-29 14:57', 'Avery Briggs'),
(31034, NULL, '2025-01-29 14:58', 'Avery Briggs'),
(31057, NULL, '2025-01-29 14:59', 'Avery Briggs'),
(30772, NULL, '2025-01-29 15:00', 'Avery Briggs'),
(30977, NULL, '2025-01-29 15:01', 'Avery Briggs'),
(31051, NULL, '2025-01-29 15:02', 'Avery Briggs'),
(31052, NULL, '2025-01-29 15:03', 'Avery Briggs'),
(30998, NULL, '2025-01-29 15:04', 'Avery Briggs')

,
(30160, '2x Hours', NULL, NULL),
(30854, 'Question ramp rear drawing? beams too heavy', NULL, NULL),
(31146, 'Question', NULL, NULL),
(31119, 'Axle Spread, what blue?', NULL, NULL)

INSERT INTO
	[BWSdb].[dbo].[WSOM_MeetingNotes]
(
	[MeetingID],
	[Quote],
	[IssueDescription],
	[DateResolved],
	[ResolvedBy]
)
SELECT
	3,
	[Q],
	[Iss],
	[DateResolved],
	[ResolvedBy]
FROM
	@t
;

ROLLBACK;
COMMIT;