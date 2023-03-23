USE BWSdb
GO

DECLARE @eRes AS TABLE ([New SN] NVARCHAR(17));
DECLARE @t AS TABLE ([ID] INT IDENTITY(0, 1), [Quote] NVARCHAR(MAX), [New SN] NVARCHAR(17));
INSERT INTO @t ([Quote])
SELECT TOP 5
	[O].[SGQuote]
FROM
	[OrdersV2] AS [O]
LEFT JOIN
	[DealersV2] AS [D]
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[Sales Staff] AS [S]
ON
	[O].[Sale PersonID] = [S].[ID-SaleStaff]
WHERE
	[Delivery Date] >= '2023-04-01'
	AND [Date Declined] IS NULL
ORDER BY
	ISNULL([Delivery Date], [Requested Delivery Date])
;

SELECT * FROM @t

DECLARE @quote AS NVARCHAR(MAX);
DECLARE @newSN AS NVARCHAR(MAX);
DECLARE @i AS INT = 0;
DECLARE @c AS INT;
SELECT @c = COUNT(*) FROM @t;

WHILE @i < @c BEGIN

	SELECT @quote = [Quote] FROM @t WHERE [ID] = @i;
	--INSERT INTO @eRes 
	EXEC sp_SerialNumberCalcSTG @quote=@quote, @year=2024, @mode=3;

	UPDATE
		@t
	SET
		[New SN] = @newSN
	WHERE
		[ID] = @i
	;
	SELECT @i = @i + 1;
END


SELECT * FROM @t

--SELECT
--	[O].[SGQuote]
--	,[O].[Quote Date]
--	,[O].[Order Date]
--	,[O].[WO#]
--	,[O].[Model No]
--	--,[O].[Sale PersonID]
--	,[S].[Sales Person]
--	,[O].[Price]
--	,[O].[Serial Number] AS [OLD SN]
--	,[NewSN] AS [OLD SN]
--	,[O].[Available Date]
--	,[O].[Delivery Date]
--	,[O].[Requested Delivery Date]
--	--,[O].[DealerID]
--	,[D].[COMPANY NAME] AS [Dealer]
--	,(CASE WHEN [O].[US Sale] = 1 THEN 'Y' ELSE 'N' END) AS [US Sale]
--	,[O].[Notes]
--	--, *
--FROM
--	[OrdersV2] AS [O]
--LEFT JOIN
--	[DealersV2] AS [D]
--ON
--	[O].[DealerID] = [D].[ID]
--LEFT JOIN
--	[Sales Staff] AS [S]
--ON
--	[O].[Sale PersonID] = [S].[ID-SaleStaff]
--WHERE
--	[Delivery Date] >= '2023-04-01'
--	AND [Date Declined] IS NULL
--ORDER BY
--	ISNULL([Delivery Date], [Requested Delivery Date])
;