// يولّد صور المتجر (Google Play): الأيقونة، صورة الغلاف، وصور الشاشات.
// التشغيل: flutter test test/store_assets --update-goldens
// الناتج في مجلد store/ في جذر المشروع.
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iman/Core/errors/failure.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Core/utils/app_themes.dart';
import 'package:iman/Features/azkar/presentation/views/azkar_categories_screen.dart';
import 'package:iman/Features/azkar/presentation/views/azkar_items_screen.dart';
import 'package:iman/Features/home/data/models/prayer_time_model.dart';
import 'package:iman/Features/home/presentation/views/home_view.dart';
import 'package:iman/Features/prayer_times/data/models/prayer_times_model.dart';
import 'package:iman/Features/prayer_times/data/repo/prayer_times_repo.dart';
import 'package:iman/Features/quran_text/presentation/views/mushaf_reader_view.dart';
import 'package:iman/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _green = Color(0xFF06B576);
const _greenDark = Color(0xFF05704A);

/// مواقيت تجريبية (القاهرة) لعرضها في صور المتجر بدل طلب الموقع
class _SamplePrayerTimesRepo implements PrayerTimesRepo {
  @override
  Future<Either<Failure, PrayerTimesModel>> getPrayerTimes() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimesForDisplay() async =>
      const Right([
        PrayerTime(name: 'الفجر', icon: Icons.brightness_4_outlined, time: '04:38'),
        PrayerTime(name: 'الشروق', icon: Icons.wb_twilight_outlined, time: '06:05'),
        PrayerTime(name: 'الظهر', icon: Icons.wb_sunny_outlined, time: '11:39'),
        PrayerTime(name: 'العصر', icon: Icons.wb_cloudy_outlined, time: '14:47', isCurrent: true),
        PrayerTime(name: 'المغرب', icon: Icons.nights_stay_outlined, time: '17:13'),
        PrayerTime(name: 'العشاء', icon: Icons.bedtime_outlined, time: '18:31'),
      ]);
}

Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final p in paths) {
    loader.addFont(Future.value(ByteData.sublistView(File(p).readAsBytesSync())));
  }
  await loader.load();
}

Future<void> _loadFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT']!;
  await _loadFont('MaterialIcons', [
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  ]);
  await _loadFont('KFGQPC Uthmanic Script HAFS', [
    'assets/fonts/KFGQPC_Uthmanic_Script_HAFS.otf',
  ]);
  await _loadFont('IBM Plex Sans Arabic', [
    'assets/fonts/IBMPlexSansArabic-Regular.ttf',
    'assets/fonts/IBMPlexSansArabic-Medium.ttf',
    'assets/fonts/IBMPlexSansArabic-SemiBold.ttf',
    'assets/fonts/IBMPlexSansArabic-Bold.ttf',
  ]);
}

/// ينتظر تحميل كل الصور والملفات (عمليات حقيقية خارج الـ fake async)
Future<void> _settle(WidgetTester tester) async {
  for (int i = 0; i < 4; i++) {
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
    await tester.pump(const Duration(milliseconds: 300));
  }
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final image = element.widget as Image;
      await precacheImage(image.image, element);
    }
  });
  await tester.pump(const Duration(seconds: 1));
  // wakelock وغيره من الـ plugins مش متاحة في الاختبار
  while (tester.takeException() != null) {}
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// لقطة شاشة التطبيق داخل إطار متجر 1080×1920 مع عنوان
class _StoreFrame extends StatelessWidget {
  final String headline;
  final String subline;
  final Uint8List screenshot;

  const _StoreFrame({required this.headline, required this.subline, required this.screenshot});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_green, _greenDark],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(90, 110, 90, 0),
        child: Column(
          children: [
            Text(
              headline,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontWeight: FontWeight.bold,
                fontSize: 66,
                height: 1.3,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              subline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 36,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: 70),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(70)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(54)),
                  child: Image.memory(
                    screenshot,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _App extends StatelessWidget {
  final Widget home;
  const _App({required this.home});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: AppThemes.getLightTheme,
        home: home,
      ),
    );
  }
}

/// أيقونة التطبيق (مش ضمن assets التطبيق، فبتتقري من الملف مباشرة)
final _appIcon = File('assets/icon/app_icon.png').readAsBytesSync();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    // wakelock_plus (شاشة المصحف) غير متاح داخل الاختبار
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
      (_) async => const StandardMessageCodec().encodeMessage(<Object?>[null]),
    );
    if (!getIt.isRegistered<PrayerTimesRepo>()) {
      getIt.registerSingleton<PrayerTimesRepo>(_SamplePrayerTimesRepo());
    }
  });

  Future<void> shot(
    WidgetTester tester,
    String name, {
    required String headline,
    required String subline,
    required Widget screen,
    Future<void> Function()? prepare,
  }) async {
    await tester.runAsync(_loadFonts);

    // ١) الشاشة الحقيقية بمقاس موبايل 375×812 (×3)
    tester.view.physicalSize = const Size(1125, 2436);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      final text = details.exceptionAsString();
      if (text.contains('overflowed')) {
        // ignore: avoid_print
        print('OVERFLOW [$name]: ${text.split('\n').first} @ ${details.context}');
      }
    };
    await tester.pumpWidget(_App(home: screen));
    await _settle(tester);
    if (prepare != null) {
      await prepare();
      await _settle(tester);
    }
    FlutterError.onError = previousOnError;
    final rawPath = '../../build/store_raw/$name.png';
    await expectLater(find.byType(_App), matchesGoldenFile(rawPath));

    // ٢) وضعها داخل إطار المتجر
    final raw = (await tester.runAsync(() => File('build/store_raw/$name.png').readAsBytes()))!;
    _setSurface(tester, const Size(1080, 1920));
    await tester.pumpWidget(_StoreFrame(headline: headline, subline: subline, screenshot: raw));
    await _settle(tester);
    await expectLater(find.byType(_StoreFrame), matchesGoldenFile('../../store/screenshots/$name.png'));
  }

  testWidgets('01 home', (tester) async {
    await shot(
      tester,
      '01_home',
      headline: 'رفيقك اليومي في العبادة',
      subline: 'مواقيت الصلاة • القرآن • الأذكار • القبلة',
      screen: const HomeView(),
      prepare: () async {
        final button = find.text('طلب مواقيت الصلاة');
        await tester.ensureVisible(button);
        await tester.tap(button);
      },
    );
  });

  testWidgets('02 mushaf', (tester) async {
    await shot(
      tester,
      '02_mushaf',
      headline: 'المصحف بنفس سطور المصحف الورقي',
      subline: '٦٠٤ صفحة • ١٥ سطراً • بخط مجمع الملك فهد',
      screen: const MushafReaderView(initialPage: 50),
    );
  });

  testWidgets('03 fatiha', (tester) async {
    await shot(
      tester,
      '03_fatiha',
      headline: 'اقرأ وردك اليومي',
      subline: 'حفظ آخر صفحة • علامات • تفسير • تسميع',
      screen: const MushafReaderView(initialPage: 2),
    );
  });

  testWidgets('04 azkar', (tester) async {
    await shot(
      tester,
      '04_azkar',
      headline: 'أذكار المسلم كاملة',
      subline: 'الصباح • المساء • بعد الصلاة • النوم',
      screen: const AzkarCategoriesScreen(),
    );
  });

  testWidgets('05 after prayer', (tester) async {
    await shot(
      tester,
      '05_after_prayer',
      headline: 'عدّاد لكل ذكر',
      subline: 'أذكار بعد الصلاة من صحيح السنة',
      screen: const AzkarItemsScreen(categoryId: 'after_prayer'),
    );
  });

  testWidgets('icon 512', (tester) async {
    await tester.runAsync(_loadFonts);
    _setSurface(tester, const Size(512, 512));
    await tester.pumpWidget(
      Container(
        color: Colors.white,
        child: Image.memory(_appIcon, fit: BoxFit.cover),
      ),
    );
    await _settle(tester);
    await expectLater(find.byType(Container).first, matchesGoldenFile('../../store/icon_512.png'));
  });

  testWidgets('feature graphic 1024x500', (tester) async {
    await tester.runAsync(_loadFonts);
    _setSurface(tester, const Size(1024, 500));
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [_green, _greenDark],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'إيمان',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontWeight: FontWeight.bold,
                        fontSize: 110,
                        height: 1.1,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'القرآن الكريم • مواقيت الصلاة والأذان\nالأذكار • اتجاه القبلة',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                        height: 1.5,
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 320,
                height: 320,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(72),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 30, offset: const Offset(0, 10)),
                  ],
                ),
                child: Image.memory(_appIcon, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
    await _settle(tester);
    await expectLater(find.byType(Directionality).first, matchesGoldenFile('../../store/feature_graphic_1024x500.png'));
  });
}
