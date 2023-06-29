import datetime
import tkinter
import re

import numpy
import pandas as pd
import pythoncom
import pywintypes

from tkinter_utility import *
from tkinter import messagebox
import pandas
import win32com.client as win32

from datetime_utility import date_str_format

# import win32com.client
# import pywin32.client as win32

n_next_recipients = 5
list_of_recipients = None
next_recipients = None
sales_account = None
failed = None


def next_n_recipients(n=n_next_recipients, recipients=None):
    global list_of_recipients
    if recipients is not None:
        list_of_recipients = [recip for recip in recipients]
    res = [list_of_recipients.pop(0) for _ in range(min(n, len(list_of_recipients)))]
    return res


def send_some_emails():
    if not next_recipients:
        tkinter.messagebox.showinfo("Customer Satisfaction Emails", "Error no emails specified")
        return
    for recipient in next_recipients:
        mail = outlook.CreateItem(0)  # create mail item
        # https://stackoverflow.com/questions/57826082/how-to-sent-email-from-a-secondary-outlook-account-from-its-own-outbox-folder#:~:text=import%20win32com.client%20as%20win32%20outlook%20%3D%20win32.Dispatch%20%28%27outlook.application%27%29,prepared%20email%20mail.Display%20%28%29%20%23%20Finally%20mail.Send%20%28%29
        mail._oleobj_.Invoke(*(64209, 0, 8, 0, sales_account))  # set current sender account
        mail.To = recipient  # assign recipient(s)

        inspector = mail.GetInspector()
        bodystart = re.search("<body.*?>", mail.HTMLBody)
        mail.HTMLBody = re.sub(bodystart.group(), bodystart.group() + raw_html_email, mail.HTMLBody)

        # mail.Subject = date_str_format(datetime.datetime.now(), include_time=True, include_weekday=True,
        #                                short_month=True, short_weekday=True)  # 'BWS Customer Satisfaction Survey'
        mail.Subject = f"{'TEST ' if TESTING else ''}BWS Customer Satisfaction Survey 2023"

        # mail.Body = 'Just testing that this email comes from the BWS sales account.'
        # mail.HTMLBody =  # this field is optional

        # To attach a file to the email (optional):
        # attachment = "Path to the attachment"
        # mail.Attachments.Add(attachment)

        print(f"sending email to '{recipient}'")
        # mail.Send()
        # mail.Display()
        # mail.Close()
        # mail.Send()
        inspector.Display()
        try:
            inspector.Send()
        except pythoncom.com_error:
            failed.append(recipient)
        # inspector.Close(0)
        # mail.Send()


def click_send_emails(event=None):
    global next_recipients
    if not TESTING:
        send_some_emails()
    next_recipients = next_n_recipients()
    lst_nr_tv_list.set(next_recipients)
    if not next_recipients:
        tl = tkinter.Toplevel()
        tl.geometry(f"400x500")
        tv_tl_label, tl_label = label_factory(
            tl,
            tv_label=f"\n\tUndeliverable ({len(failed)}):\n\n" + "\n\t\t- ".join(failed)
        )
        tl_label.pack()


if __name__ == '__main__':

    failed = []
    TESTING = True
    TESTING = False
    first_pass_bookmark = "GHERM@PECKHAM.COM"
    sales_email = "sales@bwstrailers.com"
    path = r"C:\Users\ABriggs\Documents\BWS\ISO Audit\2023\Customer Emails List.xlsx"
    raw_html_email = """<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" xmlns="http://www.w3.org/TR/REC-html40"><head><meta http-equiv=Content-Type content="text/html; charset=us-ascii"><meta name=Generator content="Microsoft Word 15 (filtered medium)"><!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
	mso-ligatures:standardcontextual;
	mso-fareast-language:EN-US;}
span.EmailStyle19
	{mso-style-type:personal-reply;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;
	mso-ligatures:none;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext="edit" spidmax="1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext="edit">
<o:idmap v:ext="edit" data="1" />
</o:shapelayout></xml><![endif]--></head><body lang=EN-CA link="#0563C1" vlink="#954F72" style='word-wrap:break-word'><div class=WordSection1><div><div style='border:none;border-top:solid #E1E1E1 1.0pt;padding:3.0pt 0cm 0cm 0cm'><p class=MsoNormal></div></div><p class=MsoNormal><a name="_Hlk90550641">Good Day,<o:p></o:p></a></p><p class=MsoNormal><span style='mso-bookmark:_Hlk90550641'><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span style='mso-bookmark:_Hlk90550641'>We would like your opinion as a valued customer of BWS Manufacturing. Please take a moment to complete our customer satisfaction survey. <o:p></o:p></span></p><p class=MsoNormal><span style='mso-bookmark:_Hlk90550641'>Your feedback is crucial in helping us improve our services and provide you with an exceptional product.<o:p></o:p></span></p><p class=MsoNormal><span style='mso-bookmark:_Hlk90550641'><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span style='mso-bookmark:_Hlk90550641'>Access the survey here: <a href="http://survey.unipointsoftware.com/OnlineSurvey.aspx?id=CA2D942D-C9A5-4527-9466-5E35689E2486">Survey Link</a><o:p></o:p></span></p><p class=MsoNormal><span style='mso-bookmark:_Hlk90550641'><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span style='mso-bookmark:_Hlk90550641'>Thank you for your time and support. We appreciate your valuable input.<o:p></o:p></span></p><p class=MsoNormal><span style='mso-bookmark:_Hlk90550641'><o:p>&nbsp;</o:p></span></p><span style='mso-bookmark:_Hlk90550641'></span><p class=MsoNormal><o:p>&nbsp;</o:p></p></p></div></body></html>"""

    df = pandas.read_excel(path)
    print(f"{df}")
    print(f"{first_pass_bookmark=}")
    email = df[df["CustomerEmail"].str.lower() > first_pass_bookmark.lower()]["CustomerEmail"].unique()

    # second_pass_emails = df[df["CustomerEmail"] > first_pass_bookmark]
    # # print(f"\n\n\tLOOK HERE -A\n")
    # # print(second_pass_emails)
    # # print(f"\nLOOK THERE -A")
    #
    # print(f"\n\n\tLOOK HERE A\n")
    # print(second_pass_emails)
    # print(f"\nLOOK THERE A")
    #
    # second_pass_emails = df[df["CustomerEmail"] > first_pass_bookmark]
    # print(f"\n\n\tLOOK HERE B\n")
    # print(second_pass_emails)
    # print(f"\nLOOK THERE B")
    #
    # second_pass_emails = [em for em in df[df["CustomerEmail"] > first_pass_bookmark]["CustomerEmail"].unique().tolist() if em > first_pass_bookmark]
    # print(f"\n\n\tLOOK HERE C\n")
    # print(second_pass_emails)
    # print(f"\nLOOK THERE C")
    # # print(",\n".join(email))
    #
    # # program execution failed during processing only got to first_pass_bookmark='GHERM@PECKHAM.COM' in the first pass.
    #
    # print(f"{first_pass_bookmark=}")
    # email = df[df["CustomerEmail"].apply(lambda email: email > first_pass_bookmark)]["CustomerEmail"].unique()
    # email = [em for em in df[df["CustomerEmail"] > first_pass_bookmark]["CustomerEmail"].unique().tolist() if em > first_pass_bookmark]
    # # test emails
    # email = [
    #     "avery.briggs@bwstrailers.com",
    #     # "james.crawford@bwstrailers.com",
    #     # "evan.findlater@bwstrailers.com",
    #     # "jamie.merrithew@bwstrailers.com"
    #     "JACK BLACK"
    # ]

    print(f"{email=}")
    next_recipients = next_n_recipients(recipients=email)

    if isinstance(email, str):
        email = [em.strip() for em in email.split(";")]

    print(f"{type(email)=}")

    if (isinstance(email, (list, tuple)) and email) or (isinstance(email, numpy.ndarray) and email.any()):

        window = tkinter.Tk()
        window.geometry(f"800x550")
        tv_btn, btn = button_factory(
            window,
            tv_btn=f"send next {n_next_recipients}",
            command=click_send_emails
        )
        lst_nr_tv_label, lst_nr_label, lst_nr_tv_list, lst_nr_list = list_factory(
            window,
            tv_label=f"Next {n_next_recipients} Recipients:",
            tv_list=next_recipients,
            kwargs_list={
                "state": "disabled",
                "width": 75,
                "justify": tkinter.CENTER
            }
        )


        outlook = win32.Dispatch('outlook.application')

        # see available mail accounts (no condition, just as info)
        for account in outlook.Session.Accounts:
            # print('Available email accounts: %s' % (account))

            # assert that we are sending the email from the sales account.
            if account.DisplayName == sales_email:
                sales_account = account

        lst_nr_list.pack()
        btn.pack()
        window.mainloop()
