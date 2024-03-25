USE [BWSdb]
GO

DECLARE @RC int
DECLARE @quote int = 29951;
--DECLARE @quote int = 30144;
SELECT @quote = 30181
DECLARE @year int = 2025
DECLARE @mode int = 3
DECLARE @startSeq int

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[sp_SerialNumberCalc] 
   @quote
  ,@year
  ,@mode
  --,@startSeq
GO

SELECT
	[CLass]
FROM
	[Products] [P]
GROUP BY
	[P].[Class]




	update 
		[Orders] 
	set
		[Serial Number] = (
			select 
				RIGHT('000000' + CAST(ISNULL(MAX([Serial Number]) + 1, 1) AS NVARCHAR(MAX)), 6) as NewSN
			from 
				[Orders] 
			inner join 
				[Products] 
			on 
				[Orders].[Model No] = [Products].[Model No]
			where
				[Class] = 'Towing'
				and [Products].[Model No] like '%SPUD KIT%'
				and ISNUMERIC([Serial Number]) = 1
		)
	where 
		[Quote#] = 30181


BEGIN TRAN;

SELECT
	*
FROM 
	[Products] [P]

UPDATE
	[Products]
SET
	[SerialCalcMethod] = 1
WHERE
	([Class] IN ('Agriculture', 'Stargate', 'Towing', 'Snow & Ice Control')
	AND LEFT([Model No], 8) <> 'SPUD KIT')
	OR ([Class] IN ('Snow & Ice Control')
	AND LEFT([Model No], 8) = 'SPUD KIT')

SELECT
	*
FROM 
	[Products] [P]

ROLLBACK;
COMMIT;


SELECT
	ISNUMERIC('0000a')


SELECT
	* 
FROM 
	[Orders] [O]
INNER JOIN
	[Products] [P]
ON
	[O].[ProductID] = [P].[IDTrailer]
WHERE
	--[P].[Class] = 'Snow & Ice Control'
	[P].[Class] = 'Towing'
ORDER BY
	[Order Date] DESC

SELECT [SerialCalcMethod] FROM [Products] INNER JOIN [Orders] ON [Products].[IDTrailer] = [Orders].[ProductID] WHERE [Quote#] = 30181