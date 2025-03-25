

SELECT * FROM [WSOM_MeetingNotes]
SELECT * FROM [WSOM_Meetings]


/*
BEGIN TRAN;

INSERT INTO [BWSdb].[dbo].[WSOM_MeetingNotes] ([MeetingID], [Quote], [ResolvedBy], [DateResolved]) VALUES
(9, 31167, 'Avery Briggs', '2025-03-12 14:30'),
(9, 31171, 'Avery Briggs', '2025-03-12 14:31'),
(9, 31207, 'Avery Briggs', '2025-03-12 14:32'),
(9, 31259, 'Avery Briggs', '2025-03-12 14:33'),
(9, 31261, 'Avery Briggs', '2025-03-12 14:34'),
(9, 31262, 'Avery Briggs', '2025-03-12 14:35'),
(9, 31240, 'Avery Briggs', '2025-03-12 14:36'),
(9, 31257, 'Avery Briggs', '2025-03-12 14:37'),
(9, 31174, 'Avery Briggs', '2025-03-19 14:38'),
(9, 31240, 'Avery Briggs', '2025-03-19 14:39'),
(9, 31276, 'Avery Briggs', '2025-03-19 14:40')

ROLLBACK;
COMMIT;
*/


-- Meeting Quotes 2025-03-12
-- MeetingID=9


/*
BEGIN TRAN;


	

SELECT
	[WO Review Date]
	,[WO Reviewed]
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	[O].[Quote#] IN (
		31167,
		31171,
		31207,
		31259,
		31261,
		31262,
		31240,
		31257,
		31174,
		31240,
		31276
	)
;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Review Date] = '2025-03-12 14:30'
	,[WO Reviewed] = 1
WHERE
	[Quote#] IN (
	
		31167,
		31171,
		31207,
		31259,
		31261,
		31262,
		31240,
		31257,
		31174,
		31240,
		31276
	)
;

SELECT
	[WO Review Date]
	,[WO Reviewed]
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	[O].[Quote#] IN (
	
		31167,
		31171,
		31207,
		31259,
		31261,
		31262,
		31240,
		31257,
		31174,
		31240,
		31276
	)

ROLLBACK;
COMMIT;
*/