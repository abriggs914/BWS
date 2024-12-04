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
-- Description:	<Update [Products] boilerplate>
-- =============================================
CREATE TRIGGER [dbo].[tr_ProductsUpdateDate] 
   ON [CompanyH].[dbo].[Products]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF TRIGGER_NESTLEVEL() = 1 BEGIN

		UPDATE
			[CompanyH].[dbo].[Products]
		SET
			[LastModified] = GETDATE()
			, [DateCreated] = COALESCE([C].[DateCreated], GETDATE())
			, [DateActive] = (CASE 
				WHEN ([I].[Active] = 1) AND ([C].[DateActive] IS NULL) THEN
					GETDATE()
				ELSE
					[C].[DateActive] 
				END
			),
			[DateInactive] = (CASE 
				WHEN ([I].[Active] = 0) AND ([C].[DateInactive] IS NULL) THEN
					GETDATE()
				ELSE
					[C].[DateInactive] 
				END
			)
		FROM
			[CompanyH].[dbo].[Products] [C]
		INNER JOIN
			INSERTED [I]
		ON
			[C].[ID] = [I].[ID]
	END

END
GO
