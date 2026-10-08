# Khutwa pitch deck

An HTML deck with a synced script window, in the Khutwa design system. Works offline from disk.

**Run:** open `pitch/index.html` in Chrome. On the start screen press «افتح نافذة النص» and drag that window to the second monitor, then «ملء الشاشة وابدأ» on the deck.

| Key (either window) | Action |
|---|---|
| `→` `↓` `Space` `PageDown` | next step |
| `←` `↑` `PageUp` | previous step |
| `F` | full screen (deck) |
| `S` | open the script window (deck) |
| `B` | black screen (deck) |
| `R` | reset the timer |
| `+` / `-` | bigger / smaller script text (script window) |

Click a line in the script window to jump there. `index.html?slide=8&step=2` opens a given point for rehearsal.

**Demo video (slide 9):** `media/demo.mp4` is a 25-second cut of the full recording, in six chapters. Each click plays one chapter and holds on its last frame while you talk; going back shows the previous chapter's last frame. The chapter end times are in the `<video data-chapters>` attribute; `media/cut.py` makes the cut from the raw recording and prints them.

**Backup slides** (after «الختام»): «العرض كاملًا» plays `media/demo-full.mp4`, the whole 100-second recording, uncut, on the first click (it has player controls too); «عرض مباشر» is for showing the app live on the phone. Use them only if there's time.

**Re-recording the demo:** `media/record-demo.sh <out-dir>` drives the phone over adb (Omar's messages, Do Not Disturb on while recording) and pulls `raw.mp4`; its header has the ffmpeg commands that make `demo.mp4` (via `media/cut.py`) and `demo-full.mp4`.

**PDF:** `khutwa-pitch.pdf` (24 pages) is the deck to send ahead or hand out: every slide in its final state, the text real and searchable, the demo as a still with a link to the recording, and links to the site and the repo on the title, closing and team slides. Make it again with `uv run --with playwright --with pypdf python tools/export_pdf.py`.

**PowerPoint:** `khutwa-pitch.pptx` is the same deck for a computer without Chrome. Every click is a PowerPoint animation (float, zoom, wipe, the typed message that erases itself), the demo plays one chapter per click, and the script is in the speaker notes, one click per HTML step. The slides are pictures of the HTML deck, so the text isn't editable there: edit `src/index.tpl.html`, then `python3 build.py && uv run --with playwright --with python-pptx python tools/export_pptx.py`.

**Edit:** slides and their script live together in `src/index.tpl.html` (each `<aside class="notes">` line has the `data-step` it belongs to). Run `python3 build.py` after editing to produce `index.html`.
