USE [SysproCompanyA]
GO

-----------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------TESTING--------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
DECLARE @job AS NVARCHAR(20),
			@mc AS NVARCHAR(30),
			@EmpName AS NVARCHAR(50),
			@WC AS NVARCHAR(20),
			@WCDesc AS NVARCHAR(50),
			@TL AS NVARCHAR(25),
			@warn AS BIT;
			
SET @job = '10015747';
--SET @job = '10015647';
--SET @job = '10016977';
--SET @job = '10015650';
--SET @job = '10015540';
SET @mc = '41';
--SELECT @mc		 = [MachineCode] FROM [ClkTransaction] WHERE [JobNumber] = @job
SELECT @EmpName  = [EmployeeName] FROM [ClkTransaction] WHERE [JobNumber] = @job
SELECT @WC		 = [WorkCentreCode] FROM [ClkTransaction] WHERE [JobNumber] = @job
SELECT @WCDesc	 = [WorkCentreCodeDescription] FROM [ClkTransaction] WHERE [JobNumber] = @job
-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------END TESTING------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

	--IF this is the first time an employee hAS logged onto a 10 million level jobWITH Machine Code 41, send email
	IF LEFT(@job, 1) = '1' AND @mc = '41'
		BEGIN
			IF ((SELECT COUNT(*) FROM ClkTransaction WITH (NOLOCK) WHERE [JobNumber] = @job AND [MachineCode] = @mc) = 1) --OR 1 = 1
				BEGIN

					--Compose email body
					DECLARE @sSubject NVARCHAR(1000) =  'New Job Start - WO# ' + rtrim(@job) + ' - Pre Build Review Required!',
							@sBody NVARCHAR(MAX),
							@sModelNo NVARCHAR(50),
							@sDesigner NVARCHAR(255),
							@sSpecialInstructions NVARCHAR(MAX)

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

					--Send email
					EXEC [msdb].[dbo].[sp_send_dbmail]
						--@recipients = 'EngineeringGroup@bwstrailers.com; avery.briggs@bwstrailers.com',
						@recipients = 'avery.briggs@bwstrailers.com',
						@profile_name = 'SQL Agent',
						@subject = @sSubject,
						@body = @sBody,
						@body_format='HTML';
				END
		END






