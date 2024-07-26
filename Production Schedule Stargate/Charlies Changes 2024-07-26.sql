
BEGIN TRAN;

	SELECT
		'Before' AS [Code]
		, [SGQuote]
		, [WO#]
		, [Model No]
		, [Available Date]
		, [JobAvailableLine]
		, [JobAvailableScheduled]
		, [JobAvailableScheduledBy]
		, [Delivery Date]
		, [SysproCompanyS].[dbo].[GetNthBusinessDay]([Available Date], 3) AS [Calc Delivery Date]
	FROM
		[BWSdb].[dbo].[OrdersV2] [O]
	WHERE
		[SGQuote] IN (
			'SG101641',
			'SG101726',
			'SG101728',
			'SG101717',
			'SG101673',
			'SG101661',
			'SG101332',
			'SG101331',
			'SG101584',
			'SG101582',
			'SG101692',
			'SG101576',
			'SG101606',
			'SG101605',
			'SG101589',
			'SG101632',
			'SG101594',
			'SG101635',
			'SG101662',
			'SG101625',
			'SG101626'
		)
	;

	UPDATE
		[BWSdb].[dbo].[OrdersV2]
	SET
		[Delivery Date] = [SysproCompanyS].[dbo].[GetNthBusinessDay]([O].[Available Date], 3)
	FROM
		[BWSdb].[dbo].[OrdersV2] [O]
	INNER JOIN (
		SELECT
			*
		FROM
			[BWSdb].[dbo].[OrdersV2]
		WHERE
			[SGQuote] IN (
				'SG101641',
				'SG101726',
				'SG101728',
				'SG101717',
				'SG101673',
				'SG101661',
				'SG101332',
				'SG101331',
				'SG101584',
				'SG101582',
				'SG101692',
				'SG101576',
				'SG101606',
				'SG101605',
				'SG101589',
				'SG101632',
				'SG101594',
				'SG101635',
				'SG101662',
				'SG101625',
				'SG101626'
			)
	) AS [SrcA]
	ON
		[O].[SGQuote] = [SrcA].[SGQuote]
	;

	SELECT
		'After' AS [Code]
		, [SGQuote]
		, [WO#]
		, [Model No]
		, [Available Date]
		, [JobAvailableLine]
		, [JobAvailableScheduled]
		, [JobAvailableScheduledBy]
		, [Delivery Date]
		, [SysproCompanyS].[dbo].[GetNthBusinessDay]([Available Date], 3) AS [Calc Delivery Date]
	FROM
		[BWSdb].[dbo].[OrdersV2] [O]
	WHERE
		[SGQuote] IN (
			'SG101641',
			'SG101726',
			'SG101728',
			'SG101717',
			'SG101673',
			'SG101661',
			'SG101332',
			'SG101331',
			'SG101584',
			'SG101582',
			'SG101692',
			'SG101576',
			'SG101606',
			'SG101605',
			'SG101589',
			'SG101632',
			'SG101594',
			'SG101635',
			'SG101662',
			'SG101625',
			'SG101626'
		)
	;
	
ROLLBACK;
COMMIT;