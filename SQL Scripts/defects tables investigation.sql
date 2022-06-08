USE BWSdb
Go

--SELECT COUNT(*) FROM [Defects] WHERE [Input Date] BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE() 
SELECT * FROM [Defects] WHERE [Input Date] BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE() ORDER BY [Input Date] DESC
SELECT * FROM [Defects_BPF] WHERE [Input Date] BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE() ORDER BY [Input Date] DESC
SELECT * FROM [Defects_Print] WHERE [Input Date] BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE() ORDER BY [Input Date] DESC
SELECT * FROM [Defects_Receiving] WHERE [Input Date] BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE() ORDER BY [Input Date] DESC
SELECT * FROM [Defects_Snags] WHERE [Input Date] BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE() ORDER BY [Input Date] DESC
--SELECT * FROM [Defects_BPF_Location]
--SELECT * FROM [Defects_BPF_NoWOsInspected]
--SELECT * FROM [Defects_Causes]
--SELECT * FROM [Defects_Snags_Causes]
--SELECT * FROM [Defects_Print_Problems]
--SELECT * FROM [Defects_Snags_Location]
--SELECT * FROM [Defects_Snags_NoWOsInspected]