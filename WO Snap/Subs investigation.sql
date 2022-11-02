USE SysproCompanyA
GO

SELECT * FROM [WipJobAmendJnl] WHERE [Job] = '20054148'
SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [WO#] = '20054148'

SELECT * FROM [WipMaster] WHERE [Job] = '20054148'
SELECT * FROM [WipMaster+] WHERE [Job] = '20054148'
SELECT * FROM [WipJobAllLab] WHERE [Job] = '20054148'


SELECT * FROM [WipMaster] WHERE [JobDescription] <> [StockDescription]
SELECT * FROM [WipMaster] WHERE [Job] = '10015654'