#!/usr/bin/env python3
"""Builds pitch/index.html from src/index.tpl.html, and pitch/short.html (the 3-minute version) from src/short.tpl.html.

Inlines the brand's doodles and illustrations so their pen strokes can be animated (a page opened from disk
cannot fetch SVG files). Tokens in the template:
  {{d:name class="..." attrs...}}   a doodle from src/doodles, drawn by the pen when its step appears
  {{ill:name class="..."}}          an illustration from assets/img, outlines traced and fills faded in
Run: python3 build.py
"""
import re
from pathlib import Path

HERE = Path(__file__).parent
TOKEN = re.compile(r"\{\{(d|ill):([a-z0-9-]+)((?:\s+[A-Za-z-]+=\"[^\"]*\")*)\s*\}\}")


def clean(svg: str) -> str:
    svg = re.sub(r"<\?xml[^>]*>", "", svg)
    svg = re.sub(r"<title>.*?</title>", "", svg, flags=re.S)
    head, rest = svg.split(">", 1)   # only the outer <svg> loses its fixed size, so CSS can size it
    head = re.sub(r'\s(width|height|role|aria-label)="[^"]*"', "", head)
    return (head + ">" + rest).strip()


def inline(m: re.Match) -> str:
    kind, name, attrs = m.group(1), m.group(2), m.group(3) or ""
    path = HERE / ("src/doodles" if kind == "d" else "assets/img") / f"{name}.svg"
    svg = clean(path.read_text(encoding="utf-8"))
    extra = dict(re.findall(r'([A-Za-z-]+)="([^"]*)"', attrs))
    base = "doodle draw" if kind == "d" else "ill trace"
    if extra.pop("static", None) is not None:
        base = "doodle" if kind == "d" else "ill"
    cls = f'{base} {extra.pop("class", "")}'.strip()
    more = " ".join(f'{k}="{v}"' for k, v in extra.items())
    return svg.replace("<svg ", f'<svg class="{cls}" aria-hidden="true" {more} ', 1)


def main() -> None:
    for src, dst in (("src/index.tpl.html", "index.html"), ("src/short.tpl.html", "short.html")):
        out = TOKEN.sub(inline, (HERE / src).read_text(encoding="utf-8"))
        (HERE / dst).write_text(out, encoding="utf-8")
        left = re.findall(r"\{\{[^}]*\}\}", out)
        print(f"{dst}: {len(out) // 1024} KB" + (f", unresolved: {left}" if left else ""))


if __name__ == "__main__":
    main()
