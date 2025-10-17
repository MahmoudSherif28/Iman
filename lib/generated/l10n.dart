// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Everything you need for your prayer: times, adhan, and Qibla direction`
  String get onboarding_title1 {
    return Intl.message(
      'Everything you need for your prayer: times, adhan, and Qibla direction',
      name: 'onboarding_title1',
      desc: '',
      args: [],
    );
  }

  /// `Everything you need for your prayer: times, adhan, and Qibla direction`
  String get onboarding_title2 {
    return Intl.message(
      'Everything you need for your prayer: times, adhan, and Qibla direction',
      name: 'onboarding_title2',
      desc: '',
      args: [],
    );
  }

  /// `All your daily adhkar in one place with reminders at the right time`
  String get onboarding_title3 {
    return Intl.message(
      'All your daily adhkar in one place with reminders at the right time',
      name: 'onboarding_title3',
      desc: '',
      args: [],
    );
  }

  /// `Qur'an`
  String get home_icon1 {
    return Intl.message('Qur\'an', name: 'home_icon1', desc: '', args: []);
  }

  /// `Qur'an Recitation`
  String get home_icon2 {
    return Intl.message(
      'Qur\'an Recitation',
      name: 'home_icon2',
      desc: '',
      args: [],
    );
  }

  /// `Qur'an Listening`
  String get home_icon3 {
    return Intl.message(
      'Qur\'an Listening',
      name: 'home_icon3',
      desc: '',
      args: [],
    );
  }

  /// `Dhikr & Tasbeeh`
  String get home_icon4 {
    return Intl.message(
      'Dhikr & Tasbeeh',
      name: 'home_icon4',
      desc: '',
      args: [],
    );
  }

  /// `Prayer Times`
  String get home_icon5 {
    return Intl.message('Prayer Times', name: 'home_icon5', desc: '', args: []);
  }

  /// `Qibla`
  String get home_icon6 {
    return Intl.message('Qibla', name: 'home_icon6', desc: '', args: []);
  }

  /// `Next Prayer`
  String get next_prayer {
    return Intl.message('Next Prayer', name: 'next_prayer', desc: '', args: []);
  }

  /// `Qibla`
  String get qibla {
    return Intl.message('Qibla', name: 'qibla', desc: '', args: []);
  }

  /// `Qibla Direction`
  String get qiblaDirection {
    return Intl.message(
      'Qibla Direction',
      name: 'qiblaDirection',
      desc: '',
      args: [],
    );
  }

  /// `Point your device towards the Qibla`
  String get pointTowardsQibla {
    return Intl.message(
      'Point your device towards the Qibla',
      name: 'pointTowardsQibla',
      desc: '',
      args: [],
    );
  }

  /// `Qibla Angle`
  String get qiblaAngle {
    return Intl.message('Qibla Angle', name: 'qiblaAngle', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
