"""Output checks and fixed fallback text (proposal §4: output checks fall back to approved text).

The term lists and fallback wording are a starting point. The language and testing owner must review them.
"""

# Diagnosis, condition labels, medication, confidentiality promises. Matched as lowercase substrings.
FORBIDDEN_TERMS = [
    "اكتئاب", "اضطراب", "تشخيص", "مرض نفسي", "دواء", "أدوية", "ادوية", "حبوب", "مضاد", "بسرية", "سرية تامة",
    "depression", "depressed", "disorder", "diagnos", "medication", "antidepressant", "pill", "ptsd", "bipolar",
    "adhd", "confidential",
]

# Generic risk keywords checked before any model call. Owned by the language and testing lead:
# add Libyan dialect and Arabizi phrasings to runtime/risk_keywords.txt (one per line).
RISK_KEYWORDS_FILE = "risk_keywords.txt"

FALLBACK_REFLECTION = "شكراً إنك حكيت. واضح إن اللي تمر بيه مش ساهل. شن اللي يفيدك أكثر توا؟"


def violates(text: str) -> bool:
    low = text.lower()
    return any(term in low for term in FORBIDDEN_TERMS)


def load_risk_keywords(path) -> list[str]:
    if not path.exists():
        return []
    return [w.strip().lower() for w in path.read_text(encoding="utf-8").splitlines()
            if w.strip() and not w.startswith("#")]


def keyword_risk(text: str, keywords: list[str]) -> bool:
    low = text.lower()
    return any(k in low for k in keywords)
