USE SysproCompanyA
GO

DECLARE @pn AS NVARCHAR(60);
SET @pn = '%TR-CLA-P006%';
--SET @pn = '%TR-CLA-P006%';

SELECT * FROM [InvMastAmendJnl] WITH (NOLOCK)
WHERE
	LOWER([StockCode]) LIKE LOWER(@pn)
ORDER BY [JnlDate] DESC