DECLARE @nR INT = 1000000;
SELECT @nR = 25

SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Orders];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Dealers];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Dealers_SalesPeople];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Dealers_SalesPersonBranch];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Order Options];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Order Options_FactoryLines];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Order Options_SpecLines];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Options];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Products];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Custom Work];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Budget Options];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Standards];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Customers];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Dept];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Department];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Design];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Design Staff];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Employees];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Employees - Salary];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Issues];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Hours Worked];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[];

-- Defects
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_BPF];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_BPF_Location];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_BPF_NoWOsInspected];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Causes];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Location];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_NoWOsInspected];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Print];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Print_Problems];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Receiving];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Receiving_Problems];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Snags];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Snags_Causes];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Snags_Location];
SELECT TOP (@nR) '' AS [T], * FROM [BWSdb].[dbo].[Defects_Snags_NoWOsInspected];