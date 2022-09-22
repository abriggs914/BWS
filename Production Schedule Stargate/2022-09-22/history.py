class History:

    def __init__(self):
        self.data = []

    def add(self, undoable):

        self.data.append(undoable)

#     def __set_name__(self, owner, name):
#         self._name = name
#
#     def __get__(self, instance, owner):
#         return instance.__dict__[self._name]
#
#     def __set__(self, instance, value):
#         try:
#             print(f"{instance=}\n{value=}\n{instance.__dict__=}\n{self._name=}\n{instance.__dict__[self._name]=}")
#             instance.__dict__[self._name] = float(value)
#             print("Validated!")
#         except ValueError:
#             raise ValueError(f'"{self._name}" must be a number') from None
#
# # point.py
#
# class Coordinate:
#     def __set_name__(self, owner, name):
#         self._name = name
#
#     def __get__(self, instance, owner):
#         return instance.__dict__[self._name]
#
#     def __set__(self, instance, value):
#         try:
#             print(f"{instance=}\n{value=}\n{instance.__dict__=}\n{self._name=}")
#             assert isinstance(value, list)
#             instance.__dict__[self._name] = value
#             print("Validated!")
#         except AssertionError:
#             raise AssertionError(f'"{self._name}" must be a list, got {type(value)}') from None
#
#     def __add__(self, other):
#         print(f"{other=}")
#
#     def add(self, undoable):
#         print(f"{dir()=}")
#
# class Point:
#     x = Coordinate()
#     y = Coordinate()
#
#     def __init__(self, x, y):
#         self.x = x
#         self.y = y
#
#     def t1(self):
#         self.x.add(a)
#         a = None
#         print(f"{self.x=}, {a=}")
#
#     # def __repr__(self):
#     #     return f"{self.x}, {self.y}"
#
# if __name__ == "__main__":
#     p1 = Point([10], [10])
#     print()
#     p2 = Point([10], list("10"))
#     print()
#     p3 = Point(list("x"), list("10"))
#
#     p3.t1()
#     # p3.append(1)
#     # p3.update(1)
#
