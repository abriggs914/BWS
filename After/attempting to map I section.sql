
SELECT
	[IW].[StockCode],
	[IW].[DefaultBin],
	[IW].[IdxDash],
	LEN([IW].[DefaultBin]) AS [LEN],
	(CASE WHEN [IdxDash] > 0 THEN SUBSTRING([IW].[DefaultBin], 2, [IW].[IdxDash] - 1) ELSE [IW].[DefaultBin] END) AS [IRow],
	SUBSTRING([IW].[DefaultBin], [IW].[IdxDash], LEN([IW].[DefaultBin]) - [IW].[IdxDash]) AS [IRow]
FROM (
	SELECT
		LTRIM(RTRIM(UPPER([IW].[StockCode]))) AS [StockCode],
		LTRIM(RTRIM(UPPER([IW].[DefaultBin]))) AS [DefaultBin],
		(CASE
			WHEN CHARINDEX('-', LTRIM(RTRIM(UPPER([IW].[DefaultBin])))) = 0 THEN (
				CASE 
					WHEN CHARINDEX(' ', LTRIM(RTRIM(UPPER([IW].[DefaultBin])))) = 0 THEN
						CHARINDEX('I19', LTRIM(RTRIM(UPPER([IW].[DefaultBin]))))
					ELSE
						CHARINDEX(' ', LTRIM(RTRIM(UPPER([IW].[DefaultBin]))))
					END)
			ELSE CHARINDEX('-', LTRIM(RTRIM(UPPER([IW].[DefaultBin]))))
		END ) AS [IdxDash]
	FROM
		[SysproCompanyA].[dbo].[InvWarehouse] [IW]
	WHERE
		(LTRIM(RTRIM(UPPER([IW].[DefaultBin]))) LIKE 'I%')
		AND (LTRIM(RTRIM(UPPER([IW].[DefaultBin]))) NOT IN ('ISSUE', 'INFO', 'I BEAM', 'IBEAM'))
	GROUP BY
		LTRIM(RTRIM(UPPER([IW].[StockCode]))),
		LTRIM(RTRIM(UPPER([IW].[DefaultBin])))
) AS [IW]

SELECT
	*
FROM
	[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]
/*
BEGIN TRAN;


INSERT INTO
	[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]
([Section], [ShelfSectionID], [Shelf], [ShelfRow])
VALUES
('E', 64, 'VMI', 0)

ROLLBACK;
COMMIT;
*/