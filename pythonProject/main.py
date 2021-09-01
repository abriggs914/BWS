

class Foo:
    def __init__(self, a, b, c, d, e, f):
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
        self.a = a

    def __repr__(self):
        return str(self.a)


f = Foo(*list(range(6)))
f.a += 100000
print(f)
