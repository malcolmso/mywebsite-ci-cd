# required
# pip install beautifulsoup4

from bs4 import BeautifulSoup
from pathlib import Path

# Paths
article_dir = Path("articles")
blog_path = Path("blog.html")

# Gather article entries
entries = []

for html_file in article_dir.glob("*.html"):
    if html_file.name.startswith("z"):  # Skip utility templates
        continue

    soup = BeautifulSoup(html_file.read_text(encoding="utf-8"), "html.parser")
    preview = soup.find("p")
    snippet = preview.text.strip() if preview else "No preview available"

    entry = f'<li><a href="articles/{html_file.name}">{html_file.stem}</a><br><em>{snippet}</em></li>'
    entries.append(entry)

# Load existing blog.html
blog_soup = BeautifulSoup(blog_path.read_text(encoding="utf-8"), "html.parser")

# Find <main><ul> and replace its contents
main = blog_soup.find("main")
ul = main.find("ul") if main else None

if ul:
    ul.clear()
    for entry_html in entries:
        ul.append(BeautifulSoup(entry_html, "html.parser"))
    blog_path.write_text(str(blog_soup), encoding="utf-8")
    print(f"✅ Blog updated with {len(entries)} article{'s' if len(entries) != 1 else ''}")
else:
    print("⚠️ Could not find <main><ul> in blog.html — no updates made.")
