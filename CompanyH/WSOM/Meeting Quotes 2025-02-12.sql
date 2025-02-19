
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]
SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]


-- Meeting Quotes
-- 2025-02-12
-- From MeetingID=5
-- Ran 2025-02-18 1355


BEGIN TRAN;


DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [Q] INT, [Iss] NVARCHAR(MAX), [DateResolved] DATETIME, [ResolvedBy] NVARCHAR(MAX))
INSERT INTO @t ([Q], [Iss], [DateResolved], [ResolvedBy]) VALUES
(31140, NULL, '2025-02-12 14:31', 'Avery Briggs'),
(31121, NULL, '2025-02-12 14:32', 'Avery Briggs'),

(31113, NULL, '2025-02-12 14:32', 'Avery Briggs'),
(31112, NULL, '2025-02-12 14:33', 'Avery Briggs'),
(31170, NULL, '2025-02-12 14:34', 'Avery Briggs'),
(31153, NULL, '2025-02-12 14:35', 'Avery Briggs'),
(31158, NULL, '2025-02-12 14:36', 'Avery Briggs'),
(31159, NULL, '2025-02-12 14:37', 'Avery Briggs'),


(30814, 'Rub rail on the wrong line ''load securement'' not step  - First Galv of this unit -- more time for drawing -- needs ramp brackets', NULL, NULL),
(31048, '2x hours', NULL, NULL),
(31142, '2x part of the ramp option', NULL, NULL),
(30844, 'GNK ramps necessary? - what part # for brake stroke indicators', NULL, NULL),
(30842, 'GNK ramps necessary? - what part # for brake stroke indicators', NULL, NULL),
(31161, 'Stargate Unit @ BWS cant hava a tarp if @ BWS', NULL, NULL),
(31152, '4s2m needs to be on 2 axles not 1', NULL, NULL)


SELECT * FROM @t


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
	5,
	[Q],
	[Iss],
	[DateResolved],
	[ResolvedBy]
FROM
	@t
;

ROLLBACK;
COMMIT;


BEGIN TRAN;

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	[Quote#] IN (
		31140,
		31121,
		31113,
		31112,
		31170,
		31153,
		31158,
		31159
)

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[WO Reviewed] = 1
	, [WO Review Date] = '2025-02-12 14:30'
WHERE
	[Quote#] IN (
		31140,
		31121,
		31113,
		31112,
		31170,
		31153,
		31158,
		31159
)


SELECT
	*
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	[Quote#] IN (
		31140,
		31121,
		31113,
		31112,
		31170,
		31153,
		31158,
		31159
)

ROLLBACK;
COMMIT;