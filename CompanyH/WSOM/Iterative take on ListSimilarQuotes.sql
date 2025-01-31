
-- Iterative take on 'ListSimilarQuotes'
-- 2025-01-30 1828

SET NOCOUNT ON;

DECLARE @sd DATETIME = '2025-01-28';
DECLARE @ed DATETIME = '2025-08-01';

DECLARE @t TABLE (
        [ID] INT IDENTITY(0, 1),
        [Q] INT
);
DECLARE @r TABLE (
        [ID] INT IDENTITY(0, 1),
        [Q] INT,
        [SimQ] INT
);
INSERT INTO @t ([Q])
SELECT
        [Orders].[Quote#]
FROM (
        [BWSdb].[dbo].[Sales Staff] WITH (NOLOCK)
INNER JOIN
        [BWSdb].[dbo].[Orders] WITH (NOLOCK)
ON
        [Sales Staff].[ID-SaleStaff] = [Orders].[Sale PersonID]
)
INNER JOIN
        [BWSdb].[dbo].[Production] WITH (NOLOCK)
ON
        [Orders].[Quote#]=[Production].[Quote#]
WHERE (
        (
                ([Production].[Prod Date]) Between @sd And @ed
        )
        And (
                ([Orders].[WO Reviewed])=0 Or ([Orders].[WO Reviewed]) Is Null
        )
)
/*
ORDER BY
        [Orders].[Model No]
        ,[Production].[Prod Date]
        ,[Orders].[Quote#]
*/
;

DECLARE @i INT;
DECLARE @c INT;
declare @modelno NVARCHAR(255);
declare @quote INT;

SELECT
        @i = 0,
        @c = COUNT(*)
FROM
        @t
;

WHILE @i < @c BEGIN

        SELECT
                @quote = [Q]
        FROM
                @t
        WHERE
                [ID] = @i
        ;

    -- Insert statements for procedure here
        --Grab Model No for future referencing
        SELECT 
			@modelno = (select [Model No]
		from
			[BWSdb].[dbo].Orders with (nolock) 
		where
			Quote# = @quote);

        --Drop and create temp table in tmpdb SQL database for faster processing
        IF OBJECT_ID('tempdb..#QuoteOptions') IS NOT NULL BEGIN
			DROP TABLE #QuoteOptions
		END

        create table #QuoteOptions
        (
                #Options int,
                [Option No] nvarchar(255),
        [Price] money,
        [Qty] int,
        [Sections] nvarchar(255),
        [Description] nvarchar(max)
        );

        --Grab Quotes with same Model No and Options as @quote parameter
        insert into #QuoteOptions ([Option No], Price, Qty, Sections, Description)
        select [Option No], Price, Qty, Sections, Description
        from [BWSdb].[dbo].[Order Options] with (nolock)
        where Quote# = @quote
		;

        update #QuoteOptions
        set #Options = NoOptions
        from (select count(*) as NoOptions
                  from [BWSdb].[dbo].[Order Options] with (nolock)
                  where Quote# = @quote) as subCountOptions
		;

        --Drop and create temp table in tmpdb SQL database for faster processing
        IF OBJECT_ID('tempdb..#QuoteswithsameOptions') IS NOT NULL BEGIN
			DROP TABLE #QuoteswithsameOptions
		END

        create table #QuoteswithsameOptions
        (
                [Quote#] int,
                [WO#] int,
                [Quote Date] datetime,
                [Prod Date] datetime
        );

        insert into #QuoteswithsameOptions
        select Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
        from [BWSdb].[dbo].[Order Options] as main with (nolock)
        inner join [BWSdb].[dbo].Orders with (nolock) on main.Quote# = Orders.Quote#
        left outer join [BWSdb].[dbo].Production with (nolock) on Orders.Quote# = Production.Quote#
        inner join #QuoteOptions as QuoteOptions on main.[Option No] = QuoteOptions.[Option No]
                                                                                                and (case when main.Sections is null then '' else main.Sections end) = (case when QuoteOptions.Sections is null then '' else QuoteOptions.Sections end)       
                                                                                                and main.Description = QuoteOptions.Description
                                                                                                AND main.[Qty] = [QuoteOptions].[Qty]
        where main.Quote# in (select Quote#
                                                  from [BWSdb].[dbo].[Order Options] with (nolock)
                                                  group by Quote#
                                                  having count(*) in (select #Options from #QuoteOptions))
        and Orders.[Model No] = @modelno
        and [Date Declined] is null
        group by Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
        having count(*) = (select distinct #Options from #QuoteOptions)
		;

        --Drop and create temp table in tmpdb SQL database for faster processing
        IF OBJECT_ID('tempdb..#QuoteNPOs') IS NOT NULL BEGIN
			DROP TABLE #QuoteNPOs
		END

        create table #QuoteNPOs
        (
                #NPOs int,
        [Description] nvarchar(max)
        );

        --Grab Quotes with same NPOs
        insert into #QuoteNPOs (Description)
        select Description
        from [BWSdb].[dbo].[Custom Work] with (nolock)
        where Quote# = @quote
		;

        update #QuoteNPOs
        set #NPOs = NoNPOs
        from (select count(*) as NoNPOs
                  from [BWSdb].[dbo].[Custom Work] with (nolock)
                  where Quote# = @quote) as subCountNPOs
		;

        --Drop and create temp table in tmpdb SQL database for faster processing
        IF OBJECT_ID('tempdb..#QuoteswithsameNPOs') IS NOT NULL BEGIN
			DROP TABLE #QuoteswithsameNPOs
		END

        create table #QuoteswithsameNPOs
        (
                [Quote#] int,
                [WO#] int,
                [Quote Date] datetime,
                [Prod Date] datetime
        );

        insert into #QuoteswithsameNPOs
        select Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
        from [BWSdb].[dbo].[Custom Work] as main with (nolock)
        inner join [BWSdb].[dbo].Orders with (nolock) on main.Quote# = Orders.Quote#
        left outer join [BWSdb].[dbo].Production with (nolock) on Orders.Quote# = Production.Quote#
        inner join #QuoteNPOs as QuoteNPOs on main.Description = QuoteNPOs.Description
        where main.Quote# in (select Quote#
                                                  from [BWSdb].[dbo].[Custom Work] with (nolock)
                                                  group by Quote#
                                                  having count(*) in (select #NPOs from #QuoteNPOs))
        and Orders.[Model No] = @modelno
        and [Date Declined] is null
        group by Orders.Quote#, Orders.WO#, Orders.[Quote Date], [Prod Date]
        having count(*) = (select distinct #NPOs from #QuoteNPOs)
		;

        --Final select statement
        INSERT INTO @r ([Q], [SimQ])
        select @quote, Options.Quote#
        from #QuoteswithsameOptions as Options
        inner join #QuoteswithsameNPOs as NPOs on Options.Quote# = NPOs.Quote#
        LEFT JOIN @t ON [Options].[Quote#] = [@t].[Q]
        where Options.Quote# <> @quote
		;


        SELECT @i = @i + 1;

END
/*
SELECT
        *
FROM
        @t
*/

SELECT
        *
FROM
        @r
;


