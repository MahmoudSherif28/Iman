import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Features/quran_text/data/models/quran_page_mapping.dart';

class MushafNavigationDialog extends StatefulWidget {
  final int currentPage;
  final Function(int) onPageSelected;

  const MushafNavigationDialog({
    super.key,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  State<MushafNavigationDialog> createState() => _MushafNavigationDialogState();
}

class _MushafNavigationDialogState extends State<MushafNavigationDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _pageController = TextEditingController();
  int _selectedSurah = 1;
  int _selectedJuz = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int page) {
    if (page >= 1 && page <= MushafPageMapping.totalPages) {
      widget.onPageSelected(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(16.w),
        constraints: BoxConstraints(maxHeight: 500.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'الانتقال السريع',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF39210F),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF39210F),
              tabs: const [
                Tab(text: 'صفحة'),
                Tab(text: 'سورة'),
                Tab(text: 'جزء'),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPageTab(),
                  _buildSurahTab(),
                  _buildJuzTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTab() {
    return Column(
      children: [
        TextField(
          controller: _pageController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'أدخل رقم الصفحة (1-604)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ElevatedButton(
          onPressed: () {
            final page = int.tryParse(_pageController.text);
            if (page != null) {
              _navigateToPage(page);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF39210F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
          ),
          child: Text(
            'انتقال',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSurahTab() {
    return Column(
      children: [
        DropdownButton<int>(
          value: _selectedSurah,
          isExpanded: true,
          items: List.generate(114, (index) {
            final surahId = index + 1;
            return DropdownMenuItem(
              value: surahId,
              child: Text(
                'سورة $surahId',
                style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
              ),
            );
          }),
          onChanged: (value) {
            setState(() {
              _selectedSurah = value!;
            });
          },
        ),
        SizedBox(height: 16.h),
        ElevatedButton(
          onPressed: () {
            final page = MushafPageMapping.getPageForSurah(_selectedSurah);
            if (page != null) {
              _navigateToPage(page);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF39210F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
          ),
          child: Text(
            'انتقال',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJuzTab() {
    return Column(
      children: [
        DropdownButton<int>(
          value: _selectedJuz,
          isExpanded: true,
          items: List.generate(30, (index) {
            final juzId = index + 1;
            return DropdownMenuItem(
              value: juzId,
              child: Text(
                'الجزء $juzId',
                style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
              ),
            );
          }),
          onChanged: (value) {
            setState(() {
              _selectedJuz = value!;
            });
          },
        ),
        SizedBox(height: 16.h),
        ElevatedButton(
          onPressed: () {
            final page = MushafPageMapping.juzStartPages[_selectedJuz];
            if (page != null) {
              _navigateToPage(page);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF39210F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
          ),
          child: Text(
            'انتقال',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
