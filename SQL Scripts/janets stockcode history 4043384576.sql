USE SysproCompanyA
GO

DECLARE @s1 AS NVARCHAR(10) = '4043384576';
DECLARE @s2 AS NVARCHAR(5) = '43384';
--SELECT @s2 = NULL

DECLARE @d1 AS DATETIME = '2022-11-01';
DECLARE @d2 AS DATETIME = '2023-02-28';

SELECT
	'[WipJobAmendJnl]' AS [T],
	*
FROM
	[WipJobAmendJnl]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
	AND [JnlDate] BETWEEN @d1 AND @d2
;

--------------------------------------------------
--------------------------------------------------


SELECT
	'[InvWhAmendJnl]' AS [T],
	*
FROM
	[InvWhAmendJnl]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
	AND [JnlDate] BETWEEN @d1 AND @d2
;
--------------------------------------------------


SELECT
	'[InvMastAmendJnl]' AS [T],
	*
FROM
	[InvMastAmendJnl]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
	AND [JnlDate] BETWEEN @d1 AND @d2
;
--------------------------------------------------


SELECT
	'[WipLabJnl]' AS [T],
	*
FROM
	[WipLabJnl]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
;
--------------------------------------------------



SELECT
	'[InvMovements]' AS [T],
	*
FROM
	[InvMovements]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
	AND [EntryDate] BETWEEN @d1 AND @d2
;
--------------------------------------------------



SELECT
	'[WipJobAllMat]' AS [T],
	*
FROM
	[WipJobAllMat]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
	--AND [EntryDate] BETWEEN @d1 AND @d2
;

DECLARE @j1 AS NVARCHAR(15) = '000000000139118'

SELECT
	'[WipMaster]' AS [T],
	*
FROM
	[WipMaster]
WHERE
	--[Job] = @j1
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
;

---------------------------------------------------------------------------------

SELECT
	'[InvWarehouse]' AS [T],
	*
FROM
	[InvWarehouse]
WHERE
	(
		[StockCode] = @s1
	OR
		[StockCode] = @s2
	)
	--AND [EntryDate] BETWEEN @d1 AND @d2
;


--------------------------------------------------

SELECT
	'[MrpInvInspect]' AS [T],
	*
FROM
	[MrpInvInspect]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
	--AND [EntryDate] BETWEEN @d1 AND @d2
;


--------------------------------------------------

SELECT
	'[MrpRequirement]' AS [T],
	*
FROM
	[MrpRequirement]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
	--AND [EntryDate] BETWEEN @d1 AND @d2
;
--------------------------------------------------

SELECT
	'[MrpAllMatLot]' AS [T],
	*
FROM
	[MrpAllMatLot]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
	--AND [EntryDate] BETWEEN @d1 AND @d2
;
--------------------------------------------------

SELECT
	'[MrpBuildSchedJnl]' AS [T],
	*
FROM
	[MrpBuildSchedJnl]
WHERE
	(
		[StockCode] LIKE '%' + @s1 + '%'
	OR
		[StockCode] LIKE '%' + @s2 + '%'
	)
	--AND [EntryDate] BETWEEN @d1 AND @d2
;
--------------------------------------------------

SELECT
	'[PorMasterDetail]' AS [T],
	*
FROM
	[PorMasterDetail]
WHERE
	(
		[MStockCode] LIKE '%' + @s1 + '%'
	OR
		[MStockCode] LIKE '%' + @s2 + '%'
	)
	--AND [EntryDate] BETWEEN @d1 AND @d2
;


--------------------------------------------------

SELECT
	'[SorDetail]' AS [T],
	*
FROM
	[SorDetail]
WHERE
	(
		[MStockCode] LIKE '%' + @s1 + '%'
	OR
		[MStockCode] LIKE '%' + @s2 + '%'
	)
	--AND [EntryDate] BETWEEN @d1 AND @d2
;