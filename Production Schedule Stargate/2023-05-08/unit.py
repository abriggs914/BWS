import dataclasses
import datetime
from dataclasses import dataclass

# Going to overwrite the AvailableDate column on the Stargate side.

@dataclass
class Unit:
	# [Stargatedb].[dbo].[dtProductionScheduleV2]
	_prod_sched_v2_id: int
	_quote_v2: str
	_wo_num_v2: str
	_job_start_date_v2: datetime.datetime
	_job_finish_date_v2: datetime.datetime
	_dtprodschedv2ts: str
	_job_start_line_v2: str
	_hide_from_prod_input_v2: bool
	_InputField1_v2: str  # Model No
	_InputField2_v2: str  # Customer Name
	_ApplyUpdate_v2: int
	_ApplyUpdateUser_v2: str

	# [Stargatedb].[dbo].[dtProductionSchedule]
	_prod_sched_id: int
	_quote: str
	_wo_num: str
	_InputField1: str  # Model No
	_InputField2: str  # Customer Name
	_Beam_Line: str
	_Beam_Date: datetime.datetime
	_GN_Line: str
	_GN_Date: datetime.datetime
	_WO_Line_1: str
	_Prod_Date_1: datetime.datetime
	_WO_Line_2: str
	_Prod_Date_2: datetime.datetime
	_Other: str
	_Other_Line: str
	_Other_Date: datetime.datetime
	_HideFromProdInput: bool
	_Step1SYSPROBudget: float
	_Step2SYSPROBudget: float
	_dtprodschedts: str
	_ApplyUpdate: int
	_ApplyUpdateUser: str
	_Slot: int
	_Slot_Quote: bool
	_Slot_Approved: bool
	_Prod_On: datetime.datetime
	_Prod_On_Time: float
	_Prod_Off: datetime.datetime
	_Prod_Off_Time: float
	_Prod_PM: bool
	_Prod_Complete: bool
	_Prod2_On: datetime.datetime
	_Prod2_On_Time: float
	_Prod2_Off: datetime.datetime
	_Prod2_Off_Time: float
	_Prod2_PM: bool
	_Prod2_Complete: bool
	_Prod_Instructions: str
	_Beam_On: datetime.datetime
	_Beam_Off: datetime.datetime
	_Beam_Complete: bool
	_Beam_PM: bool
	_Beam_Instructions: str
	_GN_On: datetime.datetime
	_GN_Off: datetime.datetime
	_GN_Complete: bool
	_GN_PM: bool
	_GN_Instructions: str
	_Axle: datetime.datetime
	_Axle_On: datetime.datetime
	_Axle_Off: datetime.datetime
	_Axle_Complete: bool
	_Axle_PM: bool
	_Axle_Instructions: str
	_Other_On: datetime.datetime
	_Other_On_Time: float
	_Other_Off: datetime.datetime
	_Other_Off_Time: float
	_Other_Complete: bool
	_Other_PM: bool
	_Other_Instructions: str
	_Stargate_WO: str

	# [BWSdb].[dbo].[Orders]
	_OrderID: int
	_SGQuote: str
	_Quote_Date: datetime.datetime
	_Order_Date: datetime.datetime
	_WO: str
	_Sales_Order: int
	_Model_No: str
	_Width: int
	_Spread: int
	_DealerID: int
	_Sale_PersonID: int
	_Price: float
	_Prom_Drawing: str
	_Special_Instructions: str
	_Date_Declined: datetime.datetime
	_Decline_Rejected: int
	_Serial_Number: str
	_Available_Date: datetime.datetime
	_Delivery_Date: datetime.datetime
	_Requested_Delivery_Date: datetime.datetime
	_Finish_Date: datetime.datetime
	_Purchase_Order: str
	_PO_Date: datetime.datetime
	_PayID: int
	_Volume_Discount: float
	_Program_Discount: float
	_Discount1_Name: str
	_Discount1_Type: str
	_Discount1: float
	_Discount2_Name: str
	_Discount2_Type: str
	_Discount2: float
	_Discount3_Name: str
	_Discount3_Type: str
	_Discount3: float
	_Est_Pro_Date: datetime.datetime
	_Notes: str
	_EngNotes: str
	_CarrierID: int
	_CustID: int
	_US_Sale: bool
	_Shipped_Date: datetime.datetime
	_GL_Override_Date: datetime.datetime
	_FE_Rate: float
	_PDD: datetime.datetime
	_Deck_Length: int
	_Invoice: str
	_Date_Registered: datetime.datetime
	_Date_In_Service: datetime.datetime
	_Invoice_Date: datetime.datetime
	_Date_Requested: datetime.datetime
	_GVWR: int
	_Tare: int
	_Selection: bool
	_Warranty: bool
	_BWSPaid: bool
	_BWSPaidDate: datetime.datetime
	_CommPaid: bool
	_CommPaidDate: datetime.datetime
	_ts_timestamp: str
	_ModifiedBy: str
	_Lead_Date: datetime.datetime
	_Lead_Source: str
	_LeadID: int
	_DealerBranchID: int
	_DealerSalesPersonID: int
	_DataEntryCheck: int
	_DataEntryUser: str
	_FinishedGoodsDealerLocID: int
	_WO_Reviewed: bool
	_WO_Review_Date: datetime.datetime
	_Follow_Up_Date: datetime.datetime
	_MSOIsDifferent: bool
	_MSOLocID: int
	_EstInvDateOverride: bool
	_Estimated_Invoice_Date: datetime.datetime
	_AdditionalPricingInfo: str
	_Slot_Orders: int
	_TempModel: bool
	_HighRiskUnit: bool
	_EngNotes_V2: str
	_CompanyID: int
	_Customer_WO: int
	_PriceSecured: bool
	_DateSecured: datetime.datetime
	_SecuredBy: str
	
	# [BWSdb].[dbo].[v_GalvanizedStargateOrders]
	_IsGalv: str
	_company_name: str
	
	# program specific variables
	_placed: bool = False
	_init_placed: bool = False
	_gener:int = 0
	_history: dict = dataclasses.field(default_factory=dict)

	def init(self):
		self.history.update({k: [(datetime.datetime.now(), self.gener_id(), v)] for k, v in self.__dict__.items() if k != "_history" and k != "_gener"})
		# print(f"{self.history=}")
		return self

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
			self.SecuredBy,
			
			self.IsGalv,
			self.company_name,

			self.init_placed,
			self.placed,
			self.gener
		]
		for el in lst:
			yield el
			
	def gener_id(self):
		self.gener += 1
		return self.gener

	def __repr__(self):
		ad = f"{self.Available_Date: '%Y-%m-%d'}" if isinstance(self.Available_Date, datetime.datetime) else "NaT"
		return f"<UNIT Q#={self.SGQuote}, WO#={self.WO}, CWO#={self.Customer_WO}, SN={self.Serial_Number}, PLACED={self.placed}, AD={ad}, LN={self.job_start_line_v2}, dealer='{self._InputField2_v2}'>"

	# _prod_sched_v2_id
	def get_prod_sched_v2_id(self):
		return self._prod_sched_v2_id

	def set_prod_sched_v2_id(self, prod_sched_v2_id_in):
		self.history["_prod_sched_v2_id"].append((datetime.datetime.now(), self.gener_id(), prod_sched_v2_id_in))
		self._prod_sched_v2_id = prod_sched_v2_id_in

	def del_prod_sched_v2_id(self):
		del self._prod_sched_v2_id

	# _quote_v2
	def get_quote_v2(self):
		return self._quote_v2

	def set_quote_v2(self, quote_v2_in):
		self.history["_quote_v2"].append((datetime.datetime.now(), self.gener_id(), quote_v2_in))
		self._quote_v2 = quote_v2_in

	def del_quote_v2(self):
		del self._quote_v2

	# _wo_num_v2
	def get_wo_num_v2(self):
		return self._wo_num_v2

	def set_wo_num_v2(self, wo_num_v2_in):
		self.history["_wo_num_v2"].append((datetime.datetime.now(), self.gener_id(), wo_num_v2_in))
		self._wo_num_v2 = wo_num_v2_in

	def del_wo_num_v2(self):
		del self._wo_num_v2

	# _job_start_date_v2
	def get_job_start_date_v2(self):
		return self._job_start_date_v2

	def set_job_start_date_v2(self, job_start_date_v2_in):
		self.history["_job_start_date_v2"].append((datetime.datetime.now(), self.gener_id(), job_start_date_v2_in))
		self._job_start_date_v2 = job_start_date_v2_in

	def del_job_start_date_v2(self):
		del self._job_start_date_v2

	# _job_finish_date_v2
	def get_job_finish_date_v2(self):
		return self._job_finish_date_v2

	def set_job_finish_date_v2(self, job_finish_date_v2_in):
		self.history["_job_finish_date_v2"].append((datetime.datetime.now(), self.gener_id(), job_finish_date_v2_in))
		self._job_finish_date_v2 = job_finish_date_v2_in

	def del_job_finish_date_v2(self):
		del self._job_finish_date_v2

	# _dtprodschedv2ts
	def get_dtprodschedv2ts(self):
		return self._dtprodschedv2ts

	def set_dtprodschedv2ts(self, dtprodschedv2ts_in):
		self.history["_dtprodschedv2ts"].append((datetime.datetime.now(), self.gener_id(), dtprodschedv2ts_in))
		self._dtprodschedv2ts = dtprodschedv2ts_in

	def del_dtprodschedv2ts(self):
		del self._dtprodschedv2ts

	# _job_start_line_v2
	def get_job_start_line_v2(self):
		return self._job_start_line_v2

	def set_job_start_line_v2(self, job_start_line_v2_in):
		self.history["_job_start_line_v2"].append((datetime.datetime.now(), self.gener_id(), job_start_line_v2_in))
		self._job_start_line_v2 = job_start_line_v2_in

	def del_job_start_line_v2(self):
		del self._job_start_line_v2

	# _hide_from_prod_input_v2
	def get_hide_from_prod_input_v2(self):
		return self._hide_from_prod_input_v2

	def set_hide_from_prod_input_v2(self, hide_from_prod_input_v2_in):
		self.history["_hide_from_prod_input_v2"].append((datetime.datetime.now(), self.gener_id(), hide_from_prod_input_v2_in))
		self._hide_from_prod_input_v2 = hide_from_prod_input_v2_in

	def del_hide_from_prod_input_v2(self):
		del self._hide_from_prod_input_v2

	# _InputField1_v2
	def get_InputField1_v2(self):
		return self._InputField1_v2

	def set_InputField1_v2(self, InputField1_v2_in):
		self.history["_InputField1_v2"].append((datetime.datetime.now(), self.gener_id(), InputField1_v2_in))
		self._InputField1_v2 = InputField1_v2_in

	def del_InputField1_v2(self):
		del self._InputField1_v2

	# _InputField2_v2
	def get_InputField2_v2(self):
		return self._InputField2_v2

	def set_InputField2_v2(self, InputField2_v2_in):
		self.history["_InputField2_v2"].append((datetime.datetime.now(), self.gener_id(), InputField2_v2_in))
		self._InputField2_v2 = InputField2_v2_in

	def del_InputField2_v2(self):
		del self._InputField2_v2

	# _ApplyUpdate_v2
	def get_ApplyUpdate_v2(self):
		return self._ApplyUpdate_v2

	def set_ApplyUpdate_v2(self, ApplyUpdate_v2_in):
		self.history["_ApplyUpdate_v2"].append((datetime.datetime.now(), self.gener_id(), ApplyUpdate_v2_in))
		self._ApplyUpdate_v2 = ApplyUpdate_v2_in

	def del_ApplyUpdate_v2(self):
		del self._ApplyUpdate_v2

	# _ApplyUpdateUser_v2
	def get_ApplyUpdateUser_v2(self):
		return self._ApplyUpdateUser_v2

	def set_ApplyUpdateUser_v2(self, ApplyUpdateUser_v2_in):
		self.history["_ApplyUpdateUser_v2"].append((datetime.datetime.now(), self.gener_id(), ApplyUpdateUser_v2_in))
		self._ApplyUpdateUser_v2 = ApplyUpdateUser_v2_in

	def del_ApplyUpdateUser_v2(self):
		del self._ApplyUpdateUser_v2

	# _prod_sched_id
	def get_prod_sched_id(self):
		return self._prod_sched_id

	def set_prod_sched_id(self, prod_sched_id_in):
		self.history["_prod_sched_id"].append((datetime.datetime.now(), self.gener_id(), prod_sched_id_in))
		self._prod_sched_id = prod_sched_id_in

	def del_prod_sched_id(self):
		del self._prod_sched_id

	# _quote
	def get_quote(self):
		return self._quote

	def set_quote(self, quote_in):
		self.history["_quote"].append((datetime.datetime.now(), self.gener_id(), quote_in))
		self._quote = quote_in

	def del_quote(self):
		del self._quote

	# _wo_num
	def get_wo_num(self):
		return self._wo_num

	def set_wo_num(self, wo_num_in):
		self.history["_wo_num"].append((datetime.datetime.now(), self.gener_id(), wo_num_in))
		self._wo_num = wo_num_in

	def del_wo_num(self):
		del self._wo_num

	# _InputField1
	def get_InputField1(self):
		return self._InputField1

	def set_InputField1(self, InputField1_in):
		self.history["_InputField1"].append((datetime.datetime.now(), self.gener_id(), InputField1_in))
		self._InputField1 = InputField1_in

	def del_InputField1(self):
		del self._InputField1

	# _InputField2
	def get_InputField2(self):
		return self._InputField2

	def set_InputField2(self, InputField2_in):
		self.history["_InputField2"].append((datetime.datetime.now(), self.gener_id(), InputField2_in))
		self._InputField2 = InputField2_in

	def del_InputField2(self):
		del self._InputField2

	# _Beam_Line
	def get_Beam_Line(self):
		return self._Beam_Line

	def set_Beam_Line(self, Beam_Line_in):
		self.history["_Beam_Line"].append((datetime.datetime.now(), self.gener_id(), Beam_Line_in))
		self._Beam_Line = Beam_Line_in

	def del_Beam_Line(self):
		del self._Beam_Line

	# _Beam_Date
	def get_Beam_Date(self):
		return self._Beam_Date

	def set_Beam_Date(self, Beam_Date_in):
		self.history["_Beam_Date"].append((datetime.datetime.now(), self.gener_id(), Beam_Date_in))
		self._Beam_Date = Beam_Date_in

	def del_Beam_Date(self):
		del self._Beam_Date

	# _GN_Line
	def get_GN_Line(self):
		return self._GN_Line

	def set_GN_Line(self, GN_Line_in):
		self.history["_GN_Line"].append((datetime.datetime.now(), self.gener_id(), GN_Line_in))
		self._GN_Line = GN_Line_in

	def del_GN_Line(self):
		del self._GN_Line

	# _GN_Date
	def get_GN_Date(self):
		return self._GN_Date

	def set_GN_Date(self, GN_Date_in):
		self.history["_GN_Date"].append((datetime.datetime.now(), self.gener_id(), GN_Date_in))
		self._GN_Date = GN_Date_in

	def del_GN_Date(self):
		del self._GN_Date

	# _WO_Line_1
	def get_WO_Line_1(self):
		return self._WO_Line_1

	def set_WO_Line_1(self, WO_Line_1_in):
		self.history["_WO_Line_1"].append((datetime.datetime.now(), self.gener_id(), WO_Line_1_in))
		self._WO_Line_1 = WO_Line_1_in

	def del_WO_Line_1(self):
		del self._WO_Line_1

	# _Prod_Date_1
	def get_Prod_Date_1(self):
		return self._Prod_Date_1

	def set_Prod_Date_1(self, Prod_Date_1_in):
		self.history["_Prod_Date_1"].append((datetime.datetime.now(), self.gener_id(), Prod_Date_1_in))
		self._Prod_Date_1 = Prod_Date_1_in

	def del_Prod_Date_1(self):
		del self._Prod_Date_1

	# _WO_Line_2
	def get_WO_Line_2(self):
		return self._WO_Line_2

	def set_WO_Line_2(self, WO_Line_2_in):
		self.history["_WO_Line_2"].append((datetime.datetime.now(), self.gener_id(), WO_Line_2_in))
		self._WO_Line_2 = WO_Line_2_in

	def del_WO_Line_2(self):
		del self._WO_Line_2

	# _Prod_Date_2
	def get_Prod_Date_2(self):
		return self._Prod_Date_2

	def set_Prod_Date_2(self, Prod_Date_2_in):
		self.history["_Prod_Date_2"].append((datetime.datetime.now(), self.gener_id(), Prod_Date_2_in))
		self._Prod_Date_2 = Prod_Date_2_in

	def del_Prod_Date_2(self):
		del self._Prod_Date_2

	# _Other
	def get_Other(self):
		return self._Other

	def set_Other(self, Other_in):
		self.history["_Other"].append((datetime.datetime.now(), self.gener_id(), Other_in))
		self._Other = Other_in

	def del_Other(self):
		del self._Other

	# _Other_Line
	def get_Other_Line(self):
		return self._Other_Line

	def set_Other_Line(self, Other_Line_in):
		self.history["_Other_Line"].append((datetime.datetime.now(), self.gener_id(), Other_Line_in))
		self._Other_Line = Other_Line_in

	def del_Other_Line(self):
		del self._Other_Line

	# _Other_Date
	def get_Other_Date(self):
		return self._Other_Date

	def set_Other_Date(self, Other_Date_in):
		self.history["_Other_Date"].append((datetime.datetime.now(), self.gener_id(), Other_Date_in))
		self._Other_Date = Other_Date_in

	def del_Other_Date(self):
		del self._Other_Date

	# _HideFromProdInput
	def get_HideFromProdInput(self):
		return self._HideFromProdInput

	def set_HideFromProdInput(self, HideFromProdInput_in):
		self.history["_HideFromProdInput"].append((datetime.datetime.now(), self.gener_id(), HideFromProdInput_in))
		self._HideFromProdInput = HideFromProdInput_in

	def del_HideFromProdInput(self):
		del self._HideFromProdInput

	# _Step1SYSPROBudget
	def get_Step1SYSPROBudget(self):
		return self._Step1SYSPROBudget

	def set_Step1SYSPROBudget(self, Step1SYSPROBudget_in):
		self.history["_Step1SYSPROBudget"].append((datetime.datetime.now(), self.gener_id(), Step1SYSPROBudget_in))
		self._Step1SYSPROBudget = Step1SYSPROBudget_in

	def del_Step1SYSPROBudget(self):
		del self._Step1SYSPROBudget

	# _Step2SYSPROBudget
	def get_Step2SYSPROBudget(self):
		return self._Step2SYSPROBudget

	def set_Step2SYSPROBudget(self, Step2SYSPROBudget_in):
		self.history["_Step2SYSPROBudget"].append((datetime.datetime.now(), self.gener_id(), Step2SYSPROBudget_in))
		self._Step2SYSPROBudget = Step2SYSPROBudget_in

	def del_Step2SYSPROBudget(self):
		del self._Step2SYSPROBudget

	# _dtprodschedts
	def get_dtprodschedts(self):
		return self._dtprodschedts

	def set_dtprodschedts(self, dtprodschedts_in):
		self.history["_dtprodschedts"].append((datetime.datetime.now(), self.gener_id(), dtprodschedts_in))
		self._dtprodschedts = dtprodschedts_in

	def del_dtprodschedts(self):
		del self._dtprodschedts

	# _ApplyUpdate
	def get_ApplyUpdate(self):
		return self._ApplyUpdate

	def set_ApplyUpdate(self, ApplyUpdate_in):
		self.history["_ApplyUpdate"].append((datetime.datetime.now(), self.gener_id(), ApplyUpdate_in))
		self._ApplyUpdate = ApplyUpdate_in

	def del_ApplyUpdate(self):
		del self._ApplyUpdate

	# _ApplyUpdateUser
	def get_ApplyUpdateUser(self):
		return self._ApplyUpdateUser

	def set_ApplyUpdateUser(self, ApplyUpdateUser_in):
		self.history["_ApplyUpdateUser"].append((datetime.datetime.now(), self.gener_id(), ApplyUpdateUser_in))
		self._ApplyUpdateUser = ApplyUpdateUser_in

	def del_ApplyUpdateUser(self):
		del self._ApplyUpdateUser

	# _Slot
	def get_Slot(self):
		return self._Slot

	def set_Slot(self, Slot_in):
		self.history["_Slot"].append((datetime.datetime.now(), self.gener_id(), Slot_in))
		self._Slot = Slot_in

	def del_Slot(self):
		del self._Slot

	# _Slot_Quote
	def get_Slot_Quote(self):
		return self._Slot_Quote

	def set_Slot_Quote(self, Slot_Quote_in):
		self.history["_Slot_Quote"].append((datetime.datetime.now(), self.gener_id(), Slot_Quote_in))
		self._Slot_Quote = Slot_Quote_in

	def del_Slot_Quote(self):
		del self._Slot_Quote

	# _Slot_Approved
	def get_Slot_Approved(self):
		return self._Slot_Approved

	def set_Slot_Approved(self, Slot_Approved_in):
		self.history["_Slot_Approved"].append((datetime.datetime.now(), self.gener_id(), Slot_Approved_in))
		self._Slot_Approved = Slot_Approved_in

	def del_Slot_Approved(self):
		del self._Slot_Approved

	# _Prod_On
	def get_Prod_On(self):
		return self._Prod_On

	def set_Prod_On(self, Prod_On_in):
		self.history["_Prod_On"].append((datetime.datetime.now(), self.gener_id(), Prod_On_in))
		self._Prod_On = Prod_On_in

	def del_Prod_On(self):
		del self._Prod_On

	# _Prod_On_Time
	def get_Prod_On_Time(self):
		return self._Prod_On_Time

	def set_Prod_On_Time(self, Prod_On_Time_in):
		self.history["_Prod_On_Time"].append((datetime.datetime.now(), self.gener_id(), Prod_On_Time_in))
		self._Prod_On_Time = Prod_On_Time_in

	def del_Prod_On_Time(self):
		del self._Prod_On_Time

	# _Prod_Off
	def get_Prod_Off(self):
		return self._Prod_Off

	def set_Prod_Off(self, Prod_Off_in):
		self.history["_Prod_Off"].append((datetime.datetime.now(), self.gener_id(), Prod_Off_in))
		self._Prod_Off = Prod_Off_in

	def del_Prod_Off(self):
		del self._Prod_Off

	# _Prod_Off_Time
	def get_Prod_Off_Time(self):
		return self._Prod_Off_Time

	def set_Prod_Off_Time(self, Prod_Off_Time_in):
		self.history["_Prod_Off_Time"].append((datetime.datetime.now(), self.gener_id(), Prod_Off_Time_in))
		self._Prod_Off_Time = Prod_Off_Time_in

	def del_Prod_Off_Time(self):
		del self._Prod_Off_Time

	# _Prod_PM
	def get_Prod_PM(self):
		return self._Prod_PM

	def set_Prod_PM(self, Prod_PM_in):
		self.history["_Prod_PM"].append((datetime.datetime.now(), self.gener_id(), Prod_PM_in))
		self._Prod_PM = Prod_PM_in

	def del_Prod_PM(self):
		del self._Prod_PM

	# _Prod_Complete
	def get_Prod_Complete(self):
		return self._Prod_Complete

	def set_Prod_Complete(self, Prod_Complete_in):
		self.history["_Prod_Complete"].append((datetime.datetime.now(), self.gener_id(), Prod_Complete_in))
		self._Prod_Complete = Prod_Complete_in

	def del_Prod_Complete(self):
		del self._Prod_Complete

	# _Prod2_On
	def get_Prod2_On(self):
		return self._Prod2_On

	def set_Prod2_On(self, Prod2_On_in):
		self.history["_Prod2_On"].append((datetime.datetime.now(), self.gener_id(), Prod2_On_in))
		self._Prod2_On = Prod2_On_in

	def del_Prod2_On(self):
		del self._Prod2_On

	# _Prod2_On_Time
	def get_Prod2_On_Time(self):
		return self._Prod2_On_Time

	def set_Prod2_On_Time(self, Prod2_On_Time_in):
		self.history["_Prod2_On_Time"].append((datetime.datetime.now(), self.gener_id(), Prod2_On_Time_in))
		self._Prod2_On_Time = Prod2_On_Time_in

	def del_Prod2_On_Time(self):
		del self._Prod2_On_Time

	# _Prod2_Off
	def get_Prod2_Off(self):
		return self._Prod2_Off

	def set_Prod2_Off(self, Prod2_Off_in):
		self.history["_Prod2_Off"].append((datetime.datetime.now(), self.gener_id(), Prod2_Off_in))
		self._Prod2_Off = Prod2_Off_in

	def del_Prod2_Off(self):
		del self._Prod2_Off

	# _Prod2_Off_Time
	def get_Prod2_Off_Time(self):
		return self._Prod2_Off_Time

	def set_Prod2_Off_Time(self, Prod2_Off_Time_in):
		self.history["_Prod2_Off_Time"].append((datetime.datetime.now(), self.gener_id(), Prod2_Off_Time_in))
		self._Prod2_Off_Time = Prod2_Off_Time_in

	def del_Prod2_Off_Time(self):
		del self._Prod2_Off_Time

	# _Prod2_PM
	def get_Prod2_PM(self):
		return self._Prod2_PM

	def set_Prod2_PM(self, Prod2_PM_in):
		self.history["_Prod2_PM"].append((datetime.datetime.now(), self.gener_id(), Prod2_PM_in))
		self._Prod2_PM = Prod2_PM_in

	def del_Prod2_PM(self):
		del self._Prod2_PM

	# _Prod2_Complete
	def get_Prod2_Complete(self):
		return self._Prod2_Complete

	def set_Prod2_Complete(self, Prod2_Complete_in):
		self.history["_Prod2_Complete"].append((datetime.datetime.now(), self.gener_id(), Prod2_Complete_in))
		self._Prod2_Complete = Prod2_Complete_in

	def del_Prod2_Complete(self):
		del self._Prod2_Complete

	# _Prod_Instructions
	def get_Prod_Instructions(self):
		return self._Prod_Instructions

	def set_Prod_Instructions(self, Prod_Instructions_in):
		self.history["_Prod_Instructions"].append((datetime.datetime.now(), self.gener_id(), Prod_Instructions_in))
		self._Prod_Instructions = Prod_Instructions_in

	def del_Prod_Instructions(self):
		del self._Prod_Instructions

	# _Beam_On
	def get_Beam_On(self):
		return self._Beam_On

	def set_Beam_On(self, Beam_On_in):
		self.history["_Beam_On"].append((datetime.datetime.now(), self.gener_id(), Beam_On_in))
		self._Beam_On = Beam_On_in

	def del_Beam_On(self):
		del self._Beam_On

	# _Beam_Off
	def get_Beam_Off(self):
		return self._Beam_Off

	def set_Beam_Off(self, Beam_Off_in):
		self.history["_Beam_Off"].append((datetime.datetime.now(), self.gener_id(), Beam_Off_in))
		self._Beam_Off = Beam_Off_in

	def del_Beam_Off(self):
		del self._Beam_Off

	# _Beam_Complete
	def get_Beam_Complete(self):
		return self._Beam_Complete

	def set_Beam_Complete(self, Beam_Complete_in):
		self.history["_Beam_Complete"].append((datetime.datetime.now(), self.gener_id(), Beam_Complete_in))
		self._Beam_Complete = Beam_Complete_in

	def del_Beam_Complete(self):
		del self._Beam_Complete

	# _Beam_PM
	def get_Beam_PM(self):
		return self._Beam_PM

	def set_Beam_PM(self, Beam_PM_in):
		self.history["_Beam_PM"].append((datetime.datetime.now(), self.gener_id(), Beam_PM_in))
		self._Beam_PM = Beam_PM_in

	def del_Beam_PM(self):
		del self._Beam_PM

	# _Beam_Instructions
	def get_Beam_Instructions(self):
		return self._Beam_Instructions

	def set_Beam_Instructions(self, Beam_Instructions_in):
		self.history["_Beam_Instructions"].append((datetime.datetime.now(), self.gener_id(), Beam_Instructions_in))
		self._Beam_Instructions = Beam_Instructions_in

	def del_Beam_Instructions(self):
		del self._Beam_Instructions

	# _GN_On
	def get_GN_On(self):
		return self._GN_On

	def set_GN_On(self, GN_On_in):
		self.history["_GN_On"].append((datetime.datetime.now(), self.gener_id(), GN_On_in))
		self._GN_On = GN_On_in

	def del_GN_On(self):
		del self._GN_On

	# _GN_Off
	def get_GN_Off(self):
		return self._GN_Off

	def set_GN_Off(self, GN_Off_in):
		self.history["_GN_Off"].append((datetime.datetime.now(), self.gener_id(), GN_Off_in))
		self._GN_Off = GN_Off_in

	def del_GN_Off(self):
		del self._GN_Off

	# _GN_Complete
	def get_GN_Complete(self):
		return self._GN_Complete

	def set_GN_Complete(self, GN_Complete_in):
		self.history["_GN_Complete"].append((datetime.datetime.now(), self.gener_id(), GN_Complete_in))
		self._GN_Complete = GN_Complete_in

	def del_GN_Complete(self):
		del self._GN_Complete

	# _GN_PM
	def get_GN_PM(self):
		return self._GN_PM

	def set_GN_PM(self, GN_PM_in):
		self.history["_GN_PM"].append((datetime.datetime.now(), self.gener_id(), GN_PM_in))
		self._GN_PM = GN_PM_in

	def del_GN_PM(self):
		del self._GN_PM

	# _GN_Instructions
	def get_GN_Instructions(self):
		return self._GN_Instructions

	def set_GN_Instructions(self, GN_Instructions_in):
		self.history["_GN_Instructions"].append((datetime.datetime.now(), self.gener_id(), GN_Instructions_in))
		self._GN_Instructions = GN_Instructions_in

	def del_GN_Instructions(self):
		del self._GN_Instructions

	# _Axle
	def get_Axle(self):
		return self._Axle

	def set_Axle(self, Axle_in):
		self.history["_Axle"].append((datetime.datetime.now(), self.gener_id(), Axle_in))
		self._Axle = Axle_in

	def del_Axle(self):
		del self._Axle

	# _Axle_On
	def get_Axle_On(self):
		return self._Axle_On

	def set_Axle_On(self, Axle_On_in):
		self.history["_Axle_On"].append((datetime.datetime.now(), self.gener_id(), Axle_On_in))
		self._Axle_On = Axle_On_in

	def del_Axle_On(self):
		del self._Axle_On

	# _Axle_Off
	def get_Axle_Off(self):
		return self._Axle_Off

	def set_Axle_Off(self, Axle_Off_in):
		self.history["_Axle_Off"].append((datetime.datetime.now(), self.gener_id(), Axle_Off_in))
		self._Axle_Off = Axle_Off_in

	def del_Axle_Off(self):
		del self._Axle_Off

	# _Axle_Complete
	def get_Axle_Complete(self):
		return self._Axle_Complete

	def set_Axle_Complete(self, Axle_Complete_in):
		self.history["_Axle_Complete"].append((datetime.datetime.now(), self.gener_id(), Axle_Complete_in))
		self._Axle_Complete = Axle_Complete_in

	def del_Axle_Complete(self):
		del self._Axle_Complete

	# _Axle_PM
	def get_Axle_PM(self):
		return self._Axle_PM

	def set_Axle_PM(self, Axle_PM_in):
		self.history["_Axle_PM"].append((datetime.datetime.now(), self.gener_id(), Axle_PM_in))
		self._Axle_PM = Axle_PM_in

	def del_Axle_PM(self):
		del self._Axle_PM

	# _Axle_Instructions
	def get_Axle_Instructions(self):
		return self._Axle_Instructions

	def set_Axle_Instructions(self, Axle_Instructions_in):
		self.history["_Axle_Instructions"].append((datetime.datetime.now(), self.gener_id(), Axle_Instructions_in))
		self._Axle_Instructions = Axle_Instructions_in

	def del_Axle_Instructions(self):
		del self._Axle_Instructions

	# _Other_On
	def get_Other_On(self):
		return self._Other_On

	def set_Other_On(self, Other_On_in):
		self.history["_Other_On"].append((datetime.datetime.now(), self.gener_id(), Other_On_in))
		self._Other_On = Other_On_in

	def del_Other_On(self):
		del self._Other_On

	# _Other_On_Time
	def get_Other_On_Time(self):
		return self._Other_On_Time

	def set_Other_On_Time(self, Other_On_Time_in):
		self.history["_Other_On_Time"].append((datetime.datetime.now(), self.gener_id(), Other_On_Time_in))
		self._Other_On_Time = Other_On_Time_in

	def del_Other_On_Time(self):
		del self._Other_On_Time

	# _Other_Off
	def get_Other_Off(self):
		return self._Other_Off

	def set_Other_Off(self, Other_Off_in):
		self.history["_Other_Off"].append((datetime.datetime.now(), self.gener_id(), Other_Off_in))
		self._Other_Off = Other_Off_in

	def del_Other_Off(self):
		del self._Other_Off

	# _Other_Off_Time
	def get_Other_Off_Time(self):
		return self._Other_Off_Time

	def set_Other_Off_Time(self, Other_Off_Time_in):
		self.history["_Other_Off_Time"].append((datetime.datetime.now(), self.gener_id(), Other_Off_Time_in))
		self._Other_Off_Time = Other_Off_Time_in

	def del_Other_Off_Time(self):
		del self._Other_Off_Time

	# _Other_Complete
	def get_Other_Complete(self):
		return self._Other_Complete

	def set_Other_Complete(self, Other_Complete_in):
		self.history["_Other_Complete"].append((datetime.datetime.now(), self.gener_id(), Other_Complete_in))
		self._Other_Complete = Other_Complete_in

	def del_Other_Complete(self):
		del self._Other_Complete

	# _Other_PM
	def get_Other_PM(self):
		return self._Other_PM

	def set_Other_PM(self, Other_PM_in):
		self.history["_Other_PM"].append((datetime.datetime.now(), self.gener_id(), Other_PM_in))
		self._Other_PM = Other_PM_in

	def del_Other_PM(self):
		del self._Other_PM

	# _Other_Instructions
	def get_Other_Instructions(self):
		return self._Other_Instructions

	def set_Other_Instructions(self, Other_Instructions_in):
		self.history["_Other_Instructions"].append((datetime.datetime.now(), self.gener_id(), Other_Instructions_in))
		self._Other_Instructions = Other_Instructions_in

	def del_Other_Instructions(self):
		del self._Other_Instructions

	# _Stargate_WO
	def get_Stargate_WO(self):
		return self._Stargate_WO

	def set_Stargate_WO(self, Stargate_WO_in):
		self.history["_Stargate_WO"].append((datetime.datetime.now(), self.gener_id(), Stargate_WO_in))
		self._Stargate_WO = Stargate_WO_in

	def del_Stargate_WO(self):
		del self._Stargate_WO

	# _OrderID
	def get_OrderID(self):
		return self._OrderID

	def set_OrderID(self, OrderID_in):
		self.history["_OrderID"].append((datetime.datetime.now(), self.gener_id(), OrderID_in))
		self._OrderID = OrderID_in

	def del_OrderID(self):
		del self._OrderID

	# _SGQuote
	def get_SGQuote(self):
		return self._SGQuote

	def set_SGQuote(self, SGQuote_in):
		self.history["_SGQuote"].append((datetime.datetime.now(), self.gener_id(), SGQuote_in))
		self._SGQuote = SGQuote_in

	def del_SGQuote(self):
		del self._SGQuote

	# _Quote_Date
	def get_Quote_Date(self):
		return self._Quote_Date

	def set_Quote_Date(self, Quote_Date_in):
		self.history["_Quote_Date"].append((datetime.datetime.now(), self.gener_id(), Quote_Date_in))
		self._Quote_Date = Quote_Date_in

	def del_Quote_Date(self):
		del self._Quote_Date

	# _Order_Date
	def get_Order_Date(self):
		return self._Order_Date

	def set_Order_Date(self, Order_Date_in):
		self.history["_Order_Date"].append((datetime.datetime.now(), self.gener_id(), Order_Date_in))
		self._Order_Date = Order_Date_in

	def del_Order_Date(self):
		del self._Order_Date

	# _WO
	def get_WO(self):
		return self._WO

	def set_WO(self, WO_in):
		if WO_in.isnumeric():
			WO_in = int(WO_in)
			print(f"{WO_in} IS NUMERIC!")
		else:
			print(f"{WO_in} IS NOT NUMERIC")
		self.history["_WO"].append((datetime.datetime.now(), self.gener_id(), WO_in))
		self._WO = WO_in

	def del_WO(self):
		del self._WO

	# _Sales_Order
	def get_Sales_Order(self):
		return self._Sales_Order

	def set_Sales_Order(self, Sales_Order_in):
		self.history["_Sales_Order"].append((datetime.datetime.now(), self.gener_id(), Sales_Order_in))
		self._Sales_Order = Sales_Order_in

	def del_Sales_Order(self):
		del self._Sales_Order

	# _Model_No
	def get_Model_No(self):
		return self._Model_No

	def set_Model_No(self, Model_No_in):
		self.history["_Model_No"].append((datetime.datetime.now(), self.gener_id(), Model_No_in))
		self._Model_No = Model_No_in

	def del_Model_No(self):
		del self._Model_No

	# _Width
	def get_Width(self):
		return self._Width

	def set_Width(self, Width_in):
		self.history["_Width"].append((datetime.datetime.now(), self.gener_id(), Width_in))
		self._Width = Width_in

	def del_Width(self):
		del self._Width

	# _Spread
	def get_Spread(self):
		return self._Spread

	def set_Spread(self, Spread_in):
		self.history["_Spread"].append((datetime.datetime.now(), self.gener_id(), Spread_in))
		self._Spread = Spread_in

	def del_Spread(self):
		del self._Spread

	# _DealerID
	def get_DealerID(self):
		return self._DealerID

	def set_DealerID(self, DealerID_in):
		self.history["_DealerID"].append((datetime.datetime.now(), self.gener_id(), DealerID_in))
		self._DealerID = DealerID_in

	def del_DealerID(self):
		del self._DealerID

	# _Sale_PersonID
	def get_Sale_PersonID(self):
		return self._Sale_PersonID

	def set_Sale_PersonID(self, Sale_PersonID_in):
		self.history["_Sale_PersonID"].append((datetime.datetime.now(), self.gener_id(), Sale_PersonID_in))
		self._Sale_PersonID = Sale_PersonID_in

	def del_Sale_PersonID(self):
		del self._Sale_PersonID

	# _Price
	def get_Price(self):
		return self._Price

	def set_Price(self, Price_in):
		self.history["_Price"].append((datetime.datetime.now(), self.gener_id(), Price_in))
		self._Price = Price_in

	def del_Price(self):
		del self._Price

	# _Prom_Drawing
	def get_Prom_Drawing(self):
		return self._Prom_Drawing

	def set_Prom_Drawing(self, Prom_Drawing_in):
		self.history["_Prom_Drawing"].append((datetime.datetime.now(), self.gener_id(), Prom_Drawing_in))
		self._Prom_Drawing = Prom_Drawing_in

	def del_Prom_Drawing(self):
		del self._Prom_Drawing

	# _Special_Instructions
	def get_Special_Instructions(self):
		return self._Special_Instructions

	def set_Special_Instructions(self, Special_Instructions_in):
		self.history["_Special_Instructions"].append((datetime.datetime.now(), self.gener_id(), Special_Instructions_in))
		self._Special_Instructions = Special_Instructions_in

	def del_Special_Instructions(self):
		del self._Special_Instructions

	# _Date_Declined
	def get_Date_Declined(self):
		return self._Date_Declined

	def set_Date_Declined(self, Date_Declined_in):
		self.history["_Date_Declined"].append((datetime.datetime.now(), self.gener_id(), Date_Declined_in))
		self._Date_Declined = Date_Declined_in

	def del_Date_Declined(self):
		del self._Date_Declined

	# _Decline_Rejected
	def get_Decline_Rejected(self):
		return self._Decline_Rejected

	def set_Decline_Rejected(self, Decline_Rejected_in):
		self.history["_Decline_Rejected"].append((datetime.datetime.now(), self.gener_id(), Decline_Rejected_in))
		self._Decline_Rejected = Decline_Rejected_in

	def del_Decline_Rejected(self):
		del self._Decline_Rejected

	# _Serial_Number
	def get_Serial_Number(self):
		return self._Serial_Number

	def set_Serial_Number(self, Serial_Number_in):
		self.history["_Serial_Number"].append((datetime.datetime.now(), self.gener_id(), Serial_Number_in))
		self._Serial_Number = Serial_Number_in

	def del_Serial_Number(self):
		del self._Serial_Number

	# _Available_Date
	def get_Available_Date(self):
		return self._Available_Date

	def set_Available_Date(self, Available_Date_in):
		self.history["_Available_Date"].append((datetime.datetime.now(), self.gener_id(), Available_Date_in))
		self._Available_Date = Available_Date_in

	def del_Available_Date(self):
		del self._Available_Date

	# _Delivery_Date
	def get_Delivery_Date(self):
		return self._Delivery_Date

	def set_Delivery_Date(self, Delivery_Date_in):
		self.history["_Delivery_Date"].append((datetime.datetime.now(), self.gener_id(), Delivery_Date_in))
		self._Delivery_Date = Delivery_Date_in

	def del_Delivery_Date(self):
		del self._Delivery_Date

	# _Requested_Delivery_Date
	def get_Requested_Delivery_Date(self):
		return self._Requested_Delivery_Date

	def set_Requested_Delivery_Date(self, Requested_Delivery_Date_in):
		self.history["_Requested_Delivery_Date"].append((datetime.datetime.now(), self.gener_id(), Requested_Delivery_Date_in))
		self._Requested_Delivery_Date = Requested_Delivery_Date_in

	def del_Requested_Delivery_Date(self):
		del self._Requested_Delivery_Date

	# _Finish_Date
	def get_Finish_Date(self):
		return self._Finish_Date

	def set_Finish_Date(self, Finish_Date_in):
		self.history["_Finish_Date"].append((datetime.datetime.now(), self.gener_id(), Finish_Date_in))
		self._Finish_Date = Finish_Date_in

	def del_Finish_Date(self):
		del self._Finish_Date

	# _Purchase_Order
	def get_Purchase_Order(self):
		return self._Purchase_Order

	def set_Purchase_Order(self, Purchase_Order_in):
		self.history["_Purchase_Order"].append((datetime.datetime.now(), self.gener_id(), Purchase_Order_in))
		self._Purchase_Order = Purchase_Order_in

	def del_Purchase_Order(self):
		del self._Purchase_Order

	# _PO_Date
	def get_PO_Date(self):
		return self._PO_Date

	def set_PO_Date(self, PO_Date_in):
		self.history["_PO_Date"].append((datetime.datetime.now(), self.gener_id(), PO_Date_in))
		self._PO_Date = PO_Date_in

	def del_PO_Date(self):
		del self._PO_Date

	# _PayID
	def get_PayID(self):
		return self._PayID

	def set_PayID(self, PayID_in):
		self.history["_PayID"].append((datetime.datetime.now(), self.gener_id(), PayID_in))
		self._PayID = PayID_in

	def del_PayID(self):
		del self._PayID

	# _Volume_Discount
	def get_Volume_Discount(self):
		return self._Volume_Discount

	def set_Volume_Discount(self, Volume_Discount_in):
		self.history["_Volume_Discount"].append((datetime.datetime.now(), self.gener_id(), Volume_Discount_in))
		self._Volume_Discount = Volume_Discount_in

	def del_Volume_Discount(self):
		del self._Volume_Discount

	# _Program_Discount
	def get_Program_Discount(self):
		return self._Program_Discount

	def set_Program_Discount(self, Program_Discount_in):
		self.history["_Program_Discount"].append((datetime.datetime.now(), self.gener_id(), Program_Discount_in))
		self._Program_Discount = Program_Discount_in

	def del_Program_Discount(self):
		del self._Program_Discount

	# _Discount1_Name
	def get_Discount1_Name(self):
		return self._Discount1_Name

	def set_Discount1_Name(self, Discount1_Name_in):
		self.history["_Discount1_Name"].append((datetime.datetime.now(), self.gener_id(), Discount1_Name_in))
		self._Discount1_Name = Discount1_Name_in

	def del_Discount1_Name(self):
		del self._Discount1_Name

	# _Discount1_Type
	def get_Discount1_Type(self):
		return self._Discount1_Type

	def set_Discount1_Type(self, Discount1_Type_in):
		self.history["_Discount1_Type"].append((datetime.datetime.now(), self.gener_id(), Discount1_Type_in))
		self._Discount1_Type = Discount1_Type_in

	def del_Discount1_Type(self):
		del self._Discount1_Type

	# _Discount1
	def get_Discount1(self):
		return self._Discount1

	def set_Discount1(self, Discount1_in):
		self.history["_Discount1"].append((datetime.datetime.now(), self.gener_id(), Discount1_in))
		self._Discount1 = Discount1_in

	def del_Discount1(self):
		del self._Discount1

	# _Discount2_Name
	def get_Discount2_Name(self):
		return self._Discount2_Name

	def set_Discount2_Name(self, Discount2_Name_in):
		self.history["_Discount2_Name"].append((datetime.datetime.now(), self.gener_id(), Discount2_Name_in))
		self._Discount2_Name = Discount2_Name_in

	def del_Discount2_Name(self):
		del self._Discount2_Name

	# _Discount2_Type
	def get_Discount2_Type(self):
		return self._Discount2_Type

	def set_Discount2_Type(self, Discount2_Type_in):
		self.history["_Discount2_Type"].append((datetime.datetime.now(), self.gener_id(), Discount2_Type_in))
		self._Discount2_Type = Discount2_Type_in

	def del_Discount2_Type(self):
		del self._Discount2_Type

	# _Discount2
	def get_Discount2(self):
		return self._Discount2

	def set_Discount2(self, Discount2_in):
		self.history["_Discount2"].append((datetime.datetime.now(), self.gener_id(), Discount2_in))
		self._Discount2 = Discount2_in

	def del_Discount2(self):
		del self._Discount2

	# _Discount3_Name
	def get_Discount3_Name(self):
		return self._Discount3_Name

	def set_Discount3_Name(self, Discount3_Name_in):
		self.history["_Discount3_Name"].append((datetime.datetime.now(), self.gener_id(), Discount3_Name_in))
		self._Discount3_Name = Discount3_Name_in

	def del_Discount3_Name(self):
		del self._Discount3_Name

	# _Discount3_Type
	def get_Discount3_Type(self):
		return self._Discount3_Type

	def set_Discount3_Type(self, Discount3_Type_in):
		self.history["_Discount3_Type"].append((datetime.datetime.now(), self.gener_id(), Discount3_Type_in))
		self._Discount3_Type = Discount3_Type_in

	def del_Discount3_Type(self):
		del self._Discount3_Type

	# _Discount3
	def get_Discount3(self):
		return self._Discount3

	def set_Discount3(self, Discount3_in):
		self.history["_Discount3"].append((datetime.datetime.now(), self.gener_id(), Discount3_in))
		self._Discount3 = Discount3_in

	def del_Discount3(self):
		del self._Discount3

	# _Est_Pro_Date
	def get_Est_Pro_Date(self):
		return self._Est_Pro_Date

	def set_Est_Pro_Date(self, Est_Pro_Date_in):
		self.history["_Est_Pro_Date"].append((datetime.datetime.now(), self.gener_id(), Est_Pro_Date_in))
		self._Est_Pro_Date = Est_Pro_Date_in

	def del_Est_Pro_Date(self):
		del self._Est_Pro_Date

	# _Notes
	def get_Notes(self):
		return self._Notes

	def set_Notes(self, Notes_in):
		self.history["_Notes"].append((datetime.datetime.now(), self.gener_id(), Notes_in))
		self._Notes = Notes_in

	def del_Notes(self):
		del self._Notes

	# _EngNotes
	def get_EngNotes(self):
		return self._EngNotes

	def set_EngNotes(self, EngNotes_in):
		self.history["_EngNotes"].append((datetime.datetime.now(), self.gener_id(), EngNotes_in))
		self._EngNotes = EngNotes_in

	def del_EngNotes(self):
		del self._EngNotes

	# _CarrierID
	def get_CarrierID(self):
		return self._CarrierID

	def set_CarrierID(self, CarrierID_in):
		self.history["_CarrierID"].append((datetime.datetime.now(), self.gener_id(), CarrierID_in))
		self._CarrierID = CarrierID_in

	def del_CarrierID(self):
		del self._CarrierID

	# _CustID
	def get_CustID(self):
		return self._CustID

	def set_CustID(self, CustID_in):
		self.history["_CustID"].append((datetime.datetime.now(), self.gener_id(), CustID_in))
		self._CustID = CustID_in

	def del_CustID(self):
		del self._CustID

	# _US_Sale
	def get_US_Sale(self):
		return self._US_Sale

	def set_US_Sale(self, US_Sale_in):
		self.history["_US_Sale"].append((datetime.datetime.now(), self.gener_id(), US_Sale_in))
		self._US_Sale = US_Sale_in

	def del_US_Sale(self):
		del self._US_Sale

	# _Shipped_Date
	def get_Shipped_Date(self):
		return self._Shipped_Date

	def set_Shipped_Date(self, Shipped_Date_in):
		self.history["_Shipped_Date"].append((datetime.datetime.now(), self.gener_id(), Shipped_Date_in))
		self._Shipped_Date = Shipped_Date_in

	def del_Shipped_Date(self):
		del self._Shipped_Date

	# _GL_Override_Date
	def get_GL_Override_Date(self):
		return self._GL_Override_Date

	def set_GL_Override_Date(self, GL_Override_Date_in):
		self.history["_GL_Override_Date"].append((datetime.datetime.now(), self.gener_id(), GL_Override_Date_in))
		self._GL_Override_Date = GL_Override_Date_in

	def del_GL_Override_Date(self):
		del self._GL_Override_Date

	# _FE_Rate
	def get_FE_Rate(self):
		return self._FE_Rate

	def set_FE_Rate(self, FE_Rate_in):
		self.history["_FE_Rate"].append((datetime.datetime.now(), self.gener_id(), FE_Rate_in))
		self._FE_Rate = FE_Rate_in

	def del_FE_Rate(self):
		del self._FE_Rate

	# _PDD
	def get_PDD(self):
		return self._PDD

	def set_PDD(self, PDD_in):
		self.history["_PDD"].append((datetime.datetime.now(), self.gener_id(), PDD_in))
		self._PDD = PDD_in

	def del_PDD(self):
		del self._PDD

	# _Deck_Length
	def get_Deck_Length(self):
		return self._Deck_Length

	def set_Deck_Length(self, Deck_Length_in):
		self.history["_Deck_Length"].append((datetime.datetime.now(), self.gener_id(), Deck_Length_in))
		self._Deck_Length = Deck_Length_in

	def del_Deck_Length(self):
		del self._Deck_Length

	# _Invoice
	def get_Invoice(self):
		return self._Invoice

	def set_Invoice(self, Invoice_in):
		self.history["_Invoice"].append((datetime.datetime.now(), self.gener_id(), Invoice_in))
		self._Invoice = Invoice_in

	def del_Invoice(self):
		del self._Invoice

	# _Date_Registered
	def get_Date_Registered(self):
		return self._Date_Registered

	def set_Date_Registered(self, Date_Registered_in):
		self.history["_Date_Registered"].append((datetime.datetime.now(), self.gener_id(), Date_Registered_in))
		self._Date_Registered = Date_Registered_in

	def del_Date_Registered(self):
		del self._Date_Registered

	# _Date_In_Service
	def get_Date_In_Service(self):
		return self._Date_In_Service

	def set_Date_In_Service(self, Date_In_Service_in):
		self.history["_Date_In_Service"].append((datetime.datetime.now(), self.gener_id(), Date_In_Service_in))
		self._Date_In_Service = Date_In_Service_in

	def del_Date_In_Service(self):
		del self._Date_In_Service

	# _Invoice_Date
	def get_Invoice_Date(self):
		return self._Invoice_Date

	def set_Invoice_Date(self, Invoice_Date_in):
		self.history["_Invoice_Date"].append((datetime.datetime.now(), self.gener_id(), Invoice_Date_in))
		self._Invoice_Date = Invoice_Date_in

	def del_Invoice_Date(self):
		del self._Invoice_Date

	# _Date_Requested
	def get_Date_Requested(self):
		return self._Date_Requested

	def set_Date_Requested(self, Date_Requested_in):
		self.history["_Date_Requested"].append((datetime.datetime.now(), self.gener_id(), Date_Requested_in))
		self._Date_Requested = Date_Requested_in

	def del_Date_Requested(self):
		del self._Date_Requested

	# _GVWR
	def get_GVWR(self):
		return self._GVWR

	def set_GVWR(self, GVWR_in):
		self.history["_GVWR"].append((datetime.datetime.now(), self.gener_id(), GVWR_in))
		self._GVWR = GVWR_in

	def del_GVWR(self):
		del self._GVWR

	# _Tare
	def get_Tare(self):
		return self._Tare

	def set_Tare(self, Tare_in):
		self.history["_Tare"].append((datetime.datetime.now(), self.gener_id(), Tare_in))
		self._Tare = Tare_in

	def del_Tare(self):
		del self._Tare

	# _Selection
	def get_Selection(self):
		return self._Selection

	def set_Selection(self, Selection_in):
		self.history["_Selection"].append((datetime.datetime.now(), self.gener_id(), Selection_in))
		self._Selection = Selection_in

	def del_Selection(self):
		del self._Selection

	# _Warranty
	def get_Warranty(self):
		return self._Warranty

	def set_Warranty(self, Warranty_in):
		self.history["_Warranty"].append((datetime.datetime.now(), self.gener_id(), Warranty_in))
		self._Warranty = Warranty_in

	def del_Warranty(self):
		del self._Warranty

	# _BWSPaid
	def get_BWSPaid(self):
		return self._BWSPaid

	def set_BWSPaid(self, BWSPaid_in):
		self.history["_BWSPaid"].append((datetime.datetime.now(), self.gener_id(), BWSPaid_in))
		self._BWSPaid = BWSPaid_in

	def del_BWSPaid(self):
		del self._BWSPaid

	# _BWSPaidDate
	def get_BWSPaidDate(self):
		return self._BWSPaidDate

	def set_BWSPaidDate(self, BWSPaidDate_in):
		self.history["_BWSPaidDate"].append((datetime.datetime.now(), self.gener_id(), BWSPaidDate_in))
		self._BWSPaidDate = BWSPaidDate_in

	def del_BWSPaidDate(self):
		del self._BWSPaidDate

	# _CommPaid
	def get_CommPaid(self):
		return self._CommPaid

	def set_CommPaid(self, CommPaid_in):
		self.history["_CommPaid"].append((datetime.datetime.now(), self.gener_id(), CommPaid_in))
		self._CommPaid = CommPaid_in

	def del_CommPaid(self):
		del self._CommPaid

	# _CommPaidDate
	def get_CommPaidDate(self):
		return self._CommPaidDate

	def set_CommPaidDate(self, CommPaidDate_in):
		self.history["_CommPaidDate"].append((datetime.datetime.now(), self.gener_id(), CommPaidDate_in))
		self._CommPaidDate = CommPaidDate_in

	def del_CommPaidDate(self):
		del self._CommPaidDate

	# _ts_timestamp
	def get_ts_timestamp(self):
		return self._ts_timestamp

	def set_ts_timestamp(self, ts_timestamp_in):
		self.history["_ts_timestamp"].append((datetime.datetime.now(), self.gener_id(), ts_timestamp_in))
		self._ts_timestamp = ts_timestamp_in

	def del_ts_timestamp(self):
		del self._ts_timestamp

	# _ModifiedBy
	def get_ModifiedBy(self):
		return self._ModifiedBy

	def set_ModifiedBy(self, ModifiedBy_in):
		self.history["_ModifiedBy"].append((datetime.datetime.now(), self.gener_id(), ModifiedBy_in))
		self._ModifiedBy = ModifiedBy_in

	def del_ModifiedBy(self):
		del self._ModifiedBy

	# _Lead_Date
	def get_Lead_Date(self):
		return self._Lead_Date

	def set_Lead_Date(self, Lead_Date_in):
		self.history["_Lead_Date"].append((datetime.datetime.now(), self.gener_id(), Lead_Date_in))
		self._Lead_Date = Lead_Date_in

	def del_Lead_Date(self):
		del self._Lead_Date

	# _Lead_Source
	def get_Lead_Source(self):
		return self._Lead_Source

	def set_Lead_Source(self, Lead_Source_in):
		self.history["_Lead_Source"].append((datetime.datetime.now(), self.gener_id(), Lead_Source_in))
		self._Lead_Source = Lead_Source_in

	def del_Lead_Source(self):
		del self._Lead_Source

	# _LeadID
	def get_LeadID(self):
		return self._LeadID

	def set_LeadID(self, LeadID_in):
		self.history["_LeadID"].append((datetime.datetime.now(), self.gener_id(), LeadID_in))
		self._LeadID = LeadID_in

	def del_LeadID(self):
		del self._LeadID

	# _DealerBranchID
	def get_DealerBranchID(self):
		return self._DealerBranchID

	def set_DealerBranchID(self, DealerBranchID_in):
		self.history["_DealerBranchID"].append((datetime.datetime.now(), self.gener_id(), DealerBranchID_in))
		self._DealerBranchID = DealerBranchID_in

	def del_DealerBranchID(self):
		del self._DealerBranchID

	# _DealerSalesPersonID
	def get_DealerSalesPersonID(self):
		return self._DealerSalesPersonID

	def set_DealerSalesPersonID(self, DealerSalesPersonID_in):
		self.history["_DealerSalesPersonID"].append((datetime.datetime.now(), self.gener_id(), DealerSalesPersonID_in))
		self._DealerSalesPersonID = DealerSalesPersonID_in

	def del_DealerSalesPersonID(self):
		del self._DealerSalesPersonID

	# _DataEntryCheck
	def get_DataEntryCheck(self):
		return self._DataEntryCheck

	def set_DataEntryCheck(self, DataEntryCheck_in):
		self.history["_DataEntryCheck"].append((datetime.datetime.now(), self.gener_id(), DataEntryCheck_in))
		self._DataEntryCheck = DataEntryCheck_in

	def del_DataEntryCheck(self):
		del self._DataEntryCheck

	# _DataEntryUser
	def get_DataEntryUser(self):
		return self._DataEntryUser

	def set_DataEntryUser(self, DataEntryUser_in):
		self.history["_DataEntryUser"].append((datetime.datetime.now(), self.gener_id(), DataEntryUser_in))
		self._DataEntryUser = DataEntryUser_in

	def del_DataEntryUser(self):
		del self._DataEntryUser

	# _FinishedGoodsDealerLocID
	def get_FinishedGoodsDealerLocID(self):
		return self._FinishedGoodsDealerLocID

	def set_FinishedGoodsDealerLocID(self, FinishedGoodsDealerLocID_in):
		self.history["_FinishedGoodsDealerLocID"].append((datetime.datetime.now(), self.gener_id(), FinishedGoodsDealerLocID_in))
		self._FinishedGoodsDealerLocID = FinishedGoodsDealerLocID_in

	def del_FinishedGoodsDealerLocID(self):
		del self._FinishedGoodsDealerLocID

	# _WO_Reviewed
	def get_WO_Reviewed(self):
		return self._WO_Reviewed

	def set_WO_Reviewed(self, WO_Reviewed_in):
		self.history["_WO_Reviewed"].append((datetime.datetime.now(), self.gener_id(), WO_Reviewed_in))
		self._WO_Reviewed = WO_Reviewed_in

	def del_WO_Reviewed(self):
		del self._WO_Reviewed

	# _WO_Review_Date
	def get_WO_Review_Date(self):
		return self._WO_Review_Date

	def set_WO_Review_Date(self, WO_Review_Date_in):
		self.history["_WO_Review_Date"].append((datetime.datetime.now(), self.gener_id(), WO_Review_Date_in))
		self._WO_Review_Date = WO_Review_Date_in

	def del_WO_Review_Date(self):
		del self._WO_Review_Date

	# _Follow_Up_Date
	def get_Follow_Up_Date(self):
		return self._Follow_Up_Date

	def set_Follow_Up_Date(self, Follow_Up_Date_in):
		self.history["_Follow_Up_Date"].append((datetime.datetime.now(), self.gener_id(), Follow_Up_Date_in))
		self._Follow_Up_Date = Follow_Up_Date_in

	def del_Follow_Up_Date(self):
		del self._Follow_Up_Date

	# _MSOIsDifferent
	def get_MSOIsDifferent(self):
		return self._MSOIsDifferent

	def set_MSOIsDifferent(self, MSOIsDifferent_in):
		self.history["_MSOIsDifferent"].append((datetime.datetime.now(), self.gener_id(), MSOIsDifferent_in))
		self._MSOIsDifferent = MSOIsDifferent_in

	def del_MSOIsDifferent(self):
		del self._MSOIsDifferent

	# _MSOLocID
	def get_MSOLocID(self):
		return self._MSOLocID

	def set_MSOLocID(self, MSOLocID_in):
		self.history["_MSOLocID"].append((datetime.datetime.now(), self.gener_id(), MSOLocID_in))
		self._MSOLocID = MSOLocID_in

	def del_MSOLocID(self):
		del self._MSOLocID

	# _EstInvDateOverride
	def get_EstInvDateOverride(self):
		return self._EstInvDateOverride

	def set_EstInvDateOverride(self, EstInvDateOverride_in):
		self.history["_EstInvDateOverride"].append((datetime.datetime.now(), self.gener_id(), EstInvDateOverride_in))
		self._EstInvDateOverride = EstInvDateOverride_in

	def del_EstInvDateOverride(self):
		del self._EstInvDateOverride

	# _Estimated_Invoice_Date
	def get_Estimated_Invoice_Date(self):
		return self._Estimated_Invoice_Date

	def set_Estimated_Invoice_Date(self, Estimated_Invoice_Date_in):
		self.history["_Estimated_Invoice_Date"].append((datetime.datetime.now(), self.gener_id(), Estimated_Invoice_Date_in))
		self._Estimated_Invoice_Date = Estimated_Invoice_Date_in

	def del_Estimated_Invoice_Date(self):
		del self._Estimated_Invoice_Date

	# _AdditionalPricingInfo
	def get_AdditionalPricingInfo(self):
		return self._AdditionalPricingInfo

	def set_AdditionalPricingInfo(self, AdditionalPricingInfo_in):
		self.history["_AdditionalPricingInfo"].append((datetime.datetime.now(), self.gener_id(), AdditionalPricingInfo_in))
		self._AdditionalPricingInfo = AdditionalPricingInfo_in

	def del_AdditionalPricingInfo(self):
		del self._AdditionalPricingInfo

	# _Slot_Orders
	def get_Slot_Orders(self):
		return self._Slot_Orders

	def set_Slot_Orders(self, Slot_Orders_in):
		self.history["_Slot_Orders"].append((datetime.datetime.now(), self.gener_id(), Slot_Orders_in))
		self._Slot_Orders = Slot_Orders_in

	def del_Slot_Orders(self):
		del self._Slot_Orders

	# _TempModel
	def get_TempModel(self):
		return self._TempModel

	def set_TempModel(self, TempModel_in):
		self.history["_TempModel"].append((datetime.datetime.now(), self.gener_id(), TempModel_in))
		self._TempModel = TempModel_in

	def del_TempModel(self):
		del self._TempModel

	# _HighRiskUnit
	def get_HighRiskUnit(self):
		return self._HighRiskUnit

	def set_HighRiskUnit(self, HighRiskUnit_in):
		self.history["_HighRiskUnit"].append((datetime.datetime.now(), self.gener_id(), HighRiskUnit_in))
		self._HighRiskUnit = HighRiskUnit_in

	def del_HighRiskUnit(self):
		del self._HighRiskUnit

	# _EngNotes_V2
	def get_EngNotes_V2(self):
		return self._EngNotes_V2

	def set_EngNotes_V2(self, EngNotes_V2_in):
		self.history["_EngNotes_V2"].append((datetime.datetime.now(), self.gener_id(), EngNotes_V2_in))
		self._EngNotes_V2 = EngNotes_V2_in

	def del_EngNotes_V2(self):
		del self._EngNotes_V2

	# _CompanyID
	def get_CompanyID(self):
		return self._CompanyID

	def set_CompanyID(self, CompanyID_in):
		self.history["_CompanyID"].append((datetime.datetime.now(), self.gener_id(), CompanyID_in))
		self._CompanyID = CompanyID_in

	def del_CompanyID(self):
		del self._CompanyID

	# _Customer_WO
	def get_Customer_WO(self):
		return self._Customer_WO

	def set_Customer_WO(self, Customer_WO_in):
		self.history["_Customer_WO"].append((datetime.datetime.now(), self.gener_id(), Customer_WO_in))
		self._Customer_WO = Customer_WO_in

	def del_Customer_WO(self):
		del self._Customer_WO

	# _PriceSecured
	def get_PriceSecured(self):
		return self._PriceSecured

	def set_PriceSecured(self, PriceSecured_in):
		self.history["_PriceSecured"].append((datetime.datetime.now(), self.gener_id(), PriceSecured_in))
		self._PriceSecured = PriceSecured_in

	def del_PriceSecured(self):
		del self._PriceSecured

	# _DateSecured
	def get_DateSecured(self):
		return self._DateSecured

	def set_DateSecured(self, DateSecured_in):
		self.history["_DateSecured"].append((datetime.datetime.now(), self.gener_id(), DateSecured_in))
		self._DateSecured = DateSecured_in

	def del_DateSecured(self):
		del self._DateSecured

	# _SecuredBy
	def get_SecuredBy(self):
		return self._SecuredBy

	def set_SecuredBy(self, SecuredBy_in):
		self.history["_SecuredBy"].append((datetime.datetime.now(), self.gener_id(), SecuredBy_in))
		self._SecuredBy = SecuredBy_in

	def del_SecuredBy(self):
		del self._SecuredBy

	# _IsGalv
	def get_IsGalv(self):
		return self._IsGalv

	def set_IsGalv(self, IsGalv_in):
		self.history["_IsGalv"].append((datetime.datetime.now(), self.gener_id(), IsGalv_in))
		self._IsGalv = IsGalv_in

	def del_IsGalv(self):
		del self._IsGalv
		
	def get_company_name(self):
		return self._company_name
		
	def set_company_name(self, company_name_in):
		self._company_name = company_name_in
		
	def del_company_name(self):
		del self._company_name

	# _placed 
	def get_placed(self):
		return self._placed

	def set_placed(self, placed_in):
		assert isinstance(placed_in, bool), f"ERROR, param placed_in='{placed_in}' is not a boolean, got {type(placed_in)}."
		self.history["_placed"].append((datetime.datetime.now(), self.gener_id(), placed_in))
		self._placed = placed_in

	def del_placed(self):
		del self._placed

	# _init_placed 
	def get_init_placed(self):
		return self._init_placed

	def set_init_placed(self, init_placed_in):
		self.history["_init_placed"].append((datetime.datetime.now(), self.gener_id(), init_placed_in))
		self._init_placed = init_placed_in

	def del_init_placed(self):
		del self._init_placed

	# _gener
	def get_gener(self):
		return self._gener

	def set_gener(self, gener_in):
		self._gener = gener_in

	def del_gener(self):
		del self._gener

	# _history
	def get_history(self):
		return self._history

	def set_history(self, history_in):
		self._history = history_in

	def del_history(self):
		del self._history

	prod_sched_v2_id = property(get_prod_sched_v2_id, set_prod_sched_v2_id, del_prod_sched_v2_id)
	quote_v2 = property(get_quote_v2, set_quote_v2, del_quote_v2)
	wo_num_v2 = property(get_wo_num_v2, set_wo_num_v2, del_wo_num_v2)
	job_start_date_v2 = property(get_job_start_date_v2, set_job_start_date_v2, del_job_start_date_v2)
	job_finish_date_v2 = property(get_job_finish_date_v2, set_job_finish_date_v2, del_job_finish_date_v2)
	dtprodschedv2ts = property(get_dtprodschedv2ts, set_dtprodschedv2ts, del_dtprodschedv2ts)
	job_start_line_v2 = property(get_job_start_line_v2, set_job_start_line_v2, del_job_start_line_v2)
	hide_from_prod_input_v2 = property(get_hide_from_prod_input_v2, set_hide_from_prod_input_v2,
									   del_hide_from_prod_input_v2)
	InputField1_v2 = property(get_InputField1_v2, set_InputField1_v2, del_InputField1_v2)
	InputField2_v2 = property(get_InputField2_v2, set_InputField2_v2, del_InputField2_v2)
	ApplyUpdate_v2 = property(get_ApplyUpdate_v2, set_ApplyUpdate_v2, del_ApplyUpdate_v2)
	ApplyUpdateUser_v2 = property(get_ApplyUpdateUser_v2, set_ApplyUpdateUser_v2, del_ApplyUpdateUser_v2)
	prod_sched_id = property(get_prod_sched_id, set_prod_sched_id, del_prod_sched_id)
	quote = property(get_quote, set_quote, del_quote)
	wo_num = property(get_wo_num, set_wo_num, del_wo_num)
	InputField1 = property(get_InputField1, set_InputField1, del_InputField1)
	InputField2 = property(get_InputField2, set_InputField2, del_InputField2)
	Beam_Line = property(get_Beam_Line, set_Beam_Line, del_Beam_Line)
	Beam_Date = property(get_Beam_Date, set_Beam_Date, del_Beam_Date)
	GN_Line = property(get_GN_Line, set_GN_Line, del_GN_Line)
	GN_Date = property(get_GN_Date, set_GN_Date, del_GN_Date)
	WO_Line_1 = property(get_WO_Line_1, set_WO_Line_1, del_WO_Line_1)
	Prod_Date_1 = property(get_Prod_Date_1, set_Prod_Date_1, del_Prod_Date_1)
	WO_Line_2 = property(get_WO_Line_2, set_WO_Line_2, del_WO_Line_2)
	Prod_Date_2 = property(get_Prod_Date_2, set_Prod_Date_2, del_Prod_Date_2)
	Other = property(get_Other, set_Other, del_Other)
	Other_Line = property(get_Other_Line, set_Other_Line, del_Other_Line)
	Other_Date = property(get_Other_Date, set_Other_Date, del_Other_Date)
	HideFromProdInput = property(get_HideFromProdInput, set_HideFromProdInput, del_HideFromProdInput)
	Step1SYSPROBudget = property(get_Step1SYSPROBudget, set_Step1SYSPROBudget, del_Step1SYSPROBudget)
	Step2SYSPROBudget = property(get_Step2SYSPROBudget, set_Step2SYSPROBudget, del_Step2SYSPROBudget)
	dtprodschedts = property(get_dtprodschedts, set_dtprodschedts, del_dtprodschedts)
	ApplyUpdate = property(get_ApplyUpdate, set_ApplyUpdate, del_ApplyUpdate)
	ApplyUpdateUser = property(get_ApplyUpdateUser, set_ApplyUpdateUser, del_ApplyUpdateUser)
	Slot = property(get_Slot, set_Slot, del_Slot)
	Slot_Quote = property(get_Slot_Quote, set_Slot_Quote, del_Slot_Quote)
	Slot_Approved = property(get_Slot_Approved, set_Slot_Approved, del_Slot_Approved)
	Prod_On = property(get_Prod_On, set_Prod_On, del_Prod_On)
	Prod_On_Time = property(get_Prod_On_Time, set_Prod_On_Time, del_Prod_On_Time)
	Prod_Off = property(get_Prod_Off, set_Prod_Off, del_Prod_Off)
	Prod_Off_Time = property(get_Prod_Off_Time, set_Prod_Off_Time, del_Prod_Off_Time)
	Prod_PM = property(get_Prod_PM, set_Prod_PM, del_Prod_PM)
	Prod_Complete = property(get_Prod_Complete, set_Prod_Complete, del_Prod_Complete)
	Prod2_On = property(get_Prod2_On, set_Prod2_On, del_Prod2_On)
	Prod2_On_Time = property(get_Prod2_On_Time, set_Prod2_On_Time, del_Prod2_On_Time)
	Prod2_Off = property(get_Prod2_Off, set_Prod2_Off, del_Prod2_Off)
	Prod2_Off_Time = property(get_Prod2_Off_Time, set_Prod2_Off_Time, del_Prod2_Off_Time)
	Prod2_PM = property(get_Prod2_PM, set_Prod2_PM, del_Prod2_PM)
	Prod2_Complete = property(get_Prod2_Complete, set_Prod2_Complete, del_Prod2_Complete)
	Prod_Instructions = property(get_Prod_Instructions, set_Prod_Instructions, del_Prod_Instructions)
	Beam_On = property(get_Beam_On, set_Beam_On, del_Beam_On)
	Beam_Off = property(get_Beam_Off, set_Beam_Off, del_Beam_Off)
	Beam_Complete = property(get_Beam_Complete, set_Beam_Complete, del_Beam_Complete)
	Beam_PM = property(get_Beam_PM, set_Beam_PM, del_Beam_PM)
	Beam_Instructions = property(get_Beam_Instructions, set_Beam_Instructions, del_Beam_Instructions)
	GN_On = property(get_GN_On, set_GN_On, del_GN_On)
	GN_Off = property(get_GN_Off, set_GN_Off, del_GN_Off)
	GN_Complete = property(get_GN_Complete, set_GN_Complete, del_GN_Complete)
	GN_PM = property(get_GN_PM, set_GN_PM, del_GN_PM)
	GN_Instructions = property(get_GN_Instructions, set_GN_Instructions, del_GN_Instructions)
	Axle = property(get_Axle, set_Axle, del_Axle)
	Axle_On = property(get_Axle_On, set_Axle_On, del_Axle_On)
	Axle_Off = property(get_Axle_Off, set_Axle_Off, del_Axle_Off)
	Axle_Complete = property(get_Axle_Complete, set_Axle_Complete, del_Axle_Complete)
	Axle_PM = property(get_Axle_PM, set_Axle_PM, del_Axle_PM)
	Axle_Instructions = property(get_Axle_Instructions, set_Axle_Instructions, del_Axle_Instructions)
	Other_On = property(get_Other_On, set_Other_On, del_Other_On)
	Other_On_Time = property(get_Other_On_Time, set_Other_On_Time, del_Other_On_Time)
	Other_Off = property(get_Other_Off, set_Other_Off, del_Other_Off)
	Other_Off_Time = property(get_Other_Off_Time, set_Other_Off_Time, del_Other_Off_Time)
	Other_Complete = property(get_Other_Complete, set_Other_Complete, del_Other_Complete)
	Other_PM = property(get_Other_PM, set_Other_PM, del_Other_PM)
	Other_Instructions = property(get_Other_Instructions, set_Other_Instructions, del_Other_Instructions)
	Stargate_WO = property(get_Stargate_WO, set_Stargate_WO, del_Stargate_WO)
	OrderID = property(get_OrderID, set_OrderID, del_OrderID)
	SGQuote = property(get_SGQuote, set_SGQuote, del_SGQuote)
	Quote_Date = property(get_Quote_Date, set_Quote_Date, del_Quote_Date)
	Order_Date = property(get_Order_Date, set_Order_Date, del_Order_Date)
	WO = property(get_WO, set_WO, del_WO)
	Sales_Order = property(get_Sales_Order, set_Sales_Order, del_Sales_Order)
	Model_No = property(get_Model_No, set_Model_No, del_Model_No)
	Width = property(get_Width, set_Width, del_Width)
	Spread = property(get_Spread, set_Spread, del_Spread)
	DealerID = property(get_DealerID, set_DealerID, del_DealerID)
	Sale_PersonID = property(get_Sale_PersonID, set_Sale_PersonID, del_Sale_PersonID)
	Price = property(get_Price, set_Price, del_Price)
	Prom_Drawing = property(get_Prom_Drawing, set_Prom_Drawing, del_Prom_Drawing)
	Special_Instructions = property(get_Special_Instructions, set_Special_Instructions, del_Special_Instructions)
	Date_Declined = property(get_Date_Declined, set_Date_Declined, del_Date_Declined)
	Decline_Rejected = property(get_Decline_Rejected, set_Decline_Rejected, del_Decline_Rejected)
	Serial_Number = property(get_Serial_Number, set_Serial_Number, del_Serial_Number)
	Available_Date = property(get_Available_Date, set_Available_Date, del_Available_Date)
	Delivery_Date = property(get_Delivery_Date, set_Delivery_Date, del_Delivery_Date)
	Requested_Delivery_Date = property(get_Requested_Delivery_Date, set_Requested_Delivery_Date,
									   del_Requested_Delivery_Date)
	Finish_Date = property(get_Finish_Date, set_Finish_Date, del_Finish_Date)
	Purchase_Order = property(get_Purchase_Order, set_Purchase_Order, del_Purchase_Order)
	PO_Date = property(get_PO_Date, set_PO_Date, del_PO_Date)
	PayID = property(get_PayID, set_PayID, del_PayID)
	Volume_Discount = property(get_Volume_Discount, set_Volume_Discount, del_Volume_Discount)
	Program_Discount = property(get_Program_Discount, set_Program_Discount, del_Program_Discount)
	Discount1_Name = property(get_Discount1_Name, set_Discount1_Name, del_Discount1_Name)
	Discount1_Type = property(get_Discount1_Type, set_Discount1_Type, del_Discount1_Type)
	Discount1 = property(get_Discount1, set_Discount1, del_Discount1)
	Discount2_Name = property(get_Discount2_Name, set_Discount2_Name, del_Discount2_Name)
	Discount2_Type = property(get_Discount2_Type, set_Discount2_Type, del_Discount2_Type)
	Discount2 = property(get_Discount2, set_Discount2, del_Discount2)
	Discount3_Name = property(get_Discount3_Name, set_Discount3_Name, del_Discount3_Name)
	Discount3_Type = property(get_Discount3_Type, set_Discount3_Type, del_Discount3_Type)
	Discount3 = property(get_Discount3, set_Discount3, del_Discount3)
	Est_Pro_Date = property(get_Est_Pro_Date, set_Est_Pro_Date, del_Est_Pro_Date)
	Notes = property(get_Notes, set_Notes, del_Notes)
	EngNotes = property(get_EngNotes, set_EngNotes, del_EngNotes)
	CarrierID = property(get_CarrierID, set_CarrierID, del_CarrierID)
	CustID = property(get_CustID, set_CustID, del_CustID)
	US_Sale = property(get_US_Sale, set_US_Sale, del_US_Sale)
	Shipped_Date = property(get_Shipped_Date, set_Shipped_Date, del_Shipped_Date)
	GL_Override_Date = property(get_GL_Override_Date, set_GL_Override_Date, del_GL_Override_Date)
	FE_Rate = property(get_FE_Rate, set_FE_Rate, del_FE_Rate)
	PDD = property(get_PDD, set_PDD, del_PDD)
	Deck_Length = property(get_Deck_Length, set_Deck_Length, del_Deck_Length)
	Invoice = property(get_Invoice, set_Invoice, del_Invoice)
	Date_Registered = property(get_Date_Registered, set_Date_Registered, del_Date_Registered)
	Date_In_Service = property(get_Date_In_Service, set_Date_In_Service, del_Date_In_Service)
	Invoice_Date = property(get_Invoice_Date, set_Invoice_Date, del_Invoice_Date)
	Date_Requested = property(get_Date_Requested, set_Date_Requested, del_Date_Requested)
	GVWR = property(get_GVWR, set_GVWR, del_GVWR)
	Tare = property(get_Tare, set_Tare, del_Tare)
	Selection = property(get_Selection, set_Selection, del_Selection)
	Warranty = property(get_Warranty, set_Warranty, del_Warranty)
	BWSPaid = property(get_BWSPaid, set_BWSPaid, del_BWSPaid)
	BWSPaidDate = property(get_BWSPaidDate, set_BWSPaidDate, del_BWSPaidDate)
	CommPaid = property(get_CommPaid, set_CommPaid, del_CommPaid)
	CommPaidDate = property(get_CommPaidDate, set_CommPaidDate, del_CommPaidDate)
	ts_timestamp = property(get_ts_timestamp, set_ts_timestamp, del_ts_timestamp)
	ModifiedBy = property(get_ModifiedBy, set_ModifiedBy, del_ModifiedBy)
	Lead_Date = property(get_Lead_Date, set_Lead_Date, del_Lead_Date)
	Lead_Source = property(get_Lead_Source, set_Lead_Source, del_Lead_Source)
	LeadID = property(get_LeadID, set_LeadID, del_LeadID)
	DealerBranchID = property(get_DealerBranchID, set_DealerBranchID, del_DealerBranchID)
	DealerSalesPersonID = property(get_DealerSalesPersonID, set_DealerSalesPersonID, del_DealerSalesPersonID)
	DataEntryCheck = property(get_DataEntryCheck, set_DataEntryCheck, del_DataEntryCheck)
	DataEntryUser = property(get_DataEntryUser, set_DataEntryUser, del_DataEntryUser)
	FinishedGoodsDealerLocID = property(get_FinishedGoodsDealerLocID, set_FinishedGoodsDealerLocID,
										del_FinishedGoodsDealerLocID)
	WO_Reviewed = property(get_WO_Reviewed, set_WO_Reviewed, del_WO_Reviewed)
	WO_Review_Date = property(get_WO_Review_Date, set_WO_Review_Date, del_WO_Review_Date)
	Follow_Up_Date = property(get_Follow_Up_Date, set_Follow_Up_Date, del_Follow_Up_Date)
	MSOIsDifferent = property(get_MSOIsDifferent, set_MSOIsDifferent, del_MSOIsDifferent)
	MSOLocID = property(get_MSOLocID, set_MSOLocID, del_MSOLocID)
	EstInvDateOverride = property(get_EstInvDateOverride, set_EstInvDateOverride, del_EstInvDateOverride)
	Estimated_Invoice_Date = property(get_Estimated_Invoice_Date, set_Estimated_Invoice_Date,
									  del_Estimated_Invoice_Date)
	AdditionalPricingInfo = property(get_AdditionalPricingInfo, set_AdditionalPricingInfo, del_AdditionalPricingInfo)
	Slot_Orders = property(get_Slot_Orders, set_Slot_Orders, del_Slot_Orders)
	TempModel = property(get_TempModel, set_TempModel, del_TempModel)
	HighRiskUnit = property(get_HighRiskUnit, set_HighRiskUnit, del_HighRiskUnit)
	EngNotes_V2 = property(get_EngNotes_V2, set_EngNotes_V2, del_EngNotes_V2)
	CompanyID = property(get_CompanyID, set_CompanyID, del_CompanyID)
	Customer_WO = property(get_Customer_WO, set_Customer_WO, del_Customer_WO)
	PriceSecured = property(get_PriceSecured, set_PriceSecured, del_PriceSecured)
	DateSecured = property(get_DateSecured, set_DateSecured, del_DateSecured)
	SecuredBy = property(get_SecuredBy, set_SecuredBy, del_SecuredBy)
	IsGalv = property(get_IsGalv, set_IsGalv, del_IsGalv)
	company_name = property(get_company_name, set_company_name, del_company_name)
	placed = property(get_placed, set_placed, del_placed)
	init_placed = property(get_init_placed, set_init_placed, del_init_placed)
	gener = property(get_gener, set_gener, del_gener)
	history = property(get_history, set_history, del_history)

	def undo(self):
		last_event = None
		for k, v in self.history.items():
			t, val = v[-1]
			if last_event is None or last_event[0] < t:
				last_event = t, k, val
		t, k, val = last_event
		record = self.history[k]
		if len(record) > 1:
			prev = record[-2]
			setattr(self, k, prev)
			self.history[k].pop(-1)


if __name__ == "__main__":
	from stg_queries import *
	from pyodbc_connection import connect
	df = connect(**SQL_ALL_DATED_STG_UNITS_TEST)
	row_gen = df.iterrows()
	row = next(row_gen)
	unit_1 = Unit(*row[1].tolist()).init()
	print(f"{unit_1.__dict__=}")
	from property_boilerplate import property_boilerplate
	property_boilerplate(unit_1)
