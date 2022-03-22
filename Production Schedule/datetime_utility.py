import datetime
from dateutil.relativedelta import relativedelta

"""
	General datetime Utility Functions
	Version...............1.1
	Date...........2022-03-22
	Author.......Avery Briggs
"""


class datetime2(datetime.datetime):

    def __init__(self, d, *args, **kwargs):
        print(f"d: <{d}>, args  : <{args}>\nkwargs: <{kwargs}>")
        # if len(args) == 1:
        #     if isinstance(args[0], str):
        #         if args[0]:
        #             try:
        #                 # try once to parse %Y-%m-%d %H:%M:%s
        #                 args = (datetime.datetime.strptime(args[0], "%Y-%m-%d %H:%M:%s"), *args[1:])
        #             except TypeError:
        #                 raise TypeError(
        #                     f"The parameter \"{args[0]}\" needs to be valid for the constructor to datetime.datetime.")
        super().__init__()
        # super(datetime2, self).__init__(*args, **kwargs)

    def add_month(self, n_months=1):
        return self + relativedelta(months=n_months)


if __name__ == '__main__':
    d2 = datetime.datetime(2022, 10, 10)
    d1 = datetime2(2022, 10, 10, 23, 48, 12)
    print("d1:", d1)
    print("d1 + M:", d1.add_month(3))
