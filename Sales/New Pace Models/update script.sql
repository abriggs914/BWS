USE BWSdb
GO


--IF OBJECT_ID('tempdb..#temp_stg_update') IS NOT NULL BEGIN
--	DROP TABLE #temp_stg_update;
--END

--CREATE TABLE #temp_stg_update (
--	[ID] INT IDENTITY(0, 11),
--	[PaceQuote] NVARCHAR(5),
--	[ModelNo] NVARCHAR(MAX),
--	[SGQuote] NVARCHAR(8),
--	[IsSTGQuote] BIT DEFAULT(1),
--	[A] BIT DEFAULT(0),
--	[B] BIT DEFAULT(0),
--	[C] BIT DEFAULT(0),
--	[D] BIT DEFAULT(0),
--	[E] BIT DEFAULT(0),
--	[F] BIT DEFAULT(0),
--	[G] BIT DEFAULT(0),
--	[H] BIT DEFAULT(0)
--);

--INSERT INTO #temp_stg_update ([PaceQuote], [ModelNo], [SGQuote], [IsStgQuote]) VALUES
--('77969', 'End Dump 4X', 'SG101116', 1),
--('77968', 'End Dump 4X', 'SG101115', 1),
--('79612', 'BTL3X', 'SG101122', 1),
--('79613', 'BTL3X+2X', 'SG101123', 1),
--('79490', 'BTL3X', 'SG101125', 1),
--('79500', 'BTL3X+2X', 'SG101126', 1),
--('80299', 'BTL3X', 'SG101127', 1),
--('80300', 'BTL3X+2X', 'SG101128', 1),
--('79242', 'BTL3X', 'SG101133', 1),
--('79243', 'BTL2X+2X', 'SG101134', 1),
--('73720', 'BTL3X', 'SG101129', 1),
--('73721', 'CD2X', '28804', 0),
--('73727', 'BTL3X', 'SG101130', 1),
--('79245', 'BTL3X', 'SG101131', 1),
--('79249', 'CD2X', '28805', 0),
--('79247', 'BTL3X', 'SG101132', 1),
--('81149', 'BTL3X', 'SG101135', 1),
--('81171', 'BTL3X+2X', 'SG101136', 1)
--;


-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- 9 ft hose correction

--BEGIN TRAN;

--	SELECT 'Bef' AS [T], * FROM #temp_stg_update;
--	SELECT
--		*
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecDescription] LIKE '%9 ft%'
--		AND [SpecSortSe] = 370
--	ORDER BY
--		[T].[ID]
--	;

--	UPDATE
--		[Custom WorkV2_SpecLines]
--	SET
--		[SpecDescription] = '9 ft. hose with female quick connect'
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecDescription] LIKE '%9 ft%'
--		AND [SpecSortSe] = 370
--	;

--	UPDATE
--		#temp_stg_update
--	SET
--		[F] = 1
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecDescription] LIKE '%9 ft%'
--		AND [SpecSortSe] = 370
--	;

--	SELECT
--		*
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecDescription] LIKE '%9 ft%'
--		AND [SpecSortSe] = 370
--	ORDER BY
--		[T].[ID]

--	SELECT 'Aft' AS [T], * FROM #temp_stg_update;
--	;

--COMMIT;
--ROLLBACK;

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- pocket lights correction

--BEGIN TRAN;

	--SELECT 'Bef' AS [T], * FROM #temp_stg_update;
	--SELECT
	--	*
	--FROM 
	--	[dbo].#temp_stg_update AS [T]
	--LEFT JOIN
	--	[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
	--ON
	--	[O].[SGQuote] = [T].[SGQuote]
	--	AND [IsSTGQuote] = 1
	--WHERE
	--	[SpecSortG] = 73
	--	AND [SpecSortSe] = 100
	--ORDER BY
	--	[T].[ID]
	--;

	--UPDATE
	--	[Custom WorkV2_SpecLines]
	--SET
	--	[SpecDescription] = RTRIM(LTRIM([SpecDescription])) + ' pocket lights'
	--FROM 
	--	[dbo].#temp_stg_update AS [T]
	--LEFT JOIN
	--	[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
	--ON
	--	[O].[SGQuote] = [T].[SGQuote]
	--	AND [IsSTGQuote] = 1
	--WHERE
	--	[SpecSortG] = 73
	--	AND [SpecSortSe] = 100
	--;

	--UPDATE
	--	#temp_stg_update
	--SET
	--	[G] = 1
	--FROM 
	--	[dbo].#temp_stg_update AS [T]
	--LEFT JOIN
	--	[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
	--ON
	--	[O].[SGQuote] = [T].[SGQuote]
	--	AND [IsSTGQuote] = 1
	--WHERE
	--	[SpecSortG] = 73
	--	AND [SpecSortSe] = 100
	--;

	--SELECT
	--	*
	--FROM 
	--	[dbo].#temp_stg_update AS [T]
	--LEFT JOIN
	--	[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
	--ON
	--	[O].[SGQuote] = [T].[SGQuote]
	--	AND [IsSTGQuote] = 1
	--WHERE
	--	[SpecSortG] = 73
	--	AND [SpecSortSe] = 100
	--ORDER BY
	--	[T].[ID]

	--SELECT 'Aft' AS [T], * FROM #temp_stg_update;
	--;

--COMMIT;
--ROLLBACK;

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- Ride Rims Correction

--BEGIN TRAN;

--	SELECT 'Bef' AS [T], * FROM #temp_stg_update;
--	SELECT
--		*
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecSortG] = 28
--		AND [SpecSortSe] = 150
--		AND [SpecDescription] IS NOT NULL
--	ORDER BY
--		[T].[ID]
--	;

--	UPDATE
--		[Custom WorkV2_SpecLines]
--	SET
--		[SpecDescription] = REPLACE(REPLACE(REPLACE([SpecDescription], 'aluminum polished', 'polished aluminum'), 'aluminum polish', 'polished aluminum'), 'polish', 'high polish')
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecSortG] = 28
--		AND [SpecSortSe] = 150
--		AND [SpecDescription] IS NOT NULL
--	;

--	UPDATE
--		#temp_stg_update
--	SET
--		[D] = 0
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecSortG] = 28
--		AND [SpecSortSe] = 150
--		AND [SpecDescription] IS NOT NULL
--	;

--	SELECT
--		*
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecSortG] = 28
--		AND [SpecSortSe] = 150
--		AND [SpecDescription] IS NOT NULL
--	ORDER BY
--		[T].[ID]

--	SELECT 'Aft' AS [T], * FROM #temp_stg_update;
--	;

--COMMIT;
--ROLLBACK;
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- Steer Rims

--BEGIN TRAN;

--	SELECT 'Bef' AS [T], * FROM #temp_stg_update;
--	SELECT
--		*
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecSortG] = 28
--		AND [SpecSortSe] = 160
--		AND [SpecDescription] IS NOT NULL
--	ORDER BY
--		[T].[ID]
--	;

--	UPDATE
--		[Custom WorkV2_SpecLines]
--	SET
--		[SpecDescription] = REPLACE(REPLACE(REPLACE([SpecDescription], 'aluminum polished', 'polished aluminum'), 'aluminum polish', 'polished aluminum'), 'polish', 'high polish')
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecSortG] = 28
--		AND [SpecSortSe] = 160
--		AND [SpecDescription] IS NOT NULL
--	;

--	UPDATE
--		#temp_stg_update
--	SET
--		[D] = 0
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecSortG] = 28
--		AND [SpecSortSe] = 160
--		AND [SpecDescription] IS NOT NULL
--	;

--	SELECT
--		*
--	FROM 
--		[dbo].#temp_stg_update AS [T]
--	LEFT JOIN
--		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
--	ON
--		[O].[SGQuote] = [T].[SGQuote]
--		AND [IsSTGQuote] = 1
--	WHERE
--		[SpecSortG] = 28
--		AND [SpecSortSe] = 160
--		AND [SpecDescription] IS NOT NULL
--	ORDER BY
--		[T].[ID]

--	SELECT 'Aft' AS [T], * FROM #temp_stg_update;
--	;

--COMMIT;
--ROLLBACK;
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------


SELECT * FROM #temp_stg_update;

SELECT
	*
FROM 
	[dbo].#temp_stg_update AS [T]
LEFT JOIN
	[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
ON
	[O].[SGQuote] = [T].[SGQuote]
	AND [IsSTGQuote] = 1
WHERE
	[O].[SGQuote] = 'SG101136'
	AND (
		[SpecDescription] LIKE '%7%'
		OR [SpecDescription] LIKE '%air cab%'
		OR [SpecDescription] LIKE '%no/reg%'
	)
	AND (
		[O].[ID] NOT IN (
			5170,
			5205
		)
	)
ORDER BY
	[SpecSection]
;


SELECT
		*
	FROM 
		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
	INNER JOIN
		[Custom WorkV2]
	ON
		[NPOID] = [Custom WorkV2].[ID]
	WHERE
		[SpecDescription] LIKE '%7-way%'
		--AND [NPOID] IS NOT NULL

	ORDER BY
		[T].[ID]
;

SELECT
	*
FROM
	#temp_stg_update AS [T]
LEFT JOIN
	[Custom WorkV2]
ON
	[T].[SGQuote] = [Custom WorkV2].[SGQuote]
WHERE
	[Custom WorkV2].[Description] = 'Rear Pocket Lights'


--SELECT
--	*
--FROM 
--	@t
--LEFT JOIN
--	[OrdersV2]
--ON
--	[OrdersV2].[SGQuote] = [@t].[SGQuote]
--	AND [IsSTGQuote] = 1
--LEFT JOIN
--	[Orders]
--ON
--	CAST([Orders].[Quote#] AS NVARCHAR(5)) = [@t].[SGQuote]
--	AND [IsSTGQuote] = 0
--ORDER BY
--	[@t].[ID]
--;

BEGIN TRAN;

	SELECT 'Bef' AS [T], * FROM #temp_stg_update;
	SELECT
		*
	FROM 
		[dbo].#temp_stg_update AS [T]
	CROSS JOIN
		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
	--ON
	--	[O].[SGQuote] = [T].[SGQuote]
	--	AND [IsSTGQuote] = 1
	WHERE
		[O].[SGQuote] IS NOT NULL
		AND [O].[ID] = 5220
		AND [IsSTGQuote] = 1
	--WHERE
	--	[SpecSortG] = 28
	--	AND [SpecSortSe] = 160
	--	AND [SpecDescription] IS NOT NULL
	ORDER BY
		[T].[ID]
	;

	INSERT INTO [Custom WorkV2_SpecLines]
	(
		[SGQuote]
           ,[WO#]
           ,[Description]
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
           ,[NPOID]
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
		[O].[SGQuote]
           ,[CW].[WO#]
           ,[CW].[Description]
           ,[Line#] = 2
           ,[CW].[SpecGroup]
           ,[SpecSortG] = 28
           ,[SpecSection] = 'Lift Axle Control Wiring'
           ,[SpecSortSe] = 71
           ,[SpecDescription] = 'Electric down thru auxiliary & ball valve (NO/REG)'
           ,[SpecDescriptionBold] = 0
           ,[SpecDescriptionItalic] = 0
           ,[SpecDescriptionUnderline] = 0
           ,[CW].[SpecDescriptionBackColour]
           ,[CW].[SpecDescriptionFontColour]
           ,[SpecSortSeLine] = 0
           ,[NPOID] = [O].[ID]
           ,[CW].[Operation1Hours]
           ,[CW].[Operation2Hours]
           ,[CW].[Operation3Hours]
           ,[CW].[Operation4Hours]
           ,[CW].[Operation5Hours]
           ,[CW].[Operation6Hours]
           ,[CW].[Operation7Hours]
           ,[CW].[Operation8Hours]
           ,[CW].[Operation9Hours]
           ,[CW].[Operation10Hours]
           ,[CW].[Operation11Hours]
           ,[CW].[Operation12Hours]
           ,[CW].[Operation13Hours]
           ,[CW].[Operation14Hours]
           ,[CW].[Operation15Hours]
           ,[CW].[Operation16Hours]
           ,[CW].[Operation17Hours]
		FROM 
			#temp_stg_update AS [T]
		LEFT JOIN
			[Custom WorkV2] AS [O] 
		ON
			[T].[SGQuote] = [O].[SGQuote]
		CROSS JOIN
			[Custom WorkV2_SpecLines] AS [CW]
		--ON
		--	[CW].[SGQuote] = [T].[SGQuote]
		--	AND [IsSTGQuote] = 1
	WHERE
		[O].[SGQuote] IS NOT NULL
		AND [CW].[ID] = 5220
		AND [IsSTGQuote] = 1

	--UPDATE
	--	[Custom WorkV2_SpecLines]
	--SET
	--	[SpecDescription] = REPLACE(REPLACE(REPLACE([SpecDescription], 'aluminum polished', 'polished aluminum'), 'aluminum polish', 'polished aluminum'), 'polish', 'high polish')
	--FROM 
	--	[dbo].#temp_stg_update AS [T]
	--LEFT JOIN
	--	[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
	--ON
	--	[O].[SGQuote] = [T].[SGQuote]
	--	AND [IsSTGQuote] = 1
	--WHERE
	--	[SpecSortG] = 28
	--	AND [SpecSortSe] = 160
	--	AND [SpecDescription] IS NOT NULL
	--;

	UPDATE
		#temp_stg_update
	SET
		[B] = 1
	FROM 
		[dbo].#temp_stg_update AS [T]
	CROSS JOIN
		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
	--ON
	--	[O].[SGQuote] = [T].[SGQuote]
	--	AND [IsSTGQuote] = 1
	WHERE
		[O].[SGQuote] IS NOT NULL
		AND [O].[ID] = 5220
		AND [IsSTGQuote] = 1
	;

	SELECT
		*
	FROM 
		[dbo].#temp_stg_update AS [T]
	INNER JOIN
		[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
	ON
		[O].[SGQuote] = [T].[SGQuote]
		AND [IsSTGQuote] = 1
	WHERE
		[O].[SGQuote] IS NOT NULL
		--AND [O].[ID] = 5220
		AND [IsSTGQuote] = 1
	--	[SpecSortG] = 28
	--	AND [SpecSortSe] = 160
	--	AND [SpecDescription] IS NOT NULL
	ORDER BY
		[T].[ID]

	SELECT 'Aft' AS [T], * FROM #temp_stg_update;
	;

COMMIT;
ROLLBACK;