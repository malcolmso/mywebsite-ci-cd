# This script will:
# Load each .html file inside articles/
# Strip out the old layout if it exists
# Inject your current article-wrapper-top.html and article-wrapper-bottom.html around the content
# Save the result back to the same .html file


#!/usr/bin/env python3
# pip install python-docx lxml
from pathlib import Path

# Load wrapper content
top = Path("article-wrapper-top.html").read_text(encoding="utf-8")
bottom = Path("article-wrapper-bottom.html").read_text(encoding="utf-8")

# Loop through all HTML articles
for html_file in Path("articles").glob("*.html"):
    original = html_file.read_text(encoding="utf-8")

    # Optional: Strip old wrappers by finding <main> content
    start = original.find("<main>")
    end = original.rfind("</main>")

    if start != -1 and end != -1:
        core = original[start + len("<main>"):end].strip()
    else:
        core = original.strip()  # fallback if <main> not found

    # Rewrap with <main> tag
    wrapped_core = f"<main>\n{core}\n</main>"

    # Assemble new layout
    new_html = f"{top}\n{wrapped_core}\n{bottom}"
    html_file.write_text(new_html, encoding="utf-8")
    print(f"✅ Retrofitted: {html_file.name}")
