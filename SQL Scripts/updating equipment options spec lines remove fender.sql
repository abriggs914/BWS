USE BWSdb
GO

SELECT
	[Class],
	*
FROM
	[Options_SpecLines]
INNER JOIN
	[Products]
ON
	[Options_SpecLines].[Model No] = [Products].[Model No]
WHERE
	[Description] LIKE '%fender%'
	AND [Description] NOT LIKE '%upgrade to%'
	AND [Description] NOT LIKE '%heavy duty smooth%'
	AND [Description] NOT LIKE '%heavy duty fenders%'
	AND ([Class] LIKE '%equipment%'
	OR [Class] LIKE '%paving%')
ORDER BY
	[Option No],
	[SpecSortG]
;