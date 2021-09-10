USE BWSdb
GO

SELECT	
	*
FROM
	[Orders] WITH (NOLOCK)
ORDER BY
	[Quote#] DESC
	
SELECT
	[ID]
FROM
	[Dealers]
;

DECLARE @I AS INTEGER = 0;

exec sp_DealerStatusReportV2 330