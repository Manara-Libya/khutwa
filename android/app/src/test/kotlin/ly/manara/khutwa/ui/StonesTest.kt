package ly.manara.khutwa.ui

import ly.manara.khutwa.ui.components.Stones
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertSame
import org.junit.Test

class StonesTest {
    @Test fun trailingKnownStoneIsSplitOff() {
        val (body, stone) = Stones.split("فاهمك، هذا ثقيل. من قداش وانت هكي؟ :kh-heavy:")
        assertEquals("فاهمك، هذا ثقيل. من قداش وانت هكي؟", body)
        assertSame(Stones.ALL["kh-heavy"], stone)
    }

    @Test fun unknownOrPrivacyStonesAreDroppedButNotShown() {
        val (body, stone) = Stones.split("هذا يبقى بينا :kh-safe:")
        assertEquals("هذا يبقى بينا", body)
        assertNull(stone)
        assertNull(Stones.split("أهلاً :kh-party:").second)
    }

    @Test fun aCodeInTheMiddleIsRemovedAndNotShown() {
        val (body, stone) = Stones.split("أهلاً :kh-hug: بيك")
        assertEquals("أهلاً بيك", body)
        assertNull(stone)
    }

    @Test fun stripRemovesTheStone() {
        assertEquals("ربي يعينك.", Stones.strip("ربي يعينك. :kh-tea:"))
    }
}
