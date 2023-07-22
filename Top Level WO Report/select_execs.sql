USE SysproCompanyA
GO

DECLARE @wo AS NVARCHAR(8);
DECLARE @io AS INT;
SELECT 
	@wo ='10016619',
	@io = 0
;


EXEC [dbo].[sp_TopLevelWOReport]
	@WO=@wo,
	@INCOMPLETEONLY = @io

EXEC 
	[dbo].[sp_TopLevelWOSubsReport] 
	@WO=@wo, @INCOMPLETEONLY=@io