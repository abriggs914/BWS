import datetime

import pandas
import win32com.client as win32

from datetime_utility import date_str_format

# import win32com.client
# import pywin32.client as win32


if __name__ == '__main__':
    sales_email = "sales@bwstrailers.com"
    path = r"C:\Users\ABriggs\Documents\BWS\ISO Audit\2023\Customer Emails List.xlsx"

    df = pandas.read_excel(path)
    print(f"{df}")
    # email = df["CustomerEmail"].unique()
    # print(f"{email}")

    # test emails
    email = [
        "avery.briggs@bwstrailers.com"
        # ,
        # "james.crawford@bwstrailers.com",
        # "evan.findlater@bwstrailers.com",
    ]

    if isinstance(email, str):
        email = [em.strip() for em in email.split(";")]

    if email:

        outlook = win32.Dispatch('outlook.application')

        # see available mail accounts (no condition, just as info)
        for account in outlook.Session.Accounts:
            # print('Available email accounts: %s' % (account))

            # assert that we are sending the email from the sales account.
            if account.DisplayName == sales_email:

                for recipient in email:

                    mail = outlook.CreateItem(0)  # create mail item
                    mail._oleobj_.Invoke(*(64209, 0, 8, 0, account))  # set current sender account
                    mail.To = recipient  # assign recipient(s)
                    mail.Subject = date_str_format(datetime.datetime.now(), include_time=True,include_weekday=True,short_month=True, short_weekday=True)  # 'BWS Customer Satisfaction Survey'
                    mail.Body = 'Just testing that this email comes from the BWS sales account.'
                    # mail.HTMLBody = '<h2>HTML Message body</h2>'  # this field is optional

                    # To attach a file to the email (optional):
                    # attachment = "Path to the attachment"
                    # mail.Attachments.Add(attachment)

                    # mail.Display()
                    print(f"sending email to '{recipient}'")
                    mail.Send()
