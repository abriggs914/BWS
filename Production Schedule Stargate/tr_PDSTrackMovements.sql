USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_PDSTrackMovements]    Script Date: 2024-07-11 4:53:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Avery Briggs
-- Create date: 2024-07-11
-- Capture the new values passed for [Available Date] and [JobAvailableLine] and send them to [Stargatedb].[dbo].[PDS Updates]
-- =============================================

ALTER TRIGGER [dbo].[tr_PDSTrackMovements] 
   ON  [dbo].[OrdersV2]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

    IF TRIGGER_NESTLEVEL() < 2 BEGIN		
		INSERT INTO
			[Stargatedb].[dbo].[PDS Updates] (
				[SGQuote]
				,[UpdaterName]
				,[NewAvailableDate]
				,[NewLine]
				,[OldAvailableDate]
				,[OldLine]
			)
			SELECT 
				[O2].[SGQuote]
				,[O2].[JobAvailableScheduledBy]
				,[O2].[Available Date]
				,[O2].[JobAvailableLine]
				,[D].[Available Date]
				,[D].[JobAvailableLine]
			FROM
				[BWSdb].[dbo].[OrdersV2] AS [O2]
			INNER JOIN
				DELETED AS [D]
			ON
				[O2].[SGQuote] = [D].[SGQuote]
			WHERE
				([O2].[Available Date] <> [D].[Available Date])
				OR ([O2].[JobAvailableLine] <> [D].[JobAvailableLine])
				OR ([O2].[JobAvailableScheduledBy] <> [D].[JobAvailableScheduledBy])	
    END

END
