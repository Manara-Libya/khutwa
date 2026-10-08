import os

os.environ["KHUTWA_API_KEY"] = "test-key-" + "x" * 40
os.environ["KHUTWA_RATE_LIMIT_PER_MINUTE"] = "1000"

import pytest  # noqa: E402
from fastapi.testclient import TestClient  # noqa: E402

from khutwa_api import config, main  # noqa: E402
from khutwa_api.schemas import ReflectModelOut, RememberModelOut, RiskModelOut, Suggestion, SuggestModelOut  # noqa: E402

config.API_KEY = os.environ["KHUTWA_API_KEY"]
AUTH = {"Authorization": f"Bearer {config.API_KEY}"}
TEXT = {"text": "rani ta3bana barsha min el imti7anat"}


class FakeRouter:
    def __init__(self, risk="none", reflection="واضح إن الضغط كبير عليك. شن اللي يفيدك توا؟", draft="فاضي نحكوا شوية؟",
                 memory="عندك امتحان قريب."):
        self.risk, self.reflection, self.draft, self.memory = risk, reflection, draft, memory
        self.calls = []

    def json_task(self, task, text, schema):
        self.calls.append((task, text))
        if task == "risk":
            return (RiskModelOut(risk=self.risk) if self.risk else None), "fake"
        if task == "reflect":
            return ReflectModelOut(reflection=self.reflection), "fake"
        if task == "remember":
            return (RememberModelOut(memory=self.memory) if self.memory is not None else None), "fake"
        return SuggestModelOut(situation=["study_pressure"], suggestions=[
            Suggestion(type="trusted_friend", why="يسمعك من غير حكم.", draft=self.draft)]), "fake"

    def chat_stream(self, prompt, model):
        yield from ["أهلاً", " بيك"]

    def try_once(self, task, text, model, prompt=None):
        self.tried = (task, model, prompt)
        return '{"reflection": "واضح إن عندك اكتئاب"}' if prompt == "bad" else '{"reflection": "ربي يعينك. شن يفيدك توا؟"}'

    def reload(self, task):
        self.reloaded = task

    def status(self):
        return {}

    def close(self):
        pass


@pytest.fixture
def client():
    def make(**kw):
        main.app.state.agy = FakeRouter(**kw)
        return TestClient(main.app)
    yield make
    main.app.state.agy = None


def test_health_needs_no_key(client):
    with client() as c:
        assert c.get("/health").json()["status"] == "ok"


@pytest.mark.parametrize("headers", [{}, {"Authorization": "Bearer wrong"}, {"X-API-Key": "wrong"}])
def test_rejects_missing_or_wrong_key(client, headers):
    with client() as c:
        r = c.post("/v1/analyze", json=TEXT, headers=headers)
        assert r.status_code == 401 and r.headers["www-authenticate"] == "Bearer"


def test_accepts_x_api_key_header(client):
    with client() as c:
        assert c.post("/v1/risk", json=TEXT, headers={"X-API-Key": config.API_KEY}).status_code == 200


@pytest.mark.parametrize("body", [{}, {"text": ""}, {"text": "x" * (config.MAX_TEXT_CHARS + 1)}])
def test_validates_input(client, body):
    with client() as c:
        assert c.post("/v1/analyze", json=body, headers=AUTH).status_code == 422


def test_rejects_oversized_body(client):
    with client() as c:
        r = c.post("/v1/analyze", content=b"x" * (config.MAX_BODY_BYTES + 1),
                   headers={**AUTH, "Content-Type": "application/json"})
        assert r.status_code == 413


def test_analyze_happy_path(client):
    with client() as c:
        r = c.post("/v1/analyze", json=TEXT, headers=AUTH).json()
        assert r["urgent"] is False and r["suggestions"][0]["type"] == "trusted_friend" and not r["fallback"]


@pytest.mark.parametrize("risk", ["possible", "high", None])
def test_any_risk_or_failure_is_urgent_with_no_ai_text(client, risk):
    with client(risk=risk) as c:
        r = c.post("/v1/analyze", json=TEXT, headers=AUTH).json()
        assert r["urgent"] is True and r["reflection"] is None and r["suggestions"] == []
        assert r["risk"] == (risk or "unknown")


def test_diagnosis_in_reflection_is_replaced_with_fallback(client):
    with client(reflection="يبدو إن عندك اكتئاب") as c:
        r = c.post("/v1/reflect", json=TEXT, headers=AUTH).json()
        assert r["fallback"] is True and "اكتئاب" not in r["reflection"]


def test_medication_in_draft_drops_the_suggestion(client):
    with client(draft="جرب حبوب للنوم") as c:
        assert c.post("/v1/suggest", json=TEXT, headers=AUTH).status_code == 503


def test_security_headers(client):
    with client() as c:
        h = c.get("/health").headers
        assert h["x-content-type-options"] == "nosniff" and h["cache-control"] == "no-store"


def test_openapi_documents_bearer_auth_and_endpoints(client):
    with client() as c:
        spec = c.get("/openapi.json").json()
        assert spec["openapi"].startswith("3.")
        assert "HTTPBearer" in spec["components"]["securitySchemes"]
        for path in ["/v1/analyze", "/v1/risk", "/v1/reflect", "/v1/suggest", "/v1/chat/completions", "/v1/models"]:
            assert path in spec["paths"]


def test_openai_chat_completion(client):
    with client() as c:
        r = c.post("/v1/chat/completions", headers=AUTH,
                   json={"model": config.QUALITY_MODEL, "messages": [{"role": "user", "content": "salam"}]}).json()
        assert r["object"] == "chat.completion" and r["choices"][0]["message"]["content"] == "أهلاً بيك"


def test_openai_chat_streaming(client):
    with client() as c:
        r = c.post("/v1/chat/completions", headers=AUTH,
                   json={"model": config.QUALITY_MODEL, "stream": True, "messages": [{"role": "user", "content": "hi"}]})
        lines = [line for line in r.text.splitlines() if line.startswith("data: ")]
        assert lines[-1] == "data: [DONE]" and '"content": "أهلاً"' in r.text


def test_openai_unknown_model(client):
    with client() as c:
        r = c.post("/v1/chat/completions", headers=AUTH,
                   json={"model": "gpt-4", "messages": [{"role": "user", "content": "hi"}]})
        assert r.status_code == 400


def test_refuses_to_start_without_strong_key(monkeypatch):
    monkeypatch.setattr(config, "API_KEY", "short")
    main.app.state.agy = FakeRouter()
    with pytest.raises(RuntimeError):
        with TestClient(main.app):
            pass
    main.app.state.agy = None


@pytest.mark.live
@pytest.mark.skipif(os.environ.get("KHUTWA_LIVE") != "1", reason="set KHUTWA_LIVE=1 to call the real agy CLI")
def test_live_analyze_and_chat():
    main.app.state.agy = None
    with TestClient(main.app) as c:
        import time
        time.sleep(6)  # let pools warm up
        for text in ["rani ta3bana barsha min el imti7anat w el 7osh kollah mashakel",
                     "حاس روحي وحيد من وقت ما جيت لـ[مدينة] للقراية",
                     "sa3at n7ess ennou mafish fayda min 7ayati"]:
            r = c.post("/v1/analyze", json={"text": text}, headers=AUTH).json()
            print(f"\n{r['elapsed_ms']} ms  urgent={r['urgent']} risk={r['risk']} "
                  f"suggestions={[s['type'] for s in r['suggestions']]} fallback={r['fallback']}")
            time.sleep(3)
        t = time.perf_counter()
        r = c.post("/v1/chat/completions", headers=AUTH, json={"model": config.FAST_MODEL, "messages": [
            {"role": "user", "content": "قولي جملة وحدة تشجعني قبل الامتحان"}]}).json()
        print(f"chat {time.perf_counter() - t:.1f}s: {r['choices'][0]['message']['content'][:120]}")


def test_client_id_trusts_cloudflare_header_only_from_loopback():
    from types import SimpleNamespace
    def req(peer, headers):
        return SimpleNamespace(client=SimpleNamespace(host=peer), headers=headers)
    assert main.client_id(req("127.0.0.1", {"cf-connecting-ip": "203.0.113.7"})) == "203.0.113.7"
    assert main.client_id(req("198.51.100.2", {"cf-connecting-ip": "203.0.113.7"})) == "198.51.100.2"
    assert main.client_id(req("127.0.0.1", {})) == "127.0.0.1"


DEV = {**AUTH, "X-Dev-Key": "dev-key-" + "y" * 30}


@pytest.fixture
def dev_client(client, monkeypatch, tmp_path):
    monkeypatch.setattr(config, "DEV_KEY", DEV["X-Dev-Key"])
    from khutwa_api import agents
    agents_dir = tmp_path / "agents"
    agents_dir.mkdir()
    for name in ("khutwa-risk", "khutwa-reflect", "khutwa-suggest"):
        (agents_dir / f"{name}.md").write_text(f"---\nname: {name}\nenabledTools: [finish]\n---\nOld prompt\n",
                                                encoding="utf-8")
    monkeypatch.setattr(agents, "AGENTS_DIR", agents_dir)
    monkeypatch.setattr(agents, "HISTORY_DIR", tmp_path / "history")
    return client, agents_dir, tmp_path


def test_json_responses_declare_utf8(client):
    with client() as c:
        assert c.post("/v1/reflect", json=TEXT, headers=AUTH).headers["content-type"] == "application/json; charset=utf-8"


def test_dev_tools_need_dev_key(dev_client):
    client, _, _ = dev_client
    with client() as c:
        assert c.post("/v1/dev/try", json={"task": "reflect", **TEXT}, headers=AUTH).status_code == 403
        assert c.post("/v1/dev/try", json={"task": "reflect", **TEXT}, headers={"X-Dev-Key": DEV["X-Dev-Key"]}).status_code == 401


def test_dev_tools_disabled_without_dev_key(client, monkeypatch):
    monkeypatch.setattr(config, "DEV_KEY", "")
    with client() as c:
        assert c.get("/v1/dev/prompts", headers=DEV).status_code == 404


def test_dev_try_reports_validity_and_guardrail(dev_client):
    client, _, _ = dev_client
    with client() as c:
        ok = c.post("/v1/dev/try", json={"task": "reflect", "prompt": "good prompt", **TEXT}, headers=DEV).json()
        bad = c.post("/v1/dev/try", json={"task": "reflect", "prompt": "bad", **TEXT}, headers=DEV).json()
        assert ok["valid"] and not ok["guardrail"] and ok["model"] == config.QUALITY_MODEL
        assert bad["valid"] and bad["guardrail"]


def test_dev_save_keeps_frontmatter_backs_up_and_reloads(dev_client):
    client, agents_dir, tmp = dev_client
    with client() as c:
        r = c.put("/v1/dev/prompts/reflect", json={"prompt": "New prompt that is long enough to save."}, headers=DEV)
        assert r.status_code == 200 and main.app.state.agy.reloaded == "reflect"
        saved = (agents_dir / "khutwa-reflect.md").read_text(encoding="utf-8")
        assert saved.startswith("---\nname: khutwa-reflect\nenabledTools: [finish]\n---") and "New prompt" in saved
        assert any((tmp / "history").iterdir())
        assert c.get("/v1/dev/prompts", headers=DEV).json()["reflect"]["prompt"].startswith("New prompt")


def test_installers_are_public_and_point_at_this_server(client):
    with client() as c:
        ps1 = c.get("/install.ps1", headers={"host": "khutwa.example", "x-forwarded-proto": "https"})
        sh = c.get("/install.sh", headers={"host": "khutwa.example", "x-forwarded-proto": "https"})
        script = c.get("/tools/khutwa-tune.py")
        assert ps1.status_code == sh.status_code == script.status_code == 200
        assert '$Base = "https://khutwa.example"' in ps1.text and 'BASE="https://khutwa.example"' in sh.text
        assert "class Tuner(App)" in script.text and "{BASE_URL}" not in ps1.text
        assert config.API_KEY not in ps1.text + sh.text + script.text


def test_pool_never_keeps_more_than_its_size_warm(monkeypatch):
    """Regression: acquire() used to start a replacement even after a cold start, so pools grew past
    their size, filled every process slot, and the risk check then timed out (failing to urgent)."""
    import threading
    import time
    from khutwa_api import agy

    started = []

    class FakeWorker:
        def __init__(self, agent, model):
            time.sleep(0.05)  # starting takes time, so a burst of requests finds the pool empty
            started.append(self)

        def close(self):
            pass

    monkeypatch.setattr(agy, "Worker", FakeWorker)
    pool = agy.Pool("khutwa-risk", "m", 2)
    workers = []
    threads = [threading.Thread(target=lambda: workers.append(pool.acquire())) for _ in range(8)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    time.sleep(0.5)  # let background spawns finish
    assert len(workers) == 8
    assert pool.ready.qsize() == 2
    assert len(started) - len(workers) == 2  # exactly `size` spares, however the calls interleave


def test_first_model_gets_the_shorter_timeout(monkeypatch):
    """A stalled first model should hand over to the fallback after PRIMARY_TIMEOUT, not the full timeout."""
    from khutwa_api import agy

    seen = []

    class FakeWorker:
        def __init__(self, model):
            self.model = model

        def ask_json(self, content, schema, timeout):
            seen.append((self.model, timeout))
            return None if self.model == config.QUALITY_MODEL else schema(reflection="ok", fallback=False)

    class FakePool:
        def __init__(self, model):
            self.model = model

        def acquire(self):
            return FakeWorker(self.model)

    router = agy.AgyRouter.__new__(agy.AgyRouter)
    router.pools = {("reflect", m): FakePool(m) for m in (config.QUALITY_MODEL, config.FAST_MODEL)}
    from khutwa_api.schemas import ReflectOut
    result, model = router.json_task("reflect", "x", ReflectOut)
    assert model == config.FAST_MODEL
    assert seen == [(config.QUALITY_MODEL, config.PRIMARY_TIMEOUT_SECONDS), (config.FAST_MODEL, config.TIMEOUT_SECONDS)]


HISTORY = [{"role": "user", "text": "راني تعبان من الخدمة"}, {"role": "assistant", "text": "فاهمك. من قداش؟"},
           {"role": "user", "text": "من شهرين"}, {"role": "assistant", "text": "حاسس بيك. شن يصير؟"}]


def test_listen_first_holds_back_support_options(client):
    with client() as c:
        first = c.post("/v1/analyze", headers=AUTH, json={"text": "راني تعبان من الخدمة", "history": []}).json()
        assert first["support_ready"] is False and first["suggestions"] == [] and first["reflection"]
        assert not first["fallback"]
        assert sorted(task for task, _ in main.app.state.agy.calls) == ["reflect", "risk"]  # no suggest call yet
        third = c.post("/v1/analyze", headers=AUTH, json={"text": "ومديري ديما يعيط", "history": HISTORY}).json()
        assert third["support_ready"] is True and third["suggestions"]


def test_asking_who_to_talk_to_gives_options_straight_away(client):
    with client() as c:
        r = c.post("/v1/analyze", headers=AUTH, json={"text": "مش عارف نحكي مع منو", "history": []}).json()
        assert r["support_ready"] is True and r["suggestions"]


def test_without_history_old_clients_get_options_every_time(client):
    with client() as c:
        r = c.post("/v1/analyze", headers=AUTH, json={"text": "راني تعبان من الخدمة"}).json()
        assert r["support_ready"] is True and r["suggestions"]


def test_reflection_sees_the_conversation_but_risk_checks_only_the_new_message(client):
    with client() as c:
        c.post("/v1/analyze", headers=AUTH, json={"text": "ومديري ديما يعيط", "history": HISTORY})
        calls = dict(main.app.state.agy.calls)
        assert calls["risk"] == "ومديري ديما يعيط"
        assert calls["reflect"].startswith("earlier user: راني تعبان من الخدمة")
        assert calls["reflect"].endswith("new: ومديري ديما يعيط") and calls["suggest"] == calls["reflect"]


def test_history_is_limited(client):
    with client() as c:
        r = c.post("/v1/analyze", headers=AUTH, json={"text": "x", "history": [{"role": "user", "text": "y"}] * 13})
        assert r.status_code == 422


def test_dev_try_can_run_a_draft_mid_conversation(dev_client):
    client, _, _ = dev_client
    body = {"task": "reflect", "text": "سكتت", "history": [{"role": "user", "text": "حد يتمسخر عليا"},
                                                          {"role": "assistant", "text": "رديت عليه ولا سكتت؟"}]}
    with client() as c:
        seen = {}
        main.app.state.agy.try_once = lambda task, text, model, prompt=None: seen.setdefault(task, text) and '{"reflection": "ok"}'
        assert c.post("/v1/dev/try", headers=DEV, json=body).status_code == 200
    assert seen["reflect"].startswith("earlier user: حد يتمسخر عليا") and seen["reflect"].endswith("new: سكتت")


def test_support_options_come_as_a_valid_a2ui_surface(client):
    with client() as c:
        r = c.post("/v1/analyze", headers=AUTH, json={"text": "مش عارف نحكي مع مني", "history": []}).json()
    msgs = r["a2ui"]
    assert [next(iter(m)) for m in msgs] == ["surfaceUpdate", "dataModelUpdate", "beginRendering"]
    sid = msgs[0]["surfaceUpdate"]["surfaceId"]
    assert all(next(iter(m.values()))["surfaceId"] == sid for m in msgs)
    comps = {x["id"]: x["component"] for x in msgs[0]["surfaceUpdate"]["components"]}
    allowed = {"Text", "Button", "Card", "Column", "Row", "TextField"}
    for cid, comp in comps.items():
        (kind, props), = comp.items()
        assert kind in allowed
        refs = props.get("children", {}).get("explicitList", []) + [props[k] for k in ("child",) if k in props]
        assert all(ref in comps for ref in refs), cid  # every reference resolves
        if kind == "Text":
            assert "text" in props and props.get("usageHint", "body") in {"h1", "h2", "h3", "h4", "h5", "caption", "body"}
        if kind == "Button":
            assert props["action"]["name"] in {"khutwa.share", "khutwa.copy"}  # nothing is ever sent for the user
        if kind == "TextField":
            assert "label" in props and props["text"]["path"].startswith("/drafts/")
    assert msgs[2]["beginRendering"]["root"] in comps
    drafts = msgs[1]["dataModelUpdate"]
    assert drafts["path"] == "/drafts" and drafts["contents"][0]["valueString"] == "فاضي نحكوا شوية؟"


def test_no_a2ui_while_still_listening(client):
    with client() as c:
        r = c.post("/v1/analyze", headers=AUTH, json={"text": "راني تعبان من الخدمة", "history": []}).json()
    assert r["support_ready"] is False and r["a2ui"] == []


def test_deferred_support_returns_the_reply_without_waiting_for_options(client):
    with client() as c:
        r = c.post("/v1/analyze", headers=AUTH, json={"text": "مش عارف نحكي مع مني", "history": [], "defer_support": True}).json()
        assert r["support_ready"] is True and r["suggestions"] == [] and r["a2ui"] == [] and r["reflection"]
        assert "suggest" not in [task for task, _ in main.app.state.agy.calls]
        s = c.post("/v1/support", headers=AUTH, json={"text": "مش عارف نحكي مع مني", "history": HISTORY}).json()
        assert s["suggestions"] and not s["fallback"]
        assert [next(iter(m)) for m in s["a2ui"]] == ["surfaceUpdate", "dataModelUpdate", "beginRendering"]


def test_support_needs_the_api_key(client):
    with client() as c:
        assert c.post("/v1/support", json={"text": "x"}).status_code == 401


def test_memory_goes_before_the_conversation_but_not_to_the_risk_check(client):
    with client() as c:
        c.post("/v1/analyze", headers=AUTH, json={"text": "رجعت", "history": [], "memory": "[اسم1] صاحبك تخاصمتوا."})
        calls = dict(c.app.state.agy.calls)
        assert calls["risk"] == "رجعت"
        assert calls["reflect"] == "memory: [اسم1] صاحبك تخاصمتوا.\nnew: رجعت"


def test_conversation_text_without_memory_is_unchanged():
    assert main.conversation_text("x", [], None) == "x"
    assert main.conversation_text("x", [], "  ") == "x"


def test_remember_returns_updated_notes(client):
    with client() as c:
        r = c.post("/v1/remember", headers=AUTH, json={"memory": "قديم", "history": [{"role": "user", "text": "عندي امتحان"}]}).json()
        assert r == {"memory": "عندك امتحان قريب.", "fallback": False}
        assert c.app.state.agy.calls[-1] == ("remember", "memory: قديم\nuser: عندي امتحان")


def test_remember_keeps_old_notes_on_failure_or_guardrail(client):
    body = {"history": [{"role": "user", "text": "عندي امتحان"}]}
    with client(memory=None) as c:
        assert c.post("/v1/remember", headers=AUTH, json=body).json() == {"memory": None, "fallback": True}
    with client(memory="عندك اكتئاب") as c:
        assert c.post("/v1/remember", headers=AUTH, json=body).json() == {"memory": None, "fallback": True}


def test_remember_needs_key_and_history(client):
    with client() as c:
        assert c.post("/v1/remember", json={"history": [{"role": "user", "text": "x"}]}).status_code in (401, 403)
        assert c.post("/v1/remember", headers=AUTH, json={"history": []}).status_code == 422


def test_feminine_addressing_goes_first_and_not_to_risk(client):
    with client() as c:
        c.post("/v1/analyze", headers=AUTH, json={"text": "تعبانة", "history": [], "addressing": "feminine"})
        calls = dict(c.app.state.agy.calls)
        assert calls["risk"] == "تعبانة"
        assert calls["reflect"] == "addressing: feminine\nnew: تعبانة"


def test_masculine_addressing_changes_nothing():
    assert main.conversation_text("x", [], None, "masculine") == "x"
