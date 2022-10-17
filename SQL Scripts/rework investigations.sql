USE SysproCompanyA
GO

DECLARE @job AS NVARCHAR(MAX);
SELECT @job = '10015945';

SELECT '[WipJobAmendJnl]' AS [TABLE], * FROM [WipJobAmendJnl] WHERE [Job] = @job
SELECT '[WipJobAllLab]' AS [TABLE], * FROM [WipJobAllLab] WHERE [Job] = @job
SELECT '[WipLabJnl]' AS [TABLE], * FROM [WipLabJnl] WHERE [Job] = @job

SELECT '[v_JobReworkHours]' AS [TABLE], * FROM [v_JobReworkHours] WHERE [Job] = @job