use BWSdb
go

BEGIN TRAN;

-- 2024-11-25 1442 - James Crawford - initial commit.
-- 2024-11-26 0849 - James Crawford - Adjusted bug with [Budget Std V2] insert statement. Was copying @compidfrom value, instead of @compidto
-- 2025-03-19 1902 - Avery Briggs - Added support to change the model name

declare @modelnoFrom nvarchar(255) = 'AED4X',
		@modelnoTo nvarchar(255) = 'AWF4X',
		@compidfrom int = 1,
		@compidto int = 0

	IF @modelnoFrom <> @modelnoTo BEGIN

	/*
    -- Remove model info from destination company
    DELETE from ProductsV2
    WHERE
        [Model No] = @modelno
        and CompanyID = @compidto

    DELETE from [Budget Std V2]
    WHERE
        [Model No] = @modelno
        and CompanyID = @compidto
	*/

    -- Copy model info over
    INSERT INTO ProductsV2 WITH (tablock) (
        [Class]
      ,[Proposed]
      ,[Non-Current]
      ,[Model]
      ,[Model No]
      ,[Top Level Part# (SYSPRO)]
      ,[Grouping]
      ,[Start Date]
      ,[End Date]
      ,[Price]
      ,[Weight]
      ,[Make]
      ,[NVIS]
      ,[Promo Drawing]
      ,[Width]
      ,[Spread]
      ,[Deck Length]
      ,[Days]
      ,[GN]
      ,[Paint]
      ,[Finish]
      ,[S/NL1]
      ,[S/NL2]
      ,[S/NT1]
      ,[S/NT2]
      ,[S/NAxles]
      ,[Selection]
      ,[EffComDate]
      ,[ComRate]
      ,[LastCostUpdate]
      ,[LCUInitials]
      ,[QR_Discount1]
      ,[QR_Discount2]
      ,[QR_Discount3]
      ,[QR_ExpectedMargin]
      ,[tmpProductsV2ClassesID]
      ,[QRUS_Discount1]
      ,[QRUS_Discount2]
      ,[QRUS_Discount3]
      ,[QRUS_ExpectedMargin]
      ,[US Price]
      ,[Customer]
      ,[Top Level Part# (SYSPRO 8)]
      ,[Promo Drawing V2]
      ,[CompanyID]
      ,[DateCreated]
    )
    select [Class]
      ,[Proposed]
      ,[Non-Current]
      ,[Model]
      ,@modelnoTo
      ,[Top Level Part# (SYSPRO)]
      ,[Grouping]
      ,[Start Date]
      ,[End Date]
      ,[Price]
      ,[Weight]
      ,[Make]
      ,[NVIS]
      ,[Promo Drawing]
      ,[Width]
      ,[Spread]
      ,[Deck Length]
      ,[Days]
      ,[GN]
      ,[Paint]
      ,[Finish]
      ,[S/NL1]
      ,[S/NL2]
      ,[S/NT1]
      ,[S/NT2]
      ,[S/NAxles]
      ,[Selection]
      ,[EffComDate]
      ,[ComRate]
      ,[LastCostUpdate]
      ,[LCUInitials]
      ,[QR_Discount1]
      ,[QR_Discount2]
      ,[QR_Discount3]
      ,[QR_ExpectedMargin]
      ,[tmpProductsV2ClassesID]
      ,[QRUS_Discount1]
      ,[QRUS_Discount2]
      ,[QRUS_Discount3]
      ,[QRUS_ExpectedMargin]
      ,[US Price]
      ,[Customer]
      ,[Top Level Part# (SYSPRO 8)]
      ,[Promo Drawing V2]
      ,@compidto
      ,[DateCreated]
    FROM    
        ProductsV2
    WHERE
        [Model No] = @modelnoFrom
        and CompanyID = @compidfrom

    INSERT INTO [Budget Std V2] with (tablock) (
        [Model No]
        ,[Top Level Part# (SYSPRO)]
        ,[Std Date]
        ,[COGS]
        ,[Labour Cost]
        ,[Made In Material]
        ,[Bought Out Material]
        ,[Machine Shop]
        ,[Axles]
        ,[Stakes/Bunks]
        ,[Beam]
        ,[GNK]
        ,[Parts]
        ,[Subs]
        ,[Line]
        ,[Step 1]
        ,[Step 2]
        ,[Blast]
        ,[Paint]
        ,[Finish]
        ,[Finish - GNK]
        ,[Final Assembly]
        ,[Tire Assembly]
        ,[Shipping]
        ,[Margins Base]
        ,[Margins Options]
        ,[Top Level Part# (SYSPRO 8)]
        ,[CompanyID]
        ,[Operation1Hours]
        ,[Operation2Hours]
        ,[Operation3Hours]
        ,[Operation4Hours]
        ,[Operation5Hours]
        ,[Operation6Hours]
        ,[Operation7Hours]
        ,[Operation8Hours]
        ,[Operation9Hours]
        ,[Operation10Hours]
        ,[Operation11Hours]
        ,[Operation12Hours]
        ,[Operation13Hours]
        ,[Operation14Hours]
        ,[Operation15Hours]
        ,[Operation16Hours]
        ,[Operation17Hours]
        ,[Galvanized]
        )
    SELECT 
	  @modelnoTo
      ,[Top Level Part# (SYSPRO)]
      ,[Std Date]
      ,[COGS]
      ,[Labour Cost]
      ,[Made In Material]
      ,[Bought Out Material]
      ,[Machine Shop]
      ,[Axles]
      ,[Stakes/Bunks]
      ,[Beam]
      ,[GNK]
      ,[Parts]
      ,[Subs]
      ,[Line]
      ,[Step 1]
      ,[Step 2]
      ,[Blast]
      ,[Paint]
      ,[Finish]
      ,[Finish - GNK]
      ,[Final Assembly]
      ,[Tire Assembly]
      ,[Shipping]
      ,[Margins Base]
      ,[Margins Options]
      ,[Top Level Part# (SYSPRO 8)]
      ,@compidto
      ,[Operation1Hours]
      ,[Operation2Hours]
      ,[Operation3Hours]
      ,[Operation4Hours]
      ,[Operation5Hours]
      ,[Operation6Hours]
      ,[Operation7Hours]
      ,[Operation8Hours]
      ,[Operation9Hours]
      ,[Operation10Hours]
      ,[Operation11Hours]
      ,[Operation12Hours]
      ,[Operation13Hours]
      ,[Operation14Hours]
      ,[Operation15Hours]
      ,[Operation16Hours]
      ,[Operation17Hours]
      ,[Galvanized]
    FROM
        [Budget Std V2]
    WHERE
        [Model No] = @modelnoFrom
        and CompanyID = @compidfrom
    

    -- Copy into legacy BWS table as well, if copying from Stargate
    if @compidto = 0 and @compidfrom = 1
        BEGIN
			/*
            delete from Products
            WHERE
                [Model No] = @modelnoFrom

            delete from [Budget Std]
            WHERE
                [Model No] = @modelnoFrom
			*/

            INSERT into Products with (tablock) (
                [Class]
                ,[Proposed]
                ,[Non-Current]
                ,[Model]
                ,[Model No]
                ,[Top Level Part# (SYSPRO)]
                ,[Grouping]
                ,[Start Date]
                ,[End Date]
                ,[Price]
                ,[Weight]
                ,[Make]
                ,[NVIS]
                ,[Promo Drawing]
                ,[Width]
                ,[Spread]
                ,[Deck Length]
                ,[Days]
                ,[GN]
                ,[Paint]
                ,[Finish]
                ,[S/NL1]
                ,[S/NL2]
                ,[S/NT1]
                ,[S/NT2]
                ,[S/NAxles]
                ,[Selection]
                ,[EffComDate]
                ,[ComRate]
                ,[LastCostUpdate]
                ,[LCUInitials]
                ,[QR_Discount1]
                ,[QR_Discount2]
                ,[QR_Discount3]
                ,[QR_ExpectedMargin]
                ,[QRUS_Discount1]
                ,[QRUS_Discount2]
                ,[QRUS_Discount3]
                ,[QRUS_ExpectedMargin]
                ,[US Price]
                ,[Customer]
                ,[Top Level Part# (SYSPRO 8)]
                ,[Promo Drawing V2]
                ,[CompanyID]
                ,[DateCreated]
            )
            select [Class]
                ,[Proposed]
                ,[Non-Current]
                ,[Model]
                ,@modelnoTo
                ,[Top Level Part# (SYSPRO)]
                ,[Grouping]
                ,[Start Date]
                ,[End Date]
                ,[Price]
                ,[Weight]
                ,[Make]
                ,[NVIS]
                ,[Promo Drawing]
                ,[Width]
                ,[Spread]
                ,[Deck Length]
                ,[Days]
                ,[GN]
                ,[Paint]
                ,[Finish]
                ,[S/NL1]
                ,[S/NL2]
                ,[S/NT1]
                ,[S/NT2]
                ,[S/NAxles]
                ,[Selection]
                ,[EffComDate]
                ,[ComRate]
                ,[LastCostUpdate]
                ,[LCUInitials]
                ,[QR_Discount1]
                ,[QR_Discount2]
                ,[QR_Discount3]
                ,[QR_ExpectedMargin]
                ,[QRUS_Discount1]
                ,[QRUS_Discount2]
                ,[QRUS_Discount3]
                ,[QRUS_ExpectedMargin]
                ,[US Price]
                ,[Customer]
                ,[Top Level Part# (SYSPRO 8)]
                ,[Promo Drawing V2]
                ,@compidto
                ,[DateCreated]
            FROM
                ProductsV2
            WHERE
                [Model No] = @modelnoFrom
                and CompanyID = @compidfrom

           INSERT into [Budget Std] with (tablock) (
                [Model No]
                ,[Top Level Part# (SYSPRO)]
                ,[Std Date]
                ,[COGS]
                ,[Labour Cost]
                ,[Made In Material]
                ,[Bought Out Material]
                ,[Machine Shop]
                ,[Axles]
                ,[Stakes/Bunks]
                ,[Beam]
                ,[GNK]
                ,[Parts]
                ,[Subs]
                ,[Line]
                ,[Step 1]
                ,[Step 2]
                ,[Blast]
                ,[Paint]
                ,[Finish]
                ,[Finish - GNK]
                ,[Final Assembly]
                ,[Tire Assembly]
                ,[Shipping]
                ,[Margins Base]
                ,[Margins Options]
                ,[Top Level Part# (SYSPRO 8)]
                ,[Galvanized]
            )
            select @modelnoTo
                ,[Budget Std V2].[Top Level Part# (SYSPRO)]
                ,[Budget Std V2].[Std Date]
                ,[Budget Std V2].[COGS]
                ,[Budget Std V2].[Labour Cost]
                ,[Budget Std V2].[Made In Material]
                ,[Budget Std V2].[Bought Out Material]
                ,[Budget Std V2].[Machine Shop]
                ,[Budget Std V2].[Axles]
                ,[Budget Std V2].[Stakes/Bunks]
                ,[Budget Std V2].[Beam]
                ,[Budget Std V2].[GNK]
                ,[Budget Std V2].[Parts]
                ,[Budget Std V2].[Subs]
                ,[Budget Std V2].[Line]
                ,[Budget Std V2].[Step 1]
                ,[Budget Std V2].[Step 2]
                ,[Budget Std V2].[Blast]
                ,[Budget Std V2].[Paint]
                ,[Budget Std V2].[Finish]
                ,[Budget Std V2].[Finish - GNK]
                ,[Budget Std V2].[Final Assembly]
                ,[Budget Std V2].[Tire Assembly]
                ,[Budget Std V2].[Shipping]
                ,[Budget Std V2].[Margins Base]
                ,[Budget Std V2].[Margins Options]
                ,[Budget Std V2].[Top Level Part# (SYSPRO 8)]
                ,[Budget Std V2].[Galvanized]
            FROM
                [Budget Std V2]
            inner JOIN
                ProductsV2
            ON
                [Budget Std V2].[Model No] = [ProductsV2].[Model No]
                and [Budget Std V2].[CompanyID] = [ProductsV2].[CompanyID]
            WHERE
                [Budget Std V2].[Model No] = @modelnoFrom
                and [Budget Std V2].CompanyID = @compidfrom
        end

    -- Verify copy
    select 'Products (BWS)' as [SelectStatus]
        , *
    FROM
        Products with (nolock)
    WHERE
        [Model No] = @modelnoTo

    select 'ProductsV2 (@compidfrom)' as [SelectStatus]
        , *
    FROM
        ProductsV2 with (nolock)
    WHERE
        [Model No] = @modelnoFrom
        and CompanyID = @compidfrom

    select 'ProductsV2 (@compidto)' as [SelectStatus]
        , *
    FROM
        ProductsV2 with (nolock)
    WHERE
        [Model No] = @modelnoTo
        and CompanyID = @compidto

    select 'Budget Std (BWS)' as [SelectStatus]
        , *
    FROM
        [Budget Std] with (nolock)
    WHERE
        [Model No] = @modelnoTo
    
    select 'Budget Std V2 (@compidfrom)' as [SelectStatus]
        , *
    FROM
        [Budget Std V2] with (nolock)
    WHERE
        [Model No] = @modelnoFrom
        and CompanyID = @compidfrom
    
    select 'Budget Std V2 (@compidto)' as [SelectStatus]
        , *
    FROM
        [Budget Std V2] with (nolock)
    WHERE
        [Model No] = @modelnoTo
        and CompanyID = @compidto

		
	END

ROLLBACK;
COMMIT;

		