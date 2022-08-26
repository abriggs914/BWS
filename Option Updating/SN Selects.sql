SELECT * FROM [Orders] ORDER BY [Quote#]
SELECT * FROM [Orders] WHERE [Quote#] LIKE '%234%' ORDER BY [Quote#]
SELECT
	[Quote#]
	, [WO#]
	, [Model No]
	, [Quote Date]
	, [Order Date]
	, [Delivery Date]
FROM [Orders] WHERE [Quote#] = 27912 ORDER BY [Quote#]

SELECT * FROM [SN Type] WHERE [Model No] = '40SN3X'