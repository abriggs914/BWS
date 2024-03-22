USE SysproCompanyA
GO

DECLARE @wo NVARCHAR(MAX) = '10016898'

-- Operatios 4 and 5
EXEC [dbo].[sp_WOSnapshotEmployeesOnJob Ops 4 5] @WO=@wo
EXEC [dbo].[sp_WO Performance Snapshot Ops 4 5] @WO=@wo


-- Operations 4, 5, 6, 7, and 8
EXEC [dbo].[sp_WOSnapshotEmployeesOnJob Ops 5to8] @WO=@wo
EXEC [dbo].[sp_WO Performance Snapshot Ops 5to8] @WO=@wo