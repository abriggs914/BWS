USE BWSdb
GO

-- dbo.sp_ProductionSlotsvsForecastRpt

SELECT * FROM [Production Slots];
SELECT * FROM [Dealers];

SELECT [Dealer], [Slot Types] FROM [Production Slots] GROUP BY [Dealer], [Slot Types] ORDER BY [DEALER];



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
GROUP BY
	[Dealers].[COMPANY NAME], [Slot Types], [Slot Date]
ORDER BY
	[Dealers].[COMPANY NAME], [Slot Types], [Slot Date]
;

/*
WITH TopSuppliers AS (
	SELECT
		ROW_NUMBER() OVER (
			PARTITION BY [Supplier]
			ORDER BY [Supplier] ASC
		) AS row_num, *
	FROM 
		[ApInvoicePay]
)
SELECT 
	*
FROM
	TopSuppliers WITH (NOLOCK)
WHERE
	TopSuppliers.[row_num] = 1
ORDER BY [JournalDate]

-- https://www.tutorialgateway.org/select-rows-with-maximum-value-on-a-column-in-sql-server/
*/

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
FROM
	(
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
		GROUP BY
			[Dealers].[COMPANY NAME], [Slot Types], [Slot Date]
	) AS [SourceTable]
PIVOT (
	SUM([# Slots])
	FOR [Month] IN ([January], [February], [March], [April], [May], [June], [July], [August] ,[September], [October], [November], [December])
) AS PivotTable
ORDER BY
	[COMPANY NAME], [Slot Type]
;
