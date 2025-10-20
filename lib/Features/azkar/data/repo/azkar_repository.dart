import 'package:flutter/material.dart';
import 'package:iman/generated/l10n.dart';
import '../models/azkar_model.dart';

class AzkarRepository {
  List<AzkarCategory> getCategories(BuildContext context) {
    final localizations = S.of(context);
    
    return [
      AzkarCategory(
        id: 'morning',
        titleKey: localizations.azkar_category_morning,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'evening',
        titleKey: localizations.azkar_category_evening,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'after_prayer',
        titleKey: localizations.azkar_category_after_prayer,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'before_sleep',
        titleKey: localizations.azkar_category_before_sleep,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'general',
        titleKey: localizations.azkar_category_general,
        imageAsset: 'assets/images/doaa.png',
      ),
      AzkarCategory(
        id: 'dua',
        titleKey: localizations.azkar_category_dua,
        imageAsset: 'assets/images/doaa.png',
      ),
    ];
  }

  List<AzkarItem> getAzkarItems(BuildContext context, String categoryId) {
    final localizations = S.of(context);
    
    switch (categoryId) {
      case 'morning':
        return [
          AzkarItem(
            id: 'morning_1',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(1),
            count: 1,
          ),
          AzkarItem(
            id: 'morning_2',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(2),
            count: 1,
          ),
          AzkarItem(
            id: 'morning_3',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(3),
            count: 3,
          ),
          AzkarItem(
            id: 'morning_4',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(4),
            count: 1,
          ),
          AzkarItem(
            id: 'morning_5',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(5),
            count: 1,
          ),
          AzkarItem(
            id: 'morning_6',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(6),
            count: 4,
          ),
          AzkarItem(
            id: 'morning_7',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(7),
            count: 1,
          ),
          AzkarItem(
            id: 'morning_8',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(8),
            count: 7,
          ),
          AzkarItem(
            id: 'morning_9',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(9),
            count: 3,
          ),
          AzkarItem(
            id: 'morning_10',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(10),
            count: 3,
          ),
          AzkarItem(
            id: 'morning_11',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(11),
            count: 1,
          ),
          AzkarItem(
            id: 'morning_12',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(12),
            count: 1,
          ),
          AzkarItem(
            id: 'morning_13',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(13),
            count: 100,
          ),
          AzkarItem(
            id: 'morning_14',
            categoryId: categoryId,
            textKey: _getMorningAzkarText(14),
            count: 100,
          ),
        ];
      case 'evening':
        return [
          AzkarItem(
            id: 'evening_1',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(1),
            count: 1,
          ),
          AzkarItem(
            id: 'evening_2',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(2),
            count: 1,
          ),
          AzkarItem(
            id: 'evening_3',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(3),
            count: 3,
          ),
          AzkarItem(
            id: 'evening_4',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(4),
            count: 1,
          ),
          AzkarItem(
            id: 'evening_5',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(5),
            count: 1,
          ),
          AzkarItem(
            id: 'evening_6',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(6),
            count: 4,
          ),
          AzkarItem(
            id: 'evening_7',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(7),
            count: 1,
          ),
          AzkarItem(
            id: 'evening_8',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(8),
            count: 7,
          ),
          AzkarItem(
            id: 'evening_9',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(9),
            count: 3,
          ),
          AzkarItem(
            id: 'evening_10',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(10),
            count: 3,
          ),
          AzkarItem(
            id: 'evening_11',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(11),
            count: 1,
          ),
          AzkarItem(
            id: 'evening_12',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(12),
            count: 1,
          ),
          AzkarItem(
            id: 'evening_13',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(13),
            count: 100,
          ),
          AzkarItem(
            id: 'evening_14',
            categoryId: categoryId,
            textKey: _getEveningAzkarText(14),
            count: 100,
          ),
        ];
      case 'after_prayer':
        return [
          AzkarItem(
            id: 'after_prayer_1',
            categoryId: categoryId,
            textKey: _getAfterPrayerAzkarText(1),
            count: 3,
          ),
          AzkarItem(
            id: 'after_prayer_2',
            categoryId: categoryId,
            textKey: _getAfterPrayerAzkarText(2),
            count: 1,
          ),
          AzkarItem(
            id: 'after_prayer_3',
            categoryId: categoryId,
            textKey: _getAfterPrayerAzkarText(3),
            count: 1,
          ),
          AzkarItem(
            id: 'after_prayer_4',
            categoryId: categoryId,
            textKey: _getAfterPrayerAzkarText(4),
            count: 33,
          ),
          AzkarItem(
            id: 'after_prayer_5',
            categoryId: categoryId,
            textKey: _getAfterPrayerAzkarText(5),
            count: 1,
          ),
          AzkarItem(
            id: 'after_prayer_6',
            categoryId: categoryId,
            textKey: _getAfterPrayerAzkarText(6),
            count: 1,
          ),
          AzkarItem(
            id: 'after_prayer_7',
            categoryId: categoryId,
            textKey: _getAfterPrayerAzkarText(7),
            count: 1,
          ),
        ];
      case 'before_sleep':
        return [
          AzkarItem(
            id: 'before_sleep_1',
            categoryId: categoryId,
            textKey: localizations.azkar_before_sleep_1,
            count: 1,
          ),
          AzkarItem(
            id: 'before_sleep_2',
            categoryId: categoryId,
            textKey: localizations.azkar_before_sleep_2,
            count: 1,
          ),
          AzkarItem(
            id: 'before_sleep_3',
            categoryId: categoryId,
            textKey: localizations.azkar_before_sleep_3,
            count: 33,
          ),
        ];
      case 'general':
        return [
          AzkarItem(
            id: 'general_1',
            categoryId: categoryId,
            textKey: localizations.azkar_general_1,
            count: 100,
          ),
          AzkarItem(
            id: 'general_2',
            categoryId: categoryId,
            textKey: localizations.azkar_general_2,
            count: 100,
          ),
          AzkarItem(
            id: 'general_3',
            categoryId: categoryId,
            textKey: localizations.azkar_general_3,
            count: 100,
          ),
        ];
      case 'dua':
        return [
          AzkarItem(
            id: 'dua_1',
            categoryId: categoryId,
            textKey: localizations.azkar_dua_1,
            count: 1,
          ),
          AzkarItem(
            id: 'dua_2',
            categoryId: categoryId,
            textKey: localizations.azkar_dua_2,
            count: 1,
          ),
          AzkarItem(
            id: 'dua_3',
            categoryId: categoryId,
            textKey: localizations.azkar_dua_3,
            count: 1,
          ),
        ];
      default:
        return [];
    }
  }

  // دوال للحصول على النصوص العربية مباشرة
  String _getMorningAzkarText(int index) {
    switch (index) {
      case 1:
        return "آية الكرسي\n\nاللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ\nلَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ\nلَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ\nمَنْ ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ\nيَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ\nوَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ\nوَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ\nوَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ\n(البقرة: 255)";
      case 2:
        return "آخر آيتين من سورة البقرة\n\nآمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ\nكُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ\nلَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ\nوَقَالُوا سَمِعْنَا وَأَطَعْنَا\nغُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ\nلَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا\nلَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ\nرَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا\nرَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا\nرَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ\nوَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا\nأَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ\n(البقرة: 285-286)";
      case 3:
        return "سورة الإخلاص والمعوذتين (3 مرات)\n\nسورة الإخلاص\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ هُوَ اللَّهُ أَحَدٌ\nاللَّهُ الصَّمَدُ\nلَمْ يَلِدْ وَلَمْ يُولَدْ\nوَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\nسورة الفلق\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ\nمِن شَرِّ مَا خَلَقَ\nوَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ\nوَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ\nوَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\nسورة الناس\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ\nمَلِكِ النَّاسِ\nإِلَٰهِ النَّاسِ\nمِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ\nالَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ\nمِنَ الْجِنَّةِ وَالنَّاسِ";
      case 4:
        return "أصبحنا وأصبح الملك لله\n\nأصبحنا وأصبح الملك لله، والحمد لله،\nلا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير،\nرب أسألك خير هذا اليوم وخير ما بعده،\nوأعوذ بك من شر هذا اليوم وشر ما بعده،\nرب أعوذ بك من الكسل وسوء الكبر،\nرب أعوذ بك من عذاب في النار وعذاب في القبر.";
      case 5:
        return "اللهم بك أصبحنا وبك أمسينا\n\nاللهم بك أصبحنا وبك أمسينا، وبك نحيا وبك نموت وإليك النشور.";
      case 6:
        return "اللهم إني أصبحت أشهدك (4 مرات)\n\nاللهم إني أصبحت أشهدك، وأشهد حملة عرشك،\nوملائكتك وجميع خلقك أنك أنت الله،\nلا إله إلا أنت وحدك لا شريك لك،\nوأن محمداً عبدك ورسولك.";
      case 7:
        return "اللهم ما أصبح بي من نعمة\n\nاللهم ما أصبح بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك،\nفلك الحمد ولك الشكر.";
      case 8:
        return "حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم (7 مرات)";
      case 9:
        return "بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم (3 مرات)";
      case 10:
        return "رضيت بالله رباً وبالإسلام ديناً وبمحمد ﷺ نبياً (3 مرات)";
      case 11:
        return "يا حي يا قيوم برحمتك أستغيث\n\nأصلح لي شأني كله، ولا تكلني إلى نفسي طرفة عين.";
      case 12:
        return "أصبحنا على فطرة الإسلام\n\nأصبحنا على فطرة الإسلام،\nوعلى كلمة الإخلاص،\nوعلى دين نبينا محمد ﷺ،\nوعلى ملة أبينا إبراهيم حنيفاً مسلماً وما كان من المشركين.";
      case 13:
        return "سبحان الله وبحمده (100 مرة)";
      case 14:
        return "لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير (100 مرة)";
      default:
        return "";
    }
  }

  String _getEveningAzkarText(int index) {
    switch (index) {
      case 1:
        return "آية الكرسي\n\nاللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ\nلَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ\nلَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ\nمَنْ ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ\nيَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ\nوَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ\nوَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ\nوَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ\n(البقرة: 255)";
      case 2:
        return "آخر آيتين من سورة البقرة\n\nآمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ\nكُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ\nلَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ\nوَقَالُوا سَمِعْنَا وَأَطَعْنَا\nغُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ\nلَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا\nلَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ\nرَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا\nرَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا\nرَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ\nوَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا\nأَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ\n(البقرة: 285-286)";
      case 3:
        return "سورة الإخلاص والمعوذتين (3 مرات)\n\nسورة الإخلاص\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ هُوَ اللَّهُ أَحَدٌ\nاللَّهُ الصَّمَدُ\nلَمْ يَلِدْ وَلَمْ يُولَدْ\nوَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\nسورة الفلق\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ\nمِن شَرِّ مَا خَلَقَ\nوَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ\nوَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ\nوَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\nسورة الناس\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ\nمَلِكِ النَّاسِ\nإِلَٰهِ النَّاسِ\nمِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ\nالَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ\nمِنَ الْجِنَّةِ وَالنَّاسِ";
      case 4:
        return "أمسينا وأمسى الملك لله\n\nأمسينا وأمسى الملك لله، والحمد لله،\nلا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير،\nرب أسألك خير هذه الليلة وخير ما بعدها،\nوأعوذ بك من شر هذه الليلة وشر ما بعدها،\nرب أعوذ بك من الكسل وسوء الكبر،\nرب أعوذ بك من عذاب في النار وعذاب في القبر.";
      case 5:
        return "اللهم بك أمسينا وبك أصبحنا\n\nاللهم بك أمسينا وبك أصبحنا، وبك نحيا وبك نموت وإليك المصير.";
      case 6:
        return "اللهم إني أمسيت أشهدك (4 مرات)\n\nاللهم إني أمسيت أشهدك، وأشهد حملة عرشك،\nوملائكتك وجميع خلقك أنك أنت الله،\nلا إله إلا أنت وحدك لا شريك لك،\nوأن محمداً عبدك ورسولك.";
      case 7:
        return "اللهم ما أمسى بي من نعمة\n\nاللهم ما أمسى بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك،\nفلك الحمد ولك الشكر.";
      case 8:
        return "حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم (7 مرات)";
      case 9:
        return "بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم (3 مرات)";
      case 10:
        return "رضيت بالله رباً وبالإسلام ديناً وبمحمد ﷺ نبياً (3 مرات)";
      case 11:
        return "يا حي يا قيوم برحمتك أستغيث\n\nأصلح لي شأني كله، ولا تكلني إلى نفسي طرفة عين.";
      case 12:
        return "أمسينا على فطرة الإسلام\n\nأمسينا على فطرة الإسلام،\nوعلى كلمة الإخلاص،\nوعلى دين نبينا محمد ﷺ،\nوعلى ملة أبينا إبراهيم حنيفاً مسلماً وما كان من المشركين.";
      case 13:
        return "سبحان الله وبحمده (100 مرة)";
      case 14:
        return "لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير (100 مرة)";
      default:
        return "";
    }
  }

  String _getAfterPrayerAzkarText(int index) {
    switch (index) {
      case 1:
        return "الاستغفار\n\nأستغفر الله (3)";
      case 2:
        return "الدعاء\n\nاللهم أنت السلام، ومنك السلام، تباركت يا ذا الجلال والإكرام.";
      case 3:
        return "التوحيد\n\nلا إله إلا الله وحده لا شريك له،\nله الملك وله الحمد وهو على كل شيء قدير،\nاللهم لا مانع لما أعطيت، ولا معطي لما منعت،\nولا ينفع ذا الجد منك الجد.";
      case 4:
        return "تسبيح دبر كل صلاة\n\nسبحان الله (33 مرة)\nالحمد لله (33 مرة)\nالله أكبر (33 مرة)\nلا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير (1 مرة).";
      case 5:
        return "آية الكرسي\n\nاللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ\nلَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ\nلَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ\nمَنْ ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ\nيَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ\nوَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ\nوَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ\nوَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ\n(البقرة: 255)";
      case 6:
        return "سور الإخلاص والمعوذتين\n\nسورة الإخلاص\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ هُوَ اللَّهُ أَحَدٌ\nاللَّهُ الصَّمَدُ\nلَمْ يَلِدْ وَلَمْ يُولَدْ\nوَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\nسورة الفلق\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ\nمِن شَرِّ مَا خَلَقَ\nوَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ\nوَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ\nوَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\nسورة الناس\n\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ\nمَلِكِ النَّاسِ\nإِلَٰهِ النَّاسِ\nمِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ\nالَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ\nمِنَ الْجِنَّةِ وَالنَّاسِ\n\n(تقال بعد كل صلاة مرة، وبعد الفجر والمغرب ثلاث مرات)";
      case 7:
        return "ذكر بعد الصلاة\n\nلا إله إلا الله وحده لا شريك له،\nله الملك وله الحمد،\nيحيي ويميت وهو على كل شيء قدير.";
      default:
        return "";
    }
  }
}