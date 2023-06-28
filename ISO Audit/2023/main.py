import pandas
import win32com.client as win32
# import win32com.client
# import pywin32.client as win32


if __name__ == '__main__':
    path = r"C:\Users\ABriggs\Documents\BWS\ISO Audit\2023\Customer Emails List.xlsx"
    df = pandas.read_excel(path)
    print(f"{df}")

    for i, row in df.iterrows():

        # contact = row["CustomerContact"]
        # email = row["CustomerEmail"]
        email = "avery.briggs@bwstrailers.com"

        if email:

            outlook = win32.Dispatch('outlook.application')

            # see available mail accounts (no condition, just as info)
            for accounts in outlook.Session.Accounts:
                print('Available email accounts: %s' % (accounts))

            mail = outlook.CreateItem(0)
            mail.To = email
            # mail.From_ = 'sales@bwstrailers.com'
            mail.SendUsingAccount = "sales@bwstrailers.com"
            mail.Subject = 'BWS Customer Satisfaction Survey'
            mail.Body = 'Message body'
            mail.HTMLBody = '<h2>HTML Message body</h2>'  # this field is optional

            # To attach a file to the email (optional):
            # attachment = "Path to the attachment"
            # mail.Attachments.Add(attachment)

            mail.Send()

        break
