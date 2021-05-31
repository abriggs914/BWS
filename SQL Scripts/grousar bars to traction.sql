USE BWSdb
GO

-- 2021-05-31

--#####################################################################################################################
-- Convert all uses of "grouser" to "traction".
-- Both Queries should return empty

SELECT [Model No], [Option No], [Description] FROM [Options]
	WHERE [Option No] IS NOT NULL
		AND [Option No] NOT LIKE '%20ntts%'
		AND [Option No] NOT LIKE '%42et2x-89%'
		AND [Option No] NOT LIKE '%42et3x-88%'
		AND [Option No] NOT LIKE '%48et2x-89%'
		AND [Option No] NOT LIKE '%48et2x mr%'
		AND [Option No] NOT LIKE '%48et3x mr east%'
		AND [Option No] NOT LIKE '%48et3x-86%'
		AND [Option No] NOT LIKE '%53et2x-89%'
		AND [Option No] NOT LIKE '%53et2x-93%'
		AND [Option No] NOT LIKE '%53et3x-93%'
		AND [Option No] NOT LIKE '%53et3x mr east-60%'
		AND [Option No] NOT LIKE '%53et3x mr east-61%'
		AND [Option No] NOT LIKE '%53et3x mr east-86%'
		AND [Option No] NOT LIKE '%53et3x mr west-92%'
		AND [Option No] NOT LIKE '%53et4x-64%'
		AND [Option No] NOT LIKE '%53et4x-84%'
		AND [Option No] NOT LIKE '%53et4x mr-60%'
		AND [Option No] NOT LIKE '%53et4x mr-61%'
		AND [Option No] NOT LIKE '%53et4x mr-91%'
		AND ([Description] LIKE '%grousar%'
		OR [Description] LIKE '%grouser%')
	ORDER BY [Model No]

SELECT * FROM [Options_SpecLines]
	WHERE [Option No] IS NOT NULL
		AND [Option No] NOT LIKE '%20ntts%'
		AND [Option No] NOT LIKE '%42et2x-89%'
		AND [Option No] NOT LIKE '%42et3x-88%'
		AND [Option No] NOT LIKE '%48et2x-89%'
		AND [Option No] NOT LIKE '%48et2x mr%'
		AND [Option No] NOT LIKE '%48et3x mr east%'
		AND [Option No] NOT LIKE '%48et3x-86%'
		AND [Option No] NOT LIKE '%53et2x-89%'
		AND [Option No] NOT LIKE '%53et2x-93%'
		AND [Option No] NOT LIKE '%53et3x-93%'
		AND [Option No] NOT LIKE '%53et3x mr east-60%'
		AND [Option No] NOT LIKE '%53et3x mr east-61%'
		AND [Option No] NOT LIKE '%53et3x mr east-86%'
		AND [Option No] NOT LIKE '%53et3x mr west-92%'
		AND [Option No] NOT LIKE '%53et4x-64%'
		AND [Option No] NOT LIKE '%53et4x-84%'
		AND [Option No] NOT LIKE '%53et4x mr-60%'
		AND [Option No] NOT LIKE '%53et4x mr-61%'
		AND [Option No] NOT LIKE '%53et4x mr-91%'
		AND ([SpecDescription] LIKE '%grousar%'
		OR [SpecDescription] LIKE '%grouser%')
	ORDER BY [Model No], [Option No]
