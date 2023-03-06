USE BWSdb
GO

SELECT 
	[Budget Options].[Option No]
	, [Options].[Option No]
	, [Budget Options].[Model No]
	, [Options].[Model No]
	, *
FROM
	[Budget Options]
FULL OUTER JOIN 
	[Options]
ON
	[Budget Options].[Option No] = [Options].[Option No]