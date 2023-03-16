USE BWSdb
GO


DECLARE @q AS NVARCHAR(MAX) = 'SG101115';
DECLARE @d AS NVARCHAR(MAX) = 'rim';
DECLARE @group INT = 1;
DECLARE @section INT = 25;

DECLARE @t TABLE (
	[Quote] NVARCHAR(MAX),
	[Model No] NVARCHAR(MAX),
	[Dealer] INT,
	[Customer] INT,
	[WO] NVARCHAR(8)
);

INSERT INTO @t ([Quote])
SELECT @q;

UPDATE
	@t
SET
	[Model No] = [OrdersV2].[Model No]
	, [Dealer] = [OrdersV2].[DealerID]
	, [Customer] = [OrdersV2].[CustID]
	, [WO] = [OrdersV2].[WO#]
FROM
	[OrdersV2]
WHERE
	[@t].[Quote] = [OrdersV2].[SGQuote];

SELECT * FROM @t; 

SELECT
* FROM [OrdersV2]

	INNER JOIN
	@t
	ON
	[OrdersV2].[Model NO] = [@t].[Model No]

--SELECT
--	*
--FROM
--	[Order OptionsV2]
--WHERE
--	[SGQuote] = @q;

--SELECT
--	*
--FROM
--	[Order OptionsV2_SpecLines]
--WHERE
--	[SGQuote] = @q;

--SELECT
--	*
--FROM
--	[Order OptionsV2_FactoryLines]
--WHERE
--	[SGQuote] = @q;

--SELECT
--	*
--FROM
--	[OrdersV2]
--WHERE
--	[SGQuote] = @q;

--SELECT
--	*
--FROM
--	[OptionsV2]
--INNER JOIN
--	@t
--ON
--	[OptionsV2].[Model No] = [@t].[Model No];

SELECT
	*
FROM
	[Options_SpecLinesV2]
INNER JOIN
	@t
ON
	[Options_SpecLinesV2].[Model No] = [@t].[Model No]
WHERE
	(CASE WHEN @d IS NOT NULL THEN
		(CASE WHEN [Description] LIKE '%' + @d + '%' THEN 0 ELSE 1 END)
	ELSE (CASE WHEN ([SpecSortG] = @group AND [SpecSortSe] = @section) THEN 0 ELSE 1 END)
	END)
	= 0
ORDER BY
	[Options_SpecLinesV2].[Model No]
;

SELECT
	*
FROM
	[Options_FactoryLinesV2]
INNER JOIN
	@t
ON
	[Options_FactoryLinesV2].[Model No] = [@t].[Model No]
WHERE
	(CASE WHEN @d IS NOT NULL THEN
		(CASE WHEN [Description] LIKE '%' + @d + '%' THEN 0 ELSE 1 END)
	ELSE (CASE WHEN ([SpecSortG] = @group AND [SpecSortSe] = @section) THEN 0 ELSE 1 END)
	END)
	= 0
ORDER BY
	[Options_FactoryLinesV2].[Model No]
;
