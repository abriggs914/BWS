
USE BWSdb
GO

	-- Use this function to quickly pull the right-most numbers from existing serial numbers.
	-- Ensures only numerical digits.

ALTER FUNCTION [dbo].[TrailingDigits](@wordIn VARCHAR(MAX)) RETURNS VARCHAR(MAX)
AS
BEGIN
	/*
	DECLARE @wordIn AS NVARCHAR(MAX);

	SELECT @wordIn = 'This is a demo word see if you can pick only numbers from the right only upto and including the number. 7'  -- <7>
	SELECT @wordIn = 'This is a demo word see if you can pick the string from the number onward. 7@ E'  -- <NULL>
	SELECT @wordIn = '2B9B63535KA001286'  -- <001286>
	*/

	DECLARE @ns AS TABLE ([ID] INT IDENTITY(1, 1), [Num] NVARCHAR(1))
	INSERT INTO @ns ([Num]) VALUES ('0'), ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('8'), ('9')

	DECLARE @reverseWord AS NVARCHAR(MAX);
	SELECT @reverseWord = REVERSE(@wordIn);

	DECLARE @a AS INTEGER;
	DECLARE @i AS INTEGER;
	DECLARE @c AS INTEGER;
	DECLARE @letter AS NVARCHAR(1);

	SELECT @i = 1;
	SELECT @c = LEN(@reverseWord);WHILE @i < @c + 1 BEGIN 
		SELECT @letter = SUBSTRING(@reverseWord, @i, 1);
		IF @letter NOT IN (SELECT [Num] FROM @ns) BEGIN
			SELECT @a = (CASE WHEN @i = 1 THEN NULL ELSE @i - 1 END);
			SELECT @i = @c + 1;
		END
		ELSE BEGIN
			SELECT @a = @i;
			SELECT @i = @i + 1;
		END
	END

	--RETURN (CASE WHEN @a IS NULL THEN '' ELSE RIGHT(@wordIn, @a - 1) END)
	RETURN (CASE WHEN @a IS NULL THEN '' ELSE RIGHT(@wordIn, (CASE WHEN @a = 1 THEN 1 ELSE @a END)) END)
END