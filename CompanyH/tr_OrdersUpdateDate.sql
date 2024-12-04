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
-- Author:		<Avery Briggs>
-- Create date: <2024-12-03>
-- Description:	<Update orders boilerplate>
-- =============================================
CREATE TRIGGER [dbo].[tr_OrdersUpdateDate]
   ON  [dbo].[Orders] 
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF TRIGGER_NESTLEVEL() > 1 BEGIN
		RETURN;
	END

	UPDATE
		[CompanyH].[dbo].[Orders]
	SET
		[DateLastModified] = GETDATE()
		, [DateCreated] = ISNULL([D].[DateCreated], GETDATE())
	FROM
		[CompanyH].[dbo].[Orders] [D]
	INNER JOIN
		INSERTED [I]
	ON
		[D].[QuoteNumber] = [I].[QuoteNumber]
END
GO
