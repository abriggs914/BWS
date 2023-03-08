USE BWSdb
GO

-- Group 1 Standards (4X) PULL

BEGIN TRAN;


DECLARE @modelCopyFrom AS NVARCHAR(MAX) = 'B-Train Pull - 2X - S.S. Pace';
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
('BTP2XASS PACE', 'BTP2XASS PACE')
;

DECLARE @i AS INT = 0;
DECLARE @j AS INT = 1;
DECLARE @c AS INT;

SELECT @c = COUNT(*) FROM @modelsToCopy;

SELECT
	'Before' AS [T],
	[StandardsV2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[StandardsV2]
WHERE
	[StandardsV2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[StandardsV2]
	WHERE
		[Model No] = @modelCopyFrom
)
ORDER BY
	[SortG],
	[SortSe]
;

WHILE @i < @c BEGIN

	INSERT INTO
		[StandardsV2]
	(
		[Model No]
           ,[Standard No]
           ,[Group]
           ,[Section]
           ,[Description]
           ,[Start Date]
           ,[End Date]
           ,[SortG]
           ,[SortSe]
           ,[Selection]
           ,[SortGv2]
           ,[SortSev2]
           ,[New Spec Wording]
           ,[CompanyID]
	)
	SELECT
		
		[MTC].[Model No]
		,[MTC].[Model No] + '-' + RIGHT('00000' + CAST(
		ROW_NUMBER() OVER(
			ORDER BY
				[SortG],
				[SortSe]
		)
		AS NVARCHAR(MAX)), 5)

           ,[Group]
           ,[Section]
           ,[Description]
           ,[Start Date]
           ,[End Date]
           ,[SortG]
           ,[SortSe]
           ,[Selection]
           ,[SortGv2]
           ,[SortSev2]
           ,[New Spec Wording]
           ,[CompanyID]
	FROM
		[StandardsV2]
	CROSS JOIN
		@modelsToCopy AS [MTC]
	WHERE
		[MTC].[ID] = @i
		AND [StandardsV2].[Model No] = @modelCopyFrom
	ORDER BY
		[SortG],
		[SortSe]
		

	SELECT @i = @i + 1;
END

SELECT
	'After' AS [T],
	[StandardsV2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[StandardsV2]
WHERE
	[StandardsV2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[StandardsV2]
	WHERE
		[Model No] = @modelCopyFrom
)
ORDER BY
	[SortG],
	[SortSe]
;

ROLLBACK;
COMMIT;

--SELECT
--	@modelID = [IDTrailer]
--FROM
--	[ProductsV2]
--WHERE 
--	[Model No] = @modelCopyFrom

	
--SELECT
--	'ProductsV2' AS [Table],
--	*
--FROM
--	[ProductsV2]
--WHERE
--	[IDTrailer] = @modelID
--;
	
SELECT
	'StandardsV2' AS [Table],
	*
FROM
	[StandardsV2]
WHERE
	[Model No] = @modelCopyFrom
;

SELECT
	'OptionsV2' AS [Table],
	*
FROM
	[OptionsV2]
WHERE
	[Model No] = @modelCopyFrom
;
SELECT
	'Budget Options V2' AS [Table],
	*
FROM
	[Budget Options V2]
WHERE
	[Model No] = @modelCopyFrom
;
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