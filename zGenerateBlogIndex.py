# required
# pip install beautifulsoup4



from bs4 import BeautifulSoup
from pathlib import Path

# Paths
article_dir = Path("articles")
blog_path = article_dir.parent / "blog.html"
top = Path("article-wrapper-top.html").read_text(encoding="utf-8")
bottom = Path("article-wrapper-bottom.html").read_text(encoding="utf-8")

entries = []

# Loop through all .html articles
for html_file in article_dir.glob("*.html"):
    if html_file.name.startswith("z"):  # Skip script-generated templates
        continue

    soup = BeautifulSoup(html_file.read_text(encoding="utf-8"), "html.parser")
    preview = soup.find("p")
    snippet = preview.text.strip() if preview else "No preview available"

    link = f'<li><a href="articles/{html_file.name}">{html_file.stem}</a><br><em>{snippet}</em></li>'
    entries.append(link)

# Inject blog content inside main section
blog_body = "<h2>Recent Articles</h2>\n<ul>\n" + "\n".join(entries) + "\n</ul>"

# Final HTML wrapped with full layout
full_html = f"{top}\n{blog_body}\n{bottom}"
blog_path.write_text(full_html, encoding="utf-8")
print(f"✅ Blog page regenerated with {len(entries)} article{'s' if len(entries) != 1 else ''}")