package ly.manara.khutwa.ui.components

import androidx.compose.ui.draw.clip
import androidx.annotation.DrawableRes
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.absoluteOffset
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.setValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay
import ly.manara.khutwa.R
import ly.manara.khutwa.ui.theme.Kh
import ly.manara.khutwa.ui.theme.KhShapes
import ly.manara.khutwa.ui.theme.KhType

/** The pen line of buttons, cards and bubbles (stroke-hand). */
val PenWidth = 2.dp

@Composable
fun KhIcon(@DrawableRes id: Int, tint: Color, modifier: Modifier = Modifier, size: Dp = 22.dp) {
    Icon(painterResource(id), contentDescription = null, tint = tint, modifier = modifier.size(size))
}

enum class ButtonKind { Primary, Quiet, Urgent }

/**
 * The Khutwa button: a hand-drawn pill. Primary and urgent buttons carry the hard "print" shadow
 * (3 x 4 dp, no blur) and press down into it.
 */
@Composable
fun KhButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    kind: ButtonKind = ButtonKind.Primary,
    @DrawableRes icon: Int? = null,
    enabled: Boolean = true,
) {
    val c = Kh.colors
    val source = remember { MutableInteractionSource() }
    val pressed by source.collectIsPressedAsState()
    val (bg, fg, edge) = when {
        !enabled -> Triple(c.paperSunk, c.inkMuted, c.border)
        kind == ButtonKind.Primary -> Triple(c.green, c.onGreen, c.onGreen)
        kind == ButtonKind.Urgent -> Triple(c.urgent, c.onUrgent, c.urgent)
        else -> Triple(c.paperRaised, c.ink, c.ink)
    }
    val shadow = enabled && kind != ButtonKind.Quiet
    val scale by animateFloatAsState(if (pressed) 0.97f else 1f, KhMotion.snappy(), label = "press")
    Box(modifier.graphicsLayer { scaleX = scale; scaleY = scale }
        .padding(end = if (shadow) 3.dp else 0.dp, bottom = if (shadow) 4.dp else 0.dp)) {
        if (shadow && !pressed) {
            Box(Modifier.matchParentSize().absoluteOffset(3.dp, 4.dp).background(c.shadow, KhShapes.pill))
        }
        Row(
            Modifier
                .absoluteOffset(if (pressed && shadow) 3.dp else 0.dp, if (pressed && shadow) 4.dp else 0.dp)
                .defaultMinSize(minHeight = 52.dp)
                .fillMaxWidth()
                .background(bg, KhShapes.pill)
                .border(PenWidth, edge, KhShapes.pill)
                .clickable(interactionSource = source, indication = null, enabled = enabled, role = Role.Button, onClick = onClick)
                .padding(horizontal = 22.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center,
        ) {
            if (icon != null) {
                KhIcon(icon, fg, size = 20.dp)
                Spacer(Modifier.width(8.dp))
            }
            Text(text, style = KhType.button, color = fg, textAlign = TextAlign.Center)
        }
    }
}

/** The "I need urgent help now" control: in the top bar of every screen, never hidden. */
@Composable
fun UrgentPill(onClick: () -> Unit) {
    val c = Kh.colors
    val haptics = androidx.compose.ui.platform.LocalHapticFeedback.current
    Row(
        Modifier
            .background(c.urgent, KhShapes.chip)
            .clickable(role = Role.Button) {
                haptics.performHapticFeedback(androidx.compose.ui.hapticfeedback.HapticFeedbackType.LongPress)
                onClick()
            }
            .semantics { contentDescription = "نحتاج مساعدة توا" }
            .padding(horizontal = 14.dp, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        KhIcon(R.drawable.ic_kh_urgent, c.onUrgent, size = 18.dp)
        Spacer(Modifier.width(6.dp))
        Text("نحتاج مساعدة توا", style = KhType.label, color = c.onUrgent)
    }
}

@Composable
fun TopBar(onUrgent: () -> Unit, modifier: Modifier = Modifier, onSettings: (() -> Unit)? = null, onHistory: (() -> Unit)? = null,
           leading: @Composable RowScope.() -> Unit = {}) {
    val c = Kh.colors
    Row(
        modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        leading()
        // Settings sit at the start edge, where Arabic apps keep their menu, well away from the urgent button.
        if (onSettings != null) {
            Box(
                Modifier.size(44.dp).clip(KhShapes.chip).clickable(role = Role.Button, onClick = onSettings)
                    .semantics { contentDescription = ly.manara.khutwa.data.Texts.SETTINGS },
                contentAlignment = Alignment.Center,
            ) { KhIcon(R.drawable.ic_kh_sliders, c.ink, size = 22.dp) }
            Spacer(Modifier.width(if (onHistory != null) 2.dp else 6.dp))
        }
        // Saved chats, only for users who turned them on.
        if (onHistory != null) {
            Box(
                Modifier.size(44.dp).clip(KhShapes.chip).clickable(role = Role.Button, onClick = onHistory)
                    .semantics { contentDescription = ly.manara.khutwa.data.Texts.HISTORY },
                contentAlignment = Alignment.Center,
            ) { KhIcon(R.drawable.ic_kh_history, c.ink, size = 22.dp) }
            Spacer(Modifier.width(6.dp))
        }
        Image(painterResource(if (c.isDark) R.drawable.logo_mark_dark else R.drawable.logo_mark), contentDescription = null,
            modifier = Modifier.size(34.dp))
        Spacer(Modifier.width(8.dp))
        Text("خطوة", style = KhType.heading, color = c.ink, modifier = Modifier.weight(1f))
        UrgentPill(onUrgent)
    }
}

@Composable
fun BackButton(onClick: () -> Unit) {
    val c = Kh.colors
    Box(
        Modifier.size(40.dp).clickable(role = Role.Button, onClick = onClick).semantics { contentDescription = "رجوع" },
        contentAlignment = Alignment.Center,
    ) {
        // arrow-right points "back" in a right-to-left layout
        KhIcon(R.drawable.ic_kh_arrow_right, c.ink, size = 24.dp)
    }
    Spacer(Modifier.width(4.dp))
}

@Composable
fun Bubble(text: String, mine: Boolean, modifier: Modifier = Modifier, reveal: Boolean = false, onRevealed: () -> Unit = {},
           onGrow: () -> Unit = {}, showWho: Boolean = false) {
    val c = Kh.colors
    // Word-by-word reveal of a reply the server has already checked; the full text is never different.
    val words = remember(text) { text.split(" ") }
    val wordByWord = reveal && !Prefs.instantReplies && !Prefs.calmMotion
    var shown by remember(text) { mutableIntStateOf(if (wordByWord) 1 else words.size) }
    LaunchedEffect(text, reveal) {
        if (!wordByWord) { shown = words.size; if (reveal) { onGrow(); onRevealed() }; return@LaunchedEffect }
        while (shown < words.size) { delay(55); shown++; if (shown % 4 == 0) onGrow() }
        onGrow(); onRevealed()
    }
    val visible = if (shown >= words.size) text else words.take(shown).joinToString(" ")
    val revealing = shown < words.size
    val shape: Shape = if (mine) KhShapes.bubbleMe else KhShapes.bubbleBot
    Column(modifier.fillMaxWidth(), horizontalAlignment = if (mine) Alignment.Start else Alignment.End) {
        // Who is speaking, above the first of Khutwa's messages in a run (kh-bubble__who in the brand stylesheet).
        if (showWho && !mine) Text("خطوة", style = KhType.small, color = c.inkMuted, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
        Text(
            visible,
            style = KhType.bubble,
            color = if (mine) c.onGreen else c.ink,
            modifier = Modifier
                .widthIn(max = 300.dp)
                // reading at your own pace: a tap shows the rest of the reply at once
                .then(if (revealing) Modifier.clickable(interactionSource = null, indication = null) { shown = words.size } else Modifier)
                .background(if (mine) c.green else c.paperRaised, shape)
                .border(PenWidth, if (mine) c.onGreen else c.ink, shape)
                .padding(horizontal = 16.dp, vertical = 10.dp),
        )
    }
}

/** "Khutwa is writing": the brand squiggle keeps drawing itself, like a pen, inside a reply bubble. */
@Composable
fun Typing(modifier: Modifier = Modifier) {
    val c = Kh.colors
    Row(modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
        Box(
            Modifier.background(c.paperRaised, KhShapes.bubbleBot).border(PenWidth, c.ink, KhShapes.bubbleBot)
                .padding(horizontal = 16.dp, vertical = 14.dp)
                .semantics { contentDescription = "خطوة قاعد يكتب" },
        ) { DoodleLoop(Doodles.SQUIGGLE, c.ink, Modifier.size(width = 64.dp, height = 12.dp)) }
    }
}

/** The pebble from the brand: a slightly lopsided, rotated stone. */
@Composable
fun Stone(color: Color, rotation: Float, modifier: Modifier = Modifier) {
    val edge = Kh.colors.onGreen
    Canvas(modifier.size(40.dp, 46.dp).rotate(rotation)) {
        val inset = 2.dp.toPx()
        drawOval(color, topLeft = Offset(inset, inset), size = Size(size.width - 2 * inset, size.height - 2 * inset))
        drawOval(edge, topLeft = Offset(inset, inset), size = Size(size.width - 2 * inset, size.height - 2 * inset),
            style = Stroke(width = 2.dp.toPx()))
    }
}

/** A support option: who could help, and the one-line reason. */
@Composable
fun SupportCard(title: String, why: String, index: Int, onClick: () -> Unit, modifier: Modifier = Modifier) {
    val c = Kh.colors
    val (stone, rot) = when (index % 3) { 0 -> c.clay to -12f; 1 -> c.sun to 10f; else -> c.green to -6f }
    Row(
        modifier.fillMaxWidth()
            .background(c.paperRaised, KhShapes.card)
            .border(PenWidth, c.ink, KhShapes.card)
            .clickable(role = Role.Button, onClick = onClick)
            .padding(20.dp),
        verticalAlignment = Alignment.Top,
    ) {
        Stone(stone, rot)
        Spacer(Modifier.width(14.dp))
        Column(Modifier.weight(1f)) {
            Text(title, style = KhType.heading, color = c.ink)
            Spacer(Modifier.height(2.dp))
            Text(why, style = KhType.body, color = c.inkMuted)
        }
        KhIcon(R.drawable.ic_kh_arrow_left, c.inkMuted, Modifier.padding(top = 6.dp), 20.dp)
    }
}

@Composable
fun ScreenTitle(text: String, modifier: Modifier = Modifier) {
    Text(text, style = KhType.title, color = Kh.colors.ink, modifier = modifier.semantics { heading() })
}

/** A quiet note with an icon: privacy reassurance, gentle notices. */
@Composable
fun Note(text: String, @DrawableRes icon: Int, background: Color, modifier: Modifier = Modifier) {
    val c = Kh.colors
    Row(
        modifier.fillMaxWidth().background(background, KhShapes.field).padding(horizontal = 14.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        KhIcon(icon, c.ink, size = 18.dp)
        Spacer(Modifier.width(10.dp))
        Text(text, style = KhType.small, color = c.ink)
    }
}
