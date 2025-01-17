/*
INSERT INTO [CompanyH].[dbo].[Employees]
           ([Active]
           ,[CompanyID]
           ,[SalaryTypeID]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[FullName]
           ,[Title]
           ,[Position]
           ,[DepartmentID]
           ,[DateOfBirth]
           ,[DateHired]
           ,[DateTerminated]
           ,[ReHire]
           ,[Gender]
           ,[Address]
           ,[City]
           ,[Province]
           ,[Postal]
           ,[HomePhone]
           ,[CellPhone]
           ,[ADPID]
           ,[ShiftID]
           ,[HealthBenefitID]
           ,[DentalBenefitID]
           ,[BWSdbCustomerID])
		   */
     SELECT
           [I].[Active]
		   ,(CASE
				WHEN [I].[Company] = 'BWS' THEN 0
				WHEN [I].[Company] = 'STARGATE' THEN 1
				WHEN [I].[Company] = 'LEWIS' THEN 2
				WHEN [I].[Company] = 'HUGO' THEN 3
				ELSE NULL
			) AS [CompanyID]
           ,<SalaryTypeID, int,>



		   
SELECT
	[Name]
	,[FirstName]
	,[LastName]
	,(CASE WHEN ISNULL([MiddleName], '') = '' THEN NULL ELSE [MiddleName] END) AS [MiddleName]
FROM (
	SELECT
		[I].[Name]
		,LTRIM(RTRIM(LEFT([I].[Name], CHARINDEX(' ', [I].[Name])))) AS [FirstName]
		,LTRIM(RTRIM(RIGHT([I].[Name], CHARINDEX(' ', REVERSE([I].[Name]))))) AS [LastName]
		,LTRIM(RTRIM(REPLACE(REPLACE([I].[Name], LTRIM(RTRIM(LEFT([I].[Name], CHARINDEX(' ', [I].[Name])))), ''), LTRIM(RTRIM(RIGHT([I].[Name], CHARINDEX(' ', REVERSE([I].[Name]))))), ''))) AS [MiddleName]
	FROM 
		[BWSdb].[dbo].[ITR Customers] AS [I]
	WHERE
		([I].[IsAPerson] = 1)
		AND ([I].[Active] = 1)
) AS [Src]



           LEFT([I].[Name], CHARINDEX(' ', [I].[Name]))
           ,<MiddleName, nvarchar(255),>
           ,<LastName, nvarchar(255),>
           ,<FullName, nvarchar(765),>
           ,<Title, nvarchar(255),>
           ,<Position, nvarchar(255),>
           ,<DepartmentID, int,>
           ,<DateOfBirth, datetime,>
           ,<DateHired, datetime,>
           ,<DateTerminated, datetime,>
           ,<ReHire, bit,>
           ,<Gender, nvarchar(3),>
           ,<Address, nvarchar(500),>
           ,<City, nvarchar(255),>
           ,<Province, nvarchar(255),>
           ,<Postal, nvarchar(50),>
           ,<HomePhone, nvarchar(50),>
           ,<CellPhone, nvarchar(50),>
           ,<ADPID, int,>
           ,<ShiftID, int,>
           ,<HealthBenefitID, int,>
           ,<DentalBenefitID, int,>
           ,<BWSdbCustomerID, int,>
		FROM 
			[BWSdb].[dbo].[ITR Customers] AS [I]
SELECT
	[CustomerID]
FROM
	[BWSdb].[dbo].[ITR Customers]