package ly.manara.khutwa

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.fadeIn
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
import ly.manara.khutwa.ui.screens.DraftScreen
import ly.manara.khutwa.ui.screens.OptionsScreen
import ly.manara.khutwa.ui.screens.UrgentScreen
import ly.manara.khutwa.ui.theme.Kh
import ly.manara.khutwa.ui.theme.KhutwaTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        val factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T =
                AppViewModel(KhutwaApi(BuildConfig.API_KEY, BuildConfig.API_URL, BuildConfig.URL_GIST_RAW)) as T
        }
        setContent {
            KhutwaTheme {
                // Arabic everywhere: right-to-left regardless of the phone's language.
                CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
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
        AnimatedContent(targetState = state.screen, transitionSpec = { fadeIn() togetherWith fadeOut() },
            contentKey = { it::class }, label = "screen") { screen ->
            when (screen) {
                Screen.Consent -> ConsentScreen(onAccept = vm::acceptConsent, onDecline = onExit, onUrgent = vm::openUrgent)
                Screen.Chat -> ChatScreen(state, vm::send, vm::retry, vm::askWhoToTalkTo, vm::openOptions, vm::newChat, vm::openUrgent, vm::revealed)
                Screen.Options -> OptionsScreen(state.options, vm::choose, onBack = { vm.back() }, onUrgent = vm::openUrgent)
                is Screen.Draft -> DraftScreen(screen.option, onBack = { vm.back() }, onUrgent = vm::openUrgent)
                is Screen.Urgent -> UrgentScreen(screen.auto, onBack = { vm.back() })
            }
        }
    }
}
