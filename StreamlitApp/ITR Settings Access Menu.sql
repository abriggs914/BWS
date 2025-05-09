SELECT
	*
FROM
	[BWSdb].[dbo].[ITR Pushes]
-----------------------------------------------
SELECT
	*
FROM
	[BWSdb].[dbo].[ADG Events]
WHERE
	[DestinationForm] = 'Search Sales Parameters'
-----------------------------------------------
SELECT
	*
FROM
	[BWSdb].[dbo].[ITR Settings]
-----------------------------------------------
SELECT
	[C].[CustomerID],
	[C].[Name],
	[C].[WindowsUser]
FROM
	[BWSdb].[dbo].[ITR Customers] [C]
WHERE
	([C].[Active] = 1)
	--AND ([C].[IsAPerson] = 1)