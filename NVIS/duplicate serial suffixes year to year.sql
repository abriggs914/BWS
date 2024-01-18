USE BWSdb
GO

SELECT * FROM [OrdersV2] WHERE RIGHT([Serial Number], 3) = '102'
SELECT * FROM [SysproCompany].[dbo].[Jnl] WHERE RIGHT([Serial Number], 3) = '102'

SELECT
	LEFT([Serial Number], 3) AS [Prefix],
	RIGHT([Serial Number], 3) AS [Suffix],
	(LEFT(RIGHT([Serial Number], 8), 1)) AS [Prod Year]
FROM (
SELECT 
	[SGQuote] AS [A],
	[Serial Number],
	LEFT([Serial Number], 3) AS [B],
	RIGHT([Serial Number], 3) AS [C],
	(LEFT(RIGHT([Serial Number], 8), 1)) AS [D]
FROM
	[OrdersV2]
GROUP BY
	[SGQuote],
	[Serial Number],
	RIGHT([Serial Number], 3),
	(LEFT(RIGHT([Serial Number], 8), 1))
--HAVING
--	COUNT(*) > 1
--ORDER BY
--	RIGHT([Serial Number], 3)

) AS [Src]
WHERE
	[Serial Number] IS NOT NULL
GROUP BY
	LEFT([Serial Number], 3),
	RIGHT([Serial Number], 3),
	(LEFT(RIGHT([Serial Number], 8), 1))
HAVING
	COUNT(*) > 1



DECLARE @T TABLE ([Suffix] NVARCHAR(MAX))
INSERT INTO @T ([Suffix]) VALUES
('049'), ('081'), ('083'), ('085'), ('087'), ('089'), ('091'), ('093'), ('102')

SELECT
	* 
FROM
	[OrdersV2]
INNER JOIN
	@T
ON
	RIGHT([OrdersV2].[Serial Number], 3) = [Suffix]
WHERE
	(LEFT(RIGHT([Serial Number], 8), 1)) = 'S'
	AND (LEFT([Serial Number], 3)) <> '2XB'
ORDER BY
	RIGHT([OrdersV2].[Serial Number], 3)