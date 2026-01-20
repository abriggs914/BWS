import math
from utility import excel_column_name


if __name__ == '__main__':

	x0 = 2
	w = 6
	y0 = 11
	h = 4

	t_w = 180
	t_h = 80
	n_rows = int(math.ceil(t_h / h))
	n_cols = int(math.ceil(t_w / w))

	cells = []
	for j in range(n_cols):
		for i in range(n_rows):
			cells.append((
				excel_column_name(j, False),
				excel_column_name(j, False),
				i,
				x0 + (j * w),
				x0 + ((j + 1) * w),
				y0 + (i * h),
				y0 + ((i + 1) * h)
			))

	print(",\n".join(map(str, cells)))