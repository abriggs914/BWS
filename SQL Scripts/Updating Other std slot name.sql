USE BWSdb
GO

DECLARE @job AS Integer;
SET @job = 10014747

SELECT TOP 1 ClkTransaction.EmployeeName, ClkTransaction.OperationComplete FROM ClkTransaction WHERE ClkTransaction.JobNumber Like @job And ClkTransaction.Operation = 4 ORDER BY ClkTransaction.LoggedOff DESC , ClkTransaction.TransactionID;
SELECT TOP 1 [BWSdb].[dbo].[Orders].[Model No], ClkTransaction.EmployeeName, ClkTransaction.OperationComplete FROM ClkTransaction INNER JOIN [BWSdb].[dbo].[Orders] ON [Orders].[WO#] = [ClkTransaction].[JobNumber] WHERE ClkTransaction.JobNumber Like @job And ClkTransaction.Operation = 4 ORDER BY ClkTransaction.LoggedOff DESC , ClkTransaction.TransactionID;
SELECT TOP 1 [BWSdb].[dbo].[Orders].[Model No] FROM ClkTransaction INNER JOIN [BWSdb].[dbo].[Orders] ON [Orders].[WO#] = [ClkTransaction].[JobNumber] WHERE ClkTransaction.JobNumber Like @job;
SELECT TOP 1 BWSdb.dbo.Orders.[Model No] FROM ClkTransaction INNER JOIN BWSdb.dbo.Orders ON [Orders].[WO#] = [ClkTransaction].[JobNumber] WHERE ClkTransaction.JobNumber Like @job;
--SELECT TOP 1 Orders.[Model No] FROM ClkTransaction INNER JOIN [Orders] ON [Orders].[WO#] = [ClkTransaction].[JobNumber] WHERE ClkTransaction.JobNumber Like "10014747";
SELECT [BWSdb].[dbo].Orders.[Model No] FROM [BWSdb].[dbo].[Orders] WHERE [WO#] = @job;


SELECT * FROM [Production Slots]
SELECT * FROM [Production Slot Types]

SELECT * FROM [dtDealerStatusReport]

EXEC [sp_DealerStatusReportV2] @dealerid=5;

SELECT * FROM [Orders] WHERE [Slot#] IS NOT NULL

BEGIN TRAN;
SELECT * FROM [Production Slots] WHERE [Slot Types] LIKE '%Other std.%'
UPDATE
	[Production Slots]
SET 
	[Slot Types] = 'Other std.'
WHERE
	[Slot Types] LIKE '%Other std.%'
SELECT * FROM [Production Slots] WHERE [Slot Types] LIKE '%Other std.%'
ROLLBACK;
COMMIT;