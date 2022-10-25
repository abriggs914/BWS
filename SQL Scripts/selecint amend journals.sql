USE SysproCompanyA

GO

SELECT * FROM [WipJobAmendJnl] WHERE [OperatorCode] = 'IVAN' AND [JnlDate] BETWEEN DATEADD(DAY, -1 ,GETDATE()) AND GETDATE() ORDER BY [JnlDate] DESC, [JnlTime] DESC
SELECT * FROM [InvMastAmendJnl] WHERE [OperatorCode] = 'IVAN' AND [JnlDate] BETWEEN DATEADD(DAY, -1 ,GETDATE()) AND GETDATE() ORDER BY [JnlDate] DESC, [JnlTime] DESC