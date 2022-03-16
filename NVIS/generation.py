ans = '2S9DATBOX5M115535'
nvis = lambda cvma1, tt, bt, l, ac, gw, cd, my, mc, cvma2, pp: ("".join(list(map(lambda x: str(x)[:4], [cvma1[0:4], tt, bt, l, ac, gw, cd, my, mc, cvma2, pp])))).upper().strip()
print("nvis:", nvis('2s9', 'dump', 'aluminum', '53', '3', '5432', '0', '2015', 'Mississauga', '11', '5535'))
print("ans: ", ans)
print("nvis == ans:", nvis('2s9', 'dump', 'aluminum', '53', '3', '5432', '0', '2015', 'Mississauga', '11', '5535') == ans)