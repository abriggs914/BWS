
USE SysproCompanyA
GO

CREATE VIEW [v_ProdOperationNames] AS

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
		FROM
			[ClkTransaction]
		WHERE
			LTRIM(RTRIM(ISNULL([OperationDescription], ''))) <> ''
		GROUP BY
			[ClkTransaction].[TransactionID]
			,[Operation]
			,[OperationDescription]
	) AS [A]
	WHERE
		[RN] = 1
	/*ORDER BY
		[Operation]
	*/
	;