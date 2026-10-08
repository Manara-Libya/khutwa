"""A2UI v0.8 surfaces (https://a2ui.org/specification/v0.8-a2ui/) for the support options.

The model never writes UI. The server builds the surface from suggestions that were already validated
against the schema and checked by the guardrail, using components from the standard catalog only.
Texts may contain placeholders such as [اسم1]; the phone puts real names back before rendering.

Actions are handled on the phone and never send anything to another person:
  khutwa.share  opens the share sheet with the edited draft (the user sends it themselves)
  khutwa.copy   copies the edited draft
"""
from .schemas import Suggestion

CATALOG = "https://a2ui.org/specification/v0_8/standard_catalog_definition.json"

TYPE_LABELS = {
    "trusted_friend": "صاحب تثق فيه",
    "academic_adviser": "أستاذ أو مرشد",
    "trusted_relative": "حد من العيلة تثق فيه",
    "community_figure": "شخص من المجتمع تثق فيه",
    "specialist": "مختص",
}


def _text(cid: str, text: str, hint: str | None = None) -> dict:
    body: dict = {"text": {"literalString": text}}
    if hint:
        body["usageHint"] = hint
    return {"id": cid, "component": {"Text": body}}


def _button(cid: str, label_id: str, action: str, draft_path: str, primary: bool) -> dict:
    return {"id": cid, "component": {"Button": {
        "child": label_id,
        "primary": primary,
        "action": {"name": action, "context": [{"key": "text", "value": {"path": draft_path}}]},
    }}}


def support_surface(suggestions: list[Suggestion], surface_id: str) -> list[dict]:
    """The support options as one A2UI surface: a card per option, with its reason, the draft in an
    editable field, and send-it-yourself / copy buttons. Messages are in the order the spec recommends."""
    components = [_text("title", "ناس ممكن تحكي معاهم", "h3"),
                  _text("subtitle", "اختار اللي تحس روحك مرتاح معاه، عدّل الرسالة، وابعتها بنفسك.", "caption")]
    cards, data = [], []
    for i, s in enumerate(suggestions):
        p = f"opt{i}"
        draft_path = f"/drafts/{p}"
        components += [
            _text(f"{p}-label", TYPE_LABELS.get(s.type, s.type), "h4"),
            _text(f"{p}-why", s.why, "body"),
            {"id": f"{p}-draft", "component": {"TextField": {
                "label": {"literalString": "رسالتك"},
                "text": {"path": draft_path},
                "textFieldType": "longText",
            }}},
            _text(f"{p}-share-label", "ابعتها بنفسك"),
            _text(f"{p}-copy-label", "انسخ"),
            _button(f"{p}-share", f"{p}-share-label", "khutwa.share", draft_path, primary=True),
            _button(f"{p}-copy", f"{p}-copy-label", "khutwa.copy", draft_path, primary=False),
            {"id": f"{p}-buttons", "component": {"Row": {"children": {"explicitList": [f"{p}-share", f"{p}-copy"]}}}},
            {"id": f"{p}-body", "component": {"Column": {"children": {"explicitList": [
                f"{p}-label", f"{p}-why", f"{p}-draft", f"{p}-buttons"]}}}},
            {"id": f"{p}-card", "component": {"Card": {"child": f"{p}-body"}}},
        ]
        cards.append(f"{p}-card")
        data.append({"key": p, "valueString": s.draft})
    components.append({"id": "root", "component": {"Column": {"children": {"explicitList": ["title", "subtitle", *cards]}}}})
    return [
        {"surfaceUpdate": {"surfaceId": surface_id, "components": components}},
        {"dataModelUpdate": {"surfaceId": surface_id, "path": "/drafts", "contents": data}},
        {"beginRendering": {"surfaceId": surface_id, "catalogId": CATALOG, "root": "root"}},
    ]
