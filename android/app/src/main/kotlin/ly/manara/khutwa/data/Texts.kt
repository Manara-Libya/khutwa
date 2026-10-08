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
    // The welcome line at the top of a new chat, by time of day (one is picked per chat). Drafted with Gemini, then
    // trimmed to lines that never assume how the user feels, never nudge and never suggest a person is listening.
    val WELCOME_NIGHT = listOf("سهران الليلة؟", "الليل هادي، شن في بالك؟", "الليل هادي، خوذ راحتك واحكي", "ربي يفرّجها عليك",
        "مازال ما رقدتش؟")
    val WELCOME_MORNING = listOf("أصبحنا وأصبح الملك لله", "صباح الخير، شن الأخبار؟", "يا صباح الخير، ربي ييسرها",
        "ربي ييسرها عليك، يومك مبارك", "يوم جديد، خطوة جديدة.", "بداية نهار هادية، خوذ وقتك")
    val WELCOME_DAY = listOf("نهارك زين؟", "شن الأخبار؟ احكيلي", "ربي يعينك، خوذ نفس واحكي", "بالشوية على روحك",
        "شن صاير معاك اليوم؟")
    val WELCOME_EVENING = listOf("أمسينا وأمسى الملك لله", "مساء الخير، كيف كان نهارك؟", "ربي يريّح بالك الليلة",
        "إن شاء الله يومك عدّى بخير", "العشية رايقة، شن في خاطرك؟")
    val WELCOME_BACK = listOf("مرحبتين بيك", "أهلاً بيك مرة ثانية.", "نورت من جديد.", "شن الأخبار توا؟",
        "خوذ راحتك، احكي وقت ما تحب")
    const val MENU = "القائمة"
    const val DRAWER_NOT_SAVED = "محادثاتك ما تنحفظش. تقدر تشغّل الحفظ، وتقعد على تلفونك بس."
    const val TURN_ON_SAVING = "شغّل الحفظ"
    const val SEE_ALL = "الكل"
    const val WELCOME_SUB = "احكي براحتك وبأي كلام يجي في بالك."
    const val COMPOSER_HINT = "اكتب هنا…"
    const val PRIVACY_LINE = "الأسماء والأرقام تنشال على تلفونك قبل ما يطلع أي كلام."
    const val PRIVACY_MARKED = "المعلّم بالأصفر ينشال على تلفونك قبل ما يطلع."
    const val RECEIPT_HIDDEN = "تخبّى اللي يعرّف بيك"
    const val RECEIPT_CLEAN = "أسرارك محفوظة"
    const val RECEIPT_SHOW = "شوف شن وصل"
    const val RECEIPT_HIDE = "سكّر"
    const val RECEIPT_TITLE = "هذا اللي وصل للذكاء الاصطناعي:"
    const val RECEIPT_NOTE = "الأسماء الحقيقية ترجع على تلفونك بس."
    const val RECEIPT_LOCAL = "ما طلع شي من تلفونك"
    const val RECEIPT_LIMIT = "الكلام نفسه ممكن يبيّن شكون انت، فخلي بالك من التفاصيل."
    const val AFTER_SEND_NOTE = "لو ما ردّش زي ما تبي، هذا مش ذنبك. تقدر تجرب حد ثاني."
    const val OFFLINE = "ما فيش نت توا. كلامك يقعد هنا لين يرجع النت، والتنفس وصفحة المساعدة يخدموا من غير نت."
    const val CALM = "نهدّي شوية"
    const val CALM_TITLE = "خذ نفس على راحتك"
    const val SETTINGS = "الإعدادات"
    val STARTERS = listOf("مضغوط من القراية", "حاس روحي وحدي", "مش عارف من وين نبدا")
    const val BREATH_START = "نتنفسوا مع بعض"
    const val BREATH_IN = "دخّل النفس من خشمك"
    const val BREATH_OUT = "طلّعه من فمك على راحتك"
    const val BREATH_DONE = "كمّلنا الخمس مرات. على راحتك."
    const val BREATH_STOP = "وقّف"
    const val BREATH_AGAIN = "عاود"
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

    const val DECLINED_BODY = "ما بعتنا شي وما خزنا شي. ترجع وقت ما تبي، وإذا احتجت مساعدة توا اضغط «نحتاج مساعدة توا» فوق."
    const val NEW_CHAT_BODY = "المحادثة هذي بتنمسح من تلفونك، وما تقدرش ترجعلها."
    const val ERASE_SAVED_BODY = "المحادثة هذي بتنمسح من تلفونك ومن محادثاتك المحفوظة، وما تقدرش ترجعلها."
    const val HISTORY = "محادثاتك"
    const val HISTORY_NOTE = "محفوظة مقفولة على تلفونك بس، وما تطلعش منه."
    const val HISTORY_EMPTY = "ما فيش محادثات محفوظة لين توا. اللي تكتبه من توا ينحفظ هني."
    const val HISTORY_OPEN_NOW = "مفتوحة توا"
    const val HISTORY_DELETE_ALL = "امسح كل المحادثات"
    const val HISTORY_DELETE_TITLE = "نمسحوا المحادثة هذي؟"
    const val HISTORY_DELETE_BODY = "بتنمسح من تلفونك، وما تقدرش ترجعلها."
    const val HISTORY_DELETE_ALL_TITLE = "نمسحوا كل المحادثات؟"
    const val HISTORY_DELETE_ALL_BODY = "كل المحادثات المحفوظة واللي يتفكّره خطوة بيتمسحوا من تلفونك، وما تقدرش ترجعلهم."
    const val KEEP_HISTORY = "احفظ محادثاتي على تلفوني"
    const val KEEP_HISTORY_NOTE = "تنحفظ مقفولة بمفتاح في تلفونك بس، وما تطلعش منه. أي حد يفتح خطوة على تلفونك يقدر يشوفها."
    const val KEEP_HISTORY_OFF_TITLE = "نقفلوا حفظ المحادثات؟"
    const val KEEP_HISTORY_OFF_BODY = "كل المحادثات المحفوظة واللي يتفكّره خطوة بيتمسحوا من تلفونك."
    const val USE_MEMORY = "خطوة يتفكّر"
    const val USE_MEMORY_NOTE = "ملاحظات قصيرة على اللي حكيت عليه، باش ما تعاودش كل شي من الأول. الأسماء تنشال منها قبل ما تطلع."
    const val MEMORY_LABEL = "شن يتفكّر خطوة عليك:"
    const val MEMORY_EMPTY = "لين توا ما فيش حاجة. تتكتب بعد ما تحكي."
    const val MEMORY_CLEAR = "امسح اللي يتفكّره"
    const val STORED_OFF = "بس إعدادات الشكل هذي (الألوان والخط والحركة). كلامك وصيغتك ما ينحفظوش، ويمشوا لما تسكر التطبيق."
    const val STORED_ON = "إعدادات الشكل، ومحادثاتك المحفوظة واللي يتفكّره خطوة، مقفولين بمفتاح. على تلفونك بس، وما يطلعوش في النسخ الاحتياطية."
    const val ADDRESS_LABEL = "نكلموك بصيغة:"
    const val ADDRESS_M = "ولد"
    const val ADDRESS_F = "بنت"

    /**
     * Feminine forms of every text that speaks to the user, picked on the consent screen (kept in memory only).
     * Keyed by the masculine text, so a text the server sends with the same wording is switched too.
     * Needs the same Libyan Arabic review as the masculine texts.
     */
    val FEMININE: Map<String, String> by lazy { mapOf(
        CONSENT_INTRO to "خطوة تساعدك تاخذي أول خطوة باش تحكي مع حد تثقي فيه، مش بديل على الناس، ومش بديل على مختص.",
        CONSENT_EMERGENCY to "خطوة مش خدمة طوارئ، لو انتي في خطر توا، اضغطي على «نحتاج مساعدة توا» في أي وقت.",
        CONSENT_ACCEPT to "فاهمة، نبي نبدا",
        URGENT_INTRO_AUTO to "شكرًا إنك كتبتي اللي في قلبك، اللي كتبتيه يخلينا نبو نتأكدوا إنك بخير، وهادي خطوات تقدري تديريها توا.",
        URGENT_STEP_PERSON to "قولي لحد قريب منك توا: صاحبتك، حد من العيلة تثقي فيه، جارتك، أي حد تحسي روحك معاه في أمان، ما تقعديش بروحك.",
        URGENT_STEP_HOSPITAL to "لو حاسة إنك ممكن تأذي روحك، امشي لأقرب مستشفى، وبرا لقسم الطوارئ، أو خلي حد يوصلك.",
        URGENT_STEP_SAFE to "بعّدي على روحك أي حاجة ممكن تأذيك، وخليك في مكان فيه ناس.",
        URGENT_NO_CONTACTS to "لتوا ما قدرناش نتأكدوا من أي رقم يرد، عشان هكي ما حطيناش أرقام، الخطوات اللي فوق تقدري تديريها توا.",
        URGENT_MESSAGE_TITLE to "اكتبي رسالة لحد تثقي فيه",
        URGENT_MESSAGE_TEXT to "أنا مش كويسة توا ومحتاجتك، تقدر تجيني أو تكلمني؟",
        URGENT_COPY to "انسخي الرسالة",
        URGENT_SHARE to "ابعتيها بنفسك",
        CARD_BREATH_BODY to "اقعدي في مكان مريح، تنفسي من خشمك على راحتك وانتي تعدي من لعند 4، وطلّعيه من فمك على راحتك وانتي تعدي لين 6. عاوديها 5 مرات، لو حسيتي بدوخة، ارجعي تنفسي عادي.",
        CARD_GROUND_BODY to "شوفي حواليك وسمّي في بالك:\n5 حوايج تشوفيهم،\n4 حوايج تسمعيهم،\n3 حوايج تقدري تلمسيهم،\n2 ريحات تشميهم،\nوحاجة وحدة تقدري تذوقيها.\nعلى راحتك، ما فيش استعجال.",
        GREETING to "أهلاً بيكي. احكيلي شن اللي في بالك، على راحتك وبالكلام اللي يجيك.",
        "سهران الليلة؟" to "سهرانة الليلة؟",
        "الليل هادي، خوذ راحتك واحكي" to "الليل هادي، خوذي راحتك واحكي",
        "ربي يفرّجها عليك" to "ربي يفرّجها عليكي",
        "مازال ما رقدتش؟" to "مازال ما رقدتيش؟",
        "ربي ييسرها عليك، يومك مبارك" to "ربي ييسرها عليكي، يومك مبارك",
        "بداية نهار هادية، خوذ وقتك" to "بداية نهار هادية، خوذي وقتك",
        "ربي يعينك، خوذ نفس واحكي" to "ربي يعينك، خوذي نفس واحكي",
        "شن صاير معاك اليوم؟" to "شن صاير معاكي اليوم؟",
        "مرحبتين بيك" to "مرحبتين بيكي",
        "أهلاً بيك مرة ثانية." to "أهلاً بيكي مرة ثانية.",
        "نورت من جديد." to "نورتي من جديد.",
        "خوذ راحتك، احكي وقت ما تحب" to "خوذي راحتك، احكي وقت ما تحبي",
        DRAWER_NOT_SAVED to "محادثاتك ما تنحفظش. تقدري تشغّلي الحفظ، وتقعد على تلفونك بس.",
        TURN_ON_SAVING to "شغّلي الحفظ",
        COMPOSER_HINT to "اكتبي هنا…",
        WHO_TO_TALK_MESSAGE to "مش عارفة مع مني نحكي",
        SEE_OPTIONS to "نشوفوا مع مني تقدري تحكي",
        OPTIONS_SUB to "اختاري اللي تحسي روحك مرتاحة معاه. ما نبعتوا شي بدالك.",
        DRAFT_SUB to "عدّليها كيف تبي، وبعدها ابعتيها بنفسك من المسنجر ولا أي تطبيق.",
        DRAFT_SHARE to "ابعتيها بنفسك",
        DRAFT_COPY to "انسخي الرسالة",
        "انسخ" to "انسخي",
        ERROR_NETWORK to "ما قدرناش نوصلوا للخادم. تقدري تعاودي، وإذا تحسي روحك مش في أمان اضغطي «نحتاج مساعدة توا».",
        RETRY to "عاودي",
        RECEIPT_HIDDEN to "تخبّى اللي يعرّف بيكي",
        RECEIPT_SHOW to "شوفي شن وصل",
        RECEIPT_HIDE to "سكّري",
        RECEIPT_LIMIT to "الكلام نفسه ممكن يبيّن شكون انتي، فخلي بالك من التفاصيل.",
        AFTER_SEND_NOTE to "لو ما ردّش زي ما تبي، هذا مش ذنبك. تقدري تجربي حد ثاني.",
        CALM_TITLE to "خوذي نفس على راحتك",
        BREATH_IN to "دخّلي النفس من خشمك",
        BREATH_OUT to "طلّعيه من فمك على راحتك",
        BREATH_STOP to "وقّفي",
        BREATH_AGAIN to "عاودي",
        DECLINED_BODY to "ما بعتنا شي وما خزنا شي. ترجعي وقت ما تبي، وإذا احتجتي مساعدة توا اضغطي «نحتاج مساعدة توا» فوق.",
        NEW_CHAT_BODY to "المحادثة هذي بتنمسح من تلفونك، وما تقدريش ترجعيلها.",
        ERASE_SAVED_BODY to "المحادثة هذي بتنمسح من تلفونك ومن محادثاتك المحفوظة، وما تقدريش ترجعيلها.",
        HISTORY_EMPTY to "ما فيش محادثات محفوظة لين توا. اللي تكتبيه من توا ينحفظ هني.",
        HISTORY_DELETE_BODY to "بتنمسح من تلفونك، وما تقدريش ترجعيلها.",
        HISTORY_DELETE_ALL_BODY to "كل المحادثات المحفوظة واللي يتفكّره خطوة بيتمسحوا من تلفونك، وما تقدريش ترجعيلهم.",
        USE_MEMORY_NOTE to "ملاحظات قصيرة على اللي حكيتي عليه، باش ما تعاوديش كل شي من الأول. الأسماء تنشال منها قبل ما تطلع.",
        MEMORY_EMPTY to "لين توا ما فيش حاجة. تتكتب بعد ما تحكي.",
        "مضغوط من القراية" to "مضغوطة من القراية",
        "حاس روحي وحدي" to "حاسة روحي وحدي",
        "مش عارف من وين نبدا" to "مش عارفة من وين نبدا",
        "صاحب تثق فيه" to "صاحبة تثقي فيها",
        "حد من العيلة تثق فيه" to "حد من العيلة تثقي فيه",
        "شخص من المجتمع تثق فيه" to "شخص من المجتمع تثقي فيه",
    ) }

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
