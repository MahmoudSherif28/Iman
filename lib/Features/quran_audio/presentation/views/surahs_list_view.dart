import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/quran_audio/data/models/moshaf_model.dart';
import 'package:iman/Features/quran_audio/data/models/surah_model.dart';
import 'package:iman/Features/quran_audio/data/services/simple_audio_service.dart';
import 'package:iman/Features/quran_audio/presentation/views/audio_player_view.dart';

class SurahsListView extends StatefulWidget {
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
  State<SurahsListView> createState() => _SurahsListViewState();
}

class _SurahsListViewState extends State<SurahsListView> {
  final TextEditingController _searchController = TextEditingController();
  List<int> _allSurahs = [];
  List<int> _filteredSurahs = [];

  @override
  void initState() {
    super.initState();
    _initializeSurahs();
    _searchController.addListener(_filterSurahs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeSurahs() {
    if (widget.moshaf.surahList.isNotEmpty) {
      _allSurahs = List<int>.from(widget.moshaf.surahList)..sort();
    } else if (widget.moshaf.surahTotal > 0) {
      _allSurahs = List.generate(widget.moshaf.surahTotal, (index) => index + 1);
    } else {
      _allSurahs = List.generate(114, (index) => index + 1);
    }
    _filteredSurahs = List.from(_allSurahs);
  }

  void _filterSurahs() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _filteredSurahs = List.from(_allSurahs);
      });
      return;
    }

    setState(() {
      _filteredSurahs = _allSurahs.where((surahNumber) {
        final surah = SurahModel.fromNumber(surahNumber);
        return surah.arabicName.contains(query) || 
               surah.number.toString().contains(query);
      }).toList();
    });
  }

  Future<void> playSurah(int surahNumber) async {
    // Find the original index in the full list to play correctly
    final originalIndex = _allSurahs.indexOf(surahNumber);
    if (originalIndex == -1) return;

    // Show loading dialog while audio initializes
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    final audioService = SimpleAudioService();
    await audioService.loadAndPlayPlaylist(
      reciterId: widget.reciterId,
      reciterName: widget.reciterName,
      moshaf: widget.moshaf,
      initialIndex: originalIndex,
    );

    if (mounted) {
      Navigator.pop(context); // dismiss loading dialog
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AudioPlayerView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(widget.moshaf.name),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث عن سورة...',
                hintStyle: AppTextStyles.regular14.copyWith(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ),
          Expanded(
            child: _filteredSurahs.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد سور مطابقة للبحث',
                      style: AppTextStyles.regular16,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _filteredSurahs.length,
                    itemBuilder: (context, index) {
                      final surahNumber = _filteredSurahs[index];
                      final surah = SurahModel.fromNumber(surahNumber);

                      return _buildSurahCard(
                        context,
                        surah,
                        () => playSurah(surahNumber),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(
    BuildContext context,
    SurahModel surah,
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
