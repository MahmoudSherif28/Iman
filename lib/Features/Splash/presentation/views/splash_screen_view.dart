import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iman/Features/onboard/presentation/views/widgets/onboard_view_body.dart';
class Splash extends StatelessWidget {
  const Splash({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: SvgPicture.asset(
          'assets/images/splash_logo.svg',
          width: 150.w,
          height: 150.w,
        ),
      ),
      nextScreen: const OnBoardViewBody(), // navigate after animation
      splashIconSize: 200.w,
      duration: 2000, // 2 seconds
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(milliseconds: 1200),
    );
  }
}
