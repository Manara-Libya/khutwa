"""Request and response models (they also generate the OpenAPI spec)."""
from typing import Literal

from pydantic import BaseModel, Field

from . import config

Situation = Literal["study_pressure", "family_tension", "loneliness", "low_mood_sleep_worry",
                    "loss_displacement", "harassment"]
SupportType = Literal["trusted_friend", "academic_adviser", "trusted_relative", "community_figure", "specialist"]
RiskLevel = Literal["none", "possible", "high"]


class TextIn(BaseModel):
    text: str = Field(min_length=1, max_length=config.MAX_TEXT_CHARS,
                      description="User text **after on-device redaction**. Never send raw identifiers.",
                      examples=["rani ta3bana barsha min el imti7anat w el 7osh kollah mashakel"])


class Turn(BaseModel):
    role: Literal["user", "assistant"]
    text: str = Field(min_length=1, max_length=config.MAX_TEXT_CHARS)


class AnalyzeIn(TextIn):
    history: list[Turn] | None = Field(
        default=None, max_length=12,
        description="Earlier turns of this conversation, oldest first, **redacted on the phone** like `text`. "
                    "The phone keeps them in memory and sends them with each message; the server stores nothing. "
                    "When `history` is sent (even empty), suggestions are held back until the user's "
                    f"{config.SUGGEST_AFTER}th message or until they ask who to talk to (`support_ready`). "
                    "Omit it for the old behaviour (suggestions on every message).")
    memory: str | None = Field(
        default=None, max_length=config.MAX_MEMORY_CHARS,
        description="Short notes from the user's earlier chats (from /v1/remember), **redacted on the phone** like `text`. "
                    "Only sent when the user turned on saved chats; the phone keeps them, the server stores nothing.")
    defer_support: bool = Field(
        default=False,
        description="When true, /v1/analyze does not wait for the support options: it returns the reply as soon as it "
                    "is ready, with support_ready set, and the app fetches the options from /v1/support.")


class RememberIn(BaseModel):
    history: list[Turn] = Field(min_length=1, max_length=12,
                                description="The conversation so far, oldest first, **redacted on the phone**.")
    memory: str | None = Field(default=None, max_length=config.MAX_MEMORY_CHARS,
                               description="The current notes, redacted with the same placeholders, to update.")


# --- what the models must return (validated before use) ---
class RiskModelOut(BaseModel):
    risk: RiskLevel


class ReflectModelOut(BaseModel):
    reflection: str = Field(min_length=1, max_length=600)


class RememberModelOut(BaseModel):
    memory: str = Field(max_length=config.MAX_MEMORY_CHARS)


class Suggestion(BaseModel):
    type: SupportType
    why: str = Field(min_length=1, max_length=300, description="One-line reason shown as 'why this suggestion'.")
    draft: str = Field(min_length=1, max_length=500, description="Draft first message; the user edits and sends it.")


class SuggestModelOut(BaseModel):
    situation: list[Situation] = Field(max_length=6)
    suggestions: list[Suggestion] = Field(min_length=1, max_length=3)


# --- API responses ---
class RiskOut(BaseModel):
    risk: Literal["none", "possible", "high", "unknown"] = Field(
        description="'unknown' means the check failed; clients must treat anything but 'none' as urgent.")
    urgent: bool


class ReflectOut(BaseModel):
    reflection: str
    fallback: bool = Field(description="True when approved fixed text replaced the model output.")


class RememberOut(BaseModel):
    memory: str | None = Field(description="The updated notes (placeholders as sent), or null to keep the current ones.")
    fallback: bool = Field(description="True when the notes could not be updated; the phone keeps what it has.")


class SuggestOut(BaseModel):
    situation: list[Situation]
    suggestions: list[Suggestion]
    fallback: bool


class AnalyzeOut(BaseModel):
    urgent: bool = Field(description="True: stop and show the fixed urgent-help screen. No AI text is returned.")
    risk: Literal["none", "possible", "high", "unknown"]
    reflection: str | None = None
    situation: list[Situation] = []
    suggestions: list[Suggestion] = []
    fallback: bool = False
    support_ready: bool = Field(default=True, description="False while Khutwa is still listening: no support options yet, keep the conversation going. True: show the support options (`suggestions`, or the generic ones if empty).")
    a2ui: list[dict] = Field(default=[], description="A2UI v0.8 messages (surfaceUpdate, dataModelUpdate, beginRendering) that render the "
                             "support options inline: a card per option with its reason, the editable draft and send-it-yourself / copy "
                             "buttons. Built by the server from validated suggestions; empty until support_ready.")
    elapsed_ms: int


class SupportOut(BaseModel):
    situation: list[Situation] = []
    suggestions: list[Suggestion] = []
    fallback: bool = Field(description="True when the suggestions are unavailable; show the generic options.")
    a2ui: list[dict] = Field(default=[], description="A2UI v0.8 messages rendering the options inline (see AnalyzeOut.a2ui).")


# --- OpenAI-compatible chat (development use) ---
class ChatMessage(BaseModel):
    role: Literal["system", "user", "assistant"]
    content: str = Field(max_length=config.MAX_TEXT_CHARS)


class ChatCompletionRequest(BaseModel):
    model: str = Field(default=config.QUALITY_MODEL, examples=[config.QUALITY_MODEL])
    messages: list[ChatMessage] = Field(min_length=1, max_length=40)
    stream: bool = False
    temperature: float | None = Field(default=None, description="Accepted for compatibility; ignored.")
    max_tokens: int | None = Field(default=None, description="Accepted for compatibility; ignored.")


# --- developer tools (prompt tuning) ---
TunableTask = Literal["risk", "reflect", "suggest"]


class DevTryIn(BaseModel):
    task: TunableTask
    text: str = Field(min_length=1, max_length=config.MAX_TEXT_CHARS)
    model: str | None = Field(default=None, description="Defaults to the task's preferred model.")
    prompt: str | None = Field(default=None, max_length=8000,
                               description="Draft prompt body to try. Omit to use the live prompt.")
    history: list[Turn] | None = Field(default=None, max_length=12,
                                       description="Earlier turns, to try a prompt in the middle of a conversation.")


class DevTryOut(BaseModel):
    raw: str
    parsed: dict | None
    valid: bool = Field(description="Parsed and matched the task's JSON schema.")
    guardrail: bool = Field(description="True if the output contains a blocked term (diagnosis, medication...).")
    model: str
    elapsed_ms: int


class DevPrompt(BaseModel):
    prompt: str = Field(min_length=20, max_length=8000)
