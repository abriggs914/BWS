USE BWSdb
GO

EXEC [SysproCompanyA].[dbo].[sp_WO Performance Snapshot Ops 4 5] @WO='10016980'
EXEC [SysproCompanyA].[dbo].[sp_WO Performance Snapshot Ops 5to8] @WO='10016980'


EXEC [SysproCompanyA].[dbo].[sp_WOSnapshotEmployeesOnJob Ops 4 5] @WO='10016980'
EXEC [SysproCompanyA].[dbo].[sp_WOSnapshotEmployeesOnJob Ops 5to8] @WO='10016980'

