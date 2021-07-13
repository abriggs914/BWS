USE uniPoint_Test
GO

SELECT * FROM [PT_CustomerService]
SELECT * FROM [PT_Attach]
SELECT * FROM [PT_History] WHERE [ObjectType] LIKE '%Equip%' ORDER BY [ActionDate], [ObjectKey]