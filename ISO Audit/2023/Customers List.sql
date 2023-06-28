USE BWSdb
GO

-- All Customers for delivered units between June 1st 2022 and June 1st 2023

DECLARE @sd AS DATETIME = '2022-06-01';
DECLARE @ed AS DATETIME = '2023-06-01 23:59:59';

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