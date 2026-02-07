import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/services/notification_service.dart';
import 'package:iman/Core/services/shared_preferences_singleton.dart';

class KhatmaPlannerDialog extends StatefulWidget {
  const KhatmaPlannerDialog({super.key});

  @override
  State<KhatmaPlannerDialog> createState() => _KhatmaPlannerDialogState();
}

class _KhatmaPlannerDialogState extends State<KhatmaPlannerDialog> {
  int _khatmas = 1;
  int _days = 30;
  List<TimeOfDay> _notificationTimes = [const TimeOfDay(hour: 20, minute: 0)];
  int _dailyPages = 20; // Default for 1 khatma in 30 days

  @override
  void initState() {
    super.initState();
    _loadSavedPlan();
  }

  void _loadSavedPlan() {
    _calculatePages();
  }

  void _calculatePages() {
    setState(() {
      _dailyPages = ((604 * _khatmas) / _days).ceil();
    });
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTimes[index],
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF39210F), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Color(0xFF39210F), // body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _notificationTimes[index]) {
      setState(() {
        _notificationTimes[index] = picked;
      });
    }
  }

  void _addTime() {
    setState(() {
      _notificationTimes.add(const TimeOfDay(hour: 12, minute: 0));
    });
  }

  void _removeTime(int index) {
    if (_notificationTimes.length > 1) {
      setState(() {
        _notificationTimes.removeAt(index);
      });
    }
  }

  Future<void> _saveAndSchedule() async {
    // Request permissions first
    await NotificationService().requestPermissions();

    // Save to prefs (optional for now, but good practice)
    await Prefs.setInt('khatma_pages', _dailyPages);

    // Cancel previous notifications (Assuming a range of IDs, e.g., 888 to 900)
    for (int i = 0; i < 20; i++) {
      await NotificationService().cancelNotification(888 + i);
    }

    // Distribute pages
    int timesCount = _notificationTimes.length;
    int basePages = _dailyPages ~/ timesCount;
    int remainder = _dailyPages % timesCount;

    for (int i = 0; i < timesCount; i++) {
      int pagesForThisTime = basePages + (i < remainder ? 1 : 0);
      
      await NotificationService().scheduleDailyNotification(
        id: 888 + i, // Unique ID for each time slot
        title: 'تذكير ورد القرآن',
        body: 'عليك قراءة $pagesForThisTime صفحة الآن لإتمام خطتك.',
        hour: _notificationTimes[i].hour,
        minute: _notificationTimes[i].minute,
      );
    }

    // Send immediate confirmation notification with scheduled times
    final timesText = _notificationTimes
        .map((time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}')
        .join(', ');
    
    await NotificationService().showImmediateNotification(
      id: 999,
      title: 'تم جدولة تذكيرات الخاتمة ✅',
      body: 'سيتم تذكيرك يومياً في: $timesText\nعدد الصفحات: $_dailyPages صفحة يومياً',
      channelId: 'khatma_confirmation',
      channelName: 'تأكيد تخطيط الخاتمة',
      channelDescription: 'إشعارات تأكيد جدولة الخاتمة',
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الخطة وجدولة التذكيرات بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'تخطيط الخاتمة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'عدد الختمات:',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  DropdownButton<int>(
                    value: _khatmas,
                    items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text('$e'),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _khatmas = val;
                          _calculatePages();
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'المدة (بالأيام):',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: '30',
                        isDense: true,
                      ),
                      onChanged: (val) {
                        int? days = int.tryParse(val);
                        if (days != null && days > 0) {
                          setState(() {
                            _days = days;
                            _calculatePages();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                children: [
                  Text(
                    'الصفحات لكل موعد: ${(_dailyPages / _notificationTimes.length).ceil()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF39210F),
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '(عدد الصفحات للمرة الواحدة)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'مواعيد التنبيه:',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notificationTimes.length,
                itemBuilder: (context, index) {
                  final time = _notificationTimes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    child: ListTile(
                      title: Text(
                        time.format(context),
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 16.sp,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => _selectTime(context, index),
                          ),
                          if (_notificationTimes.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeTime(index),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              TextButton.icon(
                onPressed: _addTime,
                icon: const Icon(Icons.add),
                label: const Text('إضافة موعد آخر', style: TextStyle(fontFamily: 'IBM Plex Sans Arabic')),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39210F),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onPressed: _saveAndSchedule,
                child: Text(
                  'حفظ وجدولة',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
