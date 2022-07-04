USE BWSdb
GO


-- List similar ITI Items using all columns to check.
-- Use this SP to determine if there are any identical items in the [ITI Item]s table.

ALTER PROCEDURE [dbo].[sp_ITI_ListSimilarItems]
	@name NVARCHAR(MAX)=NULL,
	@desc NVARCHAR(MAX)=NULL,
	@actv BIT=NULL,
	@cond INT=NULL,
	@stat INT=NULL,
	@type INT=NULL,
	@subt INT=NULL,
	@date DATETIME=NULL
AS
BEGIN


---------- TESTING -----------

--DECLARE @name AS NVARCHAR(MAX);
--DECLARE @desc AS NVARCHAR(MAX);
--DECLARE @actv as BIT;
--DECLARE @cond as INT;
--DECLARE @stat as INT;
--DECLARE @type as INT;
--DECLARE @subt as INT;
--DECLARE @date as DATETIME;

----SET @name = '17" Monitor';
----SET @desc = '17" Monitor';
----SET @actv = 1;
----SET @cond = 3;
----SET @stat = 3;
----SET @type = 3;
--SET @subt = 10;
----SET @date = '2022-07-04 2:08:32 PM'

----SET @name = NULL;

---------- TESTING -----------

	SELECT
		*
	FROM
		[ITI Item]
	WHERE 0 != (
			(CASE 
				WHEN @name IS NULL THEN 1
				WHEN LOWER(LTRIM(RTRIM([Name]))) = LOWER(LTRIM(RTRIM(@name))) THEN 1
				ELSE 0
			END)
			*
			(CASE 
				WHEN @desc IS NULL THEN 1
				WHEN LOWER(LTRIM(RTRIM([Description]))) = LOWER(LTRIM(RTRIM(@desc))) THEN 1
				ELSE 0
			END)
			*
			(CASE 
				WHEN @actv IS NULL THEN 1
				WHEN [IsActive] = @actv THEN 1
				ELSE 0
			END)
			*
			(CASE 
				WHEN @cond IS NULL THEN 1
				WHEN [Condition] = @cond THEN 1
				ELSE 0
			END)
			*
			(CASE 
				WHEN @stat IS NULL THEN 1
				WHEN [Status] = @stat THEN 1
				ELSE 0
			END)
			*
			(CASE 
				WHEN @type IS NULL THEN 1
				WHEN [Type] = @type THEN 1
				ELSE 0
			END)
			*
			(CASE 
				WHEN @subt IS NULL THEN 1
				WHEN [SubType] = @subt THEN 1
				ELSE 0
			END)
			*
			(CASE 
				WHEN @date IS NULL THEN 1
				WHEN [DateCreated] = @date THEN 1
				ELSE 0
			END)
		)


END