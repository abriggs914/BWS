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
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdateProductsSerialCalcMethod] 
   ON [Products]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	IF TRIGGER_NESTLEVEL() < 2 BEGIN
		UPDATE
			[Products]
		SET
			[SerialCalcMethod] = (
				CASE 
					WHEN ([I].[Class] IN ('Agriculture', 'Stargate', 'Towing', 'Snow & Ice Control')
						AND LEFT([I].[Model No], 8) <> 'SPUD KIT')
						OR ([I].[Class] IN ('Snow & Ice Control')
						AND LEFT([I].[Model No], 8) = 'SPUD KIT')
					THEN 1
					ELSE NULL
					END
			)
		FROM 
			[Products] [P]
		INNER JOIN
			[INSERTED] [I]
		ON
			[P].[IDTrailer] = [I].[IDTrailer]
	END
END
GO
