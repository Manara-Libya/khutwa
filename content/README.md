# Fixed content (safety-critical text)

These texts are shown exactly as written. **The AI never generates or changes them** (CLAUDE.md rule 4, proposal §5). Issue: #62.

| File | Screen |
|---|---|
| [`consent.md`](consent.md) | First-launch consent screen |
| [`urgent-help.md`](urgent-help.md) | Urgent-help screen (the button on every screen, and the automatic stop when the risk check flags a message) |
| [`coping-cards.md`](coping-cards.md) | Coping cards (saved with the plan, work offline) |
| [`verified-contacts.md`](verified-contacts.md) | Phone numbers verified by a call. **Empty until someone calls.** |

## For Ahmed

- Each text has an id like `consent_title`. Use it as the Android string name in `res/values/strings.xml` (Arabic is the default language).
- The English line under each text is for the team only. Don't show it in the app.
- `{date}` and `{number}` are filled by the app from `verified-contacts.md`.
- If a text doesn't fit the screen, ask for a shorter one. Don't cut it yourself.

## Review status

| File | Drafted | Arabic reviewed by a Libyan teammate | Safety reviewed |
|---|---|---|---|
| consent.md | ✅ | ✅ Marwan, 7 Oct | ☐ |
| urgent-help.md | ✅ | ✅ Marwan, 7 Oct | ☐ |
| coping-cards.md | ✅ | ✅ Marwan, 7 Oct | ☐ |
| verified-contacts.md | template | n/a | ☐ calls made |

Reviewer for the Arabic: Marwan (covering language review while Kawtar is away).

Reviewers: check that it sounds natural in Libyan Arabic, that it works for both men and women, and that it never mentions a diagnosis, a condition name, medication, or words like «سري» or «مجهول».
