USE BWSdb
GO

-- IT Inventory items lended out that havent been returned yet
-- What is overdue
-- When Assigned
-- When Due
-- Who has
-- Where is
-- How long overdue

ALTER VIEW [v_ITI_ItemsOnLend] AS
	SELECT
		[ColourList] + ' ' + [BrandName] + ' ' + [HardwareType] AS [Item]
		,[AssignedDate] AS [LendDate]
		,[AssignedExpectedReturn] AS [DueDate]
		,DATEDIFF(DAY, [AssignedDate], [AssignedExpectedReturn]) AS [DaysOverdue]
		,[C].[Name] AS [Employee]
		,[L].[Description]
	
		,[I].[ID] AS [InventoryID]
		,[I].[DateCreated] AS [InventoryDateCreated]
		,[I].[Active] AS [InventoryActive]
		,[I].[DateActive] AS [InventoryDateActive]
		,[I].[DateInactive] AS [InventoryDateInactive]
		,[I].[HardwareType] AS [InventoryHardwareType]
		,[I].[BrandName] AS [InventoryBrandName]
		,[I].[ModelName] AS [InventoryModelName]
		,[I].[ColourList] AS [InventoryColourList]
		,[I].[Dimension_L_INCH] AS [InventoryDimension_L_INCH]
		,[I].[Dimension_W_INCH] AS [InventoryDimension_W_INCH]
		,[I].[Dimension_H_INCH] AS [InventoryDimension_H_INCH]
		,[I].[Weight_LBS] AS [InventoryWeight_LBS]
		,[I].[ITSerial] AS [InventoryITSerial]
		,[I].[HardwareNotes] AS [InventoryHardwareNotes]
		,[I].[IsNew] AS [InventoryIsNew]
		,[I].[Supplier] AS [InventorySupplier]
		,[I].[PurchaseCost] AS [InventoryPurchaseCost]
		,[I].[AcquisitionDate] AS [InventoryAcquisitionDate]
		,[I].[DamageLevel] AS [InventoryDamageLevel]
		,[I].[DirtLevel] AS [InventoryDirtLevel]
		,[I].[ConditionNotes] AS [InventoryConditionNotes]
		,[I].[TestedDate] AS [InventoryTestedDate]
		,[I].[ITLocation] AS [InventoryITLocation]
		,[I].[IsAssigned] AS [InventoryIsAssigned]
		,[I].[AssignedDate] AS [InventoryAssignedDate]
		,[I].[AssignedNotes] AS [InventoryAssignedNotes]
		,[I].[AssignedExpectedReturn] AS [InventoryAssignedExpectedReturn]
		,[I].[RetrievedDate] AS [InventoryRetrievedDate]
		,[I].[RetireDate] AS [InventoryRetireDate]
		,[I].[RetireReason] AS [InventoryRetireReason]
		,[I].[ResourcePath] AS [InventoryResourcePath]
		,[I].[CableLength] AS [InventoryCableLenght]
		,[I].[PurchaseCostDate] AS [InventoryPurchaseCostDate]

		,[L].[ID] AS [LocationID]
		,[L].[DateCreated] AS [LocationDateCreated]
		,[L].[Active] AS [LocationActive]
		,[L].[DateActive] AS [LocationDateActive]
		,[L].[DateInactive] AS [LocationDateInactive]
		,[L].[Name] AS [LocationName]
		,[L].[BuildingID] AS [LocationBuildingID]
		,[L].[FloorNumber] AS [LocationFloorNumber]
		,[L].[GridRow] AS [LocationGridRow]
		,[L].[GridCol] AS [LocationGridCol]
		,[L].[Description] AS [LocationDescription]
		,[L].[EmployeeAssigned] AS [LocationEmployeeAssigned]

		,[C].[CustomerID] AS [ITRCustomersCustomerID]
		,[C].[Name] AS [ITRCustomersName]
		,[C].[Department] AS [ITRCustomersDepartment]
		,[C].[Company] AS [ITRCustomersCompany]
		,[C].[Email] AS [ITRCustomersEmail]
		,[C].[WorkPhone] AS [ITRCustomersWorkPhone]
		,[C].[WorkExtension] AS [ITRCustomersWorkExtension]
		,[C].[CellPhone] AS [ITRCustomersCellPhone]
		,[C].[HomePhone] AS [ITRCustomersHomePhone]
		,[C].[Active] AS [ITRCustomersActive]
		,[C].[DateAdded] AS [ITRCustomersDateAdded]
		,[C].[LastActive] AS [ITRCustomersLastActive]
		,[C].[WorkPhoneLastActive] AS [ITRCustomersWorkPhoneLastActive]
		,[C].[WorkExtensionLastActive] AS [ITRCustomersWorkExtensionLastActive]
		,[C].[CellPhoneLastActive] AS [ITRCustomersCellPhoneLastActive]
		,[C].[HomePhoneLastActive] AS [ITRCustomersHomePhoneLastActive]
		,[C].[WindowsUser] AS [ITRCustomersWindowsUser]
		,[C].[BirthYear] AS [ITRCustomersBirthYear]
		,[C].[BirthMonth] AS [ITRCustomersBirthMonth]
		,[C].[BirthDay] AS [ITRCustomersBirthDay]

	FROM
		[ITI Inventory] AS [I]
	LEFT JOIN
		[ITI Locations]  AS [L]
	ON
		[I].[ITLocation] = [L].[ID]
	LEFT JOIN
		[ITR Customers] AS [C]
	ON
		[L].[EmployeeAssigned] = [C].[CustomerID]
	WHERE
		[I].[AssignedExpectedReturn] IS NOT NULL
		AND [RetrievedDate] IS NULL
	;
GO