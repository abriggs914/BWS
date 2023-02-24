USE SysproCompanyS
GO

BEGIN TRAN;

UPDATE 
	[ClkFrmConfirmUser]
SET
	[FrmOpenedByUser] = NULL
	, [FrmOpenDate] = NULL
	, [IsFrmOpen] = 0

SELECT IsFrmOpen, FrmOpenedByUser, FrmOpenDate FROM ClkFrmConfirmUser;

ROLLBACK;
COMMIT;