package ly.manara.khutwa

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.slideOutVertically
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.unit.LayoutDirection
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import ly.manara.khutwa.data.KhutwaApi
import ly.manara.khutwa.ui.screens.ChatScreen
import ly.manara.khutwa.ui.screens.ConsentScreen
import ly.manara.khutwa.ui.screens.UrgentScreen
import ly.manara.khutwa.ui.screens.SettingsScreen
import ly.manara.khutwa.ui.screens.HistoryScreen
import ly.manara.khutwa.ui.components.KhMotion
import ly.manara.khutwa.ui.theme.Kh
import ly.manara.khutwa.ui.theme.KhutwaTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        val splash = installSplashScreen()
        super.onCreate(savedInstanceState)
        // Exit: the mark lifts a little and fades while the paper ground dissolves into the first screen.
        splash.setOnExitAnimationListener { provider ->
            val icon = provider.iconView
            val curve = android.view.animation.PathInterpolator(0.3f, 0f, 0.8f, 0.15f)  // Material emphasized accelerate
            // let the pen finish drawing the mark (the app is often ready before it is), then leave
            val wait = (provider.iconAnimationStartMillis + provider.iconAnimationDurationMillis -
                android.os.SystemClock.uptimeMillis()).coerceIn(0L, 1300L) + 120L
            icon.animate().scaleX(1.12f).scaleY(1.12f).translationY(-icon.height * 0.06f).alpha(0f)
                .setStartDelay(wait).setDuration(320L).setInterpolator(curve).start()
            provider.view.animate().alpha(0f).setStartDelay(wait + 120L).setDuration(260L).setInterpolator(curve)
                .withEndAction { provider.remove() }.start()
        }
        enableEdgeToEdge()
        // The recent-apps switcher shows a blank card instead of the conversation.
        if (android.os.Build.VERSION.SDK_INT >= 33) setRecentsScreenshotEnabled(false)
        val factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T =
                AppViewModel(KhutwaApi(BuildConfig.API_KEY, BuildConfig.API_URL, BuildConfig.URL_GIST_RAW),
                    store = ly.manara.khutwa.data.ChatStore(applicationContext)) as T
        }
        ly.manara.khutwa.ui.components.Prefs.load(this)
        setContent {
            val prefs = ly.manara.khutwa.ui.components.Prefs
            val dark = when (prefs.theme) {
                ly.manara.khutwa.ui.components.Prefs.Theme.System -> androidx.compose.foundation.isSystemInDarkTheme()
                ly.manara.khutwa.ui.components.Prefs.Theme.Light -> false
                ly.manara.khutwa.ui.components.Prefs.Theme.Dark -> true
            }
            // status and navigation bar icons follow the app's theme, not only the phone's
            androidx.compose.runtime.LaunchedEffect(dark) {
                val style = if (dark) androidx.activity.SystemBarStyle.dark(android.graphics.Color.TRANSPARENT)
                    else androidx.activity.SystemBarStyle.light(android.graphics.Color.TRANSPARENT, android.graphics.Color.TRANSPARENT)
                enableEdgeToEdge(statusBarStyle = style, navigationBarStyle = style)
            }
            KhutwaTheme(dark = dark) {
                val d = androidx.compose.ui.platform.LocalDensity.current
                val haptics = androidx.compose.ui.platform.LocalHapticFeedback.current
                // Arabic everywhere: right-to-left regardless of the phone's language. Text size and vibration follow settings.
                CompositionLocalProvider(
                    LocalLayoutDirection provides LayoutDirection.Rtl,
                    androidx.compose.ui.platform.LocalDensity provides androidx.compose.ui.unit.Density(d.density, d.fontScale * prefs.textScale),
                    androidx.compose.ui.platform.LocalHapticFeedback provides if (prefs.haptics) haptics else NoHaptics,
                ) {
                    KhutwaApp(viewModel(factory = factory), onExit = ::finish)
                }
            }
        }
    }
}

@Composable
fun KhutwaApp(vm: AppViewModel, onExit: () -> Unit) {
    val state by vm.state.collectAsStateWithLifecycle()
    BackHandler(enabled = state.screen !is Screen.Consent && state.screen !is Screen.Chat) { vm.back() }
    Box(Modifier.fillMaxSize().background(Kh.colors.paper).windowInsetsPadding(WindowInsets.safeDrawing)) {
        AnimatedContent(
            targetState = state.screen,
            transitionSpec = {
                when {
                    ly.manara.khutwa.ui.components.Prefs.calmMotion -> fadeIn(tween(160)) togetherWith fadeOut(tween(120))
                    // The urgent screen rises from below, and settles back down when closed.
                    targetState is Screen.Urgent ->
                        (slideInVertically(tween(380, easing = KhMotion.EmphasizedDecelerate)) { it / 6 } + fadeIn(tween(240))) togetherWith
                            fadeOut(tween(160))
                    initialState is Screen.Urgent ->
                        fadeIn(tween(240, delayMillis = 60)) togetherWith
                            (slideOutVertically(tween(260, easing = KhMotion.EmphasizedAccelerate)) { it / 6 } + fadeOut(tween(200)))
                    // Forward moves along the reading direction (right-to-left), Material shared axis.
                    else -> (slideInHorizontally(tween(360, easing = KhMotion.EmphasizedDecelerate)) { -it / 8 } + fadeIn(tween(260))) togetherWith
                        (slideOutHorizontally(tween(220, easing = KhMotion.EmphasizedAccelerate)) { it / 8 } + fadeOut(tween(160)))
                }
            },
            contentKey = { it::class }, label = "screen",
        ) { screen ->
            when (screen) {
                Screen.Consent -> ConsentScreen(onAccept = vm::acceptConsent, onDecline = onExit, onUrgent = vm::openUrgent,
                    onSettings = vm::openSettings)
                Screen.Chat -> ChatScreen(state, vm::send, vm::retry, vm::askWhoToTalkTo, vm::newChat, vm::openUrgent, vm::revealed,
                    onSettings = vm::openSettings, onOpenChat = vm::openChat, onAllChats = vm::openHistory)
                is Screen.Settings -> SettingsScreen(onBack = { vm.back() }, onUrgent = vm::openUrgent,
                    onErase = vm::eraseCurrent, canErase = state.lines.size > 1,
                    savedCount = state.savedChats.size, memory = state.memory,
                    onKeepHistory = vm::setKeepHistory, onUseMemory = vm::setUseMemory, onClearMemory = vm::clearMemory,
                    onOpenHistory = vm::openHistory)
                is Screen.History -> HistoryScreen(state.savedChats, state.chatId, onBack = { vm.back() }, onUrgent = vm::openUrgent,
                    onOpen = vm::openChat, onDelete = vm::deleteChat, onDeleteAll = vm::deleteAllChats)
                is Screen.Urgent -> UrgentScreen(screen.auto, onBack = { vm.back() })
            }
        }
    }
}

/** Used when the user turns vibration off in settings. */
private object NoHaptics : androidx.compose.ui.hapticfeedback.HapticFeedback {
    override fun performHapticFeedback(hapticFeedbackType: androidx.compose.ui.hapticfeedback.HapticFeedbackType) {}
}
