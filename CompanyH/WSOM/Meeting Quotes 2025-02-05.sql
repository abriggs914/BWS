
SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]
SELECT * FROM [BWSdb].[dbo].[WSOM_MeetingNotes]


-- Meeting Quotes
-- 2025-02-05
-- From MeetingID=4

/*
BEGIN TRAN;


DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [Q] INT, [Iss] NVARCHAR(MAX), [DateResolved] DATETIME, [ResolvedBy] NVARCHAR(MAX))
INSERT INTO @t ([Q], [Iss], [DateResolved], [ResolvedBy]) VALUES
(31042, NULL, '2025-02-05 14:31', 'Avery Briggs'),
(31048, NULL, '2025-02-05 14:32', 'Avery Briggs'),
(31049, NULL, '2025-02-05 14:33', 'Avery Briggs'),

(31140, NULL, '2025-02-05 14:33', 'Avery Briggs'),
(31162, NULL, '2025-02-05 14:33', 'Avery Briggs'),
(31163, NULL, '2025-02-05 14:33', 'Avery Briggs'),

(31054, 'Spelling', NULL, NULL),
(31003, 'Cross fire x2 shoul be x4', NULL, NULL),
(31041, '4', NULL, NULL),
(30854, 'Beams', NULL, NULL),

(31060, '2x hours', NULL, NULL),
(31151, 'type 4s means more than 1 axle', NULL, NULL),
(31152, 'type 4s means more than 1 axle', NULL, NULL),
(31153, 'type 4s means more than 1 axle', NULL, NULL),
(31158, 'type 4s means more than 1 axle', NULL, NULL),
(31159, 'type 4s means more than 1 axle', NULL, NULL),
(31160, 'type 4s means more than 1 axle', NULL, NULL),
(31147, 'remove tarps ''Truck Box'' name is bad', NULL, NULL),
(31148, 'remove tarps ''Truck Box'' name is bad', NULL, NULL),
(31149, 'remove tarps ''Truck Box'' name is bad', NULL, NULL),
(31121, 'Deck Length is wrong, 6ft beavertail is too long, pop-out center', NULL, NULL),
(31119, 'spruce 2in x 8in, 1 control or separate for steer (both act together) (steer axles lift together or separately)', NULL, NULL)

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
	4,
	[Q],
	[Iss],
	[DateResolved],
	[ResolvedBy]
FROM
	@t
;

ROLLBACK;
COMMIT;
*/