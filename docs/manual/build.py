#!/usr/bin/env python3
"""The StandardOS manual: docs/manual/{guide,expert}/*.md -> one self-contained HTML file.

    python3 build.py OUT.html [--version TEXT]

Each .md file is one section: its first line is `# Title`, its `##`/`###`
headings make the menu. Files are taken in name order (01-…, 02-…); the
number is dropped from the section's address (#guide-updates). Links between
sections are plain anchors: [Updates](#guide-updates), or a heading inside one
(#guide-updates--going-back). The page needs nothing from the network: the
same file is the offline manual (Controls → Documentation, the `manual`
command) and the website's.
"""
import html
import json
import os
import re
import sys

import markdown
from markdown.extensions.toc import TocExtension, slugify_unicode

HERE = os.path.dirname(os.path.abspath(__file__))
PARTS = [
    ("guide", "Guide", "Using StandardOS, day to day"),
    ("expert", "Expert", "How it works, and how to go further"),
]


def section_files(part):
    folder = os.path.join(HERE, part)
    return [os.path.join(folder, f) for f in sorted(os.listdir(folder)) if f.endswith(".md")]


def plain(fragment):
    """Text of an HTML fragment, for the search index."""
    text = re.sub(r"<(script|style)[^>]*>.*?</\1>", " ", fragment, flags=re.S)
    text = re.sub(r"<[^>]+>", " ", text)
    return re.sub(r"\s+", " ", html.unescape(text)).strip()


def chunks(slug, title, body):
    """The search index's entries for one section: the part before the first
    heading, then one entry per ## / ### heading."""
    out = []
    pieces = re.split(r'(<h[23] id="[^"]+">.*?</h[23]>)', body, flags=re.S)
    current = {"id": slug, "title": title, "text": ""}
    for piece in pieces:
        m = re.match(r'<h[23] id="([^"]+)">(.*?)</h[23]>', piece, flags=re.S)
        if m:
            if current["text"] or current["id"] == slug:
                out.append(current)
            current = {"id": m.group(1), "title": f"{title} › {plain(m.group(2))}", "text": ""}
        else:
            current["text"] += " " + plain(piece)
    out.append(current)
    for c in out:
        c["text"] = c["text"].strip()[:4000]
        c["section"] = slug
    return out


def build(out_path, version):
    nav, sections, index = [], [], []
    for part, part_title, part_lead in PARTS:
        items = []
        for path in section_files(part):
            name = re.sub(r"^\d+-", "", os.path.basename(path)[:-3])
            slug = f"{part}-{name}"
            text = open(path, encoding="utf-8").read()
            m = re.match(r"#\s+(.+?)\s*\n", text)
            if not m:
                sys.exit(f"{path}: the first line must be '# Title'")
            title = m.group(1)
            md = markdown.Markdown(
                extensions=[
                    TocExtension(
                        slugify=lambda v, sep, s=slug: f"{s}--{slugify_unicode(v, sep)}",
                        toc_depth="2-3",
                    ),
                    "tables",
                    "fenced_code",
                    "attr_list",
                    "admonition",
                    "def_list",
                    "sane_lists",
                    "md_in_html",
                ]
            )
            body = md.convert(text[m.end():])
            toc = [{"id": t["id"], "name": html.unescape(t["name"])} for t in md.toc_tokens]
            items.append({"id": slug, "title": title, "toc": toc})
            sections.append(
                f'<section class="doc" id="{slug}" data-part="{part}">\n'
                f"<h1>{html.escape(title)}</h1>\n{body}\n</section>"
            )
            index.extend(chunks(slug, title, body))
        nav.append({"part": part, "title": part_title, "lead": part_lead, "sections": items})

    # Every link inside the manual must land somewhere.
    joined = "\n".join(sections)
    ids = set(re.findall(r'\sid="([^"]+)"', joined)) | {"home"}
    broken = sorted({h for h in re.findall(r'href="#([^"]+)"', joined) if h not in ids})
    for h in broken:
        print(f"warning: a link to #{h}, which is nowhere in the manual", file=sys.stderr)
    if broken and os.environ.get("MANUAL_STRICT") == "1":
        sys.exit(f"{len(broken)} broken link(s)")

    template = open(os.path.join(HERE, "template.html"), encoding="utf-8").read()
    page = (
        template.replace("{{VERSION}}", html.escape(version))
        .replace("{{NAV_JSON}}", json.dumps(nav, ensure_ascii=False).replace("</", "<\\/"))
        .replace("{{INDEX_JSON}}", json.dumps(index, ensure_ascii=False).replace("</", "<\\/"))
        .replace("{{SECTIONS}}", "\n".join(sections))
    )
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(page)
    words = sum(len(c["text"].split()) for c in index)
    print(f"{out_path}: {len(sections)} sections, {len(index)} search entries, ~{words} words")


if __name__ == "__main__":
    args = sys.argv[1:]
    version = "development"
    if "--version" in args:
        i = args.index("--version")
        version = args[i + 1]
        del args[i : i + 2]
    if len(args) != 1:
        sys.exit(__doc__)
    build(args[0], version)
