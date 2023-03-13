USE BWSdb
GO

SELECT 
	[O].[Start Date]
	, [O].[End Date]
	, [P].[Start Date]
	, [P].[End Date]
	, [BO].[Bud_Date_Opt]
	, [BO].[Option No]
	, [O].[Option No]
	, [BO].[Model No]
	, [O].[Model No]
	, *
FROM
	[Budget Options] AS [BO]
FULL OUTER JOIN 
	[Options] AS [O]
ON
	[BO].[Option No] = [O].[Option No]
INNER JOIN 
	[Products] AS [P]
ON
	[O].[Model No] = [P].[Model No]
WHERE
	[O].[Obsolete] = 0
	AND [BO].[Obsolete] = 0
ORDER BY
	ISNULL([O].[End Date],
		ISNULL([BO].[Bud_Date_Opt],
			ISNULL([P].[End Date], 
				ISNULL([O].[Start Date], 
					ISNULL([BO].[Bud_Date_Opt], [P].[Start Date])
	)))) DESC