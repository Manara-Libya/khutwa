package ly.manara.khutwa.ui.components

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateMapOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay
import ly.manara.khutwa.R
import ly.manara.khutwa.data.A2ui
import ly.manara.khutwa.ui.theme.Kh
import ly.manara.khutwa.ui.theme.KhShapes
import ly.manara.khutwa.ui.theme.KhType

/**
 * Renders an A2UI v0.8 surface with the Khutwa design system. The draft fields are bound to the surface's
 * data model, so the buttons always act on what the user edited. Actions stay on the phone:
 * khutwa.share opens the share sheet (the user sends it), khutwa.copy copies. Nothing is sent automatically.
 */
@Composable
fun A2uiView(surface: A2ui.Surface, modifier: Modifier = Modifier) {
    val data = remember(surface.id) { mutableStateMapOf<String, String>().apply { putAll(surface.data) } }
    Column(modifier.fillMaxWidth()) {
        Node(surface, surface.root, data, cardIndex = 0)
    }
}

@Composable
private fun Node(surface: A2ui.Surface, id: String, data: MutableMap<String, String>, cardIndex: Int) {
    val c = Kh.colors
    when (val comp = surface.components[id]) {
        is A2ui.Text -> when (comp.hint) {
            "h1", "h2", "h3" -> Text(comp.text, style = KhType.heading.copy(fontSize = KhType.title.fontSize.times(0.8f)),
                color = c.ink, modifier = Modifier.semantics { heading() })
            "h4", "h5" -> Text(comp.text, style = KhType.heading, color = c.ink)
            "caption" -> Text(comp.text, style = KhType.small, color = c.inkMuted)
            else -> Text(comp.text, style = KhType.body, color = c.inkMuted)
        }
        is A2ui.Column -> {
            var cards = 0
            Column(Modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                comp.children.forEachIndexed { i, child ->
                    val isCard = surface.components[child] is A2ui.Card
                    val index = if (isCard) cards++ else cardIndex
                    if (id == surface.root) Appear("${surface.id}/$child", delayMillis = 90L * i) { Node(surface, child, data, index) }
                    else Node(surface, child, data, index)
                }
            }
        }
        is A2ui.Row -> Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp),
            verticalAlignment = Alignment.CenterVertically) {
            comp.children.forEach { child ->
                val b = surface.components[child] as? A2ui.Button
                if (b != null && !b.primary) ActionButton(surface, b, data, compact = true)
                else Column(Modifier.weight(1f)) { Node(surface, child, data, cardIndex) }
            }
        }
        is A2ui.Card -> {
            val (stone, rot) = when (cardIndex % 3) { 0 -> c.clay to -12f; 1 -> c.sun to 10f; else -> c.green to -6f }
            Row(
                Modifier.fillMaxWidth()
                    .background(c.paperRaised, KhShapes.card)
                    .border(PenWidth, c.ink, KhShapes.card)
                    .padding(16.dp),
                verticalAlignment = Alignment.Top,
            ) {
                Stone(stone, rot, Modifier.padding(top = 2.dp))
                Spacer(Modifier.width(12.dp))
                Column(Modifier.weight(1f)) { Node(surface, comp.child, data, cardIndex) }
            }
        }
        is A2ui.TextField -> {
            Text(comp.label, style = KhType.label, color = c.inkMuted)
            BasicTextField(
                value = data[comp.path].orEmpty(),
                onValueChange = { data[comp.path] = it },
                textStyle = KhType.bubble.copy(color = c.onGreen),
                cursorBrush = SolidColor(c.onGreen),
                modifier = Modifier.fillMaxWidth().heightIn(min = 72.dp)
                    .background(c.green, KhShapes.bubbleMe)
                    .border(PenWidth, c.onGreen, KhShapes.bubbleMe)
                    .padding(horizontal = 14.dp, vertical = 10.dp)
                    .semantics { contentDescription = comp.label },
            )
        }
        is A2ui.Button -> ActionButton(surface, comp, data)
        null -> Unit  // unknown or unsupported component: skipped
    }
}

@Composable
private fun ActionButton(surface: A2ui.Surface, b: A2ui.Button, data: Map<String, String>, compact: Boolean = false) {
    val context = LocalContext.current
    val label = (surface.components[b.child] as? A2ui.Text)?.text.orEmpty()
    var done by remember { mutableStateOf(false) }
    LaunchedEffect(done) { if (done) { delay(1600); done = false } }
    val text = b.textPath?.let { data[it] }.orEmpty()
    if (compact) {
        // A secondary action next to the primary one: an outlined round icon button with its label for screen readers.
        val c = Kh.colors
        val icon = when { b.action == "khutwa.copy" && done -> R.drawable.ic_kh_check; b.action == "khutwa.copy" -> R.drawable.ic_kh_copy
            else -> R.drawable.ic_kh_share }
        androidx.compose.foundation.layout.Box(
            Modifier.size(52.dp)
                .background(if (done) c.greenSoft else c.paperRaised, KhShapes.chip)
                .border(PenWidth, c.ink, KhShapes.chip)
                .clickable(enabled = text.isNotBlank(), role = Role.Button) {
                    if (b.action == "khutwa.copy") { copyText(context, text); done = true } else if (b.action == "khutwa.share") shareText(context, text)
                }
                .semantics { contentDescription = if (done) "تنسخت" else label },
            contentAlignment = Alignment.Center,
        ) { KhIcon(icon, c.ink, size = 22.dp) }
        return
    }
    when (b.action) {
        "khutwa.share" -> KhButton(label, { shareText(context, text) }, Modifier.fillMaxWidth(),
            kind = if (b.primary) ButtonKind.Primary else ButtonKind.Quiet, icon = R.drawable.ic_kh_share, enabled = text.isNotBlank())
        "khutwa.copy" -> KhButton(if (done) "تنسخت" else label, { copyText(context, text); done = true }, Modifier.fillMaxWidth(),
            kind = if (b.primary) ButtonKind.Primary else ButtonKind.Quiet,
            icon = if (done) R.drawable.ic_kh_check else R.drawable.ic_kh_copy, enabled = text.isNotBlank())
        else -> Unit  // only phone-side actions are allowed; anything else is ignored
    }
}

fun shareText(context: Context, text: String) {
    val send = Intent(Intent.ACTION_SEND).setType("text/plain").putExtra(Intent.EXTRA_TEXT, text)
    context.startActivity(Intent.createChooser(send, null).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
}

fun copyText(context: Context, text: String) {
    val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    cm.setPrimaryClip(ClipData.newPlainText("خطوة", text))
}
