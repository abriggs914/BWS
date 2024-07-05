USE BWSdb
GO

BEGIN TRAN;


DECLARE @wo INT = 10017013;

SELECT
	[O].[Available Date],
	[O].[Finish Date],
	[O].[Delivery Date],
	*
FROM
	[Orders] [O]
WHERE
	[WO#] = @wo

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[Delivery Date] = (CASE
		WHEN ISNULL([Finish Date], [Available Date]) IS NULL THEN NULL
		WHEN [Finish Date] IS NOT NULL THEN [SysproCompanyA].[dbo].[GetNthBusinessDay]([Finish Date], 3)
		ELSE [SysproCompanyA].[dbo].[GetNthBusinessDay]([Available Date], 3)
	END)
WHERE
	[WO#] = @wo

ROLLBACK;
COMMIT;