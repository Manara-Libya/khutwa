package ly.manara.khutwa.privacy

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** All test text is fictional. Appendix A cases come from docs/challenge-brief.md. */
class LibyanRedactorTest {
    private val redactor = LibyanRedactor()
    private fun r(text: String) = redactor.redact(text).redacted

    // Appendix A privacy cases

    @Test fun appendixA_nameCityNumberBrother() = assertEquals(
        "أنا [اسم] من [مكان]، ورقمي [رقم]، خوي [اسم] ما يفهمنيش.",
        r("أنا سلمى من سبها، ورقمي 091xxxxxxx، خوي أحمد ما يفهمنيش."),
    )

    @Test fun appendixA_arabiziKinNames() = assertEquals(
        "khoya [اسم] w ommi [اسم] dayman y3ayto 3liya",
        r("khoya ahmed w ommi fatima dayman y3ayto 3liya"),
    )

    @Test fun appendixA_professorAndAttachedCity() = assertEquals(
        "الدكتور [اسم] في كلية الهندسة ب[مكان] قالي نعيد السنة",
        r("الدكتور مصطفى في كلية الهندسة بسبها قالي نعيد السنة"),
    )

    // Names and places

    @Test fun attachedPrefixes() = assertEquals(
        "ساكن في [مكان] و[اسم] خوي في [مكان]",
        r("ساكن في طرابلس ومحمد خوي في بنغازي"),
    )

    @Test fun spellingVariants() = assertEquals(
        "[اسم] و[اسم] و[اسم]",
        r("احمد وفاطمه وعبد الله"),
    )

    @Test fun unlistedNameAfterKinWord() {
        assertEquals("ختي [اسم] زعلانة مني", r("ختي سندس زعلانة مني"))
        assertEquals("sa7bi [اسم] ma ja", r("sa7bi sanad ma ja"))
        assertEquals("اسمي [اسم]", r("اسمي غفران"))
    }

    @Test fun kinWordFollowedByCommonWordIsKept() {
        for (text in listOf(
            "خوي ديما يزعق عليا وما نحسش روحي مرتاحة في الحوش.",
            "بوي ماقالش حاجة",
            "khoya dayman ydhar 3liya",
            "خوي وختي مسافرين",
        )) assertEquals(text, r(text))
    }

    @Test fun universityAndNeighbourhood() = assertEquals(
        "نقرا في جامعة [مكان] وساكن في [مكان]",
        r("نقرا في جامعة طرابلس وساكن في سوق الجمعة"),
    )

    @Test fun arabiziPlaces() = assertEquals(
        "ana men [مكان] w na9ra f [مكان]",
        r("ana men Misrata w na9ra f Benghazi"),
    )

    // Numbers and emails

    @Test fun phoneFormats() {
        for (phone in listOf(
            "0912345678", "091 234 5678", "092-123-4567", "+218 91 234 5678", "00218912345678",
            "+218912345678", "٠٩١٢٣٤٥٦٧٨", "021-3334444",
        )) assertEquals(phone, "رقمي [رقم] كلمني", r("رقمي $phone كلمني"))
    }

    @Test fun emailAndHandle() = assertEquals(
        "إيميلي [بريد] والانستا [اسم]",
        r("إيميلي salma.test@example.com والانستا @salma_ly99"),
    )

    @Test fun studentNumber() = assertEquals("رقم القيد [رقم]", r("رقم القيد 22012345"))

    @Test fun shortNumbersAreKept() {
        val text = "عندي 3 امتحانات في 5 أيام، الساعة 10"
        assertEquals(text, r(text))
    }

    // Meaning must survive: risk wording and messages without identifiers stay untouched

    @Test fun messagesWithoutIdentifiersAreUnchanged() {
        for (text in listOf(
            "راني تعبان من القراية والامتحانات قربت، ومش عارف نحكي مع منو.",
            "rani ta3ban barsha w mich 3aref chen ndir, el imti7anat 9orbet",
            "من أسبوع ما رقدتش كويس، ونحس روحي ديما متوترة.",
            "قولي شن عندي؟ اكتبلي التشخيص.",
            "نحس ما عادش نبي نعيش.",
            "حد في القروب قعد يتمسخر عليا قدام الكل.",
            "ma 3adech nbi n3ich",
            "نبي نرتاح من كل شي وما نبيش نكمل",
            "أفكر في إنهاء حياتي",
            "نموت من الضحك على اللي صار اليوم",
            "قولّي شن الدوا اللي نشربه",
            "ما عاد فيه أمل، والنور مطفي في حياتي",
            "حطيت الكتاب عليا وقعدت",
            "بعمر 20 سنة وما زلت نقرا",
        )) assertEquals(text, r(text))
    }

    // Result shape and tap-to-hide

    @Test fun spansAreSortedAndDoNotOverlap() {
        val result = redactor.redact("أنا سلمى من سبها، 0912345678، salma@example.com، خوي أحمد في طرابلس")
        result.spans.zipWithNext().forEach { (a, b) -> assertTrue("$a overlaps $b", a.end <= b.start) }
        assertTrue(result.spans.all { result.original.substring(it.start, it.end).isNotBlank() })
    }

    @Test fun toggleHidesAWordAndRestoresIt() {
        val text = "نقرا في كلية الهندسة"
        val start = text.indexOf("الهندسة")
        val hidden = redactor.toggle(redactor.redact(text), start, start + "الهندسة".length)
        assertEquals("نقرا في كلية [مخفي]", hidden.redacted)
        assertEquals(text, redactor.toggle(hidden, start + 2, start + 3).redacted)
    }

    @Test fun toggleRestoresAnAutomaticSpan() {
        val result = redactor.redact("خوي أحمد")
        assertEquals("خوي أحمد", redactor.toggle(result, 5, 6).redacted)
    }

    @Test fun toggleIgnoresInvalidRanges() {
        val result = redactor.redact("سلام")
        assertEquals(result, redactor.toggle(result, 3, 2))
        assertEquals(result, redactor.toggle(result, 0, 99))
    }

    @Test fun fastEnoughFor2000Chars() {
        val text = "أنا سلمى من سبها ورقمي 0912345678 وخوي أحمد ديما يزعق عليا. ".repeat(40).take(2000)
        repeat(5) { redactor.redact(text) }   // warm up
        val ms = (1..10).map { kotlin.system.measureNanoTime { redactor.redact(text) } }.minOrNull()!! / 1_000_000
        assertTrue("took $ms ms", ms < 50)
    }
}
