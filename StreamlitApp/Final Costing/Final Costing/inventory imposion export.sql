DECLARE
	@sSD DATETIME = '2025-01-01',
	@sED DATETIME = DATEADD(MONTH, 1, GETDATE())

SELECT 
    [StockCode],
    [JnlDate],
    [RowID], 
    (CASE WHEN [ColumnName] = 'MaterialCost' THEN CAST([Before] AS DECIMAL(18, 5)) ELSE 0 END) AS [Before Material Cost],
    (CASE WHEN [ColumnName] = 'MaterialCost' THEN CAST([After] AS DECIMAL(18, 5)) ELSE 0 END) AS [After Material Cost],
    (CASE WHEN [ColumnName] = 'LabourCost' THEN CAST([Before] AS DECIMAL(18, 5)) ELSE 0 END) AS [Before Labour Cost],
    (CASE WHEN [ColumnName] = 'LabourCost' THEN CAST([After] AS DECIMAL(18, 5)) ELSE 0 END) AS [After Labour Cost],
    (CASE WHEN [ColumnName] = 'FixedOverhead' THEN CAST([Before] AS DECIMAL(18, 5)) ELSE 0 END) AS [Before Fixed Overhead],
    (CASE WHEN [ColumnName] = 'FixedOverhead' THEN CAST([After] AS DECIMAL(18, 5)) ELSE 0 END) AS [After Fixed Overhead],
	[ColumnName]
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY 
				[StockCode], 
				YEAR([JnlDate]),
				MONTH([JnlDate]),
				[ColumnName]
			ORDER BY
				[StockCode],
				[JnlDate]
		) AS [RowID],
		[JnlDate],
		[StockCode],
		[ColumnName],
		[Before],
		[After]
	FROM 
		[SysproCompanyA].[dbo].[InvMastAmendJnl] WITH (NOLOCK)
	WHERE
		[OperatorCode] = 'ROBOT'
		AND [JnlDate] BETWEEN @sSD AND @sED
		/*AND [StockCode] IN (
		
			For iLoop = 0 To Me.ListOfStockCodes.ListCount - 1
				sQuerySQL = sQuerySQL & "'" & Me.ListOfStockCodes.ItemData(iLoop) & "',"
				sFileName = sFileName & Me.ListOfStockCodes.ItemData(iLoop) & ", " 'Also, prep the file name string
			Next
		
			1
		)*/
) AS [mainsub]
WHERE 
	[RowID] = 1
ORDER BY
	[StockCode],
	[JnlDate],
	[RowID]
;




SELECT 
	[InvMaster].[StockCode],
	[InvMaster].[Description],
	[InvMaster].[LongDesc]
FROM 
	[SysproCompanyA].[dbo].[InvMaster]
GROUP BY
	[InvMaster].[StockCode],
	[InvMaster].[Description],
	[InvMaster].[LongDesc]
; 