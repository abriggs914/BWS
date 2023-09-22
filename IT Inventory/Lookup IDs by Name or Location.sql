USE BWSdb
GO


DECLARE @user NVARCHAR(MAX) = 'Avery Briggs';
--SELECT @user = 'James Crawford';
--SELECT @user = 'Server Room';
--SELECT @user = 'Avery''s Office';
--SELECT @user = 'Avery';
--SELECT @user = 'James'' Office';
--SELECT @user = 'James';
SELECT @user = 'Jamie';
--SELECT @user = 'Michele';
--SELECT @user = 'Caleb R';
DECLARE @custID AS INT;
DECLARE @persID AS INT;
DECLARE @locID AS INT;
DECLARE @persLoc AS BIT;

SELECT 'IT Personnel' AS [T], * 
FROM [IT Personnel] 
WHERE LOWER([Name]) LIKE '%' + LOWER(@user) + '%';

SELECT 'ITR Customers' AS [T], * 
FROM [ITR Customers] 
WHERE LOWER([Name]) LIKE '%' + LOWER(@user) + '%';

SELECT 'ITI Locations' AS [T], * 
FROM [ITI Locations] AS [L] 
FULL OUTER JOIN [ITR Customers] AS [C] 
ON [C].[CustomerID] = [L].[EmployeeAssigned] 
WHERE (LOWER([C].[Name]) LIKE '%' + LOWER(@user) + '%') 
	OR (LOWER([L].[Description]) LIKE '%' + LOWER(@user) + '%');


SELECT
	@custID = [C].[CustomerID]
	,@persID = [P].[ITPersonID#]
	,@locID = [L].[ID]
	,@persLoc = (CASE WHEN [C].[CustomerID] IS NOT NULL THEN 1 ELSE 0 END)
FROM
	[ITI Locations] AS [L]
FULL OUTER JOIN
	[ITR Customers] AS [C]
ON
	[C].[CustomerID] = [L].[EmployeeAssigned]
FULL OUTER JOIN
	[IT Personnel] AS [P]
ON
	[C].[CustomerID] = [P].[ITRCustomerID]
WHERE
	LOWER([C].[Name]) LIKE '%' + LOWER(@user) + '%'
	OR LOWER([L].[Description]) LIKE '%' + LOWER(@user) + '%'
;

SELECT
	'H' AS [T]
	,[C].[CustomerID]
	,[P].[ITPersonID#]
	,[L].[ID]
	,(CASE WHEN [C].[CustomerID] IS NOT NULL THEN 1 ELSE 0 END)
FROM
	[ITR Customers] AS [C]
FULL OUTER JOIN
	[IT Personnel] AS [P]
ON
	[C].[CustomerID] = [P].[ITRCustomerID]
FULL OUTER JOIN
	[ITI Locations] AS [L]
ON
	[C].[CustomerID] = [L].[EmployeeAssigned]
WHERE
	LOWER([C].[Name]) LIKE '%' + LOWER(@user) + '%'
	OR LOWER([L].[Name]) LIKE '%' + LOWER(@user) + '%'
;

SELECT 'I' AS [T], * 
FROM [ITI Locations] AS [L] 
FULL OUTER JOIN [ITR Customers] AS [C]
ON [C].[CustomerID] = [L].[EmployeeAssigned] 
FULL OUTER JOIN	[IT Personnel] AS [P]
ON [C].[CustomerID] = [P].[ITRCustomerID]
WHERE (LOWER([C].[Name]) LIKE '%' + LOWER(@user) + '%') 
	OR (LOWER([L].[Description]) LIKE '%' + LOWER(@user) + '%');

SELECT
	@user AS [@user]
	,@custID AS [@custID]
	,@persID AS [@persID]
	,@locID AS [@locID]
	,@persLoc AS [@Pers_Loc]
;
