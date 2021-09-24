USE SysproCompanyA
GO

--EXEC [dbo].[sp_MonthlyManufacturingVariance] @SD='2014-01-01', @ED='2022-02-01'
--EXEC [dbo].[sp_AnnualManufacturingVariance] @SD='2014-01-01', @ED='2022-02-01'

--EXEC [dbo].[sp_AnnualConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='A'
--EXEC [dbo].[sp_AnnualConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='B'
--EXEC [dbo].[sp_AnnualConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='C'

--EXEC [dbo].[sp_MonthlyConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='A'
--EXEC [dbo].[sp_MonthlyConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='B'
--EXEC [dbo].[sp_MonthlyConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='C'

--EXEC [dbo].[sp_MonthlyLabourBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='L'
--EXEC [dbo].[sp_MonthlyLabourBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='B'
--EXEC [dbo].[sp_MonthlyLabourBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='C'

EXEC [dbo].[sp_MonthlyMaterialBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='M'
EXEC [dbo].[sp_MonthlyMaterialBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='B'
EXEC [dbo].[sp_MonthlyMaterialBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='C'