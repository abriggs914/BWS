USE BWSdb
GO

ALTER PROCEDURE [sp_ITRSendRequestUpdateNotice]

	@itRequestIDIn BIGINT, @who AS NVARCHAR(MAX), @notes AS NVARCHAR(MAX)=NULL

AS BEGIN

	DECLARE @now AS DATETIME = GETDATE();
	DECLARE @body AS NVARCHAR(MAX);
	DECLARE @persons AS NVARCHAR(MAX);
	DECLARE @subject AS NVARCHAR(MAX);

	DECLARE @email AS NVARCHAR(MAX);
	
	SELECT @email = [Email]
	FROM
		[ITR Customers]
	INNER JOIN
		[IT Personnel]
	ON
		[ITR Customers].[CustomerID] = [IT Personnel].[ITRCustomerID]
	INNER JOIN
		[IT Requests] 
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]
	WHERE
		[IT Requests].[ITRequestID#] = @itRequestIDIn
	;

	SELECT @persons = @email;
	SELECT @persons = @persons + ';' + 'avery.briggs@bwstrailers.com';

	SELECT @subject = 'ITR #' + RIGHT('000000' + CAST(@itRequestIDIn AS NVARCHAR(MAX)), 6) + ' Request for Update';

	SELECT @body = '<!DOCTYPE html>
<html>

<head>
    <title>IT Request for Update Notice</title>
</head>

<body>
	<div>
		<h2>Notice of Request for Update</h2>
		<p>An update for IT Request #' + RIGHT('000000' + CAST(@itRequestIDIn AS NVARCHAR(MAX)), 6) + ' has been requested by ''' + @who + '''.</p>
		<p>DATE: ' + CAST(DATEPART(YEAR, @now) AS NVARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(MONTH, @now) AS NVARCHAR(2)), 2) + '-' + RIGHT('00' + CAST(DATEPART(DAY, @now) AS NVARCHAR(2)), 2) + '</p>
		<p>ToD: ' + RIGHT('00' + CAST(DATEPART(HOUR, @now) AS NVARCHAR(2)), 2) + ':' + RIGHT('00' + CAST(DATEPART(MINUTE, @now) AS NVARCHAR(2)), 2) + '</p>
		<p>Please send them an update on the status of this request.</p>
		<p>Notes:</p>
		<p>' + ISNULL(@notes, '-') + '</p>
	</div>'

	DECLARE @ws AS NVARCHAR(MAX) = '                                           ';

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
	SELECT @itr_id =			CAST(@itRequestIDIn AS NVARCHAR(6));
	SELECT @itr_duedate =		CAST([DueDate] AS NVARCHAR(11)) FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_request =		[Request] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_requestby =		[RequestedBy] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_priority =		[Priority] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_subpriority =	[SubPriority] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_type =			[RequestType] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_subtype =		[RequestSubType] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_company =		[Company] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_directory =		[Directory] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_comments =		[Comments] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_hrsEst =		ISNULL([LabourEstimate], 0.0) FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_hrsAct =		ISNULL([LabourActual], 0.0) FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	
	SELECT @itr_status_old =	[Status] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;
	SELECT @itr_status_new =	[Status] FROM [IT Requests] WHERE [ITRequestID#] = @itRequestIDIn;

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

	SET @body = @body + '<div class="ITR Body" id="ITR Body ID 001" ><Table class="ITR Table" border="1" cellpadding = "5" cellspacing = "5"><thead><th colspan="2"><b>Request</b></th></thead><tbody><tr><td><b>Company:</b></td><td>'
	SET @body = @body + ISNULL(@itr_company, '-')
	SET @body = @body + '</td></tr><tr><td><b>Request Date:</b></td><td>'
	SET @body = @body + ISNULL(@itr_today, '-')
	SET @body = @body + '</td></tr><tr><td><b>Requested By:</b></td><td>'
	SET @body = @body + ISNULL(@itr_requestby, '-')
	SET @body = @body + '</td></tr><tr><td><b>Due Date:</b></td><td>'
	SET @body = @body + ISNULL(@itr_duedate, '-')
	SET @body = @body + '</td></tr><tr><td><b>Priority:</b></td><td>'
	SET @body = @body + ISNULL(@itr_priority, '-')
	SET @body = @body + '</td></tr><tr><td><b>Sub-Priority:</b></td><td>'
	SET @body = @body + ISNULL(@itr_subpriority, '-')
	SET @body = @body + '</td></tr><tr><td><b>Type:</b></td><td>'
	SET @body = @body + ISNULL(@itr_type, '-')
	SET @body = @body + '</td></tr><tr><td><b>Sub-Type:</b></td><td>'
	SET @body = @body + ISNULL(@itr_subtype, '-')
	SET @body = @body + '</td></tr><tr><td><b>Status (Old):</b></td><td style="color:RGB(' + @itr_colour_statusOFS + ')"><b>'
	SET @body = @body + ISNULL(@itr_status_old, '-')
	SET @body = @body + '</b></td></tr><tr><td><b>Status (New):</b></td><td style="color:RGB(' + @itr_colour_statusNFS + ')"><b>'
	SET @body = @body + ISNULL(@itr_status_new, '-')
	SET @body = @body + '</b></td></tr><tr><td><b>Text:</b></td><td>'
	SET @body = @body + ISNULL(@itr_request, '-')
	SET @body = @body + '</td></tr><tr><td><b>Comments:</b></td><td>'
	SET @body = @body + ISNULL(@itr_comments, '-')
	SET @body = @body + '</td></tr><tr><td><b>Labour (Est.):</b></td><td>'
	SET @body = @body + CAST(ISNULL(@itr_hrsEst, '0') AS NVARCHAR(255))
	SET @body = @body + '</td></tr><tr><td><b>Labour (Act.):</b></td><td style="color:RGB(' + @itr_colour_labourFS + ')"><b>'
	SET @body = @body + CAST(ISNULL(@itr_hrsAct, '0') AS NVARCHAR(255))
	SET @body = @body + '</b></td></tr><tr><td><b>Link:</b></td><td><a href="'
	SET @body = @body + ISNULL(@itr_directory, '-')
	SET @body = @body + '">Attachments</a></td></tr></tbody></Table>'
	SET @body = @body + '</div></body></html>'

	--SELECT 
	--	@subject AS [@subject]
	--	, @persons AS [@persons]
	--	, @body AS [@body]

	EXEC msdb.dbo.sp_send_dbmail
		@recipients = @persons,
		@profile_name = 'SQL Agent',
		@subject = @subject, 
		@body = @body,
		@body_format='HTML';
		SELECT 1 AS [Success];

END

