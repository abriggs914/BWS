USE BWSdb
GO

--SELECT	
--	*
--FROM
--	[Orders] WITH (NOLOCK)
--ORDER BY
--	[Quote#] DESC
	
--SELECT
--	[ID]
--FROM
--	[Dealers]
--;

--DECLARE @I AS INTEGER = 0;
--SET @I = 15;

--DECLARE a number(2);
--BEGIN
--FOR @I IN (SELECT [ID] FROM [Dealers])
--exec sp_DealerStatusReportV2 330
--END
--;


--EXEC sp_DealerStatusReportV2 330;
--EXEC sp_DealerStatusReportV2 33;
--EXEC sp_DealerStatusReportV2 1;
--EXEC sp_DealerStatusReportV2 100;
--EXEC sp_DealerStatusReportV2 45;
--EXEC sp_DealerStatusReportV2 340;
--EXEC sp_DealerStatusReportV2 19;

--EXEC sp_DealerStatusReportUOO 330;
--EXEC sp_DealerStatusReportUOO 33;
--EXEC sp_DealerStatusReportUOO 1;
--EXEC sp_DealerStatusReportUOO 100;
--EXEC sp_DealerStatusReportUOO 45;
--EXEC sp_DealerStatusReportUOO 340;
--EXEC sp_DealerStatusReportUOO 19;

--DECLARE @today DATETIME = CAST(GETDATE() AS DATE)
--EXEC sp_InventoryValuation @today

--SELECT	
--	EXEC sp_DealerStatusReportUOO @dealerid = [ID] AS [Data]
--FROM
--	[Dealers]
--;

DECLARE @idColumn INT;
DECLARE @minidColumn INT;
DECLARE @BWSStatusReport TABLE
	(
		[QueryID] INT,
		[Quote#] INT,
		[WO#] INT,
		[SalesOrder] VARCHAR(6),
		[Model No] NVARCHAR(50),
		[Serial Number] NVARCHAR(255),
		[Purchase Order] NVARCHAR(255),
		[Payment Terms] NVARCHAR(255),
		[Company Name] NVARCHAR(50),
		[Order Date] DATETIME,
		[Invoice Date] DATETIME,
		[Available Date] DATETIME,
		[Delivery Date] DATETIME,
		[Date Completed] DATETIME,
		[Shipped Date] DATETIME,
		[Date In Service] DATETIME,
		[Date Registered] DATETIME,
		[US Sale] BIT,
		[Selling Price (Pre V2)] DECIMAL(14, 0),
		[Selling Price] DECIMAL(14, 0),
		[Customer] NVARCHAR(255),
		[DOG] INT,
		[Class] NVARCHAR(255),
		[DealerID] INT,
		[SlotNo] INT,
		[LastBOL] INT,
		[PO Delivery Date] DATETIME		
	)

SELECT @idColumn = min( ID ) FROM [Dealers];
WHILE @idColumn IS NOT NULL
BEGIN
    /*
        Do all the stuff that you need to do
    */
	--EXEC sp_DealerStatusReportUOO @idColumn;
	INSERT INTO @BWSStatusReport
	EXEC sp_DealerStatusReportUOO @idColumn;
    SELECT @idColumn = MIN( ID ) FROM [Dealers] WITH (NOLOCK) WHERE [ID] > @idColumn AND [ID] < 8;
END

SELECT * FROM @BWSStatusReport


--SELECT @idColumn = MIN( ID ) FROM [Dealers] WHERE [ID] > @idColumn;
--SELECT @idColumn AS [Column];
--INSERT INTO @BWSStatusReport
--EXEC sp_DealerStatusReportUOO @idColumn


--SELECT @idColumn = MIN( ID ) FROM [Dealers] WHERE [ID] > @idColumn;
--SELECT * FROM @BWSStatusReport


--EXEC sp_DealerStatusReportUOO 0;
--EXEC sp_DealerStatusReportUOO 1;
--EXEC sp_DealerStatusReportUOO 2;
--EXEC sp_DealerStatusReportUOO 3;
--EXEC sp_DealerStatusReportUOO 4;
--EXEC sp_DealerStatusReportUOO 5;
DECLARE @t table
	(
		Quote# int,
		WO# int,
		SalesOrder varchar(6),
		[Model No] nvarchar(50),
		[Serial Number] nvarchar(255),
		[Purchase Order] nvarchar(255),
		[Payment Terms] nvarchar(255),
		[Company Name] nvarchar(50),
		[Order Date] datetime,
		[Invoice Date] datetime,
		[Available Date] datetime,
		[Delivery Date] datetime,
		[Date Completed] datetime,
		[Shipped Date] datetime,
		[Date In Service] datetime,
		[Date Registered] datetime,
		[US Sale] bit,
		[Selling Price (Pre V2)] decimal(14, 0),
		[Selling Price] decimal(14, 0),
		Customer nvarchar(255),
		DOG int,
		Class nvarchar(255),
		DealerID int,
		SlotNo int,
		LastBOL int,
		[PO Delivery Date] datetime,
		[CURRENT DEALER] BIT
	)

EXEC sp_DealerStatusReportUOO;
EXEC sp_DealerStatusReportV2 23;

SELECT * FROM [Dealers] WHERE [COMPANY NAME] LIKE '%transit%' ORDER BY [COMPANY NAME]