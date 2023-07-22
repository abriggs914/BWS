USE BWSdb
GO

-- All Customers for delivered units between June 1st 2022 and June 1st 2023

DECLARE @sd AS DATETIME = '2022-06-01';
DECLARE @ed AS DATETIME = '2023-06-01 23:59:59';

DECLARE @results AS TABLE (
	[ID] INT IDENTITY(0, 1)
	,[DealerID] INT
	,[POn] NVARCHAR(MAX)
	,[Quote] INT
	,[WO] INT
	,[ModelNo] NVARCHAR(MAX)
	,[QuoteDate] DATETIME
	,[OrderDate] DATETIME
	,[CustWO] INT
	,[SOn] INT
	,[DealerName] NVARCHAR(MAX)
	,[DealerInitials] NVARCHAR(MAX)
	,[DealerAddress] NVARCHAR(MAX)
	,[DealerCity] NVARCHAR(MAX)
	,[DealerProvince] NVARCHAR(MAX)
	,[DealerContact] NVARCHAR(MAX)
	,[DealerEmail] NVARCHAR(MAX)
	,[DealerPhone] NVARCHAR(MAX)
	,[CustomerName] NVARCHAR(MAX)
	,[CustomerContact] NVARCHAR(MAX)
	,[CustomerAddress] NVARCHAR(MAX)
	,[CustomerCity] NVARCHAR(MAX)
	,[CustomerProvince] NVARCHAR(MAX)
	,[CustomerEmail] NVARCHAR(MAX)
	,[CustomerPhone] NVARCHAR(MAX)
)

INSERT INTO @results (
	[DealerID]
	,[POn] 
	,[Quote]
	,[WO]
	,[ModelNo]
	,[QuoteDate]
	,[OrderDate]
	,[CustWO]
	,[SOn]
	,[DealerName]
	,[DealerInitials]
	,[DealerAddress]
	,[DealerCity]
	,[DealerProvince]
	,[DealerContact]
	,[DealerEmail]
	,[DealerPhone]
	,[CustomerName]
	,[CustomerContact]
	,[CustomerAddress]
	,[CustomerCity]
	,[CustomerProvince]
	,[CustomerEmail]
	,[CustomerPhone]
)
SELECT
	[DealerID]
	,[Purchase Order]
	,[A].[Quote#]
	,[A].[WO#]
	,[Model No]
	,[Quote Date]
	,[Order Date]
	,[A].[Customer WO#]
	,[A].[Sales Order#]
	,[B].[COMPANY NAME] AS [DealerName]
	,[B].[Initials] AS [DealerInitials]
	,[B].[ADDRESS] AS [DealerAddress]
	,[B].[CITY] AS [DealerCity]
	,[B].[PROVINCE] AS [DealerProvince]
	,[B].[CONTACT] AS [DealerContact]
	,[B].[EMAIL] AS [DealerEmail]
	,[B].[PHONE] AS [DealerPhone]
	,[C].[Customer] AS [CustomerName]
	,[C].[Contact] AS [CustomerContact]
	,[C].[Address] AS [CustomerAddress]
	,[C].[City] AS [CustomerCity]
	,[C].[Province/State] AS [CustomerProvince]
	,[C].[Email] AS [CustomerEmail]
	,[C].[Phone] AS [CustomerPhone]
FROM
	[Orders] AS [A]
LEFT JOIN
	[Dealers] AS [B]
ON
	[A].[DealerID] = [B].[ID]
LEFT JOIN
	[Customers] AS [C]
ON
	[A].[WO#] = [C].[WO#]

WHERE
	[A].[Delivery Date] BETWEEN @sd AND @ed

SELECT
	*
FROM
	@results
WHERE
	[CustomerEmail] IS NOT NULL
	--OR
	--[DealerEmail] IS NOT NULL
;
SELECT
	[CustomerContact]
	,[CustomerName]
	,[CustomerEmail]
	,[DealerInitials]
	,[DealerName]
	,[DealerContact]
	,[DealerEmail]
FROM
	@results
WHERE
	[CustomerEmail] IS NOT NULL
	OR [DealerEmail] IS NOT NULL
GROUP BY
	[CustomerContact]
	,[CustomerName]
	,[CustomerEmail]
	,[DealerInitials]
	,[DealerName]
	,[DealerContact]
	,[DealerEmail]
;

SELECT DISTINCT
	[CustomerName]
	,[CustomerContact]
	,[CustomerEmail]
FROM
	@results 
WHERE
	[CustomerEmail] IS NOT NULL
ORDER BY
	[CustomerEmail]
;

SELECT DISTINCT
	[CustomerName]
	,[CustomerContact]
	,[CustomerEmail]
FROM
	@results 
WHERE
	[CustomerEmail] IS NOT NULL
	AND [CustomerName] LIKE '%chiac%'
ORDER BY
	[CustomerEmail]
;