USE BWSdb
GO

SELECT 'IT Requests' AS [Table], * FROM [IT Requests];
SELECT 'IT Personnel' AS [Table], * FROM [IT Personnel];
SELECT 'ITR Customers' AS [Table], * FROM [ITR Customers];
SELECT 'ITR Hardware' AS [Table], * FROM [ITR Hardware];
SELECT 'ITR Software' AS [Table], * FROM [ITR Software];
SELECT 'ITR Training' AS [Table], * FROM [ITR Training];
SELECT 'ITR Status' AS [Table], * FROM [ITR Status];

SELECT 'v_IT Requests_RawData' AS [Table], * FROM [v_IT Requests_RawData];

SELECT 'v_ITRAllRequesters' AS [Table], * FROM [v_ITRAllRequesters];
SELECT 'v_ITRequestsPerMonthTotals' AS [Table], * FROM [v_ITRequestsPerMonthTotals];
SELECT 'v_ITRRequestsByDeptByMonth' AS [Table], * FROM [v_ITRRequestsByDeptByMonth];
SELECT 'v_ITRRequestThroughput' AS [Table], * FROM [v_ITRRequestThroughput];

DECLARE @topN AS INTEGER;
DECLARE @lastReq AS INT;
DECLARE @today AS DATETIME;
DECLARE @startOfYear AS DATETIME;
DECLARE @endOfYear AS DATETIME;
SELECT @lastReq = MAX([ITRequestID#]) FROM [IT Requests]
SET @topN = 5;
SET @today = GETDATE();
SET @startOfYear = CAST(CAST(YEAR(@today) AS NVARCHAR(4)) + '-01-01' AS DATETIME);
SET @endOfYear = CAST(CAST(YEAR(@today) AS NVARCHAR(4)) + '-12-31' AS DATETIME);

EXEC [sp_ITRAnalysisByDepartment];
EXEC [sp_ITRAnalysisByHardware];
EXEC [sp_ITRAnalysisBySoftware];
EXEC [sp_ITRAnalysisByTraining];
EXEC [sp_ITRequestAssignmentList] @sd=@startOfYear, @ed=@endOfYear;
EXEC [sp_ITRequestPersonnelTotals] @sd=@startOfYear, @ed=@endOfYear;
EXEC [sp_ITREstimateLabour] @department=12; -- @sd=@startOfYear, @ed=@endOfYear
EXEC [sp_ITRGatherLinks];
EXEC [sp_ITRNewRequestHTML] @tid=@lastReq;
--EXEC [sp_ITRSendAssignmentNotification] @reqID=@lastReq
--EXEC [sp_ITRSendEmailUpdateDBs] @dbStr='@dbStr', @commentStr='@commentStr', @user='@user'
EXEC [sp_ITRToDoList]
EXEC [sp_ITRTopNRequests] @topN=@topN
EXEC [sp_ITRTopNTimeIssued] @topN=@topN
EXEC [sp_ITRTopNTimePerRequest] @topN=@topN
