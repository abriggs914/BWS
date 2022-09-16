USE BWSdb
GO


-- 2022-09-16
-- copy the US prices from Stargate models:
-- Walking Floor 2X -> Tipper 2X
-- Walking Floor 3X -> Tipper 3X
-- Walking Floor 4X -> Tipper 4X
-- Can match the descriptions. Shelley has already input this data.


DECLARE @mn1 AS NVARCHAR(MAX) = 'Walking Floor 2X';
DECLARE @mn2 AS NVARCHAR(MAX) = 'Walking Floor 3X';
DECLARE @mn3 AS NVARCHAR(MAX) = 'Walking Floor 4X';
DECLARE @mn4 AS NVARCHAR(MAX) = 'Tipper  2X';
DECLARE @mn5 AS NVARCHAR(MAX) = 'Tipper  3X';
DECLARE @mn6 AS NVARCHAR(MAX) = 'Tipper  4X';

SELECT
	*
FROM
	[ProductsV2]
WHERE
	[Model No] LIKE @mn1
	OR [Model No] LIKE @mn2
	OR [Model No] LIKE @mn3
	OR [Model No] LIKE @mn4
	OR [Model No] LIKE @mn5
	OR [Model No] LIKE @mn6
	
--SELECT * FROM [OptionsV2] WHERE [Model No] LIKE @mn1
--SELECT * FROM [OptionsV2] WHERE [Model No] LIKE @mn4



BEGIN TRAN;


	SELECT
		[A].[Model No]
		, [A].[Option No] AS [A Opt No]
		, [B].[Option No] AS [B Opt No]
		, [A].[US Price] AS [A US Price]
		, [B].[US Price] AS [B US Price]
	FROM
		[OptionsV2] AS [A]
	INNER JOIN
		[OptionsV2] AS [B]
	ON
		[A].[Description] = [B].[Description]
	WHERE
		[A].[Model No] LIKE @mn1
		AND [B].[Model No] LIKE @mn4
	;


	UPDATE
		[B]
	SET
		[US Price] = [A].[US Price]
	FROM
		[OptionsV2] AS [A]
	INNER JOIN
		[OptionsV2] AS [B]
	ON
		[A].[Description] = [B].[Description]
	WHERE
		[A].[Model No] LIKE @mn1
		AND [B].[Model No] LIKE @mn4
	

	SELECT
		[A].[Model No]
		, [A].[Option No] AS [A Opt No]
		, [B].[Option No] AS [B Opt No]
		, [A].[US Price] AS [A US Price]
		, [B].[US Price] AS [B US Price]
	FROM
		[OptionsV2] AS [A]
	INNER JOIN
		[OptionsV2] AS [B]
	ON
		[A].[Description] = [B].[Description]
	WHERE
		[A].[Model No] LIKE @mn1
		AND [B].[Model No] LIKE @mn4
	;

	----------------------------------------------------

	


	SELECT
		[A].[Model No]
		, [A].[Option No] AS [A Opt No]
		, [B].[Option No] AS [B Opt No]
		, [A].[US Price] AS [A US Price]
		, [B].[US Price] AS [B US Price]
	FROM
		[OptionsV2] AS [A]
	INNER JOIN
		[OptionsV2] AS [B]
	ON
		[A].[Description] = [B].[Description]
	WHERE
		[A].[Model No] LIKE @mn2
		AND [B].[Model No] LIKE @mn5
	;


	UPDATE
		[B]
	SET
		[US Price] = [A].[US Price]
	FROM
		[OptionsV2] AS [A]
	INNER JOIN
		[OptionsV2] AS [B]
	ON
		[A].[Description] = [B].[Description]
	WHERE
		[A].[Model No] LIKE @mn2
		AND [B].[Model No] LIKE @mn5
	

	SELECT
		[A].[Model No]
		, [A].[Option No] AS [A Opt No]
		, [B].[Option No] AS [B Opt No]
		, [A].[US Price] AS [A US Price]
		, [B].[US Price] AS [B US Price]
	FROM
		[OptionsV2] AS [A]
	INNER JOIN
		[OptionsV2] AS [B]
	ON
		[A].[Description] = [B].[Description]
	WHERE
		[A].[Model No] LIKE @mn2
		AND [B].[Model No] LIKE @mn5
	;

	---------------------------------------------------

	


	SELECT
		[A].[Model No]
		, [A].[Option No] AS [A Opt No]
		, [B].[Option No] AS [B Opt No]
		, [A].[US Price] AS [A US Price]
		, [B].[US Price] AS [B US Price]
	FROM
		[OptionsV2] AS [A]
	INNER JOIN
		[OptionsV2] AS [B]
	ON
		[A].[Description] = [B].[Description]
	WHERE
		[A].[Model No] LIKE @mn3
		AND [B].[Model No] LIKE @mn6
	;


	UPDATE
		[B]
	SET
		[US Price] = [A].[US Price]
	FROM
		[OptionsV2] AS [A]
	INNER JOIN
		[OptionsV2] AS [B]
	ON
		[A].[Description] = [B].[Description]
	WHERE
		[A].[Model No] LIKE @mn3
		AND [B].[Model No] LIKE @mn6
	

	SELECT
		[A].[Model No]
		, [A].[Option No] AS [A Opt No]
		, [B].[Option No] AS [B Opt No]
		, [A].[US Price] AS [A US Price]
		, [B].[US Price] AS [B US Price]
	FROM
		[OptionsV2] AS [A]
	INNER JOIN
		[OptionsV2] AS [B]
	ON
		[A].[Description] = [B].[Description]
	WHERE
		[A].[Model No] LIKE @mn3
		AND [B].[Model No] LIKE @mn6
	;

ROLLBACK;
COMMIT;