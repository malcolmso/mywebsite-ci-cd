#!/usr/bin/env python3
# pip install beautifulsoup4
from pathlib import Path
from bs4 import BeautifulSoup
import sys, re

ARTICLE_DIR = Path("articles")
BLOG_PATH   = Path("blog.html")

###############################################################################
# Helper functions
###############################################################################

SITE_HEADER_REGEX = re.compile(r"malcolm\s+soto\s*–?\s*article", re.I)

def log(msg: str) -> None:
    print(msg)

def ensure_blog_skeleton() -> BeautifulSoup:
    """Load blog.html or create a minimal skeleton with <main><ul>."""
    if not BLOG_PATH.exists():
        BLOG_PATH.write_text(
            "<!doctype html><html><head><title>Blog</title></head>"
            "<body><main><ul></ul></main></body></html>",
            encoding="utf-8",
        )

    soup = BeautifulSoup(BLOG_PATH.read_text(encoding="utf-8"), "html.parser")
    main = soup.find("main") or soup.new_tag("main")
    if not soup.find("main"):
        soup.body.append(main)

    ul = main.find("ul") or soup.new_tag("ul")
    if not main.find("ul"):
        main.append(ul)

    return soup

def prettify_filename(name: str) -> str:
    return name.rsplit(".", 1)[0].replace("-", " ").title()

def first_real_heading(article_tag: BeautifulSoup) -> str | None:
    """
    Return the first non‑empty heading (h1‑h3) or bold paragraph inside <article>.
    """
    for tag in article_tag.find_all(["h1", "h2", "h3", "p"]):
        txt = tag.get_text(strip=True)
        if txt:
            return txt
    return None

def extract_title(soup: BeautifulSoup, filename: str) -> str:
    """
    Determine the best title in priority order:
      1. First h1/h2/h3/*p* inside <article>
      2. First global h1/h2/h3 that is NOT the site header
      3. <title> tag
      4. Prettified filename
    """
    # 1. Inside <article>
    article_tag = soup.find("article")
    if article_tag:
        h_txt = first_real_heading(article_tag)
        if h_txt:
            return h_txt

    # 2. Global headings
    for tag in soup.find_all(["h1", "h2", "h3"]):
        txt = tag.get_text(strip=True)
        if txt and not SITE_HEADER_REGEX.fullmatch(txt):
            return txt

    # 3. <title>
    title_tag = soup.find("title")
    if title_tag and title_tag.text.strip():
        return title_tag.text.strip()

    # 4. Fallback
    return prettify_filename(filename)

def extract_snippet(soup: BeautifulSoup) -> str:
    """Use first paragraph inside <article>; otherwise first global <p>; else default."""
    article_tag = soup.find("article")
    para = (article_tag.find("p") if article_tag else None) or soup.find("p")
    return para.get_text(strip=True) if (para and para.get_text(strip=True)) else "No preview available"

###############################################################################
# Main routine
###############################################################################

def main() -> int:
    entries, processed = [], 0

    for html_file in sorted(ARTICLE_DIR.glob("*.html")):
        if html_file.name.startswith(("z", "~")):
            log(f"⏭️  Skipping {html_file.name}")
            continue

        try:
            soup = BeautifulSoup(html_file.read_text(encoding="utf-8"), "html.parser")
        except Exception as e:
            log(f"❌  Error parsing {html_file.name}: {e}")
            continue

        title   = extract_title(soup, html_file.name)
        snippet = extract_snippet(soup)

        entries.append(
            f'<li><a href="articles/{html_file.name}">{title}</a>'
            f'<br/><em>{snippet}</em></li>'
        )
        processed += 1
        log(f"✅  Added {html_file.name} → {title}")

    blog_soup = ensure_blog_skeleton()
    ul_tag = blog_soup.find("main").find("ul")
    ul_tag.clear()
    ul_tag.append(BeautifulSoup("\n".join(entries), "html.parser"))
    BLOG_PATH.write_text(str(blog_soup), encoding="utf-8")

    log(f"\n🎉 Blog updated with {processed} articles")
    return 0

if __name__ == "__main__":
    sys.exit(main())
