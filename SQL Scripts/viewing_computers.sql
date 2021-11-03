USE uniPoint_Live
GO

SELECT * FROM [PT_Equip] INNER JOIN [SysproCompanyA].[dbo].[BomEmployee] ON [Assigned_employee] COLLATE Latin1_General_BIN = [BomEmployee].[Employee] WHERE [Name] LIKE '%K%'