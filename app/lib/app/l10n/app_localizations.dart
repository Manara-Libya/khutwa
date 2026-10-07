import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Khutwa'**
  String get appName;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get switchLanguage;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hey! I\'m '**
  String get welcomeGreeting;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s work together, one step at a time, to help you feel calmer, ease stress and lighten your mind.'**
  String get welcomeSubtitle;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get termsAnd;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'Before we start'**
  String get consentTitle;

  /// No description provided for @consentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few things you should know about Khutwa.'**
  String get consentSubtitle;

  /// No description provided for @consentPointCompanion.
  ///
  /// In en, this message translates to:
  /// **'I\'m an AI companion, not a doctor or therapist, and I\'m not an emergency service.'**
  String get consentPointCompanion;

  /// No description provided for @consentPointPrivacy.
  ///
  /// In en, this message translates to:
  /// **'What you write stays on your device. I never send any message on your behalf.'**
  String get consentPointPrivacy;

  /// No description provided for @consentPointUrgent.
  ///
  /// In en, this message translates to:
  /// **'If you ever feel unsafe, tap Urgent at the top of any screen.'**
  String get consentPointUrgent;

  /// No description provided for @consentCheckAge.
  ///
  /// In en, this message translates to:
  /// **'I am 13 years old or older'**
  String get consentCheckAge;

  /// No description provided for @consentCheckUnderstand.
  ///
  /// In en, this message translates to:
  /// **'I understand Khutwa doesn\'t replace professional help or emergency services'**
  String get consentCheckUnderstand;

  /// No description provided for @consentCheckTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I accept the '**
  String get consentCheckTermsPrefix;

  /// No description provided for @consentAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree, let\'s start'**
  String get consentAgree;

  /// No description provided for @nicknameTitle.
  ///
  /// In en, this message translates to:
  /// **'What do I call you?'**
  String get nicknameTitle;

  /// No description provided for @nicknameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our conversations are private and anonymous. No login is needed. Just set a nickname and we\'re good to go!'**
  String get nicknameSubtitle;

  /// No description provided for @nicknameHint.
  ///
  /// In en, this message translates to:
  /// **'Type a nickname...'**
  String get nicknameHint;

  /// No description provided for @nicknameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname'**
  String get nicknameRequired;

  /// No description provided for @nicknameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Nickname must be {max} characters or fewer'**
  String nicknameTooLong(int max);

  /// No description provided for @ageTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}, how old are you?'**
  String ageTitle(String name);

  /// No description provided for @ageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I want to make sure I\'m giving you the right kind of support. I\'m an AI-powered wellbeing companion, and you can also connect with a human coach along the way.'**
  String get ageSubtitle;

  /// No description provided for @ageUnder13.
  ///
  /// In en, this message translates to:
  /// **'Under 13 years old'**
  String get ageUnder13;

  /// No description provided for @ageTeen.
  ///
  /// In en, this message translates to:
  /// **'13-17 years old'**
  String get ageTeen;

  /// No description provided for @ageAdult.
  ///
  /// In en, this message translates to:
  /// **'18 years and older'**
  String get ageAdult;

  /// No description provided for @personalityTitle.
  ///
  /// In en, this message translates to:
  /// **'How should I talk to you?'**
  String get personalityTitle;

  /// No description provided for @personalitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick my personality. You can always change this from the settings later.'**
  String get personalitySubtitle;

  /// No description provided for @personalityWarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Warm (Khutwa Original)'**
  String get personalityWarmTitle;

  /// No description provided for @personalityWarmDesc.
  ///
  /// In en, this message translates to:
  /// **'I\'ll be gentle and encouraging, and we\'ll take things at your pace'**
  String get personalityWarmDesc;

  /// No description provided for @personalityDirectTitle.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get personalityDirectTitle;

  /// No description provided for @personalityDirectDesc.
  ///
  /// In en, this message translates to:
  /// **'I\'ll skip the extra talk and keep it simple'**
  String get personalityDirectDesc;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get maybeLater;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s find the right support for you'**
  String get supportTitle;

  /// No description provided for @supportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a style that works best for you'**
  String get supportSubtitle;

  /// No description provided for @supportSelfCareTitle.
  ///
  /// In en, this message translates to:
  /// **'Self-care'**
  String get supportSelfCareTitle;

  /// No description provided for @supportSelfCareDesc.
  ///
  /// In en, this message translates to:
  /// **'I prefer working on challenges by myself'**
  String get supportSelfCareDesc;

  /// No description provided for @supportGuidedTitle.
  ///
  /// In en, this message translates to:
  /// **'Guided support'**
  String get supportGuidedTitle;

  /// No description provided for @supportGuidedDesc.
  ///
  /// In en, this message translates to:
  /// **'I would work with a therapist if it were affordable'**
  String get supportGuidedDesc;

  /// No description provided for @urgentLabel.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgentLabel;

  /// No description provided for @urgentTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you need help right now?'**
  String get urgentTitle;

  /// No description provided for @urgentBody.
  ///
  /// In en, this message translates to:
  /// **'If you are in danger or thinking about hurting yourself, contact emergency services or a trusted adult right away. You are not alone.'**
  String get urgentBody;

  /// No description provided for @urgentCallNow.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get urgentCallNow;

  /// No description provided for @urgentCallFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the dialer. Please call {number}.'**
  String urgentCallFailed(String number);

  /// No description provided for @urgentTipAdult.
  ///
  /// In en, this message translates to:
  /// **'Go to a trusted adult near you — a parent, relative or teacher.'**
  String get urgentTipAdult;

  /// No description provided for @urgentTipBreathe.
  ///
  /// In en, this message translates to:
  /// **'Breathe slowly: in for 4 seconds, hold for 4, out for 6.'**
  String get urgentTipBreathe;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Send a message'**
  String get chatHint;

  /// No description provided for @chatTooLong.
  ///
  /// In en, this message translates to:
  /// **'Messages must be {max} characters or fewer'**
  String chatTooLong(int max);

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice message'**
  String get chatVoice;

  /// No description provided for @chatListen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get chatListen;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon'**
  String get comingSoon;

  /// No description provided for @chatWarm1.
  ///
  /// In en, this message translates to:
  /// **'Hey {name} — let\'s keep this first chat relaxed and simply get to know each other a little, with nothing to fix or fill out. What\'s been taking up most of your time lately: work, study, or something else?'**
  String chatWarm1(String name);

  /// No description provided for @chatWarm2.
  ///
  /// In en, this message translates to:
  /// **'Got it, “{answer}” is the main thing right now. Outside that, what\'s something you actually enjoy?'**
  String chatWarm2(String answer);

  /// No description provided for @chatWarm3.
  ///
  /// In en, this message translates to:
  /// **'“{answer}” is a lovely escape. Quick one before we wrap this intro: what\'s been on your mind lately, and how does it make you feel?'**
  String chatWarm3(String answer);

  /// No description provided for @chatDirect1.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}. Quick intro: what takes up most of your time — work, study, or something else?'**
  String chatDirect1(String name);

  /// No description provided for @chatDirect2.
  ///
  /// In en, this message translates to:
  /// **'OK: “{answer}”. What do you enjoy outside of that?'**
  String chatDirect2(String answer);

  /// No description provided for @chatDirect3.
  ///
  /// In en, this message translates to:
  /// **'Good. Last one: what\'s on your mind these days, and how do you feel about it?'**
  String get chatDirect3;

  /// No description provided for @chatFallback.
  ///
  /// In en, this message translates to:
  /// **'I\'m listening. Tell me more.'**
  String get chatFallback;

  /// No description provided for @reflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'What I understood'**
  String get reflectionTitle;

  /// No description provided for @reflectionBody.
  ///
  /// In en, this message translates to:
  /// **'From what you shared, it sounds like “{topic}” takes up a lot of your day, and you\'re going through {feeling}. What you feel makes sense, and it\'s good that you talked about it.'**
  String reflectionBody(String topic, String feeling);

  /// No description provided for @reflectionDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'AI reflection — it may not be exactly right.'**
  String get reflectionDisclaimer;

  /// No description provided for @reflectionSeeSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Show me support options'**
  String get reflectionSeeSuggestions;

  /// No description provided for @feelingStressed.
  ///
  /// In en, this message translates to:
  /// **'stress and pressure'**
  String get feelingStressed;

  /// No description provided for @feelingAnxious.
  ///
  /// In en, this message translates to:
  /// **'anxiety'**
  String get feelingAnxious;

  /// No description provided for @feelingSad.
  ///
  /// In en, this message translates to:
  /// **'sadness'**
  String get feelingSad;

  /// No description provided for @feelingAngry.
  ///
  /// In en, this message translates to:
  /// **'anger'**
  String get feelingAngry;

  /// No description provided for @feelingLonely.
  ///
  /// In en, this message translates to:
  /// **'loneliness'**
  String get feelingLonely;

  /// No description provided for @feelingUnclear.
  ///
  /// In en, this message translates to:
  /// **'something heavy'**
  String get feelingUnclear;

  /// No description provided for @suggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Steps that may help'**
  String get suggestionsTitle;

  /// No description provided for @suggestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I picked these based on what you shared. Choose one.'**
  String get suggestionsSubtitle;

  /// No description provided for @suggestionsWhy.
  ///
  /// In en, this message translates to:
  /// **'Why this suggestion?'**
  String get suggestionsWhy;

  /// No description provided for @suggestionsWriteDraft.
  ///
  /// In en, this message translates to:
  /// **'Write a draft'**
  String get suggestionsWriteDraft;

  /// No description provided for @suggestionTrustedAdultTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to a trusted adult'**
  String get suggestionTrustedAdultTitle;

  /// No description provided for @suggestionTrustedAdultDesc.
  ///
  /// In en, this message translates to:
  /// **'A parent, relative or teacher you trust'**
  String get suggestionTrustedAdultDesc;

  /// No description provided for @suggestionTrustedAdultWhy.
  ///
  /// In en, this message translates to:
  /// **'You mentioned you\'re going through {feeling}. Sharing it with an adult you trust lightens the load and gets you real support.'**
  String suggestionTrustedAdultWhy(String feeling);

  /// No description provided for @suggestionFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Reach out to a friend'**
  String get suggestionFriendTitle;

  /// No description provided for @suggestionFriendDesc.
  ///
  /// In en, this message translates to:
  /// **'Someone you feel comfortable with'**
  String get suggestionFriendDesc;

  /// No description provided for @suggestionFriendWhy.
  ///
  /// In en, this message translates to:
  /// **'When you\'re feeling {feeling}, talking to a friend reminds you that you\'re not alone.'**
  String suggestionFriendWhy(String feeling);

  /// No description provided for @suggestionCounselorTitle.
  ///
  /// In en, this message translates to:
  /// **'Message the school counselor'**
  String get suggestionCounselorTitle;

  /// No description provided for @suggestionCounselorDesc.
  ///
  /// In en, this message translates to:
  /// **'A specialist at your school or university'**
  String get suggestionCounselorDesc;

  /// No description provided for @suggestionCounselorWhy.
  ///
  /// In en, this message translates to:
  /// **'Since “{topic}” takes up so much of your time, a counselor can help you organize the pressure and find practical solutions.'**
  String suggestionCounselorWhy(String topic);

  /// No description provided for @suggestionSpecialistTitle.
  ///
  /// In en, this message translates to:
  /// **'Book a session with a specialist'**
  String get suggestionSpecialistTitle;

  /// No description provided for @suggestionSpecialistDesc.
  ///
  /// In en, this message translates to:
  /// **'A consultation with a licensed professional'**
  String get suggestionSpecialistDesc;

  /// No description provided for @suggestionSpecialistWhy.
  ///
  /// In en, this message translates to:
  /// **'You said you\'d work with a therapist if it were affordable. A short message is an easy first step to ask about options and costs.'**
  String get suggestionSpecialistWhy;

  /// No description provided for @suggestionSelfNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Write a note to yourself'**
  String get suggestionSelfNoteTitle;

  /// No description provided for @suggestionSelfNoteDesc.
  ///
  /// In en, this message translates to:
  /// **'Kind words you can come back to'**
  String get suggestionSelfNoteDesc;

  /// No description provided for @suggestionSelfNoteWhy.
  ///
  /// In en, this message translates to:
  /// **'You prefer working on challenges by yourself. Writing kind words to yourself helps you see things more clearly.'**
  String get suggestionSelfNoteWhy;

  /// No description provided for @draftTitle.
  ///
  /// In en, this message translates to:
  /// **'Your draft'**
  String get draftTitle;

  /// No description provided for @draftSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit it however you like, then copy it and send it yourself whenever you\'re ready.'**
  String get draftSubtitle;

  /// No description provided for @draftNeverSent.
  ///
  /// In en, this message translates to:
  /// **'Khutwa will never send this message. You decide if, when and how to send it.'**
  String get draftNeverSent;

  /// No description provided for @draftCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy message'**
  String get draftCopy;

  /// No description provided for @draftCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get draftCopied;

  /// No description provided for @draftReset.
  ///
  /// In en, this message translates to:
  /// **'Restore original text'**
  String get draftReset;

  /// No description provided for @draftTrustedAdult.
  ///
  /// In en, this message translates to:
  /// **'Hi, I need to talk to you about something that\'s been on my mind. Lately I\'ve been going through {feeling}, and I don\'t know how to deal with it on my own. Can we sit down together soon?'**
  String draftTrustedAdult(String feeling);

  /// No description provided for @draftFriend.
  ///
  /// In en, this message translates to:
  /// **'Hey! I miss talking with you. I\'m going through a time with a lot of {feeling}... do you have time to talk soon?'**
  String draftFriend(String feeling);

  /// No description provided for @draftCounselor.
  ///
  /// In en, this message translates to:
  /// **'Hello, I\'m a student and lately I\'ve been going through {feeling} because of “{topic}”. Could I book a time to talk with you?'**
  String draftCounselor(String feeling, String topic);

  /// No description provided for @draftSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Hello, I\'d like to book a counseling session. Lately I\'ve been going through {feeling} and would like to talk to a specialist. What times are available, and what does it cost?'**
  String draftSpecialist(String feeling);

  /// No description provided for @draftSelfNote.
  ///
  /// In en, this message translates to:
  /// **'Dear {name}, I know you\'re going through {feeling} right now, and that doesn\'t make you weak. You\'re doing your best, and every small step counts. Remember to be kind to yourself.'**
  String draftSelfNote(String name, String feeling);

  /// No description provided for @consentPointAi.
  ///
  /// In en, this message translates to:
  /// **'I\'m an AI, not a person.'**
  String get consentPointAi;

  /// No description provided for @consentPointRedaction.
  ///
  /// In en, this message translates to:
  /// **'Before anything leaves your phone, names, places and numbers are removed automatically.'**
  String get consentPointRedaction;

  /// No description provided for @consentPointModel.
  ///
  /// In en, this message translates to:
  /// **'The redacted text goes to a Google AI model through Khutwa\'s server.'**
  String get consentPointModel;

  /// No description provided for @consentPointNoStorage.
  ///
  /// In en, this message translates to:
  /// **'Our server doesn\'t store or log what you write.'**
  String get consentPointNoStorage;

  /// No description provided for @consentPointPlan.
  ///
  /// In en, this message translates to:
  /// **'Your plan is saved on your phone only.'**
  String get consentPointPlan;

  /// No description provided for @consentPointNotEmergency.
  ///
  /// In en, this message translates to:
  /// **'Khutwa isn\'t an emergency service. If you\'re in danger, tap the urgent button at the top.'**
  String get consentPointNotEmergency;

  /// No description provided for @writeTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get writeTitle;

  /// No description provided for @writeHint.
  ///
  /// In en, this message translates to:
  /// **'Write like you\'d talk…'**
  String get writeHint;

  /// No description provided for @writeNext.
  ///
  /// In en, this message translates to:
  /// **'See what will be sent'**
  String get writeNext;

  /// No description provided for @myPlan.
  ///
  /// In en, this message translates to:
  /// **'My plan'**
  String get myPlan;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Before we send it'**
  String get privacyTitle;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap any word to hide it. Tap it again to bring it back.'**
  String get privacySubtitle;

  /// No description provided for @privacyOriginalLabel.
  ///
  /// In en, this message translates to:
  /// **'What you wrote (stays on your phone)'**
  String get privacyOriginalLabel;

  /// No description provided for @privacyOutgoingLabel.
  ///
  /// In en, this message translates to:
  /// **'This is what leaves your phone'**
  String get privacyOutgoingLabel;

  /// No description provided for @privacyHonestLimit.
  ///
  /// In en, this message translates to:
  /// **'Redaction can\'t remove everything, and context may still identify you'**
  String get privacyHonestLimit;

  /// No description provided for @privacySend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get privacySend;

  /// No description provided for @privacyError.
  ///
  /// In en, this message translates to:
  /// **'Redaction failed on your phone. Nothing was sent.'**
  String get privacyError;

  /// No description provided for @reflectionWaiting.
  ///
  /// In en, this message translates to:
  /// **'Reading what you wrote…'**
  String get reflectionWaiting;

  /// No description provided for @reflectionQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Think about these while you wait:'**
  String get reflectionQuestionsTitle;

  /// No description provided for @reflectionQuestion1.
  ///
  /// In en, this message translates to:
  /// **'What\'s weighing on you most these days?'**
  String get reflectionQuestion1;

  /// No description provided for @reflectionQuestion2.
  ///
  /// In en, this message translates to:
  /// **'Is there someone you feel at ease talking to?'**
  String get reflectionQuestion2;

  /// No description provided for @reflectionQuestion3.
  ///
  /// In en, this message translates to:
  /// **'What helped you through a hard time before?'**
  String get reflectionQuestion3;

  /// No description provided for @analysisErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reach the server'**
  String get analysisErrorTitle;

  /// No description provided for @analysisErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again. The urgent button works even offline.'**
  String get analysisErrorBody;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @supportTypeTrustedFriend.
  ///
  /// In en, this message translates to:
  /// **'A friend you trust'**
  String get supportTypeTrustedFriend;

  /// No description provided for @supportTypeAcademicAdviser.
  ///
  /// In en, this message translates to:
  /// **'A teacher or academic adviser'**
  String get supportTypeAcademicAdviser;

  /// No description provided for @supportTypeTrustedRelative.
  ///
  /// In en, this message translates to:
  /// **'A relative you trust'**
  String get supportTypeTrustedRelative;

  /// No description provided for @supportTypeCommunityFigure.
  ///
  /// In en, this message translates to:
  /// **'Someone you trust in your community'**
  String get supportTypeCommunityFigure;

  /// No description provided for @supportTypeSpecialist.
  ///
  /// In en, this message translates to:
  /// **'A specialist'**
  String get supportTypeSpecialist;

  /// No description provided for @fallbackWhyFriend.
  ///
  /// In en, this message translates to:
  /// **'Talking to someone who knows and cares about you lightens the load.'**
  String get fallbackWhyFriend;

  /// No description provided for @fallbackDraftFriend.
  ///
  /// In en, this message translates to:
  /// **'Hi, something has been on my mind and I\'d like to talk to you about it. Do you have time soon?'**
  String get fallbackDraftFriend;

  /// No description provided for @fallbackWhyRelative.
  ///
  /// In en, this message translates to:
  /// **'A family member you trust can be there for you.'**
  String get fallbackWhyRelative;

  /// No description provided for @fallbackDraftRelative.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'d like to talk to you about something that\'s been weighing on me. Can we sit together?'**
  String get fallbackDraftRelative;

  /// No description provided for @fallbackWhySpecialist.
  ///
  /// In en, this message translates to:
  /// **'A specialist listens in confidence and helps you with a clear plan.'**
  String get fallbackWhySpecialist;

  /// No description provided for @fallbackDraftSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Hello, I\'d like to book a session. I\'ve been under a lot of pressure lately and want to talk to a specialist. What times are available?'**
  String get fallbackDraftSpecialist;

  /// No description provided for @draftSendYourself.
  ///
  /// In en, this message translates to:
  /// **'You\'re the one who sends it'**
  String get draftSendYourself;

  /// No description provided for @draftSaveToPlan.
  ///
  /// In en, this message translates to:
  /// **'Save to my plan'**
  String get draftSaveToPlan;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'My plan'**
  String get planTitle;

  /// No description provided for @planSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved on your phone only, and opens without internet.'**
  String get planSubtitle;

  /// No description provided for @planSupportLabel.
  ///
  /// In en, this message translates to:
  /// **'The step you chose'**
  String get planSupportLabel;

  /// No description provided for @planDraftLabel.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get planDraftLabel;

  /// No description provided for @planCopingTitle.
  ///
  /// In en, this message translates to:
  /// **'Things that can help right now'**
  String get planCopingTitle;

  /// No description provided for @planSavedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved: {date}'**
  String planSavedOn(String date);

  /// No description provided for @planEmpty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a saved plan yet.'**
  String get planEmpty;

  /// No description provided for @planDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get planDeleteAll;

  /// No description provided for @planDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get planDeleteConfirmTitle;

  /// No description provided for @planDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Everything in the app will be deleted: the plan, drafts and any saved text. This can\'t be undone.'**
  String get planDeleteConfirmBody;

  /// No description provided for @planDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get planDeleteConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @planDeleted.
  ///
  /// In en, this message translates to:
  /// **'Everything was deleted.'**
  String get planDeleted;

  /// No description provided for @planStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get planStartOver;

  /// No description provided for @copingBreathingTitle.
  ///
  /// In en, this message translates to:
  /// **'Breathe slowly'**
  String get copingBreathingTitle;

  /// No description provided for @copingBreathingBody.
  ///
  /// In en, this message translates to:
  /// **'Breathe in for 4 seconds, hold for 4, and breathe out slowly for 6. Repeat 4 times.'**
  String get copingBreathingBody;

  /// No description provided for @copingGroundingTitle.
  ///
  /// In en, this message translates to:
  /// **'Come back to the moment'**
  String get copingGroundingTitle;

  /// No description provided for @copingGroundingBody.
  ///
  /// In en, this message translates to:
  /// **'Find 5 things you can see, 4 you can hear, 3 you can touch, 2 you can smell, and 1 you can taste.'**
  String get copingGroundingBody;

  /// No description provided for @copingMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Message someone you trust'**
  String get copingMessageTitle;

  /// No description provided for @copingMessageBody.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have to say everything. \"Can we talk?\" is enough to start.'**
  String get copingMessageBody;

  /// No description provided for @urgentScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you need help right now?'**
  String get urgentScreenTitle;

  /// No description provided for @urgentScreenBody.
  ///
  /// In en, this message translates to:
  /// **'If you\'re in danger or thinking about hurting yourself, don\'t wait.'**
  String get urgentScreenBody;

  /// No description provided for @urgentStep1.
  ///
  /// In en, this message translates to:
  /// **'Tell a person near you right now.'**
  String get urgentStep1;

  /// No description provided for @urgentStep2.
  ///
  /// In en, this message translates to:
  /// **'Go to the nearest hospital emergency department.'**
  String get urgentStep2;

  /// No description provided for @urgentStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Verified contacts'**
  String get urgentStep3Title;

  /// No description provided for @urgentVerifiedOn.
  ///
  /// In en, this message translates to:
  /// **'Verified: {date}'**
  String urgentVerifiedOn(String date);

  /// No description provided for @urgentCallContact.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String urgentCallContact(String name);

  /// No description provided for @consentHeading.
  ///
  /// In en, this message translates to:
  /// **'Our commitment to you.'**
  String get consentHeading;

  /// No description provided for @consentIntro.
  ///
  /// In en, this message translates to:
  /// **'Your mental health is personal. Before we start, here\'s what you should know:'**
  String get consentIntro;

  /// No description provided for @consentToggle.
  ///
  /// In en, this message translates to:
  /// **'I\'m 13 or older, I understand Khutwa doesn\'t replace professionals or emergency services, and I accept the Terms of Service and Privacy Policy.'**
  String get consentToggle;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start simple.'**
  String get chatTitle;

  /// No description provided for @chatIntro.
  ///
  /// In en, this message translates to:
  /// **'Write what\'s on your mind, however feels natural. Before anything leaves your phone, names, places and numbers are removed.'**
  String get chatIntro;

  /// No description provided for @chatSentAs.
  ///
  /// In en, this message translates to:
  /// **'What left your phone: {text}'**
  String chatSentAs(String text);

  /// No description provided for @urgentSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your safety matters most right now'**
  String get urgentSafetyTitle;

  /// No description provided for @urgentIntroAuto.
  ///
  /// In en, this message translates to:
  /// **'Thank you for writing what\'s on your mind. What you wrote makes us want to be sure you\'re OK, and here are steps you can take right now.'**
  String get urgentIntroAuto;

  /// No description provided for @urgentStepPerson.
  ///
  /// In en, this message translates to:
  /// **'Tell someone near you now: a friend, a family member you trust, a neighbour, anyone you feel safe with. Don\'t stay alone.'**
  String get urgentStepPerson;

  /// No description provided for @urgentStepHospital.
  ///
  /// In en, this message translates to:
  /// **'If you feel you might hurt yourself, go to the nearest hospital emergency department, or have someone take you.'**
  String get urgentStepHospital;

  /// No description provided for @urgentStepSafeSpace.
  ///
  /// In en, this message translates to:
  /// **'Move away from anything that could hurt you, and stay somewhere with other people.'**
  String get urgentStepSafeSpace;

  /// No description provided for @urgentContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Numbers you can call'**
  String get urgentContactsTitle;

  /// No description provided for @urgentContactVerified.
  ///
  /// In en, this message translates to:
  /// **'We checked that this number answers on {date}'**
  String urgentContactVerified(String date);

  /// No description provided for @urgentContactDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo number – not real'**
  String get urgentContactDemo;

  /// No description provided for @urgentNoContacts.
  ///
  /// In en, this message translates to:
  /// **'So far we couldn\'t confirm that any number answers, so we haven\'t listed any. You can take the steps above right now.'**
  String get urgentNoContacts;

  /// No description provided for @urgentMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Write a message to someone you trust'**
  String get urgentMessageTitle;

  /// No description provided for @urgentMessageText.
  ///
  /// In en, this message translates to:
  /// **'I\'m not OK right now and I need you. Can you come or call me?'**
  String get urgentMessageText;

  /// No description provided for @urgentCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy the message'**
  String get urgentCopy;

  /// No description provided for @urgentFooter.
  ///
  /// In en, this message translates to:
  /// **'Khutwa is not an emergency service, and nobody reads your messages. These steps were written and reviewed by the team, not by the AI.'**
  String get urgentFooter;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
