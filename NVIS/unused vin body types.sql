USE BWSdb
GO


DECLARE @possibilities AS TABLE ([ID] INT IDENTITY(1, 1), [Body Type] NVARCHAR(1))
INSERT INTO @possibilities VALUES 
	('0'),
	('1'),
	('2'),
	('3'),
	('4'),
	('5'),
	('6'),
	('7'),
	('8'),
	('9'),
	('A'),
	('B'),
	('C'),
	('D'),
	('E'),
	('F'),
	('G'),
	('H'),
	('I'),
	('J'),
	('K'),
	('L'),
	('M'),
	('N'),
	('O'),
	('P'),
	('Q'),
	('R'),
	('S'),
	('T'),
	('U'),
	('V'),
	('W'),
	('X'),
	('Y'),
	('Z')

SELECT TOP 1 [Serial Number] FROM [Orders] WHERE [Serial Number] IS NOT NULL ORDER BY [Quote Date] DESC

SELECT 
	SUBSTRING([SN], 5, 1) AS [A]
	,SUBSTRING([SN], 6, 1) AS [B]
FROM (
SELECT TOP 1 [Serial Number] AS [SN] FROM [Orders] WHERE [Serial Number] IS NOT NULL ORDER BY [Quote Date] DESC
) AS [A]
	
	SELECT 
		SUBSTRING(LEFT([Orders].[Serial Number] + '00000000000000000', 17), 6, 1) AS [Body Type],
		COUNT(*) AS [#]
	FROM
		[Orders]
	GROUP BY
		SUBSTRING(LEFT([Orders].[Serial Number] + '00000000000000000', 17), 6, 1)
	ORDER BY
		SUBSTRING(LEFT([Orders].[Serial Number] + '00000000000000000', 17), 6, 1)


SELECT
	[@possibilities].[Body Type]
FROM
	@possibilities
LEFT JOIN (
	SELECT 
		SUBSTRING(LEFT([Orders].[Serial Number] + '00000000000000000', 17), 6, 1) AS [Body Type],
		COUNT(*) AS [#]
	FROM
		[Orders]
	GROUP BY
		SUBSTRING(LEFT([Orders].[Serial Number] + '00000000000000000', 17), 6, 1)
) AS [B]
ON
	[@possibilities].[Body Type] = [B].[Body Type]
WHERE
	[B].[Body Type] IS NULL
ORDER BY
	[@possibilities].[Body Type]

--UNION
--SELECT 
--	DISTINCT [OrdersV2].[Serial Number]
--FROM
--	[OrdersV2]
