USE BWSdb
GO

DECLARE @ID AS INT;
SET @ID = (SELECT TOP 1 [ID] FROM [Dealers] WHERE [COMPANY NAME] LIKE '%remorques%');

SELECT @ID AS [IdNumber]
SELECT * FROM [v_Dealer Status Report 2] WHERE [DealerID] = @ID AND [Quote#] = 24251

EXEC [dbo].sp_DealerStatusReportV2 @dealerid = @ID

-- SELECT * FROM [dbo].[#v_DealerStatusReport2]

USE [BWSdb_20210531]
GO

DECLARE @ID AS INT;
SET @ID = (SELECT TOP 1 [ID] FROM [Dealers] WHERE [COMPANY NAME] LIKE '%remorques%');
SELECT @ID AS [IdNumber]

EXEC [dbo].sp_DealerStatusReportV2 @dealerid = @ID