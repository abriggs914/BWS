USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_ITSTR_UserDirectoryUpdateDate]    Script Date: 2024-10-30 3:40:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Avery Briggs
-- Create date: 2024-10-09
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER [dbo].[tr_ITSTR_AppDirectoryUpdateDate]
   ON [dbo].[ITSTR_AppDirectory]
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

	  
    IF (TRIGGER_NESTLEVEL() > 1)  BEGIN
        RETURN;
	END




	UPDATE
		[ITSTR_AppDirectory]
	SET
    -- Set DateCreated to GETDATE() if it is NULL
    [DateCreated] = COALESCE(C.[DateCreated], GETDATE()),

    -- Always update LastModified to current date
    [LastModified] = GETDATE(),

    -- If Active is 1 and DateActive is NULL, set DateActive to GETDATE()
    [DateActive] = CASE 
                        WHEN (I.[Active] = 1) AND (C.[DateActive] IS NULL) THEN GETDATE()
                        ELSE C.[DateActive] 
                    END,

    -- If Active is 0 and DateInactive is NULL, set DateInactive to GETDATE()
    [DateInactive] = CASE 
                            WHEN (I.[Active] = 0) AND (C.[DateInactive] IS NULL) THEN GETDATE()
                            ELSE C.[DateInactive] 
                        END

    FROM
        [ITSTR_AppDirectory] C
    INNER JOIN
        INSERTED I ON C.[ID] = I.[ID]
    LEFT JOIN
        DELETED D ON C.[ID] = D.[ID]
	;

		/*
		UPDATE
			[ITSTR_UserDirectory]
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
			END),
			[LastModified] = GETDATE()
			--
			--(CASE
			--	WHEN [O].[DateActive] IS NULL THEN [I].[DateActive]
			--	WHEN [I].[DateActive] IS NULL THEN 
			--	ELSE
			--END)
			--
		FROM
			[ITSTR_UserDirectory] [O]
		INNER JOIN
			INSERTED [I]
		ON
			[O].[ID] = [I].[ID]

	*/

END
