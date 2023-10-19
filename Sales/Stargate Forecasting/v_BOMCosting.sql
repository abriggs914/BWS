USE SysproCompanyS
GO

ALTER VIEW [v_BOMCosting] AS
SELECT       
	ParentPart,
	SUM(MadeInMaterial) AS MadeInMaterial,
	SUM(BoughtOutMaterial) AS BoughtOutMaterial,
	SUM(LabourCost) AS LabourCost,
	SUM(MadeInMaterial) + SUM(BoughtOutMaterial) + SUM(LabourCost) AS COGS, 
	SUM(MachineShop) AS MachineShop,
	SUM(Axle) AS Axle,
	SUM(Beams) AS Beams,
	SUM(Subs) AS Subs,
	SUM(Assembly) AS [Assembly],
	SUM(Step1) AS Step1,
	SUM(Step2) AS Step2,
	SUM(Blast) AS Blast,
	SUM(Paint) AS Paint, 
	SUM(Finish) AS Finish,
	SUM([Finish - GNK]) AS FGNK,
	SUM([Final Assembly]) AS FinalAssembly,
	SUM([Tire Assembly]) AS TireAssembly,
	SUM(Shipping) AS Shipping
FROM (
	SELECT
		ParentPart,
		SUM(NetMaterial) + SUM(NetLabour) AS MadeInMaterial,
		0 AS BoughtOutMaterial,
		0 AS LabourCost,
		0 AS MachineShop,
		0 AS Axle,
		0 AS Beams,
		0 AS Subs,
		0 AS Assembly,
		0 AS Step1,
		0 AS Step2,
		0 AS Blast,
		0 AS Paint,
		0 AS Finish,
		0 AS [Finish - GNK],
		0 AS [Final Assembly],
		0 AS [Tire Assembly],
		0 AS Shipping
	FROM (
		SELECT
			dbo.BomStructure.ParentPart,
			dbo.BomStructure.Component,
			dbo.InvMaster.Description,
			dbo.InvMaster.LongDesc,
			dbo.BomStructure.QtyPer * (dbo.BomStructure.ScrapPercentage / 100 + 1) AS QtyPer, 
			dbo.InvMaster.PartCategory, 
			dbo.InvMaster.MaterialCost,
			dbo.InvMaster.MaterialCost * (dbo.BomStructure.QtyPer * (dbo.BomStructure.ScrapPercentage / 100 + 1)) AS NetMaterial, 
			dbo.InvMaster.LabourCost,
			dbo.InvMaster.FixOverhead,
			dbo.InvMaster.LabourCost * (dbo.BomStructure.QtyPer * (dbo.BomStructure.ScrapPercentage / 100 + 1)) 
				+ dbo.InvMaster.FixOverhead * (dbo.BomStructure.QtyPer * (dbo.BomStructure.ScrapPercentage / 100 + 1)) AS NetLabour
		FROM
			dbo.BomStructure WITH (nolock)
		INNER JOIN
			dbo.InvMaster WITH (nolock)
		ON
			dbo.BomStructure.Component = dbo.InvMaster.StockCode
			AND dbo.InvMaster.PartCategory = 'M' 
			AND dbo.BomStructure.Route = '0') AS subquery
		GROUP BY 
			ParentPart
		
		UNION

		SELECT
			ParentPart,
			0 AS MadeInMaterial,
			SUM(NetMaterial) + SUM(NetLabour) AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM (
			SELECT
				dbo.BomStructure.ParentPart,
				dbo.BomStructure.Component,
				dbo.InvMaster.Description,
				dbo.InvMaster.LongDesc,
				dbo.BomStructure.QtyPer * (dbo.BomStructure.ScrapPercentage / 100 + 1) AS QtyPer, 
				dbo.InvMaster.PartCategory,
				dbo.InvMaster.MaterialCost,
				dbo.InvMaster.MaterialCost * (dbo.BomStructure.QtyPer * (dbo.BomStructure.ScrapPercentage / 100 + 1)) AS NetMaterial, 
				dbo.InvMaster.LabourCost,
				dbo.InvMaster.FixOverhead,
				dbo.InvMaster.LabourCost * (dbo.BomStructure.QtyPer * (dbo.BomStructure.ScrapPercentage / 100 + 1)) 
					+ dbo.InvMaster.FixOverhead * (dbo.BomStructure.QtyPer * (dbo.BomStructure.ScrapPercentage / 100 + 1)) AS NetLabour
			FROM
				dbo.BomStructure WITH (nolock)
			INNER JOIN
				dbo.InvMaster WITH (nolock)
			ON
				dbo.BomStructure.Component = dbo.InvMaster.StockCode
				AND dbo.InvMaster.PartCategory = 'B'
				AND dbo.BomStructure.Route = '0'
		) AS subquery
		GROUP BY
			ParentPart
		
		UNION
		
		

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			SUM(LabourCost) AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM (
			SELECT 
				dbo.BomOperations.StockCode,
				dbo.BomOperations.Operation,
				dbo.BomOperations.IRunTime,
				dbo.BomOperations.IRunTime * dbo.BomWorkCentre.SetUpRate1 + dbo.BomOperations.IRunTime * dbo.BomWorkCentre.FixOverRate1 AS LabourCost
			FROM
				dbo.BomOperations WITH (nolock)
			INNER JOIN
				dbo.BomWorkCentre WITH (nolock)
			ON
				dbo.BomOperations.WorkCentre = dbo.BomWorkCentre.WorkCentre
			WHERE 
				(dbo.BomOperations.Route = '0')
		) AS subquery
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			SUM(IRunTime) AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM 
			dbo.BomOperations WITH (nolock)
		WHERE
			(WorkCentre = 'M') 
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT 
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			SUM(IRunTime) AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(WorkCentre = 'A') 
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT 
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			SUM(IRunTime) AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(WorkCentre = 'B')
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			SUM(IRunTime) AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM 
			dbo.BomOperations WITH (nolock)
		WHERE
			(WorkCentre = 'S')
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			SUM(IRunTime) AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,	
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(
				WorkCentre IN (
					'T',
					'D',
					'SC-1',
					'SC-2',
					'SC-3',
					'SC-4',
					'SC-5'
				)
			) 
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			SUM(IRunTime) AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(IMachine = '41') 
			AND (Route = '0') 
			OR (IMachine <> '42')
			AND (Route = '0')
			AND (
				WorkCentre IN (
					'T',
					'D',
					'SC-1',
					'SC-2',
					'SC-3',
					'SC-4'
				)
			)
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			SUM(IRunTime) AS Step2,
			0 AS Blast,
			0 AS Paint,	
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(IMachine = '42')
			AND (Route = '0')
			OR (Route = '0') 
			AND (WorkCentre = 'SC-5')
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			SUM(IRunTime) AS Blast,
			0 AS Paint,	
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(IMachine = '05')
			AND (WorkCentre <> 'T')
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			SUM(IRunTime) AS Paint,	
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(WorkCentre = 'P' OR WorkCentre LIKE 'TL%')
			AND (IMachine <> '05')
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT 
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			SUM(IRunTime) 
			AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(
				WorkCentre IN (
					'F',
					'SC-6'
				)
			) 
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,	
			SUM(IRunTime) AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(IMachine = '47')
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,
			0 AS [Finish - GNK],
			SUM(IRunTime) AS [Final Assembly],
			0 AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(
				WorkCentre IN (
					'F',
					'SC-6'
				)
			)
			AND (
				IMachine NOT IN (
					'40',
					'47'
				)
			) 
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,	
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			SUM(IRunTime) AS [Tire Assembly],
			0 AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(
				Operation IN (
					'6',
					'13'
				)
			) 
			AND (IMachine = '40')
			AND (Route = '0')
		GROUP BY
			StockCode

		UNION

		SELECT
			StockCode,
			0 AS MadeInMaterial,
			0 AS BoughtOutMaterial,
			0 AS LabourCost,
			0 AS MachineShop,
			0 AS Axle,
			0 AS Beams,
			0 AS Subs,
			0 AS Assembly,
			0 AS Step1,
			0 AS Step2,
			0 AS Blast,
			0 AS Paint,
			0 AS Finish,
			0 AS [Finish - GNK],
			0 AS [Final Assembly],
			0 AS [Tire Assembly],
			SUM(IRunTime) AS Shipping
		FROM
			dbo.BomOperations WITH (nolock)
		WHERE
			(WorkCentre = 'L')
			AND (Route = '0')
		GROUP BY
			StockCode
	) AS mainsub



GROUP BY ParentPart