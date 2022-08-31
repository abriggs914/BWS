USE [BWSdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_SerialNumberCalc]    Script Date: 2022-08-31 3:14:40 PM ******/
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
	@quote int, @year int
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from
	 --interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @quote int, @year int;
	--SET @quote = 26744;
	--SET @year = 2023

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
	select @maxsn = max(RIGHT([Serial Number], 6))
	from Orders with (nolock)
	cross join [SNC Year] with (nolock)
	where [Year] = @year
	and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A' + '%'
	AND LEFT([Serial Number], 3) IN ('2XB', '2B9')

	--Geneate new number for serial number
	declare @newsn NVARCHAR(6)
	--select @newsn = case when @maxsn is null then 1001 else @maxsn + 1 end
	--select @newsn = case when @maxsn is null then 100001 else @maxsn + 1 end
	select @newsn = RIGHT('000000' + CAST(case when @maxsn is null then 1 else @maxsn + 1 end AS NVARCHAR(6)), 6)
	
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

	--Generate Serial Number
	select '2XB' + Position4 + Position5 + Position6 + Position7 + cast(Position8 as nvarchar)
		   + case when @cn % 11 = 10 then 'X' else cast(@cn % 11 as nvarchar) end + [SN Yr] + 'A' + right('000000' + cast(@newsn as nvarchar), 6)
	from [SN Type] with (nolock)
	inner join Products with (nolock) on [SN Type].[Model No] = Products.[Model No]
	inner join (select distinct [Model No] from Orders with (nolock) where Quote# = @quote) as subA on Products.[Model No] = subA.[Model No]
	cross join [SNC Year] with (nolock)
	where [Year] = @year

END
