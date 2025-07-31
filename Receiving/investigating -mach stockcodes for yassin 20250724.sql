SELECT * FROM [SysproCompanyA].[dbo].[PorMasterDetail] [P] WHERE [P].[PurchaseOrder] = '000000000149168'
SELECT * FROM [SysproCompanyA].[dbo].[PorMasterDetail] [P] WHERE [P].[PurchaseOrder] = '000000000149268'
SELECT * FROM [BWSdb].[dbo].[ITR Pushes]  
SELECT * FROM [BWSdb].[dbo].[ADG Events] WHERE ([CtlClicked] = 'Command286') OR ([CtlClicked] = 'Command287')



BEGIN TRAN;
UPDATE [BWSdb].[dbo].[REC_POReceivedSubs]
SET [Active] = 0, [LastSent] = GETDATE()
WHERE [ID] = 19
ROLLBACK;
COMMIT;