USE BWSdb
GO

DECLARE @mn AS NVARCHAR(MAX) = '53PC2X';

SELECT
	'Products' AS [T],
	*
FROM
	[Products]
WHERE 
	[Model No] = @mn
;

SELECT
	'Standards' AS [T],
	*
FROM
	[Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[SortGV2]
	,[SortSeV2]
;

SELECT
	'Order Standards' AS [T],
	*
FROM
	[Order Standards]
WHERE 
	[Model No] = @mn
ORDER BY
	[SortGV2]
	,[SortSeV2]
;

SELECT
	'Options' AS [T],
	*
FROM
	[Options]
WHERE 
	[Model No] = @mn
ORDER BY
	[Description]
;
SELECT
	'Budget Options' AS [T],
	*
FROM
	[Budget Options]
WHERE 
	[Model No] = @mn
ORDER BY
	[Description]
;

SELECT
	'Order Standards' AS [T],
	*
FROM
	[Order Standards]
WHERE
	[Model No] LIKE '%' + @mn + '%'
ORDER BY
	[Description]
;

SELECT
	'Orders' AS [T],
	*
FROM
	[Orders]
WHERE
	[Model No] = @mn
;

SELECT
	'Order Options' AS [T],
	*
FROM
	[Order Options]
WHERE
	[Option No] LIKE '%' + @mn + '%'

SELECT
	'Order Options_FactoryLines' AS [T],
	*
FROM
	[Order Options_FactoryLines]
WHERE
	[Option No] LIKE '%' + @mn + '%'
ORDER BY
	[Description]

SELECT
	'Order Options_SpecLine' AS [T],
	*
FROM
	[Order Options_SpecLines]
WHERE
	[Option No] LIKE '%' + @mn + '%'
ORDER BY
	[Description]

