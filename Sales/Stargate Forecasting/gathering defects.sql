USE BWSdb
GO


DECLARE @wo NVARCHAR(MAX) = '10015656';
SELECT * FROM [Defects] WHERE [WO#] = @wo
SELECT * FROM [Defects_BPF] AS [F] LEFT JOIN [Defects_Causes] AS [C] ON [F].[CauseID] = [C].[CauseID#] WHERE [WO#] = @wo
SELECT * FROM [Defects_Causes]
SELECT * FROM [Defects_Location]
SELECT * FROM [Defects_Print] AS [P] LEFT JOIN [Defects_Print_Problems] AS [PP] ON [P].[ProblemID] = [PP].[DefPrintProbsID#] WHERE [WO#] = @wo
SELECT * FROM [Defects_Print_Problems]
SELECT * FROM [Defects_Snags] WHERE [WO#] = @wo