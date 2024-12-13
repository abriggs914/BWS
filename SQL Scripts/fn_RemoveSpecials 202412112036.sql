USE [BWSdb]
GO
/****** Object:  UserDefinedFunction [dbo].[fnRemoveNonNumericCharacters]    Script Date: 2024-12-11 4:46:22 PM ******/

-- 2024-12-11 1815 - Abriggs - Function to remove special characters from string inputs.
--								Optionally include a select set of specials with default param.
-- 2024-12-11 2029 - Abriggs - Reversed the logic to maintain case, and to avoid creating gaps when replacing specials.
--								Current method will just skip specials

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Function [dbo].[fn_RemoveSpecials](
	@strText NVARCHAR(MAX),
	@include NVARCHAR(MAX) = '',
	@fillChar NVARCHAR(MAX) = '',
	@preserveSpacing BIT = 0
)
RETURNS NVARCHAR(MAX)
AS
BEGIN


	/*	
	---------------------
	------ TESTING ------
	---------------------

	DECLARE @strText NVARCHAR(MAX) = 'Avery is vErY cool, eXcept when; he tries'' to insert: some! speci@l character3.( This is rude# and should not be%$ tolerated. Remo^e them &t onc*), I mean `~ *all -_+= /-+<?>/ specials } [] { \| "';
	--DECLARE @strTextC NVARCHAR(MAX) = UPPER(SUBSTRING(@strText, 1, LEN(@strText)));
	DECLARE @include NVARCHAR(MAX) = ';';
	DECLARE @fillChar NVARCHAR(MAX) = '';
	--DECLARE @invalidTable TABLE ([ID] INT IDENTITY(0, 1), [Char] NVARCHAR(1), [RN] INT)
	*/
	
	DECLARE @i INT;
	DECLARE @c INT;
	DECLARE @char NVARCHAR(1);
	DECLARE @result NVARCHAR(MAX) = '';

	IF @preserveSpacing = 1 BEGIN
		
		SELECT @result = @strText
		DECLARE @invalidTable TABLE ([ID] INT IDENTITY(0, 1), [Char] NVARCHAR(1))
		INSERT INTO @invalidTable ([Char]) VALUES
			('`'),
			('~'),
			('!'),
			('@'),
			('#'),
			('$'),
			('%'),
			('^'),
			('&'),
			('*'),
			('('),
			(')'),
			('-'),
			('_'),
			('='),
			('+'),
			('{'),
			('}'),
			('['),
			(']'),
			('\'),
			('|'),
			(';'),
			(':'),
			(CHAR(39)),
			('"'),
			(','),
			('<'),
			('.'),
			('>'),
			('/'),
			('?'),
			(CHAR(9)),  -- \t
			(CHAR(10))  -- \n
		;

		SELECT
			@i = 0,
			@c = LEN(@include)
		;

		WHILE @i < @c BEGIN

			SELECT
				@char = SUBSTRING(@include, @i + 1, 1)
			;

			DELETE FROM 
				@invalidTable
			WHERE
				[Char] = @char
			;

			SELECT
				@i = @i + 1
			;
		END

		SELECT
			@i = 0,
			@c = MAX([ID])
		FROM
			@invalidTable
		;

		WHILE @i <= @c BEGIN

			SELECT
				@char = ''
			;

			SELECT
				@char = [Char]
			FROM
				@invalidTable
			WHERE
				[ID] = @i
			;

			IF LEN(@char) > 0 BEGIN
				SELECT 
					@result = REPLACE(@result, @char, @fillChar)
				;
			END

			SELECT
				@i = @i + 1	
			;

		END


		/*
		---------------------

		SELECT
			@strText AS [Res]
		---------------------
		*/

	END
	ELSE BEGIN
	
		DECLARE @validTable TABLE ([ID] INT IDENTITY(0, 1), [Char] NVARCHAR(1))
		DECLARE @validSpecialsTable TABLE ([ID] INT IDENTITY(0, 1), [Char] NVARCHAR(1))
		INSERT INTO @validSpecialsTable ([Char]) VALUES
			('`'),
			('~'),
			('!'),
			('@'),
			('#'),
			('$'),
			('%'),
			('^'),
			('&'),
			('*'),
			('('),
			(')'),
			('-'),
			('_'),
			('='),
			('+'),
			('{'),
			('}'),
			('['),
			(']'),
			('\'),
			('|'),
			(';'),
			(':'),
			(CHAR(39)),  -- '''' -- single quote, apostrophe
			('"'),
			(','),
			('<'),
			('.'),
			('>'),
			('/'),
			('?')
			--,
			--(CHAR(9)),  -- \t
			--(CHAR(10))  -- \n
		;
	

		SELECT
			@i = 97,
			@c = 122
		;

		WHILE @i <= @c BEGIN

			/*
			SELECT
				@i AS [I0]
			*/

			INSERT INTO @validTable ([Char])
			SELECT
				CHAR(@i)
			UNION ALL
			SELECT
				CHAR(@i - 32)
			;

			SELECT
				@i = @i + 1
			;

		END

		SELECT
			@i = 0,
			@c = LEN(@include)
		;

		WHILE @i < @c BEGIN

			SELECT
				@char = SUBSTRING(@include, @i + 1, 1)
			;

			/*
			SELECT
				@i AS [I1]
				,@char AS [CHR]
			*/

			INSERT INTO @validTable ([Char])
			SELECT
				[VST].[Char]
			FROM
				@validSpecialsTable [VST]
			WHERE
				[VST].[Char] = @char

			SELECT
				@i = @i + 1
			;
		END

		INSERT INTO @validTable ([Char]) VALUES
			('0'),
			('1'),
			('2'),
			('3'),
			('4'),
			('5'),
			('6'),
			('7'),
			('8'),
			('9'),
			(' ')
		;

		SELECT
			@i = 0,
			@c = LEN(@strText) + 1
		;

		--SELECT * FROM @validTable

		WHILE @c > 0 BEGIN

			/*
			SELECT
				@c AS [C]
				,@result AS [Res]
				,SUBSTRING(@strText, @c - 1, 1)
				,ISNULL([VT].[Char], '')
			FROM
				@validTable [VT]
			WHERE
				(SUBSTRING(@strText, @c - 1, 1) COLLATE Latin1_General_CS_AS) = ([VT].[Char] COLLATE Latin1_General_CS_AS)
			;
			*/

			SELECT
				@result = ISNULL([VT].[Char], '') + @result
			FROM
				@validTable [VT]
			WHERE
				(SUBSTRING(@strText, @c - 1, 1) COLLATE Latin1_General_CS_AS) = ([VT].[Char] COLLATE Latin1_General_CS_AS)
		
			SELECT
				@c = @c - 1	
			;
		END
	
		/*
		---------------------
		SELECT
			@strText AS [IN]
			,@result AS [OUT]
		---------------------
		*/

		-- RETURN @strText
	END
	
	RETURN @result

END

