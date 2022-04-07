USE SysproCompanyA
GO

-- viewing who last altered a work order.

select * from WipJobAmendJnl with (nolock)
where TableName = 'WipMaster'
and ChangeFlag = 'A'
and Job = '20050362'