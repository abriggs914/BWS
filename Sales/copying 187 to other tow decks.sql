

--Copying -87 to [SpecSortSeLine] on [BWSdb].[dbo].[Order Options_SpecLines]
-- 2024-12-02 1748


SELECT
	*
FROM
	[BWSdb].[dbo].[Order Options_FactoryLines] [FL]
WHERE
	[FL].[SpecSortSeLine] = -87
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Order Options_SpecLines] [SL]
WHERE
	[SL].[SpecSortSeLine] = -87
;

DECLARE @q INT = 30687;
DECLARE @m NVARCHAR(MAX);

DECLARE @quotesInQuestion TABLE ([Q] INT);
DECLARE @optionsInQuestion TABLE ([Q] INT, [O] NVARCHAR(MAX));

SELECT
	@m = [Model No]
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	[Quote#] = @q

INSERT INTO @quotesInQuestion ([Q])
SELECT
	[Quote#]
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	([Model No] = @m)
	--AND (Quote#)


INSERT INTO @optionsInQuestion ([Q], [O])
SELECT
	[Quote#],
	[Option No]
FROM
	[BWSdb].[dbo].[Order Options_SpecLines] [SL]
INNER JOIN
	@quotesInQuestion [Qiq]
ON
	[SL].[Quote#] = [Qiq].[Q]
WHERE
	[SpecSortSeLine] = -87
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Order Options_FactoryLines] [FL]
INNER JOIN
	@quotesInQuestion [Qiq]
ON
	[FL].[Quote#] = [Qiq].[Q]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Order Options_SpecLines] [SL]
INNER JOIN
	@quotesInQuestion [Qiq]
ON
	[SL].[Quote#] = [Qiq].[Q]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Order Options] [OO]
INNER JOIN
	@quotesInQuestion [Qiq]
ON
	[OO].[Quote#] = [Qiq].[Q]
ORDER BY
	[Option No],
	[Quote#]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	@quotesInQuestion [Qiq]
ON
	[O].[Quote#] = [Qiq].[Q]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Order Options_SpecLines] [SL]
INNER JOIN
	@optionsInQuestion [Oiq]
ON
	[SL].[Option No] = [Oiq].[O]
ORDER BY
	[Quote#],
	[Description]

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Order Options_SpecLines]
SET
	[SpecSortSeLine] = -87
FROM
	[BWSdb].[dbo].[Order Options_SpecLines] [SL]
INNER JOIN
	@optionsInQuestion [Oiq]
ON
	[SL].[Option No] = [Oiq].[O]

SELECT
	*
FROM
	[BWSdb].[dbo].[Order Options_SpecLines] [SL]
INNER JOIN
	@optionsInQuestion [Oiq]
ON
	[SL].[Option No] = [Oiq].[O]
ORDER BY
	[Quote#],
	[Description]

ROLLBACK;
COMMIT;
*/