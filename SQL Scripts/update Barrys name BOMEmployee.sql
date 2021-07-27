
BEGIN TRAN;

SELECT * FROM [SysproCompanyA].[dbo].[BomEmployee] WHERE [Employee] LIKE '%100047%'
UPDATE
	[SysproCompanyA].[dbo].[BomEmployee]
SET
	[Name] = 'BLANEY, BARRY'
WHERE 
	[Employee] LIKE '%100047%'

SELECT * FROM [SysproCompanyA].[dbo].[BomEmployee] WHERE [Employee] LIKE '%100047%'

ROLLBACK;
COMMIT;