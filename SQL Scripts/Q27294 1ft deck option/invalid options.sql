USE BWSdb
GO

DECLARE @t AS TABLE ([Class] NVARCHAR(MAX), [Model No] NVARCHAR(MAX), [Option No] NVARCHAR(MAX))

--INSERT INTO @t ([Class], [Model No], [Option No])
SELECT DISTINCT
	[Products].[Model No]
FROM
	[Products]
INNER JOIN
	[Options]
ON
	[Products].[Model No] = [Options].[Model No]
GROUP BY
	[Class],
	[Products].[Model No],
	[Option No]
HAVING
	COUNT([Option No]) > 1
ORDER BY 
	[Model No]
;

