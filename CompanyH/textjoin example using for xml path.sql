
-- Testing Row TEXTJOIN using FOR XML PATH.
-- Use a delimiter to append row values using a condition

SELECT [ITR2].[Request], 
    STUFF(
        (
            SELECT ',' + [ITR2].[Request] AS [text()]
            FROM [BWSdb].[dbo].[IT Requests] [ITR1]
            WHERE [ITR2].[Request] = [ITR2].[Request]
            ORDER BY [ITR2].[Request]
            FOR XML PATH (''), TYPE
        ).value('text()[1]','nvarchar(max)'), 1, 1, '') [Students]
FROM [BWSdb].[dbo].[IT Requests] [ITR2]
WHERE [ITR2].[ITRequestID#] < 5
GROUP BY [ITR2].[Request]

;

SELECT
    STUFF(
        (
            SELECT ',' + [ITR2].[Request] AS [text()]
            FROM [BWSdb].[dbo].[IT Requests] [ITR1]
            --WHERE [ITR2].[Request] = [ITR2].[Request]
            ORDER BY [ITR2].[Request]
            FOR XML PATH (''), TYPE
        ).value('text()[1]','nvarchar(max)'), 1, 1, '') [Students]
FROM [BWSdb].[dbo].[IT Requests] [ITR2]
WHERE [ITR2].[ITRequestID#] < 5
GROUP BY [ITR2].[Request]
;

--------------------------------------------

SELECT [ITR2].[Request], 
    STUFF(
        (
            SELECT ',' + [ITR1].[Request] AS [text()]
            FROM [BWSdb].[dbo].[IT Requests] [ITR1]
            --WHERE [ITR1].[Request] = [ITR2].[Request]
			WHERE [ITR1].[ITRequestID#] < 5
            ORDER BY [ITR1].[Request]
            FOR XML PATH (''), TYPE
        ).value('text()[1]','nvarchar(max)'), 1, 1, '') [Students]
FROM [BWSdb].[dbo].[IT Requests] [ITR2]
WHERE [ITR2].[ITRequestID#] < 5
GROUP BY [ITR2].[Request]

-------------------------------------------------

SELECT
  STUFF(
        (
            SELECT DISTINCT ',' + [ITR1].[RequestSubType] AS [text()]
            FROM [BWSdb].[dbo].[IT Requests] [ITR1]
            --WHERE [ITR1].[Request] = [ITR2].[Request]
			WHERE [ITR1].[ITRequestID#] < 50
            --ORDER BY [ITR1].[RequestType]
            FOR XML PATH (''), TYPE
        ).value('text()[1]','nvarchar(max)'), 1, 1, '') [Students]

-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------

-- GOOD VERSION 2025-01-22 1921


SELECT 
	[O2].[ProductID],
	[O2].[Model No], 
    STUFF(
		(
            SELECT
				';' + CAST([O1].[Quote#] AS NVARCHAR(25)) AS [text()]
            FROM
				[BWSdb].[dbo].[Orders] [O1]
			WHERE
				([O1].[Model No] = [O2].[Model No])
				AND ([O1].[Quote#] BETWEEN 25000 AND 50001)
			--WHERE [O1].[Quote#] BETWEEN 16999 AND 50001
            ORDER BY [O1].[Quote#] DESC
            FOR XML PATH (''), TYPE
        ).value('text()[1]','NVARCHAR(MAX)'), 1, 1, '') [ListQuotes]
	, COUNT(*) AS [NumQuotes]
FROM
	[BWSdb].[dbo].[Orders] [O2]
GROUP BY
	[O2].[Model No],
	[O2].[ProductID]
ORDER BY 
	[O2].[Model No]
;

------------------------------------------------------------------------

SELECT
	[P].[IDTrailer]
	, [P].[Model No]
	, [OS].[Group] AS [OS_Grp]
	, [OS].[Section] AS [OS_Sec]
	, [OS].[Description] AS [OS_Desc]
	, [OO].[Description] AS [OO_Desc]
	, [OO].[Qty] AS [OO_Qty]
	, [CW].[Description] AS [CW_Desc]
	, [CW].[Qty] AS [CW_Qty]
	, [CWFL].[SpecGroup] AS [CWFL_Grp]
	, [CWFL].[SpecSection] AS [CWFL_Sec]
	, [CWFL].[Description] AS [CWFL_Desc]
	, [CWSL].[SpecGroup] AS [CWSL_Grp]
	, [CWSL].[SpecSection] AS [CWSL_Sec]
	, [CWSL].[Description] AS [CWSL_Desc]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[Model No] = [P].[Model No]
INNER JOIN
	[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
ON
	[O].[Quote#] = [OS].[Quote#]
INNER JOIN
	[BWSdb].[dbo].[Order Options] [OO] WITH (NOLOCK)
ON
	[O].[Quote#] = [OO].[Quote#]
INNER JOIN
	[BWSdb].[dbo].[Custom Work] [CW] WITH (NOLOCK)
ON
	[O].[Quote#] = [CW].[Quote#]
LEFT JOIN
	[BWSdb].[dbo].[Custom Work_FactoryLines] [CWFL] WITH (NOLOCK)
ON
	([CW].[Quote#] = [CWFL].[Quote#])
	AND ([CW].[ID] = [CWFL].[NPOID])
LEFT JOIN
	[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
ON
	([CW].[Quote#] = [CWSL].[Quote#])
	AND ([CW].[ID] = [CWSL].[NPOID])
WHERE
	--LTRIM(RTRIM(LOWER(ISNULL([CW].[Description], '')))) <> 'none'
	[O].[Date Declined] IS NOT NULL
GROUP BY
	[P].[IDTrailer]
	, [P].[Model No]
	, [OS].[Group]
	, [OS].[Section]
	, [OS].[Description]
	, [OO].[Description]
	, [OO].[Qty]
	, [CW].[Description]
	, [CW].[Qty]
	, [CWFL].[SpecGroup]
	, [CWFL].[SpecSection]
	, [CWFL].[Description]
	, [CWSL].[SpecGroup]
	, [CWSL].[SpecSection]
	, [CWSL].[Description]
HAVING
	COUNT(*) > 1
;


	--SELECT
	--	[OO].[Quote#]
	--	, [OO].[Qty] AS [OO_Qty]
	--	, [OO].[Description] AS [OO_Desc]
	--	, [OOFL].[SpecGroup] AS [OOFL_Grp]
	--	, [OOFL].[SpecSection] AS [OOFL_Sec]
	--	, [OOFL].[Description] AS [OOFL_Desc]
	--	, [OOSL].[SpecGroup] AS [OOSL_Grp]
	--	, [OOSL].[SpecSection] AS [OOSL_Sec]
	--	, [OOSL].[Description] AS [OOSL_Desc]
	--FROM 
	--	[BWSdb].[dbo].[Order Options] [OO] WITH (NOLOCK)
	--LEFT JOIN
	--	[BWSdb].[dbo].[Order Options_FactoryLines] [OOFL] WITH (NOLOCK)
	--ON
	--	([OO].[Quote#] = [OOFL].[Quote#])
	--	AND ([OO].[ID] = [OOFL].[OrderOptionID])
	--LEFT JOIN
	--	[BWSdb].[dbo].[Order Options_SpecLines] [OOSL] WITH (NOLOCK)
	--ON
	--	([OO].[Quote#] = [OOSL].[Quote#])
	--	AND ([OO].[ID] = [OOSL].[OrderOptionID])



SELECT
	[OS].[Quote#]
	,[CW_Src].*
	,[OO_Src].*
	,[OS].[Group]
	,[OS].[Section]
	,[OS].[Description]
FROM 
	[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
LEFT JOIN (
	SELECT
		[CW].[Quote#]
		, [CW].[Qty] AS [CW_Qty]
		, [CW].[Description] AS [CW_Desc]
		, [CWFL].[SpecGroup] AS [CWFL_Grp]
		, [CWFL].[SpecSection] AS [CWFL_Sec]
		, [CWFL].[Description] AS [CWFL_Desc]
		, [CWSL].[SpecGroup] AS [CWSL_Grp]
		, [CWSL].[SpecSection] AS [CWSL_Sec]
		, [CWSL].[Description] AS [CWSL_Desc]
	FROM 
		[BWSdb].[dbo].[Custom Work] [CW] WITH (NOLOCK)
	LEFT JOIN
		[BWSdb].[dbo].[Custom Work_FactoryLines] [CWFL] WITH (NOLOCK)
	ON
		([CW].[Quote#] = [CWFL].[Quote#])
		AND ([CW].[ID] = [CWFL].[NPOID])
	LEFT JOIN
		[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
	ON
		([CW].[Quote#] = [CWSL].[Quote#])
		AND ([CW].[ID] = [CWSL].[NPOID])
) AS [CW_Src]
ON
	([OS].[Quote#] = [CW_Src].[Quote#])
	AND ([OS].[Group] = [CW_Src].[CWFL_Grp])
	AND ([OS].[Section] = [CW_Src].[CWFL_Sec])
LEFT JOIN (
	SELECT
		[OO].[Quote#]
		, [OO].[Qty] AS [OO_Qty]
		, [OO].[Description] AS [OO_Desc]
		, [OOFL].[SpecGroup] AS [OOFL_Grp]
		, [OOFL].[SpecSection] AS [OOFL_Sec]
		, [OOFL].[Description] AS [OOFL_Desc]
		, [OOSL].[SpecGroup] AS [OOSL_Grp]
		, [OOSL].[SpecSection] AS [OOSL_Sec]
		, [OOSL].[Description] AS [OOSL_Desc]
	FROM 
		[BWSdb].[dbo].[Order Options] [OO] WITH (NOLOCK)
	LEFT JOIN
		[BWSdb].[dbo].[Order Options_FactoryLines] [OOFL] WITH (NOLOCK)
	ON
		([OO].[Quote#] = [OOFL].[Quote#])
		AND ([OO].[ID] = [OOFL].[OrderOptionID])
	LEFT JOIN
		[BWSdb].[dbo].[Order Options_SpecLines] [OOSL] WITH (NOLOCK)
	ON
		([OO].[Quote#] = [OOSL].[Quote#])
		AND ([OO].[ID] = [OOSL].[OrderOptionID])
) AS [OO_Src]
ON
	([OS].[Quote#] = [OO_Src].[Quote#])
	AND ([OS].[Group] = [OO_Src].[OOFL_Grp])
	AND ([OS].[Section] = [OO_Src].[OOFL_Sec])
;


DECLARE @q INT = 30544;
SELECT
	*
FROM	
	[BWSdb].[dbo].[Custom Work] [CW1] WITH (NOLOCK)
LEFT JOIN
	[BWSdb].[dbo].[Custom Work_FactoryLines] [CWFL1] WITH (NOLOCK)
ON
	([CW1].[Quote#] = [CWFL1].[Quote#])
	AND ([CW1].[ID] = [CWFL1].[NPOID])
LEFT JOIN
	[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL1] WITH (NOLOCK)
ON
	([CW1].[Quote#] = [CWSL1].[Quote#])
	AND ([CW1].[ID] = [CWSL1].[NPOID])
WHERE
	[CW1].[Quote#] = @q
;

SELECT
	*
FROM	
	[BWSdb].[dbo].[Custom Work] [CW1] WITH (NOLOCK)
WHERE
	[CW1].[Quote#] = @q;

SELECT
	*
FROM	
	[BWSdb].[dbo].[Custom Work_FactoryLines] [CWFL] WITH (NOLOCK)
WHERE
	[CWFL].[Quote#] = @q;

SELECT
	*
FROM	
	[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
WHERE
	[CWSL].[Quote#] = @q;
