USE [BWSdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_SerialNumberCalc]    Script Date: 2024-03-20 6:48:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_SerialNumberCalc] 
	-- Add the parameters for the stored procedure here
	@quote int, @year int, @mode INT = NULL, @startSeq INT=NULL
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from
	 --interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @quote int, @year int;
	--SET @quote = 27616;
	--SET @year = 2024
	
	DECLARE @calc_pos_7 AS NVARCHAR(1);
	DECLARE @prefix AS NVARCHAR(3) = '2XB';
	DECLARE @plant AS NVARCHAR(1) = 'A';

    -- Insert statements for procedure here
	--Create table variable to store character-to-number comparison for future reference
	declare @chartonum table
	(
		[Character] char(1),
		[Number] int
	)

	insert into @chartonum
	values ('A', 1),
			('B', 2),
			('C', 3),
			('D', 4),
			('E', 5),
			('F', 6),
			('G', 7),
			('H', 8),
			('J', 1),
			('K', 2),
			('L', 3),
			('M', 4),
			('N', 5),
			('P', 7),
			('R', 9),
			('S', 2),
			('T', 3),
			('U', 4),
			('V', 5),
			('W', 6),
			('X', 7),
			('Y', 8),
			('Z', 9)

	--Grab last used serial number for selected model year
	declare @maxsn int
	select @maxsn = MAX(CAST(RIGHT([Serial Number], 6) AS INT)) + 1
	--select @maxsn2 = COUNT(*) + 2
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')
	AND [Date Declined] IS NULL

	--Geneate new number for serial number
	declare @newsn NVARCHAR(6)
	--select @newsn = case when @maxsn is null then 1001 else @maxsn + 1 end
	--select @newsn = case when @maxsn is null then 100001 else @maxsn + 1 end
	select @newsn = RIGHT('000000' + CAST(case when @maxsn is null then 1 else @maxsn end AS NVARCHAR(6)), 6)
	
	-- apply startseq if not null
	IF @startSeq IS NOT NULL BEGIN
		SELECT @newsn = RIGHT('000000' + CAST(@startSeq + 1 AS NVARCHAR(6)), 6)
	END
	
	--SET @newsn = '098765';
	--SET @newsn = '100000';

	--Generate Check Number calc for Serial Number
	declare @cn int
	--select @cn = 16 + 14 + 54 + (subCTN.Number * 5) + (Position5 * 4)
	-- 2XB => Values=(2, 7, 2) Weights=(8, 7, 6)
	select @cn = (2 * 8) + (7 * 7) + (2 * 6) + (subCTN.Number * 5) + (Position5 * 4)
	from [SN Type] with (nolock)
	inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
	inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
	inner join @chartonum as subCTN on [SN Type].Position4 = subCTN.Character
	cross join [SNC Year] with (nolock)
	where [Year] = @year

	select @cn = @cn + ((case when subCTN.Number is null then Position6 else subCTN.Number end) * 3)
	from [SN Type] with (nolock)
	inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
	inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
	left outer join @chartonum as subCTN on [SN Type].Position6 = subCTN.Character
	cross join [SNC Year] with (nolock)
	where [Year] = @year

	select @cn = @cn + (case when ISNUMERIC(Position7) = 1 then Position7 else subCTN.Number end * 2) + (Position8 * 10)
	from [SN Type] with (nolock)
	inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
	inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
	left outer join @chartonum as subCTN on [SN Type].Position7 = subCTN.Character
	cross join [SNC Year] with (nolock)
	where [Year] = @year

	select @cn = @cn + (subCTN.Number * 9) + (1 * 8) + ((left(right(@newsn, 6), 1)) * 7) + ((left(right(@newsn, 5), 1)) * 6) + ((left(right(@newsn, 4), 1)) * 5)
				 + ((left(right(@newsn, 3), 1)) * 4) + ((left(right(@newsn, 2), 1)) * 3)
				 + ((right(@newsn, 1)) * 2)
	from [SN Type] with (nolock)
	inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
	inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
	cross join [SNC Year] with (nolock)
	inner join @chartonum as subCTN on [SNC Year].[SN Yr] = subCTN.Character
	where [Year] = @year

	/*
	--Generate Serial Number
	select '2XB' + Position4 + Position5 + Position6 + Position7 + cast(Position8 as nvarchar)
		   + case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end + [SN Yr] + 'A' + right('000000' + cast(@newsn as nvarchar), 6)
	from [SN Type] with (nolock)
	inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
	inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	*/

	

	SELECT
		@calc_pos_7 = [SN].[Position7]
	FROM
		[SN Type] [SN]
	INNER JOIN
		[Orders] [O]
	ON
		[O].[Quote#] = @quote
	WHERE
		[SN].[Model No] = [O].[Model No]


	IF @mode = 3 BEGIN
		select @prefix + Position4 + Position5 + Position6 + @calc_pos_7 + cast(Position8 as nvarchar)
				+ case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end + [SN Yr] + @plant + right('000000' + cast(@newsn as nvarchar), 6)
		from [SN Type] with (nolock)
		inner join [Products] with (nolock) on [SN Type].[Model No] = [Products].[Model No]
		inner join (select distinct [Model No] from [Orders] with (nolock) where [Quote#] = @quote) as subA on [Products].[Model No] = subA.[Model No]
		cross join [SNC Year] with (nolock)
		where [Year] = @year AND [Products].[CompanyID] = 0 AND [SN Type].[CompanyID] = 0
	END
	ELSE IF @mode IS NULL BEGIN
		--Generate Serial Number
		select @prefix + Position4 + Position5 + Position6 + @calc_pos_7 + cast(Position8 as nvarchar)
				+ case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end + [SN Yr] + @plant + right('000000' + cast(@newsn as nvarchar), 6)
		from [SN Type] with (nolock)
		inner join [Products] with (nolock) on [SN Type].[Model No] = [Products].[Model No]
		inner join (select distinct [Model No] from [Orders] with (nolock) where [Quote#] = @quote) as subA on [Products].[Model No] = subA.[Model No]
		cross join [SNC Year] with (nolock)
		where [Year] = @year AND [Products].[CompanyID] = 0 AND [SN Type].[CompanyID] = 0
	END
	--ELSE IF @mode = 2 BEGIN
	--	SELECT * FROM @resultT
	--END
	ELSE BEGIN
		select @prefix AS [Prefix]
			, Position4 AS [4]
			, Position5 AS [5]
			, Position6 AS [6]
			, @calc_pos_7 AS [7]
			, cast(Position8 as nvarchar) AS [8]
			, case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end AS [CD]
			, [SN Yr] AS [10]
			, @plant AS [11]
			, right('000000' + cast(@newsn as nvarchar), 6) AS [#]
		from [SN Type] with (nolock)
		inner join [Products] with (nolock) on [SN Type].[Model No] = [Products].[Model No]
		inner join (select distinct [Model No] from [Orders] with (nolock) where [Quote#] = @quote) as subA on [Products].[Model No] = subA.[Model No]
		cross join [SNC Year] with (nolock)
		where [Year] = @year AND [Products].[CompanyID] = 0 AND [SN Type].[CompanyID] = 0
	END
END
