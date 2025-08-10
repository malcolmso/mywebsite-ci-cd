#!/usr/bin/env python3
from pathlib import Path
from bs4 import BeautifulSoup
import sys, re

ARTICLE_DIR = Path("articles")
BLOG_PATH   = Path("blog.html")

SITE_HEADER_REGEX = re.compile(r"malcolm\s+soto\s*–?\s*article", re.I)

def log(msg: str) -> None:
    print(msg)

def ensure_blog_skeleton() -> BeautifulSoup:
    """Load blog.html and preserve header/footer, or create a minimal skeleton."""
    if not BLOG_PATH.exists():
        BLOG_PATH.write_text(
            "<!doctype html><html><head><title>Blog</title></head>"
            "<body><main><ul></ul></main></body></html>",
            encoding="utf-8",
        )

    # 🧼 Optional: reload fresh content to avoid stale DOM
    BLOG_PATH.write_text(BLOG_PATH.read_text(encoding="utf-8"), encoding="utf-8")

    soup = BeautifulSoup(BLOG_PATH.read_text(encoding="utf-8"), "html.parser")

    # Ensure <main> exists
    main = soup.find("main")
    if not main:
        main = soup.new_tag("main")
        soup.body.insert(0, main)

    return soup

def prettify_filename(name: str) -> str:
    return name.rsplit(".", 1)[0].replace("-", " ").title()

def first_real_heading(article_tag: BeautifulSoup) -> str | None:
    for tag in article_tag.find_all(["h1", "h2", "h3", "p"]):
        txt = tag.get_text(strip=True)
        if txt:
            return txt
    return None

def extract_title(soup: BeautifulSoup, filename: str) -> str:
    article_tag = soup.find("article")
    if article_tag:
        h_txt = first_real_heading(article_tag)
        if h_txt:
            return h_txt

    for tag in soup.find_all(["h1", "h2", "h3"]):
        txt = tag.get_text(strip=True)
        if txt and not SITE_HEADER_REGEX.fullmatch(txt):
            return txt

    title_tag = soup.find("title")
    if title_tag and title_tag.text.strip():
        return title_tag.text.strip()

    return prettify_filename(filename)

def extract_snippet(soup: BeautifulSoup) -> str:
    article_tag = soup.find("article")
    para = (article_tag.find("p") if article_tag else None) or soup.find("p")
    return para.get_text(strip=True) if (para and para.get_text(strip=True)) else "No preview available"

def main() -> int:
    entries, processed = [], 0
    seen = set()

    for html_file in sorted(ARTICLE_DIR.glob("*.html")):
        fname = html_file.name.lower()

        if fname.startswith(("z", "~")) or fname == "ztemplate.html" or fname == "blog.html":
            log(f"⏭️  Skipping {html_file.name}")
            continue

        try:
            soup = BeautifulSoup(html_file.read_text(encoding="utf-8"), "html.parser")
        except Exception as e:
            log(f"❌  Error parsing {html_file.name}: {e}")
            continue

        title   = extract_title(soup, html_file.name)
        snippet = extract_snippet(soup)

        key = (title.strip(), fname)
        if key in seen:
            log(f"⚠️  Duplicate skipped: {title} ({html_file.name})")
            continue

        seen.add(key)
        entry_html = (
            f'<li><a href="articles/{html_file.name}">{title}</a>'
            f'<br/><em>{snippet}</em></li>'
        )
        entries.append(entry_html)
        processed += 1
        log(f"✅  Added {html_file.name} → {title}")

    blog_soup = ensure_blog_skeleton()
    main_tag = blog_soup.find("main")

    # 🧼 Remove all existing <li> and <ul> elements inside <main>
    for li in main_tag.find_all("li"):
        li.decompose()
    for ul in main_tag.find_all("ul"):
        ul.decompose()

    # ✅ Inject fresh <ul> with new entries
    new_ul = blog_soup.new_tag("ul")
    for entry_html in entries:
        entry_soup = BeautifulSoup(entry_html, "html.parser")
        li = entry_soup.find("li")
        if li:
            new_ul.append(li)

    main_tag.append(new_ul)

    BLOG_PATH.write_text(str(blog_soup), encoding="utf-8")
    log(f"\n🎉 Blog updated with {processed} unique articles")
    return 0

if __name__ == "__main__":
    sys.exit(main())