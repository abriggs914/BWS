USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_ITFFlagsUpdateActive]    Script Date: 2024-01-29 12:18:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[tr_ACDFireDrillRosterUpdateActive]
   ON  [dbo].[ACD FireDrillRoster]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- Insert statements for trigger hereSET NOCOUNT ON;

	-- In vars
	--DECLARE @in_id AS INT;
	--DECLARE @in_dateCreated AS DATETIME;
	---DECLARE @in_active AS BIT;

	-- Out vars
	--DECLARE @out_active AS BIT;

	-- working vars
	--DECLARE @new_activity AS BIT;

	--SELECT 
	--	@in_id = i.[ID]
	--	, @in_dateCreated = i.[DateCreated]
	--	, @in_active = ISNULL(i.[Active], 1)
	--FROM
	--	inserted i
	--;

	--SELECT 
	--	@in_id = d.[ID]
	--	,@out_active = d.[Active]
	--FROM
	--	deleted d
	--;

	--SELECT @new_activity = (CASE WHEN @in_active = @out_active THEN 0 ELSE 1 END);

	IF TRIGGER_NESTLEVEL() < 2 BEGIN
	
		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);

		-- Insert statements for trigger here
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'UPDATE';
			SET @user = SYSTEM_USER;

			UPDATE
				[ACD FireDrillRoster]
			SET
				[Active] = [I].[Active]
				, [DateCreated] = ISNULL([O].[DateCreated], GETDATE())
				, [DateActive] = (CASE WHEN [I].[Active] = 1 THEN GETDATE() ELSE (CASE WHEN [O].[DateActive] IS NOT NULL THEN [O].[DateActive] ELSE NULL END) END)
				, [DateInActive] = (CASE WHEN [I].[Active] = 0 THEN GETDATE() ELSE (CASE WHEN [O].[DateInActive] IS NOT NULL THEN [O].[DateInActive] ELSE NULL END) END)
			FROM
				[ACD FireDrillRoster] [O]
			RIGHT JOIN
				[Inserted] [I]
			ON
				[O].[ID] = [I].[ID]

			--IF @in_dateCreated IS NULL BEGIN
			--	UPDATE
			--		[ACD FireDrillRoster]
			--	SET
			--		[DateCreated] = GETDATE()
			--	WHERE
			--		[ID] = @in_id
			--	;
			--END

			--IF @new_activity = 1 BEGIN
				
			--	UPDATE
			--		[ACD FireDrillRoster]
			--	SET
			--		[Active] = @in_active
			--		, [DateActive] = (CASE WHEN @in_active = 1 THEN GETDATE() ELSE [DateActive] END)
			--		, [DateInactive] = (CASE WHEN @in_active = 0 THEN GETDATE() ELSE [DateInactive] END)
			--	WHERE
			--		[ID] = @in_id
			--	;

			--END

		END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;

--DECLARE @c INT = 0;
--DECLARE @new_Quote NVARCHAR(MAX) = 'NEW_QUOTE'

--DECLARE @emailMsg AS NVARCHAR(MAX) = '';
--SELECT @emailMsg = '@in_id = ' + CAST(ISNULL(@in_id, -1) AS NVARCHAR(MAX))

--EXEC msdb.dbo.sp_send_dbmail
--	@recipients = 'avery.briggs@bwstrailers.com',
--	@profile_name = 'SQL Agent',
--	@subject = 'tr ACD FireDrillRoster - INSERT', 
--	@body = @emailMsg,
--	@body_format='TEXT';

			--UPDATE
			--	[ACD FireDrillRoster]
			--SET
			--	[Active] = @in_active
			--	, [DateActive] = GETDATE()
			--	, [DateInactive] = (CASE WHEN @in_active = 0 THEN GETDATE() ELSE NULL END)
			--WHERE
			--	[ID] = @in_id
			--;

			UPDATE
				[ACD FireDrillRoster]
			SET
				[Active] = [I].[Active]
				, [DateCreated] = ISNULL([O].[DateCreated], GETDATE())
				, [DateActive] = (CASE WHEN [I].[Active] = 1 THEN GETDATE() ELSE (CASE WHEN [O].[DateActive] IS NOT NULL THEN [O].[DateActive] ELSE NULL END) END)
				, [DateInActive] = (CASE WHEN [I].[Active] = 0 THEN GETDATE() ELSE (CASE WHEN [O].[DateInActive] IS NOT NULL THEN [O].[DateInActive] ELSE NULL END) END)
			FROM
				[ACD FireDrillRoster] [O]
			RIGHT JOIN
				[Inserted] [I]
			ON
				[O].[ID] = [I].[ID]

		END
		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN 
			SET @activity = 'DELETE';
			SET @user = SYSTEM_USER;
		END

	END

END
