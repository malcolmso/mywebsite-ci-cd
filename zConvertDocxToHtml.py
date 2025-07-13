# Run this on new builds to convert .docx files to HTML!
# # pip install python-docx
# Convert .docx files to HTML with images

# install lxml if not already installed
# pip install lxml

from docx import Document
from docx.opc.constants import RELATIONSHIP_TYPE as RT
from docx.oxml.ns import qn
from pathlib import Path

# Setup paths
article_dir = Path("articles")
top = Path("article-wrapper-top.html").read_text(encoding="utf-8")
bottom = Path("article-wrapper-bottom.html").read_text(encoding="utf-8")

# Loop through .docx files
for docx_file in article_dir.glob("*.docx"):
    basename = docx_file.stem
    html_path = article_dir / f"{basename}.html"
    image_dir = Path("assets/images") / basename  # 🆕 Unique folder per doc
    image_dir.mkdir(parents=True, exist_ok=True)

    html_parts = []
    image_count = 0

    try:
        doc = Document(docx_file)
        rels = doc.part._rels

        # Loop through paragraphs and runs sequentially
        for para in doc.paragraphs:
            # Add paragraph text
            text = para.text.strip()
            if text:
                html_parts.append(f"<p>{text}</p>")

            # Check each run for embedded drawing
            for run in para.runs:
                drawings = run._element.findall(".//" + qn("a:blip"))
                for blip in drawings:
                    embed_id = blip.get(qn("r:embed"))
                    if embed_id and embed_id in rels and rels[embed_id].reltype == RT.IMAGE:
                        image_part = rels[embed_id].target_part
                        image_data = image_part.blob
                        image_count += 1
                        img_name = f"{basename}-img{image_count}.png"
                        img_path = image_dir / img_name
                        with open(img_path, "wb") as f:
                            f.write(image_data)

                        html_parts.append(
                            f'<img src="../assets/images/{basename}/{img_name}" alt="Image {image_count}" '
                            f'style="max-width:600px; border:none; outline:none; box-shadow:none; '
                            f'border-radius:8px; margin:1rem auto; display:block;" />'
                        )

        # Compose and save final HTML
        full_html = f"{top}\n{''.join(html_parts)}\n{bottom}"
        html_path.write_text(full_html, encoding="utf-8")
        print(f"✅ Converted: {docx_file.name} → {html_path.name} ({image_count} image{'s' if image_count != 1 else ''})")

    except Exception as e:
        print(f"❌ Error processing {docx_file.name}: {e}")