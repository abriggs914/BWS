
DECLARE @dealer AS VARCHAR(25);
SET @dealer = '%Demountable%'
/*
SELECT DATENAME(MONTH, [Slot Date]) + ' ' + CAST(YEAR([Slot Date]) AS VARCHAR(4))  AS [Date], * FROM 
		dtProductionSchedule WITH (NOLOCK)
	INNER JOIN 
		[Production Slots] WITH (NOLOCK)
	ON
		dtProductionSchedule.Slot# = [Production Slots].PSlotID#
	INNER JOIN
		Dealers with (nolock)
	ON
		[Production Slots].Dealer = Dealers.ID
	WHERE
		dtProductionSchedule.Quote# IS NULL
		AND [Slot/Quote] = 1
		AND [COMPANY NAME] LIKE @dealer
		*/


SELECT
	[Date],
	[Date_abbrev],
	[Slot Types],
	COUNT(*) AS [# Slots],
	[Y#],
	[M#]
FROM (
	SELECT
		[Slot#],
		[Slot Types],
		'Confirm Quote by ' + DATENAME(MONTH, CASE WHEN [Prod Date 1] is null THEN DATEADD(DAY, -120, [Prod Date 2]) ELSE DATEADD(DAY, -120, [Prod Date 1]) END) + ' '
													   + CAST(DATEPART(DAY, CASE WHEN [Prod Date 1] IS NULL THEN DATEADD(DAY, -120, [Prod Date 2]) ELSE DATEADD(DAY, -120, [Prod Date 1]) END) AS NVARCHAR) + ', '
													   + CAST(DATEPART(YEAR, CASE WHEN [Prod Date 1] IS NULL THEN DATEADD(DAY, -120, [Prod Date 2]) ELSE DATEADD(DAY, -120, [Prod Date 1]) END) AS NVARCHAR) AS [SerialNumber],
		@dealer AS [Company Name],
		dbo.fn_SlotEstimatedDeliveryDate(CASE WHEN [Prod Date 1] IS NULL THEN [Prod Date 2] ELSE [Prod Date 1] END) AS DeliveryDate,
		DATENAME(MONTH, [Slot Date]) + ' ' + CAST(YEAR([Slot Date]) AS VARCHAR(4))  AS [Date],
		CONVERT(CHAR(3), [Slot Date], 0) + ' ' + CAST(YEAR([Slot Date]) AS VARCHAR(4))  AS [Date_abbrev],
		MONTH([Slot Date]) AS [M#],
		YEAR([Slot Date]) AS [Y#]
	FROM 
		[dtProductionSchedule] WITH (NOLOCK)
	INNER JOIN 
		[Production Slots] WITH (NOLOCK)
	ON
		[dtProductionSchedule].[Slot#] = [Production Slots].[PSlotID#]
	INNER JOIN
		[Dealers] with (nolock)
	ON
		[Production Slots].[Dealer] = [Dealers].[ID]
	WHERE
		[dtProductionSchedule].[Quote#] IS NULL
		AND [Slot/Quote] = 1
		AND [COMPANY NAME] LIKE @dealer
) AS [SrcTable]
GROUP BY
	[Slot Types],
	[Date],
	[Date_abbrev],
	[Y#],
	[M#]
ORDER BY
	[Y#],
	[M#]
