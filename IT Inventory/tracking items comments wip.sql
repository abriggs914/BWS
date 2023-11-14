USE BWSdb
GO

-- IT Inventory items history
-- Item being tracked

-- changes in assigned, retire, retrieve statuses


-- What is overdue
-- When Assigned
-- When Due
-- Who has
-- Where is
-- How long overdue

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DECLARE @TESTING AS BIT = 0;

DECLARE @serial NVARCHAR(MAX) = '0000000059';
DECLARE @defaultComment NVARCHAR(MAX) = 'N/A';
DECLARE @defaultInitComment NVARCHAR(MAX) = 'Initialization';
DECLARE @defaultDate DATETIME = DATEADD(YEAR, -100, GETDATE());
DECLARE @delimiter NVARCHAR(MAX) = ';;';
DECLARE @comment NVARCHAR(MAX);
DECLARE @lendStatus NVARCHAR(MAX) = '';
DECLARE @i INTEGER = 0;
DECLARE @j INTEGER = 0;
DECLARE @c INTEGER = 0;

DECLARE
	@Item_CURR NVARCHAR(MAX)
	,@DateLend_CURR DATETIME
	,@DueDate_CURR DATETIME
	,@DaysOverdue_CURR INT
	,@Employee_CURR NVARCHAR(MAX)
	,@Description_CURR NVARCHAR(MAX)
	,@DateActive_CURR DATETIME
	,@DamageLevel_CURR INT
	,@DirtLevel_CURR INT
	,@DateTested_CURR DATETIME
	,@DatePurchaseCost_CURR DATETIME
	,@DateAssigned_CURR DATETIME
	,@DateAssignedExpectedReturn_CURR DATETIME
	,@DateRetire_CURR DATETIME
	,@DateRetrieve_CURR DATETIME

	,@Item_NEXT NVARCHAR(MAX)
	,@DateLend_NEXT DATETIME
	,@DueDate_NEXT DATETIME
	,@DaysOverdue_NEXT INT
	,@Employee_NEXT NVARCHAR(MAX)
	,@Description_NEXT NVARCHAR(MAX)
	,@DateActive_NEXT DATETIME
	,@DamageLevel_NEXT INT
	,@DirtLevel_NEXT INT
	,@DateTested_NEXT DATETIME
	,@DatePurchaseCost_NEXT DATETIME
	,@DateAssigned_NEXT DATETIME
	,@DateAssignedExpectedReturn_NEXT DATETIME
	,@DateRetire_NEXT DATETIME
	,@DateRetrieve_NEXT DATETIME

	,
	@Item_CURR_s NVARCHAR(MAX)
	,@DateLend_CURR_s NVARCHAR(MAX)
	,@DueDate_CURR_s NVARCHAR(MAX)
	,@DaysOverdue_CURR_s NVARCHAR(MAX)
	,@Employee_CURR_s NVARCHAR(MAX)
	,@Description_CURR_s NVARCHAR(MAX)
	,@DateActive_CURR_s NVARCHAR(MAX)
	,@DamageLevel_CURR_s NVARCHAR(MAX)
	,@DirtLevel_CURR_s NVARCHAR(MAX)
	,@DateTested_CURR_s NVARCHAR(MAX)
	,@DatePurchaseCost_CURR_s NVARCHAR(MAX)
	,@DateAssigned_CURR_s NVARCHAR(MAX)
	,@DateAssignedExpectedReturn_CURR_s NVARCHAR(MAX)
	,@DateRetire_CURR_s NVARCHAR(MAX)
	,@DateRetrieve_CURR_s NVARCHAR(MAX)

	,@Item_NEXT_s NVARCHAR(MAX)
	,@DateLend_NEXT_s NVARCHAR(MAX)
	,@DueDate_NEXT_s NVARCHAR(MAX)
	,@DaysOverdue_NEXT_s NVARCHAR(MAX)
	,@Employee_NEXT_s NVARCHAR(MAX)
	,@Description_NEXT_s NVARCHAR(MAX)
	,@DateActive_NEXT_s NVARCHAR(MAX)
	,@DamageLevel_NEXT_s NVARCHAR(MAX)
	,@DirtLevel_NEXT_s NVARCHAR(MAX)
	,@DateTested_NEXT_s NVARCHAR(MAX)
	,@DatePurchaseCost_NEXT_s NVARCHAR(MAX)
	,@DateAssigned_NEXT_s NVARCHAR(MAX)
	,@DateAssignedExpectedReturn_NEXT_s NVARCHAR(MAX)
	,@DateRetire_NEXT_s NVARCHAR(MAX)
	,@DateRetrieve_NEXT_s NVARCHAR(MAX)
;

DECLARE @src AS TABLE (
	[ID] INT IDENTITY(0, 1)
	,[Item] NVARCHAR(MAX)
	,[DateLend] DATETIME
	,[DateDue] DATETIME
	,[DaysOverdue] INT
	,[Employee] NVARCHAR(MAX)
	,[Description] NVARCHAR(MAX)
	,[DateActive] DATETIME
	,[DamageLevel] INT
	,[DirtLevel] INT
	,[DateTested] DATETIME
	,[DatePurchaseCost] DATETIME
	,[DateAssigned] DATETIME
	,[DateAssignedExpectedReturn] DATETIME
	,[DateRetire] DATETIME
	,[DateRetrieve] DATETIME
	,[Comment] NVARCHAR(MAX)
);

INSERT INTO @src ([Item]
	,[DateLend]
	,[DateDue]
	,[DaysOverdue]
	,[Employee]
	,[Description]
	,[DateActive]
	,[DamageLevel]
	,[DirtLevel]
	,[DateTested]
	,[DatePurchaseCost]
	,[DateAssigned]
	,[DateAssignedExpectedReturn]
	,[DateRetire]
	,[DateRetrieve])
SELECT 
	*
	--,
	--(CASE 
	--	WHEN  THEN
	--	ELSE
	--END) AS [Comment]
FROM (
	SELECT

		[ColourList] + ' ' + [BrandName] + ' ' + [HardwareType] AS [Item]
		,[AssignedDate] AS [LendDate]
		,[AssignedExpectedReturn] AS [DueDate]
		,DATEDIFF(DAY, [AssignedDate], [AssignedExpectedReturn]) AS [DaysOverdue]
		,[C].[Name] AS [Employee]
		,[L].[Description]

		,[I].[DateActive]
		,[DamageLevel]
		,[DirtLevel]
		,[TestedDate]
		,[PurchaseCostDate]
		,[AssignedDate]
		,[AssignedExpectedReturn]
		,[RetireDate]
		,[RetrievedDate]
	
		--,[I].[ID] AS [InventoryID]
		--,[I].[DateCreated] AS [InventoryDateCreated]
		--,[I].[Active] AS [InventoryActive]
		--,[I].[DateActive] AS [InventoryDateActive]
		--,[I].[DateInactive] AS [InventoryDateInactive]
		--,[I].[HardwareType] AS [InventoryHardwareType]
		--,[I].[BrandName] AS [InventoryBrandName]
		--,[I].[ModelName] AS [InventoryModelName]
		--,[I].[ColourList] AS [InventoryColourList]
		--,[I].[Dimension_L_INCH] AS [InventoryDimension_L_INCH]
		--,[I].[Dimension_W_INCH] AS [InventoryDimension_W_INCH]
		--,[I].[Dimension_H_INCH] AS [InventoryDimension_H_INCH]
		--,[I].[Weight_LBS] AS [InventoryWeight_LBS]
		--,[I].[ITSerial] AS [InventoryITSerial]
		--,[I].[HardwareNotes] AS [InventoryHardwareNotes]
		--,[I].[IsNew] AS [InventoryIsNew]
		--,[I].[Supplier] AS [InventorySupplier]
		--,[I].[PurchaseCost] AS [InventoryPurchaseCost]
		--,[I].[AcquisitionDate] AS [InventoryAcquisitionDate]
		--,[I].[DamageLevel] AS [InventoryDamageLevel]
		--,[I].[DirtLevel] AS [InventoryDirtLevel]
		--,[I].[ConditionNotes] AS [InventoryConditionNotes]
		--,[I].[TestedDate] AS [InventoryTestedDate]
		--,[I].[ITLocation] AS [InventoryITLocation]
		--,[I].[IsAssigned] AS [InventoryIsAssigned]
		--,[I].[AssignedDate] AS [InventoryAssignedDate]
		--,[I].[AssignedNotes] AS [InventoryAssignedNotes]
		--,[I].[AssignedExpectedReturn] AS [InventoryAssignedExpectedReturn]
		--,[I].[RetrievedDate] AS [InventoryRetrievedDate]
		--,[I].[RetireDate] AS [InventoryRetireDate]
		--,[I].[RetireReason] AS [InventoryRetireReason]
		--,[I].[ResourcePath] AS [InventoryResourcePath]
		--,[I].[CableLength] AS [InventoryCableLenght]
		--,[I].[PurchaseCostDate] AS [InventoryPurchaseCostDate]

		--,[L].[ID] AS [LocationID]
		--,[L].[DateCreated] AS [LocationDateCreated]
		--,[L].[Active] AS [LocationActive]
		--,[L].[DateActive] AS [LocationDateActive]
		--,[L].[DateInactive] AS [LocationDateInactive]
		--,[L].[Name] AS [LocationName]
		--,[L].[BuildingID] AS [LocationBuildingID]
		--,[L].[FloorNumber] AS [LocationFloorNumber]
		--,[L].[GridRow] AS [LocationGridRow]
		--,[L].[GridCol] AS [LocationGridCol]
		--,[L].[Description] AS [LocationDescription]
		--,[L].[EmployeeAssigned] AS [LocationEmployeeAssigned]

		--,[C].[CustomerID] AS [ITRCustomersCustomerID]
		--,[C].[Name] AS [ITRCustomersName]
		--,[C].[Department] AS [ITRCustomersDepartment]
		--,[C].[Company] AS [ITRCustomersCompany]
		--,[C].[Email] AS [ITRCustomersEmail]
		--,[C].[WorkPhone] AS [ITRCustomersWorkPhone]
		--,[C].[WorkExtension] AS [ITRCustomersWorkExtension]
		--,[C].[CellPhone] AS [ITRCustomersCellPhone]
		--,[C].[HomePhone] AS [ITRCustomersHomePhone]
		--,[C].[Active] AS [ITRCustomersActive]
		--,[C].[DateAdded] AS [ITRCustomersDateAdded]
		--,[C].[LastActive] AS [ITRCustomersLastActive]
		--,[C].[WorkPhoneLastActive] AS [ITRCustomersWorkPhoneLastActive]
		--,[C].[WorkExtensionLastActive] AS [ITRCustomersWorkExtensionLastActive]
		--,[C].[CellPhoneLastActive] AS [ITRCustomersCellPhoneLastActive]
		--,[C].[HomePhoneLastActive] AS [ITRCustomersHomePhoneLastActive]
		--,[C].[WindowsUser] AS [ITRCustomersWindowsUser]
		--,[C].[BirthYear] AS [ITRCustomersBirthYear]
		--,[C].[BirthMonth] AS [ITRCustomersBirthMonth]
		--,[C].[BirthDay] AS [ITRCustomersBirthDay]
		--,*
	FROM
		[ITI Inventory History] AS [I]
	LEFT JOIN
		[ITI Locations]  AS [L]
	ON
		[I].[ITLocation] = [L].[ID]
	LEFT JOIN
		[ITR Customers] AS [C]
	ON
		[L].[EmployeeAssigned] = [C].[CustomerID]
	WHERE
		[ITSerial] = @serial
	GROUP BY
		[ColourList]
		,[BrandName]
		,[HardwareType]
		,[C].[Name]
		,[L].[Description]
		,[I].[DateActive]
		,[DamageLevel]
		,[DirtLevel]
		,[TestedDate]
		,[PurchaseCostDate]
		,[AssignedDate]
		,[AssignedExpectedReturn]
		,[RetireDate]
		,[RetrievedDate]
	--	[I].[AssignedExpectedReturn] IS NOT NULL
	--	AND [RetrievedDate] IS NULL
) AS [Src]
;

SELECT @c = COUNT(*) FROM @src;

IF @c > 0 BEGIN
	-- Set first comment as init
	UPDATE
		@src
	SET
		[Comment] = @defaultInitComment
	WHERE
		[ID] = 0
	;
END

WHILE @i < (@c - 1) BEGIN

	SELECT @comment = '';

	SELECT
		@Item_CURR = [S].[Item]
		,@DateLend_CURR = ISNULL([S].[DateLend], @defaultDate)
		,@DueDate_CURR = ISNULL([S].[DateDue], @defaultDate)
		,@DaysOverdue_CURR = [S].[DaysOverdue]
		,@Employee_CURR = [S].[Employee]
		,@Description_CURR = [S].[Description]
		,@DateActive_CURR = ISNULL([S].[DateActive], @defaultDate)
		,@DamageLevel_CURR = [S].[DamageLevel]
		,@DirtLevel_CURR = [S].[DirtLevel]
		,@DateTested_CURR = ISNULL([S].[DateTested], @defaultDate)
		,@DatePurchaseCost_CURR = ISNULL([S].[DatePurchaseCost], @defaultDate)
		,@DateAssigned_CURR = ISNULL([S].[DateAssigned], @defaultDate)
		,@DateAssignedExpectedReturn_CURR = ISNULL([S].[DateAssignedExpectedReturn], @defaultDate)
		,@DateRetire_CURR = ISNULL([S].[DateRetire], @defaultDate)
		,@DateRetrieve_CURR = ISNULL([S].[DateRetrieve], @defaultDate)
	FROM
		@src AS [S]
	WHERE
		[ID] = @i
	;

	SELECT
		@Item_NEXT = [S].[Item]
		,@DateLend_NEXT = ISNULL([S].[DateLend], @defaultDate)
		,@DueDate_NEXT = ISNULL([S].[DateDue], @defaultDate)
		,@DaysOverdue_NEXT = [S].[DaysOverdue]
		,@Employee_NEXT = [S].[Employee]
		,@Description_NEXT = [S].[Description]
		,@DateActive_NEXT = ISNULL([S].[DateActive], @defaultDate)
		,@DamageLevel_NEXT = [S].[DamageLevel]
		,@DirtLevel_NEXT = [S].[DirtLevel]
		,@DateTested_NEXT = ISNULL([S].[DateTested], @defaultDate)
		,@DatePurchaseCost_NEXT = ISNULL([S].[DatePurchaseCost], @defaultDate)
		,@DateAssigned_NEXT = ISNULL([S].[DateAssigned], @defaultDate)
		,@DateAssignedExpectedReturn_NEXT = ISNULL([S].[DateAssignedExpectedReturn], @defaultDate)
		,@DateRetire_NEXT = ISNULL([S].[DateRetire], @defaultDate)
		,@DateRetrieve_NEXT = ISNULL([S].[DateRetrieve], @defaultDate)
	FROM
		@src AS [S]
	WHERE
		[ID] = @i + 1
	;

	SELECT
		@Item_CURR_s = CAST(@Item_CURR AS NVARCHAR(MAX))
		,@DateLend_CURR_s = CAST(@DateLend_CURR AS NVARCHAR(MAX))
		,@DueDate_CURR_s = CAST(@DueDate_CURR AS NVARCHAR(MAX))
		,@DaysOverdue_CURR_s = CAST(@DaysOverdue_CURR AS NVARCHAR(MAX))
		,@Employee_CURR_s = CAST(@Employee_CURR AS NVARCHAR(MAX))
		,@Description_CURR_s = CAST(@Description_CURR AS NVARCHAR(MAX))
		,@DateActive_CURR_s = CAST(@DateActive_CURR AS NVARCHAR(MAX))
		,@DamageLevel_CURR_s = CAST(@DamageLevel_CURR AS NVARCHAR(MAX))
		,@DirtLevel_CURR_s = CAST(@DirtLevel_CURR AS NVARCHAR(MAX))
		,@DateTested_CURR_s = CAST(@DateTested_CURR AS NVARCHAR(MAX))
		,@DatePurchaseCost_CURR_s = CAST(@DatePurchaseCost_CURR AS NVARCHAR(MAX))
		,@DateAssigned_CURR_s = CAST(@DateAssigned_CURR AS NVARCHAR(MAX))
		,@DateAssignedExpectedReturn_CURR_s = CAST(@DateAssignedExpectedReturn_CURR AS NVARCHAR(MAX))
		,@DateRetire_CURR_s = CAST(@DateRetire_CURR AS NVARCHAR(MAX))
		,@DateRetrieve_CURR_s = CAST(@DateRetrieve_CURR AS NVARCHAR(MAX))

		,
		@Item_NEXT_s = CAST(@Item_NEXT AS NVARCHAR(MAX))
		,@DateLend_NEXT_s = CAST(@DateLend_NEXT AS NVARCHAR(MAX))
		,@DueDate_NEXT_s = CAST(@DueDate_NEXT AS NVARCHAR(MAX))
		,@DaysOverdue_NEXT_s = CAST(@DaysOverdue_NEXT AS NVARCHAR(MAX))
		,@Employee_NEXT_s = CAST(@Employee_NEXT AS NVARCHAR(MAX))
		,@Description_NEXT_s = CAST(@Description_NEXT AS NVARCHAR(MAX))
		,@DateActive_NEXT_s = CAST(@DateActive_NEXT AS NVARCHAR(MAX))
		,@DamageLevel_NEXT_s = CAST(@DamageLevel_NEXT AS NVARCHAR(MAX))
		,@DirtLevel_NEXT_s = CAST(@DirtLevel_NEXT AS NVARCHAR(MAX))
		,@DateTested_NEXT_s = CAST(@DateTested_NEXT AS NVARCHAR(MAX))
		,@DatePurchaseCost_NEXT_s = CAST(@DatePurchaseCost_NEXT AS NVARCHAR(MAX))
		,@DateAssigned_NEXT_s = CAST(@DateAssigned_NEXT AS NVARCHAR(MAX))
		,@DateAssignedExpectedReturn_NEXT_s = CAST(@DateAssignedExpectedReturn_NEXT AS NVARCHAR(MAX))
		,@DateRetire_NEXT_s = CAST(@DateRetire_NEXT AS NVARCHAR(MAX))
		,@DateRetrieve_NEXT_s = CAST(@DateRetrieve_NEXT AS NVARCHAR(MAX))

	IF @TESTING = 1 BEGIN
		SELECT
			@DateAssigned_CURR AS [DAC]
			,@DateAssigned_NEXT AS [DAN]
			,@DateAssignedExpectedReturn_CURR AS [DAERC]
			,@DateAssignedExpectedReturn_NEXT AS [DAERN]
			,@comment AS [COM]
	END

	-- Primary changes

	-- Assignments
	SELECT @comment = @comment + (CASE
		WHEN (@DateAssignedExpectedReturn_CURR != @DateAssignedExpectedReturn_NEXT) AND (@DateAssignedExpectedReturn_NEXT IS NOT NULL) THEN
			-- New lend
			'New lend to ' + @Employee_NEXT + ' expected return ' + CAST(@DateAssignedExpectedReturn_NEXT AS NVARCHAR(MAX))
		WHEN @DateAssigned_CURR != @DateAssigned_NEXT THEN
			-- New Assignment 
			'New Assignment to ' + @Employee_NEXT
		ELSE 
			(CASE WHEN @TESTING = 1 THEN '-A' ELSE '' END)
	END)

	-- Add delimiter if data
	IF LEN(@comment) > 0 AND RIGHT(@comment, LEN(@delimiter)) <> @delimiter BEGIN
		SELECT @comment = @comment + @delimiter;
	END

	SELECT 
		@DateAssignedExpectedReturn_CURR AS [DAERC]
		,@DateAssignedExpectedReturn_NEXT AS [DAERN]
		,@DateRetrieve_CURR AS [DRC]
		,@DateRetrieve_NEXT AS [DRN]
		,@lendStatus AS [LS]

	-- Assignment Retrievals
	SELECT @comment = @comment + (CASE
		WHEN @DateRetrieve_CURR <> @DateRetrieve_NEXT THEN
			-- New retrieval from lend
			(CASE WHEN @DateRetrieve_CURR <= @DateAssignedExpectedReturn_NEXT THEN
				-- On time retrieval
				'New lend return from ' + @Employee_CURR + '. Expected return ' + CAST(@DateAssignedExpectedReturn_NEXT AS NVARCHAR(MAX)) + '. On-Time!'
			ELSE 
				-- Late
				'New lend return from ' + @Employee_CURR + '. Expected return ' + CAST(@DateAssignedExpectedReturn_NEXT AS NVARCHAR(MAX)) + '. Late!'
			END)
		--WHEN @DateAssigned_CURR != @DateAssigned_NEXT THEN
		--	-- New Assignment 
		--	'New Assignment to ' + @Employee_NEXT
		ELSE 
			(CASE WHEN @TESTING = 1 THEN '-A' ELSE '' END)
	END)

	-- Secondary comments / changes

	-- Add delimiter if data
	IF LEN(@comment) > 0 AND RIGHT(@comment, LEN(@delimiter)) <> @delimiter BEGIN
		SELECT @comment = @comment + @delimiter;
	END

	-- Damage
	SELECT @comment = @comment + (CASE
		WHEN @DamageLevel_CURR <> @DamageLevel_NEXT THEN
			-- Change in damage level
			(CASE 
				WHEN @DamageLevel_CURR < @DamageLevel_NEXT THEN
					'Damage level increase ' + CAST(@DamageLevel_CURR AS NVARCHAR(MAX)) + ' to ' + CAST(@DamageLevel_NEXT AS NVARCHAR(MAX))
				ELSE 
					'Damage level decrease ' + CAST(@DamageLevel_CURR AS NVARCHAR(MAX)) + ' to ' + CAST(@DamageLevel_NEXT AS NVARCHAR(MAX))
			END)
		ELSE 
			(CASE WHEN @TESTING = 1 THEN '-B' ELSE '' END)
	END)

	-- Add delimiter if data
	IF LEN(@comment) > 0 AND RIGHT(@comment, LEN(@delimiter)) <> @delimiter BEGIN
		SELECT @comment = @comment + @delimiter;
	END

	-- Cleanliness
	SELECT @comment = @comment + (CASE
		WHEN @DirtLevel_CURR <> @DirtLevel_NEXT THEN
			-- Change in cleanliness
			(CASE 
				WHEN @DirtLevel_CURR < @DirtLevel_NEXT THEN
					'Damage level increase ' + CAST(@DirtLevel_CURR AS NVARCHAR(MAX)) + ' to ' + CAST(@DirtLevel_NEXT AS NVARCHAR(MAX))
				ELSE 
					'Damage level decrease ' + CAST(@DirtLevel_CURR AS NVARCHAR(MAX)) + ' to ' + CAST(@DirtLevel_NEXT AS NVARCHAR(MAX))
			END)
		ELSE 
			(CASE WHEN @TESTING = 1 THEN '-B' ELSE '' END)
	END)

	---- Check New Assigment
	--IF @DateAssigned_CURR <> @DateAssigned_NEXT BEGIN
	--	-- Check if assignment is a lend
	--	IF @DateAssignedExpectedReturn_CURR <> @DateAssignedExpectedReturn_NEXT BEGIN
	--	SELECT @comment = 'New Assignment to ' + @Employee_NEXT
	--END

	IF LEN(@comment) = 0 BEGIN
		SELECT @comment = @defaultComment;
	END
	
	UPDATE
		@src
	SET
		[Comment] = @comment
	WHERE 
		[ID] = @i + 1
	;

	SELECT @i = @i + 1;

END

SELECT * FROM @src