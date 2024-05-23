USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_ADOMaster_UpdateActive]    Script Date: 2024-05-22 12:05:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Avery Briggs
-- Create date: 2024-05-22 1325
-- Description:	Ensures the "DateActive" and "DateInactive" columns are updated based on "Active" column value
-- =============================================
CREATE TRIGGER [dbo].[tr_ADO_User_Access_UpdateActive]
   ON  [dbo].[ADO_User_Access]
   AFTER INSERT, UPDATE
AS 
BEGIN

	IF TRIGGER_NESTLEVEL() < 2 BEGIN

		UPDATE
			[ADO_User_Access]
		SET
			[Active] = ISNULL([I].[Active], 1)
			,[DateCreated] = ISNULL([I].[DateCreated], GETDATE())
			,[DateActive] = (CASE WHEN [I].[DateActive] IS NULL THEN (
				CASE WHEN ISNULL([I].[Active], 1) = 1 THEN GETDATE() ELSE NULL END)
				ELSE ISNULL([I].[DateActive], GETDATE()) 
			END)
			,[DateInactive] = (CASE WHEN ISNULL([I].[Active], 1) = 1 THEN [I].[DateInactive] ELSE ISNULL([I].[DateInactive], GETDATE())	END)
			,[DateLastModified] = GETDATE()
		FROM
			[ADO_User_Access] [U]
		INNER JOIN
			INSERTED I
		ON
			[U].[ID] = [I].[ID]
		;
		
	END

END
