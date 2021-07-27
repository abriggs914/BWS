USE BWSdb
GO

DECLARE @DF_IDS AS TABLE ([DF_ID] INT);
INSERT INTO @DF_IDS VALUES 
	(4030),
	(4031),
	(4032),
	(4033),
	(4034),
	(4035),
	(4036),
	(4022),
	(4023),
	(4024),
	(4025),
	(4026),
	(4027),
	(4028),
	(4037),
	(4020),
	(4021)
;

SELECT
	*
FROM
	[Defects]
WHERE
	[DefectID#] IN (
		SELECT
			[DF_ID]
		FROM
			@DF_IDS
	)
;

DECLARE @EMPN AS INT = 437

SELECT
	*
FROM
	[Employees]
WHERE
	[Emp#] = @EMPN
;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[BomEmployee]
WHERE
	[Name] LIKE '%QUINN, M%'
;

BEGIN TRAN;

SELECT * FROM [Defects] WHERE [EmployeeID] = @EMPN;

UPDATE
	[Defects]
SET
	[EmployeeID] = 200000 + @EMPN
WHERE
	[EmployeeID] = @EMPN
;

SELECT * FROM [Defects] WHERE [EmployeeID] = 200000 + @EMPN;

ROLLBACK;
COMMIT;