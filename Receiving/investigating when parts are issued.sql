DECLARE @j NVARCHAR(1024) = '10017453'

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
WHERE
	[WM].[Job] = @j
;

SELECT
	[JP].[TrnDate],
	[JP].[MStockCode],
	[JP].[MQtyIssued],
	[JP].[TrnValue],
	[JP].[LTrnTime],
	[JP].[Journal],
	*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
WHERE
	[JP].[Job] = @j