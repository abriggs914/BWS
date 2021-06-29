# from pdf_writer import *
#
# pff = PDF(None)
#
# pff.table(None, None, None, None, None, show_row_names=1)


# Function FunctionName(Optional ByVal Y As Boolean, Optional ByVal X As String = "")


# def foo(x, y={}):
#     x['12'] = y
#
# def foo(x=1, y={}):
#     print("y", y)
#     x['13'] = y
#
# a = {'a':1}
# b = {'b':2, 'c':3}
# foo({}, a)
# foo({}, b)
# print(a)
# print(b)


def foo1(a, b=[]):
    b.append(a)
    return b


def foo2(a, b=[]):
    b.append(a)
    return b


x = [1]
print(foo1(14, [1]))
print(foo1(15, [2]))
print(foo1(16, [3]))
