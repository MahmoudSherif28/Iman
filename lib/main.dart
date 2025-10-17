import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Core/services/shared_prefrences_sengelton.dart';
import 'package:iman/Core/utils/app_themes.dart';
import 'package:iman/Features/Splash/presentation/views/splash_screen_view.dart';
import 'package:iman/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          title: 'Iman App',
          theme: AppThemes.getLightTheme,
          home: const Splash(),
        );
      },
    );
  }
}
