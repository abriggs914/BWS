img_path = r"G:\IT\Network Port Layout\BWS\Parts Room v0.png"

# # import matplotlib.pyplot as plt
# # import numpy as np
# # from pdf2image import convert_from_path
#
# pdf_path = r"G:\IT\Network Port Layout\BWS\Parts Room v0.pdf"
#
# if __name__ == "__main__":
#
# 	# known_distance_ft = 12  # set this to your known real-world distance
# 	#
# 	# page = convert_from_path(pdf_path, dpi=300, first_page=1, last_page=1)[0]
# 	# img = np.array(page)
# 	#
# 	# fig, ax = plt.subplots(figsize=(12, 8))
# 	# ax.imshow(img)
# 	# ax.set_title("Click TWO points that are a known real-world distance apart")
# 	# pts = plt.ginput(2, timeout=0)  # click two points
# 	# plt.close(fig)
# 	#
# 	# (x1, y1), (x2, y2) = pts
# 	# dist_px = ((x2-x1)**2 + (y2-y1)**2) ** 0.5
# 	# px_per_ft = dist_px / known_distance_ft
# 	# grid_ft = 1.0  # 1-foot grid
# 	# grid_px = px_per_ft * grid_ft
# 	#
# 	# h, w = img.shape[0], img.shape[1]
# 	# fig, ax = plt.subplots(figsize=(12, 8))
# 	# ax.imshow(img)
# 	# ax.set_xlim(0, w)
# 	# ax.set_ylim(h, 0)
# 	#
# 	# ax.set_xticks(np.arange(0, w+1, grid_px))
# 	# ax.set_yticks(np.arange(0, h+1, grid_px))
# 	# ax.grid(True)
# 	# ax.set_title(f"Grid overlay (~{grid_ft} ft per square)")
# 	#
# 	# plt.tight_layout()
# 	# plt.savefig("warehouse_grid_calibrated.png", dpi=300)
# 	# plt.show()
#
# 	from PIL import Image
#
# 	img = Image.open(img_path)
# 	img.rotate(0.6, expand=True, fillcolor="white").save("warehouse_sketch_deskew.png")
#
# 	import math
# 	import json
# 	import numpy as np
# 	import matplotlib.pyplot as plt
# 	import matplotlib.image as mpimg
#
# 	# Known distance between two clicked points (you choose what segment to click)
# 	KNOWN_DISTANCE_FT = 10.0  # change this to match the real segment you click
#
# 	img = mpimg.imread(img_path)
#
# 	fig, ax = plt.subplots(figsize=(14, 9))
# 	ax.imshow(img)
# 	ax.set_title(
# 		"Click 1) ORIGIN (0,0), then 2) point A, 3) point B (known distance).",
# 		fontsize=12
# 	)
#
# 	clicks = []
#
#
# 	def onclick(event):
# 		if event.xdata is None or event.ydata is None:
# 			return
# 		clicks.append((float(event.xdata), float(event.ydata)))
# 		ax.plot(event.xdata, event.ydata, "ro")
# 		ax.text(event.xdata + 5, event.ydata + 5, f"{len(clicks)}", color="red", fontsize=12)
# 		fig.canvas.draw()
#
# 		if len(clicks) == 3:
# 			fig.canvas.mpl_disconnect(cid)
# 			origin = clicks[0]
# 			a = clicks[1]
# 			b = clicks[2]
#
# 			dist_px = math.dist(a, b)
# 			px_per_ft = dist_px / KNOWN_DISTANCE_FT
#
# 			print("\n--- Calibration Results ---")
# 			print(f"Origin (px): {origin}")
# 			print(f"Point A (px): {a}")
# 			print(f"Point B (px): {b}")
# 			print(f"Distance A-B: {dist_px:.2f} px = {KNOWN_DISTANCE_FT} ft")
# 			print(f"Pixels per foot: {px_per_ft:.4f} px/ft")
# 			print(f"Feet per pixel: {1 / px_per_ft:.6f} ft/px")
#
# 			# Save calibration for next steps
# 			calib = {
# 				"image_path": img_path,
# 				"origin_px": {"x": origin[0], "y": origin[1]},
# 				"px_per_ft": px_per_ft,
# 				"known_distance_ft": KNOWN_DISTANCE_FT,
# 				"a_px": {"x": a[0], "y": a[1]},
# 				"b_px": {"x": b[0], "y": b[1]},
# 			}
# 			with open("calibration.json", "w") as f:
# 				json.dump(calib, f, indent=2)
#
# 			ax.set_title("Calibration saved to calibration.json. Close this window.", fontsize=12)
#
#
# 	cid = fig.canvas.mpl_connect("button_press_event", onclick)
# 	plt.show()
#
# 	import json
# 	import numpy as np
# 	import matplotlib.pyplot as plt
# 	import matplotlib.image as mpimg
#
# 	with open("calibration.json", "r") as f:
# 		calib = json.load(f)
#
# 	img = mpimg.imread(calib["image_path"])
# 	origin_x = calib["origin_px"]["x"]
# 	origin_y = calib["origin_px"]["y"]
# 	px_per_ft = calib["px_per_ft"]
#
# 	GRID_FT = 2.0  # 2-foot grid
#
# 	grid_px = GRID_FT * px_per_ft
#
# 	fig, ax = plt.subplots(figsize=(14, 9))
# 	ax.imshow(img)
#
# 	# Draw grid lines aligned to your chosen origin
# 	w = img.shape[1]
# 	h = img.shape[0]
#
# 	# vertical lines
# 	x0 = origin_x
# 	for x in np.arange(x0, w, grid_px):
# 		ax.axvline(x, linewidth=0.5, linestyle="--")
# 	for x in np.arange(x0, 0, -grid_px):
# 		ax.axvline(x, linewidth=0.5, linestyle="--")
#
# 	# horizontal lines
# 	y0 = origin_y
# 	for y in np.arange(y0, h, grid_px):
# 		ax.axhline(y, linewidth=0.5, linestyle="--")
# 	for y in np.arange(y0, 0, -grid_px):
# 		ax.axhline(y, linewidth=0.5, linestyle="--")
#
# 	ax.plot(origin_x, origin_y, "ro")
# 	ax.text(origin_x + 5, origin_y + 5, "ORIGIN (0,0)", color="red")
#
# 	ax.set_title(f"Grid overlay: {GRID_FT} ft spacing")
# 	ax.set_xticks([])
# 	ax.set_yticks([])
#
# 	plt.tight_layout()
# 	plt.savefig("warehouse_with_grid.png", dpi=200)
# 	plt.show()
#
# 	import json
# 	import matplotlib.pyplot as plt
# 	import matplotlib.image as mpimg
#
# 	with open("calibration.json", "r") as f:
# 		calib = json.load(f)
#
# 	img = mpimg.imread(calib["image_path"])
# 	origin_x = calib["origin_px"]["x"]
# 	origin_y = calib["origin_px"]["y"]
# 	px_per_ft = calib["px_per_ft"]
#
# 	bins = []
#
# 	fig, ax = plt.subplots(figsize=(14, 9))
# 	ax.imshow(img)
# 	ax.set_title("Click a bin location; after each click, type the bin ID in the console.")
# 	ax.set_xticks([])
# 	ax.set_yticks([])
#
#
# 	def px_to_ft(x_px, y_px):
# 		# convert pixel to warehouse feet coords with origin and y-flip
# 		x_ft = (x_px - origin_x) / px_per_ft
# 		y_ft = (origin_y - y_px) / px_per_ft  # flipped
# 		return x_ft, y_ft
#
#
# 	def onclick(event):
# 		if event.xdata is None or event.ydata is None:
# 			return
# 		x_px, y_px = float(event.xdata), float(event.ydata)
#
# 		bin_id = input("Enter bin ID (or blank to cancel this point): ").strip()
# 		if not bin_id:
# 			print("Skipped.")
# 			return
#
# 		x_ft, y_ft = px_to_ft(x_px, y_px)
# 		bins.append({"bin": bin_id, "x_ft": x_ft, "y_ft": y_ft, "x_px": x_px, "y_px": y_px})
#
# 		ax.plot(x_px, y_px, "ro")
# 		ax.text(x_px + 5, y_px + 5, bin_id, fontsize=9)
# 		fig.canvas.draw()
#
# 		with open("bins.json", "w") as f:
# 			json.dump(bins, f, indent=2)
#
# 		print(f"Saved {len(bins)} bins to bins.json")
#
#
# 	cid = fig.canvas.mpl_connect("button_press_event", onclick)
# 	plt.show()
#
#



if __name__ == "__main__":
	import matplotlib.pyplot as plt
	import matplotlib.image as mpimg
	from matplotlib.ticker import MultipleLocator

	# Your desired logical grid size
	N_COLS = 75  # x direction
	N_ROWS = 100  # y direction

	# Grid styling
	MAJOR_EVERY = 10  # bold grid line every 10
	MINOR_EVERY = 1  # light grid line every 1  (try 5 if too dense)

	img = mpimg.imread(img_path)

	fig, ax = plt.subplots(figsize=(10, 8))

	# Put image in "warehouse grid coordinates"
	# extent: left, right, bottom, top
	ax.imshow(img, extent=(0, N_COLS, 0, N_ROWS), origin="upper")

	# Major / minor tick locators
	ax.xaxis.set_major_locator(MultipleLocator(MAJOR_EVERY))
	ax.yaxis.set_major_locator(MultipleLocator(MAJOR_EVERY))
	ax.xaxis.set_minor_locator(MultipleLocator(MINOR_EVERY))
	ax.yaxis.set_minor_locator(MultipleLocator(MINOR_EVERY))

	# Draw grids
	ax.grid(which="major", linewidth=1.2)  # major lines thicker
	ax.grid(which="minor", linewidth=0.4)  # minor lines thinner

	# Limits and labels
	ax.set_xlim(0, N_COLS)
	ax.set_ylim(0, N_ROWS)
	ax.set_xlabel("Column")
	ax.set_ylabel("Row")
	ax.set_title("Warehouse Sketch + Logical Grid Overlay")

	plt.tight_layout()
	plt.savefig("warehouse_grid_overlay.png", dpi=200)
	plt.show()
