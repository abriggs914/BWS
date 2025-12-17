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
from reportlab.platypus import (
    BaseDocTemplate,
    SimpleDocTemplate,
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
    orientation: str = "Portrait"
    margin_left: float = 0.75 * inch
    margin_right: float = 0.75 * inch
    margin_top: float = 0.75 * inch
    margin_bottom: float = 0.75 * inch

    base_font: str = "Helvetica"
    mono_font: str = "Courier"

    header_height: float = 0.35 * inch
    footer_height: float = 0.35 * inch

    # Table defaults
    table_header_bg = colors.HexColor("#EDEDED")
    table_grid = colors.HexColor("#BDBDBD")
    zebra_bg = colors.HexColor("#F7F7F7")


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
                f"Page {doc.page+1}",
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


def df_table(
    df: pd.DataFrame,
    theme: PDFTheme,
    styles: dict[str, ParagraphStyle],
    *,
    col_widths: Optional[Sequence[float]] = None,
    zebra: bool = True,
    header_repeat: bool = True,
    max_rows: Optional[int] = None,
    number_format: Optional[dict[str, str]] = None,
) -> Table:
    """
    DataFrame -> ReportLab Table.

    number_format: mapping of column -> format string, e.g. {"Value": "{:,.2f}"}
    """
    if max_rows is not None:
        df = df.head(max_rows)

    number_format = number_format or {}

    # Build rows: header + body
    cols = list(df.columns)
    data: list[list[Any]] = [cols]

    for _, row in df.iterrows():
        out_row = []
        for c in cols:
            v = row[c]
            if pd.isna(v):
                out_row.append("")
            elif c in number_format:
                try:
                    out_row.append(number_format[c].format(v))
                except Exception:
                    out_row.append(str(v))
            else:
                out_row.append(str(v))
        data.append(out_row)

    tbl = Table(data, colWidths=col_widths, repeatRows=1 if header_repeat else 0)

    # Style
    ts = TableStyle([
        ("FONTNAME", (0, 0), (-1, -1), theme.base_font),
        ("FONTSIZE", (0, 0), (-1, -1), 9),
        ("LEADING", (0, 0), (-1, -1), 11),
        ("BACKGROUND", (0, 0), (-1, 0), theme.table_header_bg),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.black),
        ("LINEBELOW", (0, 0), (-1, 0), 1, theme.table_grid),
        ("GRID", (0, 0), (-1, -1), 0.25, theme.table_grid),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("LEFTPADDING", (0, 0), (-1, -1), 6),
        ("RIGHTPADDING", (0, 0), (-1, -1), 6),
        ("TOPPADDING", (0, 0), (-1, -1), 3),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
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
    return buf, doc


def build_zip_bytes(named_files: list[tuple[str, bytes]]) -> bytes:
    zbuf = io.BytesIO()
    with zipfile.ZipFile(zbuf, mode="w", compression=zipfile.ZIP_DEFLATED) as zf:
        for filename, data in named_files:
            print(f"{filename=}: {len(data)} bytes")
            zf.writestr(filename, data)
    return zbuf.getvalue()


def add_grid_template(
    doc: BaseDocTemplate,
    theme: PDFTheme,
    template_id: str = "grid_2x2",
    rows: int = 2,
    cols: int = 2,
    gutter: float = 0.2 * inch,
):
    """
    Creates a PageTemplate with rows x cols Frames inside the content area.
    Flowables fill frames left-to-right, top-to-bottom by default.
    Use FrameBreak() to jump to next cell; PageBreak() to go next page.
    """
    content_x = doc.leftMargin
    content_y = doc.bottomMargin + theme.footer_height
    content_w = doc.width
    content_h = doc.height - theme.header_height - theme.footer_height

    cell_w = (content_w - gutter * (cols - 1)) / cols
    cell_h = (content_h - gutter * (rows - 1)) / rows

    frames = []
    for r in range(rows):
        for c in range(cols):
            x = content_x + c * (cell_w + gutter)
            # top row should be highest y; Frame uses bottom-left origin
            y = content_y + (rows - 1 - r) * (cell_h + gutter)
            frames.append(Frame(x, y, cell_w, cell_h, id=f"cell_{r}_{c}"))

    if isinstance(doc, ReportDocTemplate):
        tpl = PageTemplate(
            id=template_id,
            frames=frames,
            onPage=doc._draw_header_footer,
        )
    else:
        tpl = PageTemplate(
            id=template_id,
            frames=frames
        )
    doc.addPageTemplates([tpl])



# -----------------------------
# Example usage (copy into your script)
# -----------------------------
if __name__ == "__main__":

    report_file_name: str = "demo_report.pdf"
    report_title: str = "Demo Report"
    report_subtitle: str = "ReportLab skeleton"
    report_author: str = "Avery Briggs"

    theme = PDFTheme(page_size=LETTER)
    meta = PDFMeta(
        title=report_title,
        subtitle=report_subtitle,
        author=report_author,
    )
    styles = build_styles(theme)

    df = pd.DataFrame({
        "Item": ["A", "B", "C"],
        "Qty": [10, 25, 7],
        "Value": [1234.5, 9876.0, 50.25],
    })

    story = []
    story += [
        h1("Demo Report", styles),
        p("This is a quick demo of the skeleton.", styles),
        vspace(10)
    ]

    # TOC (optional) — headings added after it will populate it
    story += toc(styles)

    story += [h1("Section 1", styles), p("Some paragraph text.", styles)]
    story += [h2("A table from a DataFrame", styles)]
    story += [df_table(df, theme, styles, number_format={"Value": "{:,.2f}"})]
    story += [vspace(12)]

    # If you have a matplotlib chart saved as PNG:
    # plt.savefig("chart.png", dpi=150, bbox_inches="tight")
    # story += [h2("A figure", styles)]
    # story += figure("chart.png", styles, caption="Figure 1: Example chart", max_width=6.5*inch)

    out = build_pdf(report_file_name, story, theme=theme, meta=meta)
    print(f"Wrote: {out.resolve()}")
