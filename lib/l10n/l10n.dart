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
  /// In ar, this message translates to:
  /// **'كل ما تحتاجه لصلاتك: مواقيت، أذان، واتجاه القبلة'**
  String get onboarding_title1;

  /// No description provided for @onboarding_title2.
  ///
  /// In ar, this message translates to:
  /// **'كل ما تحتاجه لصلاتك: مواقيت، أذان، واتجاه القبلة'**
  String get onboarding_title2;

  /// No description provided for @onboarding_title3.
  ///
  /// In ar, this message translates to:
  /// **'كل أذكارك في مكان واحد مع تذكيرك بها في وقتها'**
  String get onboarding_title3;

  /// No description provided for @home_icon1.
  ///
  /// In ar, this message translates to:
  /// **'القرآن '**
  String get home_icon1;

  /// No description provided for @home_icon2.
  ///
  /// In ar, this message translates to:
  /// **'تسميع القرآن '**
  String get home_icon2;

  /// No description provided for @home_icon3.
  ///
  /// In ar, this message translates to:
  /// **'استماع القرآن'**
  String get home_icon3;

  /// No description provided for @home_icon4.
  ///
  /// In ar, this message translates to:
  /// **'أذكار و تسبيح'**
  String get home_icon4;

  /// No description provided for @home_icon5.
  ///
  /// In ar, this message translates to:
  /// **'مواعيد الصلاة'**
  String get home_icon5;

  /// No description provided for @home_icon6.
  ///
  /// In ar, this message translates to:
  /// **'القبلة'**
  String get home_icon6;

  /// No description provided for @next_prayer.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة القادمة'**
  String get next_prayer;

  /// No description provided for @qibla.
  ///
  /// In ar, this message translates to:
  /// **'القبلة'**
  String get qibla;

  /// No description provided for @qiblaDirection.
  ///
  /// In ar, this message translates to:
  /// **'اتجاه القبلة'**
  String get qiblaDirection;

  /// No description provided for @pointTowardsQibla.
  ///
  /// In ar, this message translates to:
  /// **'وجه هاتفك نحو القبلة'**
  String get pointTowardsQibla;

  /// No description provided for @qiblaAngle.
  ///
  /// In ar, this message translates to:
  /// **'زاوية القبلة'**
  String get qiblaAngle;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @azkar_title.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار والأدعية'**
  String get azkar_title;

  /// No description provided for @azkar_counter.
  ///
  /// In ar, this message translates to:
  /// **'العداد'**
  String get azkar_counter;

  /// No description provided for @azkar_reset.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط'**
  String get azkar_reset;

  /// No description provided for @azkar_complete.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get azkar_complete;

  /// No description provided for @azkar_category_morning.
  ///
  /// In ar, this message translates to:
  /// **'أذكار الصباح'**
  String get azkar_category_morning;

  /// No description provided for @azkar_category_evening.
  ///
  /// In ar, this message translates to:
  /// **'أذكار المساء'**
  String get azkar_category_evening;

  /// No description provided for @azkar_category_after_prayer.
  ///
  /// In ar, this message translates to:
  /// **'أذكار بعد الصلاة'**
  String get azkar_category_after_prayer;

  /// No description provided for @azkar_category_before_sleep.
  ///
  /// In ar, this message translates to:
  /// **'أذكار قبل النوم'**
  String get azkar_category_before_sleep;

  /// No description provided for @azkar_category_general.
  ///
  /// In ar, this message translates to:
  /// **'أذكار عامة'**
  String get azkar_category_general;

  /// No description provided for @azkar_category_dua.
  ///
  /// In ar, this message translates to:
  /// **'أدعية مأثورة'**
  String get azkar_category_dua;

  /// No description provided for @azkar_morning_1.
  ///
  /// In ar, this message translates to:
  /// **'آية الكرسي\n\nاللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ\nلَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ\nلَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ\nمَنْ ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ\nيَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ\nوَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ\nوَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ\nوَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ\n(البقرة: 255)'**
  String get azkar_morning_1;

  /// No description provided for @azkar_morning_2.
  ///
  /// In ar, this message translates to:
  /// **'آخر آيتين من سورة البقرة\n\nآمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ\nكُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ\nلَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ\nوَقَالُوا سَمِعْنَا وَأَطَعْنَا\nغُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ\nلَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا\nلَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ\nرَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا\nرَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا\nرَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ\nوَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا\nأَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ\n(البقرة: 285-286)'**
  String get azkar_morning_2;

  /// No description provided for @azkar_morning_3.
  ///
  /// In ar, this message translates to:
  /// **'سورة الإخلاص والمعوذتين (3 مرات)\n\nسورة الإخلاص\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ هُوَ اللَّهُ أَحَدٌ\nاللَّهُ الصَّمَدُ\nلَمْ يَلِدْ وَلَمْ يُولَدْ\nوَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\nسورة الفلق\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ\nمِن شَرِّ مَا خَلَقَ\nوَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ\nوَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ\nوَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\nسورة الناس\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ\nمَلِكِ النَّاسِ\nإِلَٰهِ النَّاسِ\nمِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ\nالَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ\nمِنَ الْجِنَّةِ وَالنَّاسِ'**
  String get azkar_morning_3;

  /// No description provided for @azkar_morning_4.
  ///
  /// In ar, this message translates to:
  /// **'أصبحنا وأصبح الملك لله\n\nأصبحنا وأصبح الملك لله، والحمد لله،\nلا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير،\nرب أسألك خير هذا اليوم وخير ما بعده،\nوأعوذ بك من شر هذا اليوم وشر ما بعده،\nرب أعوذ بك من الكسل وسوء الكبر،\nرب أعوذ بك من عذاب في النار وعذاب في القبر.'**
  String get azkar_morning_4;

  /// No description provided for @azkar_morning_5.
  ///
  /// In ar, this message translates to:
  /// **'اللهم بك أصبحنا وبك أمسينا\n\nاللهم بك أصبحنا وبك أمسينا، وبك نحيا وبك نموت وإليك النشور.'**
  String get azkar_morning_5;

  /// No description provided for @azkar_morning_6.
  ///
  /// In ar, this message translates to:
  /// **'اللهم إني أصبحت أشهدك (4 مرات)\n\nاللهم إني أصبحت أشهدك، وأشهد حملة عرشك،\nوملائكتك وجميع خلقك أنك أنت الله،\nلا إله إلا أنت وحدك لا شريك لك،\nوأن محمداً عبدك ورسولك.'**
  String get azkar_morning_6;

  /// No description provided for @azkar_morning_7.
  ///
  /// In ar, this message translates to:
  /// **'اللهم ما أصبح بي من نعمة\n\nاللهم ما أصبح بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك،\nفلك الحمد ولك الشكر.'**
  String get azkar_morning_7;

  /// No description provided for @azkar_morning_8.
  ///
  /// In ar, this message translates to:
  /// **'حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم (7 مرات)'**
  String get azkar_morning_8;

  /// No description provided for @azkar_morning_9.
  ///
  /// In ar, this message translates to:
  /// **'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم (3 مرات)'**
  String get azkar_morning_9;

  /// No description provided for @azkar_morning_10.
  ///
  /// In ar, this message translates to:
  /// **'رضيت بالله رباً وبالإسلام ديناً وبمحمد ﷺ نبياً (3 مرات)'**
  String get azkar_morning_10;

  /// No description provided for @azkar_morning_11.
  ///
  /// In ar, this message translates to:
  /// **'يا حي يا قيوم برحمتك أستغيث\n\nأصلح لي شأني كله، ولا تكلني إلى نفسي طرفة عين.'**
  String get azkar_morning_11;

  /// No description provided for @azkar_morning_12.
  ///
  /// In ar, this message translates to:
  /// **'أصبحنا على فطرة الإسلام\n\nأصبحنا على فطرة الإسلام،\nوعلى كلمة الإخلاص،\nوعلى دين نبينا محمد ﷺ،\nوعلى ملة أبينا إبراهيم حنيفاً مسلماً وما كان من المشركين.'**
  String get azkar_morning_12;

  /// No description provided for @azkar_morning_13.
  ///
  /// In ar, this message translates to:
  /// **'سبحان الله وبحمده (100 مرة)'**
  String get azkar_morning_13;

  /// No description provided for @azkar_morning_14.
  ///
  /// In ar, this message translates to:
  /// **'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير (100 مرة)'**
  String get azkar_morning_14;

  /// No description provided for @azkar_evening_1.
  ///
  /// In ar, this message translates to:
  /// **'آية الكرسي\n\nاللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ\nلَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ\nلَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ\nمَنْ ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ\nيَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ\nوَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ\nوَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ\nوَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ\n(البقرة: 255)'**
  String get azkar_evening_1;

  /// No description provided for @azkar_evening_2.
  ///
  /// In ar, this message translates to:
  /// **'آخر آيتين من سورة البقرة\n\nآمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ\nكُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ\nلَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ\nوَقَالُوا سَمِعْنَا وَأَطَعْنَا\nغُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ\nلَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا\nلَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ\nرَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا\nرَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا\nرَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ\nوَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا\nأَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ\n(البقرة: 285-286)'**
  String get azkar_evening_2;

  /// No description provided for @azkar_evening_3.
  ///
  /// In ar, this message translates to:
  /// **'سورة الإخلاص والمعوذتين (3 مرات)\n\nسورة الإخلاص\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ هُوَ اللَّهُ أَحَدٌ\nاللَّهُ الصَّمَدُ\nلَمْ يَلِدْ وَلَمْ يُولَدْ\nوَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\nسورة الفلق\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ\nمِن شَرِّ مَا خَلَقَ\nوَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ\nوَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ\nوَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\nسورة الناس\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ\nمَلِكِ النَّاسِ\nإِلَٰهِ النَّاسِ\nمِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ\nالَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ\nمِنَ الْجِنَّةِ وَالنَّاسِ'**
  String get azkar_evening_3;

  /// No description provided for @azkar_evening_4.
  ///
  /// In ar, this message translates to:
  /// **'أمسينا وأمسى الملك لله\n\nأمسينا وأمسى الملك لله، والحمد لله،\nلا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير،\nرب أسألك خير هذه الليلة وخير ما بعدها،\nوأعوذ بك من شر هذه الليلة وشر ما بعدها،\nرب أعوذ بك من الكسل وسوء الكبر،\nرب أعوذ بك من عذاب في النار وعذاب في القبر.'**
  String get azkar_evening_4;

  /// No description provided for @azkar_evening_5.
  ///
  /// In ar, this message translates to:
  /// **'اللهم بك أمسينا وبك أصبحنا\n\nاللهم بك أمسينا وبك أصبحنا، وبك نحيا وبك نموت وإليك المصير.'**
  String get azkar_evening_5;

  /// No description provided for @azkar_evening_6.
  ///
  /// In ar, this message translates to:
  /// **'اللهم إني أمسيت أشهدك (4 مرات)\n\nاللهم إني أمسيت أشهدك، وأشهد حملة عرشك،\nوملائكتك وجميع خلقك أنك أنت الله،\nلا إله إلا أنت وحدك لا شريك لك،\nوأن محمداً عبدك ورسولك.'**
  String get azkar_evening_6;

  /// No description provided for @azkar_evening_7.
  ///
  /// In ar, this message translates to:
  /// **'اللهم ما أمسى بي من نعمة\n\nاللهم ما أمسى بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك،\nفلك الحمد ولك الشكر.'**
  String get azkar_evening_7;

  /// No description provided for @azkar_evening_8.
  ///
  /// In ar, this message translates to:
  /// **'حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم (7 مرات)'**
  String get azkar_evening_8;

  /// No description provided for @azkar_evening_9.
  ///
  /// In ar, this message translates to:
  /// **'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم (3 مرات)'**
  String get azkar_evening_9;

  /// No description provided for @azkar_evening_10.
  ///
  /// In ar, this message translates to:
  /// **'رضيت بالله رباً وبالإسلام ديناً وبمحمد ﷺ نبياً (3 مرات)'**
  String get azkar_evening_10;

  /// No description provided for @azkar_evening_11.
  ///
  /// In ar, this message translates to:
  /// **'يا حي يا قيوم برحمتك أستغيث\n\nأصلح لي شأني كله، ولا تكلني إلى نفسي طرفة عين.'**
  String get azkar_evening_11;

  /// No description provided for @azkar_evening_12.
  ///
  /// In ar, this message translates to:
  /// **'أمسينا على فطرة الإسلام\n\nأمسينا على فطرة الإسلام،\nوعلى كلمة الإخلاص،\nوعلى دين نبينا محمد ﷺ،\nوعلى ملة أبينا إبراهيم حنيفاً مسلماً وما كان من المشركين.'**
  String get azkar_evening_12;

  /// No description provided for @azkar_evening_13.
  ///
  /// In ar, this message translates to:
  /// **'سبحان الله وبحمده (100 مرة)'**
  String get azkar_evening_13;

  /// No description provided for @azkar_evening_14.
  ///
  /// In ar, this message translates to:
  /// **'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير (100 مرة)'**
  String get azkar_evening_14;

  /// No description provided for @azkar_after_prayer_1.
  ///
  /// In ar, this message translates to:
  /// **'أَسْتَغْفِرُ اللهَ (ثلاثاً) اللَّهُمَّ أَنْتَ السَّلاَمُ، وَمِنْكَ السَّلاَمُ، تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ'**
  String get azkar_after_prayer_1;

  /// No description provided for @azkar_after_prayer_2.
  ///
  /// In ar, this message translates to:
  /// **'لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، اللَّهُمَّ لاَ مَانِعَ لِمَا أَعْطَيْتَ، وَلاَ مُعْطِيَ لِمَا مَنَعْتَ، وَلاَ يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ'**
  String get azkar_after_prayer_2;

  /// No description provided for @azkar_after_prayer_3.
  ///
  /// In ar, this message translates to:
  /// **'سُبْحَانَ اللهِ (٣٣ مرة) الْحَمْدُ لِلهِ (٣٣ مرة) اللهُ أَكْبَرُ (٣٣ مرة) لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ'**
  String get azkar_after_prayer_3;

  /// No description provided for @azkar_before_sleep_1.
  ///
  /// In ar, this message translates to:
  /// **'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا'**
  String get azkar_before_sleep_1;

  /// No description provided for @azkar_before_sleep_2.
  ///
  /// In ar, this message translates to:
  /// **'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ'**
  String get azkar_before_sleep_2;

  /// No description provided for @azkar_before_sleep_3.
  ///
  /// In ar, this message translates to:
  /// **'سُبْحَانَ اللَّهِ (٣٣ مرة) الْحَمْدُ لِلَّهِ (٣٣ مرة) اللَّهُ أَكْبَرُ (٣٤ مرة)'**
  String get azkar_before_sleep_3;

  /// No description provided for @azkar_general_1.
  ///
  /// In ar, this message translates to:
  /// **'اللهم أصبحنا نشهدك ونشهد حملة عرشك وملائكتك وجميع خلقك أنك أنت الله، لا إله إلا أنت وحدك لا شريك لك، وأن محمدًا عبدك ورسولك،'**
  String get azkar_general_1;

  /// No description provided for @azkar_general_2.
  ///
  /// In ar, this message translates to:
  /// **'لا إلهَ إلاّ اللهُ وحدَهُ لا شريكَ لهُ، لهُ المُلكُ ولهُ الحمدُ وهوَ على كلّ شيءٍ قديرٌ'**
  String get azkar_general_2;

  /// No description provided for @azkar_general_3.
  ///
  /// In ar, this message translates to:
  /// **'سُبْحَانَ اللهِ وَبِحَمْدِهِ، سُبْحَانَ اللهِ العَظِيمِ'**
  String get azkar_general_3;

  /// No description provided for @azkar_dua_1.
  ///
  /// In ar, this message translates to:
  /// **'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ'**
  String get azkar_dua_1;

  /// No description provided for @azkar_dua_2.
  ///
  /// In ar, this message translates to:
  /// **'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى، وَالْعَفَافَ وَالْغِنَى'**
  String get azkar_dua_2;

  /// No description provided for @azkar_dua_3.
  ///
  /// In ar, this message translates to:
  /// **'اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَعَافِنِي، وَارْزُقْنِي'**
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
