USE BWSdb
GO


	-- 1 for AND 0 for OR

ALTER PROCEDURE [dbo].[sp_ITRToDoList]
	@AND_OR AS BIT=NULL,
	@HOUR_WINDOW AS INTEGER=NULL,
	
	@REQ_DATE_EXACT DATETIME=NULL,
	@START_DATE_EXACT DATETIME=NULL,
	@DUE_DATE_EXACT DATETIME=NULL,
	@COMPLETION_DATE_EXACT DATETIME=NULL,
	@LAST_DATE_EXACT DATETIME=NULL,
	
	@REQ_DATE_END DATETIME=NULL,
	@START_DATE_END DATETIME=NULL,
	@DUE_DATE_END DATETIME=NULL,
	@COMPLETION_DATE_END DATETIME=NULL,
	@LAST_DATE_END DATETIME=NULL,
	
	@IS_QUEUED BIT=NULL,
	@IS_INPROGRESS BIT=NULL,
	@IS_COMPLETE BIT=NULL,
	@IS_INCOMPLETE BIT=NULL,
	@IS_DECLINED BIT=NULL,
	
	@IT_PERSONNEL_S NVARCHAR(MAX)=NULL,
	@IT_REQUEST_BY NVARCHAR(MAX)=NULL

AS BEGIN


/*******************************************************************************************************/
/*******************************************************************************************************/
/*********************                      For Testing                       **************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/




---- 1 for AND 0 for OR
--DECLARE @AND_OR AS BIT;
--DECLARE @HOUR_WINDOW AS INTEGER;

--DECLARE @REQ_DATE_EXACT AS DATETIME;
--DECLARE @START_DATE_EXACT AS DATETIME;
--DECLARE @DUE_DATE_EXACT AS DATETIME;
--DECLARE @COMPLETION_DATE_EXACT AS DATETIME;
--DECLARE @LAST_DATE_EXACT AS DATETIME;

--DECLARE @REQ_DATE_END AS DATETIME;
--DECLARE @START_DATE_END AS DATETIME;
--DECLARE @DUE_DATE_END AS DATETIME;
--DECLARE @COMPLETION_DATE_END AS DATETIME;
--DECLARE @LAST_DATE_END AS DATETIME;

--DECLARE @IS_QUEUED AS BIT;
--DECLARE @IS_INPROGRESS AS BIT;
--DECLARE @IS_COMPLETE AS BIT;
--DECLARE @IS_INCOMPLETE AS BIT;
--DECLARE @IS_DECLINED AS BIT;

--DECLARE @IT_PERSONNEL_S AS NVARCHAR(MAX);
--DECLARE @IT_REQUEST_BY AS NVARCHAR(MAX);

--SET @HOUR_WINDOW = 12;

----SET @IT_PERSONNEL_S = 4
--SET @IT_REQUEST_BY = 'Avery Briggs'

----SET @REQ_DATE_EXACT = '2022-03-07';
----SET @REQ_DATE_END = '2022-03-09';

----SET @START_DATE_EXACT = '2022-03-16';
----SET @START_DATE_END = '2022-03-17';

----SET @COMPLETION_DATE_EXACT = '2022-03-07';
----SET @COMPLETION_DATE_END = '2022-03-10';

----SET @IS_DECLINED = 1;

/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/

DECLARE @split_itp AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
DECLARE @split_rqb AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))



-- Begin Processing:

INSERT INTO @split_itp SELECT * FROM [BWSdb].[dbo].[split_string_idx](LOWER(@IT_PERSONNEL_S), ';')
IF (SELECT COUNT(*) FROM @split_itp) = 0 BEGIN
	-- If no machines are selected then return all machines
	--INSERT INTO @split_im ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [IMachine]) AS [Row#], [IMachine] FROM [SysproCompanyA].[dbo].[WipJobAllLab] GROUP BY [IMachine]
	INSERT INTO @split_itp SELECT ROW_NUMBER() OVER(ORDER BY [ITPersonID#]) AS [Row#], [ITPersonID#] FROM [IT Personnel]
END

INSERT INTO @split_rqb SELECT * FROM [BWSdb].[dbo].[split_string_idx](@IT_REQUEST_BY, ';')
--IF (SELECT COUNT(*) FROM @split_rqb) = 0 BEGIN
--	-- If no machines are selected then return all machines
--	--INSERT INTO @split_im ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [IMachine]) AS [Row#], [IMachine] FROM [SysproCompanyA].[dbo].[WipJobAllLab] GROUP BY [IMachine]
--	INSERT INTO @split_rqb SELECT ROW_NUMBER() OVER(ORDER BY [ITPersonID#]) AS [Row#], [ITPersonID#] FROM [IT Personnel]
--END

DECLARE @RESULTS AS TABLE (
	[ITRequestID#] [int],
	[RequestDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[Request] [nvarchar](max) NULL,
	[Priority] [int] NULL,
	[SubPriority] [int] NULL,
	[RequestedBy] [nvarchar](255) NULL,
	[Department] [int] NULL,
	[RequestFollowUpPersonnel] [nvarchar](max) NULL,
	[RequestType] [nvarchar](255) NULL,
	[RequestSubType] [nvarchar](255) NULL,
	[Comments] [nvarchar](max) NULL,
	[ITRequestts] [timestamp] NULL,
	[Company] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Directory] [nvarchar](max) NULL,
	[ITPersonAssignedID] [int] NULL,
	[CompletionDate] [datetime] NULL,
	[LastStatusUpdate] [datetime] NULL,
	[LabourEstimate] [float] NULL,
	[LabourActual] [float] NULL
);

IF @AND_OR = 0 OR @AND_OR IS NULL BEGIN
	INSERT INTO
		@RESULTS
	(
		[ITRequestID#],
		[RequestDate],
		[StartDate],
		[DueDate],
		[Request],
		[Priority],
		[SubPriority],
		[RequestedBy],
		[Department],
		[RequestFollowUpPersonnel],
		[RequestType],
		[RequestSubType],
		[Comments],
		[Company],
		[Status],
		[Directory],
		[ITPersonAssignedID],
		[CompletionDate],
		[LastStatusUpdate],
		[LabourEstimate],
		[LabourActual]
	)
	SELECT 
		[ITRequestID#],
		[RequestDate],
		[StartDate],
		[DueDate],
		[Request],
		[Priority],
		[SubPriority],
		[RequestedBy],
		[Department],
		[RequestFollowUpPersonnel],
		[RequestType],
		[RequestSubType],
		[Comments],
		[Company],
		[Status],
		[Directory],
		(CASE WHEN [ITPersonAssignedID] = 0 THEN 1 ELSE [ITPersonAssignedID] END),
		[CompletionDate],
		[LastStatusUpdate],
		ISNULL([LabourEstimate], 0),
		ISNULL([LabourActual], 0)
	FROM
		[IT Requests]
	WHERE
		(CASE WHEN (NOT @REQ_DATE_EXACT IS NULL) AND @REQ_DATE_END IS NULL THEN
			(CASE WHEN [RequestDate] IS NULL THEN 0 ELSE
				(CASE WHEN [RequestDate] BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @REQ_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @REQ_DATE_EXACT) THEN 1 ELSE 0
				END)
			END) 
			WHEN @REQ_DATE_EXACT IS NULL THEN 0
			WHEN [RequestDate]	BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @REQ_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @REQ_DATE_END) THEN 1
			ELSE 0
		END)
		+
		(CASE WHEN (NOT @START_DATE_EXACT IS NULL) AND @START_DATE_END IS NULL THEN
			(CASE WHEN [StartDate] IS NULL THEN 0 ELSE
				(CASE WHEN [StartDate] BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @START_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @START_DATE_EXACT) THEN 1 ELSE 0
				END)
			END) 
			WHEN @START_DATE_EXACT IS NULL THEN 0
			WHEN [StartDate] BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @START_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @START_DATE_END) THEN 1
			ELSE 0
		END)
		+
		(CASE WHEN (NOT @DUE_DATE_EXACT IS NULL) AND @DUE_DATE_END IS NULL THEN
			(CASE WHEN [DueDate] IS NULL THEN 0 ELSE
				(CASE WHEN [DueDate] BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @DUE_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @DUE_DATE_EXACT) THEN 1 ELSE 0
				END)
			END) 
			WHEN @DUE_DATE_EXACT IS NULL THEN 0
			WHEN [DueDate] BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @DUE_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @DUE_DATE_END) THEN 1
			ELSE 0
		END)
		+
		(CASE WHEN (NOT @COMPLETION_DATE_EXACT IS NULL) AND @COMPLETION_DATE_END IS NULL THEN
			(CASE WHEN [CompletionDate] IS NULL THEN 0 ELSE
				(CASE WHEN [CompletionDate] BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @COMPLETION_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @COMPLETION_DATE_EXACT) THEN 1 ELSE 0
				END)
			END) 
			WHEN @COMPLETION_DATE_EXACT IS NULL THEN 0
			WHEN [CompletionDate] BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @COMPLETION_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @COMPLETION_DATE_END) THEN 1
			ELSE 0
		END)
		+
		(CASE WHEN (NOT @LAST_DATE_EXACT IS NULL) AND @LAST_DATE_END IS NULL THEN
			(CASE WHEN [LastStatusUpdate] IS NULL THEN 0 ELSE
				(CASE WHEN [LastStatusUpdate] BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @LAST_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @LAST_DATE_EXACT) THEN 1 ELSE 0
				END)
			END) 
			WHEN @LAST_DATE_EXACT IS NULL THEN 0
			WHEN [LastStatusUpdate] BETWEEN DATEADD(HOUR, -@HOUR_WINDOW, @LAST_DATE_EXACT) AND DATEADD(HOUR, @HOUR_WINDOW, @LAST_DATE_END) THEN 1
			ELSE 0
		END)
		+
		(CASE 
			WHEN @IS_QUEUED = 1 AND [Status] = 'Queued' THEN 1
			ELSE 0
		END)
		+
		(CASE 
			WHEN @IS_INPROGRESS = 1 AND [Status] = 'In Progress' THEN 1
			ELSE 0
		END)
		+
		(CASE WHEN @IS_COMPLETE = 1 AND [Status] = 'Complete' THEN 1
			ELSE 0
		END)
		+
		(CASE 
			WHEN @IS_INCOMPLETE = 1 AND [Status] = 'Incomplete' THEN 1
			ELSE 0
		END)
		+
		(CASE 
			WHEN @IS_DECLINED = 1 AND [Status] = 'Declined' THEN 1
			ELSE 0
		END)
		+
		(CASE WHEN NOT @IT_PERSONNEL_S IS NULL THEN
			(CASE WHEN CAST([ITPersonAssignedID] AS NVARCHAR(MAX)) IN (SELECT [splitted_data] FROM @split_itp) THEN 1 ELSE 0 END)
			ELSE 0
		END)
		+
		(CASE WHEN NOT @IT_REQUEST_BY IS NULL THEN
			(CASE WHEN LOWER([RequestedBy]) IN (SELECT [splitted_data] FROM @split_rqb) THEN 1 ELSE 0 END)
			ELSE 0
		END)
		> 0
END
ELSE BEGIN
	PRINT 'And not supported yet'
	--INSERT INTO
	--	@RESULTS
	--(
	--	[ITRequestID#],
	--	[RequestDate],
	--	[StartDate],
	--	[DueDate],
	--	[Request],
	--	[Priority],
	--	[SubPriority],
	--	[RequestedBy],
	--	[Department],
	--	[RequestFollowUpPersonnel],
	--	[RequestType],
	--	[RequestSubType],
	--	[Comments],
	--	[Company],
	--	[Status],
	--	[Directory],
	--	[ITPersonAssignedID],
	--	[CompletionDate],
	--	[LastStatusUpdate],
	--	[LabourEstimate],
	--	[LabourActual]
	--)
	--SELECT 
	--	[ITRequestID#],
	--	[RequestDate],
	--	[StartDate],
	--	[DueDate],
	--	[Request],
	--	[Priority],
	--	[SubPriority],
	--	[RequestedBy],
	--	[Department],
	--	[RequestFollowUpPersonnel],
	--	[RequestType],
	--	[RequestSubType],
	--	[Comments],
	--	[Company],
	--	[Status],
	--	[Directory],
	--	[ITPersonAssignedID],
	--	[CompletionDate],
	--	[LastStatusUpdate],
	--	[LabourEstimate],
	--	[LabourActual]
	--FROM
	--	[IT Requests]
	--WHERE
		
		
END

-- If nothing was specified then return everything.
IF @REQ_DATE_EXACT IS NULL
	AND @REQ_DATE_END IS NULL
	AND @START_DATE_EXACT IS NULL
	AND @START_DATE_END IS NULL
	AND @DUE_DATE_EXACT IS NULL
	AND @DUE_DATE_END IS NULL
	AND @COMPLETION_DATE_EXACT IS NULL 
	AND @COMPLETION_DATE_END IS NULL 
	AND @LAST_DATE_EXACT IS NULL
	AND @LAST_DATE_END IS NULL
	AND @IT_REQUEST_BY IS NULL
	AND @IT_PERSONNEL_S IS NULL
BEGIN
	INSERT INTO
		@RESULTS
	(
		[ITRequestID#],
		[RequestDate],
		[StartDate],
		[DueDate],
		[Request],
		[Priority],
		[SubPriority],
		[RequestedBy],
		[Department],
		[RequestFollowUpPersonnel],
		[RequestType],
		[RequestSubType],
		[Comments],
		[Company],
		[Status],
		[Directory],
		[ITPersonAssignedID],
		[CompletionDate],
		[LastStatusUpdate],
		[LabourEstimate],
		[LabourActual]
	)
	SELECT 
		[ITRequestID#],
		[RequestDate],
		[StartDate],
		[DueDate],
		[Request],
		[Priority],
		[SubPriority],
		[RequestedBy],
		[Department],
		[RequestFollowUpPersonnel],
		[RequestType],
		[RequestSubType],
		[Comments],
		[Company],
		[Status],
		[Directory],
		(CASE WHEN [ITPersonAssignedID] = 0 THEN 1 ELSE [ITPersonAssignedID] END),
		[CompletionDate],
		[LastStatusUpdate],
		ISNULL([LabourEstimate], 0),
		ISNULL([LabourActual], 0)
	FROM
		[IT Requests]
END

-- Final Select
SELECT
	[@RESULTS].*,
	[Name]
FROM
	@RESULTS
LEFT JOIN
	[IT Personnel]
ON
	[@RESULTS].[ITPersonAssignedID] = [ITPersonID#] 

	
--SELECT
--COUNT(*)
--FROM
--	@RESULTS


--SELECT
--	COUNT(*) AS [Count]
--FROM
--	[IT Requests]

END