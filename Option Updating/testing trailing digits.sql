SELECT SUBSTRING('hey there', 1, 1)

SELECT [BWSdb].[dbo].[ToProperCase]('this is a string')

SELECT [BWSdb].[dbo].[TrailingDigits]('7')

DECLARE @tests AS TABLE ([ID] INT IDENTITY(1, 1), [Args] NVARCHAR(MAX), [Desired] NVARCHAR(MAX), [Got] NVARCHAR(MAX), [Right] NVARCHAR(MAX))
INSERT INTO @tests ([Args], [Desired]) VALUES
('This is a demo word see if you can pick only numbers from the right only upto and including the number. 7', '7')
, ('This is a demo word see if you can pick the string from the number onward. 7@ E', '')
, ('2B9B63535KA001286', '001286')
, ('7', '7')
, ('', '')
, (NULL, '')
, ('45  ', '')
, ('  45', '45')


UPDATE
	@tests
SET
	[Got] = [BWSdb].[dbo].[TrailingDigits]([Args])

UPDATE 
	@tests
SET
	[Right] = CASE WHEN [Desired] = [Got] THEN 'Y' ELSE 'N' END


SELECT * FROM @tests


SELECT CAST('00125' AS INT) AS [i]