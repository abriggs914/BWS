import pandas as pd


def area(rect):
	x0, x1, y0, y1 = rect
	w = x1 - x0
	h = y1 - y0
	return w * h


def map_overlay_offsets(maps: list[pd.DataFrame], mode: str = "exact", greedy_area: str = "max"):
	occupied = []
	offsets_v = []
	offsets_n = []
	x0_r, y0_r, x0_d, y0_d = 0, 0, 0, 0
	for i, df_map in enumerate(maps):
		name = df_map.loc[0, "id"]
		x0 = df_map["X0"].min()
		x1 = df_map["X1"].max()
		y0 = df_map["Y0"].min()
		y1 = df_map["Y1"].max()
		h = y1 - y0
		w = x1 - x0

		right = [
			x0_r + x0,
			x0_r + x0 + w,
			y0_r,
			y0_r + h
		]

		down = [
			x0_d,
			x0_d + w,
			y0_d + y0,
			y0_d + y0 + h
		]

		# a_r = area(right)
		# a_d = area(down)
		a_r = area([0, right[1], 0, right[3]])
		a_d = area([0, down[1], 0, down[3]])
		do_right: bool = a_r <= a_d

		last = [x0_r, y0_r, x0_d, y0_d]
		print(f"{i=}, {name=}, (x0,x1,y0,y1)={(x0, x1, y0, y1)}, (w, h)={(w, h)}, (last)={last}, (right)={right}, (down)={down}, a_r={a_r}, a_d={a_d}, {do_right=}")

		# if i == 0:
		offsets_n.append(name)
		if do_right:
			x0_r += w
			offsets_v.append((x0_r, y0_r))
		else:
			y0_d += h
			offsets_v.append((x0_d, y0_d))

		if i == 0:
			pass

	offsets_v.insert(0, (0, 0))
	return dict(zip(offsets_n, offsets_v))

	# 	# x0_ += x0
	# 	# x1_ += x1
	# 	# y0_ += y0
	# 	# y1_ += y1
	#
	# 	# right
	# 	x0_r = l_x
	# 	x1_r = x0_ + w
	# 	a_r = x1_r * h
	#
	# 	# down
	# 	y0_d = l_y
	# 	y1_d = y0_ + h
	# 	a_d = y1_d * w
	# 	print(f"right {x0_r=}, {x1_r=}, {y0_=}, {y1_+h=}, {h=}, {w=}, {l_x=}, {l_y=}, {a_r=}")
	# 	print(f"down {x0_=}, {x1_=}, {y0_d=}, {y1_d+h=}, {h=}, {w=}, {l_x=}, {l_y=}, {a_d=}")
	#
	# 	# if a_r <= a_d:
	# 	# else:
	# 	# x0_ += x1 if (a_r > a_d) else 0
	# 	# y0_ += y1 if (a_d <= a_r) else 0
	# 	# x1_ = max(x1_, w)
	# 	# y1_ = max(y1_, h)
	# 	# x1_ += w
	# 	# y1_ += h
	#
	# 	do_left: bool = a_r <= a_d
	# 	x1_ = x1_r if do_left else (x1_ + w)
	# 	y1_ = y1_d if do_left else (y1_ + h)
	#
	# 	x0_ += l_x if do_left else 0
	# 	y0_ += l_y if do_left else 0
	#
	# 	l_x = x1_
	# 	l_y = y1_
	# 	print(f"\t=> {x0_=}, {x1_=}, {y0_=}, {y1_=}")
	#
	# 	offsets[name] = dict(
	# 		x0 = x0_,
	# 		x1 = x1_,
	# 		y0 = y0_,
	# 		y1 = y1_
	# 	)
	# return offsets

if __name__ == "__main__":
	map_a = pd.DataFrame([
		{
			"id": "A",
			"X0": 0,
			"X1": 2,
			"Y0": 0,
			"Y1": 2
		}
	])
	map_b = pd.DataFrame([
		{
			"id": "B",
			"X0": 0,
			"X1": 1,
			"Y0": 0,
			"Y1": 3
		}
	])
	map_c = pd.DataFrame([
		{
			"id": "C",
			"X0": 0,
			"X1": 3,
			"Y0": 0,
			"Y1": 2
		}
	])
	map_d = pd.DataFrame([
		{
			"id": "D",
			"X0": 0,
			"X1": 1,
			"Y0": 0,
			"Y1": 1
		}
	])
	map_e = pd.DataFrame([
		{
			"id": "E",
			"X0": 0,
			"X1": 2,
			"Y0": 0,
			"Y1": 2
		}
	])

	print(map_a)

	l_maps = [map_a, map_b, map_c, map_d, map_e]
	maps = pd.concat(l_maps, ignore_index=True)
	print(maps)

	mo = map_overlay_offsets(l_maps, mode="exact", greedy_area="max")
	for k, coords in mo.items():
		print(f"{k}: {coords}")