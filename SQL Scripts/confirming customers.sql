USE BWSdb
GO

DECLARE @set1 AS TABLE ([ID] INT IDENTITY(1, 1), [WO] NVARCHAR(MAX));
DECLARE @set2 AS TABLE ([ID] INT IDENTITY(1, 1), [WO] NVARCHAR(MAX));
DECLARE @set3 AS TABLE ([ID] INT IDENTITY(1, 1), [WO] NVARCHAR(MAX));

INSERT INTO @set1 ([WO]) VALUES 
	('491'), ('490'), ('605'),
	('476'), ('468'), ('543'),
	('596'), ('597'), ('573'),
	('572'), ('531'), ('530'),
	('487'), ('598'), ('627'),
	('589'), ('628');

INSERT INTO @set2 ([WO]) VALUES 
	('468'), ('476'), ('490'),
	('491'), ('530'), ('531'),
	('542'), ('543'), ('572'),
	('573'), ('589'), ('596'),
	('597'), ('598'), ('605'),
	('627'), ('628');

INSERT INTO @set3 ([WO]) SELECT [WO] FROM @set1 UNION SELECT [WO] FROM @set2

SELECT 
	* 
FROM
	[CustomersV2]
INNER JOIN
	[OrdersV2]
ON
	[CustomersV2].[WO#] = [OrdersV2].[WO#]
WHERE
	RIGHT([OrdersV2].[WO#], 3) IN (SELECT [WO] FROM @set3)
	AND LEFT([OrdersV2].[WO#], 1) = '1'
ORDER BY
	[OrdersV2].[WO#]

SELECT * FROM [OrdersV2] WHERE RIGHT([WO#], 3) IN (SELECT [WO] FROM @set3)



SELECT [OrdersV2].[WO#]
	FROM
	[CustomersV2]
INNER JOIN
	[OrdersV2]
ON
	[CustomersV2].[WO#] = [OrdersV2].[WO#]
WHERE
	RIGHT([OrdersV2].[WO#], 3) IN (SELECT [WO] FROM @set3)