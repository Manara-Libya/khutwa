/*
 * Khutwa pitch: one file, two windows.
 *   index.html                 the deck (drag it to the projector / built-in screen)
 *   index.html?view=script     the script, line by line, in sync (drag it to the second monitor)
 *
 * Each slide is a <section class="slide">. Elements with data-step="n" appear on the n-th click.
 * Its <aside class="notes"> holds the script: <p data-step="n"> lines say what to read while step n is showing.
 * A slide has as many steps as its highest data-step, visual or script. The deck owns the state; the script window
 * sends next/prev/goto and follows. Sync works from a local file: window.opener / postMessage first, then
 * BroadcastChannel and localStorage as fallbacks.
 */
(function () {
  "use strict";
  const params = new URLSearchParams(location.search);
  const isScript = params.get("view") === "script";
  const slides = Array.from(document.querySelectorAll("#stage .slide"));
  const stepsOf = slides.map((s) => Math.max(0, ...Array.from(s.querySelectorAll("[data-step]")).map((e) => +e.dataset.step || 0)));
  let state = { i: 0, s: 0, t0: null };

  // ------------------------------------------------------------------ messaging
  const CH = "khutwa-deck";
  let bc = null;
  try { bc = new BroadcastChannel(CH); } catch (e) { /* not available */ }
  let peer = null;   // the other window, when we opened it or it opened us
  if (window.opener && !window.opener.closed) peer = window.opener;
  function send(msg) {
    msg.from = isScript ? "script" : "deck";
    msg.id = `${Date.now()}-${Math.random().toString(36).slice(2)}`;   // one id across all routes, so it is handled once
    try { if (peer && !peer.closed) peer.postMessage(msg, "*"); } catch (e) { /* cross-origin file:// */ }
    try { if (bc) bc.postMessage(msg); } catch (e) { /* closed */ }
    try { localStorage.setItem(CH, JSON.stringify(msg)); } catch (e) { /* blocked */ }
  }
  const seen = new Set();
  function receive(msg) {
    if (!msg || msg.from === (isScript ? "script" : "deck")) return;
    if (msg.id) {   // the same message arrives by up to three routes
      if (seen.has(msg.id)) return;
      seen.add(msg.id); setTimeout(() => seen.delete(msg.id), 5000);
    }
    if (isScript) scriptReceive(msg); else deckReceive(msg);
  }
  window.addEventListener("message", (e) => receive(e.data));
  if (bc) bc.onmessage = (e) => receive(e.data);
  window.addEventListener("storage", (e) => { if (e.key === CH && e.newValue) { try { receive(JSON.parse(e.newValue)); } catch (_) {} } });

  // ------------------------------------------------------------------ navigation (shared)
  function clamp(i, s) {
    i = Math.max(0, Math.min(slides.length - 1, i));
    s = Math.max(0, Math.min(stepsOf[i], s));
    return { i, s };
  }
  function nextOf({ i, s }) { return s < stepsOf[i] ? { i, s: s + 1 } : (i < slides.length - 1 ? { i: i + 1, s: 0 } : { i, s }); }
  function prevOf({ i, s }) { return s > 0 ? { i, s: s - 1 } : (i > 0 ? { i: i - 1, s: stepsOf[i - 1] } : { i, s }); }

  function keyAction(e) {
    if (e.target && (e.target.tagName === "INPUT" || e.target.tagName === "TEXTAREA")) return null;
    const k = e.key;
    if (["ArrowRight", "ArrowDown", "PageDown", " ", "Enter", "n", "N"].includes(k)) return "next";
    if (["ArrowLeft", "ArrowUp", "PageUp", "Backspace", "p", "P"].includes(k)) return "prev";
    if (k === "Home") return "home";
    if (k === "End") return "end";
    return null;
  }


  // ================================================================== DECK
  function initDeck() {
    const stage = document.getElementById("stage");
    const fit = () => {
      const k = Math.min(innerWidth / 1920, innerHeight / 1080);
      stage.style.transform = `translate(${-960 * k}px, ${-540 * k}px) scale(${k})`;
    };
    addEventListener("resize", fit); fit();
    prepareDoodles();
    buildDots();
    document.querySelectorAll(".video-wrap video").forEach((v) => {
      v.addEventListener("loadeddata", () => v.closest(".video-wrap").classList.add("has-video"));
    });

    const saved = (() => { try { return JSON.parse(sessionStorage.getItem("khutwa-pos") || "null"); } catch (e) { return null; } })();
    if (saved) state = Object.assign(state, clamp(saved.i, saved.s));
    // ?slide=5&step=2 opens a given point (rehearsal); step=max shows the slide finished
    if (params.has("slide")) {
      const i = +params.get("slide") - 1;
      state = Object.assign(state, clamp(i, params.get("step") === "max" ? 99 : +(params.get("step") || 0)));
    }
    render(true);

    const start = document.getElementById("start");
    if (params.has("slide") || params.has("nostart")) start.classList.add("hidden");
    document.getElementById("open-script").onclick = () => { openScript(); };
    document.getElementById("go-full").onclick = () => { fullscreen(); start.classList.add("hidden"); };
    document.getElementById("just-start").onclick = () => start.classList.add("hidden");

    addEventListener("keydown", (e) => {
      if (!start.classList.contains("hidden")) { if (e.key === "Escape" || e.key === "Enter") start.classList.add("hidden"); else return; }
      const a = keyAction(e);
      if (a) { e.preventDefault(); act(a); return; }
      if (e.key === "f" || e.key === "F") fullscreen();
      if (e.key === "s" || e.key === "S") openScript();
      if (e.key === "b" || e.key === "B" || e.key === ".") document.getElementById("blackout").classList.toggle("on");
      if (e.key === "r" || e.key === "R") { state.t0 = null; broadcast(); }
    });
    stage.addEventListener("click", (e) => { if (!e.target.closest("video, a, button")) act("next"); });
    stage.addEventListener("contextmenu", (e) => { e.preventDefault(); act("prev"); });
    setInterval(broadcast, 2000);   // keeps a late or reloaded script window in step
  }

  function deckReceive(msg) {
    if (msg.type === "hello") { peer = peer || null; broadcast(); }
    if (msg.type === "cmd") {
      if (msg.action === "goto") { Object.assign(state, clamp(msg.i, msg.s)); render(); }
      else act(msg.action);
    }
  }

  function act(a) {
    let n = state;
    if (a === "next") n = nextOf(state);
    if (a === "prev") n = prevOf(state);
    if (a === "home") n = { i: 0, s: 0 };
    if (a === "end") n = { i: slides.length - 1, s: stepsOf[slides.length - 1] };
    if (a === "next" && state.t0 === null) state.t0 = Date.now();   // the timer starts with the first click
    Object.assign(state, n);
    render();
  }

  let shown = -1;
  function render(first) {
    const { i, s } = state;
    slides.forEach((sl, k) => {
      sl.classList.toggle("active", k === i);
      sl.classList.toggle("past", k < i);
    });
    const sl = slides[i];
    sl.querySelectorAll("[data-step]").forEach((el) => {
      const on = +el.dataset.step <= s;
      if (on && !el.classList.contains("on")) enter(el);
      if (!on && el.classList.contains("on")) leave(el);
      el.classList.toggle("on", on);
    });
    syncChapters(sl, s);
    if (shown !== i) {
      slides.forEach((other, k) => {
        if (k === i) return;
        other.querySelectorAll("video").forEach((v) => v.pause());
        // reset so the pen draws again next time the slide is shown
        other.querySelectorAll(".drawn").forEach((d) => d.classList.remove("drawn"));
        other.querySelectorAll("[data-step].on").forEach((d) => { d.classList.remove("on"); if (d.dataset.addClass) leave(d); });
      });
      setTimeout(() => drawIn(sl, null), 250);   // doodles that belong to the slide itself
      shown = i;
    }
    document.getElementById("progress").style.width = `${(100 * (i + (stepsOf[i] ? s / stepsOf[i] : 1) * 0.999)) / slides.length}%`;
    try { sessionStorage.setItem("khutwa-pos", JSON.stringify({ i, s })); } catch (e) { /* private mode */ }
    broadcast();
  }

  // a doodle or illustration draws when its own step appears (not a parent's), or with its slide when it has no step
  function ownStep(node) { return node.closest("[data-step]"); }
  function drawIn(scope, root) {
    scope.querySelectorAll("svg.doodle.draw, svg.ill.trace").forEach((svg) => { if (ownStep(svg) === root) svg.classList.add("drawn"); });
    if (root && root.matches("svg.doodle.draw, svg.ill.trace")) root.classList.add("drawn");
  }
  function drawOut(scope, root) {
    scope.querySelectorAll("svg.doodle.draw, svg.ill.trace").forEach((svg) => { if (ownStep(svg) === root) svg.classList.remove("drawn"); });
    if (root && root.matches("svg.doodle.draw, svg.ill.trace")) root.classList.remove("drawn");
  }

  function enter(el) {
    drawIn(el, el);
    // effects that run when a step appears
    el.querySelectorAll("[data-count]").forEach(countUp);
    if (el.matches("[data-count]")) countUp(el);
    if (el.dataset.anim === "type") typeOut(el);
    if (el.dataset.anim === "type-erase") typeOut(el, true);
    if (el.dataset.addClass) { const t = document.querySelector(el.dataset.target); if (t) t.classList.add(el.dataset.addClass); }
    const v = plainVideo(el);
    if (v) { try { v.currentTime = 0; v.play(); } catch (e) {} }
  }
  function leave(el) {
    drawOut(el, el);
    if (el.dataset.addClass) { const t = document.querySelector(el.dataset.target); if (t) t.classList.remove(el.dataset.addClass); }
    if (el.dataset.anim === "type-erase" || el.dataset.anim === "type") { const t = el.querySelector(".typed"); if (t) { t.dataset.run = ""; t.textContent = ""; } }
    const v = plainVideo(el);
    if (v) { try { v.pause(); } catch (e) {} }
  }
  // a video without chapters plays from the start when its step appears
  function plainVideo(el) {
    const v = el.matches("video") ? el : el.querySelector("video");
    return v && !v.dataset.chapters ? v : null;
  }

  // A video with data-chapters="t1,t2,…" plays one chapter per click: the step marked data-chapter="n" plays
  // from t(n-1) to t(n) and holds on that frame while the presenter talks. Going back, or jumping, shows the
  // last frame of the chapter reached, without playing.
  function syncChapters(sl, s) {
    sl.querySelectorAll("video[data-chapters]").forEach((v) => {
      const ends = v.dataset.chapters.split(",").map(Number);
      const k = Math.max(0, ...Array.from(sl.querySelectorAll("[data-chapter]"))
        .filter((e) => +e.dataset.step <= s).map((e) => +e.dataset.chapter));
      const prev = v._chapter ?? -1;
      v._chapter = k;
      if (k === prev) return;
      const at = (n) => (n <= 0 ? 0 : ends[n - 1] - 0.08);
      cancelAnimationFrame(v._raf);
      try {
        if (k === prev + 1 && k > 0) {
          v.currentTime = at(k - 1);
          v.play();
          const stop = at(k);
          const watch = () => {
            if (v.currentTime >= stop) { v.pause(); v.currentTime = stop; }
            else v._raf = requestAnimationFrame(watch);
          };
          v._raf = requestAnimationFrame(watch);
        } else { v.pause(); v.currentTime = at(k); }
      } catch (e) { /* not loaded yet */ }
    });
  }

  function countUp(el) {
    const to = +el.dataset.count, from = +(el.dataset.from || 0), dur = +(el.dataset.dur || 1100), t0 = performance.now();
    const tick = (t) => {
      const p = Math.min(1, (t - t0) / dur), e = 1 - Math.pow(1 - p, 3);
      el.textContent = Math.round(from + (to - from) * e);
      if (p < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  }

  // types the text out; with erase, pauses, then deletes it again like a message that was never sent
  function typeOut(el, erase) {
    const target = el.querySelector(".typed") || el;
    const text = target.dataset.text || target.textContent;
    const run = String(Math.random());
    target.dataset.text = text;
    target.dataset.run = run;   // a newer run (or leaving the step) stops this one
    target.textContent = "";
    let k = 0;
    const caret = el.querySelector(".caret");
    if (caret) caret.style.opacity = "";
    const live = () => target.dataset.run === run;
    const del = () => {
      if (!live()) return;
      target.textContent = text.slice(0, --k);
      if (k > 0) setTimeout(del, 28 + Math.random() * 20);
    };
    const step = () => {
      if (!live()) return;
      target.textContent = text.slice(0, ++k);
      if (k < text.length) setTimeout(step, 70 + Math.random() * 70);
      else if (erase) setTimeout(del, 1500);
      else if (caret && el.dataset.keepCaret !== "1") caret.style.opacity = 0;
    };
    setTimeout(step, 250);
  }

  function prepareDoodles() {
    document.querySelectorAll("svg.doodle.draw, svg.ill.trace").forEach((svg) => {
      svg.querySelectorAll("path, line, polyline, circle, ellipse").forEach((p, n) => {
        p.setAttribute("pathLength", "1");
        p.style.transitionDelay = `${(+svg.dataset.delay || 0) + Math.min(n * 0.08, 0.9)}s`;
      });
    });
  }

  function buildDots() {
    document.querySelectorAll(".dots[data-total]").forEach((box) => {
      const total = +box.dataset.total, a = +box.dataset.a, b = +box.dataset.b;
      // spread the highlighted dots over the grid, the same way every time
      const idx = Array.from({ length: total }, (_, k) => k);
      let seed = 7; const rnd = () => (seed = (seed * 16807) % 2147483647) / 2147483647;
      for (let k = total - 1; k > 0; k--) { const j = Math.floor(rnd() * (k + 1)); [idx[k], idx[j]] = [idx[j], idx[k]]; }
      const aSet = new Set(idx.slice(0, a)), bSet = new Set(idx.slice(0, b));
      for (let k = 0; k < total; k++) {
        const d = document.createElement("i");
        if (aSet.has(k)) d.className = bSet.has(k) ? "a b" : "a";
        d.style.transitionDelay = `${(k % 31) * 0.012}s`;
        box.appendChild(d);
      }
    });
  }

  function openScript() {
    const w = window.open(location.pathname + "?view=script", "khutwa-script", "popup,width=1400,height=900");
    if (w) { peer = w; setTimeout(broadcast, 600); setTimeout(broadcast, 1500); }
  }
  function fullscreen() {
    const d = document.documentElement;
    if (!document.fullscreenElement) (d.requestFullscreen || d.webkitRequestFullscreen || function () {}).call(d);
    else document.exitFullscreen();
  }
  function broadcast() { send({ type: "state", i: state.i, s: state.s, t0: state.t0 }); }

  // ================================================================== SCRIPT
  function initScript() {
    document.body.classList.add("script");
    document.title = "خطوة · النص";
    const box = document.getElementById("lines");
    // one flat list of lines, each tied to (slide, step)
    let cum = 0;
    slides.forEach((sl, i) => {
      const sep = document.createElement("div");
      sep.className = "slide-sep";
      const target = +(sl.dataset.time || 0);
      sep.textContent = `${i + 1} · ${sl.dataset.title || ""}${target ? `  ·  ${fmt(cum)}` : ""}`;
      sep.dataset.i = i;
      sl.dataset.cum = cum; cum += target;
      box.appendChild(sep);
      const notes = sl.querySelectorAll("aside.notes p");
      notes.forEach((p) => {
        const line = document.createElement("p");
        line.className = "line";
        line.dataset.i = i; line.dataset.s = +(p.dataset.step || 0);
        line.innerHTML = p.innerHTML.replace(/\[([^\]]+)\]/g, '<span class="cue">$1</span>');
        line.onclick = () => send({ type: "cmd", action: "goto", i, s: +line.dataset.s });
        box.appendChild(line);
      });
    });
    document.getElementById("total").textContent = fmt(cum);

    addEventListener("keydown", (e) => {
      const a = keyAction(e);
      if (a) { e.preventDefault(); send({ type: "cmd", action: a }); }
      if (e.key === "+" || e.key === "=") zoom(1.08);
      if (e.key === "-") zoom(1 / 1.08);
    });
    document.getElementById("btn-next").onclick = () => send({ type: "cmd", action: "next" });
    document.getElementById("btn-prev").onclick = () => send({ type: "cmd", action: "prev" });
    send({ type: "hello" });
    setInterval(tick, 500);
    setInterval(() => { if (Date.now() - lastSeen > 5000) send({ type: "hello" }); }, 2500);
  }

  let scale = 1;
  function zoom(f) { scale = Math.max(.6, Math.min(1.8, scale * f)); document.getElementById("lines").style.fontSize = ""; document.querySelectorAll("#lines .line").forEach((l) => (l.style.zoom = scale)); }

  let lastSeen = 0;
  function scriptReceive(msg) {
    if (msg.type !== "state") return;
    lastSeen = Date.now();
    const changed = msg.i !== state.i || msg.s !== state.s || !document.querySelector("#lines .line.now");
    state = { i: msg.i, s: msg.s, t0: msg.t0 };
    if (changed) paint();
  }

  function paint() {
    const { i, s } = state;
    const lines = Array.from(document.querySelectorAll("#lines .line"));
    let now = null;
    lines.forEach((l) => {
      const li = +l.dataset.i, ls = +l.dataset.s;
      const before = li < i || (li === i && ls < s);
      const current = li === i && ls === s;
      l.classList.toggle("past", before);
      l.classList.toggle("now", current);
      l.classList.toggle("soon", li === i && ls > s);
      if (current && !now) now = l;
    });
    // if this step has no line, keep the last line of the step before it in view
    if (!now) now = lines.filter((l) => l.classList.contains("past")).pop();
    if (now) now.scrollIntoView({ block: "center", behavior: "smooth" });
    const sl = slides[i];
    document.getElementById("count").textContent = `${i + 1} / ${slides.length}`;
    document.getElementById("title").textContent = sl.dataset.title || "";
    const nx = slides[i + 1];
    const nxLine = nx ? nx.querySelector("aside.notes p") : null;
    document.getElementById("next").innerHTML = nx ? `التالي: <b>${nx.dataset.title || ""}</b>${nxLine ? " · " + nxLine.textContent.replace(/\[[^\]]+\]/g, "").slice(0, 90) : ""}` : "النهاية";
    document.getElementById("stepinfo").textContent = stepsOf[i] ? `خطوة ${s} من ${stepsOf[i]}` : "";
  }

  function tick() {
    const link = document.getElementById("link");
    const ok = Date.now() - lastSeen < 4500;
    link.textContent = ok ? "● متصل بالعرض" : "○ يبحث عن نافذة العرض…";
    link.classList.toggle("ok", ok);
    document.getElementById("clockNow").textContent = new Date().toLocaleTimeString("en-GB", { hour: "2-digit", minute: "2-digit" });
    const el = state.t0 ? (Date.now() - state.t0) / 1000 : 0;
    document.getElementById("timer").textContent = fmt(el);
    const sl = slides[state.i];
    const pace = document.getElementById("pace");
    if (state.t0 && sl) {
      const due = +(sl.dataset.cum || 0) + (+(sl.dataset.time || 0)) * (stepsOf[state.i] ? state.s / stepsOf[state.i] : 0);
      const diff = Math.round(el - due);
      pace.textContent = diff > 5 ? `متأخر ${fmt(diff)}` : diff < -5 ? `متقدم ${fmt(-diff)}` : "في الوقت";
      pace.classList.toggle("late", diff > 5);
    } else pace.textContent = "اضغط للبدء";
  }

  function fmt(sec) { sec = Math.max(0, Math.round(sec)); return `${Math.floor(sec / 60)}:${String(sec % 60).padStart(2, "0")}`; }

  if (isScript) initScript(); else initDeck();
})();
