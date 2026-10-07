// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'خطوة';

  @override
  String get switchLanguage => 'English';

  @override
  String get back => 'رجوع';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get welcomeGreeting => 'مرحبًا! أنا ';

  @override
  String get welcomeSubtitle =>
      'لنعمل معًا خطوة بخطوة لتشعر بهدوء أكبر، وتخفف التوتر، وتريح بالك.';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get termsAnd => ' و';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get consentTitle => 'قبل أن نبدأ';

  @override
  String get consentSubtitle => 'أشياء مهمة يجب أن تعرفها عن خطوة.';

  @override
  String get consentPointCompanion =>
      'أنا رفيق يعمل بالذكاء الاصطناعي، لست طبيبًا أو معالجًا نفسيًا، ولست خدمة طوارئ.';

  @override
  String get consentPointPrivacy =>
      'ما تكتبه يبقى على جهازك، ولن أرسل أي رسالة نيابةً عنك أبدًا.';

  @override
  String get consentPointUrgent =>
      'إذا شعرت يومًا أنك لست بأمان، اضغط عاجل أعلى أي شاشة.';

  @override
  String get consentCheckAge => 'عمري 13 عامًا أو أكثر';

  @override
  String get consentCheckUnderstand =>
      'أفهم أن خطوة لا تغني عن المختصين أو خدمات الطوارئ';

  @override
  String get consentCheckTermsPrefix => 'أوافق على ';

  @override
  String get consentAgree => 'أوافق، نبدأ';

  @override
  String get nicknameTitle => 'بماذا أناديك؟';

  @override
  String get nicknameSubtitle =>
      'محادثاتنا خاصة ومجهولة الهوية. لا حاجة لتسجيل الدخول، فقط اختر اسمًا مستعارًا ونبدأ!';

  @override
  String get nicknameHint => 'اكتب اسمًا مستعارًا...';

  @override
  String get nicknameRequired => 'من فضلك اكتب اسمًا مستعارًا';

  @override
  String nicknameTooLong(int max) {
    return 'يجب ألا يزيد الاسم على $max حرفًا';
  }

  @override
  String ageTitle(String name) {
    return '$name، كم عمرك؟';
  }

  @override
  String get ageSubtitle =>
      'أريد التأكد من أنني أقدّم لك الدعم المناسب. أنا رفيق ذكي لصحتك النفسية، ويمكنك أيضًا التواصل مع مختص بشري متى أردت.';

  @override
  String get ageUnder13 => 'أقل من 13 عامًا';

  @override
  String get ageTeen => 'من 13 إلى 17 عامًا';

  @override
  String get ageAdult => '18 عامًا فأكثر';

  @override
  String get personalityTitle => 'كيف تحب أن أتحدث معك؟';

  @override
  String get personalitySubtitle =>
      'اختر شخصيتي. يمكنك دائمًا تغييرها من الإعدادات لاحقًا.';

  @override
  String get personalityWarmTitle => 'دافئ (أسلوب خطوة الأصلي)';

  @override
  String get personalityWarmDesc =>
      'سأكون لطيفًا ومشجعًا، ونمضي في الأمور على راحتك';

  @override
  String get personalityDirectTitle => 'مباشر';

  @override
  String get personalityDirectDesc => 'سأختصر الكلام الزائد وأبقي الأمور بسيطة';

  @override
  String get maybeLater => 'ربما لاحقًا';

  @override
  String get supportTitle => 'لنجد الدعم المناسب لك';

  @override
  String get supportSubtitle => 'اختر الأسلوب الأنسب لك';

  @override
  String get supportSelfCareTitle => 'رعاية ذاتية';

  @override
  String get supportSelfCareDesc => 'أفضّل العمل على تحدياتي بنفسي';

  @override
  String get supportGuidedTitle => 'دعم موجّه';

  @override
  String get supportGuidedDesc => 'سأعمل مع مختص نفسي لو كانت التكلفة مناسبة';

  @override
  String get urgentLabel => 'عاجل';

  @override
  String get urgentTitle => 'هل تحتاج مساعدة الآن؟';

  @override
  String get urgentBody =>
      'إذا كنت في خطر أو تفكر في إيذاء نفسك، تواصل فورًا مع الطوارئ أو مع شخص بالغ تثق به. أنت لست وحدك.';

  @override
  String get urgentCallNow => 'اتصل';

  @override
  String urgentCallFailed(String number) {
    return 'تعذّر فتح الاتصال. اتصل بالرقم $number.';
  }

  @override
  String get urgentTipAdult =>
      'اذهب إلى شخص بالغ تثق به قريب منك — أحد والديك، قريب، أو معلم.';

  @override
  String get urgentTipBreathe => 'تنفّس ببطء: شهيق 4 ثوانٍ، احبس 4، زفير 6.';

  @override
  String get close => 'إغلاق';

  @override
  String get chatHint => 'اكتب رسالة';

  @override
  String chatTooLong(int max) {
    return 'يجب ألا تزيد الرسالة على $max حرف';
  }

  @override
  String get chatSend => 'إرسال';

  @override
  String get chatVoice => 'رسالة صوتية';

  @override
  String get chatListen => 'استماع';

  @override
  String get comingSoon => 'هذه الميزة قادمة قريبًا';

  @override
  String chatWarm1(String name) {
    return 'أهلًا $name — لنجعل محادثتنا الأولى هادئة ونتعرف على بعضنا قليلًا، دون أي شيء لإصلاحه أو تعبئته. ما الذي يشغل معظم وقتك مؤخرًا: العمل، الدراسة، أم شيء آخر؟';
  }

  @override
  String chatWarm2(String answer) {
    return 'فهمت، «$answer» يأخذ الجزء الأكبر من وقتك الآن. وبعيدًا عن ذلك، ما الشيء الذي تستمتع به فعلًا؟';
  }

  @override
  String chatWarm3(String answer) {
    return '«$answer» متنفّس جميل. سؤال أخير: ما الذي يدور في ذهنك مؤخرًا، وبماذا يشعرك؟';
  }

  @override
  String chatDirect1(String name) {
    return 'أهلًا $name. لنتعرف بسرعة: ما الذي يشغل معظم وقتك — العمل، الدراسة، أم غير ذلك؟';
  }

  @override
  String chatDirect2(String answer) {
    return 'تمام: «$answer». وما الذي تستمتع به خارج ذلك؟';
  }

  @override
  String get chatDirect3 =>
      'جيد. أخيرًا: ما الذي يشغل بالك هذه الأيام، وبماذا تشعر تجاهه؟';

  @override
  String get chatFallback => 'أنا أسمعك. أخبرني المزيد.';

  @override
  String get reflectionTitle => 'ما فهمته منك';

  @override
  String reflectionBody(String topic, String feeling) {
    return 'مما شاركته، يبدو أن «$topic» يأخذ مساحة كبيرة من يومك، وأنك تمرّ ب$feeling. ما تشعر به مفهوم، ومن الجيد أنك تحدثت عنه.';
  }

  @override
  String get reflectionDisclaimer =>
      'انعكاس بالذكاء الاصطناعي — قد لا يكون دقيقًا تمامًا.';

  @override
  String get reflectionSeeSuggestions => 'اعرض لي خيارات الدعم';

  @override
  String get feelingStressed => 'ضغط وتوتر';

  @override
  String get feelingAnxious => 'قلق';

  @override
  String get feelingSad => 'حزن';

  @override
  String get feelingAngry => 'غضب';

  @override
  String get feelingLonely => 'شعور بالوحدة';

  @override
  String get feelingUnclear => 'شيء يثقل عليك';

  @override
  String get suggestionsTitle => 'خطوات قد تساعدك';

  @override
  String get suggestionsSubtitle =>
      'اخترت لك هذه الاقتراحات بناءً على ما شاركته. اختر واحدًا.';

  @override
  String get suggestionsWhy => 'لماذا هذا الاقتراح؟';

  @override
  String get suggestionsWriteDraft => 'اكتب مسودة';

  @override
  String get suggestionTrustedAdultTitle => 'تحدث مع شخص بالغ تثق به';

  @override
  String get suggestionTrustedAdultDesc => 'أحد والديك، قريب، أو معلم تثق به';

  @override
  String suggestionTrustedAdultWhy(String feeling) {
    return 'ذكرت أنك تمرّ ب$feeling. مشاركة ما تشعر به مع شخص بالغ تثق به تخفف الحمل وتمنحك دعمًا حقيقيًا.';
  }

  @override
  String get suggestionFriendTitle => 'تواصل مع صديق';

  @override
  String get suggestionFriendDesc => 'شخص ترتاح للحديث معه';

  @override
  String suggestionFriendWhy(String feeling) {
    return 'حين تمرّ ب$feeling، يذكّرك الحديث مع صديق بأنك لست وحدك.';
  }

  @override
  String get suggestionCounselorTitle => 'راسل المرشد الطلابي';

  @override
  String get suggestionCounselorDesc => 'مختص في مدرستك أو جامعتك';

  @override
  String suggestionCounselorWhy(String topic) {
    return 'بما أن «$topic» يأخذ الكثير من وقتك، يستطيع المرشد مساعدتك على تنظيم الضغط وإيجاد حلول عملية.';
  }

  @override
  String get suggestionSpecialistTitle => 'احجز جلسة مع مختص';

  @override
  String get suggestionSpecialistDesc => 'استشارة مع مختص مرخّص';

  @override
  String get suggestionSpecialistWhy =>
      'قلت إنك ستعمل مع مختص لو كانت التكلفة مناسبة. رسالة قصيرة خطوة أولى سهلة للسؤال عن الخيارات والتكلفة.';

  @override
  String get suggestionSelfNoteTitle => 'اكتب رسالة لنفسك';

  @override
  String get suggestionSelfNoteDesc => 'كلمات لطيفة تعود إليها لاحقًا';

  @override
  String get suggestionSelfNoteWhy =>
      'تفضّل العمل على تحدياتك بنفسك. كتابة كلمات لطيفة لنفسك تساعدك على رؤية الأمور بوضوح أكبر.';

  @override
  String get draftTitle => 'مسودتك';

  @override
  String get draftSubtitle =>
      'عدّلها كما تريد، ثم انسخها وأرسلها بنفسك متى كنت مستعدًا.';

  @override
  String get draftNeverSent =>
      'لن يرسل خطوة هذه الرسالة أبدًا. أنت من يقرر هل ومتى وكيف ترسلها.';

  @override
  String get draftCopy => 'نسخ الرسالة';

  @override
  String get draftCopied => 'تم النسخ';

  @override
  String get draftReset => 'استعادة النص الأصلي';

  @override
  String draftTrustedAdult(String feeling) {
    return 'مرحبًا، أحتاج أن أتحدث معك في شيء يشغلني. مؤخرًا أمرّ ب$feeling، ولا أعرف كيف أتعامل معه وحدي. هل يمكن أن نجلس معًا قريبًا؟';
  }

  @override
  String draftFriend(String feeling) {
    return 'أهلًا! اشتقت للحديث معك. أمرّ بفترة فيها $feeling... هل عندك وقت نتكلم قريبًا؟';
  }

  @override
  String draftCounselor(String feeling, String topic) {
    return 'مرحبًا، أنا طالب/ة وأمرّ مؤخرًا ب$feeling بسبب «$topic». هل يمكنني حجز وقت للحديث معك؟';
  }

  @override
  String draftSpecialist(String feeling) {
    return 'مرحبًا، أرغب في حجز استشارة نفسية. أمرّ مؤخرًا ب$feeling وأود الحديث مع مختص. ما المواعيد المتاحة وما التكلفة؟';
  }

  @override
  String draftSelfNote(String name, String feeling) {
    return 'عزيزي $name، أعرف أنك تمرّ الآن ب$feeling، وهذا لا يعني أنك ضعيف. أنت تبذل جهدك، وكل خطوة صغيرة تُحسب. تذكّر أن تكون لطيفًا مع نفسك.';
  }

  @override
  String get consentPointAi => 'أنا ذكاء اصطناعي، مش إنسان.';

  @override
  String get consentPointRedaction =>
      'قبل ما يطلع أي كلام من تلفونك، نشيلو منه الأسماء والأماكن والأرقام بشكل تلقائي.';

  @override
  String get consentPointModel =>
      'الكلام بعد الحذف يمشي لنموذج ذكاء اصطناعي من Google عن طريق خادم خطوة.';

  @override
  String get consentPointNoStorage => 'خادمنا ما يخزّنش ولا يسجّل كلامك.';

  @override
  String get consentPointPlan => 'خطتك تتحفظ على تلفونك بس.';

  @override
  String get consentPointNotEmergency =>
      'خطوة مش خدمة طوارئ. لو انت في خطر، اضغط زر الطوارئ فوق.';

  @override
  String get writeTitle => 'شن اللي في بالك؟';

  @override
  String get writeHint => 'اكتب زي ما تحكي…';

  @override
  String get writeNext => 'شوف شن اللي بيطلع';

  @override
  String get myPlan => 'خطتي';

  @override
  String get privacyTitle => 'قبل ما نبعتو';

  @override
  String get privacySubtitle =>
      'اضغط على أي كلمة باش تخفيها، واضغط عليها مرة ثانية باش ترجعها.';

  @override
  String get privacyOriginalLabel => 'كلامك (يبقى في تلفونك)';

  @override
  String get privacyOutgoingLabel => 'هذا اللي بيطلع من تلفونك';

  @override
  String get privacyHonestLimit =>
      'الحذف ما يقدرش يشيل كل شي، والسياق ممكن يعرّف بيك';

  @override
  String get privacySend => 'ابعت';

  @override
  String get privacyError => 'صار خطأ في الحذف على تلفونك. ما طلعش أي كلام.';

  @override
  String get reflectionWaiting => 'قاعدين نقروا كلامك…';

  @override
  String get reflectionQuestionsTitle => 'فكّر في هالأسئلة وانت تستنى:';

  @override
  String get reflectionQuestion1 => 'شن أكثر حاجة تتعبك هالأيام؟';

  @override
  String get reflectionQuestion2 => 'فيه حد ترتاح لما تحكي معاه؟';

  @override
  String get reflectionQuestion3 => 'شن اللي ساعدك قبل في وقت صعب؟';

  @override
  String get analysisErrorTitle => 'ما قدرناش نوصلو للخادم';

  @override
  String get analysisErrorBody =>
      'تأكد من الإنترنت وجرّب مرة ثانية. زر الطوارئ يخدم حتى من غير إنترنت.';

  @override
  String get retry => 'جرّب مرة ثانية';

  @override
  String get supportTypeTrustedFriend => 'صديق تثق فيه';

  @override
  String get supportTypeAcademicAdviser => 'أستاذ أو مرشد أكاديمي';

  @override
  String get supportTypeTrustedRelative => 'قريب تثق فيه';

  @override
  String get supportTypeCommunityFigure => 'شخص من المجتمع تثق فيه';

  @override
  String get supportTypeSpecialist => 'أخصائي';

  @override
  String get fallbackWhyFriend => 'الحكي مع حد يعرفك ويحبك يخفف الحمل.';

  @override
  String get fallbackDraftFriend =>
      'أهلين، فيه حاجة شاغلة بالي ونبي نحكي معاك فيها. عندك وقت قريب؟';

  @override
  String get fallbackWhyRelative => 'حد من العيلة تثق فيه يقدر يكون جنبك.';

  @override
  String get fallbackDraftRelative =>
      'السلام، نبي نحكي معاك في حاجة تعبتني شوية. نقدرو نقعدو مع بعض؟';

  @override
  String get fallbackWhySpecialist =>
      'الأخصائي يسمعك بسرية ويساعدك بخطة واضحة.';

  @override
  String get fallbackDraftSpecialist =>
      'السلام عليكم، نبي نحجز جلسة. نحس بضغط هالأيام ونبي نحكي مع مختص. شن المواعيد المتاحة؟';

  @override
  String get draftSendYourself => 'انت اللي تبعتها';

  @override
  String get draftSaveToPlan => 'احفظ في خطتي';

  @override
  String get planTitle => 'خطتي';

  @override
  String get planSubtitle => 'محفوظة في تلفونك بس، وتفتح حتى من غير إنترنت.';

  @override
  String get planSupportLabel => 'الخطوة اللي اخترتها';

  @override
  String get planDraftLabel => 'رسالتك';

  @override
  String get planCopingTitle => 'حاجات تساعدك توا';

  @override
  String planSavedOn(String date) {
    return 'اتحفظت: $date';
  }

  @override
  String get planEmpty => 'ما عندكش خطة محفوظة لتوا.';

  @override
  String get planDeleteAll => 'امسح كل شي';

  @override
  String get planDeleteConfirmTitle => 'متأكد؟';

  @override
  String get planDeleteConfirmBody =>
      'بيتمسح كل شي من التطبيق: الخطة والمسودات وأي كلام محفوظ. ما فيش رجعة.';

  @override
  String get planDeleteConfirm => 'امسح';

  @override
  String get cancel => 'إلغاء';

  @override
  String get planDeleted => 'تم مسح كل شي.';

  @override
  String get planStartOver => 'ابدأ من جديد';

  @override
  String get copingBreathingTitle => 'تنفّس ببطء';

  @override
  String get copingBreathingBody =>
      'دخّل النفس 4 ثواني، شدّه 4، وطلّعه بشوية في 6. عاودها 4 مرات.';

  @override
  String get copingGroundingTitle => 'رجّع روحك للحظة';

  @override
  String get copingGroundingBody =>
      'دوّر على 5 حاجات تشوفها، 4 تسمعها، 3 تلمسها، 2 تشمها، وحاجة وحدة تذوقها.';

  @override
  String get copingMessageTitle => 'ابعت لحد تثق فيه';

  @override
  String get copingMessageBody =>
      'مش لازم تحكي كل شي. «نبي نحكي معاك» تكفي كبداية.';

  @override
  String get urgentScreenTitle => 'محتاج مساعدة توا؟';

  @override
  String get urgentScreenBody => 'لو انت في خطر أو تفكر تأذي روحك، ما تستناش.';

  @override
  String get urgentStep1 => 'قول لشخص قريب منك توا.';

  @override
  String get urgentStep2 => 'امشي لأقرب قسم طوارئ في مستشفى.';

  @override
  String get urgentStep3Title => 'أرقام تم التحقق منها';

  @override
  String urgentVerifiedOn(String date) {
    return 'تم التحقق: $date';
  }

  @override
  String urgentCallContact(String name) {
    return 'اتصل بـ $name';
  }

  @override
  String get consentHeading => 'التزامنا معاك.';

  @override
  String get consentIntro =>
      'صحتك النفسية حاجة تخصك. قبل ما نبدأ، هذا اللي لازم تعرفه:';

  @override
  String get consentToggle =>
      'عمري 13 أو أكثر، وفاهم إن خطوة مش بديل عن المختصين أو الطوارئ، وموافق على شروط الخدمة وسياسة الخصوصية.';

  @override
  String get chatTitle => 'خلينا نبدأ ببساطة.';

  @override
  String get chatIntro =>
      'اكتب اللي في بالك بالطريقة اللي تريحك. قبل ما يطلع أي كلام من تلفونك، نشيلو منه الأسماء والأماكن والأرقام.';

  @override
  String chatSentAs(String text) {
    return 'اللي طلع من تلفونك: $text';
  }

  @override
  String get urgentSafetyTitle => 'سلامتك أهم حاجة توا';

  @override
  String get urgentIntroAuto =>
      'شكراً إنك كتبت اللي في قلبك. اللي كتبته يخلينا نبو نتأكد إنك بخير، وهذي خطوات تقدر تديرها توا.';

  @override
  String get urgentStepPerson =>
      'قول لحد قريب منك توا: صاحبك، حد من العيلة تثق فيه، جارك، أي حد تحس روحك معاه في أمان. ما تقعدش وحدك.';

  @override
  String get urgentStepHospital =>
      'لو حاسس إنك ممكن تأذي روحك، امشي لأقرب مستشفى، قسم الطوارئ، أو خلي حد يوصلك.';

  @override
  String get urgentStepSafeSpace =>
      'بعّد على روحك أي حاجة ممكن تأذيك، وخليك في مكان فيه ناس.';

  @override
  String get urgentContactsTitle => 'أرقام تقدر تتصل بيها';

  @override
  String urgentContactVerified(String date) {
    return 'تأكدنا إن الرقم هذا يرد يوم $date';
  }

  @override
  String get urgentContactDemo => 'رقم تجريبي – مش حقيقي';

  @override
  String get urgentNoContacts =>
      'لين توا ما قدرناش نتأكد من أي رقم يرد، عشان هكي ما حطيناش أرقام. الخطوات اللي فوق تقدر تديرها توا.';

  @override
  String get urgentMessageTitle => 'اكتب رسالة لحد تثق فيه';

  @override
  String get urgentMessageText =>
      'أنا مش كويس توا ومحتاجك. تقدر تجيني أو تكلمني؟';

  @override
  String get urgentCopy => 'انسخ الرسالة';

  @override
  String get urgentFooter =>
      'خطوة مش خدمة طوارئ، وما فيش حد يقرا كلامك. الخطوات هذي مكتوبة ومراجعة من الفريق، مش من الذكاء الاصطناعي.';
}
