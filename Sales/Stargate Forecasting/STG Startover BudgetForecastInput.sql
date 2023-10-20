USE BWSdb
GO

BEGIN TRAN;

SELECT
	*
FROM
	[Budget Forecast V2 Master]
WHERE
	[CompanyID] = 1
;

DELETE FROM
	[Budget Forecast V2 Master]
WHERE [CompanyID] = 1
;

SELECT
	*
FROM
	[Budget Forecast V2 Master]
WHERE
	[CompanyID] = 1
;

ROLLBACK;
COMMIT;