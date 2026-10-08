package ly.manara.khutwa.ui.screens

import androidx.compose.foundation.selection.toggleable
import androidx.compose.foundation.layout.offset
import androidx.compose.ui.semantics.heading
import ly.manara.khutwa.ui.components.Prefs
import ly.manara.khutwa.ui.components.Addressing
import androidx.compose.ui.semantics.selected
import ly.manara.khutwa.ui.components.t
import ly.manara.khutwa.ui.components.UrgentPill
import ly.manara.khutwa.ui.components.Stone
import androidx.compose.foundation.layout.navigationBarsPadding
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
import ly.manara.khutwa.ui.components.DoodleCycle
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
import androidx.compose.foundation.gestures.scrollBy
import androidx.compose.runtime.snapshotFlow
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.items
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
fun ConsentScreen(onAccept: () -> Unit, onDecline: () -> Unit, onUrgent: () -> Unit, onSettings: () -> Unit = {}) {
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
                        Text(t(Texts.DECLINED_BODY),
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
        TopBar(onUrgent, onSettings = onSettings)
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
                    Text(t(Texts.CONSENT_INTRO), style = KhType.body, color = c.inkMuted)
                }
            }
            Spacer(Modifier.height(14.dp))
            Appear("consent-address", 130) { AddressChoice() }
            Spacer(Modifier.height(20.dp))
            listOf(
                Triple(R.drawable.ic_kh_sparkle, Texts.CONSENT_AI, false),
                Triple(R.drawable.ic_kh_shield_check, Texts.CONSENT_REDACTION, false),
                Triple(R.drawable.ic_kh_info, Texts.CONSENT_GOOGLE, false),
                Triple(R.drawable.ic_kh_lock, Texts.CONSENT_SERVER, false),
                Triple(R.drawable.ic_kh_urgent, t(Texts.CONSENT_EMERGENCY), true),
            ).forEachIndexed { i, (icon, text, urgent) ->
                Appear("consent-point-$i", 160L + 70L * i) { ConsentPoint(icon, text, urgent) }
            }
            Spacer(Modifier.height(12.dp))
        }
        Column(Modifier.padding(horizontal = Gutter, vertical = 12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            KhButton(t(Texts.CONSENT_ACCEPT), onAccept, Modifier.fillMaxWidth())
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
    onSettings: () -> Unit = {},
    onOpenChat: (Long) -> Unit = {},
    onAllChats: () -> Unit = {},
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
            list.animateScrollToItem(firstNew)
        } else {
            scrollToEnd(list)
        }
    }
    // Follows the end of the conversation until the user scrolls up, and again once they come back down. While following,
    // the list stays pinned to the end when the space above the composer changes (chips showing, keyboard, a longer draft),
    // so the starter chips and the jump button can't flicker each other on and off.
    val endSlop = with(LocalDensity.current) { 48.dp.roundToPx() }
    var following by remember { mutableStateOf(true) }
    LaunchedEffect(list) {
        snapshotFlow { list.isScrollInProgress to distanceToEnd(list) }.collect { (moving, d) ->
            if (d <= endSlop) following = true else if (moving) following = false
        }
    }
    LaunchedEffect(list) {
        snapshotFlow { list.layoutInfo.let { it.viewportEndOffset - it.afterContentPadding } }.collect {
            val d = distanceToEnd(list)
            if (following && !list.isScrollInProgress && d in 1 until Int.MAX_VALUE) list.scrollBy(d.toFloat())
        }
    }
    val density = LocalDensity.current
    var composerHeight by remember { mutableIntStateOf(0) }
    // Chats and settings live in a drawer from the start edge (the right, in Arabic), like other chat apps.
    var confirmNew by remember { mutableStateOf(false) }
    val drawer = androidx.compose.material3.rememberDrawerState(androidx.compose.material3.DrawerValue.Closed)
    val closeThen: (() -> Unit) -> Unit = { action -> scope.launch { drawer.close() }; action() }
    androidx.activity.compose.BackHandler(enabled = drawer.isOpen) { scope.launch { drawer.close() } }
    androidx.compose.material3.ModalNavigationDrawer(
        drawerState = drawer,
        gesturesEnabled = drawer.isOpen,
        scrimColor = Color.Black.copy(alpha = if (c.isDark) 0.5f else 0.28f),
        drawerContent = {
            androidx.compose.material3.ModalDrawerSheet(
                drawerState = drawer,
                drawerContainerColor = c.paperRaised,
                drawerShape = androidx.compose.foundation.shape.RoundedCornerShape(topEnd = 24.dp, bottomEnd = 24.dp),
                drawerTonalElevation = 0.dp,
                modifier = Modifier.width(300.dp),
            ) {
                ChatDrawer(state, onNewChat = { closeThen { if (Prefs.keepHistory || state.lines.size <= 1) onNewChat() else confirmNew = true } },
                    onOpenChat = { id -> closeThen { onOpenChat(id) } }, onAllChats = { closeThen(onAllChats) },
                    onSettings = { closeThen(onSettings) })
            }
        },
    ) {
    Column(Modifier.fillMaxSize().imePadding()) {
        TopBar(onUrgent, onMenu = { scope.launch { drawer.open() } })
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
                WelcomeHeader(seed = state.lines.firstOrNull()?.id ?: 0L,
                    returning = Prefs.keepHistory && (state.memory.isNotBlank() || state.savedChats.any { it.id != state.chatId }))
            }
            // Line 0 is the greeting, which the welcome header above now says; line i (i >= 1) sits at list index i.
            itemsIndexed(state.lines.drop(1), key = { _, l -> l.id }) { index, line: Line ->
                Box(Modifier.animateItem(fadeInSpec = null, fadeOutSpec = null)) {
                    Appear(line.id) {
                        val surface = line.surface
                        when {
                            surface != null -> A2uiView(surface)
                            line.loadingSurface -> OptionsPlaceholder()
                            else -> Column {
                                Bubble(if (line.mine) line.text else t(line.text), line.mine, reveal = line.reveal,
                                    onRevealed = { onRevealed(line.id); scope.launch { keepInView(list, index + 1) } },
                                    onGrow = { scope.launch { keepInView(list, index + 1) } },
                                    showWho = state.lines.getOrNull(index)?.let { it.mine || index == 0 } ?: true)
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
                        Text(t(Texts.ERROR_NETWORK), style = KhType.body, color = c.ink, modifier = Modifier.weight(1f))
                    }
                    Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        KhButton(t(Texts.RETRY), onRetry, Modifier.weight(1f), kind = ButtonKind.Quiet, icon = R.drawable.ic_kh_refresh)
                        KhButton("نحتاج مساعدة", onUrgent, Modifier.weight(1f), kind = ButtonKind.Urgent)
                    }
                }
            }
        }
        // Jump to the latest message when the user has scrolled up.
        JumpToLatest(
            visible = !following && state.lines.size > 2,
            onClick = { scope.launch { scrollToEnd(list) } },
            modifier = Modifier.align(Alignment.BottomEnd)
                .padding(end = 18.dp, bottom = with(density) { composerHeight.toDp() } + 10.dp),
        )
        val online = rememberOnline()
        var calm by remember { mutableStateOf(false) }
        // With saved chats on, a new chat loses nothing, so there is nothing to confirm.
        Composer(state, onSend, onWhoToTalk, { if (Prefs.keepHistory) onNewChat() else confirmNew = true }, showChips = following || state.lines.size <= 2,
            online = online, onCalm = { calm = true },
            modifier = Modifier.align(Alignment.BottomCenter).onSizeChanged { composerHeight = it.height })
        if (calm) CalmSheet(onDismiss = { calm = false }, onUrgent = onUrgent)
        if (confirmNew) ConfirmNewChat(onConfirm = { confirmNew = false; onNewChat() }, onDismiss = { confirmNew = false })
        }
    }
    }
}

/** The drawer, kept quiet like other chat apps: a new chat, the saved chats by day (or how to turn saving on), settings. */
@Composable
private fun ChatDrawer(
    state: UiState,
    onNewChat: () -> Unit,
    onOpenChat: (Long) -> Unit,
    onAllChats: () -> Unit,
    onSettings: () -> Unit,
) {
    val c = Kh.colors
    Column(Modifier.fillMaxSize().padding(horizontal = 12.dp, vertical = 16.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.padding(horizontal = 12.dp)) {
            Image(painterResource(if (c.isDark) R.drawable.logo_mark_dark else R.drawable.logo_mark), contentDescription = null,
                modifier = Modifier.size(28.dp))
            Spacer(Modifier.width(10.dp))
            Text("خطوة", style = KhType.heading, color = c.ink)
        }
        Spacer(Modifier.height(20.dp))
        DrawerRow(R.drawable.ic_kh_edit, Texts.NEW_CHAT, onNewChat)
        Spacer(Modifier.height(18.dp))
        Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.padding(start = 12.dp)) {
            Text(Texts.HISTORY, style = KhType.small, color = c.inkMuted, modifier = Modifier.weight(1f))
            if (Prefs.keepHistory && state.savedChats.isNotEmpty()) Text(Texts.SEE_ALL, style = KhType.small, color = c.greenDeep,
                modifier = Modifier.clip(KhShapes.chip).clickable(role = Role.Button, onClick = onAllChats)
                    .padding(horizontal = 12.dp, vertical = 6.dp))
        }
        when {
            !Prefs.keepHistory -> {
                Text(t(Texts.DRAWER_NOT_SAVED), style = KhType.small, color = c.inkMuted,
                    modifier = Modifier.padding(start = 12.dp, end = 12.dp, top = 6.dp))
                Text(t(Texts.TURN_ON_SAVING), style = KhType.label, color = c.greenDeep,
                    modifier = Modifier.padding(start = 2.dp, top = 2.dp).clip(KhShapes.chip)
                        .clickable(role = Role.Button, onClick = onSettings).padding(horizontal = 10.dp, vertical = 8.dp))
                Spacer(Modifier.weight(1f))
            }
            state.savedChats.isEmpty() -> {
                Text(t(Texts.HISTORY_EMPTY), style = KhType.small, color = c.inkMuted,
                    modifier = Modifier.padding(start = 12.dp, end = 12.dp, top = 6.dp))
                Spacer(Modifier.weight(1f))
            }
            else -> LazyColumn(Modifier.weight(1f).fillMaxWidth()) {
                state.savedChats.groupBy { dayGroup(it.updatedAt) }.forEach { (day, chats) ->
                    item(key = "day-$day") {
                        Text(day, style = KhType.small, color = c.inkMuted.copy(alpha = 0.75f),
                            modifier = Modifier.padding(start = 12.dp, top = 10.dp, bottom = 2.dp))
                    }
                    items(chats, key = { it.id }) { chat -> DrawerChatRow(chat, chat.id == state.chatId) { onOpenChat(chat.id) } }
                }
            }
        }
        Spacer(Modifier.height(8.dp))
        DrawerRow(R.drawable.ic_kh_sliders, Texts.SETTINGS, onSettings)
    }
}

@Composable
private fun DrawerRow(icon: Int, label: String, onClick: () -> Unit) {
    val c = Kh.colors
    Row(
        Modifier.fillMaxWidth().clip(KhShapes.chip).clickable(role = Role.Button, onClick = onClick)
            .padding(horizontal = 12.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        KhIcon(icon, c.ink, size = 21.dp)
        Spacer(Modifier.width(14.dp))
        Text(label, style = KhType.label, color = c.ink)
    }
}

@Composable
private fun DrawerChatRow(chat: ly.manara.khutwa.data.SavedChat, current: Boolean, onClick: () -> Unit) {
    val c = Kh.colors
    Text(
        chat.lines.firstOrNull { it.mine }?.text.orEmpty(), style = KhType.body, color = c.ink, maxLines = 1,
        overflow = androidx.compose.ui.text.style.TextOverflow.Ellipsis,
        modifier = Modifier.fillMaxWidth().clip(KhShapes.chip).background(if (current) c.greenSoft else Color.Transparent)
            .clickable(role = Role.Button, onClick = onClick).padding(horizontal = 12.dp, vertical = 10.dp),
    )
}

private fun dayGroup(millis: Long): String {
    val zone = java.time.ZoneId.systemDefault()
    val d = java.time.Instant.ofEpochMilli(millis).atZone(zone).toLocalDate()
    val today = java.time.LocalDate.now(zone)
    return when {
        d == today -> "اليوم"
        d == today.minusDays(1) -> "امبارح"
        d.isAfter(today.minusDays(7)) -> "الأسبوع هذا"
        else -> "أقدم"
    }
}


@Composable
private fun Composer(
    state: UiState,
    onSend: (String) -> Unit,
    onWhoToTalk: () -> Unit,
    onNewChat: () -> Unit,
    showChips: Boolean,
    online: Boolean,
    onCalm: () -> Unit,
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
    val canSend = text.isNotBlank() && !state.waiting && online
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
        // No connection (power and internet cuts are common): say so plainly and point to what still works.
        AnimatedVisibility(!online, enter = fadeIn(tween(200)) + expandVertically(KhMotion.gentle()),
            exit = fadeOut(tween(150)) + shrinkVertically(tween(200))) {
            Row(
                Modifier.padding(bottom = 10.dp).fillMaxWidth().background(c.sunSoft, KhShapes.card)
                    .border(1.5.dp, c.border, KhShapes.card).clickable(role = Role.Button, onClick = onCalm)
                    .padding(horizontal = 12.dp, vertical = 10.dp),
                verticalAlignment = Alignment.Top,
            ) {
                KhIcon(R.drawable.ic_kh_offline, c.ink, size = 18.dp, modifier = Modifier.padding(top = 2.dp))
                Spacer(Modifier.width(8.dp))
                Text(Texts.OFFLINE, style = KhType.small, color = c.ink)
            }
        }
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
                if (state.lines.size == 1) Texts.STARTERS.map(::t).forEach { s ->
                    Chip(s, R.drawable.ic_kh_edit, { text = "$s، "; fieldFocus.requestFocus() }, enabled = true)
                }
                if (!state.supportReady) Chip(Texts.WHO_TO_TALK, R.drawable.ic_kh_users, onWhoToTalk, enabled = !state.waiting)
                if (state.lines.size > 1) Chip(Texts.CALM, R.drawable.ic_kh_heart, onCalm, enabled = true)
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
                                    Text(t(Texts.COMPOSER_HINT), style = KhType.bubble, color = c.inkMuted)
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
            Doodle(Doodles.TICK, c.greenDeep, Modifier.size(9.dp), key = "privacy-tick-$hidden", durationMillis = 380, mirrorInRtl = false)
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
private fun ConfirmNewChat(onConfirm: () -> Unit, onDismiss: () -> Unit, body: String = Texts.NEW_CHAT_BODY) =
    ConfirmDialog("نبداو محادثة جديدة؟", t(body), "إيه، محادثة جديدة", "لا، نكمل", onConfirm, onDismiss)

/** Asks before anything is deleted for good. */
@Composable
private fun ConfirmDialog(title: String, body: String, yes: String, no: String, onConfirm: () -> Unit, onDismiss: () -> Unit) {
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
                    Text(title, style = KhType.heading, color = c.ink)
                }
                Text(body, style = KhType.body, color = c.inkMuted)
                Spacer(Modifier.height(4.dp))
                KhButton(yes, onConfirm, Modifier.fillMaxWidth())
                KhButton(no, onDismiss, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet)
            }
        }
    }
}

/** How far the end of the last item is below the visible area (above the composer); MAX_VALUE when it isn't laid out. */
private fun distanceToEnd(list: androidx.compose.foundation.lazy.LazyListState): Int {
    val info = list.layoutInfo
    val last = info.visibleItemsInfo.lastOrNull() ?: return 0
    if (last.index < info.totalItemsCount - 1) return Int.MAX_VALUE
    return (last.offset + last.size - (info.viewportEndOffset - info.afterContentPadding)).coerceAtLeast(0)
}

/** Scrolls to the very end of the conversation, the bottom of the last item included, even when it is taller than the screen. */
private suspend fun scrollToEnd(list: androidx.compose.foundation.lazy.LazyListState) {
    val last = list.layoutInfo.totalItemsCount - 1
    if (last < 0) return
    if (list.layoutInfo.visibleItemsInfo.none { it.index == last }) {
        // far up: skip most of the way at once, then glide the rest
        if (list.firstVisibleItemIndex < last - 3) list.scrollToItem(last - 2)
        list.animateScrollToItem(last)
    }
    val d = distanceToEnd(list)
    if (d in 1 until Int.MAX_VALUE) list.animateScrollBy(d.toFloat())
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
                if (auto) Text(t(Texts.URGENT_INTRO_AUTO), style = KhType.body, color = c.ink)
            }
            listOf(t(Texts.URGENT_STEP_PERSON), t(Texts.URGENT_STEP_HOSPITAL), t(Texts.URGENT_STEP_SAFE)).forEachIndexed { i, step ->
                Appear("urgent-step-$i-$auto", 120L + 80L * i) { Step(i + 1, step, "urgent-$auto") }
            }
            Note(t(Texts.URGENT_NO_CONTACTS), R.drawable.ic_kh_info, c.sunSoft)
            Column(
                Modifier.fillMaxWidth().background(c.claySoft, KhShapes.card).border(PenWidth, c.ink, KhShapes.card).padding(18.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                Text(t(Texts.URGENT_MESSAGE_TITLE), style = KhType.heading, color = c.ink)
                Text(t(Texts.URGENT_MESSAGE_TEXT), style = KhType.bubble, color = c.onGreen,
                    modifier = Modifier.fillMaxWidth().background(c.green, KhShapes.bubbleMe).border(PenWidth, c.onGreen, KhShapes.bubbleMe).padding(14.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                    KhButton(t(Texts.URGENT_SHARE), { shareText(context, t(Texts.URGENT_MESSAGE_TEXT)) }, Modifier.weight(1f), icon = R.drawable.ic_kh_share)
                    KhButton(if (copied) Texts.DRAFT_COPIED else t(Texts.URGENT_COPY), { copyText(context, t(Texts.URGENT_MESSAGE_TEXT)); copied = true },
                        Modifier.weight(1f), kind = ButtonKind.Quiet, icon = if (copied) R.drawable.ic_kh_check else R.drawable.ic_kh_copy)
                }
            }
            Text("حاجات تقدر تديرها توا", style = KhType.heading, color = c.ink, modifier = Modifier.padding(top = 6.dp))
            CopingCard(R.drawable.ill_breathe, Texts.CARD_BREATH_TITLE, t(Texts.CARD_BREATH_BODY)) { BreathingGuide() }
            CopingCard(R.drawable.ill_stones_three, Texts.CARD_GROUND_TITLE, t(Texts.CARD_GROUND_BODY))
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
                if (hidden) Doodle(Doodles.TICK, c.greenDeep, Modifier.size(8.dp), key = "receipt-tick-$id", delayMillis = 250, durationMillis = 380, mirrorInRtl = false)
            }
            Spacer(Modifier.width(5.dp))
            val label = when { sent == null -> Texts.RECEIPT_LOCAL; hidden -> t(Texts.RECEIPT_HIDDEN); else -> t(Texts.RECEIPT_CLEAN) }
            Text(label, style = KhType.small, color = c.inkMuted)
            if (sent != null) {
                Text("  ·  ", style = KhType.small, color = c.inkMuted)
                Text(if (open) t(Texts.RECEIPT_HIDE) else t(Texts.RECEIPT_SHOW), style = KhType.small.copy(textDecoration = TextDecoration.Underline),
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
                Text(t(Texts.RECEIPT_LIMIT), style = KhType.small, color = c.inkMuted)
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
            KhButton(if (done) t(Texts.BREATH_AGAIN) else Texts.BREATH_START, { running = true }, Modifier.fillMaxWidth(),
                kind = ButtonKind.Quiet)
        } else {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Canvas(Modifier.size(88.dp).semantics { contentDescription = if (inhale) t(Texts.BREATH_IN) else t(Texts.BREATH_OUT) }) {
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
                        Text(if (inh) t(Texts.BREATH_IN) else t(Texts.BREATH_OUT), style = KhType.heading, color = c.ink)
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
            KhButton(t(Texts.BREATH_STOP), { running = false }, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet)
        }
    }
}

// ---------------------------------------------------------------- calm tools and connection

/** Whether the phone has a usable connection right now; follows changes live. */
@Composable
private fun rememberOnline(): Boolean {
    val context = LocalContext.current
    val cm = remember { context.getSystemService(android.net.ConnectivityManager::class.java) }
    fun now() = cm.getNetworkCapabilities(cm.activeNetwork)
        ?.hasCapability(android.net.NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
    var online by remember { mutableStateOf(now()) }
    androidx.compose.runtime.DisposableEffect(cm) {
        val callback = object : android.net.ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: android.net.Network) { online = true }
            override fun onLost(network: android.net.Network) { online = now() }
        }
        cm.registerDefaultNetworkCallback(callback)
        onDispose { cm.unregisterNetworkCallback(callback) }
    }
    return online
}

/**
 * The reviewed coping tools, one tap from the conversation (proposal: one immediate coping option).
 * Fixed text only, and they work without a connection.
 */
@OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
@Composable
private fun CalmSheet(onDismiss: () -> Unit, onUrgent: () -> Unit) {
    val c = Kh.colors
    androidx.compose.material3.ModalBottomSheet(
        onDismissRequest = onDismiss,
        sheetState = androidx.compose.material3.rememberModalBottomSheetState(skipPartiallyExpanded = true),
        containerColor = c.paper,
        shape = KhShapes.panel,
        dragHandle = { Box(Modifier.padding(top = 10.dp).size(width = 44.dp, height = 5.dp).background(c.border, KhShapes.chip)) },
    ) {
        CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
            Column(
                Modifier.fillMaxWidth().verticalScroll(rememberScrollState()).padding(horizontal = 16.dp, vertical = 8.dp)
                    .navigationBarsPadding(),
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                Row(verticalAlignment = Alignment.Bottom) {
                    Column(Modifier.weight(1f)) {
                        Text(t(Texts.CALM_TITLE), style = KhType.heading, color = c.ink)
                        Doodle(Doodles.UNDERLINE, c.green, Modifier.width(130.dp).height(10.dp), key = "calm-underline",
                            delayMillis = 200, durationMillis = 600)
                    }
                    // the sheet covers the top bar's scrim, so urgent help stays one tap away here too
                    UrgentPill { onDismiss(); onUrgent() }
                }
                CopingCard(R.drawable.ill_breathe, Texts.CARD_BREATH_TITLE, t(Texts.CARD_BREATH_BODY)) { BreathingGuide() }
                CopingCard(R.drawable.ill_stones_three, Texts.CARD_GROUND_TITLE, t(Texts.CARD_GROUND_BODY))
                Spacer(Modifier.height(8.dp))
            }
        }
    }
}

/**
 * Arabic has no neutral "you", so the user picks how Khutwa speaks to them. Every text on screen switches at once.
 * In memory only; never sent and never stored.
 */
@Composable
private fun AddressChoice() {
    val c = Kh.colors
    Row(verticalAlignment = Alignment.CenterVertically) {
        Text(Texts.ADDRESS_LABEL, style = KhType.label, color = c.inkMuted)
        Spacer(Modifier.width(10.dp))
        listOf(false to Texts.ADDRESS_M, true to Texts.ADDRESS_F).forEach { (fem, label) ->
            val selected = ly.manara.khutwa.ui.components.Addressing.feminine == fem
            val bg by animateColorAsState(if (selected) c.green else c.paperRaised, tween(200), label = "addr")
            val edge by animateColorAsState(if (selected) c.ink else c.border, tween(200), label = "addrEdge")
            Row(
                Modifier.padding(end = 8.dp).minimumInteractiveComponentSize()
                    .background(bg, KhShapes.chip).border(1.5.dp, edge, KhShapes.chip)
                    .clickable(role = Role.RadioButton) { ly.manara.khutwa.ui.components.Addressing.feminine = fem }
                    .semantics { this.selected = selected }
                    .padding(horizontal = 16.dp, vertical = 7.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                if (selected) {
                    Doodle(Doodles.TICK, c.onGreen, Modifier.size(14.dp), key = "addr-tick-$fem", durationMillis = 320, mirrorInRtl = false)
                    Spacer(Modifier.width(6.dp))
                }
                Text(label, style = KhType.label, color = if (selected) c.onGreen else c.ink)
            }
        }
    }
}

// ---------------------------------------------------------------- settings

/**
 * Settings: how Khutwa speaks to the user, how it looks and moves, and plain answers about privacy.
 * Only the display choices are kept on the phone; the conversation and the form of address never are.
 */
@Composable
fun SettingsScreen(
    onBack: () -> Unit,
    onUrgent: () -> Unit,
    onErase: () -> Unit,
    canErase: Boolean,
    savedCount: Int = 0,
    memory: String = "",
    onKeepHistory: (Boolean) -> Unit = {},
    onUseMemory: (Boolean) -> Unit = {},
    onClearMemory: () -> Unit = {},
    onOpenHistory: () -> Unit = {},
) {
    val c = Kh.colors
    var confirmErase by remember { mutableStateOf(false) }
    var confirmOff by remember { mutableStateOf(false) }
    Column(Modifier.fillMaxSize()) {
        TopBar(onUrgent, leading = { BackButton(onBack) })
        Column(
            Modifier.weight(1f).verticalScroll(rememberScrollState()).padding(horizontal = Gutter),
            verticalArrangement = Arrangement.spacedBy(14.dp),
        ) {
            Appear("settings-title") {
                Column {
                    ScreenTitle(Texts.SETTINGS)
                    Doodle(Doodles.UNDERLINE, c.green, Modifier.width(140.dp).height(12.dp), key = "settings-underline",
                        delayMillis = 300, durationMillis = 650)
                }
            }
            Appear("settings-address", 60) {
                SettingsSection(R.drawable.ic_kh_user, "كيف نكلموك") {
                    ChoiceRow(listOf(false to Texts.ADDRESS_M, true to Texts.ADDRESS_F), Addressing.feminine) { Addressing.feminine = it }
                    SettingsNote("الكلام كله يتبدّل على طول. ما ينحفظش وما يطلعش من تلفونك.")
                }
            }
            Appear("settings-look", 120) {
                SettingsSection(R.drawable.ic_kh_sparkle, "الشكل") {
                    SettingsLabel("الألوان")
                    ChoiceRow(listOf(Prefs.Theme.System to "تلقائي", Prefs.Theme.Light to "فاتح", Prefs.Theme.Dark to "غامق"),
                        Prefs.theme) { Prefs.theme = it }
                    Spacer(Modifier.height(6.dp))
                    SettingsLabel("حجم الكلام")
                    ChoiceRow(listOf(0.9f to "أصغر", 1f to "عادي", 1.15f to "أكبر", 1.3f to "كبير برشا"), Prefs.textScale) { Prefs.textScale = it }
                    Spacer(Modifier.height(8.dp))
                    // a live preview, so the choice is made by looking, not guessing
                    Column(Modifier.fillMaxWidth().background(c.paper, KhShapes.card).padding(10.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        Bubble("هكي يبان كلام خطوة.", mine = false)
                        Bubble("وهكي يبان كلامك.", mine = true)
                    }
                }
            }
            Appear("settings-comfort", 180) {
                SettingsSection(R.drawable.ic_kh_heart, "الراحة") {
                    SettingsToggle("حركة هادية", "الرسومات تطلع مرسومة من غير حركة، وما فيش حاجة تعاود تتحرك.", Prefs.calmMotion) { Prefs.calmMotion = it }
                    SettingsToggle("الرد يطلع مرة وحدة", "بدل ما يطلع كلمة كلمة.", Prefs.instantReplies) { Prefs.instantReplies = it }
                    SettingsToggle("الاهتزاز", "اهتزاز خفيف لما تبعت ولما تتنفس مع خطوة.", Prefs.haptics) { Prefs.haptics = it }
                }
            }
            Appear("settings-history", 210) {
                SettingsSection(R.drawable.ic_kh_history, Texts.HISTORY) {
                    // Off by default; turning it off deletes everything that was saved, so it asks first.
                    SettingsToggle(Texts.KEEP_HISTORY, Texts.KEEP_HISTORY_NOTE, Prefs.keepHistory) {
                        if (it) onKeepHistory(true) else confirmOff = true
                    }
                    AnimatedVisibility(Prefs.keepHistory, enter = fadeIn(tween(200)) + expandVertically(KhMotion.gentle()),
                        exit = fadeOut(tween(150)) + shrinkVertically(tween(220))) {
                        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                            KhButton("${Texts.HISTORY} ($savedCount)", onOpenHistory, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet,
                                icon = R.drawable.ic_kh_history)
                            SettingsToggle(Texts.USE_MEMORY, t(Texts.USE_MEMORY_NOTE), Prefs.useMemory, onUseMemory)
                            if (Prefs.useMemory) MemoryCard(memory, onClearMemory)
                        }
                    }
                }
            }
            Appear("settings-privacy", 240) {
                SettingsSection(R.drawable.ic_kh_shield_check, "الخصوصية") {
                    SettingsInfo(R.drawable.ic_kh_lock, "شن ينحفظ على تلفونك؟", if (Prefs.keepHistory) Texts.STORED_ON else Texts.STORED_OFF)
                    SettingsInfo(R.drawable.ic_kh_shield, "قائمة التطبيقات المفتوحة", "على أندرويد 13 وأحدث، خطوة يبان فيها فاضي من غير كلامك.")
                    Spacer(Modifier.height(4.dp))
                    KhButton("امسح المحادثة توا", { confirmErase = true }, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet,
                        icon = R.drawable.ic_kh_trash, enabled = canErase)
                }
            }
            Appear("settings-about", 300) {
                SettingsSection(R.drawable.ic_kh_info, "على خطوة") {
                    Text(t(Texts.CONSENT_INTRO), style = KhType.body, color = c.ink)
                    Text(Texts.CONSENT_AI, style = KhType.body, color = c.inkMuted)
                    Text(t(Texts.CONSENT_EMERGENCY), style = KhType.body, color = c.inkMuted)
                    Text("الإصدار ${ly.manara.khutwa.BuildConfig.VERSION_NAME} · نسخة تجريبية", style = KhType.small, color = c.inkMuted)
                }
            }
            Spacer(Modifier.height(16.dp))
        }
    }
    if (confirmErase) ConfirmNewChat(onConfirm = { confirmErase = false; onErase() }, onDismiss = { confirmErase = false },
        body = if (Prefs.keepHistory) Texts.ERASE_SAVED_BODY else Texts.NEW_CHAT_BODY)
    if (confirmOff) ConfirmDialog(Texts.KEEP_HISTORY_OFF_TITLE, Texts.KEEP_HISTORY_OFF_BODY, "إيه، اقفله وامسح", "لا، خليه",
        onConfirm = { confirmOff = false; onKeepHistory(false) }, onDismiss = { confirmOff = false })
}

/** Exactly what Khutwa remembers across chats, in plain words, with a way to wipe it. */
@Composable
private fun MemoryCard(memory: String, onClear: () -> Unit) {
    val c = Kh.colors
    Column(
        Modifier.fillMaxWidth().background(c.paper, KhShapes.card).dashedBorder(c.border, KhShapes.card).padding(12.dp),
        verticalArrangement = Arrangement.spacedBy(6.dp),
    ) {
        Text(Texts.MEMORY_LABEL, style = KhType.label, color = c.inkMuted)
        Text(memory.ifBlank { t(Texts.MEMORY_EMPTY) }, style = KhType.body, color = if (memory.isBlank()) c.inkMuted else c.ink)
        if (memory.isNotBlank()) KhButton(Texts.MEMORY_CLEAR, onClear, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet,
            icon = R.drawable.ic_kh_trash)
    }
}

/**
 * The top of a new chat: the small looping doodle and one short line for the time of day, like a friend saying hi.
 * Picked once per chat ([seed]); a returning user (saved chats on) gets a welcome back.
 */
@Composable
private fun WelcomeHeader(seed: Long, returning: Boolean) {
    val c = Kh.colors
    val line = remember(seed) {
        val pool = when (java.time.LocalTime.now().hour) {
            in 0..4 -> Texts.WELCOME_NIGHT
            in 5..11 -> Texts.WELCOME_MORNING
            in 12..16 -> Texts.WELCOME_DAY
            else -> Texts.WELCOME_EVENING
        }.let { it + Texts.WELCOME_SABR.shuffled(kotlin.random.Random(seed)).take(it.size) }
            .let { if (returning) it + Texts.WELCOME_BACK else it }
        pool[((seed * 2654435761L) ushr 7).mod(pool.size)]
    }
    Column(Modifier.fillMaxWidth().padding(top = 12.dp, bottom = 12.dp), horizontalAlignment = Alignment.CenterHorizontally) {
        WelcomeIllustration(Modifier.size(92.dp), sparkles = 30.dp)
        Spacer(Modifier.height(14.dp))
        Appear("welcome-line-$seed", delayMillis = 450) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Text(t(line), style = KhType.title.copy(fontSize = KhType.title.fontSize * 0.9f), color = c.ink,
                    textAlign = androidx.compose.ui.text.style.TextAlign.Center, modifier = Modifier.semantics { heading() })
                Spacer(Modifier.height(4.dp))
                Text(Texts.WELCOME_SUB, style = KhType.body, color = c.inkMuted, textAlign = androidx.compose.ui.text.style.TextAlign.Center)
            }
        }
    }
}

// ---------------------------------------------------------------- saved chats

@Composable
fun HistoryScreen(
    chats: List<ly.manara.khutwa.data.SavedChat>,
    currentId: Long?,
    onBack: () -> Unit,
    onUrgent: () -> Unit,
    onOpen: (Long) -> Unit,
    onDelete: (Long) -> Unit,
    onDeleteAll: () -> Unit,
) {
    val c = Kh.colors
    var deleting by remember { mutableStateOf<Long?>(null) }
    var deletingAll by remember { mutableStateOf(false) }
    Column(Modifier.fillMaxSize()) {
        TopBar(onUrgent, leading = { BackButton(onBack) })
        LazyColumn(
            Modifier.weight(1f).fillMaxWidth(),
            contentPadding = androidx.compose.foundation.layout.PaddingValues(start = Gutter, end = Gutter, bottom = 16.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp),
        ) {
            item(key = "title") {
                Appear("history-title") {
                    Column {
                        ScreenTitle(Texts.HISTORY)
                        Doodle(Doodles.UNDERLINE, c.green, Modifier.width(120.dp).height(12.dp), key = "history-underline",
                            delayMillis = 300, durationMillis = 650)
                        Spacer(Modifier.height(4.dp))
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            KhIcon(R.drawable.ic_kh_lock, c.inkMuted, size = 16.dp)
                            Spacer(Modifier.width(6.dp))
                            Text(Texts.HISTORY_NOTE, style = KhType.small, color = c.inkMuted)
                        }
                    }
                }
            }
            if (chats.isEmpty()) item(key = "empty") {
                Appear("history-empty", 80) {
                    Column(Modifier.fillMaxWidth().padding(top = 32.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Image(painterResource(R.drawable.ill_on_your_phone), contentDescription = null, modifier = Modifier.size(150.dp))
                        Spacer(Modifier.height(12.dp))
                        Text(t(Texts.HISTORY_EMPTY), style = KhType.body, color = c.inkMuted,
                            textAlign = androidx.compose.ui.text.style.TextAlign.Center)
                    }
                }
            }
            itemsIndexed(chats, key = { _, chat -> chat.id }) { i, chat ->
                Box(Modifier.animateItem()) {
                    Appear("history-${chat.id}", delayMillis = 40L * i.coerceAtMost(6)) {
                        SavedChatRow(chat, current = chat.id == currentId, onOpen = { onOpen(chat.id) }, onDelete = { deleting = chat.id })
                    }
                }
            }
            if (chats.isNotEmpty()) item(key = "delete-all") {
                KhButton(Texts.HISTORY_DELETE_ALL, { deletingAll = true }, Modifier.fillMaxWidth().padding(top = 8.dp),
                    kind = ButtonKind.Quiet, icon = R.drawable.ic_kh_trash)
            }
        }
    }
    deleting?.let { id ->
        ConfirmDialog(Texts.HISTORY_DELETE_TITLE, t(Texts.HISTORY_DELETE_BODY), "إيه، امسحها", "لا، خليها",
            onConfirm = { deleting = null; onDelete(id) }, onDismiss = { deleting = null })
    }
    if (deletingAll) ConfirmDialog(Texts.HISTORY_DELETE_ALL_TITLE, t(Texts.HISTORY_DELETE_ALL_BODY), "إيه، امسح الكل", "لا، خليهم",
        onConfirm = { deletingAll = false; onDeleteAll() }, onDismiss = { deletingAll = false })
}

@Composable
private fun SavedChatRow(chat: ly.manara.khutwa.data.SavedChat, current: Boolean, onOpen: () -> Unit, onDelete: () -> Unit) {
    val c = Kh.colors
    val preview = chat.lines.firstOrNull { it.mine }?.text.orEmpty()
    val stone = when ((chat.id / 1000 % 3).toInt()) { 0 -> c.clay; 1 -> c.sun; else -> c.green }
    Row(
        Modifier.fillMaxWidth().clip(KhShapes.card).background(if (current) c.greenSoft else c.paperRaised)
            .border(PenWidth, c.ink, KhShapes.card)
            .clickable(role = Role.Button, onClick = onOpen)
            .padding(start = 14.dp, top = 12.dp, bottom = 12.dp, end = 4.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Stone(stone, if (chat.id % 2 == 0L) -8f else 10f)
        Spacer(Modifier.width(12.dp))
        Column(Modifier.weight(1f)) {
            Text(whenLabel(chat.updatedAt) + if (current) " · ${Texts.HISTORY_OPEN_NOW}" else "", style = KhType.small, color = c.inkMuted)
            Text(preview, style = KhType.body, color = c.ink, maxLines = 2, overflow = androidx.compose.ui.text.style.TextOverflow.Ellipsis)
        }
        Box(
            Modifier.size(44.dp).clip(KhShapes.chip).clickable(role = Role.Button, onClick = onDelete)
                .semantics { contentDescription = "امسح المحادثة" },
            contentAlignment = Alignment.Center,
        ) { KhIcon(R.drawable.ic_kh_trash, c.inkMuted, size = 20.dp) }
    }
}

/** «اليوم 18:40», «امبارح 09:05», or «3/10 21:15», with Western digits like the rest of the app. */
private fun whenLabel(millis: Long): String {
    val zone = java.time.ZoneId.systemDefault()
    val t = java.time.Instant.ofEpochMilli(millis).atZone(zone)
    val today = java.time.LocalDate.now(zone)
    val time = String.format(java.util.Locale.US, "%d:%02d", t.hour, t.minute)
    return when (t.toLocalDate()) {
        today -> "اليوم $time"
        today.minusDays(1) -> "امبارح $time"
        else -> "${t.dayOfMonth}/${t.monthValue} $time"
    }
}

@Composable
private fun SettingsSection(icon: Int, title: String, content: @Composable androidx.compose.foundation.layout.ColumnScope.() -> Unit) {
    val c = Kh.colors
    Column(
        Modifier.fillMaxWidth().background(c.paperRaised, KhShapes.card).border(PenWidth, c.ink, KhShapes.card).padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.semantics { heading() }) {
            Box(Modifier.size(32.dp).background(c.greenSoft, KhShapes.chip), contentAlignment = Alignment.Center) {
                KhIcon(icon, c.greenDeep, size = 18.dp)
            }
            Spacer(Modifier.width(10.dp))
            Text(title, style = KhType.heading, color = c.ink)
        }
        content()
    }
}

@Composable private fun SettingsLabel(text: String) = Text(text, style = KhType.label, color = Kh.colors.inkMuted)

@Composable private fun SettingsNote(text: String) = Text(text, style = KhType.small, color = Kh.colors.inkMuted)

@Composable
private fun SettingsInfo(icon: Int, title: String, body: String) {
    val c = Kh.colors
    Row(Modifier.fillMaxWidth().padding(vertical = 4.dp).semantics(mergeDescendants = true) {}, verticalAlignment = Alignment.Top) {
        KhIcon(icon, c.inkMuted, size = 18.dp, modifier = Modifier.padding(top = 3.dp))
        Spacer(Modifier.width(10.dp))
        Column(Modifier.weight(1f)) {
            Text(title, style = KhType.label, color = c.ink)
            Text(body, style = KhType.small, color = c.inkMuted)
        }
    }
}

/** A row of choices drawn as pebbles; the chosen one fills green and gets a pen tick. */
@Composable
private fun <T> ChoiceRow(options: List<Pair<T, String>>, selected: T, onSelect: (T) -> Unit) {
    val c = Kh.colors
    val haptics = LocalHapticFeedback.current
    Row(Modifier.horizontalScroll(rememberScrollState()), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        options.forEach { (value, label) ->
            val on = value == selected
            val bg by animateColorAsState(if (on) c.green else c.paper, tween(200), label = "choiceBg")
            val edge by animateColorAsState(if (on) c.ink else c.border, tween(200), label = "choiceEdge")
            Row(
                Modifier.minimumInteractiveComponentSize()
                    .background(bg, KhShapes.chip).border(1.5.dp, edge, KhShapes.chip)
                    .clickable(role = Role.RadioButton) {
                        if (!on) { haptics.performHapticFeedback(HapticFeedbackType.TextHandleMove); onSelect(value) }
                    }
                    .semantics { this.selected = on }
                    .padding(horizontal = 14.dp, vertical = 7.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                if (on) {
                    Doodle(Doodles.TICK, c.onGreen, Modifier.size(14.dp), key = "choice-$label", durationMillis = 320, mirrorInRtl = false)
                    Spacer(Modifier.width(6.dp))
                }
                Text(label, style = KhType.label, color = if (on) c.onGreen else c.ink)
            }
        }
    }
}

/** A switch in the brand style: a pebble that rolls along an outlined track. */
@Composable
private fun SettingsToggle(title: String, body: String, checked: Boolean, onChange: (Boolean) -> Unit) {
    val c = Kh.colors
    val haptics = LocalHapticFeedback.current
    val x by animateFloatAsState(if (checked) 1f else 0f, KhMotion.snappy(), label = "toggle")
    val track by animateColorAsState(if (checked) c.green else c.paperSunk, tween(200), label = "track")
    Row(
        Modifier.fillMaxWidth().clip(KhShapes.card)
            .toggleable(value = checked, role = Role.Switch) { haptics.performHapticFeedback(HapticFeedbackType.TextHandleMove); onChange(it) }
            .padding(horizontal = 8.dp, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Column(Modifier.weight(1f)) {
            Text(title, style = KhType.label, color = c.ink)
            Text(body, style = KhType.small, color = c.inkMuted)
        }
        Spacer(Modifier.width(12.dp))
        Box(Modifier.size(width = 54.dp, height = 32.dp).background(track, KhShapes.chip).border(PenWidth, c.ink, KhShapes.chip)) {
            // in right-to-left, "on" sits at the left end
            Box(Modifier.align(Alignment.CenterStart).offset(x = (4 + 22 * x).dp).size(22.dp)
                .background(if (checked) c.paperRaised else c.paper, KhShapes.chip).border(PenWidth, c.ink, KhShapes.chip))
        }
    }
}
