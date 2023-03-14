USE BWSdb
GO


-- mismatch options. These options are non-obsolete on one table but not the other.

SELECT 
	[O].[Obsolete] AS [Options Obsolete]
	, [BO].[Obsolete] AS [Budget Options Obsolete]
	, [O].[Start Date]
	, [O].[End Date]
	, [P].[Start Date]
	, [P].[End Date]
	, [BO].[Bud_Date_Opt]
	, [BO].[Option No]
	, [O].[Option No]
	, [Class]
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
	([O].[Obsolete] = 1
	AND [BO].[Obsolete] = 0) OR ([O].[Obsolete] = 0
	AND [BO].[Obsolete] = 1)
ORDER BY
	ISNULL([O].[End Date],
		ISNULL([BO].[Bud_Date_Opt],
			ISNULL([P].[End Date], 
				ISNULL([O].[Start Date], 
					ISNULL([BO].[Bud_Date_Opt], [P].[Start Date])
	)))) DESC
;



SELECT
	*
FROM
	[Options]
WHERE
	[Obsolete] = 1
;

