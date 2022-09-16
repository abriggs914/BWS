USE uniPoint_Live
GO

--SET STATISTICS TIME ON;
SET CONCAT_NULL_YIELDS_NULL OFF;


SELECT 'hey' + NULL AS [x]

SELECT * FROM [PT_Equip_Usage];
SELECT * FROM [uniPoint_Live].[dbo].[PT_Employee];
SELECT * FROM [uniPoint_Live].[dbo].[PT_Employee_Extended];
SELECT * FROM [uniPoint_Live].[dbo].[PT_Company];