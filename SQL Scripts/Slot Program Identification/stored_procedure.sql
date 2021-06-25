USE BWSdb
GO

IF EXISTS (SELECT 1 FROM SYS.procedures where name ='GetSlotReport')
BEGIN
DROP PROCEDURE [GetSlotReport]
END
GO
 
CREATE PROCEDURE [GetSlotReport]
	(@StartDate Date)
AS
BEGIN
	-- Monthly slot counts for each dealer
	WITH SlotTypes AS (
		SELECT
			ROW_NUMBER() OVER (
				PARTITION BY [Dealer], [Slot Types]
				ORDER BY [Dealer] ASC
			) AS row_num, *
		FROM
			[Production Slots]
	)
	
	SELECT 
		[Dealers].[COMPANY NAME], [Slot Types], DateName(mm, [Slot Date]) AS [Month], COUNT(*) AS [# Slots]
	FROM
		SlotTypes WITH (NOLOCK)
	INNER JOIN
		[Dealers]
	ON
		[Dealers].[ID] = [SlotTypes].[Dealer]
	WHERE 
		[Slot Date] >= @StartDate
	GROUP BY
		[Dealers].[COMPANY NAME], [Slot Types], [Slot Date]
	ORDER BY
		[Dealers].[COMPANY NAME], [Slot Types], [Slot Date]
END
;
GO

PIVOT
EXEC
	[GetSlotReport]
		@StartDate = '0001-01-01'
;
