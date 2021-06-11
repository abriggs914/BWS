USE BWSdb
GO

SELECT * FROM [Options]
	WHERE [Description] LIKE '%tarp%';

SELECT * FROM [Options]
	WHERE [Description] LIKE '%tarp%'
		AND [Description] LIKE '%bracket%';

-- Shows that only mudflap options have a "brackets only" feature on DT models.
-- Want to include "Brackets only for tarps too"
SELECT * FROM [Options]
	WHERE [Description] LIKE '%bracket%'
		AND [Model No] LIKE '%dt%';
		
SELECT * FROM [Order Options]
	WHERE [Description] LIKE '%bracket%';

SELECT * FROM [Order Options]
	WHERE [Description] LIKE '%tarp%'
		AND [Description] LIKE '%bracket%';

SELECT * FROM [Options]
	WHERE [Description] LIKE '%under%'
		AND [Description] LIKE '%storage%'
	ORDER BY [Model No];

-- Double check self-cleaning ramps on ETs
SELECT * FROM [Options]
	WHERE [Description] LIKE '%clean%'
		AND [Model No] LIKE '%et%'
		AND [Description] NOT LIKE '%mounted in self cleaning%'
	ORDER BY [Model No];

-- Inspect ALL models for moulded rub-rail options.
-- Removing the options that remove D-rings.
SELECT * FROM [Options]
	WHERE [Description] LIKE '%moulded%'
		AND [Description] LIKE '%rub%'
		AND [Description] LIKE '%rail%'
		AND [Obsolete] = 0
	ORDER BY [Model No];
	
-- Inspect TO-REMOVE models for moulded rub-rail options.
-- Removing the options that remove D-rings.
SELECT * FROM [Options]
	WHERE [Description] LIKE '%moulded%'
		AND [Description] LIKE '%rub%'
		AND [Description] LIKE '%rail%'
		AND [Description] LIKE '% oc %'
		AND [Description] LIKE '%when adding%'
		AND [Obsolete] = 0
	ORDER BY [Model No];

-- Inspect TO-EDIT models for moulded rub-rail options.
-- Removing the options that remove D-rings.
SELECT * FROM [Options]
	WHERE [Description] LIKE '%moulded%'
		AND [Description] LIKE '%rub%'
		AND [Description] LIKE '%rail%'
		AND [Description] LIKE '% oc %'
		AND [Description] NOT LIKE '%when adding%'
		AND [Obsolete] = 0
	ORDER BY [Model No];

	
SELECT * FROM [Orders] ORDER BY [Quote Date]
SELECT * FROM [Order Options] ORDER BY [Description]
SELECT * FROM [Order Options_SpecLines]
SELECT * FROM [Order Options_FactoryLines]
SELECT * FROM [Order Standards]
--SELECT * FROM [Order]

SELECT * FROM [Orders]
	WHERE [Quote#] LIKE '26226'
		OR [Quote#] LIKE '26227'
		OR [Quote#] LIKE '26228'
		OR [Quote#] LIKE '26282'
		OR [Quote#] LIKE '26284'
		OR [Quote#] LIKE '26220'
		OR [Quote#] LIKE '26197'
		OR [Quote#] LIKE '26302'
		OR [Quote#] LIKE '26219'
		OR [Quote#] LIKE '26231'
		OR [Quote#] LIKE '26214'
		OR [Quote#] LIKE '26232'
		OR [Quote#] LIKE '26233'
		OR [Quote#] LIKE '26234'
		OR [Quote#] LIKE '26235'
		OR [Quote#] LIKE '26236'
		OR [Quote#] LIKE '26286'
	ORDER BY [Quote#]

SELECT [Quote#], [Quote Date], [WO#], [Available Date], [Delivery Date], [Notes], [Estimated Invoice Date] FROM [Orders]
	WHERE [Notes] LIKE '%brig%'
	AND [Notes] LIKE '%changed%'
	AND (
		[Notes] LIKE '%delivery%'
		OR [Notes] LIKE '%invoice%'
	)
	AND (
		[WO#] LIKE '10014514'
		OR [WO#] LIKE '10014515'
		OR [WO#] LIKE '10014516'
		OR [WO#] LIKE '10014517'
		OR [WO#] LIKE '10014518'
		OR [WO#] LIKE '10014705'
		OR [WO#] LIKE '10014659'
		OR [WO#] LIKE '10014660'
		OR [WO#] LIKE '10014663'
		OR [WO#] LIKE '10014690'
		OR [WO#] LIKE '10014810'
	)
	OR (
		[Quote#] LIKE '26249'
		OR [Quote#] LIKE '26251'
		OR [Quote#] LIKE '26223'
		OR [Quote#] LIKE '26250'
		OR [Quote#] LIKE '26202'
		OR [Quote#] LIKE '26229'
		OR [Quote#] LIKE '26226'
		OR [Quote#] LIKE '26227'
		OR [Quote#] LIKE '26228'
		OR [Quote#] LIKE '26222'
		OR [Quote#] LIKE '26254'
		OR [Quote#] LIKE '26252'
		OR [Quote#] LIKE '26253'
		OR [Quote#] LIKE '26282'
		OR [Quote#] LIKE '26284'
		OR [Quote#] LIKE '26220'
		OR [Quote#] LIKE '26197'
		OR [Quote#] LIKE '26302'
		OR [Quote#] LIKE '26219'
		OR [Quote#] LIKE '26230'
		OR [Quote#] LIKE '26231'
		OR [Quote#] LIKE '26215'
		OR [Quote#] LIKE '26238'
		OR [Quote#] LIKE '26213'
		OR [Quote#] LIKE '26237'
		OR [Quote#] LIKE '26216'
		OR [Quote#] LIKE '26242'
		OR [Quote#] LIKE '26214'
		OR [Quote#] LIKE '26232'
		OR [Quote#] LIKE '26233'
		OR [Quote#] LIKE '26234'
		OR [Quote#] LIKE '26235'
		OR [Quote#] LIKE '26236'
		OR [Quote#] LIKE '26286'
	)
	ORDER BY [Quote#]