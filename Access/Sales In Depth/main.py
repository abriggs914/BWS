from forms import *


def NID():
    lst = list(range(10000))
    for i in lst:
        yield i


if __name__ == '__main__':
    print('PyCharm')

    nid = NID()

    forms_list = [
        Form(nid.__next__(), "Greetings")
    ]

    for form in forms_list:
        print(form)
