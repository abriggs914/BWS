USE BWSdb
GO


CREATE VIEW [v_ITRCustomerBirthdays] AS
	SELECT
		[CustomerID]
		,[Name]
		,[Department]
		,[Company]
		,[Email]
		,[WorkPhone]
		,[WorkExtension]
		,[CellPhone]
		,[HomePhone]
		,[Active]
		,[DateAdded]
		,[LastActive]
		,[WorkPhoneLastActive]
		,[WorkExtensionLastActive]
		,[CellPhoneLastActive]
		,[HomePhoneLastActive]
		,[WindowsUser]
		,[BirthYear]
		,[BirthMonth]
		,[BirthDay]
		,(CASE
			WHEN [BirthYear] IS NULL THEN
				(CASE 
					WHEN [BirthMonth] IS NOT NULL AND [BirthDay] IS NOT NULL THEN
						CAST(CAST(YEAR(GETDATE()) AS NVARCHAR(4))
						+ '-' + RIGHT('00' + CAST([BirthMonth] AS NVARCHAR(2)), 2)
						+ '-' + RIGHT('00' + CAST([BirthDay] AS NVARCHAR(2)), 2) AS DATETIME)
					ELSE
						NULL
					END)
			ELSE
				CAST(CAST([BirthYear] AS NVARCHAR(4))
				+ '-' + RIGHT('00' + CAST([BirthMonth] AS NVARCHAR(2)), 2)
				+ '-' + RIGHT('00' + CAST([BirthDay] AS NVARCHAR(2)), 2) AS DATETIME)
		END) AS [BirthCalDay]
	FROM	
		[BWSdb].[dbo].[ITR Customers]
--	ORDER BY
--		[BirthCalDay]
GO