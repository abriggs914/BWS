import win32print
import win32api

GHOSTSCRIPT_PATH = "C:\\path\\to\\GHOSTSCRIPT\\bin\\gswin32.exe"
GSPRINT_PATH = "C:\\path\\to\\GSPRINT\\gsprint.exe"

GHOSTSCRIPT_PATH = r"""C:\GSPrint\Script\bin\gswin32.exe"""
GSPRINT_PATH = r"""C:\GSPrint\Print\gsprint.exe"""

# YOU CAN PUT HERE THE NAME OF YOUR SPECIFIC PRINTER INSTEAD OF DEFAULT
currentprinter = win32print.GetDefaultPrinter()

pdf_name = r"""ProdSched_V1_2021-01-01--2021-01-31.pdf"""


#  72 Pts / Inch
#  11"x17" -> 72*11x72*17 -> 792x1224 -> 1224x792
ddwp = 1224
ddhp = 792
# win32api.ShellExecute(0, 'open', GSPRINT_PATH, '-ghostscript "'+GHOSTSCRIPT_PATH+'" -printer "'+currentprinter+'" "{}"'.format(pdf_name), '.', 0)
# win32api.ShellExecute(0, 'open', GSPRINT_PATH, '-ghostscript "'+GHOSTSCRIPT_PATH+'" -printer "'+currentprinter+'" -dDEVICEWIDTHPOINTS={ddwp} -dDEVICEHEIGHTPOINTS={ddhp} -dPDFFitPage "{pdf}"'.format(ddwp=ddwp, ddhp=ddhp, pdf=pdf_name), '.', 0)
win32api.ShellExecute(0, 'open', GSPRINT_PATH, '-ghostscript "'+GHOSTSCRIPT_PATH+'" -printer "'+currentprinter+'" -sPAPERSIZE=tabloid -dDuplex "{pdf}"'.format(ddwp=ddwp, ddhp=ddhp, pdf=pdf_name), '.', 0)

