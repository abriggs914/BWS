USE BWSdb
GO


SELECT
	'Order Options' AS [OriginTable]
	,[OO].[ID] AS [OrderOptions_ID]
	,[OO].[Quote Date] AS [OrderOptions_DateQuote]
	,[OO].[Order Date] AS [OrderOptions_DateOrder]
	,[OO].[WO#] AS [OrderOptions_WO]
	,CAST([OO].[Quote#] AS NVARCHAR(MAX)) AS [OrderOptions_Quote]
	,[OO].[Option No] AS [OrderOptions_OptionNo]
	,[OO].[Price] AS [OrderOptions_Price]
	,[OO].[Qty] AS [OrderOptions_Qty]
	,[OO].[Sections] AS [OrderOptions_Sections]
	,[OO].[Description] AS [OrderOptions_Description]
	,[OO].[Comments] AS [OrderOptions_Comments]
	,[OO].[Weight] AS [OrderOptions_Weight]
	,[OO].[Cost] AS [OrderOptions_Cost]
	,[OO].[Material Cost] AS [OrderOptions_MaterialCost]
	,[OO].[Machine Shop] AS [OrderOptions_MachineShop]
	,[OO].[Steel Kit] AS [OrderOptions_SteelKit]
	,[OO].[Axles] AS [OrderOptions_Axles]
	,[OO].[Stakes/Bunks] AS [OrderOptions_StakesBunks]
	,[OO].[Beam] AS [OrderOptions_Beam]
	,[OO].[GNK] AS [OrderOptions_GNK]
	,[OO].[Parts] AS [OrderOptions_Parts]
	,[OO].[Line] AS [OrderOptions_Line]
	,[OO].[Step 1] AS [OrderOptions_Step1]
	,[OO].[Step 2] AS [OrderOptions_Step2]
	,[OO].[Blast] AS [OrderOptions_Blast]
	,[OO].[Paint] AS [OrderOptions_Paint]
	,[OO].[Finish] AS [OrderOptions_Finish]
	,[OO].[Finish - GNK] AS [OrderOptions_Finish-GNK]
	,[OO].[Final Assembly] AS [OrderOptions_FinalAssembly]
	,[OO].[Tire Assembly] AS [OrderOptions_TireAssembly]
	,[OO].[Shipping] AS [OrderOptions_Shipping]
	,[OO].[Start Date] AS [OrderOptions_DateStart]
	,[OO].[End Date] AS [OrderOptions_DateEnd]
	,[OO].[SortSe] AS [OrderOptions_SortSe]
	,[OO].[Width] AS [OrderOptions_Width]
	,[OO].[Spread] AS [OrderOptions_Spread]
	,[OO].[Draw/Part#] AS [OrderOptions_DrawPart]
	,[OO].[OptionInfo] AS [OrderOptions_OptionInfo]
	,[OO].[OptionPromptFlag] AS [OrderOptions_OptionPromptFlag]
	,[OO].[OptionPrompt] AS [OrderOptions_OptionPrompt]
	,[OO].[OptionConfigInfo] AS [OrderOptions_OptionConfigInfo]
	,[OO].[ordopt_timestamp] AS [OrderOptions_ordopt_timestamp]
	,[OO].[Are WO Specs Different?] AS [OrderOptions_AreWOSpecsDifferent]
	,[OO].[Comments V2] AS [OrderOptions_CommentsV2]
	,NULL AS [OrderOptions_Operation1Hours]
	,NULL AS [OrderOptions_Operation2Hours]
	,NULL AS [OrderOptions_Operation3Hours]
	,NULL AS [OrderOptions_Operation4Hours]
	,NULL AS [OrderOptions_Operation5Hours]
	,NULL AS [OrderOptions_Operation6Hours]
	,NULL AS [OrderOptions_Operation7Hours]
	,NULL AS [OrderOptions_Operation8Hours]
	,NULL AS [OrderOptions_Operation9Hours]
	,NULL AS [OrderOptions_Operation10Hours]
	,NULL AS [OrderOptions_Operation11Hours]
	,NULL AS [OrderOptions_Operation12Hours]
	,NULL AS [OrderOptions_Operation13Hours]
	,NULL AS [OrderOptions_Operation14Hours]
	,NULL AS [OrderOptions_Operation15Hours]
	,NULL AS [OrderOptions_Operation16Hours]
	,NULL AS [OrderOptions_Operation17Hours]
	,NULL AS [OrderOptions_OrderID]

	--,NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL,
	--NULL, NULL, NULL, NULL, NULL
	--,NULL
	,NULL AS [CustomWork_ID]
	,NULL AS [CustomWork_DateQuote]
	,CAST([Quote#] AS NVARCHAR(MAX)) AS [CustomWork_Quote]
	,NULL AS [CustomWork_DateOrder]
	,NULL AS [CustomWork_WO]
	,NULL AS [CustomWork_Section]
	,NULL AS [CustomWork_SortSe]
	,NULL AS [CustomWork_Description]
	,NULL AS [CustomWork_Qty]
	,NULL AS [CustomWork_Price]
	,NULL AS [CustomWork_Cost]
	,NULL AS [CustomWork_MaterialCost]
	,NULL AS [CustomWork_LabourCost]
	,NULL AS [CustomWork_MadeInMaterial]
	,NULL AS [CustomWork_BoughtOutMaterial]
	,NULL AS [CustomWork_Weight]
	,NULL AS [CustomWork_MachineShop]
	,NULL AS [CustomWork_SteelKit]
	,NULL AS [CustomWork_Axles]
	,NULL AS [CustomWork_StakesBunks]
	,NULL AS [CustomWork_Beam]
	,NULL AS [CustomWork_GNK]
	,NULL AS [CustomWork_Parts]
	,NULL AS [CustomWork_Line]
	,NULL AS [CustomWork_Step1]
	,NULL AS [CustomWork_Step2]
	,NULL AS [CustomWork_Blast]
	,NULL AS [CustomWork_Paint]
	,NULL AS [CustomWork_Finish]
	,NULL AS [CustomWork_Finish-GNK]
	,NULL AS [CustomWork_FinalAssembly]
	,NULL AS [CustomWork_TireAssembly]
	,NULL AS [CustomWork_Shipping]
	,NULL AS [CustomWork_EngHours]
	,NULL AS [CustomWork_DateOption]
	,NULL AS [CustomWork_DrawPart]
	,NULL AS [CustomWork_NPOInfo]
	,NULL AS [CustomWork_NPOPromptFlag]
	,NULL AS [CustomWork_NPOPrompt]
	,NULL AS [CustomWork_NPOConfigInfo]
	,NULL AS [CustomWork_DateNPOExpiration]
	,NULL AS [CustomWork_cw_timestamp]
	,NULL AS [CustomWork_USPrice]
	,NULL AS [CustomWork_AreWOSpecsDifferent]
	,NULL AS [CustomWork_Operation1Hours]
	,NULL AS [CustomWork_Operation2Hours]
	,NULL AS [CustomWork_Operation3Hours]
	,NULL AS [CustomWork_Operation4Hours]
	,NULL AS [CustomWork_Operation5Hours]
	,NULL AS [CustomWork_Operation6Hours]
	,NULL AS [CustomWork_Operation7Hours]
	,NULL AS [CustomWork_Operation8Hours]
	,NULL AS [CustomWork_Operation9Hours]
	,NULL AS [CustomWork_Operation10Hours]
	,NULL AS [CustomWork_Operation11Hours]
	,NULL AS [CustomWork_Operation12Hours]
	,NULL AS [CustomWork_Operation13Hours]
	,NULL AS [CustomWork_Operation14Hours]
	,NULL AS [CustomWork_Operation15Hours]
	,NULL AS [CustomWork_Operation16Hours]
	,NULL AS [CustomWork_Operation17Hours]

FROM
	[Order Options] AS [OO]
	
UNION ALL

SELECT
	'Custom Work' AS [OriginTable],
	NULL, NULL, NULL, [WO#], CAST([Quote#] AS NVARCHAR(MAX)),
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL

	,[CW].[ID] AS [CustomWork_ID]
	,[CW].[Quote Date] AS [CustomWork_DateQuote]
	,CAST([CW].[Quote#] AS NVARCHAR(MAX)) AS [CustomWork_SGQuote]
	,[CW].[Order Date] AS [CustomWork_DateOrder]
	,[CW].[WO#] AS [CustomWork_WO]
	,[CW].[Section] AS [CustomWork_Section]
	,[CW].[SortSe] AS [CustomWork_SortSe]
	,[CW].[Description] AS [CustomWork_Description]
	,[CW].[Qty] AS [CustomWork_Qty]
	,[CW].[Price] AS [CustomWork_Price]
	,[CW].[Cost] AS [CustomWork_Cost]
	,[CW].[Material Cost] AS [CustomWork_MaterialCost]
	,[CW].[Labour Cost] AS [CustomWork_LabourCost]
	,[CW].[Made In Material] AS [CustomWork_MadeInMaterial]
	,[CW].[Bought Out Material] AS [CustomWork_BoughtOutMaterial]
	,[CW].[Weight] AS [CustomWork_Weight]
	,[CW].[Machine Shop] AS [CustomWork_MachineShop]
	,[CW].[Steel Kit] AS [CustomWork_SteelKit]
	,[CW].[Axles] AS [CustomWork_Axles]
	,[CW].[Stakes/Bunks] AS [CustomWork_StakesBunks]
	,[CW].[Beam] AS [CustomWork_Beam]
	,[CW].[GNK] AS [CustomWork_GNK]
	,[CW].[Parts] AS [CustomWork_Parts]
	,[CW].[Line] AS [CustomWork_Line]
	,[CW].[Step 1] AS [CustomWork_Step1]
	,[CW].[Step 2] AS [CustomWork_Step2]
	,[CW].[Blast] AS [CustomWork_Blast]
	,[CW].[Paint] AS [CustomWork_Paint]
	,[CW].[Finish] AS [CustomWork_Finish]
	,[CW].[Finish - GNK] AS [CustomWork_Finish-GNK]
	,[CW].[Final Assembly] AS [CustomWork_FinalAssembly]
	,[CW].[Tire Assembly] AS [CustomWork_TireAssembly]
	,[CW].[Shipping] AS [CustomWork_Shipping]
	,[CW].[Eng Hours] AS [CustomWork_EngHours]
	,[CW].[Option Date] AS [CustomWork_DateOption]
	,[CW].[Draw/Part#] AS [CustomWork_DrawPart]
	,[CW].[NPOInfo] AS [CustomWork_NPOInfo]
	,[CW].[NPOPromptFlag] AS [CustomWork_NPOPromptFlag]
	,[CW].[NPOPrompt] AS [CustomWork_NPOPrompt]
	,[CW].[NPOConfigInfo] AS [CustomWork_NPOConfigInfo]
	,[CW].[NPOExpirationDate] AS [CustomWork_DateNPOExpiration]
	,[CW].[cw_timestamp] AS [CustomWork_cw_timestamp]
	,[CW].[US Price] AS [CustomWork_USPrice]
	,[CW].[Are WO Specs Different?] AS [CustomWork_AreWOSpecsDifferent]
	,NULL AS [CustomWork_Operation1Hours]
	,NULL AS [CustomWork_Operation2Hours]
	,NULL AS [CustomWork_Operation3Hours]
	,NULL AS [CustomWork_Operation4Hours]
	,NULL AS [CustomWork_Operation5Hours]
	,NULL AS [CustomWork_Operation6Hours]
	,NULL AS [CustomWork_Operation7Hours]
	,NULL AS [CustomWork_Operation8Hours]
	,NULL AS [CustomWork_Operation9Hours]
	,NULL AS [CustomWork_Operation10Hours]
	,NULL AS [CustomWork_Operation11Hours]
	,NULL AS [CustomWork_Operation12Hours]
	,NULL AS [CustomWork_Operation13Hours]
	,NULL AS [CustomWork_Operation14Hours]
	,NULL AS [CustomWork_Operation15Hours]
	,NULL AS [CustomWork_Operation16Hours]
	,NULL AS [CustomWork_Operation17Hours]
FROM
	[Custom Work] AS [CW]

UNION ALL

SELECT
	'Order OptionsV2' AS [OriginTable]
	,[OO2].[ID] AS [OrderOptionsV2ID]
	,[OO2].[Quote Date] AS [OrderOptionsV2DateQuote]
	,[OO2].[Order Date] AS [OrderOptionsV2DateOrder]
	,[OO2].[WO#] AS [OrderOptionsV2WO]
	,[OO2].[SGQuote] AS [OrderOptionsV2SGQuote]
	,[OO2].[Option No] AS [OrderOptionsV2OptionNo]
	,[OO2].[Price] AS [OrderOptionsV2Price]
	,[OO2].[Qty] AS [OrderOptionsV2Qty]
	,[OO2].[Sections] AS [OrderOptionsV2Sections]
	,[OO2].[Description] AS [OrderOptionsV2Description]
	,[OO2].[Comments] AS [OrderOptionsV2Comments]
	,[OO2].[Weight] AS [OrderOptionsV2Weight]
	,[OO2].[Cost] AS [OrderOptionsV2Cost]
	,[OO2].[Material Cost] AS [OrderOptionsV2MaterialCost]
	,[OO2].[Machine Shop] AS [OrderOptionsV2MachineShop]
	,[OO2].[Steel Kit] AS [OrderOptionsV2SteelKit]
	,[OO2].[Axles] AS [OrderOptionsV2Axles]
	,[OO2].[Stakes/Bunks] AS [OrderOptionsV2StakesBunks]
	,[OO2].[Beam] AS [OrderOptionsV2Beam]
	,[OO2].[GNK] AS [OrderOptionsV2GNK]
	,[OO2].[Parts] AS [OrderOptionsV2Parts]
	,[OO2].[Line] AS [OrderOptionsV2Line]
	,[OO2].[Step 1] AS [OrderOptionsV2Step1]
	,[OO2].[Step 2] AS [OrderOptionsV2Step2]
	,[OO2].[Blast] AS [OrderOptionsV2Blast]
	,[OO2].[Paint] AS [OrderOptionsV2Paint]
	,[OO2].[Finish] AS [OrderOptionsV2Finish]
	,[OO2].[Finish - GNK] AS [OrderOptionsV2Finish-GNK]
	,[OO2].[Final Assembly] AS [OrderOptionsV2FinalAssembly]
	,[OO2].[Tire Assembly] AS [OrderOptionsV2TireAssembly]
	,[OO2].[Shipping] AS [OrderOptionsV2Shipping]
	,[OO2].[Start Date] AS [OrderOptionsV2DateStart]
	,[OO2].[End Date] AS [OrderOptionsV2DateEnd]
	,[OO2].[SortSe] AS [OrderOptionsV2SortSe]
	,[OO2].[Width] AS [OrderOptionsV2Width]
	,[OO2].[Spread] AS [OrderOptionsV2Spread]
	,[OO2].[Draw/Part#] AS [OrderOptionsV2DrawPart]
	,[OO2].[OptionInfo] AS [OrderOptionsV2OptionInfo]
	,[OO2].[OptionPromptFlag] AS [OrderOptionsV2OptionPromptFlag]
	,[OO2].[OptionPrompt] AS [OrderOptionsV2OptionPrompt]
	,[OO2].[OptionConfigInfo] AS [OrderOptionsV2OptionConfigInfo]
	,[OO2].[ordopt_timestamp] AS [OrderOptionsV2ordopt_timestamp]
	,[OO2].[Are WO Specs Different?] AS [OrderOptionsV2AreWOSpecsDifferent]
	,[OO2].[Comments V2] AS [OrderOptionsV2CommentsV2]
	,[OO2].[Operation1Hours] AS [OrderOptionsV2Operation1Hours]
	,[OO2].[Operation2Hours] AS [OrderOptionsV2Operation2Hours]
	,[OO2].[Operation3Hours] AS [OrderOptionsV2Operation3Hours]
	,[OO2].[Operation4Hours] AS [OrderOptionsV2Operation4Hours]
	,[OO2].[Operation5Hours] AS [OrderOptionsV2Operation5Hours]
	,[OO2].[Operation6Hours] AS [OrderOptionsV2Operation6Hours]
	,[OO2].[Operation7Hours] AS [OrderOptionsV2Operation7Hours]
	,[OO2].[Operation8Hours] AS [OrderOptionsV2Operation8Hours]
	,[OO2].[Operation9Hours] AS [OrderOptionsV2Operation9Hours]
	,[OO2].[Operation10Hours] AS [OrderOptionsV2Operation10Hours]
	,[OO2].[Operation11Hours] AS [OrderOptionsV2Operation11Hours]
	,[OO2].[Operation12Hours] AS [OrderOptionsV2Operation12Hours]
	,[OO2].[Operation13Hours] AS [OrderOptionsV2Operation13Hours]
	,[OO2].[Operation14Hours] AS [OrderOptionsV2Operation14Hours]
	,[OO2].[Operation15Hours] AS [OrderOptionsV2Operation15Hours]
	,[OO2].[Operation16Hours] AS [OrderOptionsV2Operation16Hours]
	,[OO2].[Operation17Hours] AS [OrderOptionsV2Operation17Hours]
	,[OO2].[OrderID] AS [OrderOptionsV2OrderID]

	,NULL, NULL, [SGQuote], NULL, [WO#],
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL
	,NULL

FROM
	[Order OptionsV2] AS [OO2]
	
UNION ALL

SELECT
	'Custom WorkV2' AS [OriginTable]
	,NULL, NULL, NULL, [WO#], [SGQuote],
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL

	,[CW2].[ID] AS [CustomWorkV2_ID]
	,[CW2].[Quote Date] AS [CustomWorkV2_DateQuote]
	,[CW2].[SGQuote] AS [CustomWorkV2_SGQuote]
	,[CW2].[Order Date] AS [CustomWorkV2_DateOrder]
	,[CW2].[WO#] AS [CustomWorkV2_WO]
	,[CW2].[Section] AS [CustomWorkV2_Section]
	,[CW2].[SortSe] AS [CustomWorkV2_SortSe]
	,[CW2].[Description] AS [CustomWorkV2_Description]
	,[CW2].[Qty] AS [CustomWorkV2_Qty]
	,[CW2].[Price] AS [CustomWorkV2_Price]
	,[CW2].[Cost] AS [CustomWorkV2_Cost]
	,[CW2].[Material Cost] AS [CustomWorkV2_MaterialCost]
	,[CW2].[Labour Cost] AS [CustomWorkV2_LabourCost]
	,[CW2].[Made In Material] AS [CustomWorkV2_MadeInMaterial]
	,[CW2].[Bought Out Material] AS [CustomWorkV2_BoughtOutMaterial]
	,[CW2].[Weight] AS [CustomWorkV2_Weight]
	,[CW2].[Machine Shop] AS [CustomWorkV2_MachineShop]
	,[CW2].[Steel Kit] AS [CustomWorkV2_SteelKit]
	,[CW2].[Axles] AS [CustomWorkV2_Axles]
	,[CW2].[Stakes/Bunks] AS [CustomWorkV2_StakesBunks]
	,[CW2].[Beam] AS [CustomWorkV2_Beam]
	,[CW2].[GNK] AS [CustomWorkV2_GNK]
	,[CW2].[Parts] AS [CustomWorkV2_Parts]
	,[CW2].[Line] AS [CustomWorkV2_Line]
	,[CW2].[Step 1] AS [CustomWorkV2_Step1]
	,[CW2].[Step 2] AS [CustomWorkV2_Step2]
	,[CW2].[Blast] AS [CustomWorkV2_Blast]
	,[CW2].[Paint] AS [CustomWorkV2_Paint]
	,[CW2].[Finish] AS [CustomWorkV2_Finish]
	,[CW2].[Finish - GNK] AS [CustomWorkV2_Finish-GNK]
	,[CW2].[Final Assembly] AS [CustomWorkV2_FinalAssembly]
	,[CW2].[Tire Assembly] AS [CustomWorkV2_TireAssembly]
	,[CW2].[Shipping] AS [CustomWorkV2_Shipping]
	,[CW2].[Eng Hours] AS [CustomWorkV2_EngHours]
	,[CW2].[Option Date] AS [CustomWorkV2_DateOption]
	,[CW2].[Draw/Part#] AS [CustomWorkV2_DrawPart]
	,[CW2].[NPOInfo] AS [CustomWorkV2_NPOInfo]
	,[CW2].[NPOPromptFlag] AS [CustomWorkV2_NPOPromptFlag]
	,[CW2].[NPOPrompt] AS [CustomWorkV2_NPOPrompt]
	,[CW2].[NPOConfigInfo] AS [CustomWorkV2_NPOConfigInfo]
	,[CW2].[NPOExpirationDate] AS [CustomWorkV2_DateNPOExpiration]
	,[CW2].[cw_timestamp] AS [CustomWorkV2_cw_timestamp]
	,[CW2].[US Price] AS [CustomWorkV2_USPrice]
	,[CW2].[Are WO Specs Different?] AS [CustomWorkV2_AreWOSpecsDifferent]
	,[CW2].[Operation1Hours] AS [CustomWorkV2_Operation1Hours]
	,[CW2].[Operation2Hours] AS [CustomWorkV2_Operation2Hours]
	,[CW2].[Operation3Hours] AS [CustomWorkV2_Operation3Hours]
	,[CW2].[Operation4Hours] AS [CustomWorkV2_Operation4Hours]
	,[CW2].[Operation5Hours] AS [CustomWorkV2_Operation5Hours]
	,[CW2].[Operation6Hours] AS [CustomWorkV2_Operation6Hours]
	,[CW2].[Operation7Hours] AS [CustomWorkV2_Operation7Hours]
	,[CW2].[Operation8Hours] AS [CustomWorkV2_Operation8Hours]
	,[CW2].[Operation9Hours] AS [CustomWorkV2_Operation9Hours]
	,[CW2].[Operation10Hours] AS [CustomWorkV2_Operation10Hours]
	,[CW2].[Operation11Hours] AS [CustomWorkV2_Operation11Hours]
	,[CW2].[Operation12Hours] AS [CustomWorkV2_Operation12Hours]
	,[CW2].[Operation13Hours] AS [CustomWorkV2_Operation13Hours]
	,[CW2].[Operation14Hours] AS [CustomWorkV2_Operation14Hours]
	,[CW2].[Operation15Hours] AS [CustomWorkV2_Operation15Hours]
	,[CW2].[Operation16Hours] AS [CustomWorkV2_Operation16Hours]
	,[CW2].[Operation17Hours] AS [CustomWorkV2_Operation17Hours]
FROM
	[Custom WorkV2] AS [CW2]
	

