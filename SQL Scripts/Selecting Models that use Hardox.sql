USE BWSdb
GO


SELECT 
	*
FROm
	[Standards]
WHERE
	[Description] LIKE '%hardox%'
;

SELECT DISTINCT 
	[Class], [Standards].[Model No], [Section], [Description]
FROM
	[Standards]
INNER JOIN
	[Products]
ON
	[Standards].[Model No] = [Products].[Model No]
WHERE
	[Description] LIKE '%hardox%'
	AND [Proposed] = 0
	AND [Non-Current] = 0