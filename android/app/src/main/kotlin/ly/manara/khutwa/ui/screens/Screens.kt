package ly.manara.khutwa.ui.screens

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import androidx.compose.foundation.Image
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
import ly.manara.khutwa.ui.components.Bubble
import ly.manara.khutwa.ui.components.ButtonKind
import ly.manara.khutwa.ui.components.KhButton
import ly.manara.khutwa.ui.components.KhIcon
import ly.manara.khutwa.ui.components.Note
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
            Image(painterResource(R.drawable.ill_scene_private), contentDescription = null,
                modifier = Modifier.size(180.dp).align(Alignment.CenterHorizontally))
            ScreenTitle(Texts.CONSENT_TITLE)
            Spacer(Modifier.height(8.dp))
            Text(Texts.CONSENT_INTRO, style = KhType.body, color = c.inkMuted)
            Spacer(Modifier.height(20.dp))
            ConsentPoint(R.drawable.ic_kh_sparkle, Texts.CONSENT_AI)
            ConsentPoint(R.drawable.ic_kh_shield_check, Texts.CONSENT_REDACTION)
            ConsentPoint(R.drawable.ic_kh_info, Texts.CONSENT_GOOGLE)
            ConsentPoint(R.drawable.ic_kh_lock, Texts.CONSENT_SERVER)
            ConsentPoint(R.drawable.ic_kh_urgent, Texts.CONSENT_EMERGENCY, urgent = true)
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
    onOptions: () -> Unit,
    onNewChat: () -> Unit,
    onUrgent: () -> Unit,
    onRevealed: (Long) -> Unit = {},
) {
    val c = Kh.colors
    val list = rememberLazyListState()
    val scope = rememberCoroutineScope()
    val extra = (if (state.waiting) 1 else 0) + (if (state.failed) 1 else 0) + (if (state.supportReady && !state.waiting) 1 else 0)
    LaunchedEffect(state.lines.size, state.waiting, state.failed, state.supportReady) {
        list.animateScrollToItem((state.lines.size + extra - 1).coerceAtLeast(0))
    }
    Column(Modifier.fillMaxSize().imePadding()) {
        TopBar(onUrgent)
        LazyColumn(
            Modifier.weight(1f).fillMaxWidth(),
            state = list,
            contentPadding = androidx.compose.foundation.layout.PaddingValues(horizontal = Gutter, vertical = 8.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            itemsIndexed(state.lines, key = { _, l -> l.id }) { _, line: Line ->
                Bubble(line.text, line.mine, reveal = line.reveal, onRevealed = { onRevealed(line.id) },
                    onGrow = { scope.launch { list.animateScrollToItem((list.layoutInfo.totalItemsCount - 1).coerceAtLeast(0)) } })
            }
            if (state.waiting) item { Typing() }
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
            if (state.supportReady && !state.waiting) item {
                Column(
                    Modifier.fillMaxWidth().background(c.claySoft, KhShapes.card).border(PenWidth, c.ink, KhShapes.card).padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(10.dp),
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        KhIcon(R.drawable.ic_kh_users, c.ink, size = 22.dp)
                        Spacer(Modifier.width(10.dp))
                        Text("لما تكون جاهز، فيه ناس ممكن يسمعوك.", style = KhType.bodyStrong, color = c.ink)
                    }
                    KhButton(Texts.SEE_OPTIONS, onOptions, Modifier.fillMaxWidth())
                }
            }
        }
        Composer(state, onSend, onWhoToTalk, onNewChat)
    }
}

@Composable
private fun Composer(state: UiState, onSend: (String) -> Unit, onWhoToTalk: () -> Unit, onNewChat: () -> Unit) {
    val c = Kh.colors
    var text by rememberSaveable { mutableStateOf("") }
    Column(Modifier.fillMaxWidth().background(c.paper).padding(horizontal = 16.dp, vertical = 8.dp)) {
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.padding(bottom = 8.dp)) {
            if (!state.supportReady) Chip(Texts.WHO_TO_TALK, onWhoToTalk, enabled = !state.waiting)
            if (state.lines.size > 1) Chip(Texts.NEW_CHAT, onNewChat, enabled = !state.waiting)
        }
        Row(verticalAlignment = Alignment.Bottom) {
            BasicTextField(
                value = text,
                onValueChange = { text = it },
                textStyle = KhType.bubble.copy(color = c.ink),
                cursorBrush = SolidColor(c.ink),
                keyboardOptions = KeyboardOptions(capitalization = KeyboardCapitalization.Sentences, imeAction = ImeAction.Default),
                modifier = Modifier
                    .weight(1f)
                    .heightIn(min = 52.dp, max = 140.dp)
                    .background(c.paperRaised, KhShapes.field)
                    .border(PenWidth, c.border, KhShapes.field)
                    .padding(horizontal = 16.dp, vertical = 12.dp)
                    .semantics { contentDescription = "اكتب رسالتك" },
                decorationBox = { inner ->
                    Box {
                        if (text.isEmpty()) Text(Texts.COMPOSER_HINT, style = KhType.bubble, color = c.inkMuted)
                        inner()
                    }
                },
            )
            Spacer(Modifier.width(10.dp))
            val canSend = text.isNotBlank() && !state.waiting
            Box(
                Modifier.size(52.dp)
                    .background(if (canSend) c.green else c.paperSunk, KhShapes.chip)
                    .border(PenWidth, if (canSend) c.onGreen else c.border, KhShapes.chip)
                    .clickable(enabled = canSend, role = Role.Button) { onSend(text); text = "" }
                    .semantics { contentDescription = "ابعت" },
                contentAlignment = Alignment.Center,
            ) {
                // send points left in a right-to-left layout
                KhIcon(R.drawable.ic_kh_send, if (canSend) c.onGreen else c.inkMuted,
                    Modifier.graphicsMirror(), size = 22.dp)
            }
        }
        Row(Modifier.padding(top = 8.dp), verticalAlignment = Alignment.CenterVertically) {
            KhIcon(R.drawable.ic_kh_shield_check, c.greenDeep, size = 16.dp)
            Spacer(Modifier.width(6.dp))
            Text(Texts.PRIVACY_LINE, style = KhType.small, color = c.inkMuted)
        }
    }
}

private fun Modifier.graphicsMirror(): Modifier = this.graphicsLayer(scaleX = -1f)

@Composable
private fun Chip(text: String, onClick: () -> Unit, enabled: Boolean) {
    val c = Kh.colors
    Text(
        text,
        style = KhType.label,
        color = if (enabled) c.ink else c.inkMuted,
        modifier = Modifier
            .background(c.paperRaised, KhShapes.chip)
            .border(1.5.dp, c.border, KhShapes.chip)
            .clickable(enabled = enabled, role = Role.Button, onClick = onClick)
            .padding(horizontal = 14.dp, vertical = 7.dp),
    )
}

// ---------------------------------------------------------------- support options

@Composable
fun OptionsScreen(options: List<Option>, onChoose: (Option) -> Unit, onBack: () -> Unit, onUrgent: () -> Unit) {
    val c = Kh.colors
    Column(Modifier.fillMaxSize()) {
        TopBar(onUrgent) { BackButton(onBack) }
        Column(Modifier.weight(1f).verticalScroll(rememberScrollState()).padding(horizontal = Gutter),
            verticalArrangement = Arrangement.spacedBy(14.dp)) {
            Image(painterResource(R.drawable.ill_together), contentDescription = null,
                modifier = Modifier.size(150.dp).align(Alignment.CenterHorizontally))
            ScreenTitle(Texts.OPTIONS_TITLE)
            Text(Texts.OPTIONS_SUB, style = KhType.body, color = c.inkMuted)
            options.forEachIndexed { i, o ->
                SupportCard(Texts.TYPE_LABELS[o.type] ?: o.type, o.why, i, onClick = { onChoose(o) })
            }
            Spacer(Modifier.height(12.dp))
        }
    }
}

// ---------------------------------------------------------------- draft

@Composable
fun DraftScreen(option: Option, onBack: () -> Unit, onUrgent: () -> Unit) {
    val c = Kh.colors
    val context = LocalContext.current
    var text by rememberSaveable(option) { mutableStateOf(option.draft) }
    var copied by remember { mutableStateOf(false) }
    LaunchedEffect(copied) { if (copied) { delay(1800); copied = false } }
    Column(Modifier.fillMaxSize().imePadding()) {
        TopBar(onUrgent) { BackButton(onBack) }
        Column(Modifier.weight(1f).verticalScroll(rememberScrollState()).padding(horizontal = Gutter),
            verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Image(painterResource(R.drawable.ill_letter), contentDescription = null,
                modifier = Modifier.size(140.dp).align(Alignment.CenterHorizontally))
            ScreenTitle("${Texts.DRAFT_TITLE} لـ${Texts.TYPE_LABELS[option.type] ?: ""}")
            Text(Texts.DRAFT_SUB, style = KhType.body, color = c.inkMuted)
            BasicTextField(
                value = text,
                onValueChange = { text = it },
                textStyle = KhType.bubble.copy(color = c.onGreen),
                cursorBrush = SolidColor(c.onGreen),
                modifier = Modifier.fillMaxWidth().heightIn(min = 120.dp)
                    .background(c.green, KhShapes.bubbleMe).border(PenWidth, c.onGreen, KhShapes.bubbleMe)
                    .padding(18.dp)
                    .semantics { contentDescription = "الرسالة" },
            )
            Note(Texts.DRAFT_NOTE, R.drawable.ic_kh_lock, c.paperSunk)
        }
        Column(Modifier.padding(horizontal = Gutter, vertical = 12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            KhButton(Texts.DRAFT_SHARE, { share(context, text) }, Modifier.fillMaxWidth(), icon = R.drawable.ic_kh_share)
            KhButton(if (copied) Texts.DRAFT_COPIED else Texts.DRAFT_COPY, { copy(context, text); copied = true },
                Modifier.fillMaxWidth(), kind = ButtonKind.Quiet, icon = if (copied) R.drawable.ic_kh_check else R.drawable.ic_kh_copy)
        }
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
            Step(1, Texts.URGENT_STEP_PERSON)
            Step(2, Texts.URGENT_STEP_HOSPITAL)
            Step(3, Texts.URGENT_STEP_SAFE)
            Note(Texts.URGENT_NO_CONTACTS, R.drawable.ic_kh_info, c.sunSoft)
            Column(
                Modifier.fillMaxWidth().background(c.claySoft, KhShapes.card).border(PenWidth, c.ink, KhShapes.card).padding(18.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                Text(Texts.URGENT_MESSAGE_TITLE, style = KhType.heading, color = c.ink)
                Text(Texts.URGENT_MESSAGE_TEXT, style = KhType.bubble, color = c.onGreen,
                    modifier = Modifier.fillMaxWidth().background(c.green, KhShapes.bubbleMe).border(PenWidth, c.onGreen, KhShapes.bubbleMe).padding(14.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                    KhButton(Texts.URGENT_SHARE, { share(context, Texts.URGENT_MESSAGE_TEXT) }, Modifier.weight(1f), icon = R.drawable.ic_kh_share)
                    KhButton(if (copied) Texts.DRAFT_COPIED else Texts.URGENT_COPY, { copy(context, Texts.URGENT_MESSAGE_TEXT); copied = true },
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

// ---------------------------------------------------------------- helpers

private fun share(context: Context, text: String) {
    val send = Intent(Intent.ACTION_SEND).setType("text/plain").putExtra(Intent.EXTRA_TEXT, text)
    context.startActivity(Intent.createChooser(send, null).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
}

private fun copy(context: Context, text: String) {
    val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    cm.setPrimaryClip(ClipData.newPlainText("خطوة", text))
}
