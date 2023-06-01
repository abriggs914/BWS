ftk = ["ITA Copy DBs", "ITR Adjust Due Date", "ITR Admin", "ITR Admin Override", "ITR Admin SubForm", "ITR Cancellation Reason Input", "ITR Custom Colour Selector", "ITR DB Updates Input", "ITR Edit", "ITR Edit Params", "ITR Input", "ITR Input 2023-05-08", "ITR Input Vertical", "ITR Labour Help", "ITR Name Colour Scheme", "ITR New Customer", "ITR Open Requests Dashboard", "ITR Open Requests Dashboard Sub", "ITR Personnel Assignments", "ITR Personnel Assignments Breakdown", "ITR Predict Labour", "ITR Priority Help", "ITR Reporting Params", "ITR ToDo List Input", "ITR Top 20 Outstanding Requests Params"]
save_lines = [f"Application.saveastext acform, \"{f}\", \"C:\\Access\\FORM__{f}.txt\"" for f in ftk]
load_lines = [f"Application.loadfromtext acform, \"{f}\", \"C:\\Access\\FORM__{f}.txt\"" for f in ftk]

f_load = lambda form_names: [f"Application.loadfromtext acform, \"{f}\", \"C:\\Access\\FORM__{f}.txt\"" for f in form_names]
f_save = lambda form_names: [f"Application.saveastext acform, \"{f}\", \"C:\\Access\\FORM__{f}.txt\"" for f in form_names]
f_lines = lambda form_names: (f_load(form_names), f_save(form_names))

def gen_lines(obj_names, typ = Literal["acForm", "acReport", "acModule", "acMacro", "acTable", "acQuery"]):
	text_headers = {k: k[2:].upper() for k in ["acForm", "acReport", "acModule", "acMacro", "acTable", "acQuery"]}
	f_load = lambda names: [f"Application.loadfromtext {typ}, \"{f}\", \"C:\\Access\\{text_headers[typ]}__{f}.txt\"" for f in names]
	f_save = lambda names: [f"Application.saveastext {typ}, \"{f}\", \"C:\\Access\\{text_headers[typ]}__{f}.txt\"" for f in names]
	return f_load(obj_names), f_save(obj_names)
	

lttk = ["dtITR Custom Colour Scheme", "dtITR Edit", "dtITR Input", "dtITR Name Colour Scheme", "dtITR ToDo List", "dtITR Requests", "ITR Admin Override", "ITR Dummy Table", "ITR Supported Fonts"]
sttk = ["ITR ColourSchemes", "ITR Customers", "ITR Hardware", "ITR Merit", "ITR Personnel", "ITR Settings", "ITR Software", "ITR Status", "ITR Training", "ITRequests", "v_ITRAllRequesters", "v_ITRequestsPerMonthTotals", "v_ITRRequestsByDeptByMonth", "v_ITRRequestThroughput"]