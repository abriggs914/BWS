USE BWSdb
GO

-- Group 4 [Budget Std] (3X) LEAD

BEGIN TRAN;


DECLARE @modelCopyFrom AS NVARCHAR(MAX) = 'BTL3XSS PACE';
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
	[Budget Std V2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[Budget Std V2]
WHERE
	[Budget Std V2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[Budget Std V2]
	WHERE
		[Model No] = @modelCopyFrom
)

WHILE @i < @c BEGIN

	INSERT INTO
		[Budget Std V2]
	(
		[Model No]
           ,[Top Level Part# (SYSPRO)]
           ,[Std Date]
           ,[COGS]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Machine Shop]
           ,[Axles]
           ,[Stakes/Bunks]
           ,[Beam]
           ,[GNK]
           ,[Parts]
           ,[Subs]
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
           ,[Margins Base]
           ,[Margins Options]
           ,[Top Level Part# (SYSPRO 8)]
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
		
		[MTC].[Model No]
		,NULL
           ,GETDATE()
           ,[COGS]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Machine Shop]
           ,[Axles]
           ,[Stakes/Bunks]
           ,[Beam]
           ,[GNK]
           ,[Parts]
           ,[Subs]
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
           ,[Margins Base]
           ,[Margins Options]
           ,[Top Level Part# (SYSPRO 8)]
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
		[Budget Std V2]
	CROSS JOIN
		@modelsToCopy AS [MTC]
	WHERE
		[MTC].[ID] = @i
		AND [Budget Std V2].[Model No] = @modelCopyFrom
		

	SELECT @i = @i + 1;
END

SELECT
	'After' AS [T],
	[Budget Std V2].*
FROM
	@modelsToCopy AS [MTC]
CROSS JOIN
	[Budget Std V2]
WHERE
	[Budget Std V2].[Model No] = [MTC].[Model No]
	--OR [IDTrailer] = @modelID
UNION ALL (
	SELECT
		'B' AS [T],
		*
	FROM
		[Budget Std V2]
	WHERE
		[Model No] = @modelCopyFrom
)
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