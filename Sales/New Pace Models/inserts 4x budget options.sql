USE BWSdb
GO

-- Group 1 (4X) [Budget Options V2]

BEGIN TRAN;

DECLARE @modelCopyFrom AS NVARCHAR(MAX) = 'B-Train Lead  - 4X - S.S. Pace';
DECLARE @modelID AS INT;
SELECT @modelID = [IDTrailer] FROM [ProductsV2] WHERE [Model No] = @modelCopyFrom;

--SELECT @modelCopyFrom AS [MC]

DECLARE @class AS NVARCHAR(MAX);
SELECT @class = [Class] FROM [Products_Classes] WHERE [Class] = 'Pace'; 

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
	[Budget Options V2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[Budget Options V2]
WHERE
	[Budget Options V2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[Budget Options V2]
	WHERE
		[Model No] = @modelCopyFrom
)
ORDER BY
	[SortSe]
;

WHILE @i < @c BEGIN

	INSERT INTO
		[Budget Options V2]
	(
		[Bud_Date_Opt]
           ,[Model No]
           ,[Option No]
           ,[Description]
           ,[Cost]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Machine Shop]
           ,[Steel Kit]
           ,[Axles]
           ,[Stakes/Bunks]
           ,[Beam]
           ,[GNK]
           ,[Parts]
           ,[Line]
           ,[Step 1]
           ,[Step 2]
           ,[Blast]
           ,[Paint]
           ,[Finish]
           ,[Finish - GNK]
           ,[Final Assembly]
           ,[Tire Assembly]
           ,[Shipping]
           ,[Sections]
           ,[SortSe]
           ,[Obsolete]
           ,[CompanyID]
           ,[Operation1Hours]
           ,[Operation2Hours]
           ,[Operation3Hours]
           ,[Operation4Hours]
           ,[Operation5Hours]
           ,[Operation6Hours]
           ,[Operation7Hours]
           ,[Operation8Hours]
           ,[Operation9Hours]
           ,[Operation10Hours]
           ,[Operation11Hours]
           ,[Operation12Hours]
           ,[Operation13Hours]
           ,[Operation14Hours]
           ,[Operation15Hours]
           ,[Operation16Hours]
           ,[Operation17Hours]
	)
	SELECT
		GETDATE()
           ,[MTC].[Model No]
		,[MTC].[Model No] + '-' + RIGHT('00000' + CAST(
		ROW_NUMBER() OVER(
			ORDER BY
				[SortSe]
		)
		AS NVARCHAR(MAX)), 5)
           ,[Description]
           ,[Cost]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Machine Shop]
           ,[Steel Kit]
           ,[Axles]
           ,[Stakes/Bunks]
           ,[Beam]
           ,[GNK]
           ,[Parts]
           ,[Line]
           ,[Step 1]
           ,[Step 2]
           ,[Blast]
           ,[Paint]
           ,[Finish]
           ,[Finish - GNK]
           ,[Final Assembly]
           ,[Tire Assembly]
           ,[Shipping]
           ,[Sections]
           ,[SortSe]
           ,[Obsolete]
           ,[CompanyID]
           ,[Operation1Hours]
           ,[Operation2Hours]
           ,[Operation3Hours]
           ,[Operation4Hours]
           ,[Operation5Hours]
           ,[Operation6Hours]
           ,[Operation7Hours]
           ,[Operation8Hours]
           ,[Operation9Hours]
           ,[Operation10Hours]
           ,[Operation11Hours]
           ,[Operation12Hours]
           ,[Operation13Hours]
           ,[Operation14Hours]
           ,[Operation15Hours]
           ,[Operation16Hours]
           ,[Operation17Hours]
	FROM
		[Budget Options V2]
	CROSS JOIN
		@modelsToCopy AS [MTC]
	WHERE
		[MTC].[ID] = @i
		AND [Budget Options V2].[Model No] = @modelCopyFrom
	ORDER BY
		[SortSe]
		

	SELECT @i = @i + 1;
END

SELECT
	'After' AS [T],
	[Budget Options V2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[Budget Options V2]
WHERE
	[Budget Options V2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[Budget Options V2]
	WHERE
		[Model No] = @modelCopyFrom
)
ORDER BY
	[SortSe]
;

ROLLBACK;
COMMIT;


SELECT
	'Options V2_FactoryLines' AS [Table],
	*
FROM
	[Options V2_FactoryLines]
WHERE
	[Model No] = @modelCopyFrom
;
SELECT
	'Options V2_SpecLines' AS [Table],
	*
FROM
	[Options V2_SpecLines]
WHERE
	[Model No] = @modelCopyFrom

;