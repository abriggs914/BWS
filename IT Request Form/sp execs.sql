USE BWSdb
GO

EXEC [sp_ITRAnalysisByDepartment]
EXEC [sp_ITRAnalysisByHardware]
EXEC [sp_ITRAnalysisBySoftware]
EXEC [sp_ITRAnalysisByTraining]
EXEC [sp_ITREstimateLabour] @department=12, @requestType='Hardware', @requestSubType='Computer'
EXEC [sp_ITREstimateLabour] @department=12

SELECT * FROM [v_ITRAllRequesters]
SELECT * FROM [v_ITRequestsPerMonthTotals]
SELECT * FROM [v_ITRRequestsByDeptByMonth]

-- I'm making a request.
-- time on last request.
-- time per request per department
-- time per request per requestType
-- time per request per requestSubType
-- time per request per requester
		-- Have to make this one

-- total time this week
-- total time this month
-- total time this year

