# Khutwa (خطوة)

A private AI assistant that helps a young Libyan (18–25) take the first step toward a real person for support. It works in Libyan dialect and Arabizi, and it removes identifying details on the device before any text reaches the AI. Built for the AI4LY Codathon (Mental Health in Libya). **The final pitch is 8 October 2026.**

## Source of truth

Read these before designing anything; don't re-derive what's already in them.

- `docs/proposal.md`: our proposal (scope, journey, technical design, safety, team, risks, claims). Images are in `docs/media/proposal/`.
- `docs/challenge-brief.md`: the challenge brief and research. Use §3 for the Minister's brief and criteria, §8 for the full Khutwa spec, §8.18 and Appendix A for the evaluation sets, Appendix B for the user-test script, Appendix C for safe and unsafe claims, and §12 for references.
- The original .docx files are in `docs/references/`. If they differ from the Markdown, the .docx wins.

## Judging criteria (from the Minister's brief)

Innovation · applicability in Libya · genuine use of AI · privacy protection. No diagnosis is a hard limit.

## Non-negotiable product rules

These come from the proposal. Never weaken them to make a demo work.

1. **No diagnosis, label, score or medication advice.** Ever, in any prompt, fallback or UI text.
2. **Identifiers are redacted on the device.** Names, places, phone numbers, emails and digit patterns are removed before any network call, and the user sees exactly what will be sent and can tap any word to remove it. The backend and the model only ever receive redacted text.
3. **The urgent-help button is on every screen** and never depends on risk detection. The risk check (keyword list plus LLM classifier) **fails toward** the safety screen when it is unsure.
4. **Safety-critical content is fixed text, never generated.** This covers the urgent-help screen, the coping cards and any contacts. Only show a phone number or service the team has verified by phone, with its verified-on date.
5. **Nothing is sent to another person automatically.** The user copies or sends the drafted message themselves.
6. **No accounts, no server-side conversation logs, no analytics on conversation text.** The plan is stored only on the device, works offline, and is deleted with one tap. Error logs must contain no conversation text.
7. **No engagement tricks** (streaks, nudges, guilt messages). The app pushes toward people, not more chatting.
8. **Never assume family is safe.** Support suggestions come from the fixed list in the proposal (§3) and include a one-line "why this suggestion". The user chooses.
9. **Honest claims only.** Follow the claims table in proposal §11. Never write "anonymous", "end-to-end encrypted", "certified", "compliant", "clinically validated" or "first in the world" in code, UI or slides.
10. **All test data is fictional.** No real names or real conversations in the repo.

## Stack

**Not chosen yet**: the team is deciding between a PWA and a quick Android app. Don't scaffold an app or add dependencies until the decision is recorded here. The LLM provider is also undecided, so keep it behind one swappable interface in our own backend, with structured (JSON) outputs.

## Team and ownership

| Workstream (proposal §8) | Owner |
|---|---|
| 1. Frontend / app (screens, RTL, privacy panel, offline, urgent button) | Marwan Elamami (team leader) |
| 2. AI and backend (model calls, prompts, guardrails, risk check, fallbacks) | Hiba Alshabani |
| 3. Privacy shield (on-device redaction, tap-to-redact, delete, recall test) | TBD |
| 4. Language and testing (dialect/Arabizi sets, evals, user test) | TBD |
| 5. Pitch, evidence and safety (slides, demo, backup video, verified emergency route) | TBD |

## Working rules

- This is a one-day build: make small, direct changes and keep one complete demo path working end to end. Use the heavy planning skills (brainstorm, plan, subagents) only for multi-file features.
- Branch from `main` as `<area>/<short-name>` (e.g. `privacy/tap-to-redact`), open a PR, and link the issue. Keep PRs small so five people can merge all day.
- If time runs short, cut stretch items (role-play, reminders) first. Never cut the safety screen or the measured results.
- Arabic UI is right-to-left. Test with real Libyan dialect and Arabizi strings from `docs/challenge-brief.md` Appendix A.
- Secrets go in `.env` (git-ignored), never in code or commits.
