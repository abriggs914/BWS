USE BWSdb
GO

CREATE PROCEDURE [sp_ITI_UniqueColours] AS BEGIN

	DECLARE @S varchar(max),
			@Split char(1),
			@X xml

	SELECT @Split = ',';

	DECLARE @i AS INT;
	DECLARE @c AS INT;
	SELECT @i = 0, @c = COUNT(*) FROM [ITI Inventory]

	DECLARE @res AS TABLE ([ID] INT IDENTITY(0, 1), [Colour] NVARCHAR(MAX))

	WHILE @i < @c BEGIN

		SELECT @S = [ColourList] FROM [ITI Inventory] WHERE [ID] = @i;

		SELECT @X = CONVERT(xml,' <root> <myvalue>' +
		REPLACE(@S,@Split,'</myvalue> <myvalue>') + '</myvalue>   </root> ')

		SELECT @i = @i + 1;

		INSERT INTO @res
		SELECT UPPER(LTRIM(RTRIM(T.c.value('.','varchar(200)'))))
		FROM @X.nodes('/root/myvalue') T(c)
	END

	SELECT DISTINCT [Colour] FROM @res ORDER BY [Colour]

	--SELECT  T.c.value('.','varchar(20)'),              --retrieve ALL values at once
	--  T.c.value('(/root/myvalue)[1]','VARCHAR(20)')  , --retrieve index 1 only, which is the 'ab'
	--  T.c.value('(/root/myvalue)[2]','VARCHAR(20)')
	-- FROM @X.nodes('/root/myvalue') T(c)
END