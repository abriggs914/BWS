

select MAX(CAST(RIGHT([Serial Number], 6) AS INT))
	--select @maxsn2 = COUNT(*) + 2
	from [OrdersV2] with (nolock)
	cross join [SNC Year] with (nolock)
	where
	 RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'M' + '%'
	AND
	LEFT([Serial Number], 3) IN ('2SV')
	AND
	[Date Declined] IS NULL

	EXEC sp_SerialNumberCalcSTG
		@quote='SG101125'
		, @year=2023

IF 1 = 0 BEGIN
	BEGIN TRAN;

	SELECT
		*
	FROM
		[OrdersV2]
	WHERE
		[SGQuote] = 'SG101125'
	;

	UPDATE
		[OrdersV2]
	SET
		[Serial Number] = '2SVS6D134PM000001'
	WHERE
		[SGQuote] = 'SG101125'
	;

	SELECT
		*
	FROM
		[OrdersV2]
	WHERE
		[SGQuote] = 'SG101125'
	;
	
	ROLLBACK;
	COMMIT;
END
IF 2 = 0 BEGIN
	BEGIN TRAN;

	SELECT
		*
	FROM
		[OrdersV2]
	WHERE
		[SGQuote] = 'SG101125'
		OR [SGQuote] = 'SG101126'
	;

	UPDATE
		[OrdersV2]
	SET
		[Serial Number] = NULL
	WHERE
		[SGQuote] = 'SG101125'
		OR [SGQuote] = 'SG101126'
	;

	SELECT
		*
	FROM
		[OrdersV2]
	WHERE
		[SGQuote] = 'SG101125'
		OR [SGQuote] = 'SG101126'
	;
	
	ROLLBACK;
	COMMIT;
END