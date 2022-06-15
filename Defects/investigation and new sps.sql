SELECT * FROM [v_SYSPROLabourAnalysis]

EXEC [dbo].[sp_EfficiencyReworkYTD2] @ed='2022-06-08'


USE SysproCompanyA
GO

exec [sp_ReworkReviewReport v2_StartEndDates] @sd='2021-06-08',  @ed='2022-06-08'