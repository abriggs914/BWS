--EXEC [SysproCompanyA].[dbo].[sp_TopLevelWOReportJamie] @WO='10015300', @INCOMPLETEONLY = 0, @WAREHOUSE=NULL, @OPERATION='4;5', @PARTCATEGORY='M';
--EXEC [SysproCompanyA].[dbo].[sp_TopLevelWOReportJamie] @WO='10009384', @INCOMPLETEONLY=0, @PARTCATEGORY='M', @OPERATION='4;5', @WAREHOUSE='4;6';
--EXEC [SysproCompanyA].[dbo].[sp_TopLevelWOReportJamie] @WO='10015300', @INCOMPLETEONLY=0, @PARTCATEGORY='M', @OPERATION='4;5', @WAREHOUSE='4;6';
--EXEC [SysproCompanyA].[dbo].[sp_TopLevelWOReportJamie] @WO='10015400', @INCOMPLETEONLY=0, @PARTCATEGORY='M', @OPERATION='4;5', @WAREHOUSE='4;6';
EXEC [SysproCompanyA].[dbo].[sp_TopLevelWOReportJamie] @WO='10015595', @INCOMPLETEONLY=0, @PARTCATEGORY='M', @OPERATION='1;2;4;5', @WAREHOUSE='4;6';
EXEC [SysproCompanyA].[dbo].[sp_TopLevelWOReportJamie] @WO='10015595', @INCOMPLETEONLY=0, @PARTCATEGORY='M', @WAREHOUSE='4;6';
EXEC [SysproCompanyA].[dbo].[sp_TopLevelWOReport] @WO='10015595', @INCOMPLETEONLY=0;

--SELECT * FROM [SysproCompanyA].[dbo].[WipJobAllMat] WHERE [StockCode] = '03746'
--SELECT * FROM [SysproCompanyA].[dbo].[InvMaster] WHERE [StockCode] = '03746'