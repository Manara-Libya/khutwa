package ly.manara.khutwa.ui.screens

import androidx.compose.ui.graphics.drawOutline
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.widthIn
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.withStyle
import androidx.compose.foundation.Canvas
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.animateContentSize
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.expandVertically
import androidx.compose.animation.shrinkVertically
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.slideOutVertically
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.interaction.collectIsFocusedAsState
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.input.OffsetMapping
import androidx.compose.ui.text.input.TransformedText
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextDecoration
import ly.manara.khutwa.privacy.LibyanRedactor
import ly.manara.khutwa.ui.components.WelcomeIllustration
import ly.manara.khutwa.ui.components.DoodleLoop
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import androidx.compose.foundation.Image
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.derivedStateOf
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.window.Dialog
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import ly.manara.khutwa.ui.components.Appear
import ly.manara.khutwa.ui.components.Doodle
import ly.manara.khutwa.ui.components.Doodles
import ly.manara.khutwa.ui.components.KhMotion
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.gestures.animateScrollBy
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.material3.minimumInteractiveComponentSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.foundation.layout.absoluteOffset
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import ly.manara.khutwa.Line
import ly.manara.khutwa.R
import ly.manara.khutwa.UiState
import ly.manara.khutwa.data.Option
import ly.manara.khutwa.data.Texts
import ly.manara.khutwa.ui.components.BackButton
import ly.manara.khutwa.ui.components.A2uiView
import ly.manara.khutwa.ui.components.Bubble
import ly.manara.khutwa.ui.components.ButtonKind
import ly.manara.khutwa.ui.components.KhButton
import ly.manara.khutwa.ui.components.KhIcon
import ly.manara.khutwa.ui.components.Note
import ly.manara.khutwa.ui.components.copyText
import ly.manara.khutwa.ui.components.shareText
import ly.manara.khutwa.ui.components.ScreenTitle
import ly.manara.khutwa.ui.components.PenWidth
import ly.manara.khutwa.ui.components.SupportCard
import ly.manara.khutwa.ui.components.TopBar
import ly.manara.khutwa.ui.components.Typing
import ly.manara.khutwa.ui.theme.Kh
import ly.manara.khutwa.ui.theme.KhShapes
import ly.manara.khutwa.ui.theme.KhType

private val Gutter = 20.dp

// ---------------------------------------------------------------- consent

@Composable
fun ConsentScreen(onAccept: () -> Unit, onDecline: () -> Unit, onUrgent: () -> Unit) {
    val c = Kh.colors
    var declined by rememberSaveable { mutableStateOf(false) }
    if (declined) {
        // Not now: no pressure. The urgent help stays one tap away, and nothing was sent or stored.
        Column(Modifier.fillMaxSize()) {
            TopBar(onUrgent)
            Column(Modifier.weight(1f).padding(horizontal = Gutter), verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally) {
                Appear("declined-ill") { Image(painterResource(R.drawable.ill_on_your_phone), contentDescription = null, modifier = Modifier.size(170.dp)) }
                Spacer(Modifier.height(16.dp))
                Appear("declined-text", 80) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            ScreenTitle("على راحتك")
                            Spacer(Modifier.width(8.dp))
                            Doodle(Doodles.HEART_OUTLINE, c.clay, Modifier.size(34.dp), key = "declined-heart", delayMillis = 450, durationMillis = 800)
                        }
                        Spacer(Modifier.height(8.dp))
                        Text("ما بعتنا شي وما خزنا شي. ترجع وقت ما تبي، وإذا احتجت مساعدة توا اضغط «نحتاج مساعدة توا» فوق.",
                            style = KhType.body, color = c.inkMuted, textAlign = androidx.compose.ui.text.style.TextAlign.Center)
                    }
                }
            }
            Column(Modifier.padding(horizontal = Gutter, vertical = 12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                KhButton("نرجع للموافقة", { declined = false }, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet)
                KhButton("نسكر التطبيق", onDecline, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet)
            }
        }
        return
    }
    Column(Modifier.fillMaxSize()) {
        TopBar(onUrgent)
        Column(Modifier.weight(1f).verticalScroll(rememberScrollState()).padding(horizontal = Gutter)) {
            // A staged entrance: illustration, title, then each point a beat after the previous one.
            Appear("consent-ill") {
                Box(Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                    Image(painterResource(R.drawable.ill_scene_private), contentDescription = null, modifier = Modifier.size(180.dp))
                    Doodle(Doodles.SPARKLES, c.ink, Modifier.size(54.dp).align(Alignment.TopEnd).padding(end = 24.dp),
                        key = "consent-sparkles", delayMillis = 450, durationMillis = 900)
                }
            }
            Appear("consent-title", 80) {
                Column {
                    ScreenTitle(Texts.CONSENT_TITLE)
                    Doodle(Doodles.UNDERLINE, c.green, Modifier.width(190.dp).height(14.dp),
                        key = "consent-underline", delayMillis = 520, durationMillis = 700)
                    Spacer(Modifier.height(8.dp))
                    Text(Texts.CONSENT_INTRO, style = KhType.body, color = c.inkMuted)
                }
            }
            Spacer(Modifier.height(20.dp))
            listOf(
                Triple(R.drawable.ic_kh_sparkle, Texts.CONSENT_AI, false),
                Triple(R.drawable.ic_kh_shield_check, Texts.CONSENT_REDACTION, false),
                Triple(R.drawable.ic_kh_info, Texts.CONSENT_GOOGLE, false),
                Triple(R.drawable.ic_kh_lock, Texts.CONSENT_SERVER, false),
                Triple(R.drawable.ic_kh_urgent, Texts.CONSENT_EMERGENCY, true),
            ).forEachIndexed { i, (icon, text, urgent) ->
                Appear("consent-point-$i", 160L + 70L * i) { ConsentPoint(icon, text, urgent) }
            }
            Spacer(Modifier.height(12.dp))
        }
        Column(Modifier.padding(horizontal = Gutter, vertical = 12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            KhButton(Texts.CONSENT_ACCEPT, onAccept, Modifier.fillMaxWidth())
            KhButton(Texts.CONSENT_DECLINE, { declined = true }, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet)
        }
    }
}

@Composable
private fun ConsentPoint(icon: Int, text: String, urgent: Boolean = false) {
    val c = Kh.colors
    Row(Modifier.fillMaxWidth().padding(vertical = 8.dp), verticalAlignment = Alignment.Top) {
        Box(
            Modifier.size(36.dp).background(if (urgent) c.claySoft else c.greenSoft, KhShapes.chip),
            contentAlignment = Alignment.Center,
        ) { KhIcon(icon, if (urgent) c.urgent else c.greenDeep, size = 20.dp) }
        Spacer(Modifier.width(12.dp))
        Text(text, style = KhType.body, color = c.ink, modifier = Modifier.weight(1f).padding(top = 4.dp))
    }
}

// ---------------------------------------------------------------- chat

@Composable
fun ChatScreen(
    state: UiState,
    onSend: (String) -> Unit,
    onRetry: () -> Unit,
    onWhoToTalk: () -> Unit,
    onNewChat: () -> Unit,
    onUrgent: () -> Unit,
    onRevealed: (Long) -> Unit = {},
    onQuickExit: () -> Unit = {},
) {
    val c = Kh.colors
    val list = rememberLazyListState()
    val scope = rememberCoroutineScope()
    // Item 0 is the welcome illustration, so line i sits at list index i + 1.
    var seen by remember { mutableIntStateOf(state.lines.size) }
    LaunchedEffect(state.lines.size, state.waiting, state.failed) {
        val firstNew = seen
        seen = state.lines.size
        val newLine = state.lines.getOrNull(firstNew)
        if (newLine != null && !newLine.mine) {
            // Khutwa answered: bring the start of the answer into view, with the options (if any) below it.
            list.animateScrollToItem(firstNew + 1)
        } else {
            list.animateScrollToItem((list.layoutInfo.totalItemsCount - 1).coerceAtLeast(0))
        }
    }
    val density = LocalDensity.current
    var composerHeight by remember { mutableIntStateOf(0) }
    Column(Modifier.fillMaxSize().imePadding()) {
        TopBar(onUrgent, onQuickExit = onQuickExit)
        // The composer floats over the conversation; the list scrolls underneath it, padded so nothing hides.
        Box(Modifier.weight(1f).fillMaxWidth()) {
        LazyColumn(
            Modifier.fillMaxSize(),
            state = list,
            contentPadding = androidx.compose.foundation.layout.PaddingValues(
                start = Gutter, end = Gutter, top = 8.dp, bottom = with(density) { composerHeight.toDp() } + 8.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            item(key = "welcome") {
                Box(Modifier.fillMaxWidth().padding(bottom = 4.dp), contentAlignment = Alignment.Center) {
                    WelcomeIllustration(Modifier.size(150.dp))
                }
            }
            itemsIndexed(state.lines, key = { _, l -> l.id }) { index, line: Line ->
                Box(Modifier.animateItem(fadeInSpec = null, fadeOutSpec = null)) {
                    Appear(line.id) {
                        val surface = line.surface
                        when {
                            surface != null -> A2uiView(surface)
                            line.loadingSurface -> OptionsPlaceholder()
                            else -> Column {
                                Bubble(line.text, line.mine, reveal = line.reveal,
                                    onRevealed = { onRevealed(line.id); scope.launch { keepInView(list, index + 1) } },
                                    onGrow = { scope.launch { keepInView(list, index + 1) } },
                                    showWho = state.lines.getOrNull(index - 1)?.let { it.mine } ?: true)
                                if (line.mine && (line.sent != null || line.stayedOnPhone))
                                    SentReceipt(line.sent, line.id, onOpen = { scope.launch { keepInView(list, index + 1) } })
                            }
                        }
                    }
                }
            }
            if (state.waiting) item(key = "typing") { Box(Modifier.animateItem(fadeOutSpec = null)) { Appear("typing-${state.lines.size}") { Typing() } } }
            if (state.failed) item {
                Column(
                    Modifier.fillMaxWidth().background(c.sunSoft, KhShapes.card).border(PenWidth, c.ink, KhShapes.card).padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(10.dp),
                ) {
                    Row(verticalAlignment = Alignment.Top) {
                        Doodle(Doodles.EXCLAIM, c.ink, Modifier.size(width = 16.dp, height = 32.dp), key = "error-${state.lines.size}",
                            durationMillis = 500, mirrorInRtl = false)
                        Spacer(Modifier.width(10.dp))
                        Text(Texts.ERROR_NETWORK, style = KhType.body, color = c.ink, modifier = Modifier.weight(1f))
                    }
                    Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        KhButton(Texts.RETRY, onRetry, Modifier.weight(1f), kind = ButtonKind.Quiet, icon = R.drawable.ic_kh_refresh)
                        KhButton("نحتاج مساعدة", onUrgent, Modifier.weight(1f), kind = ButtonKind.Urgent)
                    }
                }
            }
        }
        // Jump to the latest message when the user has scrolled up.
        val atEnd by remember { derivedStateOf { !list.canScrollForward } }
        JumpToLatest(
            visible = !atEnd && state.lines.size > 2,
            onClick = { scope.launch { list.animateScrollToItem((list.layoutInfo.totalItemsCount - 1).coerceAtLeast(0)) } },
            modifier = Modifier.align(Alignment.BottomEnd)
                .padding(end = 18.dp, bottom = with(density) { composerHeight.toDp() } + 10.dp),
        )
        var confirmNew by remember { mutableStateOf(false) }
        Composer(state, onSend, onWhoToTalk, { confirmNew = true }, showChips = atEnd || state.lines.size <= 2,
            modifier = Modifier.align(Alignment.BottomCenter).onSizeChanged { composerHeight = it.height })
        if (confirmNew) ConfirmNewChat(onConfirm = { confirmNew = false; onNewChat() }, onDismiss = { confirmNew = false })
        }
    }
}

@Composable
private fun Composer(
    state: UiState,
    onSend: (String) -> Unit,
    onWhoToTalk: () -> Unit,
    onNewChat: () -> Unit,
    showChips: Boolean,
    modifier: Modifier = Modifier,
) {
    val c = Kh.colors
    val haptics = LocalHapticFeedback.current
    val scope = rememberCoroutineScope()
    var text by rememberSaveable { mutableStateOf("") }
    // The same on-device rules that run before sending, applied while typing: what will be removed is marked
    // in the field itself, so the user sees it before anything leaves the phone.
    val redactor = remember { LibyanRedactor() }
    val spans = remember(text) { if (text.isBlank()) emptyList() else redactor.redact(text).spans }
    val mark = if (c.isDark) c.sun.copy(alpha = 0.38f) else c.sunSoft
    val highlight = remember(spans, mark) { HiddenWords(spans.map { it.start until it.end }, mark) }
    val focus = remember { MutableInteractionSource() }
    val focused by focus.collectIsFocusedAsState()
    val lift by animateFloatAsState(if (focused) 1f else 0f, KhMotion.gentle(), label = "lift")
    val canSend = text.isNotBlank() && !state.waiting
    val flight = remember { Animatable(0f) }
    val fieldFocus = remember { FocusRequester() }

    fun send() {
        if (!canSend) return
        haptics.performHapticFeedback(HapticFeedbackType.TextHandleMove)
        onSend(text); text = ""
        scope.launch { flight.snapTo(0f); flight.animateTo(1f, tween(380, easing = KhMotion.EmphasizedAccelerate)); flight.snapTo(0f) }
    }

    // No bar behind it: each control carries its own outlined shape, so the composer floats.
    Column(modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp)) {
        // Shortcuts only at the end of the conversation, so they never sit on top of what the user is reading.
        AnimatedVisibility(
            visible = showChips && (!state.supportReady || state.lines.size > 1) && !(state.lines.size == 1 && text.isNotEmpty()),
            enter = fadeIn(tween(180)) + expandVertically(KhMotion.gentle(), expandFrom = Alignment.Bottom) +
                slideInVertically(KhMotion.gentleOffset) { it / 2 },
            exit = fadeOut(tween(120)) + shrinkVertically(tween(200, easing = KhMotion.EmphasizedAccelerate), shrinkTowards = Alignment.Bottom),
        ) {
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.padding(bottom = 10.dp).horizontalScroll(rememberScrollState())) {
                // A way in for when the first words are the hardest: it only fills the field, the user edits and sends.
                if (state.lines.size == 1) Texts.STARTERS.forEach { s ->
                    Chip(s, R.drawable.ic_kh_edit, { text = "$s، "; fieldFocus.requestFocus() }, enabled = true)
                }
                if (!state.supportReady) Chip(Texts.WHO_TO_TALK, R.drawable.ic_kh_users, onWhoToTalk, enabled = !state.waiting)
                if (state.lines.size > 1) Chip(Texts.NEW_CHAT, R.drawable.ic_kh_edit, onNewChat, enabled = !state.waiting)
            }
        }
        Row(verticalAlignment = Alignment.Bottom) {
            Box(Modifier.weight(1f).padding(end = 4.dp, bottom = 5.dp)) {
                // the brand's hard print shadow; the field lifts off it a little while the user writes
                Box(Modifier.matchParentSize()
                    .absoluteOffset((3 + 1.5f * lift).dp, (4 + 1.5f * lift).dp)
                    .background(c.shadow.copy(alpha = if (c.isDark) 1f else 0.9f), KhShapes.field))
                BasicTextField(
                    value = text,
                    onValueChange = { text = it },
                    textStyle = KhType.bubble.copy(color = c.ink),
                    cursorBrush = SolidColor(c.greenDeep),
                    interactionSource = focus,
                    visualTransformation = highlight,
                    keyboardOptions = KeyboardOptions(capitalization = KeyboardCapitalization.Sentences, imeAction = ImeAction.Default),
                    modifier = Modifier
                        .fillMaxWidth()
                        .focusRequester(fieldFocus)
                        .graphicsLayer { translationX = -1.5f * lift * density; translationY = -1.5f * lift * density }
                        .heightIn(min = 54.dp, max = 148.dp)
                        .background(c.paperRaised, KhShapes.field)
                        .border(PenWidth, c.ink, KhShapes.field)
                        .padding(horizontal = 16.dp, vertical = 13.dp)
                        .semantics { contentDescription = "اكتب رسالتك" },
                    decorationBox = { inner ->
                        Box {
                            // the hint drifts away as the first letter lands, instead of blinking out
                            androidx.compose.animation.AnimatedVisibility(
                                visible = text.isEmpty(),
                                enter = fadeIn(tween(200)) + slideInHorizontally(KhMotion.gentleOffset) { -it / 6 },
                                exit = fadeOut(tween(90)) + slideOutHorizontally(tween(160)) { it / 8 },
                            ) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Text(Texts.COMPOSER_HINT, style = KhType.bubble, color = c.inkMuted)
                                    if (!focused) {
                                        Spacer(Modifier.width(6.dp))
                                        Doodle(Doodles.SQUIGGLE, c.inkMuted.copy(alpha = 0.55f), Modifier.size(34.dp, 8.dp),
                                            key = "composer-hint-squiggle", delayMillis = 900, durationMillis = 700)
                                    }
                                }
                            }
                            inner()
                        }
                    },
                )
            }
            Spacer(Modifier.width(10.dp))
            SendButton(canSend = canSend, waiting = state.waiting, flight = flight.value, onClick = ::send)
        }
        PrivacyLine(hidden = spans.size, modifier = Modifier.padding(top = 8.dp))
    }
}

/** Marks the words the on-device rules will remove, like a highlighter, without changing the text. */
private class HiddenWords(private val ranges: List<IntRange>, private val mark: Color) : VisualTransformation {
    override fun filter(text: AnnotatedString): TransformedText {
        if (ranges.isEmpty()) return TransformedText(text, OffsetMapping.Identity)
        val out = buildAnnotatedString {
            append(text)
            ranges.forEach { r ->
                if (r.last < text.length) addStyle(SpanStyle(background = mark, textDecoration = TextDecoration.Underline), r.first, r.last + 1)
            }
        }
        return TransformedText(out, OffsetMapping.Identity)
    }
    override fun equals(other: Any?) = other is HiddenWords && other.ranges == ranges && other.mark == mark
    override fun hashCode() = ranges.hashCode() * 31 + mark.hashCode()
}

@Composable
private fun SendButton(canSend: Boolean, waiting: Boolean, flight: Float, onClick: () -> Unit) {
    val c = Kh.colors
    val source = remember { MutableInteractionSource() }
    val pressed by source.collectIsPressedAsState()
    val bg by animateColorAsState(if (canSend) c.green else c.paperSunk, tween(220), label = "sendBg")
    val edge by animateColorAsState(if (canSend) c.ink else c.border, tween(220), label = "sendEdge")
    val ready by animateFloatAsState(if (canSend) 1f else 0f, KhMotion.snappy(), label = "sendReady")
    val press by animateFloatAsState(if (pressed) 0.9f else 1f, KhMotion.snappy(), label = "sendPress")
    Box(Modifier.padding(end = 4.dp, bottom = 5.dp)) {
        // the print shadow only appears once there is something to send
        Box(Modifier.matchParentSize().absoluteOffset((3 * ready).dp, (4 * ready).dp)
            .background(c.shadow.copy(alpha = ready * (if (c.isDark) 1f else 0.9f)), KhShapes.chip))
        Box(
            Modifier.size(54.dp)
                .graphicsLayer { val s = (0.92f + 0.08f * ready) * press; scaleX = s; scaleY = s }
                .background(bg, KhShapes.chip)
                .border(PenWidth, edge, KhShapes.chip)
                .clickable(interactionSource = source, indication = null, enabled = canSend, role = Role.Button, onClick = onClick)
                .semantics { contentDescription = "ابعت" },
            contentAlignment = Alignment.Center,
        ) {
            if (waiting) {
                DoodleLoop(Doodles.SQUIGGLE, c.inkMuted, Modifier.size(30.dp, 8.dp), periodMillis = 1300)
            } else {
                // send points left in a right-to-left layout; on send it flies off and a fresh one settles in
                KhIcon(R.drawable.ic_kh_send, if (canSend) c.onGreen else c.inkMuted,
                    Modifier.graphicsLayer {
                        scaleX = -1f
                        rotationZ = -12f * (1f - ready)
                        translationX = -flight * 46.dp.toPx()
                        translationY = -flight * 18.dp.toPx()
                        alpha = 1f - flight
                    }, size = 22.dp)
            }
        }
    }
}

@Composable
private fun PrivacyLine(hidden: Int, modifier: Modifier = Modifier) {
    val c = Kh.colors
    val bg by animateColorAsState(if (hidden > 0) c.sunSoft else c.paperRaised.copy(alpha = 0.92f), tween(260), label = "privacyBg")
    Row(
        modifier.background(bg, KhShapes.chip).animateContentSize(KhMotion.gentle()).padding(horizontal = 10.dp, vertical = 5.dp)
            .semantics(mergeDescendants = true) {},
        verticalAlignment = Alignment.CenterVertically,
    ) {
        // the shield ticks once each time a new word gets marked
        Box(Modifier.size(16.dp), contentAlignment = Alignment.Center) {
            KhIcon(R.drawable.ic_kh_shield, c.greenDeep, size = 16.dp)
            Doodle(Doodles.TICK, c.greenDeep, Modifier.size(9.dp), key = "privacy-tick-$hidden", durationMillis = 380)
        }
        Spacer(Modifier.width(6.dp))
        AnimatedContent(
            targetState = hidden > 0,
            transitionSpec = { (fadeIn(tween(200, 60)) + slideInVertically(KhMotion.gentleOffset) { it / 2 }) togetherWith
                (fadeOut(tween(100)) + slideOutVertically(tween(160)) { -it / 2 }) },
            label = "privacyText",
        ) { marked ->
            Text(if (marked) Texts.PRIVACY_MARKED else Texts.PRIVACY_LINE, style = KhType.small,
                color = if (marked) c.ink else c.inkMuted)
        }
    }
}

private fun Modifier.graphicsMirror(): Modifier = this.graphicsLayer(scaleX = -1f)

@Composable
private fun JumpToLatest(visible: Boolean, onClick: () -> Unit, modifier: Modifier = Modifier) {
    val c = Kh.colors
    AnimatedVisibility(
        visible = visible,
        enter = fadeIn(tween(160)) + scaleIn(KhMotion.snappy(), initialScale = 0.7f),
        exit = fadeOut(tween(120)) + scaleOut(tween(120), targetScale = 0.7f),
        modifier = modifier,
    ) {
        Box(
            Modifier.size(44.dp).background(c.paperRaised, KhShapes.chip).border(PenWidth, c.ink, KhShapes.chip)
                .clickable(role = Role.Button, onClick = onClick)
                .semantics { contentDescription = "آخر رسالة" },
            contentAlignment = Alignment.Center,
        ) { KhIcon(R.drawable.ic_kh_arrow_down, c.ink, size = 22.dp) }
    }
}

/** A new chat erases the current one from the phone, so ask first. */
@Composable
private fun ConfirmNewChat(onConfirm: () -> Unit, onDismiss: () -> Unit) {
    val c = Kh.colors
    Dialog(onDismissRequest = onDismiss) {
        CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
            Column(
                Modifier.fillMaxWidth().background(c.paperRaised, KhShapes.panel).border(PenWidth, c.ink, KhShapes.panel).padding(22.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    KhIcon(R.drawable.ic_kh_trash, c.ink, size = 22.dp)
                    Spacer(Modifier.width(10.dp))
                    Text("نبداو محادثة جديدة؟", style = KhType.heading, color = c.ink)
                }
                Text("المحادثة هذي بتنمسح من تلفونك، وما تقدرش ترجعلها.", style = KhType.body, color = c.inkMuted)
                Spacer(Modifier.height(4.dp))
                KhButton("إيه، محادثة جديدة", onConfirm, Modifier.fillMaxWidth())
                KhButton("لا، نكمل", onDismiss, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet)
            }
        }
    }
}

/** While a reply types itself out, keep its bottom edge on screen without jumping past it. */
private suspend fun keepInView(list: androidx.compose.foundation.lazy.LazyListState, index: Int) {
    val info = list.layoutInfo
    val item = info.visibleItemsInfo.firstOrNull { it.index == index } ?: return list.animateScrollToItem(index)
    // the visible area ends above the floating composer (the list's bottom content padding)
    val overflow = item.offset + item.size - (info.viewportEndOffset - info.afterContentPadding) + 24
    if (overflow > 0) list.animateScrollBy(overflow.toFloat())
}

/** Shown in place of the support options for the second or two they take to arrive. */
@Composable
private fun OptionsPlaceholder() {
    val c = Kh.colors
    val t = rememberInfiniteTransition(label = "shimmer")
    val x by t.animateFloat(-1f, 2f, infiniteRepeatable(tween(1300, easing = LinearEasing)), label = "x")
    val brush = Brush.linearGradient(
        listOf(c.paperSunk, c.paperRaised, c.paperSunk),
        start = Offset(x * 900f, 0f), end = Offset(x * 900f + 600f, 300f),
    )
    Column(
        Modifier.fillMaxWidth().background(c.paperRaised, KhShapes.card).border(PenWidth, c.line, KhShapes.card).padding(18.dp)
            .semantics { contentDescription = "نجهزوا في ناس ممكن تحكي معاهم" },
        verticalArrangement = Arrangement.spacedBy(10.dp),
    ) {
        Text("نجهزوا في ناس ممكن تحكي معاهم…", style = KhType.label, color = c.inkMuted)
        Box(Modifier.fillMaxWidth(0.55f).height(18.dp).background(brush, KhShapes.chip))
        Box(Modifier.fillMaxWidth().height(14.dp).background(brush, KhShapes.chip))
        Box(Modifier.fillMaxWidth(0.8f).height(14.dp).background(brush, KhShapes.chip))
        Box(Modifier.fillMaxWidth().height(56.dp).background(brush, KhShapes.bubbleMe))
    }
}

@Composable
private fun Chip(text: String, icon: Int, onClick: () -> Unit, enabled: Boolean) {
    val c = Kh.colors
    val source = remember { MutableInteractionSource() }
    val pressed by source.collectIsPressedAsState()
    val scale by animateFloatAsState(if (pressed) 0.95f else 1f, KhMotion.snappy(), label = "chip")
    Row(
        Modifier
            .minimumInteractiveComponentSize()
            .graphicsLayer { scaleX = scale; scaleY = scale; alpha = if (enabled) 1f else 0.6f }
            .background(c.paperRaised, KhShapes.chip)
            .border(1.5.dp, c.border, KhShapes.chip)
            .clickable(interactionSource = source, indication = null, enabled = enabled, role = Role.Button, onClick = onClick)
            .padding(start = 12.dp, end = 14.dp, top = 7.dp, bottom = 7.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        KhIcon(icon, c.greenDeep, size = 16.dp)
        Spacer(Modifier.width(6.dp))
        Text(text, style = KhType.label, color = c.ink)
    }
}

// ---------------------------------------------------------------- urgent help

@Composable
fun UrgentScreen(auto: Boolean, onBack: () -> Unit) {
    val c = Kh.colors
    val context = LocalContext.current
    var copied by remember { mutableStateOf(false) }
    LaunchedEffect(copied) { if (copied) { delay(1800); copied = false } }
    Column(Modifier.fillMaxSize()) {
        Row(Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 10.dp), verticalAlignment = Alignment.CenterVertically) {
            BackButton(onBack)
            Text(Texts.URGENT_BACK, style = KhType.label, color = c.inkMuted)
        }
        Column(Modifier.weight(1f).verticalScroll(rememberScrollState()).padding(horizontal = Gutter),
            verticalArrangement = Arrangement.spacedBy(14.dp)) {
            Column(
                Modifier.fillMaxWidth().background(c.paperRaised, KhShapes.panel).border(PenWidth, c.urgent, KhShapes.panel).padding(20.dp),
                verticalArrangement = Arrangement.spacedBy(10.dp),
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(painterResource(R.drawable.ill_lifebuoy), contentDescription = null, modifier = Modifier.size(64.dp))
                    Spacer(Modifier.width(12.dp))
                    ScreenTitle(Texts.URGENT_TITLE, Modifier.weight(1f))
                }
                if (auto) Text(Texts.URGENT_INTRO_AUTO, style = KhType.body, color = c.ink)
            }
            listOf(Texts.URGENT_STEP_PERSON, Texts.URGENT_STEP_HOSPITAL, Texts.URGENT_STEP_SAFE).forEachIndexed { i, step ->
                Appear("urgent-step-$i-$auto", 120L + 80L * i) { Step(i + 1, step, "urgent-$auto") }
            }
            Note(Texts.URGENT_NO_CONTACTS, R.drawable.ic_kh_info, c.sunSoft)
            Column(
                Modifier.fillMaxWidth().background(c.claySoft, KhShapes.card).border(PenWidth, c.ink, KhShapes.card).padding(18.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                Text(Texts.URGENT_MESSAGE_TITLE, style = KhType.heading, color = c.ink)
                Text(Texts.URGENT_MESSAGE_TEXT, style = KhType.bubble, color = c.onGreen,
                    modifier = Modifier.fillMaxWidth().background(c.green, KhShapes.bubbleMe).border(PenWidth, c.onGreen, KhShapes.bubbleMe).padding(14.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                    KhButton(Texts.URGENT_SHARE, { shareText(context, Texts.URGENT_MESSAGE_TEXT) }, Modifier.weight(1f), icon = R.drawable.ic_kh_share)
                    KhButton(if (copied) Texts.DRAFT_COPIED else Texts.URGENT_COPY, { copyText(context, Texts.URGENT_MESSAGE_TEXT); copied = true },
                        Modifier.weight(1f), kind = ButtonKind.Quiet, icon = if (copied) R.drawable.ic_kh_check else R.drawable.ic_kh_copy)
                }
            }
            Text("حاجات تقدر تديرها توا", style = KhType.heading, color = c.ink, modifier = Modifier.padding(top = 6.dp))
            CopingCard(R.drawable.ill_breathe, Texts.CARD_BREATH_TITLE, Texts.CARD_BREATH_BODY) { BreathingGuide() }
            CopingCard(R.drawable.ill_stones_three, Texts.CARD_GROUND_TITLE, Texts.CARD_GROUND_BODY)
            Text(Texts.URGENT_FOOTER, style = KhType.small, color = c.inkMuted, modifier = Modifier.padding(vertical = 12.dp))
        }
    }
}

@Composable
private fun Step(n: Int, text: String, scope: String) {
    val c = Kh.colors
    Row(
        Modifier.fillMaxWidth().background(c.paperRaised, KhShapes.card).border(PenWidth, c.ink, KhShapes.card).padding(16.dp)
            .semantics(mergeDescendants = true) {},
        verticalAlignment = Alignment.Top,
    ) {
        // the brand's hand-drawn step numeral (decoration: the step is written out beside it)
        val numeral = when (n) { 1 -> Doodles.STEP_1; 2 -> Doodles.STEP_2; else -> Doodles.STEP_3 }
        Doodle(numeral, c.onGreen, Modifier.size(42.dp), key = "$scope-numeral-$n", delayMillis = 200L + 90L * n,
            durationMillis = 700, mirrorInRtl = false)
        Spacer(Modifier.width(12.dp))
        Text(text, style = KhType.body, color = c.ink, modifier = Modifier.weight(1f))
    }
}

@Composable
private fun CopingCard(image: Int, title: String, body: String, extra: @Composable () -> Unit = {}) {
    val c = Kh.colors
    Row(
        Modifier.fillMaxWidth().background(c.greenSoft, KhShapes.card).padding(16.dp),
        verticalAlignment = Alignment.Top,
    ) {
        Image(painterResource(image), contentDescription = null, modifier = Modifier.size(56.dp))
        Spacer(Modifier.width(12.dp))
        Column(Modifier.weight(1f)) {
            Text(title, style = KhType.heading, color = c.ink)
            Text(body, style = KhType.body, color = c.ink)
            extra()
        }
    }
}


// ---------------------------------------------------------------- what left the phone

private val PLACEHOLDER = Regex("""\[(اسم|مكان|رقم|بريد|مخفي)\d*]""")

/**
 * Under each of the user's messages: whether anything identifying was removed, and on tap, the exact text
 * that reached the AI, with the placeholders marked. Kept in memory only, like the rest of the conversation.
 */
@Composable
private fun SentReceipt(sent: String?, id: Long, onOpen: () -> Unit) {
    val c = Kh.colors
    var open by rememberSaveable(id) { mutableStateOf(false) }
    val hidden = sent != null && PLACEHOLDER.containsMatchIn(sent)
    Column(Modifier.fillMaxWidth().padding(top = 4.dp), horizontalAlignment = Alignment.Start) {
        Row(
            Modifier.clip(KhShapes.chip)
                .clickable(enabled = sent != null, role = Role.Button) { open = !open; if (open) onOpen() }
                .padding(horizontal = 6.dp, vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Box(Modifier.size(15.dp), contentAlignment = Alignment.Center) {
                KhIcon(if (sent == null) R.drawable.ic_kh_lock else R.drawable.ic_kh_shield, c.greenDeep, size = 15.dp)
                if (hidden) Doodle(Doodles.TICK, c.greenDeep, Modifier.size(8.dp), key = "receipt-tick-$id", delayMillis = 250, durationMillis = 380)
            }
            Spacer(Modifier.width(5.dp))
            val label = when { sent == null -> Texts.RECEIPT_LOCAL; hidden -> Texts.RECEIPT_HIDDEN; else -> Texts.RECEIPT_CLEAN }
            Text(label, style = KhType.small, color = c.inkMuted)
            if (sent != null) {
                Text("  ·  ", style = KhType.small, color = c.inkMuted)
                Text(if (open) Texts.RECEIPT_HIDE else Texts.RECEIPT_SHOW, style = KhType.small.copy(textDecoration = TextDecoration.Underline),
                    color = c.greenDeep)
            }
        }
        AnimatedVisibility(
            visible = open && sent != null,
            enter = fadeIn(tween(200, 60)) + expandVertically(KhMotion.gentle(), expandFrom = Alignment.Top),
            exit = fadeOut(tween(120)) + shrinkVertically(tween(220, easing = KhMotion.EmphasizedAccelerate), shrinkTowards = Alignment.Top),
        ) {
            val marked = remember(sent) {
                buildAnnotatedString {
                    val s = sent.orEmpty(); var at = 0
                    PLACEHOLDER.findAll(s).forEach { m ->
                        append(s.substring(at, m.range.first))
                        withStyle(SpanStyle(background = if (c.isDark) c.sun.copy(alpha = 0.38f) else c.sunSoft, fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold)) { append(m.value) }
                        at = m.range.last + 1
                    }
                    append(s.substring(at))
                }
            }
            Column(
                Modifier.padding(top = 4.dp).widthIn(max = 300.dp)
                    .background(c.paperRaised, KhShapes.card)
                    .dashedBorder(c.inkMuted, KhShapes.card)
                    .padding(horizontal = 14.dp, vertical = 10.dp),
                verticalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                Text(Texts.RECEIPT_TITLE, style = KhType.label, color = c.inkMuted)
                Text(marked, style = KhType.bubble, color = c.ink)
                Text(Texts.RECEIPT_NOTE, style = KhType.small, color = c.inkMuted)
            }
        }
    }
}

/** A hand-drawn dashed edge: "this is a copy of what was sent", not a message. */
private fun Modifier.dashedBorder(color: Color, shape: androidx.compose.ui.graphics.Shape): Modifier = drawWithContent {
    drawContent()
    val outline = shape.createOutline(size, layoutDirection, this)
    drawOutline(outline, color, style = Stroke(width = 1.6.dp.toPx(), cap = StrokeCap.Round,
        pathEffect = androidx.compose.ui.graphics.PathEffect.dashPathEffect(floatArrayOf(7.dp.toPx(), 5.dp.toPx()))))
}

// ---------------------------------------------------------------- breathing together

/**
 * Follows the fixed breathing card (in for 4, out for 6, five times): a pebble fills as the breath comes in and
 * empties as it goes out, with the count beside it. A soft tick marks each change. It stops whenever the user wants.
 */
@Composable
private fun BreathingGuide() {
    val c = Kh.colors
    val haptics = LocalHapticFeedback.current
    var running by remember { mutableStateOf(false) }
    var done by remember { mutableStateOf(false) }
    var inhale by remember { mutableStateOf(true) }
    var count by remember { mutableIntStateOf(1) }
    var round by remember { mutableIntStateOf(1) }
    val fill = remember { Animatable(0.35f) }
    LaunchedEffect(running) {
        if (!running) { fill.animateTo(0.35f, tween(500)); return@LaunchedEffect }
        done = false
        for (r in 1..5) {
            round = r
            inhale = true; haptics.performHapticFeedback(HapticFeedbackType.TextHandleMove)
            launch { fill.animateTo(1f, tween(4000, easing = androidx.compose.animation.core.FastOutSlowInEasing)) }
            for (i in 1..4) { count = i; kotlinx.coroutines.delay(1000) }
            inhale = false; haptics.performHapticFeedback(HapticFeedbackType.TextHandleMove)
            launch { fill.animateTo(0.35f, tween(6000, easing = androidx.compose.animation.core.FastOutSlowInEasing)) }
            for (i in 1..6) { count = i; kotlinx.coroutines.delay(1000) }
        }
        running = false; done = true
    }
    Column(Modifier.fillMaxWidth().padding(top = 12.dp).animateContentSize(KhMotion.gentle())) {
        if (!running) {
            if (done) Text(Texts.BREATH_DONE, style = KhType.body, color = c.ink, modifier = Modifier.padding(bottom = 8.dp))
            KhButton(if (done) Texts.BREATH_AGAIN else Texts.BREATH_START, { running = true }, Modifier.fillMaxWidth(),
                kind = ButtonKind.Quiet)
        } else {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Canvas(Modifier.size(88.dp).semantics { contentDescription = if (inhale) Texts.BREATH_IN else Texts.BREATH_OUT }) {
                    val r = size.minDimension / 2f
                    // the full pebble, drawn in pen
                    drawOval(c.ink, topLeft = Offset(size.width / 2 - r * 0.92f, size.height / 2 - r),
                        size = androidx.compose.ui.geometry.Size(r * 1.84f, r * 2f), style = Stroke(PenWidth.toPx()))
                    // the breath, filling it
                    val f = fill.value
                    drawOval(c.green, topLeft = Offset(size.width / 2 - r * 0.92f * f, size.height / 2 - r * f),
                        size = androidx.compose.ui.geometry.Size(r * 1.84f * f, r * 2f * f))
                }
                Spacer(Modifier.width(14.dp))
                Column(Modifier.weight(1f)) {
                    AnimatedContent(inhale, transitionSpec = { fadeIn(tween(300)) togetherWith fadeOut(tween(200)) }, label = "phase") { inh ->
                        Text(if (inh) Texts.BREATH_IN else Texts.BREATH_OUT, style = KhType.heading, color = c.ink)
                    }
                    AnimatedContent(count, transitionSpec = {
                        (fadeIn(tween(220)) + slideInVertically(KhMotion.gentleOffset) { it / 2 }) togetherWith fadeOut(tween(150))
                    }, label = "count") { n ->
                        Text("$n", style = KhType.title, color = c.greenDeep)
                    }
                    Text("المرة $round من 5", style = KhType.small, color = c.inkMuted)
                }
            }
            Spacer(Modifier.height(8.dp))
            KhButton(Texts.BREATH_STOP, { running = false }, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet)
        }
    }
}
