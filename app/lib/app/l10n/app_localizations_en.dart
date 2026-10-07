// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Khutwa';

  @override
  String get switchLanguage => 'العربية';

  @override
  String get back => 'Back';

  @override
  String get continueLabel => 'Continue';

  @override
  String get welcomeGreeting => 'Hey! I\'m ';

  @override
  String get welcomeSubtitle =>
      'Let\'s work together, one step at a time, to help you feel calmer, ease stress and lighten your mind.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsAnd => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get consentTitle => 'Before we start';

  @override
  String get consentSubtitle => 'A few things you should know about Khutwa.';

  @override
  String get consentPointCompanion =>
      'I\'m an AI companion, not a doctor or therapist, and I\'m not an emergency service.';

  @override
  String get consentPointPrivacy =>
      'What you write stays on your device. I never send any message on your behalf.';

  @override
  String get consentPointUrgent =>
      'If you ever feel unsafe, tap Urgent at the top of any screen.';

  @override
  String get consentCheckAge => 'I am 13 years old or older';

  @override
  String get consentCheckUnderstand =>
      'I understand Khutwa doesn\'t replace professional help or emergency services';

  @override
  String get consentCheckTermsPrefix => 'I accept the ';

  @override
  String get consentAgree => 'I agree, let\'s start';

  @override
  String get nicknameTitle => 'What do I call you?';

  @override
  String get nicknameSubtitle =>
      'Our conversations are private and anonymous. No login is needed. Just set a nickname and we\'re good to go!';

  @override
  String get nicknameHint => 'Type a nickname...';

  @override
  String get nicknameRequired => 'Please enter a nickname';

  @override
  String nicknameTooLong(int max) {
    return 'Nickname must be $max characters or fewer';
  }

  @override
  String ageTitle(String name) {
    return '$name, how old are you?';
  }

  @override
  String get ageSubtitle =>
      'I want to make sure I\'m giving you the right kind of support. I\'m an AI-powered wellbeing companion, and you can also connect with a human coach along the way.';

  @override
  String get ageUnder13 => 'Under 13 years old';

  @override
  String get ageTeen => '13-17 years old';

  @override
  String get ageAdult => '18 years and older';

  @override
  String get personalityTitle => 'How should I talk to you?';

  @override
  String get personalitySubtitle =>
      'Pick my personality. You can always change this from the settings later.';

  @override
  String get personalityWarmTitle => 'Warm (Khutwa Original)';

  @override
  String get personalityWarmDesc =>
      'I\'ll be gentle and encouraging, and we\'ll take things at your pace';

  @override
  String get personalityDirectTitle => 'Direct';

  @override
  String get personalityDirectDesc =>
      'I\'ll skip the extra talk and keep it simple';

  @override
  String get maybeLater => 'Maybe later';

  @override
  String get supportTitle => 'Let\'s find the right support for you';

  @override
  String get supportSubtitle => 'Choose a style that works best for you';

  @override
  String get supportSelfCareTitle => 'Self-care';

  @override
  String get supportSelfCareDesc => 'I prefer working on challenges by myself';

  @override
  String get supportGuidedTitle => 'Guided support';

  @override
  String get supportGuidedDesc =>
      'I would work with a therapist if it were affordable';

  @override
  String get urgentLabel => 'Urgent';

  @override
  String get urgentTitle => 'Do you need help right now?';

  @override
  String get urgentBody =>
      'If you are in danger or thinking about hurting yourself, contact emergency services or a trusted adult right away. You are not alone.';

  @override
  String get urgentCallNow => 'Call';

  @override
  String urgentCallFailed(String number) {
    return 'Couldn\'t open the dialer. Please call $number.';
  }

  @override
  String get urgentTipAdult =>
      'Go to a trusted adult near you — a parent, relative or teacher.';

  @override
  String get urgentTipBreathe =>
      'Breathe slowly: in for 4 seconds, hold for 4, out for 6.';

  @override
  String get close => 'Close';

  @override
  String get chatHint => 'Send a message';

  @override
  String chatTooLong(int max) {
    return 'Messages must be $max characters or fewer';
  }

  @override
  String get chatSend => 'Send';

  @override
  String get chatVoice => 'Voice message';

  @override
  String get chatListen => 'Listen';

  @override
  String get comingSoon => 'This feature is coming soon';

  @override
  String chatWarm1(String name) {
    return 'Hey $name — let\'s keep this first chat relaxed and simply get to know each other a little, with nothing to fix or fill out. What\'s been taking up most of your time lately: work, study, or something else?';
  }

  @override
  String chatWarm2(String answer) {
    return 'Got it, “$answer” is the main thing right now. Outside that, what\'s something you actually enjoy?';
  }

  @override
  String chatWarm3(String answer) {
    return '“$answer” is a lovely escape. Quick one before we wrap this intro: what\'s been on your mind lately, and how does it make you feel?';
  }

  @override
  String chatDirect1(String name) {
    return 'Hi $name. Quick intro: what takes up most of your time — work, study, or something else?';
  }

  @override
  String chatDirect2(String answer) {
    return 'OK: “$answer”. What do you enjoy outside of that?';
  }

  @override
  String get chatDirect3 =>
      'Good. Last one: what\'s on your mind these days, and how do you feel about it?';

  @override
  String get chatFallback => 'I\'m listening. Tell me more.';

  @override
  String get reflectionTitle => 'What I understood';

  @override
  String reflectionBody(String topic, String feeling) {
    return 'From what you shared, it sounds like “$topic” takes up a lot of your day, and you\'re going through $feeling. What you feel makes sense, and it\'s good that you talked about it.';
  }

  @override
  String get reflectionDisclaimer =>
      'AI reflection — it may not be exactly right.';

  @override
  String get reflectionSeeSuggestions => 'Show me support options';

  @override
  String get feelingStressed => 'stress and pressure';

  @override
  String get feelingAnxious => 'anxiety';

  @override
  String get feelingSad => 'sadness';

  @override
  String get feelingAngry => 'anger';

  @override
  String get feelingLonely => 'loneliness';

  @override
  String get feelingUnclear => 'something heavy';

  @override
  String get suggestionsTitle => 'Steps that may help';

  @override
  String get suggestionsSubtitle =>
      'I picked these based on what you shared. Choose one.';

  @override
  String get suggestionsWhy => 'Why this suggestion?';

  @override
  String get suggestionsWriteDraft => 'Write a draft';

  @override
  String get suggestionTrustedAdultTitle => 'Talk to a trusted adult';

  @override
  String get suggestionTrustedAdultDesc =>
      'A parent, relative or teacher you trust';

  @override
  String suggestionTrustedAdultWhy(String feeling) {
    return 'You mentioned you\'re going through $feeling. Sharing it with an adult you trust lightens the load and gets you real support.';
  }

  @override
  String get suggestionFriendTitle => 'Reach out to a friend';

  @override
  String get suggestionFriendDesc => 'Someone you feel comfortable with';

  @override
  String suggestionFriendWhy(String feeling) {
    return 'When you\'re feeling $feeling, talking to a friend reminds you that you\'re not alone.';
  }

  @override
  String get suggestionCounselorTitle => 'Message the school counselor';

  @override
  String get suggestionCounselorDesc =>
      'A specialist at your school or university';

  @override
  String suggestionCounselorWhy(String topic) {
    return 'Since “$topic” takes up so much of your time, a counselor can help you organize the pressure and find practical solutions.';
  }

  @override
  String get suggestionSpecialistTitle => 'Book a session with a specialist';

  @override
  String get suggestionSpecialistDesc =>
      'A consultation with a licensed professional';

  @override
  String get suggestionSpecialistWhy =>
      'You said you\'d work with a therapist if it were affordable. A short message is an easy first step to ask about options and costs.';

  @override
  String get suggestionSelfNoteTitle => 'Write a note to yourself';

  @override
  String get suggestionSelfNoteDesc => 'Kind words you can come back to';

  @override
  String get suggestionSelfNoteWhy =>
      'You prefer working on challenges by yourself. Writing kind words to yourself helps you see things more clearly.';

  @override
  String get draftTitle => 'Your draft';

  @override
  String get draftSubtitle =>
      'Edit it however you like, then copy it and send it yourself whenever you\'re ready.';

  @override
  String get draftNeverSent =>
      'Khutwa will never send this message. You decide if, when and how to send it.';

  @override
  String get draftCopy => 'Copy message';

  @override
  String get draftCopied => 'Copied to clipboard';

  @override
  String get draftReset => 'Restore original text';

  @override
  String draftTrustedAdult(String feeling) {
    return 'Hi, I need to talk to you about something that\'s been on my mind. Lately I\'ve been going through $feeling, and I don\'t know how to deal with it on my own. Can we sit down together soon?';
  }

  @override
  String draftFriend(String feeling) {
    return 'Hey! I miss talking with you. I\'m going through a time with a lot of $feeling... do you have time to talk soon?';
  }

  @override
  String draftCounselor(String feeling, String topic) {
    return 'Hello, I\'m a student and lately I\'ve been going through $feeling because of “$topic”. Could I book a time to talk with you?';
  }

  @override
  String draftSpecialist(String feeling) {
    return 'Hello, I\'d like to book a counseling session. Lately I\'ve been going through $feeling and would like to talk to a specialist. What times are available, and what does it cost?';
  }

  @override
  String draftSelfNote(String name, String feeling) {
    return 'Dear $name, I know you\'re going through $feeling right now, and that doesn\'t make you weak. You\'re doing your best, and every small step counts. Remember to be kind to yourself.';
  }

  @override
  String get consentPointAi => 'I\'m an AI, not a person.';

  @override
  String get consentPointRedaction =>
      'Before anything leaves your phone, names, places and numbers are removed automatically.';

  @override
  String get consentPointModel =>
      'The redacted text goes to a Google AI model through Khutwa\'s server.';

  @override
  String get consentPointNoStorage =>
      'Our server doesn\'t store or log what you write.';

  @override
  String get consentPointPlan => 'Your plan is saved on your phone only.';

  @override
  String get consentPointNotEmergency =>
      'Khutwa isn\'t an emergency service. If you\'re in danger, tap the urgent button at the top.';

  @override
  String get writeTitle => 'What\'s on your mind?';

  @override
  String get writeHint => 'Write like you\'d talk…';

  @override
  String get writeNext => 'See what will be sent';

  @override
  String get myPlan => 'My plan';

  @override
  String get privacyTitle => 'Before we send it';

  @override
  String get privacySubtitle =>
      'Tap any word to hide it. Tap it again to bring it back.';

  @override
  String get privacyOriginalLabel => 'What you wrote (stays on your phone)';

  @override
  String get privacyOutgoingLabel => 'This is what leaves your phone';

  @override
  String get privacyHonestLimit =>
      'Redaction can\'t remove everything, and context may still identify you';

  @override
  String get privacySend => 'Send';

  @override
  String get privacyError =>
      'Redaction failed on your phone. Nothing was sent.';

  @override
  String get reflectionWaiting => 'Reading what you wrote…';

  @override
  String get reflectionQuestionsTitle => 'Think about these while you wait:';

  @override
  String get reflectionQuestion1 => 'What\'s weighing on you most these days?';

  @override
  String get reflectionQuestion2 =>
      'Is there someone you feel at ease talking to?';

  @override
  String get reflectionQuestion3 =>
      'What helped you through a hard time before?';

  @override
  String get analysisErrorTitle => 'We couldn\'t reach the server';

  @override
  String get analysisErrorBody =>
      'Check your connection and try again. The urgent button works even offline.';

  @override
  String get retry => 'Try again';

  @override
  String get supportTypeTrustedFriend => 'A friend you trust';

  @override
  String get supportTypeAcademicAdviser => 'A teacher or academic adviser';

  @override
  String get supportTypeTrustedRelative => 'A relative you trust';

  @override
  String get supportTypeCommunityFigure =>
      'Someone you trust in your community';

  @override
  String get supportTypeSpecialist => 'A specialist';

  @override
  String get fallbackWhyFriend =>
      'Talking to someone who knows and cares about you lightens the load.';

  @override
  String get fallbackDraftFriend =>
      'Hi, something has been on my mind and I\'d like to talk to you about it. Do you have time soon?';

  @override
  String get fallbackWhyRelative =>
      'A family member you trust can be there for you.';

  @override
  String get fallbackDraftRelative =>
      'Hi, I\'d like to talk to you about something that\'s been weighing on me. Can we sit together?';

  @override
  String get fallbackWhySpecialist =>
      'A specialist listens in confidence and helps you with a clear plan.';

  @override
  String get fallbackDraftSpecialist =>
      'Hello, I\'d like to book a session. I\'ve been under a lot of pressure lately and want to talk to a specialist. What times are available?';

  @override
  String get draftSendYourself => 'You\'re the one who sends it';

  @override
  String get draftSaveToPlan => 'Save to my plan';

  @override
  String get planTitle => 'My plan';

  @override
  String get planSubtitle =>
      'Saved on your phone only, and opens without internet.';

  @override
  String get planSupportLabel => 'The step you chose';

  @override
  String get planDraftLabel => 'Your message';

  @override
  String get planCopingTitle => 'Things that can help right now';

  @override
  String planSavedOn(String date) {
    return 'Saved: $date';
  }

  @override
  String get planEmpty => 'You don\'t have a saved plan yet.';

  @override
  String get planDeleteAll => 'Delete everything';

  @override
  String get planDeleteConfirmTitle => 'Are you sure?';

  @override
  String get planDeleteConfirmBody =>
      'Everything in the app will be deleted: the plan, drafts and any saved text. This can\'t be undone.';

  @override
  String get planDeleteConfirm => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get planDeleted => 'Everything was deleted.';

  @override
  String get planStartOver => 'Start over';

  @override
  String get copingBreathingTitle => 'Breathe slowly';

  @override
  String get copingBreathingBody =>
      'Breathe in for 4 seconds, hold for 4, and breathe out slowly for 6. Repeat 4 times.';

  @override
  String get copingGroundingTitle => 'Come back to the moment';

  @override
  String get copingGroundingBody =>
      'Find 5 things you can see, 4 you can hear, 3 you can touch, 2 you can smell, and 1 you can taste.';

  @override
  String get copingMessageTitle => 'Message someone you trust';

  @override
  String get copingMessageBody =>
      'You don\'t have to say everything. \"Can we talk?\" is enough to start.';

  @override
  String get urgentScreenTitle => 'Do you need help right now?';

  @override
  String get urgentScreenBody =>
      'If you\'re in danger or thinking about hurting yourself, don\'t wait.';

  @override
  String get urgentStep1 => 'Tell a person near you right now.';

  @override
  String get urgentStep2 => 'Go to the nearest hospital emergency department.';

  @override
  String get urgentStep3Title => 'Verified contacts';

  @override
  String urgentVerifiedOn(String date) {
    return 'Verified: $date';
  }

  @override
  String urgentCallContact(String name) {
    return 'Call $name';
  }

  @override
  String get consentHeading => 'Our commitment to you.';

  @override
  String get consentIntro =>
      'Your mental health is personal. Before we start, here\'s what you should know:';

  @override
  String get consentToggle =>
      'I\'m 13 or older, I understand Khutwa doesn\'t replace professionals or emergency services, and I accept the Terms of Service and Privacy Policy.';

  @override
  String get chatTitle => 'Let\'s start simple.';

  @override
  String get chatIntro =>
      'Write what\'s on your mind, however feels natural. Before anything leaves your phone, names, places and numbers are removed.';

  @override
  String chatSentAs(String text) {
    return 'What left your phone: $text';
  }

  @override
  String get urgentSafetyTitle => 'Your safety matters most right now';

  @override
  String get urgentIntroAuto =>
      'Thank you for writing what\'s on your mind. What you wrote makes us want to be sure you\'re OK, and here are steps you can take right now.';

  @override
  String get urgentStepPerson =>
      'Tell someone near you now: a friend, a family member you trust, a neighbour, anyone you feel safe with. Don\'t stay alone.';

  @override
  String get urgentStepHospital =>
      'If you feel you might hurt yourself, go to the nearest hospital emergency department, or have someone take you.';

  @override
  String get urgentStepSafeSpace =>
      'Move away from anything that could hurt you, and stay somewhere with other people.';

  @override
  String get urgentContactsTitle => 'Numbers you can call';

  @override
  String urgentContactVerified(String date) {
    return 'We checked that this number answers on $date';
  }

  @override
  String get urgentContactDemo => 'Demo number – not real';

  @override
  String get urgentNoContacts =>
      'So far we couldn\'t confirm that any number answers, so we haven\'t listed any. You can take the steps above right now.';

  @override
  String get urgentMessageTitle => 'Write a message to someone you trust';

  @override
  String get urgentMessageText =>
      'I\'m not OK right now and I need you. Can you come or call me?';

  @override
  String get urgentCopy => 'Copy the message';

  @override
  String get urgentFooter =>
      'Khutwa is not an emergency service, and nobody reads your messages. These steps were written and reviewed by the team, not by the AI.';
}
