import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/quran_audio/data/models/moshaf_model.dart';
import 'package:iman/Features/quran_audio/data/models/surah_model.dart';
import 'package:iman/Features/quran_audio/data/services/simple_audio_service.dart';
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
    List<int> sortedSurahs;

    if (moshaf.surahList.isNotEmpty) {
      sortedSurahs = List<int>.from(moshaf.surahList)..sort();
    } else if (moshaf.surahTotal > 0) {
      sortedSurahs = List.generate(moshaf.surahTotal, (index) => index + 1);
    } else {
      sortedSurahs = List.generate(114, (index) => index + 1);
    }

    void playSurah(int index) {
      final audioService = SimpleAudioService();
      audioService.loadAndPlayPlaylist(
        reciterId: reciterId,
        reciterName: reciterName,
        moshaf: moshaf,
        initialIndex: index,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AudioPlayerView()),
      );
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

                return _buildSurahCard(
                  context,
                  surah,
                  index,
                  () => playSurah(index),
                );
              },
            ),
    );
  }

  Widget _buildSurahCard(
    BuildContext context,
    SurahModel surah,
    int index,
    VoidCallback onPlay,
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
          onPressed: onPlay,
        ),
        onTap: onPlay,
      ),
    );
  }
}