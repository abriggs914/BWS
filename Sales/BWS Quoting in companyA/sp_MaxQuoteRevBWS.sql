/****** Script for SelectTopNRows command from SSMS  ******/

ALTER PROCEDURE [sp_MaxQuoteRevBWS]

	@q AS NVARCHAR(5),
	@w AS NVARCHAR(8)=NULL,
	@s AS NVARCHAR(17)=NULL
AS
BEGIN

--DECLARE @q AS NVARCHAR(5);
--DECLARE @w AS NVARCHAR(8);
--DECLARE @s AS NVARCHAR(17);

--SELECT @q = '28370';

	SELECT [QuoteRev#]
		  ,[Rev#]
		  ,[RevDate]
		  ,[Quote#]
		  ,[WO#]
		  ,[Serial Number]
	  FROM [BWSdb].[dbo].[Orders_RevHistory]
	  WHERE
		(CASE WHEN @q IS NULL THEN 
			(CASE WHEN @w IS NULL THEN
				(CASE WHEN @s IS NULL THEN 
					1
				ELSE 
					(CASE WHEN [Serial Number] LIKE '%' + @s + '%' THEN 
						1
					ELSE 
						0
					END) 
				END)
			ELSE
				(CASE WHEN [WO#] LIKE '%' + @w + '%' THEN
					1
				ELSE 
					0
				END)
			END)
		ELSE 
			(CASE WHEN [Quote#] LIKE '%' + @q + '%' THEN
				1
			ELSE
				0
			END)
		END) = 1
END