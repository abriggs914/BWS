from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Any, Literal, Optional

import streamlit as st



import pandas as pd
import pdfplumber

PARTS_HDR_TOKENS = {
	"PARTS LIST", "ITEM", "ITEM NO.", "QTY", "STOCK", "STOCK NO.", "STOCKNO.", "PART", "PART NO.", "PARTNO.",
	"DESCRIPTION", "DESC", "LENGTH", "WIDTH", "AREA", "AREA (SQ.FT.)", "COMMENTS"
}

REV_HDR_TOKENS = {
	"REV", "REV.", "BY", "DATE", "DESCRIPTION", "CHK'D", "CHKD", "CHECKED"
}

RE_ITEM = re.compile(r"^\d+$")
RE_STOCKLIKE = re.compile(r"^[A-Z0-9][A-Z0-9\-]{2,}$")  # tune to your stockcode rules if you want


@dataclass
class TableCandidate:
	kind: Literal["parts", "revision", "other"]
	score: float
	page: int
	bbox: tuple[float, float, float, float]
	df: pd.DataFrame
	method: str


def _norm(x: Any) -> str:
	if x is None:
		return ""
	return str(x).strip()


def _df_from_table(table_obj) -> pd.DataFrame:
	raw = table_obj.extract() or []
	df = pd.DataFrame(raw)
	df = df.replace({None: ""})
	df = df.applymap(_norm)

	# drop empty rows/cols
	df = df.loc[df.apply(lambda r: any(c != "" for c in r), axis=1)]
	df = df.loc[:, df.apply(lambda c: any(v != "" for v in c), axis=0)]
	return df.reset_index(drop=True)


def _row_tokens(row: pd.Series) -> set[str]:
	toks = set()
	for v in row.tolist():
		s = _norm(v).upper()
		if not s:
			continue
		toks.add(s)
	return toks


def _parts_score(df: pd.DataFrame) -> float:
	if df.empty:
		return -1e9

	score = 0.0
	nrows, ncols = df.shape

	# shape expectation: parts tables tend to have several columns
	if ncols >= 5: score += 3
	elif ncols >= 3: score += 1
	if nrows >= 2: score += 1

	# header presence in first 1-2 rows
	hdr_hits = 0
	for i in range(min(2, nrows)):
		toks = _row_tokens(df.iloc[i])
		hdr_hits += sum(1 for t in toks for h in PARTS_HDR_TOKENS if h in t)
	score += min(6, hdr_hits)

	# data-likeness: find a row that looks like an item row (item number + qty)
	item_row_hits = 0
	for i in range(min(10, nrows)):
		row = df.iloc[i].tolist()
		if len(row) >= 2 and RE_ITEM.match(_norm(row[0])) and (_norm(row[1]).isdigit() or _norm(row[1]) == ""):
			item_row_hits += 1
	score += min(4, item_row_hits)

	# penalize if it looks like revision table keywords
	text_blob = " ".join(df.head(6).astype(str).values.flatten()).upper()
	if any(k in text_blob for k in REV_HDR_TOKENS):
		score -= 3

	return score


def _revision_score(df: pd.DataFrame) -> float:
	if df.empty:
		return -1e9

	score = 0.0
	nrows, ncols = df.shape

	# revision tables are often 3-6 columns, short-ish
	if 2 <= ncols <= 8:
		score += 2
	if nrows >= 2:
		score += 1

	text_blob = " ".join(df.head(8).astype(str).values.flatten()).upper()
	hits = sum(1 for k in REV_HDR_TOKENS if k in text_blob)
	score += hits * 2

	# penalize if it strongly matches parts headers
	phits = sum(1 for k in ("ITEM", "QTY", "STOCK", "PART", "LENGTH", "WIDTH") if k in text_blob)
	score -= phits

	return score


def _classify(df: pd.DataFrame) -> tuple[str, float]:
	ps = _parts_score(df)
	rs = _revision_score(df)
	if ps >= rs and ps >= 3:
		return "parts", ps
	if rs > ps and rs >= 3:
		return "revision", rs
	return "other", max(ps, rs)


def _drop_parts_header_rows(df: pd.DataFrame) -> pd.DataFrame:
	"""
	Remove leading header/title rows so the first row is actual part data.
	Strategy: find first row that looks like an ITEM row.
	"""
	if df.empty:
		return df

	# If the first row contains lots of header tokens, keep dropping until data row
	start = 0
	for i in range(min(12, len(df))):
		row = df.iloc[i].tolist()
		# data row heuristic: first cell is item number
		if len(row) >= 1 and RE_ITEM.match(_norm(row[0])):
			start = i
			break

	df2 = df.iloc[start:].reset_index(drop=True)

	# Optionally remove any rows that are pure header noise
	def is_noise_row(r):
		blob = " ".join(_norm(x).upper() for x in r.tolist())
		# contains only header-y words and no digits
		hdrish = any(h in blob for h in ("ITEM", "QTY", "STOCK", "PART", "DESCRIPTION", "LENGTH", "WIDTH", "AREA", "COMMENTS"))
		has_digits = any(ch.isdigit() for ch in blob)
		return hdrish and not has_digits

	df2 = df2.loc[~df2.apply(is_noise_row, axis=1)].reset_index(drop=True)
	return df2


def extract_table_candidates(
	pdf_path_or_file,
	table_settings_passes: list[tuple[str, dict]] | None = None
) -> list[TableCandidate]:
	"""
	Extract candidates with bbox using page.find_tables().
	Returns a list of TableCandidate, one per detected table per pass.
	"""
	if table_settings_passes is None:
		table_settings_passes = [
			("lines", dict(
				vertical_strategy="lines",
				horizontal_strategy="lines",
				snap_tolerance=3,
				join_tolerance=3,
				intersection_tolerance=5,
				edge_min_length=12,
			)),
			("text", dict(
				vertical_strategy="text",
				horizontal_strategy="text",
				text_x_tolerance=2,
				text_y_tolerance=2,
				snap_tolerance=3,
				join_tolerance=3,
				intersection_tolerance=5,
				min_words_vertical=1,
				min_words_horizontal=1,
			)),
		]

	out: list[TableCandidate] = []

	with pdfplumber.open(pdf_path_or_file) as pdf:
		for pidx, page in enumerate(pdf.pages, start=1):
			for method, settings in table_settings_passes:
				tables = page.find_tables(table_settings=settings) or []
				for t in tables:
					df = _df_from_table(t)
					df = promote_header_if_present(df)

					# 2) Recover header from words above bbox if needed
					if list(df.columns) == list(range(df.shape[1])) or all(
							str(c).startswith("COL_") for c in df.columns):
						hdr = recover_header_from_words(page, t.bbox)
						if hdr and len(hdr) == df.shape[1]:
							df.columns = [h.replace(".", "") for h in hdr]

					# >>> NEW STEP <<<
					# 3) Drop empty columns BEFORE anything else
					df = drop_empty_columns(df, min_non_null=1)

					# >>> NEW STEP <<<
					# 4) Deduplicate column names (Streamlit-safe)
					df = dedupe_columns(df)

					# 5) Drop non-data rows (ITEM must be numeric)
					df = drop_non_data_rows(df)

					# 6) (optional) re-drop empties after row filtering
					df = drop_empty_columns(df, min_non_null=1)

					# # ---- ENTRY POINT B: if still unnamed columns, recover header from words above bbox
					# if all(str(c).startswith("0") or str(c).isdigit() for c in df.columns) or \
					# 		all(str(c).upper().startswith("COL_") for c in df.columns):
					# 	hdr = recover_header_from_words(page, t.bbox)
					# 	if hdr and len(hdr) == df.shape[1]:
					# 		df.columns = [h.replace(".", "") for h in hdr]
					#
					# # ---- ENTRY POINT C (Step 3): drop header/junk rows, keep only part rows
					# df = drop_non_data_rows(df)

					# (now classify/score on the cleaned df)
					kind, score = _classify(df)

					out.append(TableCandidate(
						kind=kind,
						score=float(score),
						page=pidx,
						bbox=tuple(t.bbox),
						df=df,
						method=method,
					))

	return out


def pick_best_parts_table(cands: list[TableCandidate], correction_cols_to_ignore: Optional[list] = None) -> TableCandidate | None:
	parts = [c for c in cands if c.kind == "parts"]
	if not parts:
		return None
	# prefer higher score; tie-break: larger area (often the real table is larger than tiny false positives)
	def key(c: TableCandidate):
		x0, y0, x1, y1 = c.bbox
		area = max(0.0, (x1 - x0) * (y1 - y0))
		return (c.score, area)
	best = max(parts, key=key)
	# clean headers
	best.df = _drop_parts_header_rows(best.df)
	best.df = correct_cols(best.df, ignore_cols=correction_cols_to_ignore)
	return best


def pick_best_revision_table(cands: list[TableCandidate]) -> TableCandidate | None:
	rev = [c for c in cands if c.kind == "revision"]
	if not rev:
		return None
	def key(c: TableCandidate):
		x0, y0, x1, y1 = c.bbox
		area = max(0.0, (x1 - x0) * (y1 - y0))
		return (c.score, area)
	return max(rev, key=key)


CANON_HDR = ["ITEM", "ITEM NO", "PART", "PART NO", "DESCRIPTION", "DESC", "STK", "STOCK", "STK CODE",
			 "MATERIAL", "WEIGHT", "QTY", "QUANTITY"]


def norm_token(s: str) -> str:
	return re.sub(r"\s+", " ", (s or "").strip().upper())


def is_header_row(row) -> bool:
	toks = [norm_token(x) for x in row]
	hits = sum(any(h in t for h in CANON_HDR) for t in toks if t)
	# e.g. "ITEM NO." "PART NO." "DESCRIPTION" "QTY" etc
	return hits >= 3


def promote_header_if_present(df: pd.DataFrame) -> pd.DataFrame:
	if df.empty:
		return df
	# check first row, then second row (sometimes there’s a “Parts List” banner first)
	for r in (0, 1):
		if r < len(df) and is_header_row(df.iloc[r].tolist()):
			new_cols = [norm_token(c).replace(".", "") for c in df.iloc[r].tolist()]
			new_cols = [c if c else f"COL_{i}" for i, c in enumerate(new_cols)]
			df2 = df.iloc[r+1:].copy()
			df2.columns = new_cols
			return df2.reset_index(drop=True)
	return df


def recover_header_from_words(page, table_bbox, y_window=25):
	x0, y0, x1, y1 = table_bbox
	words = page.extract_words(use_text_flow=True) or []

	# candidate words slightly above the table, within x-range
	cands = [
		w for w in words
		if (y0 - y_window) <= w["top"] <= y0
		and x0 <= w["x0"] <= x1
	]
	if not cands:
		return None

	# sort left-to-right, then group into a single line string
	cands.sort(key=lambda w: w["x0"])
	header_cells = [norm_token(w["text"]) for w in cands]

	# quick sanity: must contain at least 3 known header terms
	hits = sum(any(h in t for h in CANON_HDR) for t in header_cells)
	return header_cells if hits >= 3 else None

def drop_non_data_rows(df: pd.DataFrame) -> pd.DataFrame:
	"""
	Keeps only rows that look like part rows (ITEM is numeric).
	Works whether columns are named or not.
	"""
	if df.empty:
		return df

	# determine item column
	item_col = None
	for c in df.columns:
		if norm_token(str(c)) in ("ITEM", "ITEM NO", "ITEM NO."):
			item_col = c
			break

	if item_col is None:
		# fallback: try first column
		item_col = df.columns[0]

	s = df[item_col].astype(str).str.strip()
	df2 = df[s.str.match(RE_ITEM, na=False)].copy()
	return df2.reset_index(drop=True)


def drop_empty_columns(df: pd.DataFrame, min_non_null: int = 1) -> pd.DataFrame:
	"""
	Drop columns with fewer than `min_non_null` non-empty values.
	Default: drop columns that are entirely empty.
	"""
	if df.empty:
		return df

	def non_empty_count(col):
		return sum(bool(str(v).strip()) for v in col)

	keep_cols = [
		c for c in df.columns
		if non_empty_count(df[c]) >= min_non_null
	]

	return df[keep_cols].copy()


def dedupe_columns(df: pd.DataFrame) -> pd.DataFrame:
	"""
	Ensure column names are unique by appending __n to duplicates.
	Streamlit-safe.
	"""
	if df.empty:
		return df

	seen = {}
	new_cols = []

	for c in df.columns:
		c = str(c)
		if c not in seen:
			seen[c] = 0
			new_cols.append(c)
		else:
			seen[c] += 1
			new_cols.append(f"{c}__{seen[c]}")

	df.columns = new_cols
	return df


def correct_cols(df: pd.DataFrame, ignore_cols: Optional[list[str]] = None) -> pd.DataFrame:
	st.write(f"Correcting {df.shape=}")
	st.write(df.columns.tolist())
	ignore_cols = ignore_cols or []
	ignore_cols = [col.lower().replace(" ", "").strip() for col in ignore_cols]
	cols: list = df.columns.tolist()
	cols_c: list = cols.copy()
	col_sc0 = get_stockcode_col(df)
	if col_sc0:
		cols_c.remove(col_sc0)
	col_sc1 = get_stockcode_col(df[cols_c])
	if col_sc1:
		cols_c.remove(col_sc1)
	col_sc2 = get_stockcode_col(df[cols_c])
	col_sc0_l, col_sc1_l, col_sc2_l = map(lambda x: "" if x is None else x.lower().replace(" ", "").strip(), [col_sc0, col_sc1, col_sc2])
	col_sc0, col_sc1, col_sc2 = map(lambda x: "" if x is None else x, [col_sc0, col_sc1, col_sc2])
	st.write(f"{col_sc0=}__{col_sc1=}__{col_sc2=}")
	st.write(f"{col_sc0_l=}__{col_sc1_l=}__{col_sc2_l=}")
	st.write(f"ignore_cols")
	st.write(ignore_cols)
	for i, row in df.copy().iterrows():
		p_val0 = row.get(col_sc0)
		p_val1 = row.get(col_sc1)
		p_val2 = row.get(col_sc2)
		st.write(f"{i=}, {p_val0=}__{p_val1=}__{p_val2=}")
		if pd.isna(p_val0) or (not p_val0):
			if (not pd.isna(p_val1)) and p_val1:
				if not any((col_sc0_l in col) or (col in col_sc0_l) for col in ignore_cols):
					st.write(f"Replace A {col_sc0=}, {p_val1=}")
					df.loc[i, col_sc0] = p_val1
			elif (not pd.isna(p_val2)) and p_val2:
				if not any((col_sc0_l in col) or (col in col_sc0_l) for col in ignore_cols):
					st.write(f"Replace B {col_sc0=}, {p_val2=}")
					df.loc[i, col_sc0] = p_val2
				if not any((col_sc1_l in col) or (col in col_sc1_l) for col in ignore_cols):
					st.write(f"Replace C {col_sc1=}, {p_val2=}")
					df.loc[i, col_sc1] = p_val2
		else:
			if (not pd.isna(col_sc1)) and col_sc1:
				if not any((col_sc1_l in col) or (col in col_sc1_l) for col in ignore_cols):
					st.write(f"Replace D {col_sc1=}, {p_val0=}")
					df.loc[i, col_sc1] = p_val0
			if (not pd.isna(col_sc2)) and col_sc2:
				if not any((col_sc2_l in col) or (col in col_sc2_l) for col in ignore_cols):
					st.write(f"Replace E {col_sc2=}, {p_val0=}")
					df.loc[i, col_sc2] = p_val0
	st.write(df.columns.tolist())
	return df


def get_stockcode_col(df: pd.DataFrame, part_first: bool = False) -> str:
	col_sc = [c for c in df.columns if ("part" if part_first else "stock") in c.lower()]
	print("A")
	if col_sc:
		col_sc = col_sc[0]
		print("B")
	else:
		print("C")
		col_sc = [c for c in df.columns if ("stock" if part_first else "part") in c.lower()]
		if col_sc:
			col_sc = col_sc[0]
			print("D")
		else:
			col_sc = [c for c in df.columns if "dwg" in c.lower()]
			if col_sc:
				col_sc = col_sc[0]
				print("E")
			else:
				print("E")
				col_sc = None
	return col_sc
