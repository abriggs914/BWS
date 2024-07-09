

	
SELECT
	[SGQuote]
	,[Delivery Date]
	,[Available Date]
	,[Finish Date]
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
	
SELECT
	[Quote#]
	,[Delivery Date]
	,[Available Date]
	,[Finish Date]
FROM (
	SELECT
		*
	FROM
		[BWSdb].[dbo].[Orders] [O]
	WHERE
		(YEAR(ISNULL([Finish Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1)
		OR YEAR(ISNULL([Available Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1)
		OR YEAR(ISNULL([Delivery Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1))
) AS [Src]
WHERE
	((CASE
		WHEN (([Finish Date] IS NULL) AND ([Available Date] IS NULL)) THEN 
			(CASE
				WHEN ([Delivery Date] IS NULL) THEN 0
				ELSE 1
			END)
		ELSE 
			(CASE
				WHEN ([Finish Date] IS NOT NULL) THEN
					(CASE
						WHEN [Delivery Date] IS NULL THEN 1
						ELSE
							(CASE
								WHEN [SysproCompanyA].[dbo].[GetNthBusinessDay]([Finish Date], 3) < [Delivery Date] THEN 1
								ELSE 0
							END)
					END)
				WHEN ([Available Date] IS NOT NULL) THEN
					(CASE
						WHEN [Delivery Date] IS NULL THEN 1
						ELSE
							(CASE
								WHEN [SysproCompanyA].[dbo].[GetNthBusinessDay]([Available Date], 3) < [Delivery Date] THEN 1
								ELSE 0
							END)
					END)
			END)
	END) = 1)


SELECT
	[SysproCompanyA].[dbo].[GetNthBusinessDay](GETDATE(), 1) AS [1],
	[SysproCompanyA].[dbo].[GetNthBusinessDay](GETDATE(), 2) AS [2],
	[SysproCompanyA].[dbo].[GetNthBusinessDay](GETDATE(), 3) AS [3],
	[SysproCompanyA].[dbo].[GetNthBusinessDay](GETDATE(), 4) AS [4],
	[SysproCompanyA].[dbo].[GetNthBusinessDay](GETDATE(), 5) AS [5],
	[SysproCompanyA].[dbo].[GetNthBusinessDay](GETDATE(), 6) AS [6]


BEGIN TRAN;

SELECT
	[SGQuote]
	,[WO#]
	,[Delivery Date]
	,[Available Date]
	,[Finish Date]
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	(CASE WHEN [Delivery Date] IS NOT NULL THEN (CASE WHEN ([Delivery Date] < DATEADD(MONTH, -6, GETDATE())) THEN 0 ELSE 1 END) ELSE 0 END) = 1
	AND
	(YEAR(ISNULL([Finish Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1)
	OR YEAR(ISNULL([Available Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1)
	OR YEAR(ISNULL([Delivery Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1))
;

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Delivery Date] = (
		CASE
			WHEN (([Available Date] IS NULL) AND ([Delivery Date] IS NULL)) THEN NULL
			WHEN ([Available Date] IS NOT NULL) THEN [SysproCompanyS].[dbo].[GetNthBusinessDay]([Available Date], 3)
			ELSE [Delivery Date]
		END
	)
	/*
	[Delivery Date] = (
		CASE
			WHEN (([Finish Date] IS NULL) AND ([Available Date] IS NULL) AND ([Delivery Date] IS NULL)) THEN NULL
			WHEN ([Finish Date] IS NOT NULL) THEN [SysproCompanyS].[dbo].[GetNthBusinessDay]([Finish Date], 3)
			WHEN ([Available Date] IS NOT NULL) THEN [SysproCompanyS].[dbo].[GetNthBusinessDay]([Available Date], 3)
			ELSE [Delivery Date]
		END
	)
	*/
WHERE
	(CASE WHEN [Delivery Date] IS NOT NULL THEN (CASE WHEN ([Delivery Date] < DATEADD(MONTH, -6, GETDATE())) THEN 0 ELSE 1 END) ELSE 0 END) = 1
	AND
	(YEAR(ISNULL([Finish Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1)
	OR YEAR(ISNULL([Available Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1)
	OR YEAR(ISNULL([Delivery Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1))
;


SELECT
	[SGQuote]
	,[WO#]
	,[Delivery Date]
	,[Available Date]
	,[Finish Date]
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	(CASE WHEN [Delivery Date] IS NOT NULL THEN (CASE WHEN ([Delivery Date] < DATEADD(MONTH, -6, GETDATE())) THEN 0 ELSE 1 END) ELSE 0 END) = 1
	AND
	(YEAR(ISNULL([Finish Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1)
	OR YEAR(ISNULL([Available Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1)
	OR YEAR(ISNULL([Delivery Date], DATEADD(YEAR, -2, GETDATE()))) >= (YEAR(GETDATE()) - 1))


ROLLBACK;
COMMIT;