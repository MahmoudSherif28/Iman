import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Features/quran_text/data/models/quran_model.dart';
import 'package:iman/Features/quran_text/data/repos/quran_service.dart';
import 'package:iman/Features/quran_text/presentation/views/surah_detail_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurahListView extends StatefulWidget {
  final bool enableTasmee;
  const SurahListView({super.key, this.enableTasmee = true});

  @override
  State<SurahListView> createState() => _SurahListViewState();
}

class _SurahListViewState extends State<SurahListView> {
  final QuranService _quranService = QuranService();
  late Future<List<SurahModel>> _surahsFuture;
  List<SurahModel> _allSurahs = [];
  List<SurahModel> _filteredSurahs = [];
  final TextEditingController _searchController = TextEditingController();
  int? _savedSurahId;

  @override
  void initState() {
    super.initState();
    _surahsFuture = _quranService.getSurahs().then((surahs) {
        _allSurahs = surahs;
        _filteredSurahs = surahs;
        return surahs;
    });
    _loadSavedSurahId();
    _searchController.addListener(_filterSurahs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSurahs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSurahs = _allSurahs.where((surah) {
        final nameAr = surah.name; // Arabic
        final nameEn = surah.transliteration.toLowerCase(); // English
        // You might want to normalize Arabic text (remove Tashkeel) if needed, 
        // but simple contains is a good start. 
        // Most quran.json names are plain or lightly decorated.
        return nameAr.contains(query) || nameEn.contains(query);
      }).toList();
    });
  }

  Future<void> _loadSavedSurahId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedSurahId = prefs.getInt('hefz_surah_id');
    });
  }

  Future<void> _saveSurahId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hefz_surah_id', id);
    setState(() {
      _savedSurahId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سور القرآن الكريم'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SurahModel>>(
        future: _surahsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList();
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ أثناء تحميل البيانات: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد بيانات متاحة'));
          }

          // We use _filteredSurahs for display, ensuring it's populated initially via the Future logic
          // However, if the Future just finished, we might need a frame to sync if not handled in .then
          if (_allSurahs.isEmpty && snapshot.hasData) {
             _allSurahs = snapshot.data!;
             if (_searchController.text.isEmpty) {
                 _filteredSurahs = _allSurahs;
             }
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث باسم السورة...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.w),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
                  itemCount: _filteredSurahs.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final surah = _filteredSurahs[index];
                    return _buildSurahItem(surah);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSurahItem(SurahModel surah) {
    final isSaved = _savedSurahId == surah.id;

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahDetailView(
              surah: surah,
              enableTasmee: widget.enableTasmee,
            ),
          ),
        );
        _loadSavedSurahId();
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Number Container with potential Hefz overlay
            Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  alignment: Alignment.center,
                  child: Text(
                    '${surah.id}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),

                // Hefz Image Overlay
                if (isSaved)
                  Positioned.fill(
                     child: Image.asset('assets/images/hefz.png', fit: BoxFit.contain), 
                     // Adjust overlay logic: maybe replace the number container? 
                     // User said: "puts the image on the screen... if he wants to put it on another surah it moves"
                     // "image content" -> hefz.png
                  ),
              ],
            ),
            
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${surah.type == "meccan" ? "مكية" : "مدنية"} • ${surah.totalVerses} آية',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Transliteration or Bookmark Icon?
            if (isSaved) 
               Padding(
                 padding: EdgeInsets.only(left: 8.w),
                 child: Image.asset('assets/images/hefz.png', width: 24.w, height: 24.w),
               )
            else
               Text(
                surah.transliteration,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF05B576),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }



  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 72.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        );
      },
    );
  }
}
