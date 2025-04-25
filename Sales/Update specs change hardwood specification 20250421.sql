
-- Models that need to have '1 3/4 in. Hardwood' changed to '1 1/2 in. Hardwood'




BEGIN TRAN;

DECLARE @out0 AS NVARCHAR(MAX) = '1-3/4 in. Hardwood'
DECLARE @out1 AS NVARCHAR(MAX) = '1 3/4 in. Hardwood'
DECLARE @in AS NVARCHAR(MAX) = '1 1/2 in. Hardwood'

DECLARE @changed TABLE ([ID] INT IDENTITY(0,1), [ChangedID] INT)
INSERT INTO @changed ([ChangedID])
SELECT
	[OS].[IDStd]
FROM
	[BWSdb].[dbo].[Standards] [OS]
INNER JOIN
	[BWSdb].[dbo].[Products] [P]
ON
	[OS].[Model No] = [P].[Model No]
WHERE
	([P].[Class] <> 'Hydraulic')
	AND (
		([OS].[Description] LIKE '%3/4%') AND ([OS].[Description] LIKE '%Hardwood%')
		OR ([OS].[Description] LIKE '%1 3/4 in. Hardwood%')
	)
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
	AND ([P].[Model No] NOT LIKE '%hdg%')
;

SELECT
	'Before' AS [Table]
	,[Class]
	,[OS].[Model No]
	,[OS].*
FROM
	[BWSdb].[dbo].[Standards] [OS]
INNER JOIN
	[BWSdb].[dbo].[Products] [P]
ON
	[OS].[Model No] = [P].[Model No]
WHERE
	([P].[Class] <> 'Hydraulic')
	AND (
		([OS].[Description] LIKE '%3/4%') AND ([OS].[Description] LIKE '%Hardwood%')
		OR ([OS].[Description] LIKE '%1 3/4 in. Hardwood%')
	)
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
	AND ([P].[Model No] NOT LIKE '%hdg%')
;

UPDATE
	[BWSdb].[dbo].[Standards]
SET
	[Description] = REPLACE(REPLACE([Description], @out0, @in), @out1, @in)
FROM
	[BWSdb].[dbo].[Standards] [OS]
INNER JOIN
	[BWSdb].[dbo].[Products] [P]
ON
	[OS].[Model No] = [P].[Model No]
WHERE
	([P].[Class] <> 'Hydraulic')
	AND (
		([OS].[Description] LIKE '%3/4%') AND ([OS].[Description] LIKE '%Hardwood%')
		OR ([OS].[Description] LIKE '%1 3/4 in. Hardwood%')
	)
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
	AND ([P].[Model No] NOT LIKE '%hdg%')
;

SELECT
	[Class]
	,[OS].[Model No]
	,[OS].*
FROM
	[BWSdb].[dbo].[Standards] [OS]
INNER JOIN
	[BWSdb].[dbo].[Products] [P]
ON
	[OS].[Model No] = [P].[Model No]
WHERE
	([P].[Class] <> 'Hydraulic')
	AND (
		([OS].[Description] LIKE '%3/4%') AND ([OS].[Description] LIKE '%Hardwood%')
		OR ([OS].[Description] LIKE '%1 3/4 in. Hardwood%')
	)
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
	AND ([P].[Model No] NOT LIKE '%hdg%')
;



SELECT
	'After' AS [Table]
	,[Class]
	,[OS].[Model No]
	,[OS].*
FROM
	[BWSdb].[dbo].[Standards] [OS]
INNER JOIN
	[BWSdb].[dbo].[Products] [P]
ON
	[OS].[Model No] = [P].[Model No]
INNER JOIN
	@changed [C]
ON
	[OS].[IDStd] = [C].[ChangedID]
WHERE
	([P].[Class] <> 'Hydraulic')
	AND (
		([OS].[Description] LIKE '%1/2%') AND ([OS].[Description] LIKE '%Hardwood%')
		OR ([OS].[Description] LIKE '%' + @in + '%')
	)
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
	AND ([P].[Model No] NOT LIKE '%hdg%')
;

ROLLBACK;
COMMIT;