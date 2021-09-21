USE BWSdb
GO

DECLARE	@OptID int, @MN nvarchar(255), @compid int, @modelno VARCHAR(50);
SET @OptID = 10;
SET @MN = '20ART';
SET @compid = 0;
SET @modelno = '20ART'


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


select [Model No], [Model No] + '-' + convert(nvarchar, max(right([Option No], len([Option No]) - PATINDEX('%-[0-9]%', [Option No]))) + 1) as NewOptNo
	from OptionsV2
	where CompanyID = @compid
	and [Model No] = @MN
	group by [Model No]

	
select [Model No],
	--PATINDEX('%-[0-9]%', [Option No]) AS [Patindex],
	--len([Option No]) - PATINDEX('%-[0-9]%', [Option No]) AS [B],
	--right([Option No], len([Option No]) - PATINDEX('%-[0-9]%', [Option No])) AS [C],
	max(right([Option No], len([Option No]) - PATINDEX('%-[0-9]%', [Option No]))) AS [D],
	convert(nvarchar, max(right([Option No], len([Option No]) - PATINDEX('%-[0-9]%', [Option No]))) + 1) AS [E],
	RIGHT(('00000' + convert(nvarchar, max(right([Option No], len([Option No]) - PATINDEX('%-[0-9]%', [Option No]))) + 1)), 5) AS [F]
	from OptionsV2
	where CompanyID = @compid
	and [Model No] = @MN
	group by [Model No]


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


select [Model No], [Model No] + '-' + convert(nvarchar, right('00000' + cast(No + 1 as varchar(2)), 5)) as [Option No] 
	from (select CompanyID, [Model No], max(right([Option No], 2)) as [No]
	from (select CompanyID, [Model No], [Option No] from OptionsV2
		  where right([Option No], 2) not like '%[A-Z]%') as subA
	group by CompanyID, [Model No]) as mainsub
	where right(No, 1) not like '[A-Z]'
	and [Model No] = @modelno
	and CompanyID = @compid


SELECT
SUBSTRING(
		[Order OptionsV2].[Option No],
		0,
		LEN([Order OptionsV2].[Option No]) - CHARINDEX(REVERSE([Order OptionsV2].[Option No]), REVERSE([Order OptionsV2].[Option No])) - 1
		) AS [Model No],
	*
FROM
	[Order OptionsV2]
--BEGIN TRAN
	
--ROLLBACK;
--COMMIT;
