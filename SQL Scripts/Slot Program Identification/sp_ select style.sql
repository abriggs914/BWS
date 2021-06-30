USE [BWSdb]
GO

DECLARE @StartDate DATETIME = '2021-06-29';
DECLARE @SlotStatus INT = 2;


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
		[Dealers].[COMPANY NAME],
		[Slot Types] AS [Slot Type],
		[GROUPING],
		[Label],
		[Dealers].[Initials], 
		[LabelTtl],
		[Slot Status],
		YEAR([Slot Date]) AS [Year],
		DateName(mm, [Slot Date]) AS [Month],
		COUNT(*) AS [# Slots]
	FROM
		[SlotTypes] WITH (NOLOCK)
	INNER JOIN
		[Dealers]
	ON
		[Dealers].[ID] = [SlotTypes].[Dealer]
	INNER JOIN 
		[v_Dealer Totals Breakdown]
	ON
		[Dealers].[Initials] = [v_Dealer Totals Breakdown].[Initials]
	WHERE
		[Slot Types] IS NOT NULL
		AND [Slot Date] >= @StartDate
		AND (
			[Slot Status] = @SlotStatus
			OR @SlotStatus = 2
		)
	GROUP BY
		[Dealers].[COMPANY NAME], [Slot Types], [GROUPING], [Label], [Dealers].[Initials], [LabelTtl], [Slot Status], [Slot Date]
) AS [SourceTable]
PIVOT (
	SUM([# Slots])
	FOR 
		[Month]
	IN
		(
			[January],
			[February],
			[March],
			[April],
			[May],
			[June],
			[July],
			[August],
			[September],
			[October],
			[November],
			[December]
		)
) AS PivotTable
ORDER BY
	[COMPANY NAME], [Slot Type]
;