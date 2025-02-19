
-- Meeting Quotes
-- 2025-02-19
-- From MeetingID=6

DECLARE @qs TABLE ([ID] INT IDENTITY(0, 1), [Q] INT)
INSERT INTO @qs ([Q]) VALUES
(31190),
(31196),
(31192),
(31193),
(31197),
(31188),
(31189),
(31195),
(31198),
(31204),
(31194)

/*
BEGIN TRAN;

INSERT INTO
	[BWSdb].[dbo].[WSOM_MeetingNotes]
([Quote], [MeetingID], [DateResolved], [ResolvedBy])
VALUES 
(31190, 6, '2025-02-19 14:30', 'Avery Briggs'),
(31196, 6, '2025-02-19 14:31', 'Avery Briggs'),
(31192, 6, '2025-02-19 14:32', 'Avery Briggs'),
(31193, 6, '2025-02-19 14:33', 'Avery Briggs'),
(31197, 6, '2025-02-19 14:34', 'Avery Briggs'),
(31188, 6, '2025-02-19 14:35', 'Avery Briggs'),
(31189, 6, '2025-02-19 14:36', 'Avery Briggs'),
(31195, 6, '2025-02-19 14:37', 'Avery Briggs'),
(31198, 6, '2025-02-19 14:38', 'Avery Briggs'),
(31204, 6, '2025-02-19 14:39', 'Avery Briggs'),
(31194, 6, '2025-02-19 14:40', 'Avery Briggs')

ROLLBACK;
COMMIT;
*/

DECLARE @lastQ INT;
SELECT TOP 1 [Q] FROM @qs ORDER BY [ID] DESC

SELECT
	[Quote]
	,[MeetingID]
FROM
	[BWSdb].[dbo].[WSOM_MeetingNotes] [MN]
INNER JOIN
	@qs [QS]
ON
	[MN].[Quote] = [QS].[Q]
WHERE
	[DateResolved] IS NULL
GROUP BY
	[Quote]
	,[MeetingID]
ORDER BY
	[Quote]


SELECT @lastQ

SELECT
	[Quote]
	,[MeetingID]
FROM
	[BWSdb].[dbo].[WSOM_MeetingNotes]
ORDER BY
	[Quote]
WHERE
	--([DateResolved] IS NULL)
	--AND (
	[Quote] = @lastQ
	--)
GROUP BY
	[Quote]
	,[MeetingID]
ORDER BY
	[Quote]




SELECT
	[Quote#]
	,[Model No]
	,[WO Review Date]
	,[WO Reviewed]
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	[O].[Quote#] IN (
	31042,
	31048,
	31049,
	31162,
	31163
)

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1
	,[WO Review Date] = '2025-02-05'
WHERE
	[Quote#] IN (
	31042,
	31048,
	31049,
	31162,
	31163	
)

ROLLBACK;
COMMIT;
*/