USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_SendEmailUpdatedITRequestColoured]    Script Date: 2022-04-06 9:40:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER TRIGGER [dbo].[tr_SendEmailUpdatedITRequestColoured]  
   ON  [dbo].[IT Requests] 
   AFTER UPDATE
AS 

BEGIN        
SET NOCOUNT ON;

DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
DECLARE @persons AS NVARCHAR(MAX);
DECLARE @subject AS NVARCHAR(255);
DECLARE @body AS NVARCHAR(MAX);

DECLARE @itr_today AS NVARCHAR(11);
DECLARE @itr_id AS NVARCHAR(6);
DECLARE @itr_duedate AS NVARCHAR(11);
DECLARE @itr_request AS NVARCHAR(MAX);
DECLARE @itr_requestby AS NVARCHAR(255);
DECLARE @itr_priority AS NVARCHAR(2);
DECLARE @itr_subpriority AS NVARCHAR(2);
DECLARE @itr_type AS NVARCHAR(255);
DECLARE @itr_subtype AS NVARCHAR(255);
DECLARE @itr_company AS NVARCHAR(25);
DECLARE @itr_directory AS NVARCHAR(255);
DECLARE @itr_comments AS NVARCHAR(MAX);
DECLARE @itr_hrsEst AS FLOAT;
DECLARE @itr_hrsAct AS FLOAT;
DECLARE @itr_colour_labourFS AS NVARCHAR(MAX);
DECLARE @itr_colour_statusNFS AS NVARCHAR(MAX);
DECLARE @itr_colour_statusOFS AS NVARCHAR(MAX);

DECLARE @itr_status_old AS NVARCHAR(255);
DECLARE @itr_status_new AS NVARCHAR(255);

DECLARE @itr_colour_labourT AS TABLE ([ID] INT IDENTITY(1, 1), [Status] NVARCHAR(MAX), [Rf] INT, [Gf] INT, [Bf] INT);
DECLARE @itr_colour_statusT AS TABLE ([ID] INT IDENTITY(1, 1), [Status] NVARCHAR(MAX), [Rf] INT, [Gf] INT, [Bf] INT);

SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM INSERTED i;
SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM INSERTED i;
SELECT @itr_request =		[Request] FROM INSERTED i;
SELECT @itr_requestby =		[RequestedBy] FROM INSERTED i;
SELECT @itr_priority =		[Priority] FROM INSERTED i;
SELECT @itr_subpriority =	[SubPriority] FROM INSERTED i;
SELECT @itr_type =			[RequestType] FROM INSERTED i;
SELECT @itr_subtype =		[RequestSubType] FROM INSERTED i;
SELECT @itr_company =		[Company] FROM INSERTED i;
SELECT @itr_directory =		[Directory] FROM INSERTED i;
SELECT @itr_comments =		[Comments] FROM INSERTED i;
SELECT @itr_hrsEst =		[LabourEstimate] FROM INSERTED i;
SELECT @itr_hrsAct =		[LabourActual] FROM INSERTED i;

SELECT @itr_status_old =	[Status] FROM DELETED d;
SELECT @itr_status_new =	[Status] FROM INSERTED i;

/*******************************************************************************/
							-- For Testing
/*******************************************************************************/

--DECLARE @TID AS INT = 365;
--SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
--SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_request =		[Request] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_requestby =		[RequestedBy] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_priority =		[Priority] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_subpriority =	[SubPriority] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_type =			[RequestType] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_subtype =		[RequestSubType] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_company =		[Company] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_directory =		[Directory] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_comments =		[Comments] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_hrsEst =		ISNULL([LabourEstimate], 0) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
--SELECT @itr_hrsAct =		ISNULL([LabourActual], 0) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];

--SELECT @itr_status_old =	'In Progress';
--SELECT @itr_status_new =	'Complete';
--SELECT @itr_hrsEst =		3.5;
--SELECT @itr_hrsAct =		4.1;

/*******************************************************************************/

IF @itr_status_old <> @itr_status_new BEGIN

	INSERT INTO @itr_colour_labourT ([Status], [Rf], [Gf], [Bf]) VALUES
	('He < Ha <= (He + 0.5)', 138, 96, 0), -- orange, slightly over estimate
	('(He - 0.5) <= Ha <= He', 0, 204, 25), -- green, slightly under estimate
	('Ha < (He - 0.5)', 0, 204, 25), -- green, very under estimate
	('(He + 0.5) < Ha', 183, 9, 9) -- red, very over estimate

	SELECT @itr_colour_statusOFS = 
		RIGHT(CAST([R] AS NVARCHAR(MAX)), 3) + ',' + 
		RIGHT(CAST([G] AS NVARCHAR(MAX)), 3) + ',' + 
		RIGHT(CAST([B] AS NVARCHAR(MAX)), 3)
	FROM [ITR Status] WHERE [Status] = @itr_status_old;
	SELECT @itr_colour_statusNFS = 
		RIGHT(CAST([R] AS NVARCHAR(MAX)), 3) + ',' + 
		RIGHT(CAST([G] AS NVARCHAR(MAX)), 3) + ',' + 
		RIGHT(CAST([B] AS NVARCHAR(MAX)), 3)
	FROM [ITR Status] WHERE [Status] = @itr_status_new;

	IF @itr_hrsAct < (@itr_hrsEst - 0.5) BEGIN
		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_labourT WHERE [ID] = 3;
	END
	IF @itr_hrsAct > (@itr_hrsEst + 0.5) BEGIN
		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_labourT WHERE [ID] = 4;
	END
	IF (@itr_hrsEst - 0.5 <= @itr_hrsAct) AND (@itr_hrsAct <= @itr_hrsEst) BEGIN
		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_labourT WHERE [ID] = 1;
	END
	IF @itr_hrsEst < @itr_hrsAct AND @itr_hrsAct <= (@itr_hrsEst + 0.5) BEGIN
		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_labourT WHERE [ID] = 2;
	END

	-- ITR #
	-- Date
	-- Due Date
	-- Request
	-- Priority
	-- SubPriority
	-- Request Type
	-- Request SubType
	-- Company
	-- Directory

	SET @subject = 'Updated IT Request #' + RIGHT('000000' + @itr_id, 6);

	SET @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Request</b></th></thead><tbody><tr><td><b>Request Date:</b></td><td>'
	SET @body = @body + @itr_today
	SET @body = @body + '</td></tr><tr><td><b>Requested By:</b></td><td>'
	SET @body = @body + @itr_requestby
	SET @body = @body + '</td></tr><tr><td><b>Due Date:</b></td><td>'
	SET @body = @body + @itr_duedate
	SET @body = @body + '</td></tr><tr><td><b>Priority:</b></td><td>'
	SET @body = @body + @itr_priority
	SET @body = @body + '</td></tr><tr><td><b>Sub-Priority:</b></td><td>'
	SET @body = @body + @itr_subpriority
	SET @body = @body + '</td></tr><tr><td><b>Type:</b></td><td>'
	SET @body = @body + @itr_type
	SET @body = @body + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
	SET @body = @body + @itr_subtype
	SET @body = @body + '</td></tr><tr><td><b>Status (Old):</b></td><td style="color:RGB(' + @itr_colour_statusOFS + ')"><b>'
	SET @body = @body + @itr_status_old
	SET @body = @body + '</b></td></tr><tr><td><b>Status (New):</b></td><td style="color:RGB(' + @itr_colour_statusNFS + ')"><b>'
	SET @body = @body + @itr_status_new
	SET @body = @body + '</b></td></tr><tr><td><b>Text:</b></td><td>'
	SET @body = @body + @itr_request
	SET @body = @body + '</td></tr><tr><td><b>Comments:</b></td><td>'
	SET @body = @body + @itr_comments
	SET @body = @body + '</td></tr><tr><td><b>Labour (Est.):</b></td><td>'
	SET @body = @body + CAST(ISNULL(@itr_hrsEst, '0') AS NVARCHAR(255))
	SET @body = @body + '</td></tr><tr><td><b>Labour (Act.):</b></td><td style="color:RGB(' + @itr_colour_labourFS + ')"><b>'
	SET @body = @body + CAST(ISNULL(@itr_hrsAct, '0') AS NVARCHAR(255))
	SET @body = @body + '</b></td></tr><tr><td><b>Link:</b></td><td><a href="'
	SET @body = @body + @itr_directory
	SET @body = @body + '">Attachments</a></td></tr></tbody></Table></div></body><footer><h6>Note: Request attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'

	SELECT @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
	SELECT @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
	SELECT @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie

	SELECT @persons = @persons + ';' + 'avery.briggs@bwstrailers.com';
	--SELECT @persons = @persons + ';' + 'james.crawford@bwstrailers.com'
	
	--SELECT @persons = 'avery.briggs@bwstrailers.com';
	
	--SELECT @itr_colour_statusOFS AS [@itr_colour_statusOFS], @itr_colour_statusNFS AS [@itr_colour_statusNFS], @body AS [@body]

	EXEC msdb.dbo.sp_send_dbmail
		@recipients = @persons,
		@profile_name = 'SQL Agent',
		@subject = @subject, 
		@body = @body
		,@body_format='HTML';
	END

END



/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
/*********************         Previous version 2022-04-06 10:03 AM     *********************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
--USE [BWSdb]
--GO
--/****** Object:  Trigger [dbo].[tr_SendEmailUpdatedITRequestColoured]    Script Date: 2022-04-06 9:40:51 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO


--ALTER TRIGGER [dbo].[tr_SendEmailUpdatedITRequestColoured]  
--   ON  [dbo].[IT Requests] 
--   AFTER UPDATE
--AS 

--BEGIN        
--SET NOCOUNT ON;

--DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
--DECLARE @persons AS NVARCHAR(MAX);
--DECLARE @subject AS NVARCHAR(255);
--DECLARE @body AS NVARCHAR(MAX);

--DECLARE @itr_today AS NVARCHAR(11);
--DECLARE @itr_id AS NVARCHAR(6);
--DECLARE @itr_duedate AS NVARCHAR(11);
--DECLARE @itr_request AS NVARCHAR(MAX);
--DECLARE @itr_requestby AS NVARCHAR(255);
--DECLARE @itr_priority AS NVARCHAR(2);
--DECLARE @itr_subpriority AS NVARCHAR(2);
--DECLARE @itr_type AS NVARCHAR(255);
--DECLARE @itr_subtype AS NVARCHAR(255);
--DECLARE @itr_company AS NVARCHAR(25);
--DECLARE @itr_directory AS NVARCHAR(255);
--DECLARE @itr_comments AS NVARCHAR(MAX);
--DECLARE @itr_hrsEst AS FLOAT;
--DECLARE @itr_hrsAct AS FLOAT;
--DECLARE @itr_colour_labourFS AS NVARCHAR(MAX);
--DECLARE @itr_colour_statusNFS AS NVARCHAR(MAX);
--DECLARE @itr_colour_statusOFS AS NVARCHAR(MAX);

--DECLARE @itr_status_old AS NVARCHAR(255);
--DECLARE @itr_status_new AS NVARCHAR(255);

--DECLARE @itr_colour_labourT AS TABLE ([ID] INT IDENTITY(1, 1), [Status] NVARCHAR(MAX), [Rf] INT, [Gf] INT, [Bf] INT);
--DECLARE @itr_colour_statusT AS TABLE ([ID] INT IDENTITY(1, 1), [Status] NVARCHAR(MAX), [Rf] INT, [Gf] INT, [Bf] INT);

--SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
--SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM INSERTED i;
--SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM INSERTED i;
--SELECT @itr_request =		[Request] FROM INSERTED i;
--SELECT @itr_requestby =		[RequestedBy] FROM INSERTED i;
--SELECT @itr_priority =		[Priority] FROM INSERTED i;
--SELECT @itr_subpriority =	[SubPriority] FROM INSERTED i;
--SELECT @itr_type =			[RequestType] FROM INSERTED i;
--SELECT @itr_subtype =		[RequestSubType] FROM INSERTED i;
--SELECT @itr_company =		[Company] FROM INSERTED i;
--SELECT @itr_directory =		[Directory] FROM INSERTED i;
--SELECT @itr_comments =		[Comments] FROM INSERTED i;
--SELECT @itr_hrsEst =		[LabourEstimate] FROM INSERTED i;
--SELECT @itr_hrsAct =		[LabourActual] FROM INSERTED i;

--SELECT @itr_status_old =	[Status] FROM DELETED d;
--SELECT @itr_status_new =	[Status] FROM INSERTED i;

--/*******************************************************************************/
--							-- For Testing
--/*******************************************************************************/

----DECLARE @TID AS INT = 1;
----SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
----SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_request =		[Request] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_requestby =		[RequestedBy] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_priority =		[Priority] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_subpriority =	[SubPriority] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_type =			[RequestType] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_subtype =		[RequestSubType] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_company =		[Company] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_directory =		[Directory] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_comments =		[Comments] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_hrsEst =		ISNULL([LabourEstimate], 0) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_hrsAct =		ISNULL([LabourActual], 0) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];

----SELECT @itr_status_old =	'In Progress';
----SELECT @itr_status_new =	'Complete';
----SELECT @itr_hrsEst =		3.5;
----SELECT @itr_hrsAct =		4.1;

--/*******************************************************************************/

--IF @itr_status_old <> @itr_status_new BEGIN

--	INSERT INTO @itr_colour_labourT ([Status], [Rf], [Gf], [Bf]) VALUES
--	('He < Ha <= (He + 0.5)', 138, 96, 0), -- orange, slightly over estimate
--	('(He - 0.5) <= Ha <= He', 0, 204, 25), -- green, slightly under estimate
--	('Ha < (He - 0.5)', 0, 204, 25), -- green, very under estimate
--	('(He + 0.5) < Ha', 183, 9, 9) -- red, very over estimate


--	INSERT INTO @itr_colour_statusT ([Status], [Rf], [Gf], [Bf]) VALUES
--	('Queued', 0, 0, 0), -- black
--	('In Progress', 138, 96, 0), -- orange
--	('Complete', 0, 204, 25), -- green
--	('Incomplete', 183, 9, 9), -- red
--	('Declined', 183, 9, 9) -- red
	
--	SELECT @itr_colour_statusOFS = 
--		RIGHT(CAST([Rf] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Gf] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Bf] AS NVARCHAR(MAX)), 3)
--	FROM @itr_colour_statusT WHERE [Status] = @itr_status_old;
--	SELECT @itr_colour_statusNFS = 
--		RIGHT(CAST([Rf] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Gf] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Bf] AS NVARCHAR(MAX)), 3)
--	FROM @itr_colour_statusT WHERE [Status] = @itr_status_new;

--	IF @itr_hrsAct < (@itr_hrsEst - 0.5) BEGIN
--		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 3;
--	END
--	IF @itr_hrsAct > (@itr_hrsEst + 0.5) BEGIN
--		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 4;
--	END
--	IF (@itr_hrsEst - 0.5 <= @itr_hrsAct) AND (@itr_hrsAct <= @itr_hrsEst) BEGIN
--		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 1;
--	END
--	IF @itr_hrsEst < @itr_hrsAct AND @itr_hrsAct <= (@itr_hrsEst + 0.5) BEGIN
--		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 2;
--	END




--	--INSERT INTO @itr_colour_statusT ([Status], [Rf], [Gf], [Bf]) VALUES
--	--('Queued', 0, 0, 0), -- black
--	--('In Progress', 138, 96, 0), -- orange
--	--('Complete', 0, 204, 25), -- green
--	--('Incomplete', 183, 9, 9), -- red
--	--('Declined', 183, 9, 9), -- red
--	--('Debugging', 75, 29, 170) -- purple
--	
--	--SELECT @itr_colour_statusOFS = 
--	--	RIGHT(CAST([Rf] AS NVARCHAR(MAX)), 3) + ',' + 
--	--	RIGHT(CAST([Gf] AS NVARCHAR(MAX)), 3) + ',' + 
--	--	RIGHT(CAST([Bf] AS NVARCHAR(MAX)), 3)
--	--FROM @itr_colour_statusT WHERE [Status] = @itr_status_old;
--	--SELECT @itr_colour_statusNFS = 
--	--	RIGHT(CAST([Rf] AS NVARCHAR(MAX)), 3) + ',' + 
--	--	RIGHT(CAST([Gf] AS NVARCHAR(MAX)), 3) + ',' + 
--	--	RIGHT(CAST([Bf] AS NVARCHAR(MAX)), 3)
--	--FROM @itr_colour_statusT WHERE [Status] = @itr_status_new;
--	
--	---- Old status not found above, default black
--	--IF @itr_colour_statusOFS IS NULL BEGIN
--	--	SET @itr_colour_statusOFS = '0,0,0'
--	--END
--
--	---- New status not found above, default black
--	--IF @itr_colour_statusNFS IS NULL BEGIN
--	--	SET @itr_colour_statusNFS = '0,0,0'
--	--END



--	-- ITR #
--	-- Date
--	-- Due Date
--	-- Request
--	-- Priority
--	-- SubPriority
--	-- Request Type
--	-- Request SubType
--	-- Company
--	-- Directory

--	SET @subject = 'Updated IT Request #' + RIGHT('000000' + @itr_id, 6);

--	SET @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Request</b></th></thead><tbody><tr><td><b>Request Date:</b></td><td>'
--	SET @body = @body + @itr_today
--	SET @body = @body + '</td></tr><tr><td><b>Requested By:</b></td><td>'
--	SET @body = @body + @itr_requestby
--	SET @body = @body + '</td></tr><tr><td><b>Due Date:</b></td><td>'
--	SET @body = @body + @itr_duedate
--	SET @body = @body + '</td></tr><tr><td><b>Priority:</b></td><td>'
--	SET @body = @body + @itr_priority
--	SET @body = @body + '</td></tr><tr><td><b>Sub-Priority:</b></td><td>'
--	SET @body = @body + @itr_subpriority
--	SET @body = @body + '</td></tr><tr><td><b>Type:</b></td><td>'
--	SET @body = @body + @itr_type
--	SET @body = @body + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
--	SET @body = @body + @itr_subtype
--	SET @body = @body + '</td></tr><tr><td><b>Status (Old):</b></td><td style="color:RGB(' + @itr_colour_statusOFS + ')"><b>'
--	SET @body = @body + @itr_status_old
--	SET @body = @body + '</b></td></tr><tr><td><b>Status (New):</b></td><td style="color:RGB(' + @itr_colour_statusNFS + ')"><b>'
--	SET @body = @body + @itr_status_new
--	SET @body = @body + '</b></td></tr><tr><td><b>Text:</b></td><td>'
--	SET @body = @body + @itr_request
--	SET @body = @body + '</td></tr><tr><td><b>Comments:</b></td><td>'
--	SET @body = @body + @itr_comments
--	SET @body = @body + '</td></tr><tr><td><b>Labour (Est.):</b></td><td>'
--	SET @body = @body + CAST(ISNULL(@itr_hrsEst, '0') AS NVARCHAR(255))
--	SET @body = @body + '</td></tr><tr><td><b>Labour (Act.):</b></td><td style="color:RGB(' + @itr_colour_labourFS + ')"><b>'
--	SET @body = @body + CAST(ISNULL(@itr_hrsAct, '0') AS NVARCHAR(255))
--	SET @body = @body + '</b></td></tr><tr><td><b>Link:</b></td><td><a href="'
--	SET @body = @body + @itr_directory
--	SET @body = @body + '">Attachments</a></td></tr></tbody></Table></div></body><footer><h6>Note: Request attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'

--	SELECT @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
--	SELECT @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
--	SELECT @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie

--	SELECT @persons = @persons + ';' + 'avery.briggs@bwstrailers.com';
--	--SELECT @persons = @persons + ';' + 'james.crawford@bwstrailers.com'

--	EXEC msdb.dbo.sp_send_dbmail
--		@recipients = @persons,
--		@profile_name = 'SQL Agent',
--		@subject = @subject, 
--		@body = @body,
--		@body_format='HTML';
--	END

--END
/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/
/***********************************************************************************************************************************************************************************************************************************************************************************/





/*********

-- Version with emojis. doesnt work though. :( 2022-03-22
USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_SendEmailUpdatedITRequestColoured]    Script Date: 2022-03-22 3:16:04 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO


--ALTER TRIGGER [dbo].[tr_SendEmailUpdatedITRequestColoured]  
--   ON  [dbo].[IT Requests] 
--   AFTER UPDATE
--AS 

--BEGIN        
--SET NOCOUNT ON;

DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
DECLARE @persons AS NVARCHAR(MAX);
DECLARE @subject AS NVARCHAR(255);
DECLARE @body AS NVARCHAR(MAX);

DECLARE @itr_today AS NVARCHAR(11);
DECLARE @itr_id AS NVARCHAR(6);
DECLARE @itr_duedate AS NVARCHAR(11);
DECLARE @itr_request AS NVARCHAR(MAX);
DECLARE @itr_requestby AS NVARCHAR(255);
DECLARE @itr_priority AS NVARCHAR(2);
DECLARE @itr_subpriority AS NVARCHAR(2);
DECLARE @itr_type AS NVARCHAR(255);
DECLARE @itr_subtype AS NVARCHAR(255);
DECLARE @itr_company AS NVARCHAR(25);
DECLARE @itr_directory AS NVARCHAR(255);
DECLARE @itr_comments AS NVARCHAR(MAX);
DECLARE @itr_hrsEst AS FLOAT;
DECLARE @itr_hrsAct AS FLOAT;
DECLARE @itr_hrsEmoji AS NVARCHAR(MAX);
DECLARE @itr_colour_labourFS AS NVARCHAR(MAX);
DECLARE @itr_colour_statusNFS AS NVARCHAR(MAX);
DECLARE @itr_colour_statusOFS AS NVARCHAR(MAX);

DECLARE @itr_status_old AS NVARCHAR(255);
DECLARE @itr_status_new AS NVARCHAR(255);

DECLARE @itr_colour_labourT AS TABLE ([ID] INT IDENTITY(1, 1), [Status] NVARCHAR(MAX), [Rf] INT, [Gf] INT, [Bf] INT);
DECLARE @itr_colour_statusT AS TABLE ([ID] INT IDENTITY(1, 1), [Status] NVARCHAR(MAX), [Rf] INT, [Gf] INT, [Bf] INT);

--SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
--SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM INSERTED i;
--SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM INSERTED i;
--SELECT @itr_request =		[Request] FROM INSERTED i;
--SELECT @itr_requestby =		[RequestedBy] FROM INSERTED i;
--SELECT @itr_priority =		[Priority] FROM INSERTED i;
--SELECT @itr_subpriority =	[SubPriority] FROM INSERTED i;
--SELECT @itr_type =			[RequestType] FROM INSERTED i;
--SELECT @itr_subtype =		[RequestSubType] FROM INSERTED i;
--SELECT @itr_company =		[Company] FROM INSERTED i;
--SELECT @itr_directory =		[Directory] FROM INSERTED i;
--SELECT @itr_comments =		[Comments] FROM INSERTED i;
--SELECT @itr_hrsEst =		[LabourEstimate] FROM INSERTED i;
--SELECT @itr_hrsAct =		[LabourActual] FROM INSERTED i;

--SELECT @itr_status_old =	[Status] FROM DELETED d;
--SELECT @itr_status_new =	[Status] FROM INSERTED i;

/*******************************************************************************/
							-- For Testing
/*******************************************************************************/

DECLARE @TID AS INT = 260;
SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_request =		[Request] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_requestby =		[RequestedBy] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_priority =		[Priority] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_subpriority =	[SubPriority] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_type =			[RequestType] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_subtype =		[RequestSubType] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_company =		[Company] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_directory =		[Directory] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_comments =		[Comments] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_hrsEst =		ISNULL([LabourEstimate], 0) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
SELECT @itr_hrsAct =		ISNULL([LabourActual], 0) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];

SELECT @itr_status_old =	'In Progress';
SELECT @itr_status_new =	'Complete';
SELECT @itr_hrsEst =		3.5;
SELECT @itr_hrsAct =		4.1;

/*******************************************************************************/

IF @itr_status_old <> @itr_status_new BEGIN

	INSERT INTO @itr_colour_labourT ([Status], [Rf], [Gf], [Bf]) VALUES
	('He < Ha <= (He + 0.5)', 138, 96, 0), -- orange, slightly over estimate
	('(He - 0.5) <= Ha <= He', 0, 204, 25), -- green, slightly under estimate
	('Ha < (He - 0.5)', 0, 204, 25), -- green, very under estimate
	('(He + 0.5) < Ha', 183, 9, 9) -- red, very over estimate

	SELECT @itr_colour_statusOFS = 
		RIGHT(CAST([R] AS NVARCHAR(MAX)), 3) + ',' + 
		RIGHT(CAST([G] AS NVARCHAR(MAX)), 3) + ',' + 
		RIGHT(CAST([B] AS NVARCHAR(MAX)), 3)
	FROM [ITR Status] WHERE [Status] = @itr_status_old;
	SELECT @itr_colour_statusNFS = 
		RIGHT(CAST([R] AS NVARCHAR(MAX)), 3) + ',' + 
		RIGHT(CAST([G] AS NVARCHAR(MAX)), 3) + ',' + 
		RIGHT(CAST([B] AS NVARCHAR(MAX)), 3)
	FROM [ITR Status] WHERE [Status] = @itr_status_new;

	IF @itr_hrsAct < (@itr_hrsEst - 0.5) BEGIN
		-- Very under budget
		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 3;
		SELECT @itr_hrsEmoji = ':smile:'
	END
	IF @itr_hrsAct > (@itr_hrsEst + 0.5) BEGIN
		-- Very over budget 
		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 4;
		SELECT @itr_hrsEmoji = ':white_frowning_face:'
	END
	IF (@itr_hrsEst - 0.5 <= @itr_hrsAct) AND (@itr_hrsAct <= @itr_hrsEst) BEGIN
		-- Slightly under budget
		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 1;
		SELECT @itr_hrsEmoji = ':smile:'
	END
	IF @itr_hrsEst < @itr_hrsAct AND @itr_hrsAct <= (@itr_hrsEst + 0.5) BEGIN
		-- Slightly over budget
		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 2;
		SELECT @itr_hrsEmoji = ':smiley:'
	END

	-- ITR #
	-- Date
	-- Due Date
	-- Request
	-- Priority
	-- SubPriority
	-- Request Type
	-- Request SubType
	-- Company
	-- Directory

	SET @subject = 'Updated IT Request #' + RIGHT('000000' + @itr_id, 6);

	SET @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Request</b></th></thead><tbody><tr><td><b>Request Date:</b></td><td>'
	SET @body = @body + @itr_today
	SET @body = @body + '</td></tr><tr><td><b>Requested By:</b></td><td>'
	SET @body = @body + @itr_requestby
	SET @body = @body + '</td></tr><tr><td><b>Due Date:</b></td><td>'
	SET @body = @body + @itr_duedate
	SET @body = @body + '</td></tr><tr><td><b>Priority:</b></td><td>'
	SET @body = @body + @itr_priority
	SET @body = @body + '</td></tr><tr><td><b>Sub-Priority:</b></td><td>'
	SET @body = @body + @itr_subpriority
	SET @body = @body + '</td></tr><tr><td><b>Type:</b></td><td>'
	SET @body = @body + @itr_type
	SET @body = @body + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
	SET @body = @body + @itr_subtype
	SET @body = @body + '</td></tr><tr><td><b>Status (Old):</b></td><td style="color:RGB(' + @itr_colour_statusOFS + ')"><b>'
	SET @body = @body + @itr_status_old
	SET @body = @body + '</b></td></tr><tr><td><b>Status (New):</b></td><td style="color:RGB(' + @itr_colour_statusNFS + ')"><b>'
	SET @body = @body + @itr_status_new
	SET @body = @body + '</b></td></tr><tr><td><b>Text:</b></td><td>'
	SET @body = @body + @itr_request
	SET @body = @body + '</td></tr><tr><td><b>Comments:</b></td><td>'
	SET @body = @body + @itr_comments
	SET @body = @body + '</td></tr><tr><td><b>Labour (Est.):</b></td><td>'
	SET @body = @body + CAST(ISNULL(@itr_hrsEst, '0') AS NVARCHAR(255))
	SET @body = @body + '</td></tr><tr><td><b>Labour (Act.):</b></td><td style="color:RGB(' + @itr_colour_labourFS + ')"><b>'
	SET @body = @body + CAST(ISNULL(@itr_hrsAct, '0') AS NVARCHAR(255))
	SET @body = @body + '</b> ' + @itr_hrsEmoji
	SET @body = @body + '</td></tr><tr><td><b>Link:</b></td><td><a href="'
	SET @body = @body + '</b></td></tr><tr><td><b>Link:</b></td><td><a href="'
	SET @body = @body + @itr_directory
	SET @body = @body + '">Attachments</a></td></tr></tbody></Table></div></body><footer><h6>Note: Request attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'

	SELECT @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
	--SELECT @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
	--SELECT @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie

	SELECT @persons = @persons + ';' + 'avery.briggs@bwstrailers.com';
	--SELECT @persons = @persons + ';' + 'james.crawford@bwstrailers.com'

	EXEC msdb.dbo.sp_send_dbmail
		@recipients = @persons,
		@profile_name = 'SQL Agent',
		@subject = @subject, 
		@body = @body,
		@body_format='HTML';
	END

--END

*********/









--/*********

--		Previous Version that colours the font and the background.
--		2022-03-16 9:31 AM

--USE [BWSdb]
--GO
--/****** Object:  Trigger [dbo].[tr_SendEmailUpdatedITRequestColoured]    Script Date: 2022-03-16 9:30:39 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO


--ALTER TRIGGER [dbo].[tr_SendEmailUpdatedITRequestColoured]  
--   ON  [dbo].[IT Requests] 
--   AFTER UPDATE
--AS 

--BEGIN        
--SET NOCOUNT ON;

--DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
--DECLARE @persons AS NVARCHAR(MAX);
--DECLARE @subject AS NVARCHAR(255);
--DECLARE @body AS NVARCHAR(MAX);

--DECLARE @itr_today AS NVARCHAR(11);
--DECLARE @itr_id AS NVARCHAR(6);
--DECLARE @itr_duedate AS NVARCHAR(11);
--DECLARE @itr_request AS NVARCHAR(MAX);
--DECLARE @itr_requestby AS NVARCHAR(255);
--DECLARE @itr_priority AS NVARCHAR(2);
--DECLARE @itr_subpriority AS NVARCHAR(2);
--DECLARE @itr_type AS NVARCHAR(255);
--DECLARE @itr_subtype AS NVARCHAR(255);
--DECLARE @itr_company AS NVARCHAR(25);
--DECLARE @itr_directory AS NVARCHAR(255);
--DECLARE @itr_comments AS NVARCHAR(MAX);
--DECLARE @itr_hrsEst AS FLOAT;
--DECLARE @itr_hrsAct AS FLOAT;
--DECLARE @itr_colour_labourFS AS NVARCHAR(MAX);
--DECLARE @itr_colour_labourBS AS NVARCHAR(MAX);
--DECLARE @itr_colour_statusNFS AS NVARCHAR(MAX);
--DECLARE @itr_colour_statusNBS AS NVARCHAR(MAX);
--DECLARE @itr_colour_statusOFS AS NVARCHAR(MAX);
--DECLARE @itr_colour_statusOBS AS NVARCHAR(MAX);

--DECLARE @itr_status_old AS NVARCHAR(255);
--DECLARE @itr_status_new AS NVARCHAR(255);

--DECLARE @itr_colour_labourT AS TABLE ([ID] INT IDENTITY(1, 1), [Status] NVARCHAR(MAX), [Rf] INT, [Gf] INT, [Bf] INT, [Rb] INT, [Gb] INT, [Bb] INT);
--DECLARE @itr_colour_statusT AS TABLE ([ID] INT IDENTITY(1, 1), [Status] NVARCHAR(MAX), [Rf] INT, [Gf] INT, [Bf] INT, [Rb] INT, [Gb] INT, [Bb] INT);

--SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
--SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM INSERTED i;
--SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM INSERTED i;
--SELECT @itr_request =		[Request] FROM INSERTED i;
--SELECT @itr_requestby =		[RequestedBy] FROM INSERTED i;
--SELECT @itr_priority =		[Priority] FROM INSERTED i;
--SELECT @itr_subpriority =	[SubPriority] FROM INSERTED i;
--SELECT @itr_type =			[RequestType] FROM INSERTED i;
--SELECT @itr_subtype =		[RequestSubType] FROM INSERTED i;
--SELECT @itr_company =		[Company] FROM INSERTED i;
--SELECT @itr_directory =		[Directory] FROM INSERTED i;
--SELECT @itr_comments =		[Comments] FROM INSERTED i;
--SELECT @itr_hrsEst =		[LabourEstimate] FROM INSERTED i;
--SELECT @itr_hrsAct =		[LabourActual] FROM INSERTED i;

--SELECT @itr_status_old =	[Status] FROM DELETED d;
--SELECT @itr_status_new =	[Status] FROM INSERTED i;

----DECLARE @TID AS INT = 10;
----SELECT @itr_today =			CAST(GETDATE() AS NVARCHAR(11));
----SELECT @itr_id =			CAST([ITRequestID#] AS NVARCHAR(6)) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_request =		[Request] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_requestby =		[RequestedBy] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_priority =		[Priority] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_subpriority =	[SubPriority] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_type =			[RequestType] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_subtype =		[RequestSubType] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_company =		[Company] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_directory =		[Directory] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_comments =		[Comments] FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_hrsEst =		ISNULL([LabourEstimate], 0) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];
----SELECT @itr_hrsAct =		ISNULL([LabourActual], 0) FROM (SELECT * FROM [IT Requests] WHERE [ITRequestID#] = @TID) AS [Src];

----SELECT @itr_status_old =	'Queued';
----SELECT @itr_status_new =	'In Progress';

--IF @itr_status_old <> @itr_status_new BEGIN

--	INSERT INTO @itr_colour_labourT ([Status], [Rf], [Gf], [Bf], [Rb], [Gb], [Bb]) VALUES
--	('He < Ha <= (He + 0.5)', 240, 233, 11, 0, 0, 0), -- yellow on black, slightly over estimate
--	('(He - 0.5) <= Ha <= He', 227, 235, 227, 0, 204, 25), -- white on green, slightly under estimate
--	('Ha < (He - 0.5)', 240, 233, 11, 0, 204, 25), -- yellow on green very under estimate
--	('(He + 0.5) < Ha', 227, 235, 227, 183, 9, 9) -- white on red very over estimate

--	INSERT INTO @itr_colour_statusT ([Status], [Rf], [Gf], [Bf], [Rb], [Gb], [Bb]) VALUES
--	('Queued', 0, 0, 0, 255, 255, 255), -- black on white
--	('In Progress', 227, 235, 227, 0, 0, 0), -- white on black
--	('Complete', 227, 235, 227, 0, 204, 25), -- white on green
--	('Incomplete', 183, 9, 9, 0, 0, 0), -- red on black
--	('Declined', 183, 9, 9, 255, 255, 255) -- red on white
	
--	SELECT @itr_colour_statusOFS = 
--		RIGHT(CAST([Rf] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Gf] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Bf] AS NVARCHAR(MAX)), 3)
--	FROM @itr_colour_statusT WHERE [Status] = @itr_status_old;
--	SELECT @itr_colour_statusOBS = 
--		RIGHT(CAST([Rb] AS NVARCHAR(MAX)), 3) + ',' +
--		RIGHT(CAST([Gb] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Bb] AS NVARCHAR(MAX)), 3) 
--	FROM @itr_colour_statusT WHERE [Status] = @itr_status_old;
--	SELECT @itr_colour_statusNFS = 
--		RIGHT(CAST([Rf] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Gf] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Bf] AS NVARCHAR(MAX)), 3)
--	FROM @itr_colour_statusT WHERE [Status] = @itr_status_new;
--	SELECT @itr_colour_statusNBS = 
--		RIGHT(CAST([Rb] AS NVARCHAR(MAX)), 3) + ',' +
--		RIGHT(CAST([Gb] AS NVARCHAR(MAX)), 3) + ',' + 
--		RIGHT(CAST([Bb] AS NVARCHAR(MAX)), 3) 
--	FROM @itr_colour_statusT WHERE [Status] = @itr_status_new;

--	IF @itr_hrsAct < (@itr_hrsEst - 0.5) BEGIN
--		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 3;
--		SELECT @itr_colour_labourBS = CAST([Rb] AS NVARCHAR(3)) + ',' + CAST([Gb] AS NVARCHAR(3)) + ',' + CAST([Bb] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 3;
--	END
--	IF @itr_hrsAct > (@itr_hrsEst + 0.5) BEGIN
--		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 4;
--		SELECT @itr_colour_labourBS = CAST([Rb] AS NVARCHAR(3)) + ',' + CAST([Gb] AS NVARCHAR(3)) + ',' + CAST([Bb] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 4;
--	END
--	IF (@itr_hrsEst - 0.5 <= @itr_hrsAct) AND (@itr_hrsAct <= @itr_hrsEst) BEGIN
--		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 1;
--		SELECT @itr_colour_labourBS = CAST([Rb] AS NVARCHAR(3)) + ',' + CAST([Gb] AS NVARCHAR(3)) + ',' + CAST([Bb] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 1;
--	END
--	IF @itr_hrsEst < @itr_hrsAct AND @itr_hrsAct <= (@itr_hrsEst + 0.5) BEGIN
--		SELECT @itr_colour_labourFS = CAST([Rf] AS NVARCHAR(3)) + ',' + CAST([Gf] AS NVARCHAR(3)) + ',' + CAST([Bf] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 2;
--		SELECT @itr_colour_labourBS = CAST([Rb] AS NVARCHAR(3)) + ',' + CAST([Gb] AS NVARCHAR(3)) + ',' + CAST([Bb] AS NVARCHAR(3)) FROM @itr_colour_statusT WHERE [ID] = 2;
--	END

--	-- ITR #
--	-- Date
--	-- Due Date
--	-- Request
--	-- Priority
--	-- SubPriority
--	-- Request Type
--	-- Request SubType
--	-- Company
--	-- Directory

--	SET @subject = 'Updated IT Request #' + RIGHT('000000' + @itr_id, 6);

--	SET @body = '<!DOCTYPE html><html><body><div class="ITR Body" id="ITR Body ID 001" ><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Request</b></th></thead><tbody><tr><td><b>Request Date:</b></td><td>'
--	SET @body = @body + @itr_today
--	SET @body = @body + '</td></tr><tr><td><b>Requested By:</b></td><td>'
--	SET @body = @body + @itr_requestby
--	SET @body = @body + '</td></tr><tr><td><b>Due Date:</b></td><td>'
--	SET @body = @body + @itr_duedate
--	SET @body = @body + '</td></tr><tr><td><b>Priority:</b></td><td>'
--	SET @body = @body + @itr_priority
--	SET @body = @body + '</td></tr><tr><td><b>Sub-Priority:</b></td><td>'
--	SET @body = @body + @itr_subpriority
--	SET @body = @body + '</td></tr><tr><td><b>Type:</b></td><td>'
--	SET @body = @body + @itr_type
--	SET @body = @body + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
--	SET @body = @body + @itr_subtype
--	SET @body = @body + '</td></tr><tr><td><b>Status (Old):</b></td><td style="color:RGB(' + @itr_colour_statusOFS + '); background-color:RGB(' + @itr_colour_statusOBS + ')"><b>'
--	SET @body = @body + @itr_status_old
--	SET @body = @body + '</b></td></tr><tr><td><b>Status (New):</b></td><td style="color:RGB(' + @itr_colour_statusNFS + '); background-color:RGB(' + @itr_colour_statusNBS + ')"><b>'
--	SET @body = @body + @itr_status_new
--	SET @body = @body + '</b></td></tr><tr><td><b>Text:</b></td><td>'
--	SET @body = @body + @itr_request
--	SET @body = @body + '</td></tr><tr><td><b>Comments:</b></td><td>'
--	SET @body = @body + @itr_comments
--	SET @body = @body + '</td></tr><tr><td><b>Labour (Est.):</b></td><td>'
--	SET @body = @body + CAST(ISNULL(@itr_hrsEst, '0') AS NVARCHAR(255))
--	SET @body = @body + '</td></tr><tr><td><b>Labour (Act.):</b></td><td style="color:RGB(' + @itr_colour_labourFS + '); background-color:RGB(' + @itr_colour_labourBS + ')"><b>'
--	SET @body = @body + CAST(ISNULL(@itr_hrsAct, '0') AS NVARCHAR(255))
--	SET @body = @body + '</b></td></tr><tr><td><b>Link:</b></td><td><a href="'
--	SET @body = @body + @itr_directory
--	SET @body = @body + '">Attachments</a></td></tr></tbody></Table></div></body><footer><h6>Note: Request attachments will be included in future emails once BWS has transitioned to Office 365.</h6></footer></html>'

--	--SELECT @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
--	--SELECT @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
--	--SELECT @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie

--	SELECT @persons = 'avery.briggs@bwstrailers.com';
--	SELECT @persons = @persons + ';' + 'james.crawford@bwstrailers.com'

--	EXEC msdb.dbo.sp_send_dbmail
--		@recipients = @persons,
--		@profile_name = 'SQL Agent',
--		@subject = @subject, 
--		@body = @body,
--		@body_format='HTML';
--	END
--END




--**********/