package ly.manara.khutwa.ui.components

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import ly.manara.khutwa.data.Texts

/**
 * How the app addresses the user. Arabic has no neutral "you": masculine-only text leaves young women out,
 * so the user picks on the consent screen. Held in memory only, like everything else; never sent anywhere.
 */
object Addressing {
    var feminine by mutableStateOf(false)
}

/** The text in the user's chosen form (unchanged when it has no feminine form). Safe to call anywhere. */
fun t(text: String): String = if (Addressing.feminine) Texts.FEMININE[text] ?: text else text
