-- Take the new [Available Date] value, go ahead 3 working days in the Stargate Syspro Company Calendar, then assign this to the @newdeliverydate variable
select @newdeliverydate = subB.CalendarDate
FROM
    (
        select CalendarDate, row_number() over ( order by CalendarDate asc) as rn, WorkDay
        from SysproCompanyS.dbo.v_CalendarWorkDays with (nolock)
        where WorkDay = 1
    ) as subA
inner JOIN
    (
        select CalendarDate, row_number() over ( order by CalendarDate asc) as rn, WorkDay
        from SysproCompanyS.dbo.v_CalendarWorkDays with (nolock)
        where WorkDay = 1
    ) as subB
ON
    subB.rn - subA.rn = 3
WHERE
    subA.CalendarDate = @ad

-- Update dates in OrdersV2 table
update [BWSdb].[dbo].OrdersV2
set
    [Finish Date] = @ad
    , [Delivery Date] = @newdeliverydate
WHERE
    SGQuote = @sgquote


-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------


-- Update dates in OrdersV2 table
UPDATE
	[BWSdb].[dbo].[OrdersV2] --[O]
SET
    --[O].[Finish Date] = @ad
    --[O].[Delivery Date] = @newdeliverydate
    [Delivery Date] = @newdeliverydate
WHERE
    SGQuote = @sgquote


SELECT
	[Delivery Date]
	,DAY([Delivery Date]) [DayOfMonth]
	,DATEPART(DW, [Delivery Date]) [DayOfWeek]
	,(CASE WHEN
		
		THEN 
		ELSE
			DATEADD(DAY, 3, [Delivery Date])
	END) AS [Plus3WorkDays]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
INNER JOIN
	[SysproCompanyS].[dbo].[v_CalendarWorkDays] [W]
ON
	[O].[Delivery Date] = [W].[CalendarDate]




SELECT
	*
	/*[W1].*
	,[W2].*
	--, AS [Plus3Days]*/
FROM
	[SysproCompanyS].[dbo].[v_CalendarWorkDays] [W1]
INNER JOIN
	[SysproCompanyS].[dbo].[v_CalendarWorkDays] [W2]
ON
	DATEADD(DAY, 3, [W1].[CalendarDate]) <= [W2].[CalendarDate]
	AND ((ISNULL([W1].[WorkDay], 0) = 1) AND (ISNULL([W2].[WorkDay], 0) = 1))
ORDER BY
	[W1].[CalendarDate]
	,[W2].[CalendarDate]


	
SELECT
	*
	/*[W1].*
	,[W2].*
	--, AS [Plus3Days]*/
FROM
	[SysproCompanyS].[dbo].[v_CalendarWorkDays] [W1]
INNER JOIN (
	SELECT --TOP 1
		*
		--MIN([CalendarDate]) AS []
	FROM (
		SELECT
			ROW_NUMBER() OVER(
				--PARTITION BY
				--	[CalendarDate]
				ORDER BY
					[CalendarDate]
			) AS [RN],
			*
		FROM
			[SysproCompanyS].[dbo].[v_CalendarWorkDays] [A]
	) AS [B]
	WHERE
		([CalendarDate] IS NOT NULL)
		AND (ISNULL([WorkDay], 0) = 1)
	/*ORDER BY
		[CalendarDate]
		*/
) AS [W2]
ON
	DATEADD(DAY, 3, [W1].[CalendarDate]) <= [W2].[CalendarDate]
	AND ((ISNULL([W1].[WorkDay], 0) = 1) AND (ISNULL([W2].[WorkDay], 0) = 1))
--WHERE
	--[W2].[RN] = 1
ORDER BY
	[W1].[CalendarDate]
	,[W2].[CalendarDate]



SELECT
	[BWSdb].[dbo].[NEXT_BUSINESS_DAY]('2024-06-13', 2) AS [NewDate]
	,[BWSdb].[dbo].[NEXT_BUSINESS_DAY]('2024-06-14', 2) AS [NewDate]
	,[BWSdb].[dbo].[NEXT_BUSINESS_DAY]('2024-06-15', 2) AS [NewDate]
	,[BWSdb].[dbo].[NEXT_BUSINESS_DAY]('2024-06-16', 2) AS [NewDate]
	,[BWSdb].[dbo].[NEXT_BUSINESS_DAY]('2024-06-17', 2) AS [NewDate]