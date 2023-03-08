USE BWSdb
GO

-- Group 4 [Options] (3X) PULL

BEGIN TRAN;

DECLARE @modelCopyFrom AS NVARCHAR(MAX) = 'B-Train PULL 3X - Pace';
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
('87BTP3XAA-EST', 'BTP3XAA PACE'),
('BTP3XAAB PACE', 'BTP3XAAB PACE'),
('BTP3XAAC PACE', 'BTP3XAAC PACE')
;

DECLARE @i AS INT = 0;
DECLARE @c AS INT;

SELECT @c = COUNT(*) FROM @modelsToCopy;

SELECT
	'Before' AS [T],
	[OptionsV2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[OptionsV2]
WHERE
	[OptionsV2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[OptionsV2]
	WHERE
		[Model No] = @modelCopyFrom
)
ORDER BY
	[SortSe]
;

WHILE @i < @c BEGIN

	INSERT INTO
		[OptionsV2]
	(
		[Model No]
           ,[Option No]
           ,[Start Date]
           ,[End Date]
           ,[Price]
           ,[Sections]
           ,[Description]
           ,[Weight]
           ,[Width]
           ,[Deck Length]
           ,[Spread]
           ,[SortSe]
           ,[Draw/Part#]
           ,[Std Hours]
           ,[Obsolete]
           ,[Selection]
           ,[New Option Wording]
           ,[OptionInfo]
           ,[OptionPromptFlag]
           ,[OptionPrompt]
           ,[OptionConfigInfo]
           ,[US Price]
           ,[CompanyID]
	)
	SELECT
		
		[MTC].[Model No]
		,[MTC].[Model No] + '-' + RIGHT('00000' + CAST(
		ROW_NUMBER() OVER(
			ORDER BY
				[SortSe]
		)
		AS NVARCHAR(MAX)), 5)
           ,GETDATE()
           ,DATEADD(YEAR,1, GETDATE())
           ,[Price]
           ,[Sections]
           ,[Description]
           ,[Weight]
           ,[Width]
           ,[Deck Length]
           ,[Spread]
           ,[SortSe]
           ,[Draw/Part#]
           ,[Std Hours]
           ,[Obsolete]
           ,[Selection]
           ,[New Option Wording]
           ,[OptionInfo]
           ,[OptionPromptFlag]
           ,[OptionPrompt]
           ,[OptionConfigInfo]
           ,[US Price]
           ,[CompanyID]
	FROM
		[OptionsV2]
	CROSS JOIN
		@modelsToCopy AS [MTC]
	WHERE
		[MTC].[ID] = @i
		AND [OptionsV2].[Model No] = @modelCopyFrom
	ORDER BY
		[SortSe]
		

	SELECT @i = @i + 1;
END

SELECT
	'After' AS [T],
	[OptionsV2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[OptionsV2]
WHERE
	[OptionsV2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[OptionsV2]
	WHERE
		[Model No] = @modelCopyFrom
)
ORDER BY
	[SortSe]
;

ROLLBACK;
COMMIT;



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