USE BWSdb
GO

SELECT * FROM [IT Requests]

EXEC [dbo].[sp_ITRequestPersonnelTotals] @sd='2021-11-01', @ed='2022-01-01'

SELECT (CASE WHEN '2021-12-12' < '2021-12-16' THEN 'Yes' ELSE 'No' END)