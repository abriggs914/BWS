SELECT * FROM [dbo].split_string('avery, is cool, and awesome,', ',')
SELECT * FROM [dbo].[split_string_idx]('avery, is cool, and awesome,', ' ')
SELECT TOP 1 * FROM [dbo].split_string_idx('avery, is cool, and awesome,', ' ') ORDER BY [Idx] DESC
SELECT MAX([Idx]), MAX([splited_data]) FROM [dbo].split_string_idx('avery, is cool, and awesome,', ' ')