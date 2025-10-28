import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/services/shared_prefrences_sengelton.dart';
import 'package:iman/Features/home/presentation/views/home_view.dart';
import 'package:iman/constants.dart';

class OnBoardViewBody extends StatefulWidget {
  const OnBoardViewBody({super.key});

  @override
  State<OnBoardViewBody> createState() => _OnBoardViewBodyState();
}

class _OnBoardViewBodyState extends State<OnBoardViewBody> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.jpg",
      "title_key": "onboarding_title1",
      "subtitle_key": "onboarding_subtitle1",
    },
    {
      "image": "assets/images/onboarding2.jpg",
      "title_key": "onboarding_title2",
      "subtitle_key": "onboarding_subtitle2",
    },
    {
      "image": "assets/images/onboarding3.jpg",
      "title_key": "onboarding_title3",
      "subtitle_key": "onboarding_subtitle3",
    },
  ];

  String translate(String key) {
    final Map<String, String> arLocalizations = {
      "onboarding_title1": "كل ما تحتاجه لصلاتك:",
      "onboarding_subtitle1": "مواقيت، أذان، واتجاه القبلة",
      "onboarding_title2": "كل أذكارك في مكان واحد",
      "onboarding_subtitle2": "مع تذكيرك بها في وقتها",
      "onboarding_title3": "قرآنك دائماً معك",
      "onboarding_subtitle3": "استمع وتدبّر بسهولة",
      "skip": "تخطي",
      "next": "التالي",
      "start_now": "ابدأ الآن",
    };
    return arLocalizations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final String titleText = translate(
      onboardingData[currentIndex]['title_key']!,
    );
    final String subtitleText = translate(
      onboardingData[currentIndex]['subtitle_key']!,
    );

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(onboardingData[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.65),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 50.h,
            right: 24.w,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeView(),
                  ),
                );
              },
              child: Text(
                translate("skip"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitleText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 18.sp),
                  ),
                  SizedBox(height: 25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        height: 8.h,
                        width: currentIndex == index ? 24.w : 8.w,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? const Color(0xFF4CAF50)
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      onPressed: () {
                        if (currentIndex == onboardingData.length - 1) {
                          Prefs.setBool(isOnboadingViewSeenKey, true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        currentIndex == onboardingData.length - 1
                            ? translate("start_now")
                            : translate("next"),
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
