# reportlab_utils.py
from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Iterable, Optional, Sequence, Union

import io
import zipfile
import pandas as pd

from reportlab.lib import colors
from reportlab.lib.pagesizes import LETTER, A4, portrait, landscape
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.pdfbase.pdfmetrics import stringWidth
from reportlab.platypus import (
    BaseDocTemplate,
    SimpleDocTemplate,
    NextPageTemplate,
    Frame,
    Image,
    FrameBreak,
    PageBreak,
    PageTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle
)
from reportlab.platypus.tableofcontents import TableOfContents


# -----------------------------
# Theme / Config
# -----------------------------

@dataclass(frozen=True)
class PDFTheme:
    page_size: tuple = LETTER  # or A4
    margin_left: float = 0.75 * inch
    margin_right: float = 0.75 * inch
    margin_top: float = 0.75 * inch
    margin_bottom: float = 0.75 * inch

    base_font: str = "Helvetica"
    mono_font: str = "Courier"

    header_height: float = 0.35 * inch
    footer_height: float = 0.35 * inch

    # Table defaults
    table_header_bg: colors.Color = colors.HexColor("#EDEDED")
    table_grid: colors.Color = colors.HexColor("#BDBDBD")
    zebra_bg: colors.Color = colors.HexColor("#F7F7F7")


@dataclass
class PDFMeta:
    title: str = "Report"
    subtitle: str = ""
    author: str = ""
    subject: str = ""
    created_at: datetime = datetime.now()


# -----------------------------
# DocTemplate with TOC support
# -----------------------------

class ReportDocTemplate(BaseDocTemplate):
    """
    DocTemplate that:
      - draws header/footer on each page
      - collects headings into a Table of Contents
    """

    def __init__(
        self,
        filename: Union[str, Path, io.BytesIO],
        theme: PDFTheme,
        meta: PDFMeta,
        show_page_numbers: bool = True,
    ):
        self.theme = theme
        self.meta = meta
        self.show_page_numbers = show_page_numbers

        super().__init__(
            str(filename),
            pagesize=theme.page_size,
            leftMargin=theme.margin_left,
            rightMargin=theme.margin_right,
            topMargin=theme.margin_top,
            bottomMargin=theme.margin_bottom,
            title=meta.title,
            author=meta.author,
            subject=meta.subject,
        )

        # Define content frame (leaving room for header/footer)
        frame = Frame(
            self.leftMargin,
            self.bottomMargin + theme.footer_height,
            self.width,
            self.height - theme.header_height - theme.footer_height,
            id="content",
        )

        template = PageTemplate(
            id="main",
            frames=[frame],
            onPage=self._draw_header_footer,
        )
        self.addPageTemplates([template])

        # TOC plumbing: styles are assigned when building the TOC flowable
        self._heading_level_styles: dict[int, ParagraphStyle] = {}

    def afterFlowable(self, flowable: Any) -> None:
        """
        Called after a flowable is added. We hook headings here to populate TOC.
        We detect headings by a convention: Paragraph styles named 'H1', 'H2', 'H3'.
        """
        if isinstance(flowable, Paragraph):
            style_name = getattr(flowable.style, "name", "")
            if style_name in ("H1", "H2", "H3"):
                level = {"H1": 0, "H2": 1, "H3": 2}[style_name]
                text = flowable.getPlainText()
                page_num = self.page
                # Notify TableOfContents instances in the story
                self.notify("TOCEntry", (level, text, page_num))

    def _draw_header_footer(self, canvas, doc) -> None:
        canvas.saveState()

        # Header line
        header_y = doc.pagesize[1] - self.theme.margin_top + (self.theme.header_height * 0.35)
        canvas.setFont(self.theme.base_font, 10)
        canvas.drawString(self.theme.margin_left, header_y, self.meta.title)

        if self.meta.subtitle:
            canvas.setFont(self.theme.base_font, 8)
            canvas.drawRightString(doc.pagesize[0] - self.theme.margin_right, header_y, self.meta.subtitle)

        # Footer line
        footer_y = self.theme.margin_bottom - (self.theme.footer_height * 0.65)
        canvas.setFont(self.theme.base_font, 8)

        # Left: timestamp
        ts = self.meta.created_at.strftime("%Y-%m-%d %H:%M")
        canvas.drawString(self.theme.margin_left, footer_y, f"Generated {ts}")

        # Right: page number
        if self.show_page_numbers:
            canvas.drawRightString(
                doc.pagesize[0] - self.theme.margin_right,
                footer_y,
                f"Page {doc.page}",
            )

        canvas.restoreState()


# -----------------------------
# Styles
# -----------------------------

def build_styles(theme: PDFTheme) -> dict[str, ParagraphStyle]:
    base = getSampleStyleSheet()

    # Start from defaults and override to be predictable
    normal = ParagraphStyle(
        "Normal",
        parent=base["Normal"],
        fontName=theme.base_font,
        fontSize=10,
        leading=12,
        spaceAfter=6,
    )

    h1 = ParagraphStyle(
        "H1",
        parent=base["Heading1"],
        fontName=theme.base_font,
        fontSize=16,
        leading=20,
        spaceBefore=10,
        spaceAfter=10,
        keepWithNext=True,
    )

    h2 = ParagraphStyle(
        "H2",
        parent=base["Heading2"],
        fontName=theme.base_font,
        fontSize=13,
        leading=16,
        spaceBefore=10,
        spaceAfter=8,
        keepWithNext=True,
    )

    h3 = ParagraphStyle(
        "H3",
        parent=base["Heading3"],
        fontName=theme.base_font,
        fontSize=11,
        leading=14,
        spaceBefore=8,
        spaceAfter=6,
        keepWithNext=True,
    )

    caption = ParagraphStyle(
        "Caption",
        parent=normal,
        fontName=theme.base_font,
        fontSize=9,
        leading=11,
        textColor=colors.HexColor("#444444"),
        spaceBefore=4,
        spaceAfter=10,
    )

    mono = ParagraphStyle(
        "Mono",
        parent=normal,
        fontName=theme.mono_font,
        fontSize=9,
        leading=11,
        backColor=colors.HexColor("#F3F3F3"),
        borderPadding=6,
        spaceBefore=6,
        spaceAfter=10,
    )

    return {"normal": normal, "h1": h1, "h2": h2, "h3": h3, "caption": caption, "mono": mono}


# -----------------------------
# Flowable helpers
# -----------------------------

def p(text: str, styles: dict[str, ParagraphStyle]) -> Paragraph:
    return Paragraph(text, styles["normal"])

def h1(text: str, styles: dict[str, ParagraphStyle]) -> Paragraph:
    return Paragraph(text, styles["h1"])

def h2(text: str, styles: dict[str, ParagraphStyle]) -> Paragraph:
    return Paragraph(text, styles["h2"])

def h3(text: str, styles: dict[str, ParagraphStyle]) -> Paragraph:
    return Paragraph(text, styles["h3"])

def code_block(text: str, styles: dict[str, ParagraphStyle]) -> Paragraph:
    # Basic escaping to keep it readable in Paragraph
    safe = (
        text.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\n", "<br/>")
            .replace(" ", "&nbsp;")
    )
    return Paragraph(safe, styles["mono"])

def vspace(points: float) -> Spacer:
    return Spacer(1, points)

def pagebreak() -> PageBreak:
    return PageBreak()


def toc(styles: dict[str, ParagraphStyle]) -> list:
    """
    Returns flowables for a Table of Contents section.
    Insert this near the top of your story.
    """
    toc_flowable = TableOfContents()
    toc_flowable.levelStyles = [
        ParagraphStyle(
            "TOCLevel0",
            parent=styles["normal"],
            fontSize=10,
            leading=12,
            leftIndent=0,
            firstLineIndent=0,
            spaceBefore=2,
            spaceAfter=2,
        ),
        ParagraphStyle(
            "TOCLevel1",
            parent=styles["normal"],
            fontSize=10,
            leading=12,
            leftIndent=14,
            firstLineIndent=0,
            spaceBefore=1,
            spaceAfter=1,
        ),
        ParagraphStyle(
            "TOCLevel2",
            parent=styles["normal"],
            fontSize=9,
            leading=11,
            leftIndent=28,
            firstLineIndent=0,
            spaceBefore=1,
            spaceAfter=1,
        ),
    ]

    return [
        h1("Table of Contents", styles),
        vspace(6),
        toc_flowable,
        pagebreak(),
    ]


# def df_table(
#     df: pd.DataFrame,
#     theme: PDFTheme,
#     styles: dict[str, ParagraphStyle],
#     *,
#     col_widths: Optional[Sequence[float]] = None,
#     zebra: bool = True,
#     header_repeat: bool = True,
#     max_rows: Optional[int] = None,
#     number_format: Optional[dict[str, str]] = None,
# ) -> Table:
#     """
#     DataFrame -> ReportLab Table.
#
#     number_format: mapping of column -> format string, e.g. {"Value": "{:,.2f}"}
#     """
#     if max_rows is not None:
#         df = df.head(max_rows)
#
#     number_format = number_format or {}
#
#     # Build rows: header + body
#     cols = list(df.columns)
#     data: list[list[Any]] = [cols]
#
#     for _, row in df.iterrows():
#         out_row = []
#         for c in cols:
#             v = row[c]
#             if pd.isna(v):
#                 out_row.append("")
#             elif c in number_format:
#                 try:
#                     out_row.append(number_format[c].format(v))
#                 except Exception:
#                     out_row.append(str(v))
#             else:
#                 out_row.append(str(v))
#         data.append(out_row)
#
#     tbl = Table(data, colWidths=col_widths, repeatRows=1 if header_repeat else 0)
#
#     # Style
#     ts = TableStyle([
#         ("FONTNAME", (0, 0), (-1, -1), theme.base_font),
#         ("FONTSIZE", (0, 0), (-1, -1), 9),
#         ("LEADING", (0, 0), (-1, -1), 11),
#         ("BACKGROUND", (0, 0), (-1, 0), theme.table_header_bg),
#         ("TEXTCOLOR", (0, 0), (-1, 0), colors.black),
#         ("LINEBELOW", (0, 0), (-1, 0), 1, theme.table_grid),
#         ("GRID", (0, 0), (-1, -1), 0.25, theme.table_grid),
#         ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
#         ("LEFTPADDING", (0, 0), (-1, -1), 6),
#         ("RIGHTPADDING", (0, 0), (-1, -1), 6),
#         ("TOPPADDING", (0, 0), (-1, -1), 3),
#         ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
#     ])
#
#     if zebra and len(data) > 2:
#         for r in range(1, len(data)):
#             if r % 2 == 0:
#                 ts.add("BACKGROUND", (0, r), (-1, r), theme.zebra_bg)
#
#     tbl.setStyle(ts)
#     return tbl


def ellipsize(text: str, font_name: str, font_size: float, max_width: float) -> str:
    """Return text truncated with … so it fits in max_width (points)."""
    if not text:
        return ""
    text = str(text)

    if stringWidth(text, font_name, font_size) <= max_width:
        return text

    ell = "…"
    ell_w = stringWidth(ell, font_name, font_size)
    if ell_w >= max_width:
        return ""  # too narrow to show anything reliably

    lo, hi = 0, len(text)
    # binary search max prefix that fits
    while lo < hi:
        mid = (lo + hi) // 2
        s = text[:mid]
        if stringWidth(s, font_name, font_size) + ell_w <= max_width:
            lo = mid + 1
        else:
            hi = mid
    cut = max(0, lo - 1)
    return text[:cut].rstrip() + ell


def df_table(
    df: pd.DataFrame,
    theme,
    styles: dict[str, ParagraphStyle],
    *,
    col_widths: Optional[Sequence[float]] = None,
    zebra: bool = True,
    header_repeat: bool = True,
    max_rows: Optional[int] = None,
    number_format: Optional[dict[str, str]] = None,
    font_size: float = 8.0,
    leading: Optional[float] = None,
    pad_x: float = 2.5,
    pad_y: float = 1.5,
    wrap_columns: Optional[set[str]] = None,
    truncate_columns: Optional[set[str]] = None,
    header_font_size: Optional[float] = None,
) -> Table:
    """
    DataFrame -> ReportLab Table with optional wrapping and truncation.

    wrap_columns:
        Columns whose cell values will be turned into Paragraphs (wrap enabled).
        (Usually for longer text columns.)

    truncate_columns:
        Columns whose cell values will be truncated with … to fit the column width.
        This is ideal for "single-line as much as possible" printer-friendly tables.
        NOTE: col_widths should be provided for best results; otherwise truncation is skipped.

    number_format:
        Mapping column -> format string, e.g. {"TOTAL": "{:,.2f}"}
    """
    if max_rows is not None:
        df = df.head(max_rows)

    number_format = number_format or {}
    wrap_columns = wrap_columns or set()
    truncate_columns = truncate_columns or set()

    header_font_size = header_font_size or (font_size + 0.5)
    leading = leading or (font_size + 1.5)

    cols = list(df.columns)

    # Style for wrapped cells
    wrap_style = ParagraphStyle(
        "WrapCell",
        parent=styles["normal"],
        fontName=theme.base_font,
        fontSize=font_size,
        leading=leading,
        spaceAfter=0,
        spaceBefore=0,
    )

    # Build header + rows
    data: list[list[Any]] = [cols]

    # For truncation, we need per-column usable width (minus padding)
    usable_col_widths: dict[str, float] = {}
    if col_widths is not None:
        if len(col_widths) != len(cols):
            raise ValueError(
                f"col_widths length mismatch: expected {len(cols)}, got {len(col_widths)}"
            )
        for i, c in enumerate(cols):
            w = col_widths[i]
            # subtract left/right padding inside the cell
            usable_col_widths[c] = max(0.0, float(w) - (2.0 * pad_x))

    for _, row in df.iterrows():
        out_row: list[Any] = []
        for c in cols:
            v = row[c]

            # format value
            if pd.isna(v):
                cell_txt = ""
            elif c in number_format:
                try:
                    cell_txt = number_format[c].format(v)
                except Exception:
                    cell_txt = str(v)
            else:
                cell_txt = str(v)

            # truncate (single-line preference) if requested and widths known
            if c in truncate_columns and c in usable_col_widths and cell_txt:
                cell_txt = ellipsize(cell_txt, theme.base_font, font_size, usable_col_widths[c])

            # wrap if requested (wrap uses Paragraph)
            if c in wrap_columns and cell_txt:
                safe = (cell_txt.replace("&", "&amp;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;"))
                out_row.append(Paragraph(safe, wrap_style))
            else:
                out_row.append(cell_txt)

        data.append(out_row)

    tbl = Table(data, colWidths=col_widths, repeatRows=1 if header_repeat else 0)

    ts = TableStyle([
        ("FONTNAME", (0, 0), (-1, -1), theme.base_font),
        ("FONTSIZE", (0, 1), (-1, -1), font_size),
        ("LEADING", (0, 1), (-1, -1), leading),

        ("BACKGROUND", (0, 0), (-1, 0), theme.table_header_bg),
        ("FONTSIZE", (0, 0), (-1, 0), header_font_size),
        ("LINEBELOW", (0, 0), (-1, 0), 0.75, theme.table_grid),

        ("GRID", (0, 0), (-1, -1), 0.25, theme.table_grid),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), pad_x),
        ("RIGHTPADDING", (0, 0), (-1, -1), pad_x),
        ("TOPPADDING", (0, 0), (-1, -1), pad_y),
        ("BOTTOMPADDING", (0, 0), (-1, -1), pad_y),
    ])

    if zebra and len(data) > 2:
        for r in range(1, len(data)):
            if r % 2 == 0:
                ts.add("BACKGROUND", (0, r), (-1, r), theme.zebra_bg)

    tbl.setStyle(ts)
    return tbl


def img(
    image_path: Union[str, Path],
    *,
    max_width: Optional[float] = None,
    max_height: Optional[float] = None,
) -> Image:
    """
    Create a ReportLab Image, optionally scaling to fit max_width/max_height.
    """
    image_path = Path(image_path)
    im = Image(str(image_path))

    if max_width is None and max_height is None:
        return im

    iw, ih = im.imageWidth, im.imageHeight
    scale = 1.0

    if max_width is not None:
        scale = min(scale, max_width / float(iw))
    if max_height is not None:
        scale = min(scale, max_height / float(ih))

    im.drawWidth = iw * scale
    im.drawHeight = ih * scale
    return im


def figure(
    image_path: Union[str, Path],
    styles: dict[str, ParagraphStyle],
    *,
    caption: str = "",
    max_width: Optional[float] = None,
    max_height: Optional[float] = None,
) -> list:
    flowables = [img(image_path, max_width=max_width, max_height=max_height)]
    if caption:
        flowables.append(Paragraph(caption, styles["caption"]))
    else:
        flowables.append(vspace(10))
    return flowables


# -----------------------------
# Builder
# -----------------------------

def build_pdf(
    out_path: Optional[str | Path],
    story: Optional[list] = None,
    *,
    theme: Optional[PDFTheme] = None,
    meta: Optional[PDFMeta] = None,
    show_toc: bool = False,
    as_zip: bool = False
) -> tuple[Path | Any]:
    """
    Build a PDF from flowables.
    If show_toc=True, you should include the toc() flowables near the top,
    but this flag is here in case you want to enforce a pattern later.
    """

    if not as_zip:
        if (out_path is None) or (not out_path):
            raise ValueError(f"If not zipping the PDF, 'out_path' must be specified. Got '{out_path}'.")

    theme = theme or PDFTheme()
    meta = meta or PDFMeta(created_at=datetime.now())

    buf = None
    if not as_zip:
        out_path = Path(out_path)
        out_path.parent.mkdir(parents=True, exist_ok=True)
        doc = ReportDocTemplate(out_path, theme=theme, meta=meta)
    else:
        buf = io.BytesIO()
        doc = SimpleDocTemplate(buf, theme=theme, meta=meta)
        out_path = None

    # Build
    if story:
        doc.build(story)
        return out_path, doc

    # Remember to build the doc with a story, and resolve the path if using the doc elsewhere!
    return (buf if buf else out_path), doc


def build_zip_bytes(named_files: list[tuple[str, bytes]]) -> bytes:
    zbuf = io.BytesIO()
    with zipfile.ZipFile(zbuf, mode="w", compression=zipfile.ZIP_DEFLATED) as zf:
        for filename, data in named_files:
            print(f"{filename=}: {len(data)} bytes")
            zf.writestr(filename, data)
    return zbuf.getvalue()


# def add_grid_template(
#     doc: BaseDocTemplate,
#     theme: PDFTheme,
#     template_id: str = "grid_2x2",
#     rows: int = 2,
#     cols: int = 2,
#     gutter: float = 0.2 * inch,
# ):
#     """
#     Creates a PageTemplate with rows x cols Frames inside the content area.
#     Flowables fill frames left-to-right, top-to-bottom by default.
#     Use FrameBreak() to jump to next cell; PageBreak() to go next page.
#     """
#     content_x = doc.leftMargin
#     content_y = doc.bottomMargin + theme.footer_height
#     content_w = doc.width
#     content_h = doc.height - theme.header_height - theme.footer_height
#
#     cell_w = (content_w - gutter * (cols - 1)) / cols
#     cell_h = (content_h - gutter * (rows - 1)) / rows
#
#     frames = []
#     for r in range(rows):
#         for c in range(cols):
#             x = content_x + c * (cell_w + gutter)
#             # top row should be highest y; Frame uses bottom-left origin
#             y = content_y + (rows - 1 - r) * (cell_h + gutter)
#             frames.append(Frame(x, y, cell_w, cell_h, id=f"cell_{r}_{c}"))
#
#     if isinstance(doc, ReportDocTemplate):
#         tpl = PageTemplate(
#             id=template_id,
#             frames=frames,
#             onPage=doc._draw_header_footer,
#         )
#     else:
#         tpl = PageTemplate(
#             id=template_id,
#             frames=frames
#         )
#     doc.addPageTemplates([tpl])


def add_grid_template(
    doc: BaseDocTemplate,
    theme: PDFTheme,
    template_id: str = "grid",
    rows: int = 2,
    cols: int = 2,
    gutter: float = 0.2 * inch,
    merged_cells: Optional[Sequence[tuple[int, int, int, int]]] = None,
):
    """
    Creates a PageTemplate with rows x cols Frames inside the content area.

    Flowables fill frames in the order frames are added (left-to-right, top-to-bottom).
    Use FrameBreak() to jump to next frame; PageBreak() to go next page.

    merged_cells: sequence of (m_i, m_j, m_len_rows, m_len_cols)
      - m_i, m_j are 0-based start row/col indices in the grid
      - m_len_rows, m_len_cols are spans (>= 1)
      - A (1,1) span is effectively an unmerged cell (you may omit it)
      - Merges may not overlap; out-of-bounds merges raise ValueError
    """

    merged_cells = merged_cells or []

    # --- Compute content area inside margins, leaving header/footer bands ---
    content_x = doc.leftMargin
    content_y = doc.bottomMargin + theme.footer_height
    content_w = doc.width
    content_h = doc.height - theme.header_height - theme.footer_height

    # Base cell sizes (gutter sits *between* cells)
    cell_w = (content_w - gutter * (cols - 1)) / cols
    cell_h = (content_h - gutter * (rows - 1)) / rows

    # covered[r][c] True means this grid cell is already occupied by a merged region
    covered = [[False for _ in range(cols)] for _ in range(rows)]
    # map from merge start cell -> (row_span, col_span)
    merge_starts: dict[tuple[int, int], tuple[int, int]] = {}

    def _validate_int(name: str, v: int) -> None:
        if not isinstance(v, int):
            raise TypeError(f"{name} must be int, got {type(v).__name__}: {v!r}")

    # --- Validate + mark coverage for each merged region ---
    for (mi, mj, rspan, cspan) in merged_cells:
        _validate_int("m_i", mi)
        _validate_int("m_j", mj)
        _validate_int("m_len_rows", rspan)
        _validate_int("m_len_cols", cspan)

        if not (0 <= mi < rows):
            raise ValueError(f"merged_cells start row out of range: {mi=} with {rows=}")
        if not (0 <= mj < cols):
            raise ValueError(f"merged_cells start col out of range: {mj=} with {cols=}")

        if rspan < 1 or cspan < 1:
            raise ValueError(f"merged_cells spans must be >= 1, got {rspan=} {cspan=}")

        end_r = mi + rspan - 1
        end_c = mj + cspan - 1
        if end_r >= rows or end_c >= cols:
            raise ValueError(
                f"merged_cells span out of bounds: start=({mi},{mj}) span=({rspan},{cspan}) "
                f"ends at ({end_r},{end_c}) but grid is ({rows}x{cols})."
            )

        # Check overlap + mark coverage
        for rr in range(mi, mi + rspan):
            for cc in range(mj, mj + cspan):
                if covered[rr][cc] or (rr, cc) in merge_starts:
                    raise ValueError(
                        f"merged_cells overlap detected at ({rr},{cc}). "
                        f"Check your merged_cells specifications."
                    )

        for rr in range(mi, mi + rspan):
            for cc in range(mj, mj + cspan):
                covered[rr][cc] = True

        merge_starts[(mi, mj)] = (rspan, cspan)

    frames: list[Frame] = []

    # --- Build frames in reading order (top-to-bottom, left-to-right) ---
    # Placement: y uses inverted row index because PDF coordinate system is bottom-up.
    for r in range(rows):
        for c in range(cols):
            # If this cell is a merge start, create one big frame for the whole region
            if (r, c) in merge_starts:
                rspan, cspan = merge_starts[(r, c)]

                x = content_x + c * (cell_w + gutter)
                # top row should be highest y; so invert r
                y_top = content_y + (rows - 1 - r) * (cell_h + gutter)

                # Width includes internal gutters between spanned columns
                span_w = (cell_w * cspan) + (gutter * (cspan - 1))
                # Height includes internal gutters between spanned rows
                span_h = (cell_h * rspan) + (gutter * (rspan - 1))

                # BUT: since y_top is top row's baseline, and Frame expects bottom-left,
                # we need to drop y by (span_h - cell_h) to cover rows below.
                y = y_top - (span_h - cell_h)

                frames.append(Frame(x, y, span_w, span_h, id=f"cell_{r}_{c}_span{rspan}x{cspan}"))
                continue

            # If covered by a merge (but not a start), skip it
            if covered[r][c]:
                continue

            # Normal single-cell frame
            x = content_x + c * (cell_w + gutter)
            y = content_y + (rows - 1 - r) * (cell_h + gutter)
            frames.append(Frame(x, y, cell_w, cell_h, id=f"cell_{r}_{c}"))

    # Attach header/footer if we can
    if isinstance(doc, ReportDocTemplate):
        tpl = PageTemplate(id=template_id, frames=frames, onPage=doc._draw_header_footer)
    else:
        tpl = PageTemplate(id=template_id, frames=frames)

    doc.addPageTemplates([tpl])




# -----------------------------
# Example usage (copy into your script)
# -----------------------------
if __name__ == "__main__":

    from pyodbc_connection import connect
    from typing import Literal

    # report_file_name: str = "demo_report.pdf"
    # report_title: str = "Demo Report"
    # report_subtitle: str = "ReportLab skeleton"
    # report_author: str = "Avery Briggs"
    #
    # theme = PDFTheme(page_size=LETTER)
    # meta = PDFMeta(
    #     title=report_title,
    #     subtitle=report_subtitle,
    #     author=report_author,
    # )
    # styles = build_styles(theme)
    #
    # df = pd.DataFrame({
    #     "Item": ["A", "B", "C"],
    #     "Qty": [10, 25, 7],
    #     "Value": [1234.5, 9876.0, 50.25],
    # })
    #
    # story = []
    # story += [
    #     h1("Demo Report", styles),
    #     p("This is a quick demo of the skeleton.", styles),
    #     vspace(10)
    # ]
    #
    # # TOC (optional) — headings added after it will populate it
    # story += toc(styles)
    #
    # story += [h1("Section 1", styles), p("Some paragraph text.", styles)]
    # story += [h2("A table from a DataFrame", styles)]
    # story += [df_table(df, theme, styles, number_format={"Value": "{:,.2f}"})]
    # story += [vspace(12)]
    #
    # # If you have a matplotlib chart saved as PNG:
    # # plt.savefig("chart.png", dpi=150, bbox_inches="tight")
    # # story += [h2("A figure", styles)]
    # # story += figure("chart.png", styles, caption="Figure 1: Example chart", max_width=6.5*inch)
    #
    # out = build_pdf(report_file_name, story, theme=theme, meta=meta)
    # print(f"Wrote: {out.resolve()}")

    def generate_so_pick_sheet(df_so_pick_sheet: pd.DataFrame, as_zip: bool = False):
        df_w = df_so_pick_sheet.copy()

        if len(df_w["SalesOrder"].dropna().unique()) != 1:
            raise ValueError(f"Cannot prepare a Sales Order Pick Sheet with combined orders.")

        so = df_w.loc[0, "SalesOrder"]
        df_stock_movements = load_stockcode_movements(so)
        cust_name = df_w.loc[0, "CustomerName"]
        ship_addr_0 = df_w.loc[0, "ShipAddress1"]
        ship_addr_1 = df_w.loc[0, "ShipAddress2"]
        ship_addr_2 = df_w.loc[0, "ShipAddress3"]

        df_w.sort_values("SalesOrderLine", inplace=True)
        table_cols = {
            "MOrderQty": "ORD",
            "MBackOrderQty": "B/O",
            "MShipQty": "SHP",
            "MStockingUom": "UOM",
            "MStockCode": "STOCK",
            "MStockDes": "DESC",
            "LongDesc": "LONG DESC",
            "MPrice": "PRICE",
            "Discount": "DISC",
            "Amount": "TOTAL",
            "QtyOnHand": "ON HAND",
            "QtyOnOrder": "ON ORDER"
        }
        df_part_data = df_w[table_cols.keys()]
        df_part_data.rename(columns=table_cols, inplace=True)

        report_file_name: str = f"so_pick_sheet_{so}_{datetime.now():%Y-%m-%d_%H%M%S}.pdf"
        report_title: str = f"Sales Order Pick Sheet"
        report_subtitle: str = f"SO# {so}"
        # report_author: str = f"{user}"
        report_author: str = f"abriggs"

        theme = PDFTheme(
            page_size=landscape(LETTER),
            margin_left=0.35*inch,
            margin_right=0.35*inch,
            margin_top=0.40*inch,
            margin_bottom=0.40*inch,
            header_height=0.25*inch,
            footer_height=0.25*inch,
            table_header_bg=colors.HexColor("#ADADAD")
        )
        meta = PDFMeta(
            title=report_title,
            subtitle=report_subtitle,
            author=report_author
        )
        styles = build_styles(theme)

        out, doc = build_pdf(
            report_file_name,
            story=None,
            theme=theme,
            meta=meta,
            as_zip=as_zip
        )
        buf = out
        add_grid_template(
            doc,
            theme,
            template_id="dash",
            rows=3,
            cols=2,
            merged_cells=[[1, 0, 1, 2]]
        )
        doc._firstPageTemplateIndex = next(
            i for i, t in enumerate(doc.pageTemplates) if t.id == "dash"
        )

        story = []
        # story += [NextPageTemplate("dash")]
        # story += [NextPageTemplate("dash"), PageBreak()]
        story += [
            h3("Picked By:", styles),
            h3("Picked Date:", styles),
            h3("Ship Date:", styles),
        ]

        # cell 0, 0
        story += [FrameBreak()]

        # cell 0, 1
        story += [
            h3(f"{cust_name}", styles),
            h3(f"{ship_addr_0}", styles),
            h3(f"{ship_addr_1}", styles),
            h3(f"{ship_addr_2}", styles),
            FrameBreak()
        ]

        # # cell 1, 0
        # story += [
        #     df_table(
        #         df_part_data,
        #         theme,
        #         styles,
        #         number_format={"Value": "{:,.2f}"},
        #         font_size=7.0,
        #         pad_x=1.5,
        #         pad_y=1.8,
        #         truncate_columns={"LONG DESC", "DESC"}
        #     )
        # ]

        available_w = doc.width  # or frame width if you’re in a grid cell

        col_widths = []
        for col in df_part_data.columns:
            if col in {"QTY ORD", "QTY B/O", "QTY SHP"}:
                col_widths.append(0.55 * inch)
            elif col in {"UOM"}:
                col_widths.append(0.45 * inch)
            elif col in {"PRICE", "TOTAL", "ON HAND", "ON ORDER"}:
                col_widths.append(0.70 * inch)
            elif col in {"STOCK"}:
                col_widths.append(0.90 * inch)
            else:
                col_widths.append(None)

        # distribute remaining width among None columns
        fixed = sum(w for w in col_widths if w is not None)
        flex_cols = [i for i, w in enumerate(col_widths) if w is None]
        flex_w = max(0, (available_w - fixed) / max(1, len(flex_cols)))
        for i in flex_cols:
            col_widths[i] = flex_w

        print(df_part_data.columns)
        for i, row in df_part_data.iterrows():
            story += [
                df_table(
                    # pd.DataFrame(row),
                    # pd.DataFrame(df_part_data.loc[i, df_part_data.columns]),
                    # df_part_data.loc[i, df_part_data.columns],
                    # pd.DataFrame(df_part_data.loc[i, list(df_part_data.columns)].transpose(), columns=df_part_data.columns),
                    # pd.DataFrame(df_part_data.iloc[i].transpose(), columns=df_part_data.columns),
                    # pd.DataFrame(df_part_data.iloc[i].transpose()),
                    pd.DataFrame(df_part_data.loc[i].transpose()).transpose(),
                    theme,
                    styles,
                    col_widths=col_widths,
                    number_format={"Value": "{:,.2f}"},
                    font_size=7.0,
                    pad_x=1.5,
                    pad_y=1.8,
                    truncate_columns={"LONG DESC", "DESC"}
                ),
                vspace(1),
                df_table(
                    # pd.DataFrame(row),
                    # pd.DataFrame(df_part_data.loc[i, df_part_data.columns]),
                    # df_part_data.loc[i, df_part_data.columns],
                    # pd.DataFrame(df_part_data.loc[i, list(df_part_data.columns)].transpose(), columns=df_part_data.columns),
                    # pd.DataFrame(df_part_data.iloc[i].transpose(), columns=df_part_data.columns),
                    # pd.DataFrame(df_part_data.iloc[i].transpose()),
                    load_stockcode_movements(row["STOCK"]).sort_values("TrnDateTime", ascending=False).head(3),
                    theme,
                    styles,
                    col_widths=col_widths,
                    number_format={"Value": "{:,.2f}"},
                    font_size=7.0,
                    pad_x=1.5,
                    pad_y=1.8,
                    truncate_columns={"LONG DESC", "DESC"}
                ),
                vspace(1)
            ]

        doc.build(story)
        if (not as_zip) and out:
            f_name = out.resolve()
            print(f"Wrote: {f_name}")
            return f_name

        # Will be io.BytesIO for zipping
        print(f"ZIP generate_so_pick_sheet")
        if buf is not None:
            return buf.getvalue()
        else:
            return None


    def so_fmt(so_num: int | str, out_type: Literal["int", "str"], word_size: int = 15) -> int | str:
        if out_type == "str":
            return str(so_num).rjust(word_size, "0")
        else:
            while so_num and (so_num[0] == "0"):
                so_num = so_num[1:]
            return so_num


    def load_stockcode_movements(stockcode: str) -> pd.DataFrame:
        sql = f"""
    SELECT
    	[IMdt].[TrnDateTime],
    	[IM].[EntryDate],
    	[IM].[TrnTime],
    	[IM].[StockCode],
    	[IM].[Warehouse],
    	[IM].[Job],
    	[IM].[TrnQty],
    	--[IM].[MovementType],
    	[IM].[TrnType],
    	[IM].[Reference],
    	[IM].[SalesOrder]
    FROM
    	[SysproCompanyA].[dbo].[InvMovements] [IM] WITH (NOLOCK)
    LEFT JOIN
    	[SysproCompanyA].[dbo].[v_PROD_InvMovementsDateTime] [IMdt] WITH (NOLOCK)
    ON
    	([IM].[StockCode] = [IMdt].[StockCode])
    	AND ([IM].[Warehouse] = [IMdt].[Warehouse])
    	AND ([IM].[Journal] = [IMdt].[Journal])
    	AND ([IM].[JournalEntry] = [IMdt].[JournalEntry])
    	AND ([IM].[TrnYear] = [IMdt].[TrnYear])
    	AND ([IM].[TrnMonth] = [IMdt].[TrnMonth])
    	AND ([IM].[TrnTime] = [IMdt].[TrnTime])
    	AND ([IM].[TrnType] = [IMdt].[TrnType])
    WHERE
    	LOWER([IM].[StockCode]) = LOWER('{stockcode}')
    ;
    """
        df = connect(sql)
        # display_df(df, "FETCH MOVEMENTS A")
        # df["MovementType"] = df["MovementType"].apply(lambda mt: "ISSUE" if mt == "I" else ("SALE" if mt == "S" else mt))
        df["TrnType"] = df["TrnType"].apply(lambda mt: "ISSUE" if mt == "I" else (
            "REC" if mt == "R" else ("ADJ" if mt == "A" else ("SALE" if mt == "S" else mt))))
        df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, "int"))
        # display_df(df, "FETCH MOVEMENTS B")
        return df


    def load_so_details(stockcode: Optional[str] = None, salesorder: Optional[str] = None) -> pd.DataFrame:
        """
            Load more Sales Order data than the Sales Order Pick Sheet version, but mising formatting.
            Ability to search by StockCode or SalesOrder. When querying with salesorder, the data will exclude StockCode data.
        """

        if ((stockcode is None) and (salesorder is None)) or ((stockcode is not None) and (salesorder is not None)):
            raise ValueError(f"Must pass either a SalesOrder # or a StockCode #. Got '{stockcode=}', '{salesorder=}'.")
        sc_mode: bool = stockcode is not None

        if sc_mode:
            sql = f"""
        SELECT
            [SD].[SalesOrder],
            [SD].[MStockCode],
            [SD].[MOrderUom],
            [SD].[MOrderQty],
            [SD].[MShipQty],
            [SD].[MBackOrderQty],
            [SD].[MPrice],
            [SD].[MDiscPct1],
            [SD].[MDiscPct2],
            [SD].[MDiscPct3],
            [SD].[MCustRequestDat],
            [SM].[ExchangeRate],
            [SM].[OrderDate],
            [SM].[OrderStatus],
            [SM].[ActiveFlag],
            [SM].[CancelledFlag],
            [SM].[LastOperator],
            [SM].[LastInvoice],
            [AC].[Name] AS [Customer],
            [AC].[ShortName],
            [AC].[SoldToAddr1],
            [AC].[SoldToAddr2],
            [AC].[SoldToAddr3],
            [SM].[ShipAddress1],
            [SM].[ShipAddress2],
            [SM].[ShipAddress3],
            [AC].[Contact],
            [AC].[Telephone],
            [AC].[Email],
            [AC].[Nationality],
            [AC].[DateCustAdded],
            [AC].[DateLastSale],
            [AC].[DateLastPay]
        FROM
            [SysproCompanyA].[dbo].[SorDetail] [SD] WITH (NOLOCK)
        INNER JOIN
            [SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
        ON
            [SD].[SalesOrder] = [SM].[SalesOrder]
        INNER JOIN
            [SysproCompanyA].[dbo].[ArCustomer] [AC] WITH (NOLOCK)
        ON
            [SM].[Customer] = [AC].[Customer]
        WHERE
    		(LTRIM(RTRIM(ISNULL([SD].[MStockCode], ''))) <> '')
            AND (LOWER([SD].[MStockCode]) = LOWER('{stockcode}'))
        """
        else:
            sql = f"""
        SELECT
            [SD].[SalesOrder],
            [SD].[MStockCode],
            [SD].[MOrderUom],
            [SD].[MOrderQty],
            [SD].[MShipQty],
            [SD].[MBackOrderQty],
            [SD].[MPrice],
            [SD].[MDiscPct1],
            [SD].[MDiscPct2],
            [SD].[MDiscPct3],
            [SD].[MCustRequestDat],
            [SM].[ExchangeRate],
            [SM].[OrderDate],
            [SM].[OrderStatus],
            [SM].[ActiveFlag],
            [SM].[CancelledFlag],
            [SM].[LastOperator],
            [SM].[LastInvoice],
            [AC].[Name] AS [Customer],
            [AC].[ShortName],
            [AC].[SoldToAddr1],
            [AC].[SoldToAddr2],
            [AC].[SoldToAddr3],
            [SM].[ShipAddress1],
            [SM].[ShipAddress2],
            [SM].[ShipAddress3],
            [AC].[Contact],
            [AC].[Telephone],
            [AC].[Email],
            [AC].[Nationality],
            [AC].[DateCustAdded],
            [AC].[DateLastSale],
            [AC].[DateLastPay]
        FROM
            [SysproCompanyA].[dbo].[SorDetail] [SD] WITH (NOLOCK)
        INNER JOIN
            [SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
        ON
            [SD].[SalesOrder] = [SM].[SalesOrder]
        INNER JOIN
            [SysproCompanyA].[dbo].[ArCustomer] [AC] WITH (NOLOCK)
        ON
            [SM].[Customer] = [AC].[Customer]
        WHERE
    		(LTRIM(RTRIM(ISNULL([SD].[MStockCode], ''))) <> '')
            AND (LOWER([SM].[SalesOrder]) = LOWER('{so_fmt(salesorder, out_type='str')}'))
        """
        df = connect(sql)
        df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, out_type="int"))
        return df


    def load_sales_order_pick_sheet(salesorder: str) -> pd.DataFrame:
        """Run the SO pick sheet logic from within Access to get the formatted and focused data on Sales Order StockCode data"""
        sql = f"""
    SELECT
        [SO].[SalesOrder],
        [SO].[SalesOrderLine],
        [SO].[MStockCode],
        [SO].[MStockDes],
        [IM].[LongDesc],
        [SO].[MStockingUom],
        [SO].[MWarehouse],
        [IW].[DefaultBin],
        [SO].[MOrderQty],
        [SO].[MShipQty],
        [SO].[MBackOrderQty],
        [SO].[MPrice],
        [IW].[QtyAllocated],
        [IW].[QtyAllocatedToPick],
        [IW].[QtyAllocatedWip],
        [IW].[QtyOnBackOrder],
        [IW].[QtyOnHand],
        [IW].[QtyOnOrder],
        [SM].[Customer],
        [SM].[CustomerName],
        [SM].[ShipAddress1],
        [SM].[ShipAddress2],
        [SM].[ShipAddress3],
        [SM].[ShipAddress3Loc],
        [SM].[ShipAddress4],
        [SM].[ShipAddress5],
        [IW].[QtyOnHand] - (
            [IW].[QtyAllocated] + [IW].[QtyAllocatedToPick] + [IW].[QtyAllocatedWip]
        ) AS Available,
        [SO].[MOrderQty] * (
            [SO].[MPrice] - (
                (([SO].[MPrice] * ([SO].[MDiscPct1] / 100))) + [SO].[MDiscValue]
            )
        ) AS Amount,
        [SO].[MOrderQty] * (
            (
                (([SO].[MPrice] * ([SO].[MDiscPct1] / 100))) + [SO].[MDiscValue]
            )
        ) AS Discount
    FROM
        (
            (
                [SysproCompanyA].[dbo].[SorDetail] AS [SO]
                LEFT JOIN [SysproCompanyA].[dbo].[InvWarehouse] AS [IW] ON ([SO].[MWarehouse] = [IW].[Warehouse])
                AND ([SO].[MStockCode] = [IW].[StockCode])
            )
            LEFT JOIN [SysproCompanyA].[dbo].[SorMaster] AS SM ON [SO].[SalesOrder] = [SM].[SalesOrder]
        )
        LEFT JOIN [SysproCompanyA].[dbo].[InvMaster] AS IM ON ([IM].[StockCode] = [IW].[StockCode])
        AND ([IW].[Warehouse] = [IM].[WarehouseToUse])
    WHERE
        (
            [SO].[SalesOrder] = RIGHT('000000000000000' + '{so_fmt(salesorder, out_type="str")}', 15)
        )
        AND (ISNULL([SO].[MStockCode], '') <> '')
    ;
    """
        df = connect(sql)
        df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, out_type="int"))
        return df


    df_sales_order_pick_sheets = load_sales_order_pick_sheet(115601)

    lst_pdfs_bytes = []
    for so in df_sales_order_pick_sheets["SalesOrder"].dropna().unique():
        f_name = f"SOPickSheet_{so}.pdf"
        lst_pdfs_bytes.append((
            f_name,
            generate_so_pick_sheet(
                df_sales_order_pick_sheets[df_sales_order_pick_sheets["SalesOrder"] == so],
                as_zip=False
            )
        ))
    # zip_bytes = build_zip_bytes(lst_pdfs_bytes)
    #
    # st.download_button(
    #     "Download Sales Order Pick Sheets",
    #     data=zip_bytes,
    #     file_name=f"reports_{datetime.datetime.now():%Y-%m-%d_%H%M%S}.zip",
    #     mime="application/zip",
    # )
