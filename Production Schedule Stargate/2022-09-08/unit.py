import datetime
from dataclasses import dataclass

# Going to overwrite the AvailableDate column on the Stargate side.

@dataclass
class Unit:

    # [Stargatedb].[dbo].[dtProductionScheduleV2]
    prod_sched_v2_id: int
    quote_v2: str
    wo_num_v2: str
    job_start_date_v2: datetime.datetime
    job_finish_date_v2: datetime.datetime
    dtprodschedv2ts: str
    job_start_line_v2: str
    hide_from_prod_input_v2: bool
    InputField1_v2: str  # Model No
    InputField2_v2: str  # Customer Name
    ApplyUpdate_v2: int
    ApplyUpdateUser_v2: str

    # [Stargatedb].[dbo].[dtProductionSchedule]
    prod_sched_id: int
    quote: str
    wo_num: str
    InputField1: str  # Model No
    InputField2: str  # Customer Name
    Beam_Line: str
    Beam_Date: datetime.datetime
    GN_Line: str
    GN_Date: datetime.datetime
    WO_Line_1: str
    Prod_Date_1: datetime.datetime
    WO_Line_2: str
    Prod_Date_2: datetime.datetime
    Other: str
    Other_Line: str
    Other_Date: datetime.datetime
    HideFromProdInput: bool
    Step1SYSPROBudget: float
    Step2SYSPROBudget: float
    dtprodschedts: str
    ApplyUpdate: int
    ApplyUpdateUser: str
    Slot: int
    Slot_Quote: bool
    Slot_Approved: bool
    Prod_On: datetime.datetime
    Prod_On_Time: float
    Prod_Off: datetime.datetime
    Prod_Off_Time: float
    Prod_PM: bool
    Prod_Complete: bool
    Prod2_On: datetime.datetime
    Prod2_On_Time: float
    Prod2_Off: datetime.datetime
    Prod2_Off_Time: float
    Prod2_PM: bool
    Prod2_Complete: bool
    Prod_Instructions: str
    Beam_On: datetime.datetime
    Beam_Off: datetime.datetime
    Beam_Complete: bool
    Beam_PM: bool
    Beam_Instructions: str
    GN_On: datetime.datetime
    GN_Off: datetime.datetime
    GN_Complete: bool
    GN_PM: bool
    GN_Instructions: str
    Axle: datetime.datetime
    Axle_On: datetime.datetime
    Axle_Off: datetime.datetime
    Axle_Complete: bool
    Axle_PM: bool
    Axle_Instructions: str
    Other_On: datetime.datetime
    Other_On_Time: float
    Other_Off: datetime.datetime
    Other_Off_Time: float
    Other_Complete: bool
    Other_PM: bool
    Other_Instructions: str
    Stargate_WO: str

    # [BWSdb].[dbo].[Orders]
    OrderID: int
    SGQuote: str
    Quote_Date: datetime.datetime
    Order_Date: datetime.datetime
    WO: str
    Sales_Order: int
    Model_No: str
    Width: int
    Spread: int
    DealerID: int
    Sale_PersonID: int
    Price: float
    Prom_Drawing: str
    Special_Instructions: str
    Date_Declined: datetime.datetime
    Decline_Rejected: int
    Serial_Number: str
    Available_Date: datetime.datetime
    Delivery_Date: datetime.datetime
    Requested_Delivery_Date: datetime.datetime
    Finish_Date: datetime.datetime
    Purchase_Order: str
    PO_Date: datetime.datetime
    PayID: int
    Volume_Discount: float
    Program_Discount: float
    Discount1_Name: str
    Discount1_Type: str
    Discount1: float
    Discount2_Name: str
    Discount2_Type: str
    Discount2: float
    Discount3_Name: str
    Discount3_Type: str
    Discount3: float
    Est_Pro_Date: datetime.datetime
    Notes: str
    EngNotes: str
    CarrierID: int
    CustID: int
    US_Sale: bool
    Shipped_Date: datetime.datetime
    GL_Override_Date: datetime.datetime
    FE_Rate: float
    PDD: datetime.datetime
    Deck_Length: int
    Invoice: str
    Date_Registered: datetime.datetime
    Date_In_Service: datetime.datetime
    Invoice_Date: datetime.datetime
    Date_Requested: datetime.datetime
    GVWR: int
    Tare: int
    Selection: bool
    Warranty: bool
    BWSPaid: bool
    BWSPaidDate: datetime.datetime
    CommPaid: bool
    CommPaidDate: datetime.datetime
    ts_timestamp: str
    ModifiedBy: str
    Lead_Date: datetime.datetime
    Lead_Source: str
    LeadID: int
    DealerBranchID: int
    DealerSalesPersonID: int
    DataEntryCheck: int
    DataEntryUser: str
    FinishedGoodsDealerLocID: int
    WO_Reviewed: bool
    WO_Review_Date: datetime.datetime
    Follow_Up_Date: datetime.datetime
    MSOIsDifferent: bool
    MSOLocID: int
    EstInvDateOverride: bool
    Estimated_Invoice_Date: datetime.datetime
    AdditionalPricingInfo: str
    Slot_Orders: int
    TempModel: bool
    HighRiskUnit: bool
    EngNotes_V2: str
    CompanyID: int
    Customer_WO: int
    PriceSecured: bool
    DateSecured: datetime.datetime
    SecuredBy: str

    def __iter__(self):
        lst = [
            self.prod_sched_v2_id,
            self.quote_v2,
            self.wo_num_v2,
            self.job_start_date_v2,
            self.job_finish_date_v2,
            self.dtprodschedv2ts,
            self.job_start_line_v2,
            self.hide_from_prod_input_v2,
            self.InputField1_v2,  # Model No
            self.InputField2_v2,  # Customer Name
            self.ApplyUpdate_v2,
            self.ApplyUpdateUser_v2,

            self.prod_sched_id,
            self.quote,
            self.wo_num,
            self.InputField1,  # Model No
            self.InputField2,  # Customer Name
            self.Beam_Line,
            self.Beam_Date,
            self.GN_Line,
            self.GN_Date,
            self.WO_Line_1,
            self.Prod_Date_1,
            self.WO_Line_2,
            self.Prod_Date_2,
            self.Other,
            self.Other_Line,
            self.Other_Date,
            self.HideFromProdInput,
            self.Step1SYSPROBudget,
            self.Step2SYSPROBudget,
            self.dtprodschedts,
            self.ApplyUpdate,
            self.ApplyUpdateUser,
            self.Slot,
            self.Slot_Quote,
            self.Slot_Approved,
            self.Prod_On,
            self.Prod_On_Time,
            self.Prod_Off,
            self.Prod_Off_Time,
            self.Prod_PM,
            self.Prod_Complete,
            self.Prod2_On,
            self.Prod2_On_Time,
            self.Prod2_Off,
            self.Prod2_Off_Time,
            self.Prod2_PM,
            self.Prod2_Complete,
            self.Prod_Instructions,
            self.Beam_On,
            self.Beam_Off,
            self.Beam_Complete,
            self.Beam_PM,
            self.Beam_Instructions,
            self.GN_On,
            self.GN_Off,
            self.GN_Complete,
            self.GN_PM,
            self.GN_Instructions,
            self.Axle,
            self.Axle_On,
            self.Axle_Off,
            self.Axle_Complete,
            self.Axle_PM,
            self.Axle_Instructions,
            self.Other_On,
            self.Other_On_Time,
            self.Other_Off,
            self.Other_Off_Time,
            self.Other_Complete,
            self.Other_PM,
            self.Other_Instructions,
            self.Stargate_WO,

            self.OrderID,
            self.SGQuote,
            self.Quote_Date,
            self.Order_Date,
            self.WO,
            self.Sales_Order,
            self.Model_No,
            self.Width,
            self.Spread,
            self.DealerID,
            self.Sale_PersonID,
            self.Price,
            self.Prom_Drawing,
            self.Special_Instructions,
            self.Date_Declined,
            self.Decline_Rejected,
            self.Serial_Number,
            self.Available_Date,
            self.Delivery_Date,
            self.Requested_Delivery_Date,
            self.Finish_Date,
            self.Purchase_Order,
            self.PO_Date,
            self.PayID,
            self.Volume_Discount,
            self.Program_Discount,
            self.Discount1_Name,
            self.Discount1_Type,
            self.Discount1,
            self.Discount2_Name,
            self.Discount2_Type,
            self.Discount2,
            self.Discount3_Name,
            self.Discount3_Type,
            self.Discount3,
            self.Est_Pro_Date,
            self.Notes,
            self.EngNotes,
            self.CarrierID,
            self.CustID,
            self.US_Sale,
            self.Shipped_Date,
            self.GL_Override_Date,
            self.FE_Rate,
            self.PDD,
            self.Deck_Length,
            self.Invoice,
            self.Date_Registered,
            self.Date_In_Service,
            self.Invoice_Date,
            self.Date_Requested,
            self.GVWR,
            self.Tare,
            self.Selection,
            self.Warranty,
            self.BWSPaid,
            self.BWSPaidDate,
            self.CommPaid,
            self.CommPaidDate,
            self.ts_timestamp,
            self.ModifiedBy,
            self.Lead_Date,
            self.Lead_Source,
            self.LeadID,
            self.DealerBranchID,
            self.DealerSalesPersonID,
            self.DataEntryCheck,
            self.DataEntryUser,
            self.FinishedGoodsDealerLocID,
            self.WO_Reviewed,
            self.WO_Review_Date,
            self.Follow_Up_Date,
            self.MSOIsDifferent,
            self.MSOLocID,
            self.EstInvDateOverride,
            self.Estimated_Invoice_Date,
            self.AdditionalPricingInfo,
            self.Slot_Orders,
            self.TempModel,
            self.HighRiskUnit,
            self.EngNotes_V2,
            self.CompanyID,
            self.Customer_WO,
            self.PriceSecured,
            self.DateSecured,
            self.SecuredBy
        ]
        for el in lst:
            yield el

    def __repr__(self):
        return f"<UNIT Q#={self.SGQuote}, WO#={self.WO}, AD={self.Available_Date}, {self.job_start_line_v2=}>"


if __name__ == "__main__":
    from stg_queries import *
    from pyodbc_connection import connect
    df = connect(**SQL_ALL_DATED_STG_UNITS_TEST)
    row_gen = df.iterrows()
    row = next(row_gen)
    unit_1 = Unit(*row[1].tolist())
    print(f"{unit_1.__dict__=}")
