USE BWSdb

GO
SELECT
'NEW' AS [X],
* FROM 
[ORders] WHERE [Serial Number] = '2XBB6GW22RA001312'
OR [Quote#] IN (29092, 29403)
SELECT
'OLD' AS [X],
* FROM 
[ORders] WHERE [Serial Number] = '2XBB6GW21RA001124'

SELECT
* FROM 
[dtProductionSchedule] WHERE [dtProductionSchedule].[Quote#] IN (29092, 29403) 
SELECT
* FROM 
[ORders] WHERE [Serial Number] = '2XBB6GW21RA001124'