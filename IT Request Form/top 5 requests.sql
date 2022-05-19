USE BWSdb
GO

 -- Top 5 highest budgeted requests
SELECT TOP 5 * FROM [IT Requests] WHERE [LabourEstimate] IS NOT NULL ORDER BY [LabourEstimate] DESC

 -- Top 5 highest issued requests
SELECT TOP 5 * FROM [IT Requests] WHERE [LabourActual] IS NOT NULL ORDER BY [LabourActual] DESC

 -- Bottom 5 highest budgeted requests
SELECT TOP 5 * FROM [IT Requests] WHERE [LabourEstimate] IS NOT NULL ORDER BY [LabourEstimate]

 -- Bottom 5 highest issued requests
SELECT TOP 5 * FROM [IT Requests] WHERE [LabourActual] IS NOT NULL ORDER BY [LabourActual]


 -- Top 5 most revisited requests
SELECT TOP 5 * FROM [IT Requests] WHERE [OpenCounter] IS NOT NULL ORDER BY [OpenCounter] DESC