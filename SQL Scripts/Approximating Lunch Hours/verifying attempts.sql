USE SysproCompanyA
GO

DECLARE @WO AS NVARCHAR(17);

DECLARE @min_n_hours AS DECIMAL(14, 2);
DECLARE @max_start_hour AS INT;
DECLARE @min_end_hour AS INT;
DECLARE @max_n_hours AS DECIMAL(14, 2);

-----------------------------------------------------------------------------------------------------------------------

SELECT @WO = '10015976'; -- Colden's wo
SELECT @WO = '10015644';

SELECT * FROM [ClkTransaction] WHERE [JobNumber] = @WO AND [EmployeeNumber] = '200339' ORDER BY [LoggedOn]
SELECT * FROM [ClkTransaction] WHERE [EmployeeNumber] = '200339' ORDER BY [LoggedOn]