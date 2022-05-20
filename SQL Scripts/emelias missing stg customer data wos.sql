USE SysproCompanyS
GO

SELECT 
	[Job], [JobDescription], [WipMaster].[Customer],
	[CustomerName], [WO#], [CustomersV2].[Customer],
	[Address], [City], [Province/State], [Postal Code/ZIP],
	[Phone], [Cell], [Email],
	[Contact], [Notes], [SGQuote]
FROM
	[WipMaster] 
LEFT JOIN
	[BWSdb].[dbo].[CustomersV2]
ON
	[WipMaster].[Customer] = CAST([CustomersV2].[ID#] AS NVARCHAR(MAX))
WHERE 
	RIGHT([Job], 3) IN (
		'491', '490', '605', '476', '468',
		'543', '596', '597', '573', '572',
		'531', '530', '487', '598', '627',
		'589', '628'
	)
	AND LEFT([Job], 1) = '1'
ORDER BY
	[Job]

	
SELECT 
	[customer_timestamp]
	--,
	--[Job], [JobDescription], [WipMaster].[Customer],
	--[CustomerName], [WO#], [CustomersV2].[Customer],
	--[Address], [City], [Province/State], [Postal Code/ZIP],
	--[Phone], [Cell], [Email],
	--[Contact], [Notes], [SGQuote]
FROM
	[WipMaster] 
LEFT JOIN
	[BWSdb].[dbo].[CustomersV2]
ON
	[WipMaster].[Customer] = [CustomersV2].[ID#]
ORDER BY
	[customer_timestamp]



SELECT * FROM 
	[BWSdb].[dbo].[CustomersV2]