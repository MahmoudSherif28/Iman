import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
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
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

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

  /// No description provided for @onboarding_title1.
  ///
  /// In en, this message translates to:
  /// **'Everything you need for your prayer: times, adhan, and Qibla direction'**
  String get onboarding_title1;

  /// No description provided for @onboarding_title2.
  ///
  /// In en, this message translates to:
  /// **'Everything you need for your prayer: times, adhan, and Qibla direction'**
  String get onboarding_title2;

  /// No description provided for @onboarding_title3.
  ///
  /// In en, this message translates to:
  /// **'All your daily adhkar in one place with reminders at the right time'**
  String get onboarding_title3;

  /// No description provided for @home_icon1.
  ///
  /// In en, this message translates to:
  /// **'Qur\'an'**
  String get home_icon1;

  /// No description provided for @home_icon2.
  ///
  /// In en, this message translates to:
  /// **'Qur\'an Recitation'**
  String get home_icon2;

  /// No description provided for @home_icon3.
  ///
  /// In en, this message translates to:
  /// **'Qur\'an Listening'**
  String get home_icon3;

  /// No description provided for @home_icon4.
  ///
  /// In en, this message translates to:
  /// **'Dhikr & Tasbeeh'**
  String get home_icon4;

  /// No description provided for @home_icon5.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get home_icon5;

  /// No description provided for @home_icon6.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get home_icon6;

  /// No description provided for @next_prayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get next_prayer;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @qiblaDirection.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qiblaDirection;

  /// No description provided for @pointTowardsQibla.
  ///
  /// In en, this message translates to:
  /// **'Point your device towards the Qibla'**
  String get pointTowardsQibla;

  /// No description provided for @qiblaAngle.
  ///
  /// In en, this message translates to:
  /// **'Qibla Angle'**
  String get qiblaAngle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @azkar_title.
  ///
  /// In en, this message translates to:
  /// **'Adhkar & Duas'**
  String get azkar_title;

  /// No description provided for @azkar_counter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get azkar_counter;

  /// No description provided for @azkar_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get azkar_reset;

  /// No description provided for @azkar_complete.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get azkar_complete;

  /// No description provided for @azkar_category_morning.
  ///
  /// In en, this message translates to:
  /// **'Morning Adhkar'**
  String get azkar_category_morning;

  /// No description provided for @azkar_category_evening.
  ///
  /// In en, this message translates to:
  /// **'Evening Adhkar'**
  String get azkar_category_evening;

  /// No description provided for @azkar_category_after_prayer.
  ///
  /// In en, this message translates to:
  /// **'After Prayer Adhkar'**
  String get azkar_category_after_prayer;

  /// No description provided for @azkar_category_before_sleep.
  ///
  /// In en, this message translates to:
  /// **'Before Sleep Adhkar'**
  String get azkar_category_before_sleep;

  /// No description provided for @azkar_category_general.
  ///
  /// In en, this message translates to:
  /// **'General Adhkar'**
  String get azkar_category_general;

  /// No description provided for @azkar_category_dua.
  ///
  /// In en, this message translates to:
  /// **'Duas'**
  String get azkar_category_dua;

  /// No description provided for @azkar_morning_1.
  ///
  /// In en, this message translates to:
  /// **'Ayat al-Kursi (The Throne Verse)\n\nAllah! There is no deity except Him, the Ever-Living, the Sustainer of existence.\nNeither drowsiness overtakes Him nor sleep.\nTo Him belongs whatever is in the heavens and whatever is on the earth.\nWho is it that can intercede with Him except by His permission?\nHe knows what is before them and what will be after them,\nand they encompass not a thing of His knowledge except for what He wills.\nHis Kursi extends over the heavens and the earth,\nand their preservation tires Him not. And He is the Most High, the Most Great.\n(Al-Baqarah: 255)'**
  String get azkar_morning_1;

  /// No description provided for @azkar_morning_2.
  ///
  /// In en, this message translates to:
  /// **'Last two verses of Surah Al-Baqarah\n\nThe Messenger has believed in what was revealed to him from his Lord, and the believers.\nAll of them have believed in Allah and His angels and His books and His messengers.\nWe make no distinction between any of His messengers.\nAnd they say, \'We hear and we obey. Your forgiveness, our Lord, and to You is the return.\'\nAllah does not charge a soul except with that within its capacity.\nIt will have what it has gained, and it will bear what it has lost.\nOur Lord, do not impose blame upon us if we have forgotten or erred.\nOur Lord, and lay not upon us a burden like that which You laid upon those before us.\nOur Lord, and burden us not with that which we have no ability to bear.\nAnd pardon us; and forgive us; and have mercy upon us.\nYou are our protector, so give us victory over the disbelieving people.\n(Al-Baqarah: 285-286)'**
  String get azkar_morning_2;

  /// No description provided for @azkar_morning_3.
  ///
  /// In en, this message translates to:
  /// **'Surah Al-Ikhlas and Al-Mu\'awwidhatain (3 times)\n\nSay, \'He is Allah, [who is] One.\'\nSay, \'I seek refuge in the Lord of daybreak.\'\nSay, \'I seek refuge in the Lord of mankind.\''**
  String get azkar_morning_3;

  /// No description provided for @azkar_morning_4.
  ///
  /// In en, this message translates to:
  /// **'We have reached the morning and at this very time all sovereignty belongs to Allah\n\nWe have reached the morning and at this very time all sovereignty belongs to Allah, and all praise is for Allah.\nNone has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.\nO Lord, I ask You for the good of this day and the good of what follows it.\nAnd I seek refuge in You from the evil of this day and the evil of what follows it.\nO Lord, I seek refuge in You from laziness and old age.\nO Lord, I seek refuge in You from punishment in the Fire and punishment in the grave.'**
  String get azkar_morning_4;

  /// No description provided for @azkar_morning_5.
  ///
  /// In en, this message translates to:
  /// **'O Allah, by You we have reached the morning and by You we have reached the evening\n\nO Allah, by You we have reached the morning and by You we have reached the evening, and by You we live and by You we die, and to You is the return.'**
  String get azkar_morning_5;

  /// No description provided for @azkar_morning_6.
  ///
  /// In en, this message translates to:
  /// **'O Allah, I have reached the morning bearing witness to You (4 times)\n\nO Allah, I have reached the morning bearing witness to You, and bearing witness to the bearers of Your Throne,\nand Your angels and all of Your creation, that You are Allah,\nthere is no deity except You, alone, without partner,\nand that Muhammad is Your servant and Your messenger.'**
  String get azkar_morning_6;

  /// No description provided for @azkar_morning_7.
  ///
  /// In en, this message translates to:
  /// **'O Allah, whatever blessing I have reached this morning\n\nO Allah, whatever blessing I have reached this morning or any of Your creation has reached, it is from You alone, without partner, so for You is all praise and unto You all thanks.'**
  String get azkar_morning_7;

  /// No description provided for @azkar_morning_8.
  ///
  /// In en, this message translates to:
  /// **'Allah is sufficient for me, there is no deity except Him, upon Him I rely and He is the Lord of the Great Throne (7 times)'**
  String get azkar_morning_8;

  /// No description provided for @azkar_morning_9.
  ///
  /// In en, this message translates to:
  /// **'In the name of Allah, with whose name nothing can harm on earth or in heaven, and He is the Hearing, the Knowing (3 times)'**
  String get azkar_morning_9;

  /// No description provided for @azkar_morning_10.
  ///
  /// In en, this message translates to:
  /// **'I am pleased with Allah as a Lord, and with Islam as a religion, and with Muhammad as a Prophet (3 times)'**
  String get azkar_morning_10;

  /// No description provided for @azkar_morning_11.
  ///
  /// In en, this message translates to:
  /// **'O Ever-Living, O Self-Sustaining, by Your mercy I seek help\n\nSet right for me all my affairs, and do not leave me to myself for the blink of an eye.'**
  String get azkar_morning_11;

  /// No description provided for @azkar_morning_12.
  ///
  /// In en, this message translates to:
  /// **'We have reached the morning upon the natural religion of Islam\n\nWe have reached the morning upon the natural religion of Islam,\nand upon the word of sincerity,\nand upon the religion of our Prophet Muhammad,\nand upon the religion of our father Abraham, inclining toward truth, and he was not of the polytheists.'**
  String get azkar_morning_12;

  /// No description provided for @azkar_morning_13.
  ///
  /// In en, this message translates to:
  /// **'Glory is to Allah and praise is to Him (100 times)'**
  String get azkar_morning_13;

  /// No description provided for @azkar_morning_14.
  ///
  /// In en, this message translates to:
  /// **'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent (100 times)'**
  String get azkar_morning_14;

  /// No description provided for @azkar_evening_1.
  ///
  /// In en, this message translates to:
  /// **'We have reached the evening and at this very time all sovereignty belongs to Allah. Praise is to Allah. None has the right to be worshipped except Allah, alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent.'**
  String get azkar_evening_1;

  /// No description provided for @azkar_evening_2.
  ///
  /// In en, this message translates to:
  /// **'O Allah, what blessing I or any of Your creation have risen upon, is from You alone, without partner, so for You is all praise and unto You all thanks.'**
  String get azkar_evening_2;

  /// No description provided for @azkar_evening_3.
  ///
  /// In en, this message translates to:
  /// **'O Allah, I take refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts and from being overpowered by men.'**
  String get azkar_evening_3;

  /// No description provided for @azkar_after_prayer_1.
  ///
  /// In en, this message translates to:
  /// **'I ask Allah for forgiveness (three times). O Allah, You are As-Salam and from You is all peace, blessed are You, O Possessor of majesty and honor.'**
  String get azkar_after_prayer_1;

  /// No description provided for @azkar_after_prayer_2.
  ///
  /// In en, this message translates to:
  /// **'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent. O Allah, none can prevent what You have willed to bestow and none can bestow what You have willed to prevent, and no wealth or majesty can benefit anyone, as from You is all wealth and majesty.'**
  String get azkar_after_prayer_2;

  /// No description provided for @azkar_after_prayer_3.
  ///
  /// In en, this message translates to:
  /// **'Glory is to Allah (33 times). Praise is to Allah (33 times). Allah is the greatest (33 times). None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.'**
  String get azkar_after_prayer_3;

  /// No description provided for @azkar_before_sleep_1.
  ///
  /// In en, this message translates to:
  /// **'In Your name O Allah, I die and I live.'**
  String get azkar_before_sleep_1;

  /// No description provided for @azkar_before_sleep_2.
  ///
  /// In en, this message translates to:
  /// **'O Allah, protect me from Your punishment on the day Your servants are resurrected.'**
  String get azkar_before_sleep_2;

  /// No description provided for @azkar_before_sleep_3.
  ///
  /// In en, this message translates to:
  /// **'Glory is to Allah (33 times). Praise is to Allah (33 times). Allah is the greatest (34 times).'**
  String get azkar_before_sleep_3;

  /// No description provided for @azkar_general_1.
  ///
  /// In en, this message translates to:
  /// **'Glory is to Allah and praise is to Him.'**
  String get azkar_general_1;

  /// No description provided for @azkar_general_2.
  ///
  /// In en, this message translates to:
  /// **'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.'**
  String get azkar_general_2;

  /// No description provided for @azkar_general_3.
  ///
  /// In en, this message translates to:
  /// **'Glory is to Allah and praise is to Him, Glory is to Allah the Greatest.'**
  String get azkar_general_3;

  /// No description provided for @azkar_dua_1.
  ///
  /// In en, this message translates to:
  /// **'Our Lord, give us in this world that which is good and in the Hereafter that which is good and protect us from the punishment of the Fire.'**
  String get azkar_dua_1;

  /// No description provided for @azkar_dua_2.
  ///
  /// In en, this message translates to:
  /// **'O Allah, I ask You for guidance, piety, chastity and contentment.'**
  String get azkar_dua_2;

  /// No description provided for @azkar_dua_3.
  ///
  /// In en, this message translates to:
  /// **'O Allah, forgive me, have mercy upon me, guide me, give me health and grant me sustenance.'**
  String get azkar_dua_3;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
