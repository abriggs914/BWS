
DECLARE @poS NVARCHAR(255);

DECLARE @partsData TABLE (
	[ID] INT IDENTITY(0,1),
	[StockCode] NVARCHAR(512), 
	[JnlDate] DATETIME, 
	[QtyReceived] DECIMAL(18, 5), 
	[PriceReceived] DECIMAL(18, 5),
	[Reference] NVARCHAR(512), 
	[MQtyOrdered] DECIMAL(18, 5), 
	[MQtyReceived] DECIMAL(18, 5), 
	[Complete] INT
);
DECLARE @html NVARCHAR(MAX);

SELECT @poS = '000000000149144'

INSERT INTO @partsData ([StockCode], [JnlDate], [QtyReceived], [PriceReceived], [Reference], [MQtyOrdered], [MQtyReceived], [Complete])
SELECT
	[PD].[MStockCode],
	[PH].[JnlDate],
	[PH].[QtyReceived],
	[PH].[PriceReceived],
	[PH].[Reference],
	[PD].[MOrderQty],
	[PD].[MReceivedQty],
	(CASE WHEN [PD].[MOrderQty] <= [PD].[MReceivedQty] THEN 1 ELSE 0 END) AS [Complete]
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [PD]
FULL OUTER JOIN
	[SysproCompanyA].[dbo].[PorHistReceipt] [PH]
ON
	([PH].[PurchaseOrder] = [PD].[PurchaseOrder])
	AND ([PH].[StockCode] = [PD].[MStockCode])
WHERE
	([PD].[PurchaseOrder] = @poS)
	AND (ISNULL([PD].[MStockCode], '') <> '')
ORDER BY
	[PH].[Journal],
	[PH].[JournalEntry]
;

SELECT * FROM [SysproCompanyA].[dbo].[PorHistReceipt] [PH] WHERE ([PH].[PurchaseOrder] = @poS)
SELECT * FROM [SysproCompanyA].[dbo].[PorMasterDetail] [PD] WHERE ([PD].[PurchaseOrder] = @poS)
SELECT * FROM @partsData;

DECLARE @i INT;
DECLARE @c INT;
DECLARE @StockCode NVARCHAR(512);
DECLARE @JnlDate NVARCHAR(512);
DECLARE @QtyReceived NVARCHAR(512);
DECLARE @PriceReceived NVARCHAR(512);
DECLARE @Reference NVARCHAR(512);
DECLARE @MQtyOrdered NVARCHAR(512);
DECLARE @MQtyReceived NVARCHAR(512); 
DECLARE @Complete NVARCHAR(512);

SELECT 
	@html = '<table border="1" cellpadding="5" cellspacing="5"><thead><tr><th>StockCode</th><th>JnlDate</th><th>QtyReceived</th><th>PriceReceived</th><th>Reference</th><th>MOrderQty</th><th>MReceivedQty</th><th>Complete</th></tr></thead><tbody>',
	@i = 0,
	@c = COUNT(*)
FROM 
	@partsData
;

WHILE @i < @c BEGIN

	SELECT
		@StockCode = ISNULL(CAST([StockCode] AS NVARCHAR(512)), 'N/A'),
		@JnlDate = ISNULL(CAST(CAST([JnlDate] AS DATE) AS NVARCHAR(512)), 'N/A'),
		@QtyReceived = ISNULL(CAST([QtyReceived] AS NVARCHAR(512)), 'N/A'),
		@PriceReceived = ISNULL(CAST([PriceReceived] AS NVARCHAR(512)), 'N/A'),
		@Reference = ISNULL(CAST([Reference] AS NVARCHAR(512)), 'N/A'),
		@MQtyOrdered = ISNULL(CAST([MQtyOrdered] AS NVARCHAR(512)), 'N/A'),
		@MQtyReceived = ISNULL(CAST([MQtyReceived] AS NVARCHAR(512)), 'N/A'),
		@Complete = ISNULL(CAST([Complete] AS NVARCHAR(512)), 'N/A')
	FROM
		@partsData
	WHERE
		[ID] = @i
	;
		
	SELECT @html = @html + '<tr>'
	SELECT @html = @html + '<td>' + @StockCode + '</td>'
	SELECT @html = @html + '<td>' + @JnlDate + '</td>'
	SELECT @html = @html + '<td>' + @QtyReceived + '</td>'
	SELECT @html = @html + '<td>' + @PriceReceived + '</td>'
	SELECT @html = @html + '<td>' + @Reference + '</td>'
	SELECT @html = @html + '<td>' + @MQtyOrdered + '</td>'
	SELECT @html = @html + '<td>' + @MQtyReceived + '</td>'
	SELECT @html = @html + '<td style="color:RGB(' 
						+ (CASE WHEN ISNULL(@complete, 0) = 1 THEN '0,186,12' ELSE '186,12,0' END) 
						+ ')">' 
						+ (CASE WHEN ISNULL(@complete, 0) = 1 THEN 'YES' ELSE 'NO' END)
						+ '</td>'
	SELECT @html = @html + '</tr>'

	SELECT @i = @i + 1;
END

SELECT 
	@html = @html + '</tbody></table></html>'
;

SELECT @html AS [HTML]

SELECT
	ISNULL(MIN([FirstDate]), GETDATE()) AS [FirstDate],
	ISNULL(MAX([LastDate]), GETDATE()) AS [LastDate],
	COUNT(*) AS [TimesReceived]
FROM (

	SELECT
		[JnlDate],
		ISNULL(MIN([JnlDate]), 0) AS [FirstDate],
		ISNULL(MAX([JnlDate]), 0) AS [LastDate]
	FROM
		[SysproCompanyA].[dbo].[PorHistReceipt] [P]
	WHERE
		[PurchaseOrder] = @poS
	GROUP BY
		[PurchaseOrder],
		[JnlDate]
) AS [Src]
;
