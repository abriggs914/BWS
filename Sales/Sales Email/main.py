

import win32com.client
from dateutil import parser


def load_sales_emails(count=None):
    outlook = win32com.client.Dispatch('outlook.application')
    mapi = outlook.GetNamespace("MAPI")
    for account in mapi.Accounts:
        print(account)

    olk = win32com.client.Dispatch("Outlook.Application").GetNameSpace("MAPI").Folders["Sales"]
    for messages in olk.items():
        print(f"{messages=}")

    # olk = win32com.client.Dispatch("Outlook.Application").GetNameSpace("MAPI").Stores
    # for i in range(olk.count):
    #     for cat in olk[i].categories:
    #         print(f"{i=}, {cat=}")

    print(f"{mapi.Folders=}")
    print(f"{mapi.Folders['Sales']=}")

    for cat in mapi.Folders["Sales"].categories:
        print(f"{cat=}")

    # armstrong_folder = mapi.Folders.Item("Avery Briggs").Folders.Item("Armstrong").Items
    folder_sales_inbox = mapi.Folders.Item("Sales").Folders.Item("Inbox").Items
    # folders_list_sales = list(folder_sales_inbox.categories)
    # print(f"{folders_list_sales=}")
    # email = armstrong_folder.GetFirst()
    email = folder_sales_inbox.GetLast()
    email_items = {}
    i = 0

    # general updates come from infor@armcom.ca
    # Walk backwards newest email to oldest.
    while email:
        try:
            print(f"i:{i}, email: {email}")
            email_data = dict()
            email_data['sent_on'] = parser.parse(str(getattr(email, 'SentOn', '<UNKNOWN>')))
            email_data['T'] = type(email_data["sent_on"])
            email_data['sender'] = getattr(email, 'SenderEmailAddress', '<UNKNOWN>')
            email_data['receiver'] = getattr(email, 'to', '<UNKNOWN>')
            email_data['subject'] = getattr(email, 'subject', '<UNKNOWN>')
            email_data['cc'] = getattr(email, 'cc', '<UNKNOWN>')
            email_data['bcc'] = getattr(email, 'bcc', '<UNKNOWN>')
            email_data['body'] = getattr(email, 'body', '<UNKNOWN>')[:25]  # TODO REMOVE BODY CAP TO SEE WHOLE MESSAGE
            email_items[i] = email_data
            print(f"\tdate: {email_data['sent_on']},\n\tfrom:\n\t{email_data['sender']},\n\tsubject:\n\t{email_data['subject']},\nbody: {email_data['body']}")
        except Exception as ex:
            print(f"Error processing mail\n\t{ex=}")
        i += 1
        if count is not None and i >= count:
            break
        email = folder_sales_inbox.GetPrevious()
        # email = armstrong_folder.GetNext()

    # print(dict_print(email_items, "Email Items"))
    return email_items


if __name__ == "__main__":
    print(f"{load_sales_emails()=}")
