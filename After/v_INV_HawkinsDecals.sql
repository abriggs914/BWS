
-- 2026-01-29 - Avery Briggs - Specific selection of Decals in the Hawkins parts room decal shelf.
--								Adds ability to sort these stockcodes by bin location more accurately.

CREATE VIEW
	[dbo].[v_INV_HawkinsDecals]
AS

	SELECT
		[IW].[StockCode],
		[IW].[DefaultBin],
		/*[IW].[IdxDash],
		LEN([IW].[DefaultBin]) AS [LEN],*/
		(CASE
			WHEN LEFT([IW].[DefaultBin], 3) = 'I19' THEN '0'
			WHEN [IdxDash] > 0 THEN SUBSTRING([IW].[DefaultBin], 2, [IW].[IdxDash] - 2)
			ELSE [IW].[DefaultBin] 
		END) AS [IRow],
		(CASE
			WHEN LEFT([IW].[DefaultBin], 3) = 'I19' THEN '0'
			WHEN [IdxDash] > 0 THEN SUBSTRING([IW].[DefaultBin], [IW].[IdxDash] + 1, LEN([IW].[DefaultBin]) - [IW].[IdxDash])
			ELSE [IW].[DefaultBin] 
		END) AS [ICol]
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
;