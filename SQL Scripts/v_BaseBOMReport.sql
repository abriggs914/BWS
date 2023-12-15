USE [SysproCompanyA]
GO

----/****** Object:  View [dbo].[v_BaseBOMReport]    Script Date: 2023-12-14 3:11:11 PM ******/

-- 2023-12-15 Avery Briggs - Added "Times Sold" as a new column.

----SET ANSI_NULLS ON
----GO

----SET QUOTED_IDENTIFIER ON
----GO



--DECLARE @mn NVARCHAR(MAX) = '51LF4X5T V2018';


ALTER view [dbo].[v_BaseBOMReport] as 

--SELECT [Model No] FROM (

select distinct 
	case 
		when Proposed = 1 then
			'Proposed'
		when [Non-Current] = 0 and Proposed = 0 then
			'Current' 
		else
			'Non-Current'
	end as [Current/Proposed],
	[Non-Current],
	Proposed,
	Class,
	Products.[Model No],
	InvMaster.StockCode,
	cast(LabourCost + MaterialCost + FixOverhead + VariableOverhead as decimal(14, 2)) as TotalCost,
	cast(LastSold as date) as LastSold,
	cast(LastCostUpdate as date) as LastRecost 
	,ISNULL([TimesOrdered], 0) AS [TimesOrdered]
	,[OrderedModels].[ProductID]
from 
	BWSdb.dbo.Products with (nolock)
left outer join (
	select 
		[Model No],
		[ProductID],
		max([Quote Date]) as LastSold
	from
		BWSdb.dbo.Orders with (nolock)
	group by
		[Model No]
		,[ProductID]
) as subLastSold
on
	--Products.[Model No] = subLastSold.[Model No]
	[Products].[IDTrailer] = [subLastSold].[ProductID]
LEFT JOIN (
	SELECT
		[Model No]
		,[ProductID]
		, COUNT(*) AS [TimesOrdered]
	FROM
		[BWSdb].[dbo].[Orders]
	WHERE
		([Order Date] IS NOT NULL)
		AND ([Date Declined] IS NULL) 
		AND ([Decline/Rejected] = 4)
	GROUP BY
		[ProductID]
		,[Model No]
) AS [OrderedModels]
ON
	[Products].[IDTrailer] = [OrderedModels].[ProductID]
inner join 
	InvMaster with (nolock) 
on
	Products.[Top Level Part# (SYSPRO 8)] collate Latin1_General_BIN = InvMaster.StockCode
;

GO

--WHERE
--	[Products].[Model No] = @mn

----) AS [Src]
----GROUP BY
----	[Model No]
----HAVING COUNT(*) > 1

--ORDER BY
--	[Class]
--	,[Model No]


------ Times a model was quoted
----SELECT
----	[Model No]
----	, COUNT(*) AS [TimesQuoted]
----FROM
----	[BWSdb].[dbo].[Orders]
----GROUP BY
----	[Model No]
----;

---- Times a model was ordered and not declined
--SELECT
--	[Model No]
--	, [ProductID]
--	, COUNT(*) AS [TimesOrdered]
--FROM
--	[BWSdb].[dbo].[Orders]
--WHERE
--	([Order Date] IS NOT NULL)
--	AND ([Date Declined] IS NULL) 
--	AND ([Decline/Rejected] = 4)

--	AND [Model No] = @mn
--GROUP BY
--	[Model No]
--	, [ProductID]
--ORDER BY
--	[Model No]
--;

--SELECT
--	[Quote#]
--	,[Model No] 
--	,[Quote Date]
--	,[ProductID]
--FROM
--	[BWSdb].[dbo].[Orders]
--WHERE
--	[Model No] = @mn
--ORDER BY
--	[Model No]
--;

--SELECT
--	*
--FROM
--	[BWSdb].[dbo].[Products]
--WHERE
--	([Model No] = @mn)
--	OR ([IDTrailer] IN (1712))
--ORDER BY
--	[Model No]

----GO

--	SELECT
--		[Model No]
--		,[ProductID]
--		, COUNT(*) AS [TimesOrdered]
--		, MAX([Quote Date]) AS [Last Sold]
--	FROM
--		[BWSdb].[dbo].[Orders]
--	WHERE
--		([Order Date] IS NOT NULL)
--		AND ([Date Declined] IS NULL) 
--		AND ([Decline/Rejected] = 4)

--		AND [Model No] = @mn
--	GROUP BY
--		[ProductID]
--		,[Model No]
--ORDER BY
--	[Model No]
--;

--select 
--	[Model No],
--	[ProductID],
--	max([Quote Date]) as LastSold
--from
--	BWSdb.dbo.Orders with (nolock)
--group by
--	[Model No]
--	,[ProductID]
--ORDER BY
--	[ProductID]

	
----DECLARE @mn1 NVARCHAR(MAX) = '51LF3X5T';
----DECLARE @mn2 NVARCHAR(MAX) = '51LF4X5T V2018';
----SELECT
----	[Model No],
----	[IDTrailer]
----FROM
----	[BWSdb].[dbo].[Products]
----WHERE
----	[Model No] IN (@mn1, @mn2)

----BEGIN TRAN;

----SELECT
----	[Model No],
----	[ProductID],
----	[Quote#]
----FROM
----	[BWSdb].[dbo].[Orders]
----WHERE
----	[Model No] IN (@mn1, @mn2)

----UPDATE
----	[BWSdb].[dbo].[Orders]
----SET
----	[ProductID] = [IDTrailer]
----FROM
----	[BWSdb].[dbo].[Products] AS [P]
----INNER JOIN
----	[BWSdb].[dbo].[Orders] AS [O]
----ON
----	[P].[Model No] = [O].[Model No]
----WHERE
----	[O].[Model No] = @mn1

----SELECT
----	[Model No],
----	[ProductID],
----	[Quote#]
----FROM
----	[BWSdb].[dbo].[Orders]
----WHERE
----	[Model No] IN (@mn1, @mn2)

----ROLLBACK;
----COMMIT;