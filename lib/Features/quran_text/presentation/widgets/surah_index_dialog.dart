import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurahIndexDialog extends StatefulWidget {
  final Function(int pageNumber) onSurahSelected;

  const SurahIndexDialog({
    super.key,
    required this.onSurahSelected,
  });

  @override
  State<SurahIndexDialog> createState() => _SurahIndexDialogState();
}

class _SurahIndexDialogState extends State<SurahIndexDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<SurahInfo> _allSurahs = [];
  List<SurahInfo> _filteredSurahs = [];

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
    _allSurahs = [
      SurahInfo(1, 'الفاتحة', 'Al-Fatihah', 1),
      SurahInfo(2, 'البقرة', 'Al-Baqarah', 2),
      SurahInfo(3, 'آل عمران', 'Ali \'Imran', 50),
      SurahInfo(4, 'النساء', 'An-Nisa', 77),
      SurahInfo(5, 'المائدة', 'Al-Ma\'idah', 106),
      SurahInfo(6, 'الأنعام', 'Al-An\'am', 128),
      SurahInfo(7, 'الأعراف', 'Al-A\'raf', 151),
      SurahInfo(8, 'الأنفال', 'Al-Anfal', 177),
      SurahInfo(9, 'التوبة', 'At-Tawbah', 187),
      SurahInfo(10, 'يونس', 'Yunus', 208),
      SurahInfo(11, 'هود', 'Hud', 221),
      SurahInfo(12, 'يوسف', 'Yusuf', 235),
      SurahInfo(13, 'الرعد', 'Ar-Ra\'d', 249),
      SurahInfo(14, 'إبراهيم', 'Ibrahim', 255),
      SurahInfo(15, 'الحجر', 'Al-Hijr', 262),
      SurahInfo(16, 'النحل', 'An-Nahl', 267),
      SurahInfo(17, 'الإسراء', 'Al-Isra', 282),
      SurahInfo(18, 'الكهف', 'Al-Kahf', 293),
      SurahInfo(19, 'مريم', 'Maryam', 305),
      SurahInfo(20, 'طه', 'Ta-Ha', 312),
      SurahInfo(21, 'الأنبياء', 'Al-Anbya', 322),
      SurahInfo(22, 'الحج', 'Al-Hajj', 332),
      SurahInfo(23, 'المؤمنون', 'Al-Mu\'minun', 342),
      SurahInfo(24, 'النور', 'An-Nur', 350),
      SurahInfo(25, 'الفرقان', 'Al-Furqan', 359),
      SurahInfo(26, 'الشعراء', 'Ash-Shu\'ara', 367),
      SurahInfo(27, 'النمل', 'An-Naml', 377),
      SurahInfo(28, 'القصص', 'Al-Qasas', 385),
      SurahInfo(29, 'العنكبوت', 'Al-\'Ankabut', 396),
      SurahInfo(30, 'الروم', 'Ar-Rum', 404),
      SurahInfo(31, 'لقمان', 'Luqman', 411),
      SurahInfo(32, 'السجدة', 'As-Sajdah', 415),
      SurahInfo(33, 'الأحزاب', 'Al-Ahzab', 418),
      SurahInfo(34, 'سبأ', 'Saba', 428),
      SurahInfo(35, 'فاطر', 'Fatir', 434),
      SurahInfo(36, 'يس', 'Ya-Sin', 440),
      SurahInfo(37, 'الصافات', 'As-Saffat', 446),
      SurahInfo(38, 'ص', 'Sad', 453),
      SurahInfo(39, 'الزمر', 'Az-Zumar', 458),
      SurahInfo(40, 'غافر', 'Ghafir', 467),
      SurahInfo(41, 'فصلت', 'Fussilat', 477),
      SurahInfo(42, 'الشورى', 'Ash-Shura', 483),
      SurahInfo(43, 'الزخرف', 'Az-Zukhruf', 489),
      SurahInfo(44, 'الدخان', 'Ad-Dukhan', 496),
      SurahInfo(45, 'الجاثية', 'Al-Jathiyah', 499),
      SurahInfo(46, 'الأحقاف', 'Al-Ahqaf', 502),
      SurahInfo(47, 'محمد', 'Muhammad', 507),
      SurahInfo(48, 'الفتح', 'Al-Fath', 511),
      SurahInfo(49, 'الحجرات', 'Al-Hujurat', 515),
      SurahInfo(50, 'ق', 'Qaf', 518),
      SurahInfo(51, 'الذاريات', 'Adh-Dhariyat', 520),
      SurahInfo(52, 'الطور', 'At-Tur', 523),
      SurahInfo(53, 'النجم', 'An-Najm', 526),
      SurahInfo(54, 'القمر', 'Al-Qamar', 528),
      SurahInfo(55, 'الرحمن', 'Ar-Rahman', 531),
      SurahInfo(56, 'الواقعة', 'Al-Waqi\'ah', 534),
      SurahInfo(57, 'الحديد', 'Al-Hadid', 537),
      SurahInfo(58, 'المجادلة', 'Al-Mujadila', 542),
      SurahInfo(59, 'الحشر', 'Al-Hashr', 545),
      SurahInfo(60, 'الممتحنة', 'Al-Mumtahanah', 549),
      SurahInfo(61, 'الصف', 'As-Saff', 551),
      SurahInfo(62, 'الجمعة', 'Al-Jumu\'ah', 553),
      SurahInfo(63, 'المنافقون', 'Al-Munafiqun', 554),
      SurahInfo(64, 'التغابن', 'At-Taghabun', 556),
      SurahInfo(65, 'الطلاق', 'At-Talaq', 558),
      SurahInfo(66, 'التحريم', 'At-Tahrim', 560),
      SurahInfo(67, 'الملك', 'Al-Mulk', 562),
      SurahInfo(68, 'القلم', 'Al-Qalam', 564),
      SurahInfo(69, 'الحاقة', 'Al-Haqqah', 566),
      SurahInfo(70, 'المعارج', 'Al-Ma\'arij', 568),
      SurahInfo(71, 'نوح', 'Nuh', 570),
      SurahInfo(72, 'الجن', 'Al-Jinn', 572),
      SurahInfo(73, 'المزمل', 'Al-Muzzammil', 574),
      SurahInfo(74, 'المدثر', 'Al-Muddaththir', 575),
      SurahInfo(75, 'القيامة', 'Al-Qiyamah', 577),
      SurahInfo(76, 'الإنسان', 'Al-Insan', 578),
      SurahInfo(77, 'المرسلات', 'Al-Mursalat', 580),
      SurahInfo(78, 'النبأ', 'An-Naba', 582),
      SurahInfo(79, 'النازعات', 'An-Nazi\'at', 583),
      SurahInfo(80, 'عبس', '\'Abasa', 585),
      SurahInfo(81, 'التكوير', 'At-Takwir', 586),
      SurahInfo(82, 'الانفطار', 'Al-Infitar', 587),
      SurahInfo(83, 'المطففين', 'Al-Mutaffifin', 587),
      SurahInfo(84, 'الانشقاق', 'Al-Inshiqaq', 589),
      SurahInfo(85, 'البروج', 'Al-Buruj', 590),
      SurahInfo(86, 'الطارق', 'At-Tariq', 591),
      SurahInfo(87, 'الأعلى', 'Al-A\'la', 591),
      SurahInfo(88, 'الغاشية', 'Al-Ghashiyah', 592),
      SurahInfo(89, 'الفجر', 'Al-Fajr', 593),
      SurahInfo(90, 'البلد', 'Al-Balad', 594),
      SurahInfo(91, 'الشمس', 'Ash-Shams', 595),
      SurahInfo(92, 'الليل', 'Al-Layl', 595),
      SurahInfo(93, 'الضحى', 'Ad-Dhuha', 596),
      SurahInfo(94, 'الشرح', 'Ash-Sharh', 596),
      SurahInfo(95, 'التين', 'At-Tin', 597),
      SurahInfo(96, 'العلق', 'Al-\'Alaq', 597),
      SurahInfo(97, 'القدر', 'Al-Qadr', 598),
      SurahInfo(98, 'البينة', 'Al-Bayyinah', 598),
      SurahInfo(99, 'الزلزلة', 'Az-Zalzalah', 599),
      SurahInfo(100, 'العاديات', 'Al-\'Adiyat', 599),
      SurahInfo(101, 'القارعة', 'Al-Qari\'ah', 600),
      SurahInfo(102, 'التكاثر', 'At-Takathur', 600),
      SurahInfo(103, 'العصر', 'Al-\'Asr', 601),
      SurahInfo(104, 'الهمزة', 'Al-Humazah', 601),
      SurahInfo(105, 'الفيل', 'Al-Fil', 601),
      SurahInfo(106, 'قريش', 'Quraysh', 602),
      SurahInfo(107, 'الماعون', 'Al-Ma\'un', 602),
      SurahInfo(108, 'الكوثر', 'Al-Kawthar', 602),
      SurahInfo(109, 'الكافرون', 'Al-Kafirun', 603),
      SurahInfo(110, 'النصر', 'An-Nasr', 603),
      SurahInfo(111, 'المسد', 'Al-Masad', 603),
      SurahInfo(112, 'الإخلاص', 'Al-Ikhlas', 604),
      SurahInfo(113, 'الفلق', 'Al-Falaq', 604),
      SurahInfo(114, 'الناس', 'An-Nas', 604),
    ];
    _filteredSurahs = _allSurahs;
  }

  void _filterSurahs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        _filteredSurahs = _allSurahs.where((surah) {
          return surah.nameAr.contains(query) ||
                 surah.nameEn.toLowerCase().contains(query) ||
                 surah.number.toString().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(16.w),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'فهرس السور',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            // Search field
            TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'بحث عن سورة...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Surah list
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredSurahs.length,
                separatorBuilder: (context, index) => Divider(height: 1.h),
                itemBuilder: (context, index) {
                  final surah = _filteredSurahs[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF39210F),
                      radius: 18.r,
                      child: Text(
                        '${surah.number}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      surah.nameAr,
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                      'صفحة ${surah.pageStart}',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    trailing: Text(
                      surah.nameEn,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                    onTap: () {
                      widget.onSurahSelected(surah.pageStart);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurahInfo {
  final int number;
  final String nameAr;
  final String nameEn;
  final int pageStart;

  SurahInfo(this.number, this.nameAr, this.nameEn, this.pageStart);
}
