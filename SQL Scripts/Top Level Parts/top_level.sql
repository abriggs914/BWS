USE SysproCompanyA
GO

SELECT * FROM [WipMaster] ORDER BY [JobStartDate] DESC;
SELECT * FROM [WipJobAllLab] ORDER BY [PlannedStartDate] DESC;
SELECT * FROM [WipJobAllMat];