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

  /// `Adhkar & Duas`
  String get azkar_title {
    return Intl.message(
      'Adhkar & Duas',
      name: 'azkar_title',
      desc: '',
      args: [],
    );
  }

  /// `Counter`
  String get azkar_counter {
    return Intl.message('Counter', name: 'azkar_counter', desc: '', args: []);
  }

  /// `Reset`
  String get azkar_reset {
    return Intl.message('Reset', name: 'azkar_reset', desc: '', args: []);
  }

  /// `Done`
  String get azkar_complete {
    return Intl.message('Done', name: 'azkar_complete', desc: '', args: []);
  }

  /// `Morning Adhkar`
  String get azkar_category_morning {
    return Intl.message(
      'Morning Adhkar',
      name: 'azkar_category_morning',
      desc: '',
      args: [],
    );
  }

  /// `Evening Adhkar`
  String get azkar_category_evening {
    return Intl.message(
      'Evening Adhkar',
      name: 'azkar_category_evening',
      desc: '',
      args: [],
    );
  }

  /// `After Prayer Adhkar`
  String get azkar_category_after_prayer {
    return Intl.message(
      'After Prayer Adhkar',
      name: 'azkar_category_after_prayer',
      desc: '',
      args: [],
    );
  }

  /// `Before Sleep Adhkar`
  String get azkar_category_before_sleep {
    return Intl.message(
      'Before Sleep Adhkar',
      name: 'azkar_category_before_sleep',
      desc: '',
      args: [],
    );
  }

  /// `General Adhkar`
  String get azkar_category_general {
    return Intl.message(
      'General Adhkar',
      name: 'azkar_category_general',
      desc: '',
      args: [],
    );
  }

  /// `Duas`
  String get azkar_category_dua {
    return Intl.message('Duas', name: 'azkar_category_dua', desc: '', args: []);
  }

  /// `Ayat al-Kursi (The Throne Verse)\n\nAllah! There is no deity except Him, the Ever-Living, the Sustainer of existence.\nNeither drowsiness overtakes Him nor sleep.\nTo Him belongs whatever is in the heavens and whatever is on the earth.\nWho is it that can intercede with Him except by His permission?\nHe knows what is before them and what will be after them,\nand they encompass not a thing of His knowledge except for what He wills.\nHis Kursi extends over the heavens and the earth,\nand their preservation tires Him not. And He is the Most High, the Most Great.\n(Al-Baqarah: 255)`
  String get azkar_morning_1 {
    return Intl.message(
      'Ayat al-Kursi (The Throne Verse)\n\nAllah! There is no deity except Him, the Ever-Living, the Sustainer of existence.\nNeither drowsiness overtakes Him nor sleep.\nTo Him belongs whatever is in the heavens and whatever is on the earth.\nWho is it that can intercede with Him except by His permission?\nHe knows what is before them and what will be after them,\nand they encompass not a thing of His knowledge except for what He wills.\nHis Kursi extends over the heavens and the earth,\nand their preservation tires Him not. And He is the Most High, the Most Great.\n(Al-Baqarah: 255)',
      name: 'azkar_morning_1',
      desc: '',
      args: [],
    );
  }

  /// `Last two verses of Surah Al-Baqarah\n\nThe Messenger has believed in what was revealed to him from his Lord, and the believers.\nAll of them have believed in Allah and His angels and His books and His messengers.\nWe make no distinction between any of His messengers.\nAnd they say, 'We hear and we obey. Your forgiveness, our Lord, and to You is the return.'\nAllah does not charge a soul except with that within its capacity.\nIt will have what it has gained, and it will bear what it has lost.\nOur Lord, do not impose blame upon us if we have forgotten or erred.\nOur Lord, and lay not upon us a burden like that which You laid upon those before us.\nOur Lord, and burden us not with that which we have no ability to bear.\nAnd pardon us; and forgive us; and have mercy upon us.\nYou are our protector, so give us victory over the disbelieving people.\n(Al-Baqarah: 285-286)`
  String get azkar_morning_2 {
    return Intl.message(
      'Last two verses of Surah Al-Baqarah\n\nThe Messenger has believed in what was revealed to him from his Lord, and the believers.\nAll of them have believed in Allah and His angels and His books and His messengers.\nWe make no distinction between any of His messengers.\nAnd they say, \'We hear and we obey. Your forgiveness, our Lord, and to You is the return.\'\nAllah does not charge a soul except with that within its capacity.\nIt will have what it has gained, and it will bear what it has lost.\nOur Lord, do not impose blame upon us if we have forgotten or erred.\nOur Lord, and lay not upon us a burden like that which You laid upon those before us.\nOur Lord, and burden us not with that which we have no ability to bear.\nAnd pardon us; and forgive us; and have mercy upon us.\nYou are our protector, so give us victory over the disbelieving people.\n(Al-Baqarah: 285-286)',
      name: 'azkar_morning_2',
      desc: '',
      args: [],
    );
  }

  /// `Surah Al-Ikhlas and Al-Mu'awwidhatain (3 times)\n\nSurah Al-Ikhlas\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, 'He is Allah, [who is] One.'\nAllah, the Eternal Refuge.\nHe neither begets nor is born,\nNor is there to Him any equivalent.\n\nSurah Al-Falaq\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, 'I seek refuge in the Lord of daybreak'\nFrom the evil of that which He created\nAnd from the evil of darkness when it settles\nAnd from the evil of the blowers in knots\nAnd from the evil of an envier when he envies.\n\nSurah An-Nas\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, 'I seek refuge in the Lord of mankind,'\nThe Sovereign of mankind,\nThe God of mankind,\nFrom the evil of the retreating whisperer\nWho whispers [evil] into the breasts of mankind\nFrom among the jinn and mankind.`
  String get azkar_morning_3 {
    return Intl.message(
      'Surah Al-Ikhlas and Al-Mu\'awwidhatain (3 times)\n\nSurah Al-Ikhlas\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, \'He is Allah, [who is] One.\'\nAllah, the Eternal Refuge.\nHe neither begets nor is born,\nNor is there to Him any equivalent.\n\nSurah Al-Falaq\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, \'I seek refuge in the Lord of daybreak\'\nFrom the evil of that which He created\nAnd from the evil of darkness when it settles\nAnd from the evil of the blowers in knots\nAnd from the evil of an envier when he envies.\n\nSurah An-Nas\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, \'I seek refuge in the Lord of mankind,\'\nThe Sovereign of mankind,\nThe God of mankind,\nFrom the evil of the retreating whisperer\nWho whispers [evil] into the breasts of mankind\nFrom among the jinn and mankind.',
      name: 'azkar_morning_3',
      desc: '',
      args: [],
    );
  }

  /// `We have reached the morning and at this very time all sovereignty belongs to Allah\n\nWe have reached the morning and at this very time all sovereignty belongs to Allah, and all praise is for Allah.\nNone has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.\nO Lord, I ask You for the good of this day and the good of what follows it.\nAnd I seek refuge in You from the evil of this day and the evil of what follows it.\nO Lord, I seek refuge in You from laziness and old age.\nO Lord, I seek refuge in You from punishment in the Fire and punishment in the grave.`
  String get azkar_morning_4 {
    return Intl.message(
      'We have reached the morning and at this very time all sovereignty belongs to Allah\n\nWe have reached the morning and at this very time all sovereignty belongs to Allah, and all praise is for Allah.\nNone has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.\nO Lord, I ask You for the good of this day and the good of what follows it.\nAnd I seek refuge in You from the evil of this day and the evil of what follows it.\nO Lord, I seek refuge in You from laziness and old age.\nO Lord, I seek refuge in You from punishment in the Fire and punishment in the grave.',
      name: 'azkar_morning_4',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, by You we have reached the morning and by You we have reached the evening\n\nO Allah, by You we have reached the morning and by You we have reached the evening, and by You we live and by You we die, and to You is the return.`
  String get azkar_morning_5 {
    return Intl.message(
      'O Allah, by You we have reached the morning and by You we have reached the evening\n\nO Allah, by You we have reached the morning and by You we have reached the evening, and by You we live and by You we die, and to You is the return.',
      name: 'azkar_morning_5',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, I have reached the morning bearing witness to You (4 times)\n\nO Allah, I have reached the morning bearing witness to You, and bearing witness to the bearers of Your Throne,\nand Your angels and all of Your creation, that You are Allah,\nthere is no deity except You, alone, without partner,\nand that Muhammad is Your servant and Your messenger.`
  String get azkar_morning_6 {
    return Intl.message(
      'O Allah, I have reached the morning bearing witness to You (4 times)\n\nO Allah, I have reached the morning bearing witness to You, and bearing witness to the bearers of Your Throne,\nand Your angels and all of Your creation, that You are Allah,\nthere is no deity except You, alone, without partner,\nand that Muhammad is Your servant and Your messenger.',
      name: 'azkar_morning_6',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, whatever blessing I have reached this morning\n\nO Allah, whatever blessing I have reached this morning or any of Your creation has reached, it is from You alone, without partner, so for You is all praise and unto You all thanks.`
  String get azkar_morning_7 {
    return Intl.message(
      'O Allah, whatever blessing I have reached this morning\n\nO Allah, whatever blessing I have reached this morning or any of Your creation has reached, it is from You alone, without partner, so for You is all praise and unto You all thanks.',
      name: 'azkar_morning_7',
      desc: '',
      args: [],
    );
  }

  /// `Allah is sufficient for me, there is no deity except Him, upon Him I rely and He is the Lord of the Great Throne (7 times)`
  String get azkar_morning_8 {
    return Intl.message(
      'Allah is sufficient for me, there is no deity except Him, upon Him I rely and He is the Lord of the Great Throne (7 times)',
      name: 'azkar_morning_8',
      desc: '',
      args: [],
    );
  }

  /// `In the name of Allah, with whose name nothing can harm on earth or in heaven, and He is the Hearing, the Knowing (3 times)`
  String get azkar_morning_9 {
    return Intl.message(
      'In the name of Allah, with whose name nothing can harm on earth or in heaven, and He is the Hearing, the Knowing (3 times)',
      name: 'azkar_morning_9',
      desc: '',
      args: [],
    );
  }

  /// `I am pleased with Allah as a Lord, and with Islam as a religion, and with Muhammad as a Prophet (3 times)`
  String get azkar_morning_10 {
    return Intl.message(
      'I am pleased with Allah as a Lord, and with Islam as a religion, and with Muhammad as a Prophet (3 times)',
      name: 'azkar_morning_10',
      desc: '',
      args: [],
    );
  }

  /// `O Ever-Living, O Self-Sustaining, by Your mercy I seek help\n\nSet right for me all my affairs, and do not leave me to myself for the blink of an eye.`
  String get azkar_morning_11 {
    return Intl.message(
      'O Ever-Living, O Self-Sustaining, by Your mercy I seek help\n\nSet right for me all my affairs, and do not leave me to myself for the blink of an eye.',
      name: 'azkar_morning_11',
      desc: '',
      args: [],
    );
  }

  /// `We have reached the morning upon the natural religion of Islam\n\nWe have reached the morning upon the natural religion of Islam,\nand upon the word of sincerity,\nand upon the religion of our Prophet Muhammad,\nand upon the religion of our father Abraham, inclining toward truth, and he was not of the polytheists.`
  String get azkar_morning_12 {
    return Intl.message(
      'We have reached the morning upon the natural religion of Islam\n\nWe have reached the morning upon the natural religion of Islam,\nand upon the word of sincerity,\nand upon the religion of our Prophet Muhammad,\nand upon the religion of our father Abraham, inclining toward truth, and he was not of the polytheists.',
      name: 'azkar_morning_12',
      desc: '',
      args: [],
    );
  }

  /// `Glory is to Allah and praise is to Him (100 times)`
  String get azkar_morning_13 {
    return Intl.message(
      'Glory is to Allah and praise is to Him (100 times)',
      name: 'azkar_morning_13',
      desc: '',
      args: [],
    );
  }

  /// `None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent (100 times)`
  String get azkar_morning_14 {
    return Intl.message(
      'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent (100 times)',
      name: 'azkar_morning_14',
      desc: '',
      args: [],
    );
  }

  /// `Ayat al-Kursi (The Throne Verse)\n\nAllah! There is no deity except Him, the Ever-Living, the Sustainer of existence.\nNeither drowsiness overtakes Him nor sleep.\nTo Him belongs whatever is in the heavens and whatever is on the earth.\nWho is it that can intercede with Him except by His permission?\nHe knows what is before them and what will be after them,\nand they encompass not a thing of His knowledge except for what He wills.\nHis Kursi extends over the heavens and the earth,\nand their preservation tires Him not. And He is the Most High, the Most Great.\n(Al-Baqarah: 255)`
  String get azkar_evening_1 {
    return Intl.message(
      'Ayat al-Kursi (The Throne Verse)\n\nAllah! There is no deity except Him, the Ever-Living, the Sustainer of existence.\nNeither drowsiness overtakes Him nor sleep.\nTo Him belongs whatever is in the heavens and whatever is on the earth.\nWho is it that can intercede with Him except by His permission?\nHe knows what is before them and what will be after them,\nand they encompass not a thing of His knowledge except for what He wills.\nHis Kursi extends over the heavens and the earth,\nand their preservation tires Him not. And He is the Most High, the Most Great.\n(Al-Baqarah: 255)',
      name: 'azkar_evening_1',
      desc: '',
      args: [],
    );
  }

  /// `Last two verses of Surah Al-Baqarah\n\nThe Messenger has believed in what was revealed to him from his Lord, and the believers.\nAll of them have believed in Allah and His angels and His books and His messengers.\nWe make no distinction between any of His messengers.\nAnd they say, 'We hear and we obey. Your forgiveness, our Lord, and to You is the return.'\nAllah does not charge a soul except with that within its capacity.\nIt will have what it has gained, and it will bear what it has lost.\nOur Lord, do not impose blame upon us if we have forgotten or erred.\nOur Lord, and lay not upon us a burden like that which You laid upon those before us.\nOur Lord, and burden us not with that which we have no ability to bear.\nAnd pardon us; and forgive us; and have mercy upon us.\nYou are our protector, so give us victory over the disbelieving people.\n(Al-Baqarah: 285-286)`
  String get azkar_evening_2 {
    return Intl.message(
      'Last two verses of Surah Al-Baqarah\n\nThe Messenger has believed in what was revealed to him from his Lord, and the believers.\nAll of them have believed in Allah and His angels and His books and His messengers.\nWe make no distinction between any of His messengers.\nAnd they say, \'We hear and we obey. Your forgiveness, our Lord, and to You is the return.\'\nAllah does not charge a soul except with that within its capacity.\nIt will have what it has gained, and it will bear what it has lost.\nOur Lord, do not impose blame upon us if we have forgotten or erred.\nOur Lord, and lay not upon us a burden like that which You laid upon those before us.\nOur Lord, and burden us not with that which we have no ability to bear.\nAnd pardon us; and forgive us; and have mercy upon us.\nYou are our protector, so give us victory over the disbelieving people.\n(Al-Baqarah: 285-286)',
      name: 'azkar_evening_2',
      desc: '',
      args: [],
    );
  }

  /// `Surah Al-Ikhlas and Al-Mu'awwidhatain (3 times)\n\nSurah Al-Ikhlas\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, 'He is Allah, [who is] One.'\nAllah, the Eternal Refuge.\nHe neither begets nor is born,\nNor is there to Him any equivalent.\n\nSurah Al-Falaq\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, 'I seek refuge in the Lord of daybreak'\nFrom the evil of that which He created\nAnd from the evil of darkness when it settles\nAnd from the evil of the blowers in knots\nAnd from the evil of an envier when he envies.\n\nSurah An-Nas\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, 'I seek refuge in the Lord of mankind,'\nThe Sovereign of mankind,\nThe God of mankind,\nFrom the evil of the retreating whisperer\nWho whispers [evil] into the breasts of mankind\nFrom among the jinn and mankind.`
  String get azkar_evening_3 {
    return Intl.message(
      'Surah Al-Ikhlas and Al-Mu\'awwidhatain (3 times)\n\nSurah Al-Ikhlas\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, \'He is Allah, [who is] One.\'\nAllah, the Eternal Refuge.\nHe neither begets nor is born,\nNor is there to Him any equivalent.\n\nSurah Al-Falaq\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, \'I seek refuge in the Lord of daybreak\'\nFrom the evil of that which He created\nAnd from the evil of darkness when it settles\nAnd from the evil of the blowers in knots\nAnd from the evil of an envier when he envies.\n\nSurah An-Nas\n\nIn the name of Allah, the Entirely Merciful, the Especially Merciful.\nSay, \'I seek refuge in the Lord of mankind,\'\nThe Sovereign of mankind,\nThe God of mankind,\nFrom the evil of the retreating whisperer\nWho whispers [evil] into the breasts of mankind\nFrom among the jinn and mankind.',
      name: 'azkar_evening_3',
      desc: '',
      args: [],
    );
  }

  /// `We have reached the evening and at this very time all sovereignty belongs to Allah\n\nWe have reached the evening and at this very time all sovereignty belongs to Allah, and all praise is for Allah.\nNone has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.\nO Lord, I ask You for the good of this night and the good of what follows it.\nAnd I seek refuge in You from the evil of this night and the evil of what follows it.\nO Lord, I seek refuge in You from laziness and old age.\nO Lord, I seek refuge in You from punishment in the Fire and punishment in the grave.`
  String get azkar_evening_4 {
    return Intl.message(
      'We have reached the evening and at this very time all sovereignty belongs to Allah\n\nWe have reached the evening and at this very time all sovereignty belongs to Allah, and all praise is for Allah.\nNone has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.\nO Lord, I ask You for the good of this night and the good of what follows it.\nAnd I seek refuge in You from the evil of this night and the evil of what follows it.\nO Lord, I seek refuge in You from laziness and old age.\nO Lord, I seek refuge in You from punishment in the Fire and punishment in the grave.',
      name: 'azkar_evening_4',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, by You we have reached the evening and by You we have reached the morning\n\nO Allah, by You we have reached the evening and by You we have reached the morning, and by You we live and by You we die, and to You is the return.`
  String get azkar_evening_5 {
    return Intl.message(
      'O Allah, by You we have reached the evening and by You we have reached the morning\n\nO Allah, by You we have reached the evening and by You we have reached the morning, and by You we live and by You we die, and to You is the return.',
      name: 'azkar_evening_5',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, I have reached the evening bearing witness to You (4 times)\n\nO Allah, I have reached the evening bearing witness to You, and bearing witness to the bearers of Your Throne,\nand Your angels and all of Your creation, that You are Allah,\nthere is no deity except You, alone, without partner,\nand that Muhammad is Your servant and Your messenger.`
  String get azkar_evening_6 {
    return Intl.message(
      'O Allah, I have reached the evening bearing witness to You (4 times)\n\nO Allah, I have reached the evening bearing witness to You, and bearing witness to the bearers of Your Throne,\nand Your angels and all of Your creation, that You are Allah,\nthere is no deity except You, alone, without partner,\nand that Muhammad is Your servant and Your messenger.',
      name: 'azkar_evening_6',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, whatever blessing I have reached this evening\n\nO Allah, whatever blessing I have reached this evening or any of Your creation has reached, it is from You alone, without partner, so for You is all praise and unto You all thanks.`
  String get azkar_evening_7 {
    return Intl.message(
      'O Allah, whatever blessing I have reached this evening\n\nO Allah, whatever blessing I have reached this evening or any of Your creation has reached, it is from You alone, without partner, so for You is all praise and unto You all thanks.',
      name: 'azkar_evening_7',
      desc: '',
      args: [],
    );
  }

  /// `Allah is sufficient for me, there is no deity except Him, upon Him I rely and He is the Lord of the Great Throne (7 times)`
  String get azkar_evening_8 {
    return Intl.message(
      'Allah is sufficient for me, there is no deity except Him, upon Him I rely and He is the Lord of the Great Throne (7 times)',
      name: 'azkar_evening_8',
      desc: '',
      args: [],
    );
  }

  /// `In the name of Allah, with whose name nothing can harm on earth or in heaven, and He is the Hearing, the Knowing (3 times)`
  String get azkar_evening_9 {
    return Intl.message(
      'In the name of Allah, with whose name nothing can harm on earth or in heaven, and He is the Hearing, the Knowing (3 times)',
      name: 'azkar_evening_9',
      desc: '',
      args: [],
    );
  }

  /// `I am pleased with Allah as a Lord, and with Islam as a religion, and with Muhammad as a Prophet (3 times)`
  String get azkar_evening_10 {
    return Intl.message(
      'I am pleased with Allah as a Lord, and with Islam as a religion, and with Muhammad as a Prophet (3 times)',
      name: 'azkar_evening_10',
      desc: '',
      args: [],
    );
  }

  /// `O Ever-Living, O Self-Sustaining, by Your mercy I seek help\n\nSet right for me all my affairs, and do not leave me to myself for the blink of an eye.`
  String get azkar_evening_11 {
    return Intl.message(
      'O Ever-Living, O Self-Sustaining, by Your mercy I seek help\n\nSet right for me all my affairs, and do not leave me to myself for the blink of an eye.',
      name: 'azkar_evening_11',
      desc: '',
      args: [],
    );
  }

  /// `We have reached the evening upon the natural religion of Islam\n\nWe have reached the evening upon the natural religion of Islam,\nand upon the word of sincerity,\nand upon the religion of our Prophet Muhammad,\nand upon the religion of our father Abraham, inclining toward truth, and he was not of the polytheists.`
  String get azkar_evening_12 {
    return Intl.message(
      'We have reached the evening upon the natural religion of Islam\n\nWe have reached the evening upon the natural religion of Islam,\nand upon the word of sincerity,\nand upon the religion of our Prophet Muhammad,\nand upon the religion of our father Abraham, inclining toward truth, and he was not of the polytheists.',
      name: 'azkar_evening_12',
      desc: '',
      args: [],
    );
  }

  /// `Glory is to Allah and praise is to Him (100 times)`
  String get azkar_evening_13 {
    return Intl.message(
      'Glory is to Allah and praise is to Him (100 times)',
      name: 'azkar_evening_13',
      desc: '',
      args: [],
    );
  }

  /// `None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent (100 times)`
  String get azkar_evening_14 {
    return Intl.message(
      'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent (100 times)',
      name: 'azkar_evening_14',
      desc: '',
      args: [],
    );
  }

  /// `I ask Allah for forgiveness (three times). O Allah, You are As-Salam and from You is all peace, blessed are You, O Possessor of majesty and honor.`
  String get azkar_after_prayer_1 {
    return Intl.message(
      'I ask Allah for forgiveness (three times). O Allah, You are As-Salam and from You is all peace, blessed are You, O Possessor of majesty and honor.',
      name: 'azkar_after_prayer_1',
      desc: '',
      args: [],
    );
  }

  /// `None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent. O Allah, none can prevent what You have willed to bestow and none can bestow what You have willed to prevent, and no wealth or majesty can benefit anyone, as from You is all wealth and majesty.`
  String get azkar_after_prayer_2 {
    return Intl.message(
      'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent. O Allah, none can prevent what You have willed to bestow and none can bestow what You have willed to prevent, and no wealth or majesty can benefit anyone, as from You is all wealth and majesty.',
      name: 'azkar_after_prayer_2',
      desc: '',
      args: [],
    );
  }

  /// `Glory is to Allah (33 times). Praise is to Allah (33 times). Allah is the greatest (33 times). None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.`
  String get azkar_after_prayer_3 {
    return Intl.message(
      'Glory is to Allah (33 times). Praise is to Allah (33 times). Allah is the greatest (33 times). None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.',
      name: 'azkar_after_prayer_3',
      desc: '',
      args: [],
    );
  }

  /// `In Your name O Allah, I die and I live.`
  String get azkar_before_sleep_1 {
    return Intl.message(
      'In Your name O Allah, I die and I live.',
      name: 'azkar_before_sleep_1',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, protect me from Your punishment on the day Your servants are resurrected.`
  String get azkar_before_sleep_2 {
    return Intl.message(
      'O Allah, protect me from Your punishment on the day Your servants are resurrected.',
      name: 'azkar_before_sleep_2',
      desc: '',
      args: [],
    );
  }

  /// `Glory is to Allah (33 times). Praise is to Allah (33 times). Allah is the greatest (34 times).`
  String get azkar_before_sleep_3 {
    return Intl.message(
      'Glory is to Allah (33 times). Praise is to Allah (33 times). Allah is the greatest (34 times).',
      name: 'azkar_before_sleep_3',
      desc: '',
      args: [],
    );
  }

  /// `Glory is to Allah and praise is to Him.`
  String get azkar_general_1 {
    return Intl.message(
      'Glory is to Allah and praise is to Him.',
      name: 'azkar_general_1',
      desc: '',
      args: [],
    );
  }

  /// `None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.`
  String get azkar_general_2 {
    return Intl.message(
      'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.',
      name: 'azkar_general_2',
      desc: '',
      args: [],
    );
  }

  /// `Glory is to Allah and praise is to Him, Glory is to Allah the Greatest.`
  String get azkar_general_3 {
    return Intl.message(
      'Glory is to Allah and praise is to Him, Glory is to Allah the Greatest.',
      name: 'azkar_general_3',
      desc: '',
      args: [],
    );
  }

  /// `Our Lord, give us in this world that which is good and in the Hereafter that which is good and protect us from the punishment of the Fire.`
  String get azkar_dua_1 {
    return Intl.message(
      'Our Lord, give us in this world that which is good and in the Hereafter that which is good and protect us from the punishment of the Fire.',
      name: 'azkar_dua_1',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, I ask You for guidance, piety, chastity and contentment.`
  String get azkar_dua_2 {
    return Intl.message(
      'O Allah, I ask You for guidance, piety, chastity and contentment.',
      name: 'azkar_dua_2',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, forgive me, have mercy upon me, guide me, give me health and grant me sustenance.`
  String get azkar_dua_3 {
    return Intl.message(
      'O Allah, forgive me, have mercy upon me, guide me, give me health and grant me sustenance.',
      name: 'azkar_dua_3',
      desc: '',
      args: [],
    );
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
