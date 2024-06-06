USE BWSdb
GO

SELECT
	*
FROM
	[ITI Buildings] [B]
FULL OUTER JOIN
	[ITI Locations] [L]
ON
	[B].[ID] = [L].[BuildingID]
FULL OUTER JOIN
	[ITI_Building_Maps] [M]
ON
	[L].[ITIBuildingMapID] = [M].[ID]
;

SELECT
	*
FROM
;

SELECT
	*
FROM
	[ITI Inventory]
;

SELECT
	*
FROM
	[ITI_Building_Maps]
;