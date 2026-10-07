package ly.manara.khutwa.privacy

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Test

class ConversationPrivacyTest {
    @Test fun namesKeepOneNumberForTheWholeConversation() {
        val p = ConversationPrivacy()
        assertEquals("خوي [اسم1] ديما يعيط", p.redact("خوي أحمد ديما يعيط"))
        assertEquals("وصاحبي [اسم2] يفهمني أكثر من [اسم1]", p.redact("وصاحبي سند يفهمني أكثر من أحمد"))
    }

    @Test fun restorePutsTheRightNamesBack() {
        val p = ConversationPrivacy()
        p.redact("خوي أحمد ديما يعيط")
        p.redact("وصاحبي سند يفهمني، ساكن في طرابلس")
        assertEquals("يا سند، نبي نحكي معاك لما نروح طرابلس", p.restore("يا [اسم2]، نبي نحكي معاك لما نروح [مكان1]"))
        assertEquals("يا [اسم]", p.restore("يا [اسم]"))  // two names: a bare placeholder is ambiguous, kept
    }

    @Test fun numbersAndEmailsAreNeverRestored() {
        val p = ConversationPrivacy()
        val sent = p.redact("رقمي 0912345678 وإيميلي salma@example.com")
        assertFalse(sent.contains("0912345678") || sent.contains("salma@"))
        assertEquals("رقمي [رقم]", p.restore("رقمي [رقم]"))
    }

    @Test fun clearForgetsEverything() {
        val p = ConversationPrivacy()
        p.redact("خوي أحمد")
        p.clear()
        assertEquals("يا [اسم1]", p.restore("يا [اسم1]"))
        assertEquals("صاحبي [اسم1]", p.redact("صاحبي محمد"))
    }
}
