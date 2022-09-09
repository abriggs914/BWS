import re


SQL_ALL_DATED_STG_UNITS = {
    "sql": re.sub("\s+", ' ', """
        SELECT
            B.[ProdSchedV2ID#]
            ,B.[SGQuote]
            ,B.[WO#]
            ,B.[JobStartDate]
            ,B.[JobFinishDate]
            ,B.[dtprodschedv2ts]
            ,B.[JobStartLine]
            ,B.[HideFromProdInput]
            ,B.[InputField1]
            ,B.[InputField2]
            ,B.[ApplyUpdate]
            ,B.[ApplyUpdateUser]
      
            , A.[ProdSchedID#]
            ,A.[SGQuote]
            ,A.[WO#]
            ,A.[InputField1]
            ,A.[InputField2]
            ,A.[Beam Line]
            ,A.[Beam Date]
            ,A.[GN Line]
            ,A.[GN Date]
            ,A.[WO Line 1]
            ,A.[Prod Date 1]
            ,A.[WO Line 2]
            ,A.[Prod Date 2]
            ,A.[Other]
            ,A.[Other Line]
            ,A.[Other Date]
            ,A.[HideFromProdInput]
            ,A.[Step1SYSPROBudget]
            ,A.[Step2SYSPROBudget]
            ,A.[dtprodschedts]
            ,A.[ApplyUpdate]
            ,A.[ApplyUpdateUser]
            ,A.[Slot#]
            ,A.[Slot/Quote]
            ,A.[Slot Approved]
            ,A.[Prod On]
            ,A.[Prod On Time]
            ,A.[Prod Off]
            ,A.[Prod Off Time]
            ,A.[Prod PM]
            ,A.[Prod Complete]
            ,A.[Prod2 On]
            ,A.[Prod2 On Time]
            ,A.[Prod2 Off]
            ,A.[Prod2 Off Time]
            ,A.[Prod2 PM]
            ,A.[Prod2 Complete]
            ,A.[Prod Instructions]
            ,A.[Beam On]
            ,A.[Beam Off]
            ,A.[Beam Complete]
            ,A.[Beam PM]
            ,A.[Beam Instructions]
            ,A.[GN On]
            ,A.[GN Off]
            ,A.[GN Complete]
            ,A.[GN PM]
            ,A.[GN Instructions]
            ,A.[Axle]
            ,A.[Axle On]
            ,A.[Axle Off]
            ,A.[Axle Complete]
            ,A.[Axle PM]
            ,A.[Axle Instructions]
            ,A.[Other On]
            ,A.[Other On Time]
            ,A.[Other Off]
            ,A.[Other Off Time]
            ,A.[Other Complete]
            ,A.[Other PM]
            ,A.[Other Instructions]
            ,A.[Stargate WO#]
            
            , O. [OrderID]
            ,O.[SGQuote]
            ,O.[Quote Date]
            ,O.[Order Date]
            ,O.[WO#]
            ,O.[Sales Order#]
            ,O.[Model No]
            ,O.[Width]
            ,O.[Spread]
            ,O.[DealerID]
            ,O.[Sale PersonID]
            ,O.[Price]
            ,O.[Prom Drawing]
            ,O.[Special Instructions]
            ,O.[Date Declined]
            ,O.[Decline/Rejected]
            ,O.[Serial Number]
            ,O.[Available Date]
            ,O.[Delivery Date]
            ,O.[Requested Delivery Date]
            ,O.[Finish Date]
            ,O.[Purchase Order]
            ,O.[PO Date]
            ,O.[PayID]
            ,O.[Volume Discount]
            ,O.[Program Discount]
            ,O.[Discount1_Name]
            ,O.[Discount1_Type]
            ,O.[Discount1]
            ,O.[Discount2_Name]
            ,O.[Discount2_Type]
            ,O.[Discount2]
            ,O.[Discount3_Name]
            ,O.[Discount3_Type]
            ,O.[Discount3]
            ,O.[Est Pro Date]
            ,O.[Notes]
            ,O.[EngNotes]
            ,O.[CarrierID]
            ,O.[CustID]
            ,O.[US Sale]
            ,O.[Shipped Date]
            ,O.[GL Override Date]
            ,O.[FE Rate]
            ,O.[PDD]
            ,O.[Deck Length]
            ,O.[Invoice #]
            ,O.[Date Registered]
            ,O.[Date In Service]
            ,O.[Invoice Date]
            ,O.[Date Requested]
            ,O.[GVWR]
            ,O.[Tare]
            ,O.[Selection]
            ,O.[Warranty]
            ,O.[BWSPaid]
            ,O.[BWSPaidDate]
            ,O.[CommPaid]
            ,O.[CommPaidDate]
            ,O.[ts_timestamp]
            ,O.[ModifiedBy]
            ,O.[Lead Date]
            ,O.[Lead Source]
            ,O.[LeadID]
            ,O.[DealerBranchID]
            ,O.[DealerSalesPersonID]
            ,O.[DataEntryCheck]
            ,O.[DataEntryUser]
            ,O.[FinishedGoodsDealerLocID]
            ,O.[WO Reviewed]
            ,O.[WO Review Date]
            ,O.[Follow Up Date]
            ,O.[MSOIsDifferent]
            ,O.[MSOLocID]
            ,O.[EstInvDateOverride]
            ,O.[Estimated Invoice Date]
            ,O.[AdditionalPricingInfo]
            ,O.[Slot#]
            ,O.[TempModel?]
            ,O.[HighRiskUnit]
            ,O.[EngNotes V2]
            ,O.[CompanyID]
            ,O.[Customer WO#]
            ,O.[PriceSecured]
            ,O.[DateSecured]
            ,O.[SecuredBy]
        FROM
            BWSdb.dbo.OrdersV2 AS O
        LEFT JOIN 
            dtProductionSchedule AS A
        ON
            A.SGQuote = O.SGQuote
        LEFT JOIN 
            dtProductionScheduleV2 AS B
        ON
            B.SGQuote = O.SGQuote
        WHERE
            B.JobFinishDate IS NOT NULL
        ORDER BY
            B.JobFinishDate
        ;        
    """),
    "database": "Stargatedb",
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0"
}


SQL_ALL_DATED_STG_UNITS_ALIAS = {
    "sql": re.sub("\s+", ' ', """
        SELECT
            B.*
            , A.*
            , O.*
        FROM
            BWSdb.dbo.OrdersV2 AS O
        LEFT JOIN 
            dtProductionSchedule AS A
        ON
            A.SGQuote = O.SGQuote
        LEFT JOIN 
            dtProductionScheduleV2 AS B
        ON
            B.SGQuote = O.SGQuote
        WHERE
            B.JobFinishDate IS NOT NULL
        ORDER BY
            B.JobFinishDate
        ;        
    """),
    "database": "Stargatedb",
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0"
}

SQL_ALL_STG_PROD_DAYS = {
    "sql": """SELECT * FROM [v_CalendarWorkDays] ORDER BY [CalendarDate] DESC""",
    "database": "SysproCompanyS",
    "uid": "SCSRS",
    "pwd": ""
}

SQL_ALL_DATED_STG_UNITS_TEST = {
    "sql": re.sub("\s+", ' ', """
        SELECT
            B.[ProdSchedV2ID#]
            ,B.[SGQuote]
            ,B.[WO#]
            ,B.[JobStartDate]
            ,B.[JobFinishDate]
            ,B.[dtprodschedv2ts]
            ,B.[JobStartLine]
            ,B.[HideFromProdInput]
            ,B.[InputField1]
            ,B.[InputField2]
            ,B.[ApplyUpdate]
            ,B.[ApplyUpdateUser]
      
            , A.[ProdSchedID#]
            ,A.[SGQuote]
            ,A.[WO#]
            ,A.[InputField1]
            ,A.[InputField2]
            ,A.[Beam Line]
            ,A.[Beam Date]
            ,A.[GN Line]
            ,A.[GN Date]
            ,A.[WO Line 1]
            ,A.[Prod Date 1]
            ,A.[WO Line 2]
            ,A.[Prod Date 2]
            ,A.[Other]
            ,A.[Other Line]
            ,A.[Other Date]
            ,A.[HideFromProdInput]
            ,A.[Step1SYSPROBudget]
            ,A.[Step2SYSPROBudget]
            ,A.[dtprodschedts]
            ,A.[ApplyUpdate]
            ,A.[ApplyUpdateUser]
            ,A.[Slot#]
            ,A.[Slot/Quote]
            ,A.[Slot Approved]
            ,A.[Prod On]
            ,A.[Prod On Time]
            ,A.[Prod Off]
            ,A.[Prod Off Time]
            ,A.[Prod PM]
            ,A.[Prod Complete]
            ,A.[Prod2 On]
            ,A.[Prod2 On Time]
            ,A.[Prod2 Off]
            ,A.[Prod2 Off Time]
            ,A.[Prod2 PM]
            ,A.[Prod2 Complete]
            ,A.[Prod Instructions]
            ,A.[Beam On]
            ,A.[Beam Off]
            ,A.[Beam Complete]
            ,A.[Beam PM]
            ,A.[Beam Instructions]
            ,A.[GN On]
            ,A.[GN Off]
            ,A.[GN Complete]
            ,A.[GN PM]
            ,A.[GN Instructions]
            ,A.[Axle]
            ,A.[Axle On]
            ,A.[Axle Off]
            ,A.[Axle Complete]
            ,A.[Axle PM]
            ,A.[Axle Instructions]
            ,A.[Other On]
            ,A.[Other On Time]
            ,A.[Other Off]
            ,A.[Other Off Time]
            ,A.[Other Complete]
            ,A.[Other PM]
            ,A.[Other Instructions]
            ,A.[Stargate WO#]
            
            , O. [OrderID]
            ,O.[SGQuote]
            ,O.[Quote Date]
            ,O.[Order Date]
            ,O.[WO#]
            ,O.[Sales Order#]
            ,O.[Model No]
            ,O.[Width]
            ,O.[Spread]
            ,O.[DealerID]
            ,O.[Sale PersonID]
            ,O.[Price]
            ,O.[Prom Drawing]
            ,O.[Special Instructions]
            ,O.[Date Declined]
            ,O.[Decline/Rejected]
            ,O.[Serial Number]
            ,O.[Available Date]
            ,O.[Delivery Date]
            ,O.[Requested Delivery Date]
            ,O.[Finish Date]
            ,O.[Purchase Order]
            ,O.[PO Date]
            ,O.[PayID]
            ,O.[Volume Discount]
            ,O.[Program Discount]
            ,O.[Discount1_Name]
            ,O.[Discount1_Type]
            ,O.[Discount1]
            ,O.[Discount2_Name]
            ,O.[Discount2_Type]
            ,O.[Discount2]
            ,O.[Discount3_Name]
            ,O.[Discount3_Type]
            ,O.[Discount3]
            ,O.[Est Pro Date]
            ,O.[Notes]
            ,O.[EngNotes]
            ,O.[CarrierID]
            ,O.[CustID]
            ,O.[US Sale]
            ,O.[Shipped Date]
            ,O.[GL Override Date]
            ,O.[FE Rate]
            ,O.[PDD]
            ,O.[Deck Length]
            ,O.[Invoice #]
            ,O.[Date Registered]
            ,O.[Date In Service]
            ,O.[Invoice Date]
            ,O.[Date Requested]
            ,O.[GVWR]
            ,O.[Tare]
            ,O.[Selection]
            ,O.[Warranty]
            ,O.[BWSPaid]
            ,O.[BWSPaidDate]
            ,O.[CommPaid]
            ,O.[CommPaidDate]
            ,O.[ts_timestamp]
            ,O.[ModifiedBy]
            ,O.[Lead Date]
            ,O.[Lead Source]
            ,O.[LeadID]
            ,O.[DealerBranchID]
            ,O.[DealerSalesPersonID]
            ,O.[DataEntryCheck]
            ,O.[DataEntryUser]
            ,O.[FinishedGoodsDealerLocID]
            ,O.[WO Reviewed]
            ,O.[WO Review Date]
            ,O.[Follow Up Date]
            ,O.[MSOIsDifferent]
            ,O.[MSOLocID]
            ,O.[EstInvDateOverride]
            ,O.[Estimated Invoice Date]
            ,O.[AdditionalPricingInfo]
            ,O.[Slot#]
            ,O.[TempModel?]
            ,O.[HighRiskUnit]
            ,O.[EngNotes V2]
            ,O.[CompanyID]
            ,O.[Customer WO#]
            ,O.[PriceSecured]
            ,O.[DateSecured]
            ,O.[SecuredBy]
        FROM
            BWSdb.dbo.OrdersV2 AS O
        LEFT JOIN 
            dtProductionSchedule AS A
        ON
            A.SGQuote = O.SGQuote
        LEFT JOIN 
            dtProductionScheduleV2 AS B
        ON
            B.SGQuote = O.SGQuote
        WHERE
            B.JobFinishDate IS NOT NULL
            AND [O].[SGQuote] = 'SG100393'
        ORDER BY
            B.JobFinishDate
        ;        
    """),
    "database": "Stargatedb",
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0"
}

if __name__ == "__main__":
    from pyodbc_connection import connect
    for query in [
        "SQL_ALL_DATED_STG_UNITS",
        "SQL_ALL_STG_PROD_DAYS"
    ]:
        print(f"{query}:\n{connect(**eval(query))}")
