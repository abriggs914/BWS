
-- Testing fn_PartOrNoneIssued

DECLARE @sd DATETIME = '2025-09-18';
DECLARE @tlo BIT = 1;
DECLARE @op INT = 1;
DECLARE @j NVARCHAR(MAX) = '10017648';
DECLARE @sc NVARCHAR(MAX) = '544325048';

SELECT
	*
FROM
	[BWSdb].[dbo].[fn_PartOrNoneIssued](@sd, @tlo) [PNO]
WHERE
	[PNO].[Job] = @j

SELECT
	*
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
WHERE
	[YT].[StockCode] = @sc