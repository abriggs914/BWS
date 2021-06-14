/*
USE SysproCompanyS
GO

ALTER PROCEDURE [dbo].[sp_APTrialBalance] 
	-- Add the parameters for the stored procedure here
	@d datetime, @reporttype int, @excludezeroinvs int, @localcur int

	--with recompile

	AS
	BEGIN

	declare @mth int = 6, @year int = 2021
	declare @loopid int = 1
	declare @loopsupplier varchar(15),
				@loopinvoice varchar(20)

	IF OBJECT_ID('tempdb..#tblGrabPaymentRef') IS NOT NULL
		DROP TABLE #tblGrabPaymentRef

	create table #tblGrabPaymentRef
	(
		RecordID int identity(1, 1),
		Supplier varchar(15),
		Invoice varchar(20),
		PaymentReference varchar(50)
	)

	insert into #tblGrabPaymentRef (Supplier, Invoice)
	select distinct Supplier, Invoice 
	from ApInvoicePay with (nolock)
	where right('0000' + cast(TrnYear as varchar(4)), 4) + right('00' + cast(TrnMonth as varchar(2)), 2) <= right('0000' + cast(@year as varchar(4)), 4) + right('00' + cast(@mth as varchar(2)), 2)
	and PaymentReference <> ''

	while @loopid <= (select max(RecordID) from #tblGrabPaymentRef)
		begin
			select @loopsupplier = Supplier,
				   @loopinvoice = Invoice
			from #tblGrabPaymentRef
			where RecordID = @loopid

			update #tblGrabPaymentRef
			set PaymentReference = subPR.PaymentReference
			from #tblGrabPaymentRef
			cross join (select top (1) Supplier, Invoice, PaymentReference
						from ApInvoicePay with (nolock)
						where right('0000' + cast(TrnYear as varchar(4)), 4) + right('00' + cast(TrnMonth as varchar(2)), 2) <= right('0000' + cast(@year as varchar(4)), 4) + right('00' + cast(@mth as varchar(2)), 2)
						and PaymentReference <> ''
						and Supplier = @loopsupplier
						and Invoice = @loopinvoice
						order by Supplier, Invoice, PaymentReference desc) as subPR
			where RecordID = @loopid

			select @loopid = @loopid + 1
		end
	end
GO

DECLARE @date date = '2021-06-14';  
DECLARE @datetime datetime = @date;

EXEC dbo.sp_APTrialBalance @d=@datetime, @reporttype=0, @excludezeroinvs=1, @localcur=4


--SELECT * FROM [ApInvoicePay]
*/

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------


USE SysproCompanyS
GO

ALTER PROCEDURE [dbo].[sp_APTrialBalance] 
	-- Add the parameters for the stored procedure here
	@d datetime, @reporttype int, @excludezeroinvs int, @localcur int

	--with recompile

	AS
	BEGIN

	declare @mth int = 6, @year int = 2021
	declare @loopid int = 1
	declare @loopsupplier varchar(15),
				@loopinvoice varchar(20)

	IF OBJECT_ID('tempdb..#tblGrabPaymentRef') IS NOT NULL
		DROP TABLE #tblGrabPaymentRef

	create table #tblGrabPaymentRef
	(
		RecordID int identity(1, 1),
		Supplier varchar(15),
		Invoice varchar(20),
		PaymentReference varchar(50)
	)

	insert into #tblGrabPaymentRef (Supplier, Invoice)
	select distinct Supplier, Invoice 
	from ApInvoicePay with (nolock)
	where right('0000' + cast(TrnYear as varchar(4)), 4) + right('00' + cast(TrnMonth as varchar(2)), 2) <= right('0000' + cast(@year as varchar(4)), 4) + right('00' + cast(@mth as varchar(2)), 2)
	and PaymentReference <> ''

	--while @loopid <= (select max(RecordID) from #tblGrabPaymentRef)
	--	begin
	--		select @loopsupplier = Supplier,
	--			   @loopinvoice = Invoice
	--		from #tblGrabPaymentRef
	--		where RecordID = @loopid

	--		update #tblGrabPaymentRef
	--		set PaymentReference = subPR.PaymentReference
	--		from #tblGrabPaymentRef
	--		cross join (select top (1) Supplier, Invoice, PaymentReference
	--					from ApInvoicePay with (nolock)
	--					where right('0000' + cast(TrnYear as varchar(4)), 4) + right('00' + cast(TrnMonth as varchar(2)), 2) <= right('0000' + cast(@year as varchar(4)), 4) + right('00' + cast(@mth as varchar(2)), 2)
	--					and PaymentReference <> ''
	--					and Supplier = @loopsupplier
	--					and Invoice = @loopinvoice
	--					order by Supplier, Invoice, PaymentReference desc) as subPR
	--		where RecordID = @loopid

	--		select @loopid = @loopid + 1
	--	end
	end
GO

DECLARE @date date = '2021-06-14';  
DECLARE @datetime datetime = @date;

EXEC dbo.sp_APTrialBalance @d=@datetime, @reporttype=0, @excludezeroinvs=1, @localcur=4

-----------------------------------------------------------------------------------------------------------------------

SELECT * FROM [ApInvoicePay]


SELECT
	ROW_NUMBER() OVER (
		PARTITION BY [Supplier]
		ORDER BY [Supplier]
	) row_num, *
FROM 
	[ApInvoicePay]
ORDER BY [JournalDate]


SELECT
	ApInvoicePay.[Supplier]
FROM
	ApInvoicePay
INNER JOIN
	(SELECT
		ROW_NUMBER() OVER (
			PARTITION BY [Supplier]
			ORDER BY [Supplier]
		) row_num, *
	FROM 
		[ApInvoicePay]
	ORDER BY [JournalDate]
	) AS A
ON 
	ApInvoicePay.[Supplier] = A.[Supplier];