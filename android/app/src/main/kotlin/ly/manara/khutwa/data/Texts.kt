package ly.manara.khutwa.data

/**
 * Fixed, safety-critical text. Copied from content/ (reviewed in Libyan Arabic by Marwan, #67).
 * Never generated, never changed by the AI.
 */
object Texts {
    const val CONSENT_TITLE = "خطوة: قبل ما نبدوا"
    const val CONSENT_INTRO = "خطوة تساعدك تاخذ أول خطوة باش تحكي مع حد تثق فيه، مش بديل على الناس، ومش بديل على مختص."
    const val CONSENT_AI = "خلي في بالك إن اللي يرد عليك ذكاء اصطناعي، مش إنسان."
    const val CONSENT_REDACTION = "قبل ما يطلع أي كلام من تلفونك، الأسماء والأماكن والأرقام والإيميلات تنشال تلقائيًا على التلفون نفسه، والذكاء الاصطناعي ما يشوفهاش."
    const val CONSENT_GOOGLE = "الكلام بعد ما ينشال منه اللي يعرّف بيك يمشي لنموذج ذكاء اصطناعي تابع لشركة Google باش يرد عليك، وGoogle تتعامل معاه حسب سياستها."
    const val CONSENT_SERVER = "إحني ما نسجلوش كلامك وما نخزنوهش عندنا، وما فيش حسابات."
    const val CONSENT_EMERGENCY = "خطوة مش خدمة طوارئ، لو أنت في خطر توا، اضغط على «نحتاج مساعدة توا» في أي وقت."
    const val CONSENT_ACCEPT = "فاهم، نبي نبدا"
    const val CONSENT_DECLINE = "مش توا"

    const val URGENT_TITLE = "سلامتك أهم حاجة توا"
    const val URGENT_INTRO_AUTO = "شكرًا إنك كتبت اللي في قلبك، اللي كتبته يخلينا نبو نتأكدوا إنك بخير، وهادي خطوات تقدر تديرها توا."
    const val URGENT_STEP_PERSON = "قول لحد قريب منك توا: صاحبك، حد من العيلة تثق فيه، جارك، أي حد تحس روحك معاه في أمان، ما تقعدش بروحك."
    const val URGENT_STEP_HOSPITAL = "لو حاس إنك ممكن تأذي روحك، امشي لأقرب مستشفى، وبرا لقسم الطوارئ، أو خلي حد يوصلك."
    const val URGENT_STEP_SAFE = "بعّد على روحك أي حاجة ممكن تأذيك، وخليك في مكان فيه ناس."
    const val URGENT_NO_CONTACTS = "لتوا ما قدرناش نتأكدوا من أي رقم يرد، عشان هكي ما حطيناش أرقام، الخطوات اللي فوق تقدر تديرها توا."
    const val URGENT_MESSAGE_TITLE = "اكتب رسالة لحد تثق فيه"
    const val URGENT_MESSAGE_TEXT = "أنا مش كويس توا ومحتاجك، تقدر تجيني أو تكلمني؟"
    const val URGENT_COPY = "انسخ الرسالة"
    const val URGENT_SHARE = "ابعتها بنفسك"
    const val URGENT_BACK = "رجوع"
    const val URGENT_FOOTER = "خطوة مش خدمة طوارئ، وما فيش حد يقرا كلامك، الخطوات هذي مكتوبة ومراجعة من الفريق، مش من الذكاء الاصطناعي."

    const val CARD_BREATH_TITLE = "تنفّس على راحتك"
    const val CARD_BREATH_BODY = "اقعد في مكان مريح، تنفس من خشمك على راحتك وانت تعد من لعند 4، وطلّعه من فمك على راحتك وانت تعد لين 6. عاودها 5 مرات، لو حسيت بدوخة، ارجع تنفس عادي."
    const val CARD_GROUND_TITLE = "رجّع روحك للحظة هذي"
    const val CARD_GROUND_BODY = "شوف حواليك وسمّي في بالك:\n5 حوايج تشوفهم،\n4 حوايج تسمعهم،\n3 حوايج تقدر تلمسهم،\n2 ريحات تشمهم،\nوحاجة وحدة تقدر تذوقها.\nعلى راحتك، ما فيش استعجال."

    // App chrome (not safety content).
    const val GREETING = "أهلاً بيك. احكيلي شن اللي في بالك، على راحتك وبالكلام اللي يجيك."
    const val COMPOSER_HINT = "اكتب هنا…"
    const val PRIVACY_LINE = "الأسماء والأرقام تنشال على تلفونك قبل ما يطلع أي كلام."
    const val PRIVACY_MARKED = "المعلّم بالأصفر ينشال على تلفونك قبل ما يطلع."
    const val WHO_TO_TALK = "مع مني نحكي؟"
    const val WHO_TO_TALK_MESSAGE = "مش عارف مع مني نحكي"
    const val SEE_OPTIONS = "نشوفوا مع مني تقدر تحكي"
    const val OPTIONS_TITLE = "ناس ممكن تحكي معاهم"
    const val OPTIONS_SUB = "اختار اللي تحس روحك مرتاح معاه. ما نبعتوا شي بدالك."
    const val DRAFT_TITLE = "رسالتك"
    const val DRAFT_SUB = "عدّلها كيف تبي، وبعدها ابعتها بنفسك من المسنجر ولا أي تطبيق."
    const val DRAFT_SHARE = "ابعتها بنفسك"
    const val DRAFT_COPY = "انسخ الرسالة"
    const val DRAFT_COPIED = "تنسخت"
    const val DRAFT_NOTE = "خطوة ما يبعت شي بدالك، وما يحفظ الرسالة."
    const val ERROR_NETWORK = "ما قدرناش نوصلوا للخادم. تقدر تعاود، وإذا تحس روحك مش في أمان اضغط «نحتاج مساعدة توا»."
    const val RETRY = "عاود"
    const val NEW_CHAT = "محادثة جديدة"

    /** Generic support options, used when the AI's suggestions are unavailable. Never promises confidentiality. */
    val GENERIC_OPTIONS = listOf(
        Option("trusted_friend", "صاحب يسمعك من غير ما يحكم عليك.", "عندك شوية وقت نحكوا؟ نبي نحكيلك على حاجة شاغلتني."),
        Option("trusted_relative", "حد من العيلة تثق فيه وتحس روحك مرتاح معاه.", "بالله لو عندك وقت، نبي نحكي معاك في موضوع."),
        Option("specialist", "المختص يقدر يسمعك ويساعدك تفهم شن اللي يفيدك.", "السلام عليكم، نبي نحجز موعد ونحكي مع حد."),
    )

    val TYPE_LABELS = mapOf(
        "trusted_friend" to "صاحب تثق فيه",
        "academic_adviser" to "أستاذ أو مرشد",
        "trusted_relative" to "حد من العيلة تثق فيه",
        "community_figure" to "شخص من المجتمع تثق فيه",
        "specialist" to "مختص",
    )
}

data class Option(val type: String, val why: String, val draft: String)
