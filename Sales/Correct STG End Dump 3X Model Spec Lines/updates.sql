USE BWSdb
GO

SELECT
* FROM [OrdersV2] WHERE [Model No] = 'End Dump 2X'
SELECT 'StandardsV2' AS [X],
* FROM [StandardsV2] WHERE [Model No] = 'End Dump 2X'


DECLARE @q AS NVARCHAR(MAX) = 'SG101307';


SELECT  'Order StandardsV2' AS [X], *
 FROM [Order StandardsV2] WHERE [Model No] = 'End Dump 2X' AND [SGQuote] = @q ORDER BY [SortGv2], [SortSev2]
 
SELECT
	*
FROM
	[Order OptionsV2]
WHERE
	[SGQuote] = @q
SELECT
	*
FROM
	[Custom WorkV2]
WHERE
	[SGQuote] = @q


-- Update [StandardsV2] and [Budget_StandardsV2] for [ModelNo] = 'End Dump 2X';
-- Copy the standards from [Order StandardsV2] for [SGQuote] = 'SG101307'


SELECT *
	FROM
		[StandardsV2] AS [S]
	INNER JOIN
		[Order StandardsV2] AS [O]
	ON
		[S].[Standard No] = [O].[Standard No]
	WHERE
		[S].[Model No] = 'End Dump 2X'
		AND [O].[SGQuote] = @q
	ORDER BY
		[S].[SortGv2]
		,[S].[SortSev2]
	;
		



BEGIN TRAN;

DECLARE @q AS NVARCHAR(MAX) = 'SG101307';
	
SELECT 'StandardsV2' AS [X],
* FROM [StandardsV2] WHERE [Model No] = 'End Dump 2X'

	UPDATE [dbo].[StandardsV2]
	   SET [Description] = [O].[Description]
		  ,[Start Date] = GETDATE()
		  ,[End Date] = DATEADD(YEAR, 1, GETDATE())
		  --,[New Spec Wording] = <New Spec Wording, nvarchar(255),
	FROM
		[StandardsV2] AS [S]
	INNER JOIN
		[Order StandardsV2] AS [O]
	ON
		[S].[Standard No] = [O].[Standard No]
	WHERE
		[S].[Model No] = 'End Dump 2X'
		AND [O].[SGQuote] = @q
	;
		
SELECT 'StandardsV2' AS [X],
* FROM [StandardsV2] WHERE [Model No] = 'End Dump 2X'

ROLLBACK;
COMMIT;