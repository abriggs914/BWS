-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Avery Briggs
-- Create date: 2024-08-27
-- Description:	Maintain the [LastModified] column of the [Stargatedb].[dbo].[PDS Valid Updaters] table.
-- =============================================
CREATE TRIGGER [dbo].[tr_PDS_UpdateLastModifiedColumn] 
   ON  [Stargatedb].[dbo].[PDS Valid Updaters]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	IF TRIGGER_NESTLEVEL() < 2 BEGIN 
		
		UPDATE
			[Stargatedb].[dbo].[PDS Valid Updaters]
		SET
			[LastModified] = GETDATE()
		FROM
			[Stargatedb].[dbo].[PDS Valid Updaters] [U]
		INNER JOIN
			INSERTED [I]
		ON
			[U].[ID] = [I].[ID]

	END

END
GO
