USE BWSdb

GO



	declare @job varchar(20),
			@mc varchar(30),
			@EmpName varchar(50),
			@WC varchar(20),
			@WCDesc varchar(50),
			@TL AS NVARCHAR(25),
			@warn AS BIT,
			@id AS NVARCHAR(MAX);

	--SET @job = '10016023';
	
	select @job		 = '10016023'
	SELECT @id = '1512344';

	--select @job		 = '10016022'
	--SELECT @id = '1512462';


	select @mc		 = '41'
	select @EmpName  = [EmployeeName] FROM [SysproCompanyA].[dbo].[ClkTransaction] WHERE [TransactionID] = @id
	select @WC		 = [WorkCentreCode] FROM [SysproCompanyA].[dbo].[ClkTransaction] WHERE [TransactionID] = @id
	select @WCDesc	 = [WorkCentreCodeDescription] FROM [SysproCompanyA].[dbo].[ClkTransaction] WHERE [TransactionID] = @id



SELECT * FROM [dtProductionSchedule] WHERE [WO#] = 10016023
SELECT [ClkTransaction].[TransactionID], [MachineCode], [JobNumber], [ClkTransaction].[LoggedOn], [LoggedOff] FROM [SysproCompanyA].[dbo].[ClkTransaction] WHERE [JobNumber] = @job ORDER BY [LoggedOn]

SELECT COUNT(*) FROM [SysproCompanyA].[dbo].[ClkTransaction] WITH (NOLOCK) WHERE [JobNumber] = @job AND [MachineCode] = '41'


SELECT [Orders].[Model No],
						[Staff],
						[Special Instructions]
					FROM [BWSdb].[dbo].[Orders] WITH (NOLOCK)
					INNER JOIN [BWSdb].[dbo].[Design] WITH (NOLOCK) ON [Orders].[Quote#] = [Design].[Quote#]
					WHERE cast([Orders].[WO#] AS NVARCHAR(20)) = @job

--Compose email body
					DECLARE @sSubject NVARCHAR(1000) =  'New Job Start - WO# ' + rtrim(@job) + ' - Pre Build Review Required!',
							@sBody NVARCHAR(MAX),
							@sModelNo NVARCHAR(50),
							@sDesigner NVARCHAR(255),
							@sSpecialInstructions NVARCHAR(MAX),
							@sRecipients NVARCHAR(MAX)

					SELECT @sModelNo = [Orders].[Model No],
						@sDesigner = [Staff],
						@sSpecialInstructions = [Special Instructions]
					FROM [BWSdb].[dbo].[Orders] WITH (NOLOCK)
					INNER JOIN [BWSdb].[dbo].[Design] WITH (NOLOCK) ON [Orders].[Quote#] = [Design].[Quote#]
					WHERE cast([Orders].[WO#] AS NVARCHAR(20)) = @job
					
					SELECT @TL	 = (CASE WHEN [Prod Line] IS NULL THEN [Prod Line2] ELSE [Prod Line] END) FROM [BWSdb].[dbo].[Production] WHERE [WO#] = CAST(@job AS INT)
					SELECT @warn = (CASE WHEN (SELECT COUNT(*) FROM [BWSdb].[dbo].[Production] WHERE [WO#] = @job) <> 1 THEN 1 ELSE 0 END)

					SELECT @sBody = '<!DOCTYPE html><!-- Automated message to alert of Shopclock job starts. 2022-07-27 --><html><head><meta content="text/html; charset=UTF-8" /><style> html, body {width: 100%;height: 100%;margin: 0;padding: 0;} </style></head><body><div class="Body" id="Body ID 001" ><table class="Table" id="Table ID 001" border="1" cellpadding = "5" cellspacing = "5", style="width:30%; margin-left: 20px; margin-top: 20px; margin-right: 20px; margin-bottom: 20px;"><thead><th colspan="2">Time Card Info:</th></thead><tbody><tr><td>Employee Name:</td><td>'
							+ ISNULL(@EmpName, 'N/A')
							+ '</td></tr><tr><td>Trailer Line:</td><td>'
							+ ISNULL(@TL, 'N/A')
							+ '</td></tr><tr><td>WorkCentre:</td><td>'
							+ ISNULL(@WC, 'N/A')
							+ '</td></tr><tr><td>WorkCentre Description:</td><td>'
							+ ISNULL(@WCDesc, 'N/A')
							+ '</td></tr></tbody></table><table class="Table" id="Table ID 002" border="1" cellpadding = "5" cellspacing = "5", style="width:30%; margin-left: 20px; margin-top: 20px; margin-right: 20px; margin-bottom: 20px;"><thead><th style="width:100%" colspan="2">WO Info:</th></thead><tbody><tr><td>Model No:</td><td>'
							+ ISNULL(@sModelNo, 'N/A')
							+ '</td></tr><tr><td>Engineer:</td><td>'
							+ ISNULL(@sDesigner, 'N/A')
							+ '</td></tr></tbody></table><div style="margin-left: 20px; margin-top: 20px; margin-right: 20px; margin-bottom: 20px;"><dl><dt>Special Instructions:</dt><dd>'
							+ ISNULL(@sSpecialInstructions, 'N/A')
							+ '</dd></dl>'

							+ (CASE WHEN @warn = 1 THEN '<dl style="color:RGB(255, 0, 0)"><dl>WARNING:</dt><dd style="color:RGB(240, 20, 20)">WO# '
								+ @job
								+ ' HAS NOT BEEN ENTERED ON THE PRODUCTION SCHEDULE YET.</dd></dl>'
								ELSE '' END)

							+ '</div></div></body></html>'
							;


					SET @sRecipients = (CASE WHEN @warn = 1 THEN 'EngineeringGroup@bwstrailers.com; avery.briggs@bwstrailers.com' ELSE 'EngineeringGroup@bwstrailers.com' END);
					--Send email
					--EXEC [msdb].[dbo].[sp_send_dbmail]
					--	--@recipients = @sRecipients,
					--	@recipients = 'avery.briggs@bwstrailers.com',
					--	@profile_name = 'SQL Agent',
					--	@subject = @sSubject,
					--	@body = @sBody,
					--	@body_format='HTML';



SELECT * FROM [SysproCompanyA].[dbo].[WipJobAmendJnl] WHERE [Job] = @job;
SELECT * FROM [SysproCompanyA].[dbo].[WipJobAmendJnl] WHERE [Job] = @job AND [After] LIKE '%41%' ORDER BY [ColumnName]--AND [ColumnName] LIKE '%mac%';

SELECT * FROM [SysproCompanyA].[dbo].[WipJobAmendJnl] WHERE [Job] = @job ORDER BY [JnlDate];