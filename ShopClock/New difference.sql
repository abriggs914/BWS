USE SysproCompanyA
GO

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;

SELECT 
	@sd='2023-03-28'
	, @ed='2023-03-28 23:59:59'
;

-- Exisiting calculation
EXEC [sp_ClkLabourOverride] @sd=@sd, @ed=@ed;

-- New calculation
EXEC [sp_ClkLabourTime] @sd=@sd, @ed=@ed;