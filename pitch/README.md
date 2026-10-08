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

**Demo video:** put the recording at `pitch/media/demo.mp4`; it plays on the first click of slide 8.

**Edit:** slides and their script live together in `src/index.tpl.html` (each `<aside class="notes">` line has the `data-step` it belongs to). Run `python3 build.py` after editing to produce `index.html`.
