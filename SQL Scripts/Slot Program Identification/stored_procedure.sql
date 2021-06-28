USE BWSdb
GO
/*
IF EXISTS (SELECT 1 FROM SYS.procedures where name ='GetSlotReport')
BEGIN
DROP PROCEDURE [GetSlotReport]
END
GO
 
CREATE PROCEDURE [GetSlotReport]
	@StartDate AS Date,
	@SlotStatus AS Int = 1
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
		*
	FROM (
		SELECT 
			[Dealers].[COMPANY NAME], [Slot Types] AS [Slot Type], DateName(mm, [Slot Date]) AS [Month], COUNT(*) AS [# Slots]
		FROM
			SlotTypes WITH (NOLOCK)
		INNER JOIN
			[Dealers]
		ON
			[Dealers].[ID] = [SlotTypes].[Dealer]
		WHERE
			[Slot Types] IS NOT NULL
			AND [Slot Date] >= @StartDate
			AND [Slot Status] = @SlotStatus
		GROUP BY
			[Dealers].[COMPANY NAME], [Slot Types], [Slot Date]
	) AS [SourceTable]
	PIVOT (
		SUM([# Slots])
		FOR [Month] IN ([January], [February], [March], [April], [May], [June], [July], [August] ,[September], [October], [November], [December])
	) AS PivotTable
	ORDER BY
		[COMPANY NAME], [Slot Type]
END
;
GO

--PRINT 'Get slot Report 2021-06-30, Slot status=0'
EXEC
	[GetSlotReport]
		@StartDate = '2021-06-30',
		@SlotStatus = 0
;

--PRINT 'Get slot Report 2021-06-30, Slot status=1'
EXEC
	[GetSlotReport]
		@StartDate = '2021-06-30',
		@SlotStatus = 1
;
*/