package ly.manara.khutwa.privacy

/**
 * Word lists for [LibyanRedactor]. Started from Anas's lists (#58), extended for Libyan use.
 *
 * Leave out names that are also everyday words (أمل hope, حياة life, نور light, علي "on me", سالم safe,
 * فرح joy...). Hiding them would hide meaning, including risk wording like «ما عاد فيه أمل».
 * The user can still tap any word to hide it.
 *
 * Arabic entries are written in one spelling only: alef/hamza forms, final ة/ه and final ى/ي are matched
 * loosely by the redactor.
 */
internal object LibyanLexicon {
    val arabicNames = listOf(
        // men
        "محمد", "أحمد", "محمود", "مصطفى", "عمر", "عثمان", "خالد", "طارق", "إبراهيم", "يوسف", "حسن", "حسين",
        "أيمن", "وليد", "مروان", "أنس", "معاذ", "أسامة", "حمزة", "بلال", "منصور", "أنور", "هشام", "فتحي", "مهند",
        "أيوب", "زكريا", "سفيان", "صهيب", "رياض", "نبيل", "فيصل", "عماد", "عصام", "مراد", "ناصر", "وائل", "حاتم",
        "خليل", "إسماعيل", "إدريس", "موسى", "عيسى", "هارون", "سليمان", "داوود", "المهدي", "السنوسي", "أكرم",
        "زياد", "رامي", "سامي", "تامر", "شادي", "هيثم", "لؤي", "قيس", "غيث", "أنيس", "مؤيد", "محسن", "علاء",
        "ضياء", "معتز", "مجدي", "يحيى", "يونس", "نزار", "الطاهر", "الهادي", "الصديق", "عبدو", "حمودة", "ميمي",
        // women
        "فاطمة", "مريم", "عائشة", "خديجة", "سارة", "سلمى", "هبة", "كوثر", "أمينة", "آمنة", "زينب", "رحاب",
        "سعاد", "نجلاء", "هند", "رانيا", "ريم", "آلاء", "رقية", "حليمة", "صفية", "نسرين", "ياسمين", "شيماء",
        "منار", "إسراء", "سمية", "لمياء", "رزان", "لجين", "تسنيم", "جنى", "روان", "مروة", "نهى", "عبير", "وداد",
        "سناء", "ليلى", "نادية", "هالة", "سمر", "غادة", "منيرة", "حواء", "ربيعة", "نعيمة", "رنيم", "فاطيمة",
    )

    /** Second part of compound names: عبد + (ال) + suffix, with or without a space. */
    val arabicAbdSuffixes = listOf(
        "له", "رحمن", "رحيم", "سلام", "حميد", "عزيز", "باسط", "حكيم", "رؤوف", "منعم", "كريم", "مجيد", "وهاب",
        "قادر", "لطيف", "ناصر", "رزاق", "غني", "جليل", "فتاح", "عاطي", "حفيظ", "غفار", "معطي", "مطلب",
    )

    val latinNames = listOf(
        "mohamed", "mohammed", "mohammad", "muhammad", "mhmd", "ahmed", "ahmad", "mahmoud", "mahmud", "mostafa",
        "mustafa", "moustafa", "omar", "omer", "othman", "osman", "khaled", "khalid", "tarek", "tariq", "ibrahim",
        "brahim", "youssef", "yousef", "yusuf", "hassan", "hasan", "hussein", "hussain", "hossein", "ayman", "waleed",
        "walid", "marwan", "anas", "moaz", "muath", "muadh", "osama", "usama", "hamza", "bilal", "mansour", "anwar",
        "hisham", "fathi", "mohannad", "ayoub", "zakaria", "sufyan", "sofian", "riyad", "riad", "nabil", "faisal",
        "emad", "imad", "essam", "mourad", "murad", "nasser", "wael", "hatem", "khalil", "ismail", "idris", "mousa",
        "musa", "issa", "suleiman", "sulaiman", "dawood", "akram", "ziad", "rami", "sami", "tamer", "shadi",
        "haitham", "qais", "ghaith", "anis", "mohsen", "alaa", "moataz", "mutaz", "majdi", "yahya", "younes", "yunus", "nizar", "ali", "abdo", "hamouda",
        "fatima", "fatma", "maryam", "mariam", "aisha", "aicha", "khadija", "sara", "sarah", "salma", "hiba", "heba",
        "kawtar", "kawthar", "amina", "zainab", "zeinab", "rehab", "souad", "najla", "hind", "rania", "reem",
        "ruqaya", "halima", "safia", "nisreen", "nesrine", "yasmin", "yasmine", "shaima", "manar", "esraa", "israa",
        "sumaya", "lamya", "razan", "lujain", "tasneem", "rawan", "marwa", "noha", "abeer", "wedad", "sanaa",
        "laila", "layla", "nadia", "samar", "ghada", "munira", "raneem",
    )

    val latinAbdSuffixes = listOf(
        "lah", "rahman", "rahim", "salam", "hamid", "aziz", "basit", "baset", "hakim", "raouf", "monem", "moneim",
        "karim", "majid", "wahab", "qader", "kader", "latif", "nasser", "razzaq", "ghani", "jalil", "fattah", "muttalib",
    )

    val arabicPlaces = listOf(
        "طرابلس", "بنغازي", "مصراتة", "الزاوية", "سبها", "درنة", "طبرق", "البيضاء", "زليتن", "غريان", "اجدابيا",
        "سرت", "ترهونة", "الخمس", "صبراتة", "زوارة", "الكفرة", "مرزق", "يفرن", "نالوت", "بني وليد", "تاجوراء",
        "جنزور", "الزنتان", "غدامس", "أوباري", "غات", "شحات", "المرج", "الأبيار", "توكرة", "قمينس", "العجيلات",
        "صرمان", "ككلة", "الأصابعة", "مزدة", "القره بوللي", "مسلاتة", "الجفرة", "سوكنة", "براك", "القطرون", "جالو",
        "أوجلة", "البريقة", "راس لانوف", "ودان", "الرجبان",
        // neighbourhoods
        "سوق الجمعة", "عين زارة", "قرقارش", "حي الأندلس", "بن عاشور", "الظهرة", "فشلوم", "أبوسليم", "أبو سليم",
        "الفرناج", "الدريبي", "غوط الشعال", "النوفليين", "زاوية الدهماني", "الكيش", "السلماني", "الفويهات",
        "الليثي", "سيدي حسين", "الصابري", "بوعطني", "قاريونس", "الهواري", "الزروق",
    )

    val latinPlaces = listOf(
        "tripoli", "trablus", "tarablus", "trabls", "benghazi", "bengazi", "misrata", "misurata", "msrata",
        "zawiya", "zawia", "zawya", "sebha", "sabha", "derna", "darna", "tobruk", "tubruq", "bayda", "baida",
        "zliten", "zlitin", "gharyan", "ghiryan", "ajdabiya", "ajdabia", "sirte", "sirt", "tarhuna", "tarhouna",
        "khoms", "sabratha", "sabratah", "zuwara", "zuwarah", "kufra", "murzuq", "yefren", "yafran", "nalut",
        "bani walid", "tajoura", "tajura", "janzour", "zintan", "ghadames", "ubari", "marj", "brak", "jalu",
        "brega", "souq aljumaa", "souq al jumaa", "ain zara", "gargaresh", "hay alandalus", "abu salim",
        "abusalim", "fashloum", "dahra", "sidi hussein", "garyounis",
    )

    /** Words that put a place right after them: «جامعة طرابلس», "university of tripoli". */
    val arabicPlaceMarkers = listOf("جامعة", "مدرسة", "مستشفى", "شركة", "شارع")
    val latinPlaceMarkers = listOf("university of", "uni of", "jami3at", "madrasat")

    /** Kinship words and titles: the next word is usually a name («خوي سند», "khoya sanad"). */
    val arabicKin = listOf(
        "خوي", "خويا", "خوية", "اخوي", "ختي", "اختي", "خوتي", "امي", "ماما", "بوي", "بويا", "ابوي", "بابا",
        "عمي", "عمتي", "خالي", "خالتي", "جدي", "جدتي", "نسيبي", "راجلي", "مرتي", "زوجي", "زوجتي", "خطيبي",
        "خطيبتي", "صاحبي", "صاحبتي", "صديقي", "صديقتي", "الدكتور", "الدكتورة", "دكتور",
        "دكتورة", "الاستاذ", "الاستاذة", "استاذ", "استاذة", "المعلم", "المعلمة", "الشيخ", "الحاج",
        "الحاجة", "عمو", "خالو", "اسمي", "اسمه", "اسمها",
    )
    val latinKin = listOf(
        "khoya", "khouya", "khoy", "khuya", "okhti", "o5ti", "ukhti", "khti", "khouti", "ommi", "omi", "oumi",
        "mama", "baba", "bouya", "bouy", "abouya", "3ammi", "3ami", "3amti", "khali", "khalti", "jeddi", "jaddi",
        "sa7bi", "sahbi", "sa7bti", "sahbti", "rajli", "marti", "zawji", "khatibi", "khatibti",
        "doctor", "dr", "doktor", "ostath", "ostaz", "ustadh", "oustaz", "cheikh", "sheikh", "haj", "hajja",
        "esmi", "ismi", "esmo", "esmha",
    )

    /** Common words that follow a kinship word and are not names. */
    val stopwords = setOf(
        "ديما", "دايما", "ديمة", "ما", "مش", "موش", "قال", "قالي", "قاللي", "كان", "كانت", "توا", "هو", "هي",
        "في", "من", "على", "عليا", "عليه", "او", "أو", "الكبير", "الكبيرة", "الصغير", "الصغيرة", "الكبار",
        "الصغار", "اللي", "هذا", "هذي", "هاذا", "هاذي", "برضو", "زاده", "زادة", "هلبا", "شوية", "بس", "لين",
        "حتى", "كل", "مرة", "يوم", "ليا", "لي", "عندي", "عنده", "عندها", "معاي", "معاه", "معاها", "انا", "أنا",
        "انت", "إنت", "انتي", "احنا", "هما", "الله", "والله", "خلاص", "مريض", "مريضة", "تعبان", "تعبانة",
        "w", "wa", "ou", "dayman", "dima", "ma", "mich", "mouch", "mush", "kan", "kanet", "9al", "9alli", "galli",
        "f", "fi", "fel", "men", "min", "mel", "3la", "3liya", "howa", "hiya", "el", "l", "elli", "illi", "lkbir",
        "kbir", "sghir", "s8ir", "barsha", "chwaya", "shwaya", "bas", "ken", "kol", "kull", "yom", "3andi",
        "m3aya", "ana", "enti", "inti", "nti", "a7na", "homa", "toa", "tawa", "taw", "hadha", "hadhi", "zeda",
        "the", "is", "and", "my", "said", "always", "was",
    )
}
