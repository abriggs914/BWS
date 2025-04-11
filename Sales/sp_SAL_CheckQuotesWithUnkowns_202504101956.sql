USE BWSdb
GO


CREATE PROCEDURE [sp_SAL_CheckQuotesWithUnkowns]
AS
BEGIN

	DECLARE @st NVARCHAR(3) = '???'

	SELECT
		[Src].*,
		[O].[Quote Date],
		ISNULL([PS].[Prod Date 1], [PS].[Prod Date 2]) AS [Prod Date]
	FROM (
		SELECT
			NULL AS [Table],
			NULL AS [Quote],
			NULL AS [WO],
			NULL AS [Model],
			NULL AS [Group],
			NULL AS [Section],
			NULL AS [Desc]

		UNION (

			SELECT
				'Standards' AS [Table],
				NULL AS [Quote],
				NULL AS [WO],
				NULL AS [Model],
				NULL AS [Group],
				NULL AS [Section],
				NULL AS [Desc]
			UNION ALL
			SELECT 
				'Standards' AS [Table]
				,[OS].[Quote#]
				,[OS].[WO#]
				,[OS].[Model No]
				,[OS].[Group]
				,[OS].[Section]
				,[OS].[Description]
			FROM
				[BWSdb].[dbo].[Order Standards] [OS]
			WHERE 
				(CASE WHEN ISNULL([OS].[Description], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END)
				+ (CASE WHEN ISNULL([OS].[Group], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END) 
				+ (CASE WHEN ISNULL([OS].[Section], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END) >= 1
	

			UNION
			-----------------------------------------------------------------------------------------------------------------------

			SELECT
				'OO Options' AS [Table],
				NULL AS [Quote],
				NULL AS [WO],
				NULL AS [Model],
				NULL AS [Group],
				NULL AS [Section],
				NULL AS [Desc]
			UNION ALL
			SELECT 
				'OO Options' AS [Table]
				,[OO].[Quote#]
				,[OO].[WO#]
				,NULL AS [Model]
				,NULL AS [Group]
				,NULL AS [Section]
				,[OO].[Description]
			FROM
				[BWSdb].[dbo].[Order Options] [OO]
			WHERE 
				(CASE WHEN ISNULL([OO].[Description], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END) >= 1
	

			UNION
			-----------------------------------------------------------------------------------------------------------------------

			SELECT
				'OO Factory Lines' AS [Table],
				NULL AS [Quote],
				NULL AS [WO],
				NULL AS [Model],
				NULL AS [Group],
				NULL AS [Section],
				NULL AS [Desc]
			UNION ALL
			SELECT 
				'OO Factory Lines' AS [Table]
				,[FL].[Quote#]
				,[FL].[WO#]
				,NULL AS [Model]
				,NULL AS [Group]
				,NULL AS [Section]
				,[FL].[Description]
			FROM
				[BWSdb].[dbo].[Order Options_FactoryLines] [FL]
			WHERE 
				(CASE WHEN ISNULL([FL].[Description], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END) >= 1
	

			UNION
			-----------------------------------------------------------------------------------------------------------------------

			SELECT
				'OO Spec Lines' AS [Table],
				NULL AS [Quote],
				NULL AS [WO],
				NULL AS [Model],
				NULL AS [Group],
				NULL AS [Section],
				NULL AS [Desc]
			UNION ALL
			SELECT 
				'OO Spec Lines' AS [Table]
				,[SL].[Quote#]
				,[SL].[WO#]
				,NULL AS [Model]
				,NULL AS [Group]
				,NULL AS [Section]
				,[SL].[Description]
			FROM
				[BWSdb].[dbo].[Order Options_SpecLines] [SL]
			WHERE 
				(CASE WHEN ISNULL([SL].[Description], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END) >= 1
	

			UNION
			-----------------------------------------------------------------------------------------------------------------------

			SELECT
				'CW Custom Work' AS [Table],
				NULL AS [Quote],
				NULL AS [WO],
				NULL AS [Model],
				NULL AS [Group],
				NULL AS [Section],
				NULL AS [Desc]
			UNION ALL
			SELECT 
				'CW Custom Work' AS [Table]
				,[CW].[Quote#]
				,[CW].[WO#]
				,NULL AS [Model]
				,NULL AS [Group]
				,NULL AS [Section]
				,[CW].[Description]
			FROM
				[BWSdb].[dbo].[Custom Work] [CW]
			WHERE 
				(CASE WHEN ISNULL([CW].[Description], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END)
				+ (CASE WHEN ISNULL([CW].[Section], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END) >= 1
	

			UNION
			-----------------------------------------------------------------------------------------------------------------------

			SELECT
				'CW Factory Lines' AS [Table],
				NULL AS [Quote],
				NULL AS [WO],
				NULL AS [Model],
				NULL AS [Group],
				NULL AS [Section],
				NULL AS [Desc]
			UNION ALL
			SELECT 
				'CW Factory Lines' AS [Table]
				,[FL].[Quote#]
				,[FL].[WO#]
				,NULL AS [Model]
				,NULL AS [Group]
				,NULL AS [Section]
				,[FL].[Description]
			FROM
				[BWSdb].[dbo].[Custom Work_FactoryLines] [FL]
			WHERE 
				(CASE WHEN ISNULL([FL].[Description], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END) >= 1
	

			UNION
			-----------------------------------------------------------------------------------------------------------------------

			SELECT
				'CW Spec Lines' AS [Table],
				NULL AS [Quote],
				NULL AS [WO],
				NULL AS [Model],
				NULL AS [Group],
				NULL AS [Section],
				NULL AS [Desc]
			UNION ALL
			SELECT 
				'CW Spec Line' AS [Table]
				,[SL].[Quote#]
				,[SL].[WO#]
				,NULL AS [Model]
				,NULL AS [Group]
				,NULL AS [Section]
				,[SL].[Description]
			FROM
				[BWSdb].[dbo].[Custom Work_SpecLines] [SL]
			WHERE 
				(CASE WHEN ISNULL([SL].[Description], '') LIKE '%' + @st + '%' THEN 1 ELSE 0 END) >= 1
		)
	) AS [Src]
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O]
	ON
		[Src].[Quote] = [O].[Quote#]
	LEFT JOIN
		[BWSdb].[dbo].[dtProductionSchedule] [PS]
	ON
		[Src].[Quote] = [PS].[Quote#]
	-----------------------------------------------------------------------------------------------------------------------
	WHERE
		[Quote] IS NOT NULL
	/*
	ORDER BY
		[Quote]
		,[Table]
		,[Group]
		,[Section]
	*/
END