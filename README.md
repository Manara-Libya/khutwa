# Khutwa (خطوة)

**A private first step toward a real person.** Khutwa is an AI assistant for young Libyans (18–25). It listens in Libyan dialect and Arabizi, and it removes identifying details on the phone before the AI sees any text. It suggests the right kind of human support and drafts the first message, which the user sends themselves. It never diagnoses.

Built for the AI4LY Codathon: Mental Health in Libya. Final pitch: 8 October 2026.

> Khutwa is not a therapist, a diagnostic tool or an emergency service.

## Docs

- [Project proposal](docs/proposal.md): scope, user journey, technical design, safety, roles, risks, claims
- [Challenge brief and research](docs/challenge-brief.md): the Minister's brief, judging criteria, evidence, full spec, evaluation sets
- Original documents: [`docs/references/`](docs/references/)

## Team

| Name | Role |
|---|---|
| Marwan Elamami | Team leader, application lead |
| Hiba Alshabani | AI lead |
| Ahmed Alaeb | TBD |
| Kawtar Gdoure | TBD |
| Anas Al-Thaabit | TBD |

## Working with Claude Code

This repo ships a shared Claude Code setup:

- `CLAUDE.md`: project context and the non-negotiable safety and privacy rules
- `.claude/settings.json`: shared plugins and permissions. Claude Code asks to install the plugins the first time you open the repo.

Personal overrides go in `.claude/settings.local.json`, which is git-ignored.

## Status

The stack hasn't been chosen yet (PWA or Android app); see the "Decisions needed" issue.
