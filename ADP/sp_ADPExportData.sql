USE [BWSdb]
GO
SELECT * FROM [dbo].[v_ADPExportFileName]

USE SysproCompanyA
GO
EXEC [dbo].[sp_ADPExportData] @sd='2022-02-01', @ed='2022-02-02'

