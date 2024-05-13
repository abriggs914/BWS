
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Avery Briggs>
-- Create date: <2024-05-13>
-- Description:	<Ensure that new warranty work order numbers are transferred to [Stargatedb].[dbo].[PDS WarrantyUnits]>
-- =============================================
CREATE TRIGGER [tr_PDS_UpdateWarrantyUnits]
   ON [SysproCompanyS].[dbo].[WipMaster]
   AFTER 
	INSERT,
	UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	INSERT INTO
		[Stargatedb].[dbo].[PDS WarrantyUnits]
		([Job])
	SELECT
		[I].[Job]
	FROM
		inserted [I]
	LEFT JOIN
		[PDS WarrantyUnits] [W]
	ON
		[I].[Job] = [W].[Job]
	WHERE
		[W].[Job] IS NULL

END
GO
