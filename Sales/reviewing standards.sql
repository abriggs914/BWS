USE BWSdb
GO

DECLARE @q AS NVARCHAR(MAX) = 'SG101115';

SELECT * FROM [StandardsV2] WHERE [Model No] = 'End Dump 4X';

SELECT * FROM [OrdersV2] WHERE [SGQuote] = @q;

SELECT * FROM [Order StandardsV2] WHERE [SGQuote] = @q;

SELECT 
	DISTINCT [OrdersV2].[SGQuote]
FROM 
	[OrdersV2]
LEFT JOIN
	[Order StandardsV2] 
ON
	[OrdersV2].[SGQuote] = [Order StandardsV2].[SGQuote]
WHERE
	[Order StandardsV2].[SGQuote] IS NULL 
;