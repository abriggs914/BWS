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