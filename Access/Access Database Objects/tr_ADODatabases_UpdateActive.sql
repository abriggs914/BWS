USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_ADOMaster_UpdateActive]    Script Date: 2024-03-13 12:25:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Avery Briggs
-- Create date: 2024-03-13 1328
-- Description:	Ensures the "DateActive" and "DateInactive" columns are updated based on "Active" column value
-- =============================================
ALTER TRIGGER [dbo].[tr_ADODatabases_UpdateActive]
   ON  [dbo].[ADO Databases]
   AFTER INSERT, UPDATE
AS 
BEGIN

	IF TRIGGER_NESTLEVEL() < 2 BEGIN

		UPDATE
			[ADO Databases]
		SET
			[Active] = ISNULL([I].[Active], 1)
			,[DateCreated] = ISNULL([I].[DateCreated], GETDATE())
			,[DateActive] = (CASE WHEN [I].[DateActive] IS NULL THEN (
				CASE WHEN ISNULL([I].[Active], 1) = 1 THEN GETDATE() ELSE NULL END)
				ELSE ISNULL([I].[DateActive], GETDATE()) 
			END)
			,[DateInactive] = (CASE WHEN ISNULL([I].[Active], 1) = 1 THEN [I].[DateInactive] ELSE ISNULL([I].[DateInactive], GETDATE())	END)
		FROM
			[ADO Databases] [D]
		INNER JOIN
			INSERTED I
		ON
			[D].[ADODatabasesID] = [I].[ADODatabasesID]
		;
		
	END

END
