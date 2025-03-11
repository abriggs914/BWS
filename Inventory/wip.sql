

	-- Dump BOM and Access model data into temp table for faster processing
	DECLARE @BomModelData TABLE (
		[ID] INT IDENTITY(0, 1),
		[Component] NVARCHAR(128),
		[WareHouse] NVARCHAR(128),
		[ParentPart] NVARCHAR(128),
		[Model No] NVARCHAR(128),
		[Class] NVARCHAR(128),
		[Grouping] NVARCHAR(128)
	)

	DECLARE @InvData TABLE (
		[ID] INT IDENTITY(0, 1),
		[StockCode] NVARCHAR(128),
		[WareHouse] NVARCHAR(128),
		[WarehouseToUse] NVARCHAR(128),
		--[CycleCount] DECIMAL(18, 8),
		[CycleCount] INT,
		[CycleCountDescription] NVARCHAR(128),
		[ProductClass] NVARCHAR(128),
		[QtyOnHand] DECIMAL(15, 6),
		[UnitCost] DECIMAL(15, 6),
		[ValueOnHand] DECIMAL(15, 6)
	)

	INSERT INTO @BomModelData ([Component], [WareHouse], [ParentPart], [Model No], [Class], [Grouping])
	SELECT BomStructure.Component
		, CASE WHEN len(BomStructure.Warehouse) = 0 THEN InvMaster.WarehouseToUse
				ELSE BomStructure.Warehouse
				END AS Warehouse
		, BomStructure.ParentPart
		, CASE WHEN AccessBaseModel.[Model No] IS NOT NULL AND AccessQuoteModel.[Model No] IS NULL THEN AccessBaseModel.[Model No]
				WHEN AccessBaseModel.[Model No] IS NULL AND AccessQuoteModel.[Model No] IS NOT NULL THEN AccessQuoteModel.[Model No]
				END AS [Model No]
		, CASE WHEN AccessBaseModel.[Model No] IS NOT NULL AND AccessQuoteModel.[Model No] IS NULL THEN AccessBaseModel.[Class]
				WHEN AccessBaseModel.[Model No] IS NULL AND AccessQuoteModel.[Model No] IS NOT NULL THEN AccessQuoteModel.[Class]
				END AS [Class]
		, CASE WHEN AccessBaseModel.[Model No] IS NOT NULL AND AccessQuoteModel.[Model No] IS NULL THEN AccessBaseModel.[Grouping]
				WHEN AccessBaseModel.[Model No] IS NULL AND AccessQuoteModel.[Model No] IS NOT NULL THEN AccessQuoteModel.[Grouping]
				END AS [Grouping]
	/*
	INTO
		##BomModelData
	*/
	FROM
		SysproCompanyA.dbo.BomStructure WITH (nolock)
	INNER JOIN
		SysproCompanyA.dbo.InvMaster WITH (nolock)
	ON
		BomStructure.Component = InvMaster.StockCode
	LEFT OUTER JOIN
		(
			SELECT CLASS
				, [Model No]
				, [Grouping]
				, [Top Level Part# (SYSPRO 8)]
			FROM
				BWSdb.dbo.Products WITH (NOLOCK)
			WHERE
				[Non-Current] = 0
				AND [Proposed] = 0
		) AS AccessBaseModel
	ON
		BomStructure.ParentPart = AccessBaseModel.[Top Level Part# (SYSPRO 8)] COLLATE Latin1_General_BIN
	LEFT OUTER JOIN
		BWSdb.dbo.Orders WITH (NOLOCK)
	ON
		RIGHT(BomStructure.ParentPart, 6) = '-' + CAST(Orders.[Quote#] AS VARCHAR)
	LEFT OUTER JOIN
		(
			SELECT IDTrailer
				, CLASS
				, [Model No]
				, [Grouping]
				, [Top Level Part# (SYSPRO 8)]
			FROM
				BWSdb.dbo.Products WITH (NOLOCK)
			WHERE
				[Non-Current] = 0
				AND [Proposed] = 0
		) AS AccessQuoteModel
	ON
		Orders.ProductID = AccessQuoteModel.IDTrailer
		OR Orders.[Model No] = AccessQuoteModel.[Model No]
	
	-- Dump Inventory values into temp table for faster processing
	INSERT INTO @InvData ([StockCode], [Warehouse], [WarehouseToUSe], [CycleCount], [CycleCountDescription], [ProductClass], [QtyOnHAnd], [UnitCost], [ValueOnHand])
	SELECT InvMaster.StockCode
		, InvWarehouse.Warehouse
		, InvMaster.WarehouseToUse
		, CAST(InvMaster.CycleCount AS INT)
		, CASE CycleCount WHEN '1' THEN '1 - PURCHASED'
						WHEN '2' THEN '2 - FULL LENGTH STEEL/ALUMINUM'
						WHEN '3' THEN '3 - STEEL KITS'
						WHEN '4' THEN '4 - PRECUT STEEL'
						WHEN '5' THEN '5 - PAINT/PAINT PRODUCTS'
						WHEN '6' THEN '6 - CONSUMABLES'
						WHEN '7' THEN '7 - MANUFACTURED PARTS/COMPONENTS'
						WHEN '8' THEN '8 - AXLES/SUSPENSIONS'
						WHEN '9' THEN '9 - FLOORING/LUMBER'
						WHEN '10' THEN '10 - LASER KITS'
						WHEN '11' THEN '11 - TIRES/WHEELS'
						WHEN '12' THEN '12 - MARKETING MATERIAL'
						WHEN '13' THEN '13 - PRECUT ALUMINUM'
						WHEN '14' THEN '14 - STEEL/ALUM PLATE'
						WHEN '15' THEN '15 - CYLINDERS'
						WHEN '21' THEN '21 - OBSOLETE PURCHASED PARTS'
						WHEN '22' THEN '22 - OBSOLETE FULL LENGTH STEEL'
						WHEN '23' THEN '23 - OBSOLETE STEEL KITS'
						WHEN '24' THEN '24 - OBSOLETE PRECUT STEEL'
						WHEN '25' THEN '25 - OBSOLETE PAINT/PAINT PRODUCTS'
						WHEN '26' THEN '26 - OBSOLETE CONSUMABLES'
						WHEN '27' THEN '27 - OBSOLETE MANUFACTURED PARTS/COMPONENTS'
						WHEN '28' THEN '28 - OBSOLETE AXLES/SUSPENSIONS'
						WHEN '29' THEN '29 - OBSOLETE FLOORING/LUMBER'
						WHEN '30' THEN '30 - OBSOLETE LASER KITS'
						WHEN '31' THEN '31 - OBSOLETE TIRES/WHEELS'
						WHEN '32' THEN '32 - OBSOLETE MARKETING MATERIAL'
						WHEN '33' THEN '33 - OBSOLETE PRECUT ALUMINUM'
						WHEN '34' THEN '34 - OBSOLETE STEEL/ALUM PLATE'
						WHEN '55' THEN '55 - EXCESS LB AND HR'
						ELSE cast(CycleCount AS varchar) + ' - UNCLASSIFIED' END AS [CycleCountDescription]
		, InvMaster.ProductClass
		, InvWarehouse.QtyOnHand
		, InvWarehouse.UnitCost
		, (InvWarehouse.QtyOnHand * InvWarehouse.UnitCost) AS [ValueOnHand]
	/*
	INTO
		##InvData
	*/
	FROM
		SysproCompanyA.dbo.InvWarehouse WITH (NOLOCK)
	INNER JOIN
		SysproCompanyA.dbo.InvMaster WITH (NOLOCK)
	ON
		InvWarehouse.StockCode = InvMaster.StockCode
	LEFT OUTER JOIN
		(
			SELECT StockCode
				, sum(DemandQty) AS [NetDemandQty]
			FROM
				SysproCompanyA.dbo.MrpRequirement WITH (nolock)
			GROUP BY
				StockCode
		) AS subMRPReqDemandSumCheck
	ON
		InvWarehouse.StockCode = subMRPReqDemandSumCheck.StockCode
	WHERE
		(
			InvMaster.WarehouseToUse NOT IN ('03', '99')
			OR InvMaster.WarehouseToUse IS NULL
		)
		AND InvWarehouse.QtyOnHand <> 0
		AND (
			subMRPReqDemandSumCheck.NetDemandQty = 0
			OR subMRPReqDemandSumCheck.NetDemandQty IS NULL
		)

	SELECT 
		'Details' AS [DatasetType]
		, StockCode
		, Warehouse
		, WarehouseToUse
		, CycleCount
		, CycleCountDescription
		, ProductClass
		, QtyOnHand
		, UnitCost
		, ValueOnHand
		, CASE WHEN ParentPartsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ParentPartsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ParentPartsCount > 1 THEN 'MULTIPLE BOMS'
			ELSE ParentParts
			END AS [ParentPart]
		, CASE WHEN ParentPartsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ParentPartsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ParentPartsCount > 1 THEN ParentParts
			END AS [ParentPartsArray (IF MULTIPLE)]
		, CASE WHEN ModelNosCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ModelNosCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ModelNosCount > 1 THEN 'MULTIPLE MODELS'
			ELSE ModelNos
			END AS [ModelNo]
		, CASE WHEN ModelNosCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ModelNosCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ModelNosCount > 1 THEN ModelNos
			END AS [ModelNosArray (IF MULTIPLE)]
		, CASE WHEN ClassesCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ClassesCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ClassesCount > 1 THEN 'MULTIPLE CLASSES'
			ELSE Classes
			END AS [Class]
		, CASE WHEN ClassesCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ClassesCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ClassesCount > 1 THEN Classes
			END AS [ClasssArray (IF MULTIPLE)]
		, CASE WHEN GroupingsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN GroupingsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN GroupingsCount > 1 THEN 'MULTIPLE GROUPINGS'
			ELSE Groupings
			END AS [Grouping]
		, CASE WHEN GroupingsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN GroupingsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN GroupingsCount > 1 THEN Groupings
			END AS [GroupingsArray (IF MULTIPLE)]
	FROM
	(
		SELECT StockCode
			, Warehouse
			, WarehouseToUse
			, CycleCount
			, [CycleCountDescription]
			, ProductClass
			, QtyOnHand
			, UnitCost
			, [ValueOnHand]
			, (
					SELECT COUNT(*)
					FROM
						@BomModelData AS BomModelData
					WHERE
						BomModelData.Component = InvData.StockCode
						AND BomModelData.Warehouse = InvData.Warehouse
			) AS [ParentPartsCount]
			, ltrim(
				STUFF(
					(
						SELECT ', ' + BomModelData.ParentPart
						FROM
							@BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
					FOR XML path(''))
					, 1, 1, ''
				)
			) AS [ParentParts]
			, (
				SELECT count(DISTINCT BomModelData.[Model No])
						FROM
							@BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
			) AS [ModelNosCount]
			, ltrim(
				STUFF(
					(
						SELECT DISTINCT ', ' + BomModelData.[Model No]
						FROM
							@BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
					FOR XML path(''))
					, 1, 1, ''
					)
			) AS [ModelNos]
			, (
				SELECT count(DISTINCT BomModelData.[Class])
						FROM
							@BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
			) AS [ClassesCount]
			, ltrim(
				STUFF(
					(
						SELECT DISTINCT ', ' + BomModelData.[Class]
						FROM
							@BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
					FOR XML path(''))
					, 1, 1, ''
					)
			) AS [Classes]
			, (
				SELECT count(DISTINCT BomModelData.[Grouping])
						FROM
							@BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
			) AS [GroupingsCount]
			, ltrim(
				STUFF(
					(
						SELECT DISTINCT ', ' + BomModelData.[Grouping]
						FROM
							@BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
					FOR XML path(''))
					, 1, 1, ''
					)
			) AS [Groupings]
		FROM
			@InvData AS InvData
	) AS main
	