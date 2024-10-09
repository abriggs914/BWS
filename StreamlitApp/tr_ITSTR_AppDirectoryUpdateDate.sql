
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Avery Briggs
-- Create date: 2024-10-09
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [tr_ITSTR_AppDirectoryUpdateDate]
   ON [ITSTR_AppDirectory]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



	/*
	[ID]
      ,[DateCreated]
      ,[Active]
      ,[DateActive]
      ,[DateInactive]
      ,[AppShortName]
      ,[AppLongName]
      ,[AppDescription]
	  */







    -- Insert statements for trigger here
	IF TRIGGER_NESTLEVEL() < 2 BEGIN 
		
		UPDATE
			[ITSTR_AppDirectory]
		SET
		--[O].[DateActive] = ISNULL([O].[DateActive], (CASE WHEN [I].[] THEN ELSE END))
			[DateCreated] = ISNULL([I].[DateCreated], ISNULL([O].[DateCreated], GETDATE())),
			[DateActive] = (CASE
				WHEN [I].[Active] IS NULL THEN [I].[DateActive]
				WHEN [I].[Active] = 0 THEN NULL
				ELSE [I].[DateActive]
			END),
			[DateInActive] = (CASE
				WHEN [I].[Active] = 0 THEN NULL
				WHEN [I].[Active] IS NULL THEN [I].[DateInActive]
				ELSE [I].[DateInActive]
			END)
			/*
			(CASE
				WHEN [O].[DateActive] IS NULL THEN [I].[DateActive]
				WHEN [I].[DateActive] IS NULL THEN 
				ELSE
			END)
			*/
		FROM
			[ITSTR_AppDirectory] [O]
		INNER JOIN
			INSERTED [I]
		ON
			[O].[ID] = [I].[ID]

	END

END
GO
