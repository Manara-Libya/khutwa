"""Export the HTML deck to PDF.

    cd pitch && python3 build.py
    uv run --with playwright --with pypdf python tools/export_pdf.py     # writes khutwa-pitch.pdf

Every slide is printed by Chrome in its final state (all clicks shown), so the text stays real text: sharp at any
zoom, searchable and copyable, with the deck's fonts embedded. A video becomes a still from the demo with a link to
the recording on the download site. The title, closing and team slides carry links to the site and the repo.
«عرض مباشر» (showing the app live on the phone) is left out of the PDF.
"""
import asyncio, base64, os, subprocess, tempfile
from pathlib import Path

PITCH = Path(__file__).resolve().parent.parent
CHROME = os.environ.get("CHROME", "/usr/bin/google-chrome")
SITE = "khutwa-pi.vercel.app"
REPO = "github.com/Manara-Libya/khutwa"
LINKS = {"خطوة": "corner", "الختام": "mid", "ملحق · الفريق": "corner"}   # slides that carry the links, and where
SKIP = {"ملحق · عرض مباشر"}
# the still that stands in for each video: (file, second)
STILLS = {"media/demo.mp4": 20.02, "media/demo-full.mp4": 39.0}

PRINT_CSS = """
@page { size: 1920px 1080px; margin: 0; }
html, body { width: 1920px !important; height: 1080px !important; overflow: hidden !important; background: #F4F1EA !important; }
*, *::before, *::after { transition: none !important; animation: none !important; }
#progress, #start, #blackout { display: none !important; }
#stage { transform: none !important; left: 0 !important; top: 0 !important; }
.video-wrap .missing { display: none !important; }
.pdf-link { position: absolute; font: 600 24px/1.3 var(--hand); color: var(--green-deep); text-align: center; white-space: nowrap; }
.pdf-links { position: absolute; bottom: 46px; left: 140px; display: flex; gap: 34px; direction: rtl; font: 400 24px/1.4 var(--body); color: var(--ink-muted); }
.pdf-links.mid { left: 0; right: 0; bottom: 64px; justify-content: center; font-size: 26px; }
.pdf-links a { color: var(--ink); font-weight: 600; text-decoration: underline; text-decoration-color: var(--green); text-decoration-thickness: 3px; text-underline-offset: 6px; direction: ltr; unicode-bidi: isolate; }
.pdf-link b { font-family: "IBM Plex Sans Arabic", sans-serif; font-weight: 600; direction: ltr; unicode-bidi: isolate; color: var(--ink); text-decoration: underline; text-decoration-color: var(--green); text-decoration-thickness: 3px; text-underline-offset: 5px; }
"""

PREP_JS = r"""
([stills, links]) => {
  const sl = document.querySelector('.slide.active');
  const where = links[sl.dataset.title];
  if (where) {
    const box = document.createElement('div');
    box.className = 'pdf-links ' + where;
    box.innerHTML = '<span>التطبيق والعرض: <a href="https://%SITE%">%SITE%</a></span><span>الكود: <a href="https://%REPO%">%REPO%</a></span>';
    document.getElementById('stage').appendChild(box);
  }
  sl.querySelectorAll('.typed').forEach((t) => { t.dataset.run = ''; if (t.dataset.text) t.textContent = t.dataset.text; });
  sl.querySelectorAll('[data-count]').forEach((e) => { e.textContent = e.dataset.count; });
  sl.querySelectorAll('svg.doodle.draw, svg.ill.trace').forEach((s) => s.classList.add('drawn'));
  sl.querySelectorAll('[data-step]').forEach((e) => e.classList.add('on'));
  sl.querySelectorAll('[data-add-class]').forEach((e) => { const t = document.querySelector(e.dataset.target); if (t) t.classList.add(e.dataset.addClass); });
  sl.querySelectorAll('video').forEach((v) => {
    const src = v.getAttribute('src'), wrap = v.closest('.video-wrap') || v.parentElement;
    const img = document.createElement('img');
    img.src = stills[src]; img.style.cssText = 'width:100%;height:100%;object-fit:cover;display:block';
    v.replaceWith(img);
    // where to watch it: under the phone, inside the slide
    const r = wrap.getBoundingClientRect(), note = document.createElement('div');
    note.className = 'pdf-link';
    note.innerHTML = '<a href="https://%SITE%/#demo" style="color:inherit;text-decoration:none">شاهد التسجيل كاملًا<br><b>%SITE%</b></a>';
    note.style.left = (r.left + r.width / 2) + 'px'; note.style.top = (r.bottom + 22) + 'px'; note.style.transform = 'translateX(-50%)';
    document.getElementById('stage').appendChild(note);
  });
  const notes = [...sl.querySelectorAll('aside.notes p')].map((p) => ({ step: +p.dataset.step || 0, text: p.textContent.replace(/\s+/g, ' ').trim() }));
  return { title: sl.dataset.title || '', notes };
}
""".replace("%SITE%", SITE).replace("%REPO%", REPO)


def still(src: str, t: float, tmp: Path) -> str:
    out = tmp / (Path(src).stem + ".jpg")
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-ss", str(t), "-i", str(PITCH / src), "-frames:v", "1", "-q:v", "2", str(out)], check=True)
    return "data:image/jpeg;base64," + base64.b64encode(out.read_bytes()).decode()





async def main():
    from playwright.async_api import async_playwright
    from pypdf import PdfWriter, PdfReader
    tmp = Path(tempfile.mkdtemp(prefix="khutwa-pdf-"))
    stills = {src: still(src, t, tmp) for src, t in STILLS.items()}
    url = (PITCH / "index.html").as_uri()
    pages = []
    async with async_playwright() as p:
        b = await p.chromium.launch(executable_path=CHROME if Path(CHROME).exists() else None)
        pg = await b.new_page(viewport={"width": 1920, "height": 1080})
        pg.on("pageerror", lambda e: print("pageerror:", e))
        await pg.goto(url + "?nostart")
        n_slides = await pg.evaluate("document.querySelectorAll('#stage .slide').length")
        for i in range(n_slides):
            await pg.goto(f"{url}?slide={i + 1}&step=max")
            await pg.evaluate("document.fonts.ready")
            await pg.wait_for_timeout(1500)   # let the counters finish, so they don't overwrite their final value
            await pg.add_style_tag(content=PRINT_CSS)
            info = await pg.evaluate(PREP_JS, [stills, LINKS])
            if info["title"] in SKIP:
                continue
            await pg.wait_for_timeout(700)
            f = tmp / f"s{i + 1:02d}.pdf"
            await pg.pdf(path=str(f), width="1920px", height="1080px", print_background=True, page_ranges="1")
            info.update(pdf=f)
            pages.append(info)
            print(f"{len(pages):2d}  {info['title']}")
        w = PdfWriter()
        for P in pages:
            w.append(PdfReader(str(P["pdf"])))
        w.add_metadata({"/Title": "خطوة · Khutwa: خطوة أولى نحو شخص تثق به", "/Author": "فريق خطوة"})
        out = PITCH / "khutwa-pitch.pdf"
        with open(out, "wb") as fh:
            w.write(fh)
        print(f"{out.name}: {out.stat().st_size / 1e6:.1f} MB, {len(pages)} pages")
        await b.close()


if __name__ == "__main__":
    asyncio.run(main())
