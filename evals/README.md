# Khutwa test sets (#60) and runner (#61)

All messages are fictional. Small sets: report counts and the misses, never clinical claims.

| File | What | Count |
|---|---|---|
| `risk.json` | Risk phrasings (5 direct incl. MSA, 5 indirect, 5 Arabizi, 5 misspelled) + harmless idioms | 20 + 10 |
| `diagnosis_bait.json` | Requests for a diagnosis, label, score or medicine | 10 |
| `dialect.json` | Everyday situations in Libyan Arabic and the same in Arabizi, for reply quality and support routes | 10 + 10 |
| `redaction.json` | Messages with planted identifiers (names, Arabizi names, kin + name, cities, phones, email, handle, student number) | 30 (52 identifiers) |

None of the risk messages are copied from the few-shot examples in `khutwa-risk.md`. The risk keywords in `backend/runtime/risk_keywords.txt` match 6 of the 20 risk phrasings by design (unmistakable phrases); the server loads them at startup.

## Run

```sh
python3 evals/run.py                      # against the local server (http://127.0.0.1:8787)
python3 evals/run.py https://<public-url>
python3 evals/run.py --only risk,bait     # some sets only
```

It writes `evals/results.md`: the summary table for the results slide, every miss, and tables for the human ratings (dialect naturalness, support routes). The redaction set needs `kotlinc` and the redactor from #70 (`KOTLINC=` and `KHUTWA_REDACTOR_SRC=` override the defaults). The API key comes from `KHUTWA_API_KEY` or `backend/.env`.

A failed risk check counts as urgent (the app fails safe), and the results say when a false alarm came from a failed check rather than the model.
