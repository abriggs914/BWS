-- Set everyone to the day shift for today 2022-03-04


BEGIN TRAN;
SELECT * FROM [SysproCompanyA].[dbo].[ClkEmployee]

UPDATE
	[SysproCompanyA].[dbo].[ClkEmployee]
SET
	[ShiftID] = 42

SELECT * FROM [SysproCompanyA].[dbo].[ClkEmployee]

ROLLBACK;
COMMIT;