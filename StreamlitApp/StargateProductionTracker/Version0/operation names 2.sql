USE [SysproCompanyA]
GO

/****** Object:  View [dbo].[v_ProdOperationNames]    Script Date: 2024-10-16 2:12:08 PM ******/
/*
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_ProdOperationNames] AS
*/

	SELECT
		*
	FROM (
		SELECT
			ROW_NUMBER() OVER(
				PARTITION BY
					[Operation]
				ORDER BY
					[ClkTransaction].[TransactionID] DESC
			) AS [RN]
			,[Operation]
			,[OperationDescription]
			,[WorkCentreCode]
			,[WorkCentreCodeDescription]
		FROM
			[ClkTransaction]
		WHERE
			LTRIM(RTRIM(ISNULL([OperationDescription], ''))) <> ''
		GROUP BY
			[ClkTransaction].[TransactionID]
			,[Operation]
			,[OperationDescription]
			,[WorkCentreCode]
			,[WorkCentreCodeDescription]
	) AS [A]
	/*WHERE
		[RN] = 1
	*/
	ORDER BY
		[Operation]
	
	;

	

	SELECT
		*
	FROM (
		SELECT
			ROW_NUMBER() OVER(
				PARTITION BY
					[Operation]
				ORDER BY
					[ClkTransaction].[TransactionID] DESC
			) AS [RN]
			,[Operation]
			,[OperationDescription]
			,[WorkCentreCode]
			,[WorkCentreCodeDescription]
		FROM
			[SysproCompanyA].[dbo].[WipJobPost] [P]
		WHERE
			LTRIM(RTRIM(ISNULL([OperationDescription], ''))) <> ''
		GROUP BY
			[ClkTransaction].[TransactionID]
			,[Operation]
			,[OperationDescription]
			,[WorkCentreCode]
			,[WorkCentreCodeDescription]
	) AS [A]
	/*WHERE
		[RN] = 1
	*/
	ORDER BY
		[Operation]
	
	;
--GO


