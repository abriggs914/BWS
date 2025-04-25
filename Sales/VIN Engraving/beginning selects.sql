
-- Gathering the data for VIN Engraving
-- [Axle] does not exist for STG so it is not really tracked correctly

SELECT
	[SGQuote]
	,[Model No]
	,[Serial Number]
	,[GVWR]
	--,[Date In Service]
	--,[Date Registered]
	--,[Date Requested]
	,[Delivery Date]
	--,[Finish Date]
	,[UnitQtyReqd]
	,[M].*
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[SysproCompanyS].[dbo].[WipJobAllMat] [M]
ON
	CAST([O].[WO#] AS NVARCHAR(MAX)) = [M].[Job]
LEFT JOIN
	[SysproCompanyS].[dbo].[InvMaster] [I]
ON
	[M].[StockCode] = [I].[StockCode]
WHERE
	([SGQuote] = 'SG101437')
	AND (
		(LOWER([I].[Description]) LIKE '%axle%')
		OR (LOWER([I].[LongDesc]) LIKE '%axle%')
	)

where    
    Mass <> 0    
    and (        
        lower(Description) like '%axle%'        
        or lower(LongDesc) like '%axle%'    
    )


SELECT
	[Quote#]
	,[O].[WO#]
	,[Model No]
	,[Serial Number]
	,[GVWR]
	,[Delivery Date]
	,[AXLE #1]
	,[AXLE #2]
	,[AXLE #3]
	,[AXLE #4]
	/*,[Tire]
	,[Rim]*/
FROM
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[Axle] [A]
ON
	[O].[WO#] = [A].[WO#]
WHERE
	[Quote#] = 30604

	
SELECT
	*
FROM
	[BWSdb].[dbo].[Axle]

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	[WO#] = 10017192
