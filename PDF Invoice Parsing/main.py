import asyncio
import time
import re
import os
import pandas as pd
import PyPDF2

from datetime_utility import date_str_format
from utility import *


# Rule 1
# Laser Amp Order Numbers MUST be 6 digits.
LEN_ORDER_NUMBER = 6

# Rule 2
# Laser Amp Part Numbers come in 2 varieties:
#   -   Including a '-' in the 5th (0-index) position, surrounded by a number of characters.
#   -   ex:
#   -       00108-40973198
#   -       00108-40973156
#   -   Including the prefix '242.' followed by some number of characters.
#   -   ex:
#   -       242.40994128
#   -       242.22200870
#
# This is critical for parsing the quantities value.


# def parse_pdf(dir):
#     # text, qtys, p_nums, revs, prices, amounts, invoice, order
#     return 0, 1, 2, 3, 4, 5, 6, 7


async def process_pdf(fn, fails, files, qtys, p_nums, revs, prices, amounts, invoices, orders):
    # fn = r"C:\Users\ABriggs\Downloads\2023-04 LASER AMP 244246 PO 140194 POSTED.pdf"

    print(f"processing '{fn}'")

    known_prefixes = ("242.")
    f0, f1, f2, f3, f4, f5, f6, f7, f8, f9 = [True for i in range(10)]
    text = ""

    try:

        # open the PDF file in binary mode
        with open(fn, 'rb') as f:
            # create a PDF reader object
            pdf_reader = PyPDF2.PdfFileReader(f)
            # pdf_reader = PdfReader(f)
            # read each page of the PDF file
            for page_num in range(pdf_reader.numPages):
                page = pdf_reader.getPage(page_num)
                # extract text from the page
                page_text = page.extractText()
                # append the text from this page to the overall text
                text += page_text
        f0 = False

        # t1 = "Expédié via / Ship Via No commande / Order number Incoterms Termes / Terms Date No client Customer No. Page"
        # print(f"{text.count(t1)=}")

        splitter1 = 0, "Price Montant"
        splitter2 = 0, "Montant / amount"
        splitter3 = 0, "Page"
        splitter = splitter3
        num_pages = text.count(splitter[1])
        num_pages1 = text.count(splitter1[1])
        num_pages2 = text.count(splitter2[1])
        num_pages3 = text.count(splitter3[1])
        # idx_0 = text.index(splitter[1])
        print(f"{text=}")
        print(f"{num_pages=}")
        print(f"{num_pages1=}")
        print(f"{num_pages2=}")
        print(f"{num_pages3=}")
        if num_pages1 == 0:
            num_pages1 = num_pages2
            print(f"NEW {num_pages1=}")

        if num_pages1 == 0:
            splitter = -1, ""

        print(f"{splitter=}")
        rows = text.split(splitter[1])[1:]
        f1 = False
        # print(f"A {values=}")
        # rows = values.split("\n")
        columns = [
            "Qté /qty",
            "Numéro de pièce / Part Number",
            "Rev.",
            "Prix /Price",
            "Montant / amount"
        ]
        print(f"{rows=}")
        # invoice, order = "INVOICE", "ORDER"
        invoice_number = None
        order_number = None
        for i, row in enumerate(rows):
            if row:
                vals_list = list(row.split("\n"))  # [1].split(" ")
                # print("\nVALS")

                for j, vl in enumerate(vals_list):
                    print(f"\t{j=}, {vl=}")

                # print_by_line(vals)
                for j, val_s in enumerate(vals_list):
                    f2, f3, f4, f5, f6, f7, f8, f9 = [True for k in range(8)]
                    print(f"{val_s=}")
                    if "No.:" in val_s:
                        print(f"FOUND 1 {val_s=}")
                        val_stp = val_s.split("No.:")
                        left, right = val_stp[-2].split(" ")[-1].strip(), val_stp[-1].strip()
                        print(f"{left=}, {right=}")
                        l_match = re.search(r'(\d+)No\.:', val_s)
                        r_match = re.search(r'No\.:(\d+)', val_s)

                        if r_match:
                            invoice_number = int(r_match.group(1))
                        else:
                            invoice_number = int(l_match.group(1))
                        order_number = "ORDER_NUMBER"
                        f2 = False
                        # order_number = int(val_s.split("No.:")[0].split(" ")[-1].strip())
                        f3 = False
                        print(f"FOUND 1\n\t{val_s=}\n\t{invoice_number}\n\t{order_number}")

                    vals = val_s.split(" ")
                    print(f"l={len(vals)}, {vals=}")
                    if len(vals) == 4:
                        try:
                            # print(f"{row=}, {vals=}, {splitter=}")
                            # if splitter[0] == 0:
                            qty_part_number, rev, price, amount = vals
                            if qty_part_number.startswith("$") and "." in qty_part_number:
                                # looks like a money value was parsed first.
                                amount, price, rev, qty_part_number = qty_part_number, rev, price, amount
                            f4 = False
                            qty = 0
                            part_number = "UNKNOWN"
                            for k, kp in enumerate(known_prefixes):
                                if kp in qty_part_number:
                                    if k != 0:
                                        # k[0] = "-"
                                        qty, part_number = qty_part_number.split(kp)
                                    else:
                                        part_number = qty_part_number.split(kp)[-1]
                                        idx = qty_part_number.index("-")
                                        f6 = False
                                        part_number = f"{qty_part_number[idx - 5:idx]}-{part_number}"
                                        f7 = False
                                        qty = int(qty_part_number[:idx][:-5])
                                        f8 = False
                                    break
                            # f5 = False
                            # idx = qty_part_number.index("-")
                            # f6 = False
                            # part_number = f"{qty_part_number[idx - 5:idx]}-{part_number}"
                            # f7 = False
                            # qty = int(qty_part_number[:idx][:-5])
                            # f8 = False
                            # else:
                            #     part_number, qty, amount, price, rev = vals
                            #     f4 = False

                            qty = int(qty)
                            f9 = False
                            # print(f"{qty=}, {part_number=}, {int(rev)=}, {money_value(price)=}, {money_value(amount)=}")
                        except (TypeError, ValueError) as e:
                            print(f"{e=}")
                            pass
                        else:
                            # print(f"ELSE")
                            qtys.append(qty)
                            p_nums.append(part_number)
                            revs.append(rev)
                            prices.append(price)
                            amounts.append(amount)
                            invoices.append(invoice_number)
                            orders.append(order_number)
                            files.append(fn)
    except (ValueError, TypeError, KeyError, AttributeError):
        msg = []
        if f0:
            # all failed except text
            msg.append("all failed except text")
            print(f"f0 -- {msg[-1]} -- {fn}")
        if f1:
            # splitting failed
            msg.append("splitting failed")
            print(f"f1 -- {msg[-1]} -- {fn}")
        if f2:
            # invoice_number failed
            msg.append("invoice_number failed")
            print(f"f2 -- {msg[-1]} -- {fn}")
        if f3:
            # order_number failed
            msg.append("order_number failed")
            print(f"f3 -- {msg[-1]} -- {fn}")
        if f4:
            # unpacking vals failed
            msg.append("unpacking vals failed")
            print(f"f4 -- {msg[-1]} -- {fn}")
        if f5:
            # qty_part_number split failed
            msg.append("qty_part_number split failed")
            print(f"f5 -- {msg[-1]} -- {fn}")
        if f6:
            # qty_part_number index failed
            msg.append("qty_part_number index failed")
            print(f"f6 -- {msg[-1]} -- {fn}")
        if f7:
            # part_number slicing failed
            msg.append("part_number slicing failed")
            print(f"f7 -- {msg[-1]} -- {fn}")
        if f8:
            # int qty_number failed
            msg.append("int qty_number failed")
            print(f"f8 -- {msg[-1]} -- {fn}")
        if f9:
            # int qty failed
            msg.append("int qty failed")
            print(f"f9 -- {msg[-1]} -- {fn}")
        # if f10:
        #     # int rev failed
        #     msg.append("int rev failed")
        #     print(f"f10 -- {msg[-1]} -- {fn}")

        s_msg = "|||".join(msg)
        fails.append(f"{fn}|||{s_msg}")

    print(f"{fails=}, {text=}, {files=}, {qtys=}, {p_nums=}, {revs=}, {prices=}, {amounts=}, {invoices=}, {orders=}")
    return fails, text, files, qtys, p_nums, revs, prices, amounts, invoices, orders


async def test_batch_laser_amp(root_in=None, stop_num=None):
    timings["batch_start"] = time.time()
    root_laser_amp = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP"
    root_laser_amp = root_laser_amp if root_in is None else root_in
    sub_dirs = [(f"{root_laser_amp}\\{s_d}", "", "") for s_d in os.listdir(root_laser_amp)]

    i = 0
    files = {}
    file_template = [
        "file_name",
        "p_dir",
        "s_dir",
        "text_extracted",
        "invoice",
        "order_number",
        "data"
    ]
    data_template = [
        "qty",
        "part_number",
        "rev",
        "price",
        "amount"
    ]

    k1 = None

    while sub_dirs:
        a, b, c = sub_dirs.pop(0)
        # s_s_dirs = '\n'.join(a)
        # print(f"\n{i=}\n{files=}\ns_s_dirs=\n{s_s_dirs}")
        p_dir = a
        if os.path.isfile(p_dir) and p_dir.endswith(".pdf"):
            if k1 is None:
                k1 = p_dir
            # text, qtys, p_nums, revs, prices, amounts, invoice, order = parse_pdf(p_dir)
            # data_values = [qtys, p_nums, revs, prices, amounts]
            # data = dict(zip(data_template, data_values))
            data = {}
            # file_values = [p_dir, b, c, text, invoice, order, data]
            file_values = [p_dir, b, c, None, None, None, data]
            files[p_dir] = dict(zip(file_template, file_values))
        elif os.path.isdir(p_dir):
            for s_dir in os.listdir(p_dir):
                # print(f"{p_dir=}, {s_dir=}")
                sub_dirs.append((f"{p_dir}\\{s_dir}", p_dir, s_dir))
        else:
            print(f"unsure what to do with path '{p_dir}'")
        i += 1

    tasks = []
    # print(f"{files=}")
    print(f"{k1=}")
    print(f"{len(files)=}")
    print(f"{list(files.keys())=}")
    print(f"{list(files[k1].keys())=}")
    print(f"\n\n\tfiles[k1]\n")
    for i, k_v in enumerate(files[k1].items()):
        k, v = k_v
        print(f"{i=}, {k=}, {v=}")
    print(f"\n\n")
    # print(f"{list(files[k1]['data'])=}")
    fails, qtys, files_l, p_nums, revs, prices, amounts, invoices, orders = [], [], [], [], [], [], [], [], []
    for i, file in enumerate(files):
        tasks.append(asyncio.create_task(process_pdf(file, fails, files_l, qtys, p_nums, revs, prices, amounts, invoices, orders)))
        if (i + 1) == stop_num:
            break
        # text, qtys, p_nums, revs, prices, amounts, invoice, order = parse_pdf(p_dir)
        # data_values = [qtys, p_nums, revs, prices, amounts]
        # data = dict(zip(data_template, data_values))

    timings["batch_end"] = time.time()
    return asyncio.gather(*tasks)


    # for i, f_name in enumerate(files):


def collect_files(root_in):

    timings["batch_start"] = time.time()
    root_laser_amp = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP"
    root_laser_amp = root_laser_amp if root_in is None else root_in
    sub_dirs = [(f"{root_laser_amp}\\{s_d}", "", "") for s_d in os.listdir(root_laser_amp)]

    i = 0
    files = {}
    file_template = [
        "file_name",
        "p_dir",
        "s_dir",
        "text_extracted",
        "invoice",
        "order_number",
        "data"
    ]
    data_template = [
        "qty",
        "part_number",
        "rev",
        "price",
        "amount"
    ]

    k1 = None

    while sub_dirs:
        a, b, c = sub_dirs.pop(0)
        # s_s_dirs = '\n'.join(a)
        # print(f"\n{i=}\n{files=}\ns_s_dirs=\n{s_s_dirs}")
        p_dir = a
        if os.path.isfile(p_dir) and p_dir.endswith(".pdf"):
            if k1 is None:
                k1 = p_dir
            # text, qtys, p_nums, revs, prices, amounts, invoice, order = parse_pdf(p_dir)
            # data_values = [qtys, p_nums, revs, prices, amounts]
            # data = dict(zip(data_template, data_values))
            data = {}
            # file_values = [p_dir, b, c, text, invoice, order, data]
            file_values = [p_dir, b, c, None, None, None, data]
            files[p_dir] = dict(zip(file_template, file_values))
        elif os.path.isdir(p_dir):
            for s_dir in os.listdir(p_dir):
                # print(f"{p_dir=}, {s_dir=}")
                sub_dirs.append((f"{p_dir}\\{s_dir}", p_dir, s_dir))
        else:
            print(f"unsure what to do with path '{p_dir}'")
        i += 1
    return files


def scratch(root_in):
    text = ""
    pages = []

    def f1(s):
        i = s.index("-")
        return s[:i - 5], s[i - 5:i] + s[i:]

    def f2(s):
        i = s.index("242.")
        return s[:i], s[i:]

    known_prefixes = {
        "-": lambda s: f1(s),
        "242.": lambda s: f2(s)
    }

    files = collect_files(root_in)
    file = None
    for i, file in enumerate(files):
        # tasks.append(asyncio.create_task(process_pdf(file, fails, files_l, qtys, p_nums, revs, prices, amounts, invoices, orders)))
        if i == 0:
            break
    fn = files[file]["file_name"]
    print(f"processing '{fn}'")

    page_idxs, fails, qtys, passes, p_nums, revs, prices, amounts, invoices, orders = [], [], [], [], [], [], [], [], [], []

    try:

        # open the PDF file in binary mode
        with open(fn, 'rb') as f:
            # create a PDF reader object
            pdf_reader = PyPDF2.PdfFileReader(f)
            # pdf_reader = PdfReader(f)
            # read each page of the PDF file
            for page_num in range(pdf_reader.numPages):
                page = pdf_reader.getPage(page_num)
                # extract text from the page
                page_text = page.extractText()
                # append the text from this page to the overall text
                text += page_text

        # t1 = "Expédié via / Ship Via No commande / Order number Incoterms Termes / Terms Date No client Customer No. Page"
        # print(f"{text.count(t1)=}")

        invoice_number = None
        order_number = None
        splitter = 0, "Page"
        in_spl_invoice = "No.:"
        in_spl_order_1 = "TermsIncoterms"
        in_spl_order_2 = "PICK-UP "
        num_pages = text.count(splitter[1])
        print(f"{text=}")
        print(f"{num_pages=}")
        print(f"{splitter=}")
        pages = text.split(splitter[1]) #[1:]
        invoices_l, orders_l = [], []
        invoice_match, order_match = None, None

        # rows = [
        #     ' No client\nCustomer No.Date Termes /\nTermsIncoterms\n132606No commande / \nOrder number\nHOLD FOR PICK-UPExpédié via / \nShip Via29 HAWKINS ROAD 10 MONTANA STREETBWS MANUFACTURING  LTD. (HOLD FOR BWS MANUFACTURING LTD.Expédié à \nShip ToFacturé à:\nBill To230015No.:FACTURE / INVOICE\nCENTREVILLE, NB E7K 1A4 CENTREVILLE (N.B), NB E7K 3E9\n770, Georges-Cros, Granby, QC, J2J 1N2\nE-mail: laseramp@laseramp.com\nTél.:  450-776-6982 / 877-776-6982    \nFAX:  450-378-3305\nMontant / amount Prix /Price Rev. Numéro de pièce / Part Number Qté /qty\n$16.84 $4.21 1 4242.40994128\n$129.24 $32.31 0 4242.STP-UC-P007\n$51.04 $6.38 0 8242.STP-UC-P008\n$124.98 $62.49 2 2242.22200869\n$215.62 $107.81 1 2242.22200870\n$14.60 $3.65 2 4242.22200712\n$58.28 $14.57 1 4242.22201172\n$52.04 $26.02 0 2242.22201159\n$52.46 $26.23 1 2242.22201143\n$81.12 $20.28 0 4242.22201147\n$45.12 $11.28 0 4242.22201155\n$273.79 $273.79 1 1242.22202990\n$61.58 $30.79 1 2242.22202991\n$102.20 $102.20 NR 1242.TR-SFR-P229\n$119.21 $119.21 NR 1242.TR-SFR-P232\n$114.38 $114.38 NR 1242.TR-SFR-P233\n$84.67 $84.67 1 1242.22201292\n$35.79 $35.79 2 1242.22201293\n$84.55 $84.55 2 1242.22201297\n$35.73 $35.73 2 1242.22201298\n$27.33 $27.33 NR 1242.TR-SFR-P182L\n$27.33 $27.33 NR 1242.TR-SFR-P182R\n$37.35 $12.45 2 3242.222009372 108 2021-11-01 NET 60 FCA GRANBY',
        #     " No client\nCustomer No.Date Termes /\nTermsIncoterms\n132606No commande / \nOrder number\nHOLD FOR PICK-UPExpédié via / \nShip Via29 HAWKINS ROAD 10 MONTANA STREETBWS MANUFACTURING  LTD. (HOLD FOR BWS MANUFACTURING LTD.Expédié à \nShip ToFacturé à:\nBill To230015No.:FACTURE / INVOICE\nCENTREVILLE, NB E7K 1A4 CENTREVILLE (N.B), NB E7K 3E9\n770, Georges-Cros, Granby, QC, J2J 1N2\nE-mail: laseramp@laseramp.com\nTél.:  450-776-6982 / 877-776-6982    \nFAX:  450-378-3305\n$39.36 $3.28 2 12242.22200905\n$90.80 $9.08 1 10242.22204340\n$45.30 $7.55 1 6242.22204400\n$29.18 $14.59 2 2242.22202633\nTERMES: CETTE FACTURE PORTERA INTÉRÊT AU TAUX DE DIX-HUIT POUR CENT (18%) L'AN (CALCULÉ MENSUELLEMENT (UN ET DEMI POUR CENT (1 1/2%)\nPAR MOIS) SUR TOUT SOLDE NON-ACQUITTÉ EN DEDANS DES DÉLAIS CONVENUS ET ACCEPTÉS DE PART ET D'AUTRES, LEQUEL INTÉRÊT\nCOURRA ÀPARTIR DE LA DATE DE FACTURATION, SI IMPAYÉE DANS LES 30 JOURS.\nLES FRAIS DE PERCEPTION DE TOUT SOLDE NON-ACQUITTÉ SERONT ÀLA CHARGE DE L'ACHETEUR.\nTERMS:INTEREST WILL BE CHARGED AT THE RATE OF EIGHTEEN PERCENT (18%) PER YEAR (THAT IS ONE AND AHALF PERCENT (1 1/2%) PER MONTH) ON\nALL OVER DUE ACCOUNTS UNPAID WITHIN THE DELAYS AGREED AND ACCEPTED ON BOTH SIDES, SUCH INTEREST ACCRUED FROM DATE OF\nINVOICING IF NOT PAID WITHIN 30 DAYS. COLLECTION FEES ON OVERDUE ACCOUNTS WILL BE ASSUMED BY THE BUYER.\nRÉCLAMATIONS: TOUTES RÉCLAMATIONS CONCERNANT CETTE COMMANDE DOIVENT SE FAIRE DANS LES 10 JOURS SUIVANT LA RÉCEPTION DE LA MARCHANDISE.\nCLAIMS: ALL CLAIMS CONCERNING THIS ORDER MUST BE MADE WITHIN 10 DAYS FOLLOWING THE RECEIPT OF MERCHANDISE.TPS/GST: 103183190 RT0005   TVQ/QST: 1002029606 TQ0006$2,357.40 TOTAL               :$0.00 TVQ / QST:$307.51 TPS-TVH / GST-HST:$2,049.89 SOUS-TOTAL / SUB-TOTAL:\n($ CAN)"]
        # rows = [
        #     "\nHOLD\x03FOR\x03PICK-UP 139106 FCA\x03GRANBY NET\x03602023-02-14 108 1\nQté\x03/qtyNuméro\x03de\x03pièce\x03/\x03Part\x03Number Rev. Prix\x03/Price Montant\x03/\x03amount\n100108-40973198 1 $57.55 $57.55\n100108-40973156 1 $15.39 $15.39\nSOUS-TOTAL \x03/\x03SUB-TOTAL: $72.94\nTPS-TVH \x03/\x03GST-HST: $10.94\nTVQ\x03/\x03QST: $0.00\nTOTAL\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03 : ($\x03CAN)TPS/GST: \x03103183190 \x03RT0005 \x03\x03\x03TVQ/QST: \x031002029606 \x03TQ0006$83.88\nTERMES: \x03CETTE\x03FACTURE \x03PORTERA \x03INTÉRÊT \x03AU\x03TAUX\x03DE\x03DIX-HUIT \x03POUR\x03CENT\x03(18%)\x03L'AN\x03(CALCULÉ \x03MENSUELLEMENT \x03(UN\x03ET\x03DEMI\x03POUR\x03CENT\x03(1\x031/2%)\n\x03PAR\x03MOIS)\x03SUR\x03TOUT\x03SOLDE\x03NON-ACQUITTÉ \x03EN\x03DEDANS\x03DES\x03DÉLAIS\x03CONVENUS \x03ET\x03ACCEPTÉS \x03DE\x03PART\x03ET\x03D'AUTRES, \x03LEQUEL\x03INTÉRÊT\nCOURRA \x03À\x03PARTIR\x03DE\x03LA\x03DATE\x03DE\x03FACTURATION, \x03SI\x03IMPAYÉE \x03DANS\x03LES\x0330\x03JOURS.\nLES\x03FRAIS\x03DE\x03PERCEPTION \x03DE\x03TOUT\x03SOLDE\x03NON-ACQUITTÉ \x03SERONT\x03À\x03LA\x03CHARGE\x03DE\x03L'ACHETEUR.\nTERMS:INTEREST \x03WILL\x03BE\x03CHARGED \x03AT\x03THE\x03RATE\x03OF\x03EIGHTEEN \x03PERCENT \x03(18%)\x03PER\x03YEAR\x03(THAT\x03IS\x03ONE\x03AND\x03A\x03HALF\x03PERCENT \x03(1\x031/2%)\x03PER\x03MONTH) \x03ON\nALL\x03OVER\x03DUE\x03ACCOUNTS \x03UNPAID\x03WITHIN\x03THE\x03DELAYS\x03AGREED\x03AND\x03ACCEPTED \x03ON\x03BOTH\x03SIDES,\x03SUCH\x03INTEREST \x03ACCRUED \x03FROM\x03DATE\x03OF\nINVOICING \x03IF\x03NOT\x03PAID\x03WITHIN\x0330\x03DAYS.\x03COLLECTION \x03FEES\x03ON\x03OVERDUE \x03ACCOUNTS \x03WILL\x03BE\x03ASSUMED \x03BY\x03THE\x03BUYER.\nRÉCLAMATIONS: \x03TOUTES\x03RÉCLAMATIONS \x03CONCERNANT \x03CETTE\x03COMMANDE \x03DOIVENT \x03SE\x03FAIRE\x03DANS\x03LES\x0310\x03JOURS\x03SUIVANT \x03LA\x03RÉCEPTION \x03DE\x03LA\x03MARCHANDISE.\nCLAIMS:\x03ALL\x03CLAIMS\x03CONCERNING \x03THIS\x03ORDER\x03MUST\x03BE\x03MADE\x03WITHIN\x0310\x03DAYS\x03FOLLOWING \x03THE\x03RECEIPT \x03OF\x03MERCHANDISE."]
        for i, page in enumerate(pages):

            print(f"\nNewPage {i}")

            # if invoice_number == None and order_number == None:
            re_check_order_1 = False
            re_check_order_2 = False
            iv_idx = lstindex(page, in_spl_invoice)
            print(f"{iv_idx=}, {page=}")
            if iv_idx >= 0:
                left = page[:iv_idx].split(" ")[-1] + in_spl_invoice
                right1 = page[iv_idx:].split(" ")[0]
                right2 = f"{in_spl_invoice} " + page[iv_idx:].split(" ")[1]
                # check right first:
                l_match = re.search(r'(\d+)' + in_spl_invoice, left)
                r_match1 = re.search(in_spl_invoice + r'(\d+)', right1)
                r_match2 = re.search(in_spl_invoice + r' (\d+)', right2)
                print(f"A> {iv_idx=} {l_match=}, {left=}\n{r_match1=}, {right1=}\n{r_match2=}, {right2=}")
                if r_match1:
                    invoice_match = r_match1.group(1)
                elif r_match2:
                    invoice_match = r_match2.group(1)
                else:
                    invoice_match = l_match.group(1)

                p_a = l_match.group(0)
                p_b = len(p_a)
                p_c = len(in_spl_invoice)
                print(f"\t\t{p_a=}, {p_b=}, {p_c}, {(p_b - p_c)=}")
                if l_match and ((len(p_a)) - len(in_spl_invoice) == LEN_ORDER_NUMBER) and any([r_match1, r_match2]):
                    order_match = p_a.replace(in_spl_invoice, "")
                    re_check_order_1 = False
                else:
                    re_check_order_1 = True

            if order_match is None and iv_idx < 0:
                re_check_order_1 = True

            if re_check_order_1:
                # order number not found
                iv_idx = lstindex(page, in_spl_order_1)
                left = (page[:iv_idx].split(" ")[-1] + in_spl_order_1).replace("\n", "")
                right = (page[iv_idx:].split(" ")[0]).replace("\n", "")
                l_match = re.search(r'(\d+)' + in_spl_order_1, left)
                r_match = re.search(in_spl_order_1 + r'(\d+)', right)
                print(f"B> {iv_idx=} {l_match=}, {left=}\n{r_match=}, {right=}")
                if r_match:
                    order_match = r_match.group(1)
                    re_check_order_2 = False
                    print(f"\n\t0-0 {order_match=}")
                elif l_match:
                    order_match = l_match.group(1)
                    re_check_order_2 = False
                    print(f"\n\t0-1 {order_match=}")
                else:
                    re_check_order_2 = True
                    
            if re_check_order_2:
                # order number not found
                iv_idx = lstindex(page, in_spl_order_2)
                left = (page[:iv_idx].split(" ")[-1] + in_spl_order_2).replace(" ", "")
                right = in_spl_order_2 + (page[iv_idx:].replace(in_spl_order_2, "").split(" ")[0]).replace(" ", "")
                l_match = re.search(r'(\d+)' + in_spl_order_2, left)
                r_match = re.search(in_spl_order_2 + r'(\d+)', right)
                print(f"C> {iv_idx=} {l_match=}, {left=}\n{r_match=}, {right=}")
                if r_match:
                    order_match = r_match.group(1)
                    print(f"\n\t1-0 {order_match=}")
                elif l_match:
                    order_match = l_match.group(1)
                    print(f"\n\t1-1 {order_match=}")
                else:
                    order_match = None
                    print(f"\n\t1-2 {order_match=}")
            
            if invoice_match:
                invoice_number = invoice_match.replace(in_spl_invoice, "")
                invoices_l.append(invoice_number)
            if order_match:
                order_number = order_match
                orders_l.append(order_number)
            # else:
            #     invoice_number, order_number = None, None

            # if iv_idx >= 0

            page_lines = [pl for pl in page.split("\n") if (pl.count("$") == 2) or ("No.:" in pl)]
            values = [pl.split(" ")[:4] for pl in page_lines if len(pl.split(" ")) >= 4]
            for j, vals in enumerate(values):
                a, b, c, d = vals
                if is_money(a) and "$" in a:
                    # money value first
                    a, b, c, d = d, c, b, a

                if is_money(c) and is_money(d):
                    print(f"\t{a=}, {b=}, {c=}, {d=}")
                    part_func_type = [key for key in known_prefixes.keys() if key in a][0]
                    part_type_func = known_prefixes[part_func_type]
                    qty, part_number = part_type_func(a)
                    rev, price, amount = b, c, d
                    print(f"{qty=}, {part_number=}, {rev=}, {price=}, {amount=}")
                    # print(f"ELSE")
                    page_idxs.append(i - 1)
                    qtys.append(qty)
                    p_nums.append(part_number)
                    revs.append(rev)
                    prices.append(price)
                    amounts.append(amount)
                    invoices.append(invoice_number)
                    orders.append(order_number)
                    passes.append(fn)
                else:
                    print(f"{i=} {j=}, PASS ON {vals=}")

    except (ValueError) as e:
        print(f"FAILURE")
        raise e

    print(f"{invoices_l=}")
    print(f"{orders_l=}")
    for i, idx in enumerate(page_idxs):
        invoices[i] = invoices_l[idx]
        orders[i] = orders_l[idx]

    print(f"\n\n\tFINAL\n")
    s_lists = "\n".join([f"{l_name.ljust(12)} len={len(lst)}, lst={lst}" for l_name, lst in
                         [
                             ("page_idxs", page_idxs),
                             ("fails", fails),
                             ("qtys", qtys),
                             ("passes", passes),
                             ("p_nums", p_nums),
                             ("revs", revs),
                             ("prices", prices),
                             ("amounts", amounts),
                             ("invoices", invoices),
                             ("orders", orders),
                             ("invoices_l", invoices_l),
                             ("orders_l", orders_l)
                         ]])
    print(f"{s_lists}")


    # page_2 = rows[1]
    # p2_lines = page_2.split("\n")
    # p1_lines = page_1.split("\n")
    # x = [pl.split(" ")[:4] for pl in p1_lines if len(pl.split(" ")) >= 4]
    # y = [pl.split(" ")[:4] for pl in p2_lines if len(pl.split(" ")) >= 4]


if __name__ == "__main__":

    timings = {"program_start": time.time()}

    t_root_1 = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP\2021\NOV 2021"
    t_root_2 = r"\\nas1\Public\Accounts Payable\AP - BWS Manufacturing\Posted\Laser AMP\2021\August 2021"
    # t_root_1 = None
    #
    # results = asyncio.run(
    #     test_batch_laser_amp(
    #         root_in=t_root_1,
    #         stop_num=1
    #     )
    # )
    # print(f"{results=}")
    # print(f"{type(results)=}")
    # print(f"{dir(results)=}")
    # results = results.result()
    # print(f"{results=}")
    # print(f"{len(results)=}")
    # timings["program_end"] = time.time()
    # timings.update({
    #     "program run time (ms)": timings["program_end"] - timings["program_start"],
    #     "batch run time (ms)": timings["batch_end"] - timings["batch_start"]
    # })
    # print(dict_print(timings, "Timings"))
    #
    # fails, text, files, qtys, p_nums, revs, prices, amounts, invoices, orders = results[0]
    # d = date_str_format(datetime.datetime.now(), file_name=True)
    # with open(r"C:\Users\ABriggs\Documents\BWS\PDF Invoice Parsing\output_" + d + ".txt", "w") as f:
    #     s_fails = '\n'.join(fails)
    #     s_files = '\n'.join(files)
    #     f.write(f"{len(fails)=},\n'\\n'.join(fails)={s_fails}",)
    #     f.write(f"\n{len(text)=}, {text=}")
    #     f.write(f"\n{len(files)=},\nfiles=\n{s_files}")
    #     f.write(f"\n{len(qtys)=}, {qtys=}")
    #     f.write(f"\n{len(p_nums)=}, {p_nums=}")
    #     f.write(f"\n{len(revs)=}, {revs=}")
    #     f.write(f"\n{len(prices)=}, {prices=}")
    #     f.write(f"\n{len(amounts)=}, {amounts=}")
    #     f.write(f"\n{len(invoices)=}, {invoices=}")
    #     f.write(f"\n{len(orders)=}, {orders=}")
    #
    # # files[file]["data"] = dict()
    # #
    # # print(f"{files=}")
    # # print(f"{len(files)=}")
    # # df = pd.DataFrame(files)
    # # print(f"\n\tdf\n{df}")


    # scratch(t_root_1)
    # scratch(t_root_2)
    scratch(None)
