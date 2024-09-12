SELECT
	[O2].[SGQuote]
	, [O2].[Model No]
	, [O2].[Available Date]
	, [O2].[JobAvailableLine]
	, [O2].[JobAvailableScheduled]
	, [O2].[JobAvailableScheduledBy]
	, *
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
WHERE
	[O2].[Available Date] IS NOT NULL
ORDER BY
	[O2].[Available Date] DESC

-- Make sure that no already scheduled units appear in the combobox