SELECT
	*
FROM (
	SELECT 
		*
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	FULL JOIN
		[SysproCompanyA].[dbo].[WipMaster] [Master] WITH (NOLOCK)
	ON
		CAST([O].[WO#] AS NVARCHAR(MAX)) = CAST([Master].[Job] AS NVARCHAR(MAX))
	WHERE
		([O].[WO#] IS NOT NULL)
		AND ([O].[Decline/Rejected] = 4)
		AND ([O].[Quote Date] IS NULL)
		AND ([O].[Order Date] IS NULL)
		AND ([O].[Date Declined] IS NULL)
		AND ([Master].[JobStartDate] IS NULL)
		AND ([Master].[ActCompleteDate] IS NULL)
		AND ([O].[Invoice Date] IS NULL)
		AND ([O].[Shipped Date] IS NULL)
		AND ([O].[Delivery Date] IS NULL)
		AND ([O].[Date In Service] IS NULL)
		AND ([O].[Date Registered] IS NULL)
		AND ([O].[BWSPaidDate] IS NULL)
		AND ([O].[PDD] IS NULL)
) AS [Src]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost]
ON
	[Src].[Job] = [WipJobPost].[Job]
ORDER BY
	[WO#] DESC

SELECT 
	*
FROM
	[BWSdb].[dbo].[Orders] WITH (NOLOCK)
ORDER BY
	[Quote Date] DESC

SELECT
	*
FROM (
	SELECT
		/*[O].[Quote#]
		,[O].[WO#]
		,*/
		[C].[Date]
		,COUNT([O].[Quote Date]) AS [CountDateQuote]
		,COUNT([O].[Order Date]) AS [CountDateOrder]
		,COUNT([O].[Date Declined]) AS [CountDateDeclined]
		,COUNT([Master].[JobStartDate]) AS [CountDateJobStart]
		,COUNT([Master].[ActCompleteDate]) AS [CountDateActComplete]
		,COUNT([O].[Invoice Date]) AS [CountDateInvoice]
		,COUNT([O].[Shipped Date]) AS [CountDateShipped]
		,COUNT([O].[Delivery Date]) AS [CountDateDelivery]
		,COUNT([O].[Date In Service]) AS [CountDateInService]
		,COUNT([O].[Date Registered]) AS [CountDateRegistered]
	FROM
		[BWSdb].[dbo].[Calendar] [C] WITH (NOLOCK)
	FULL JOIN
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	ON
		ISNULL([O].[Quote Date],
			ISNULL([O].[Order Date],
				ISNULL([O].[Date Declined],
					--ISNULL([Master].[JobStartDate],
						--ISNULL([Master].[ActCompleteDate],
							ISNULL([O].[Invoice Date],
								ISNULL([O].[Shipped Date],
									ISNULL([O].[Delivery Date],
										ISNULL([O].[Date In Service], 
											ISNULL([O].[Date Registered], 
												ISNULL([O].[BWSPaidDate], [O].[PDD])
											)
										)
									)
								)
							)
						--)
					--)
				)
			)
		) = [C].[Date]
	FULL JOIN
		[SysproCompanyA].[dbo].[WipMaster] [Master] WITH (NOLOCK)
	ON
		CAST([O].[WO#] AS NVARCHAR(MAX)) = CAST([Master].[Job] AS NVARCHAR(MAX))
	WHERE
		([O].[WO#] IS NOT NULL)
		AND ([O].[Decline/Rejected] = 4)
		--(LEFT([Master].[Job], 1) = '1')
		--AND LEN([Master].[Job]) = 8
	GROUP BY
		/*[O].[Quote#]
		,[O].[WO#]
		,*/
		[C].[Date]
		/*,[O].[Quote Date]
		,[O].[Order Date]
		,[O].[Date Declined]
		,[Master].[JobStartDate]
		,[Master].[ActCompleteDate]
		,[O].[Invoice Date]
		,[O].[Shipped Date]
		,[O].[Delivery Date]
		,[O].[Date In Service]
		,[O].[Date Registered]*/
) AS [Src]
WHERE
	(
		[CountDateQuote]
		+ [CountDateOrder]
		+ [CountDateDeclined]
		+ [CountDateJobStart]
		+ [CountDateActComplete]
		+ [CountDateInvoice]
		+ [CountDateShipped]
		+ [CountDateDelivery]
		+ [CountDateInService]
		+ [CountDateRegistered]
	) > 0
ORDER BY
	[Date] DESC
;

/*
SELECT
	[Job]
FROM
	[SysproCompanyA].[dbo].[WipMaster] [Master]
WHERE
	LEFT([Master].[Job], 1) = '1'
GROUP BY
	[Job]
ORDER BY
	[Job]
;

SELECT
	[WO#]
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	LEFT([O].[WO#], 1) = '1'
GROUP BY
	[WO#]
ORDER BY
	[WO#]
*/

SELECT
	[JobStartDate]
FROM
	[SysproCompanyA].[dbo].[WipMaster] [Master] WITH (NOLOCK)
WHERE
	LEFT([Master].[Job], 1) = '1'
GROUP BY
	[JobStartDate]
ORDER BY
	[JobStartDate]