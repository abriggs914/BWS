USE SysproCompanyS
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
	[Job], [JobDescription], [WipMaster].[Customer],
	[CustomerName], [WO#], [CustomersV2].[Customer],
	[Address], [City], [Province/State], [Postal Code/ZIP],
	[Phone], [Cell], [Email],
	[Contact], [Notes], [SGQuote]
FROM
	[BWSdb].[dbo].[CustomersV2]
LEFT JOIN
	[OrdersV2] 
ON
	[OrdersV2].[Customer] = CAST([CustomersV2].[ID#] AS NVARCHAR(MAX))
WHERE 
	RIGHT([Job], 3) IN (SELECT [WO] FROM @set3)
	AND LEFT([Job], 1) = '1'
ORDER BY
	[Job]

SELECT 
	[Job], [JobDescription], [WipMaster].[Customer],
	[CustomerName], [CustomersV2].[WO#], [CustomersV2].[Customer],
	[Address], [City], [Province/State], [Postal Code/ZIP],
	[Phone], [Cell], [Email],
	[Contact], [CustomersV2].[Notes], [CustomersV2].[SGQuote]
FROM
	[BWSdb].[dbo].[CustomersV2]
LEFT JOIN
	[WipMaster] 
ON
	[WipMaster].[Customer] = CAST([CustomersV2].[ID#] AS NVARCHAR(MAX))
LEFT JOIN
	[BWSdb].[dbo].[OrdersV2]
ON
	[CustomersV2].[SGQuote] = [OrdersV2].[SGQuote]
WHERE 
	RIGHT([Job], 3) IN (SELECT [WO] FROM @set3)
	AND LEFT([Job], 1) = '1'
ORDER BY
	[Job]

	
SELECT 
	[customer_timestamp]
	--,
	--[Job], [JobDescription], [WipMaster].[Customer],
	--[CustomerName], [WO#], [CustomersV2].[Customer],
	--[Address], [City], [Province/State], [Postal Code/ZIP],
	--[Phone], [Cell], [Email],
	--[Contact], [Notes], [SGQuote]
FROM
	[WipMaster] 
LEFT JOIN
	[BWSdb].[dbo].[CustomersV2]
ON
	[WipMaster].[Customer] = CAST([CustomersV2].[ID#] AS NVARCHAR(MAX))
ORDER BY
	[customer_timestamp]



SELECT * FROM 
	[BWSdb].[dbo].[CustomersV2]