USE BWSdb
GO

SELECT
	*
FROM
	[Budget Std V2]
WHERE
	[Model No] IN
		(
			'BTL3XSS PACE',
			'BTL4XASS PACE',
			'BTP2XASS PACE',

			'BTL3XAA PACE',
			'BTL3XAAB PACE',
			'BTL3XAAC PACE',
			'BTL4XAA PACE',
			'BTP3XAA PACE',
			'BTP3XAAB PACE',
			'BTP3XAAC PACE'
		)
ORDER BY
	[Model No]
;

INSERT INTO
	[Budget Std V2]
	([Model No]
           ,[Top Level Part# (SYSPRO)]
           ,[Std Date]
           ,[COGS]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Machine Shop]
           ,[Axles]
           ,[Stakes/Bunks]
           ,[Beam]
           ,[GNK]
           ,[Parts]
           ,[Subs]
           ,[Line]
           ,[Step 1]
           ,[Step 2]
           ,[Blast]
           ,[Paint]
           ,[Finish]
           ,[Finish - GNK]
           ,[Final Assembly]
           ,[Tire Assembly]
           ,[Shipping]
           ,[Margins Base]
           ,[Margins Options]
           ,[Top Level Part# (SYSPRO 8)]
           ,[CompanyID]
           ,[Operation1Hours]
           ,[Operation2Hours]
           ,[Operation3Hours]
           ,[Operation4Hours]
           ,[Operation5Hours]
           ,[Operation6Hours]
           ,[Operation7Hours]
           ,[Operation8Hours]
           ,[Operation9Hours]
           ,[Operation10Hours]
           ,[Operation11Hours]
           ,[Operation12Hours]
           ,[Operation13Hours]
           ,[Operation14Hours]
           ,[Operation15Hours]
           ,[Operation16Hours]
           ,[Operation17Hours])
SELECT
SET
	