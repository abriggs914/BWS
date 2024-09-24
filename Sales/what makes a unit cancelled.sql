SELECT
	'Cancelled by in valid code',
	*
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
WHERE
	[O2].[Decline/Rejected] <> 4
;

SELECT
	'Cancelled by invalid date set',
	*
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
WHERE
	[O2].[Date Declined] IS NOT NULL
;

SELECT
	'Cancelled but both columns dont match',
	'by code',
	*
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
WHERE
	[O2].[Decline/Rejected] <> 4
	AND [O2].[Date Declined] IS NULL
;

SELECT
	'Cancelled but both columns dont match',
	'by date',
	*
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
WHERE
	[O2].[Decline/Rejected] = 4
	AND [O2].[Date Declined] IS NOT NULL
;