USE SysproCompanyA
GO

--EXEC [dbo].[sp_MonthlyManufacturingVariance] @SD='2014-01-01', @ED='2022-02-01'
--EXEC [dbo].[sp_AnnualManufacturingVariance] @SD='2014-01-01', @ED='2022-02-01'

--EXEC [dbo].[sp_AnnualConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='A'
--EXEC [dbo].[sp_AnnualConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='B'
--EXEC [dbo].[sp_AnnualConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='C'

EXEC [dbo].[sp_MonthlyConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='A'
EXEC [dbo].[sp_MonthlyConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='B'
EXEC [dbo].[sp_MonthlyConsumablesBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='C'

--EXEC [dbo].[sp_MonthlyLabourBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='L'
--EXEC [dbo].[sp_MonthlyLabourBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='B'
--EXEC [dbo].[sp_MonthlyLabourBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='C'

--EXEC [dbo].[sp_MonthlyMaterialBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='M'
--EXEC [dbo].[sp_MonthlyMaterialBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='B'
--EXEC [dbo].[sp_MonthlyMaterialBudget] @SD='2014-01-01', @ED='2022-02-01', @COL='C'

--EXEC [dbo].[sp_AnnualInventoryValue] @SD='2014-01-01', @ED='2022-02-01'
--EXEC [dbo].[sp_MonthlyInventoryValue] @SD='2014-01-01', @ED='2022-02-01'

--EXEC [dbo].[sp_AnnualWIPValue] @SD='2014-01-01', @ED='2022-02-01'
--EXEC [dbo].[sp_MonthlyWIPValue] @SD='2014-01-01', @ED='2022-02-01'

--EXEC [dbo].[sp_AnnualInventoryTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='I'
--EXEC [dbo].[sp_AnnualInventoryTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='C'
--EXEC [dbo].[sp_AnnualInventoryTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='IC'
--EXEC [dbo].[sp_AnnualInventoryTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='T'

--EXEC [dbo].[sp_AnnualReceivablesTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='R'
--EXEC [dbo].[sp_AnnualReceivablesTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='C'
--EXEC [dbo].[sp_AnnualReceivablesTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='RC'
--EXEC [dbo].[sp_AnnualReceivablesTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='T'

--EXEC [dbo].[sp_AnnualPayablesTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='PA'
--EXEC [dbo].[sp_AnnualPayablesTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='PU'
--EXEC [dbo].[sp_AnnualPayablesTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='PP'
--EXEC [dbo].[sp_AnnualPayablesTurnover] @SD='2014-01-01', @ED='2022-02-01', @COL='T'

--select case when YEAR('2021-02-02') between YEAR('2021-01-01') and YEAR('2021-03-03') then 'yes' else 'no' end