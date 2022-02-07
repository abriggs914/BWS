USE BWSdb
GO

DECLARE @SD AS DATETIME;
SET @SD = '2021-08-23';
DECLARE @DN AS VARCHAR(25);
SET @DN = '%Demountable%'

SELECT
	[Production Slots].[Slot Type],
	[Dealers].[COMPANY NAME]
FROM 
	[Production Slots]
INNER JOIN
	[Dealers]
ON
	[Dealers].[ID] = [Production Slots].[Dealer]
WHERE
	[Slot Date] >= @SD
	AND [Dealers].[COMPANY NAME] LIKE @DN
GROUP BY
	[Production Slots].[Slot Type],
	[Dealers].[COMPANY NAME]
ORDER BY
	[Production Slots].[Slot Date]