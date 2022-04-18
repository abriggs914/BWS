USE BWSdb
GO
--DECLARE @b AS NVARCHAR(6);
--DECLARE @c AS NVARCHAR(4);
----SET @b = 'Main';
--SET @b = 'Dome';
----SET @b = 'Finish';
----SET @b = 'Tire';
--SET @c = 5648;
----SELECT * FROM [SecurityV1]

ALTER PROCEDURE [dbo].[sp_SecurityCheckValidCodeV1] 
	@b AS NVARCHAR(MAX),
	@c AS NVARCHAR(4)
AS BEGIN

	DECLARE @buildings AS TABLE([ROW#] INT, [B] NVARCHAR(MAX))
	INSERT INTO @buildings SELECT * FROM [BWSdb].[dbo].[split_string_idx](@b, ';')

	DECLARE @Src AS TABLE ([SecurityID] INT, [EmployeeID] INT, [Code] NVARCHAR(4), [A] INT, [A1] INT, [A2] INT, [A3] INT, [A4] INT, [Main] INT, [Finish] INT, [Tire] INT, [Dome] INT, [Active] BIT);
	INSERT INTO @Src
	SELECT * FROM [SecurityV1] WHERE 0 < (
		CASE WHEN @b = 'Main'
			THEN (
				CASE WHEN [Main] = 1
					THEN 1
					ELSE 0
				END)
			WHEN @b = 'Dome'
			THEN (
				CASE WHEN [Dome] = 1
					THEN 1
					ELSE 0
				END)
			WHEN @b = 'Finish'
			THEN (
				CASE WHEN [Finish] = 1
					THEN 1
					ELSE 0
				END)
			WHEN @b = 'Tire'
			THEN (
				CASE WHEN [Tire] = 1
					THEN 1
					ELSE 0
				END)
			ELSE 0
		END)

	--SELECT * FROM @Src
	SELECT (CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END) AS [CodeAvailable?] FROM @Src WHERE [Code] = @c
END

