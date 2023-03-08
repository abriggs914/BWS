USE BWSdb
GO

-- Group 4 (3X) [Options V2_SpecLines]

BEGIN TRAN;

DECLARE @modelCopyFrom AS NVARCHAR(MAX) = 'B-Train Lead  - 4X - S.S. Pace';
DECLARE @modelID AS INT;
SELECT @modelID = [IDTrailer] FROM [ProductsV2] WHERE [Model No] = @modelCopyFrom;

--SELECT @modelCopyFrom AS [MC]

DECLARE @class AS NVARCHAR(MAX);
SELECT @class = 'Pace'; 

SELECT @modelID AS [@modelID], @modelCopyFrom AS [@modelCopyFrom];

DECLARE @modelsToCopy AS TABLE 
(
	[ID] INT IDENTITY(0, 1),
	[Model] NVARCHAR(MAX),
	[Model No] NVARCHAR(MAX)
);

INSERT INTO @modelsToCopy ([Model], [Model No]) VALUES
('BTL4XAA PACE', 'BTL4XAA PACE')
;

DECLARE @i AS INT = 0;
DECLARE @c AS INT;

SELECT @c = COUNT(*) FROM @modelsToCopy;

SELECT
	'Before' AS [T],
	[Options V2_SpecLines].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[Options V2_SpecLines]
WHERE
	[Options V2_SpecLines].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[Options V2_SpecLines]
	WHERE
		[Model No] = @modelCopyFrom
)
ORDER BY
		[SpecSortG]
		, [SpecSortSe]
		, [SpecSortSeLine]
;

WHILE @i < @c BEGIN

	INSERT INTO
		[Options V2_SpecLines]
	(
		[Stock Code (SYSPRO)]
           ,[Model No]
           ,[Line#]
           ,[SpecGroup]
           ,[SpecSortG]
           ,[SpecSection]
           ,[SpecSortSe]
           ,[SpecDescription]
           ,[SpecDescriptionBold]
           ,[SpecDescriptionItalic]
           ,[SpecDescriptionUnderline]
           ,[SpecDescriptionBackColour]
           ,[SpecDescriptionFontColour]
           ,[SpecSortSeLine]
	)
	SELECT

		[Stock Code (SYSPRO)]
           ,[MTC].[Model No]
           ,[Line#]
           ,[SpecGroup]
           ,[SpecSortG]
           ,[SpecSection]
           ,[SpecSortSe]
           ,[SpecDescription]
           ,[SpecDescriptionBold]
           ,[SpecDescriptionItalic]
           ,[SpecDescriptionUnderline]
           ,[SpecDescriptionBackColour]
           ,[SpecDescriptionFontColour]
           ,[SpecSortSeLine]

	FROM
		[Options V2_SpecLines]
	CROSS JOIN
		@modelsToCopy AS [MTC]
	WHERE
		[MTC].[ID] = @i
		AND [Options V2_SpecLines].[Model No] = @modelCopyFrom
	ORDER BY
		[SpecSortG]
		, [SpecSortSe]
		, [SpecSortSeLine]
		

	SELECT @i = @i + 1;
END

SELECT
	'After' AS [T],
	[Options V2_SpecLines].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[Options V2_SpecLines]
WHERE
	[Options V2_SpecLines].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[Options V2_SpecLines]
	WHERE
		[Model No] = @modelCopyFrom
)
ORDER BY
		[SpecSortG]
		, [SpecSortSe]
		, [SpecSortSeLine]
;

ROLLBACK;
COMMIT;
