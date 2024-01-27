USE BWSdb
GO

SELECT
	[Serial Number]
	,COUNT(*) AS [Times Found]
FROM
	[Orders]
WHERE
	[Serial Number] IS NOT NULL
GROUP BY
	[Serial Number]
HAVING
	COUNT(*) > 1
;

SELECT
	[Serial Number]
	,COUNT(*) AS [Times Found]
FROM
	[OrdersV2]
WHERE
	[Serial Number] IS NOT NULL
GROUP BY
	[Serial Number]
HAVING
	COUNT(*) > 1
;

SELECT
	*
FROM
	[Orders_History]
	
USE BWSdb
GO

SELECT * FROM [Orders_History]
SELECT * FROM [OrdersV2 History]
SELECT * FROM [Order standards_history]
SELECT * FROM [Order standardsV2_history]
SELECT * FROM [Order options_history]
SELECT * FROM [Order optionsV2_history]
SELECT * FROM [Order optionsv2_factorylines_history]
SELECT * FROM [Order options_factorylines_history]
SELECT * FROM [Order optionsv2_speclines_history]
SELECT * FROM [Order options_speclines_history]
SELECT * FROM [Custom Work_history]
SELECT * FROM [Custom WorkV2_history]
