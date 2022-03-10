USE [BWSdb]
GO

ALTER PROCEDURE [dbo].[sp_PVCollectOrders] 

@sd AS DATETIME=NULL,-- = '2022-03-01'
@ed AS DATETIME=NULL,-- = '2022-03-10'
@id AS INTEGER=NULL -- = '2022-03-10'

AS BEGIN

	IF @sd IS NULL BEGIN
		SELECT @sd = MIN([PO Date]) FROM [Orders] WITH (NOLOCK)
	END
	IF @ed IS NULL BEGIN
		SELECT @ed = MAX([PO Date]) FROM [Orders] WITH (NOLOCK)
	END
	IF @id IS NULL BEGIN
		SELECT
			[Orders].*,
			[Customers].[Customer],
			[Dealers].[COMPANY NAME]
		FROM
			[Orders] WITH (NOLOCK)
		LEFT JOIN
			[Customers]
		ON
			[Customers].[ID#] =	[Orders].[CustID]
		LEFT JOIN
			[Dealers]
		ON
			[Orders].[DealerID] = [Dealers].[ID]
		WHERE
			(
				[PriceSecured] IS NULL 
				OR [PriceSecured] = 0
			)
			AND [PO Date] BETWEEN @sd AND @ed

	END
	ELSE BEGIN 
		SELECT
			[Orders].*,
			[Customers].[Customer],
			[Dealers].[COMPANY NAME]
		FROM
			[Orders] WITH (NOLOCK)
		LEFT JOIN
			[Customers]
		ON
			[Customers].[ID#] =	[Orders].[CustID]
		LEFT JOIN
			[Dealers]
		ON
			[Orders].[DealerID] = [Dealers].[ID]
		WHERE
			(
				[PriceSecured] IS NULL 
				OR [PriceSecured] = 0
			)
			AND [PO Date] BETWEEN @sd AND @ed
			AND [DealerID] = @id
	END
END