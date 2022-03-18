USE BWSdb
GO

	SELECT * FROM [ProductsV2] WHERE [Model No] = 'End Dump 2X'
	SELECT * FROM [OptionsV2] WHERE [Model No] = 'End Dump 2X'
	SELECT * FROM [Standards] WHERE [Model No] = 'End Dump 2X'





	
	SELECT * FROM [StandardsV2] WHERE [Model No] = 'End Dump 2X'




	SELECT * FROM [StandardsV2] WHERE [Model No] = 'End Dump 3X'

	DECLARE @T AS TABLE (
		[Model No] NVARCHAR(MAX),
		[Standard No] NVARCHAR(MAX),
		[Group]  NVARCHAR(MAX),
		[Section] NVARCHAR(MAX),
		[Description] NVARCHAR(MAX),
		[StartDate] DATETIME,
		[EndDate] DATETIME,
		[SortG] INT,
		[SortSe] INT,
		[Selection] BIT,
		[SortGv2] INT,
		[SortSev2] INT,
		[New Spec Wording] NVARCHAR(MAX),
		[CompanyID] INT
	)

	INSERT INTO @T
	SELECT 
		'End Dump 2X',
		REPLACE([Standard No], '3X', '2X'),
		[Group],
		[Section],
		[Description],
		[Start Date],
		[End Date],
		[SortG],
		[SortSe],
		[Selection],
		[SortGv2],
		[SortSev2],
		[New Spec Wording],
		[CompanyID]
	FROM
		[StandardsV2] 
	WHERE
		[Model No] = 'End Dump 3X'

	SELECT * FROM @T
