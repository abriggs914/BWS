USE BWSdb
GO

-- Get Table of Dealership addresses
SELECT [COMPANY NAME], [ADDRESS], [CITY], [Province], [Postal CODE] FROM [Dealers] WITH (NOLOCK) ORDER BY [COMPANY NAME]

SELECT * FROM dtQEOrderOptions WHERE [Description] LIKE '%full%' and  [Description] LIKE '%width%'
