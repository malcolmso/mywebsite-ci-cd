#!/usr/bin/env python3
# pip install python-docx lxml
from pathlib import Path
from docx import Document
from docx.opc.constants import RELATIONSHIP_TYPE as RT
from docx.oxml.ns import qn
import re, sys

###############################################################################
# Utility helpers
###############################################################################

def slugify(text: str) -> str:
    """Simplistic slug generator (lowercase, a‑z0‑9, ‘-’)."""
    return re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")

###############################################################################
# Paths / wrapper templates
###############################################################################

ARTICLE_DIR = Path("articles")
TOP_WRAPPER = Path("article-wrapper-top.html").read_text(encoding="utf-8")
BOT_WRAPPER = Path("article-wrapper-bottom.html").read_text(encoding="utf-8")

###############################################################################
# Main conversion loop
###############################################################################

for docx_file in ARTICLE_DIR.glob("*.docx"):
    # Skip Office lock files such as "~$foo.docx"
    if docx_file.name.startswith(("~$", ".")):
        continue

    try:
        doc         = Document(docx_file)
        doc_title   = (doc.core_properties.title or doc.paragraphs[0].text).strip()
        slug        = slugify(doc_title) or docx_file.stem
        html_path   = ARTICLE_DIR / f"{slug}.html"
        image_dir   = Path("assets/images") / slug
        image_dir.mkdir(parents=True, exist_ok=True)

        html_parts  = []
        image_count = 0
        rels        = doc.part._rels

        # ---------- Insert the H1 heading first ----------
        html_parts.append(f"<h1>{doc_title}</h1>\n")

        # ---------- Iterate through paragraphs ----------
        for para in doc.paragraphs:
            text = para.text.strip()
            if text:
                html_parts.append(f"<p>{text}</p>\n")

            # Images inside each run
            for run in para.runs:
                for blip in run._element.findall(".//" + qn("a:blip")):
                    rid = blip.get(qn("r:embed"))
                    if rid and rid in rels and rels[rid].reltype == RT.IMAGE:
                        image_part = rels[rid].target_part
                        image_count += 1
                        img_name = f"{slug}-img{image_count}.png"
                        (image_dir / img_name).write_bytes(image_part.blob)
                        html_parts.append(
                            f'<img src="../assets/images/{slug}/{img_name}" '
                            f'alt="Image {image_count}" style="max-width:600px; '
                            f'display:block;margin:1rem auto;border-radius:8px;" />\n'
                        )

        # ---------- Assemble and write ----------
        full_html = f"{TOP_WRAPPER}\n<article>\n{''.join(html_parts)}</article>\n{BOT_WRAPPER}"
        html_path.write_text(full_html, encoding="utf-8")
        print(f"✅ Converted: {docx_file.name} → {html_path.name} ({image_count} image{'s' if image_count!=1 else ''})")

    except Exception as e:
        print(f"❌ Error processing {docx_file.name}: {e}", file=sys.stderr)
