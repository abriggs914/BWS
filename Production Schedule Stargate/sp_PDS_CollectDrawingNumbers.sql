USE SysproCompanyA
GO

--DECLARE @job NVARCHAR(MAX) = '10001266';

ALTER PROCEDURE [sp_PDS_CollectDrawingNumbers]
	@job NVARCHAR(MAX),
	@compID INT = NULL
AS BEGIN

	SELECT
		*
	FROM (
		SELECT
			*
		FROM (
			SELECT 
				0 AS [CompID], 
				[DrawOfficeNum],
				[OperationOffset],
				CASE
					WHEN [subInfoDrawing].[StockCode] IS NOT NULL THEN 0
					WHEN [Mat].[StockCode] LIKE '%-I%' THEN [UnitQtyReqd]
					ELSE 1
				END AS [QtyToPrint]
			FROM 
				[SysproCompanyA].[dbo].[WipJobAllMat] AS [Mat] WITH (NOLOCK)
			INNER JOIN
				[SysproCompanyA].[dbo].[InvMaster] AS [Inv] WITH (NOLOCK)
			ON
				[Mat].[StockCode] = [Inv].[StockCode]
			LEFT OUTER JOIN (
				SELECT 
					[Job],
					[Inv].[StockCode]
				FROM 
					[SysproCompanyA].[dbo].[WipJobAllMat] AS [Mat] WITH (NOLOCK)
				INNER JOIN 
					[SysproCompanyA].[dbo].[InvMaster] AS [Inv] WITH (NOLOCK)
				ON
					[Mat].[StockCode] = [Inv].[StockCode]
				WHERE
					[ProductClass] IN ('BF', 'INFO')
					AND [Mat].[StockCode] LIKE '%-I%'
			) AS [subInfoDrawing] 
			ON
				[Mat].[Job] = [subInfoDrawing].[Job]
				AND [Mat].[StockCode] + '-I' = [subInfoDrawing].[StockCode]
			where
				[ProductClass] in ('BF', 'INFO')
				AND	[Mat].[Job] = @job
				AND [DrawOfficeNum] <> ''
				AND [UserField3] <> 'Y'

			UNION ALL

			SELECT
				0 AS [CompID],
				[StockCode],
				NULL,
				1
			FROM
				[SysproCompanyA].[dbo].[WipMaster] AS [Mat] WITH (NOLOCK)
			WHERE
				[Job] = @job
		) AS [SrcA]

		UNION ALL (

			SELECT 
				1 AS [CompID], 
				[DrawOfficeNum],
				[OperationOffset],
				CASE
					WHEN [subInfoDrawing].[StockCode] IS NOT NULL THEN 0
					WHEN [Mat].[StockCode] LIKE '%-I%' THEN [UnitQtyReqd]
					ELSE 1
				END AS [QtyToPrint]
			FROM 
				[SysproCompanyS].[dbo].[WipJobAllMat] AS [Mat] WITH (NOLOCK)
			INNER JOIN
				[SysproCompanyS].[dbo].[InvMaster] AS [Inv] WITH (NOLOCK)
			ON
				[Mat].[StockCode] = [Inv].[StockCode]
			LEFT OUTER JOIN (
				SELECT 
					[Job],
					[Inv].[StockCode]
				FROM 
					[SysproCompanyS].[dbo].[WipJobAllMat] AS [Mat] WITH (NOLOCK)
				INNER JOIN 
					[SysproCompanyS].[dbo].[InvMaster] AS [Inv] WITH (NOLOCK)
				ON
					[Mat].[StockCode] = [Inv].[StockCode]
				WHERE
					[ProductClass] IN ('BF', 'INFO')
					AND [Mat].[StockCode] LIKE '%-I%'
			) AS [subInfoDrawing] 
			ON
				[Mat].[Job] = [subInfoDrawing].[Job]
				AND [Mat].[StockCode] + '-I' = [subInfoDrawing].[StockCode]
			WHERE
				[ProductClass] IN ('BF', 'INFO')
				AND	[Mat].[Job] = @job
				AND [DrawOfficeNum] <> ''
				AND [UserField3] <> 'Y'

			UNION ALL

			SELECT
				1 AS [CompID],
				[StockCode],
				NULL,
				1
			FROM
				[SysproCompanyS].[dbo].[WipMaster] AS [Mat] WITH (NOLOCK)
			WHERE
				[Job] = @job
		)
	) AS [Master]
	
	WHERE (
		CASE
			WHEN @compID IS NULL THEN 1
			WHEN @compID = 0 THEN 1  -- BWS
			WHEN @compID = 1 THEN 1  -- STG
			ELSE 0
		END
	) = 1

	ORDER BY
		[OperationOffset]
		,[DrawOfficeNum]

END