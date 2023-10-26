USE BWSdb
GO

DECLARE @fiscalyear int, @dealerid int, @version int, @companyID INT = 0, @fx DECIMAL(18, 6)=1

SELECT @fiscalyear=2024, @dealerid=52376, @version=1, @companyid=1, @fx=1

exec [sp_BudgetForecastV2_RptByClassSpecificDealer V2] @fiscalyear, @dealerid, @version, @fx, @companyID

EXEC [sp_BudgetForecastV2_RptByClassMonthlyUnits] @fiscalyear, @version, 0

EXEC [sp_BudgetForecastV2_ForecastEditDataFetch] @fiscalyear, @dealerid, @version,

---- Solving sp_BudgetForecastV2_ForecastEditDataFetch

--exec sp_BudgetForecastV2_ForecastEditDataFetch @fiscalyear, @dealerid, @version, @companyID

--declare @listofdealerIDs table
--(
--	DealerIDs int
--);

--select distinct ID from DealersV2 with (nolock)
--		where [COMPANY NAME] = (select [COMPANY NAME] from [DealersV2] with (nolock) where ID = @dealerid)
--;

--SELECT *
--from ProductsV2 with (nolock)
--cross join DealersV2 with (nolock)
--where Proposed = 0
--and [Non-Current] = 0
--and ID = @dealerid
--and [ProductsV2].[CompanyID] = 1
--;

--SELECT 
--'--Just Where' AS [T],
--*
--FROM
-- [Budget Forecast V2]
-- where [Budget Forecast V2].Fiscal = @fiscalyear AND ([Budget Forecast V2].[CompanyID] = 1)
--			  --and Dealer = @dealerid
--			  and Version = @version
--;


--		select Dealer, Version, Class, [Model No], [Discount 1], [Discount 2], [Discount 3], [Expected Margin],
--		[1] as Month1, [2] as Month2, [3] as Month3, [4] as Month4, [5] as Month5, [6] as Month6,
--		[7] as Month7, [8] as Month8, [9] as Month9, [10] as Month10, [11] as Month11, [12] as Month12, [CompanyID]
--		from (select Dealer, Version, Class, [Model No],
--			  [Discount 1], [Discount 2], [Discount 3], [Expected Margin], MonthID, NoUnits, [CompanyID]
--			  from [Budget Forecast V2] with (nolock)
--			  inner join (select Fiscal, BudYear, BudMonth,
--						  ROW_NUMBER() over(order by Fiscal desc, BudYear, BudMonth) as MonthID
--						  from (select distinct Fiscal, BudYear, BudMonth
--								from [Budget Forecast V2] with (nolock)
--								where ([Budget Forecast V2].[CompanyID] = 1) AND (Fiscal = @fiscalyear
--								and Dealer = @dealerid)) as subA) as subRowID on [Budget Forecast V2].Fiscal = subRowID.Fiscal
--																	  and [Budget Forecast V2].BudYear = subRowID.BudYear
--																	  and [Budget Forecast V2].BudMonth = subRowID.BudMonth
--			  inner join @listofdealerIDs as subList on [Budget Forecast V2].Dealer = subList.DealerIDs
--			  where [Budget Forecast V2].Fiscal = @fiscalyear AND ([Budget Forecast V2].[CompanyID] = 1)
--			  --and Dealer = @dealerid
--			  and Version = @version) as subPivot
--		pivot (sum(NoUnits) for MonthID in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) as pvt
--;