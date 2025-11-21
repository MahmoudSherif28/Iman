import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/quran_audio/data/models/moshaf_model.dart';
import 'package:iman/Features/quran_audio/data/models/surah_model.dart';
import 'package:iman/Features/quran_audio/presentation/views/audio_player_view.dart';

class SurahsListView extends StatelessWidget {
  final int reciterId;
  final String reciterName;
  final MoshafModel moshaf;

  const SurahsListView({
    super.key,
    required this.reciterId,
    required this.reciterName,
    required this.moshaf,
  });

  @override
  Widget build(BuildContext context) {
    // إنشاء قائمة السور
    List<int> sortedSurahs;
    
    if (moshaf.surahList.isNotEmpty) {
      // إذا كانت القائمة موجودة، استخدمها
      sortedSurahs = List<int>.from(moshaf.surahList)..sort();
    } else if (moshaf.surahTotal > 0) {
      // إذا كانت القائمة فارغة لكن surahTotal موجود، أنشئ قائمة من 1 إلى surahTotal
      sortedSurahs = List.generate(moshaf.surahTotal, (index) => index + 1);
    } else {
      // افتراضي: 114 سورة
      sortedSurahs = List.generate(114, (index) => index + 1);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(moshaf.name),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: sortedSurahs.isEmpty
          ? Center(
              child: Text(
                'لا توجد سور متاحة',
                style: AppTextStyles.regular16,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: sortedSurahs.length,
              itemBuilder: (context, index) {
                final surahNumber = sortedSurahs[index];
                final surah = SurahModel.fromNumber(surahNumber);
                final surahUrl = moshaf.getSurahUrl(surahNumber);

                return _buildSurahCard(
                  context,
                  surah,
                  surahUrl,
                  index,
                  sortedSurahs.length,
                );
              },
            ),
    );
  }

  Widget _buildSurahCard(
    BuildContext context,
    SurahModel surah,
    String surahUrl,
    int index,
    int totalSurahs,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        leading: Text(
          surah.number.toString(),
          style: AppTextStyles.semiBold16.copyWith(
            color: Colors.black,
          ),
        ),
        title: Text(
          surah.arabicName,
          style: AppTextStyles.semiBold16,
        ),
        subtitle: Text(
          'سورة ${surah.number}',
          style: AppTextStyles.regular14,
        ),
        trailing: IconButton(
          icon: Icon(Icons.play_circle_outline, size: 32.sp),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioPlayerView(
                  reciterId: reciterId,
                  reciterName: reciterName,
                  surah: surah,
                  surahUrl: surahUrl,
                  currentIndex: index,
                  totalSurahs: totalSurahs,
                  moshaf: moshaf,
                ),
              ),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioPlayerView(
                reciterId: reciterId,
                reciterName: reciterName,
                surah: surah,
                surahUrl: surahUrl,
                currentIndex: index,
                totalSurahs: totalSurahs,
                moshaf: moshaf,
              ),
            ),
          );
        },
      ),
    );
  }
}

