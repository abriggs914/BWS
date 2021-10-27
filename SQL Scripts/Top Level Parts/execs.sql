USE SysproCompanyA
GO

--EXEC [dbo].[sp_TopLevelWOSubsReport] @WO = '10015243', @INCOMPLETEONLY = 0
--EXEC [dbo].[sp_TopLevelWOSubsReport] @WO = '10015243', @INCOMPLETEONLY = 1
--EXEC [dbo].[sp_TopLevelWOSubsReport] @WO = '10014841', @INCOMPLETEONLY = 0
--EXEC [dbo].[sp_TopLevelWOSubsReport] @WO = '10014841', @INCOMPLETEONLY = 1


--EXEC [dbo].[sp_TopLevelWOSubsReport] @WO = '10014747', @INCOMPLETEONLY = 0
--EXEC [dbo].[sp_TopLevelWOSubsReport] @WO = '10014747', @INCOMPLETEONLY = 1



EXEC [dbo].[sp_TopLevelWOReport] @WO = '10015243', @INCOMPLETEONLY = 0
EXEC [dbo].[sp_TopLevelWOReport] @WO = '10015243', @INCOMPLETEONLY = 1
EXEC [dbo].[sp_TopLevelWOReport] @WO = '10014841', @INCOMPLETEONLY = 0
EXEC [dbo].[sp_TopLevelWOReport] @WO = '10014841', @INCOMPLETEONLY = 1


EXEC [dbo].[sp_TopLevelWOReport] @WO = '10014747', @INCOMPLETEONLY = 0
EXEC [dbo].[sp_TopLevelWOReport] @WO = '10014747', @INCOMPLETEONLY = 1