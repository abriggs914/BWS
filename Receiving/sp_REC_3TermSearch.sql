USE [BWSdb]
GO

-- 2025-08-21 - Avery Briggs - Simple format to search known parts by up to 3 terms.
--								Condsiders [Description] and [LongDescription] fields of [SysproCompanyA].[dbo].[InvMaster]

CREATE PROCEDURE [dbo].[sp_REC_3TermSearch]
	@st1 NVARCHAR(MAX) = NULL,
	@st2 NVARCHAR(MAX) = NULL,
	@st3 NVARCHAR(MAX) = NULL
AS
BEGIN

	SELECT
		*
	FROM (
		SELECT
			[IW].[StockCode],
			[IM].[Description],
			[IM].[LongDesc],
			[IW].[DefaultBin],
			[IW].[QtyOnHand],
			[IW].[QtyAllocated],
			[IW].[QtyAllocatedToPick],
			[IW].[QtyAllocatedWip],
			[IW].[UnitCost],
			[IW].[DateLastSale]

			, LOWER(ISNULL([IM].[Description], '') + ISNULL([IM].[LongDesc], '')) AS [Desc]
		FROM
			[SysproCompanyA].[dbo].[InvWarehouse] [IW]
		INNER JOIN
			[SysproCompanyA].[dbo].[InvMaster] [IM]
		ON
			[IW].[StockCode] = [IM].[StockCode]
		/*WHERE
			LEFT(LOWER([IW].[DefaultBin]), 3) = 'f36'*/
	) AS [Src]
	WHERE
		((CASE WHEN @st1 IS NULL THEN 1 ELSE (CASE WHEN [Desc] LIKE '%' + @st1 + '%' THEN 1 ELSE 0 END) END) * 
		(CASE WHEN @st2 IS NULL THEN 1 ELSE (CASE WHEN [Desc] LIKE '%' + @st2 + '%' THEN 1 ELSE 0 END) END) *
		(CASE WHEN @st3 IS NULL THEN 1 ELSE (CASE WHEN [Desc] LIKE '%' + @st3 + '%' THEN 1 ELSE 0 END) END)) > 0
END