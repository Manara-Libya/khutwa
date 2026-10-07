package ly.manara.khutwa.ui.screens

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import androidx.compose.foundation.Image
import androidx.compose.animation.animateColorAsState
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
    Column(Modifier.fillMaxSize()) {
        TopBar(onUrgent)
        Column(Modifier.weight(1f).verticalScroll(rememberScrollState()).padding(horizontal = Gutter)) {
            // A staged entrance: illustration, title, then each point a beat after the previous one.
            Appear("consent-ill") {
                Box(Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                    Image(painterResource(R.drawable.ill_scene_private), contentDescription = null, modifier = Modifier.size(180.dp))
                }
            }
            Appear("consent-title", 80) {
                Column {
                    ScreenTitle(Texts.CONSENT_TITLE)
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
            KhButton(Texts.CONSENT_DECLINE, onDecline, Modifier.fillMaxWidth(), kind = ButtonKind.Quiet)
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
        TopBar(onUrgent)
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
                Image(painterResource(R.drawable.ill_listen), contentDescription = null,
                    modifier = Modifier.fillMaxWidth().height(150.dp).padding(bottom = 4.dp))
            }
            itemsIndexed(state.lines, key = { _, l -> l.id }) { index, line: Line ->
                Box(Modifier.animateItem(fadeInSpec = null, fadeOutSpec = null)) {
                    Appear(line.id) {
                        val surface = line.surface
                        when {
                            surface != null -> A2uiView(surface)
                            line.loadingSurface -> OptionsPlaceholder()
                            else -> Bubble(line.text, line.mine, reveal = line.reveal, onRevealed = { onRevealed(line.id) },
                                onGrow = { scope.launch { keepInView(list, index + 1) } })
                        }
                    }
                }
            }
            if (state.waiting) item(key = "typing") { Box(Modifier.animateItem()) { Appear("typing-${state.lines.size}") { Typing() } } }
            if (state.failed) item {
                Column(
                    Modifier.fillMaxWidth().background(c.sunSoft, KhShapes.card).border(PenWidth, c.ink, KhShapes.card).padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(10.dp),
                ) {
                    Text(Texts.ERROR_NETWORK, style = KhType.body, color = c.ink)
                    Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        KhButton(Texts.RETRY, onRetry, Modifier.weight(1f), kind = ButtonKind.Quiet, icon = R.drawable.ic_kh_refresh)
                        KhButton("نحتاج مساعدة", onUrgent, Modifier.weight(1f), kind = ButtonKind.Urgent)
                    }
                }
            }
        }
        Composer(state, onSend, onWhoToTalk, onNewChat,
            Modifier.align(Alignment.BottomCenter).onSizeChanged { composerHeight = it.height })
        }
    }
}

@Composable
private fun Composer(
    state: UiState,
    onSend: (String) -> Unit,
    onWhoToTalk: () -> Unit,
    onNewChat: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val c = Kh.colors
    val haptics = LocalHapticFeedback.current
    var text by rememberSaveable { mutableStateOf("") }
    // No bar behind it: each control carries its own outlined shape, so the composer floats.
    Column(modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp)) {
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.padding(bottom = 8.dp)) {
            if (!state.supportReady) Chip(Texts.WHO_TO_TALK, onWhoToTalk, enabled = !state.waiting)
            if (state.lines.size > 1) Chip(Texts.NEW_CHAT, onNewChat, enabled = !state.waiting)
        }
        Row(verticalAlignment = Alignment.Bottom) {
            Box(Modifier.weight(1f).padding(end = 3.dp, bottom = 4.dp)) {
            // the brand's hard print shadow lifts the field off the conversation
            Box(Modifier.matchParentSize().absoluteOffset(3.dp, 4.dp).background(c.shadow.copy(alpha = if (c.isDark) 1f else 0.9f), KhShapes.field))
            BasicTextField(
                value = text,
                onValueChange = { text = it },
                textStyle = KhType.bubble.copy(color = c.ink),
                cursorBrush = SolidColor(c.ink),
                keyboardOptions = KeyboardOptions(capitalization = KeyboardCapitalization.Sentences, imeAction = ImeAction.Default),
                modifier = Modifier
                    .fillMaxWidth()
                    .heightIn(min = 52.dp, max = 140.dp)
                    .background(c.paperRaised, KhShapes.field)
                    .border(PenWidth, c.ink, KhShapes.field)
                    .padding(horizontal = 16.dp, vertical = 12.dp)
                    .semantics { contentDescription = "اكتب رسالتك" },
                decorationBox = { inner ->
                    Box {
                        if (text.isEmpty()) Text(Texts.COMPOSER_HINT, style = KhType.bubble, color = c.inkMuted)
                        inner()
                    }
                },
            )
            }
            Spacer(Modifier.width(10.dp))
            val canSend = text.isNotBlank() && !state.waiting
            val sendBg by animateColorAsState(if (canSend) c.green else c.paperSunk, tween(220), label = "sendBg")
            val sendEdge by animateColorAsState(if (canSend) c.onGreen else c.border, tween(220), label = "sendEdge")
            val sendScale by animateFloatAsState(if (canSend) 1f else 0.92f, KhMotion.snappy(), label = "sendScale")
            Box(
                Modifier.size(52.dp)
                    .graphicsLayer { scaleX = sendScale; scaleY = sendScale }
                    .background(sendBg, KhShapes.chip)
                    .border(PenWidth, sendEdge, KhShapes.chip)
                    .clickable(enabled = canSend, role = Role.Button) {
                        haptics.performHapticFeedback(HapticFeedbackType.TextHandleMove)
                        onSend(text); text = ""
                    }
                    .semantics { contentDescription = "ابعت" },
                contentAlignment = Alignment.Center,
            ) {
                // send points left in a right-to-left layout
                KhIcon(R.drawable.ic_kh_send, if (canSend) c.onGreen else c.inkMuted,
                    Modifier.graphicsMirror(), size = 22.dp)
            }
        }
        Row(
            Modifier.padding(top = 8.dp).background(c.paperRaised.copy(alpha = 0.92f), KhShapes.chip)
                .padding(horizontal = 10.dp, vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            KhIcon(R.drawable.ic_kh_shield_check, c.greenDeep, size = 16.dp)
            Spacer(Modifier.width(6.dp))
            Text(Texts.PRIVACY_LINE, style = KhType.small, color = c.inkMuted)
        }
    }
}

private fun Modifier.graphicsMirror(): Modifier = this.graphicsLayer(scaleX = -1f)

/** While a reply types itself out, keep its bottom edge on screen without jumping past it. */
private suspend fun keepInView(list: androidx.compose.foundation.lazy.LazyListState, index: Int) {
    val info = list.layoutInfo
    val item = info.visibleItemsInfo.firstOrNull { it.index == index } ?: return list.animateScrollToItem(index)
    val overflow = item.offset + item.size - info.viewportEndOffset + 24
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
private fun Chip(text: String, onClick: () -> Unit, enabled: Boolean) {
    val c = Kh.colors
    val source = remember { MutableInteractionSource() }
    val pressed by source.collectIsPressedAsState()
    val scale by animateFloatAsState(if (pressed) 0.95f else 1f, KhMotion.snappy(), label = "chip")
    Text(
        text,
        style = KhType.label,
        color = if (enabled) c.ink else c.inkMuted,
        modifier = Modifier
            .graphicsLayer { scaleX = scale; scaleY = scale }
            .background(c.paperRaised, KhShapes.chip)
            .border(1.5.dp, c.border, KhShapes.chip)
            .clickable(interactionSource = source, indication = null, enabled = enabled, role = Role.Button, onClick = onClick)
            .padding(horizontal = 14.dp, vertical = 7.dp),
    )
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
                Appear("urgent-step-$i-$auto", 120L + 80L * i) { Step(i + 1, step) }
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
            CopingCard(R.drawable.ill_breathe, Texts.CARD_BREATH_TITLE, Texts.CARD_BREATH_BODY)
            CopingCard(R.drawable.ill_stones_three, Texts.CARD_GROUND_TITLE, Texts.CARD_GROUND_BODY)
            Text(Texts.URGENT_FOOTER, style = KhType.small, color = c.inkMuted, modifier = Modifier.padding(vertical = 12.dp))
        }
    }
}

@Composable
private fun Step(n: Int, text: String) {
    val c = Kh.colors
    Row(
        Modifier.fillMaxWidth().background(c.paperRaised, KhShapes.card).border(PenWidth, c.ink, KhShapes.card).padding(16.dp),
        verticalAlignment = Alignment.Top,
    ) {
        Box(Modifier.size(34.dp).background(c.urgent, KhShapes.chip), contentAlignment = Alignment.Center) {
            Text(n.toString(), style = KhType.button, color = c.onUrgent)
        }
        Spacer(Modifier.width(12.dp))
        Text(text, style = KhType.body, color = c.ink, modifier = Modifier.weight(1f))
    }
}

@Composable
private fun CopingCard(image: Int, title: String, body: String) {
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
        }
    }
}

