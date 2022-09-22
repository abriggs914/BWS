import os
import sys


def f():
    python = sys.executable
    print(f"{python=}, {sys.argv=}")
    print(f"")
    os.execl(python, python, * sys.argv)


if __name__ == '__main__':
    i = input("ENTER A NUMBER\n\t: ")
    if i == "0":
        f()
    else:
        print(f"NO F")
