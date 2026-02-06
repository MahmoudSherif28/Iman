import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MushafSettingsSheet extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onDarkModeToggle;
  final VoidCallback onBookmarksView;
  final VoidCallback onSurahIndex;
  final VoidCallback? onDownloadForOffline;

  const MushafSettingsSheet({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeToggle,
    required this.onBookmarksView,
    required this.onSurahIndex,
    this.onDownloadForOffline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إعدادات المصحف',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 24.h),
          
          // Dark Mode Toggle
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: isDarkMode ? const Color(0xFFFFD700) : const Color(0xFF39210F),
            ),
            title: Text(
              'الوضع الليلي',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 16.sp,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) => onDarkModeToggle(),
              activeTrackColor: const Color(0xFF39210F),
            ),
          ),
          
          Divider(color: isDarkMode ? Colors.white24 : Colors.grey[300]),
          
          // Surah Index
          ListTile(
            leading: Icon(
              Icons.list_alt,
              color: isDarkMode ? const Color(0xFFFFD700) : const Color(0xFF39210F),
            ),
            title: Text(
              'فهرس السور',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 16.sp,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDarkMode ? Colors.white54 : Colors.grey,
            ),
            onTap: onSurahIndex,
          ),
          
          Divider(color: isDarkMode ? Colors.white24 : Colors.grey[300]),
          
          // View Bookmarks
          ListTile(
            leading: Icon(
              Icons.bookmarks,
              color: isDarkMode ? const Color(0xFFFFD700) : const Color(0xFF39210F),
            ),
            title: Text(
              'العلامات المرجعية',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 16.sp,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDarkMode ? Colors.white54 : Colors.grey,
            ),
            onTap: onBookmarksView,
          ),
          
          if (onDownloadForOffline != null) ...[
            Divider(color: isDarkMode ? Colors.white24 : Colors.grey[300]),
            ListTile(
              leading: Icon(
                Icons.download_rounded,
                color: isDarkMode ? const Color(0xFFFFD700) : const Color(0xFF39210F),
              ),
              title: Text(
                'تحميل المصحف للاستخدام بدون إنترنت',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 16.sp,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Text(
                'حفظ كل الصفحات (604) على الجهاز',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 12.sp,
                  color: isDarkMode ? Colors.white54 : Colors.grey,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.white54 : Colors.grey,
              ),
              onTap: onDownloadForOffline,
            ),
          ],
          
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
