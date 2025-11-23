import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Features/quran_text/data/models/quran_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SurahDetailView extends StatefulWidget {
  final SurahModel surah;
  final bool enableTasmee;

  const SurahDetailView({super.key, required this.surah, this.enableTasmee = true});

  @override
  State<SurahDetailView> createState() => _SurahDetailViewState();
}

class _SurahDetailViewState extends State<SurahDetailView> {
  bool _isTasmeeMode = false;
  int _revealedVersesCount = 0;
  final ScrollController _scrollController = ScrollController();

  void _toggleTasmeeMode() {
    setState(() {
      if (_isTasmeeMode) {
        // Look up logic: if in mode, reveal next verse
        if (_revealedVersesCount < widget.surah.verses.length) {
          _revealedVersesCount++;
          _scrollToBottom();
        } else {
           // Optional: Reset or Exit? User just said "appear one after another".
           // Let's keep it simple: if done, maybe reset? Or just stay done.
        }
      } else {
        // Enter mode
        _isTasmeeMode = true;
        _revealedVersesCount = 0;
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedStatus();
  }

  Future<void> _loadSavedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getInt('hefz_surah_id');
    if (mounted) {
      setState(() {
        _isSaved = savedId == widget.surah.id;
      });
    }
  }

  Future<void> _saveSurah() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hefz_surah_id', widget.surah.id);
    if (mounted) {
      setState(() {
        _isSaved = true;
      });
    }
  }

  Future<void> _removeSurah() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('hefz_surah_id');
    if (mounted) {
      setState(() {
        _isSaved = false;
      });
    }
  }

  Future<void> _showSaveConfirmDialog() async {
    final isRemoving = _isSaved;
    final title = isRemoving ? 'إلغاء الحفظ' : 'تأكيد الحفظ';
    final content = isRemoving 
        ? 'هل تريد الغاء الحفظ من سورة ${widget.surah.name}؟' 
        : 'هل تريد وضع علامة الحفظ علي سورة ${widget.surah.name}؟';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content, textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('لا', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('نعم', style: TextStyle(color: Color(0xFF05B576))),
              onPressed: () {
                if (isRemoving) {
                  _removeSurah();
                } else {
                  _saveSurah();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      floatingActionButton: widget.enableTasmee ? FloatingActionButton(
        onPressed: _toggleTasmeeMode,
        backgroundColor: const Color(0xFF39210F),
        child: Icon(
          _isTasmeeMode && _revealedVersesCount < widget.surah.verses.length 
              ? Icons.mic 
              : Icons.mic_none_outlined, 
          color: Colors.white,
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h), // Spacing for the top area

                  // Zaghrafa and Name
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/zaghrafa.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        widget.surah.name,
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF240F4F),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 10.h),

                  // Basmalah
                  if (widget.surah.id != 1 && widget.surah.id != 9) ...[
                    Center(
                      child: Text(
                        'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],

                  // Content
                  if (!_isTasmeeMode)
                    RichText(
                      textAlign: TextAlign.justify,
                      textDirection: TextDirection.rtl,
                      text: TextSpan(
                        children: widget.surah.verses.map((verse) {
                          return TextSpan(
                            children: [
                              TextSpan(
                                text: '${verse.text} ',
                                style: TextStyle(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  fontSize: 22.sp,
                                  color: Colors.black87,
                                  height: 2.0,
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  padding: EdgeInsets.all(6.r),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF39210F),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${verse.id}',
                                    style: TextStyle(
                                      fontFamily: 'IBM Plex Sans Arabic',
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF442712),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    )
                  else
                    Column(
                      children: List.generate(_revealedVersesCount, (index) {
                        final verse = widget.surah.verses[index];
                        // Using TweenAnimationBuilder for simple fade/slide in
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: RichText(
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${verse.text} ',
                                    style: TextStyle(
                                      fontFamily: 'IBM Plex Sans Arabic',
                                      fontSize: 22.sp,
                                      color: Colors.black87,
                                      height: 2.0,
                                    ),
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                                      padding: EdgeInsets.all(6.r),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF39210F),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        '${verse.id}',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Arabic',
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF442712),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                  SizedBox(height: 80.h), // Extra space for FAB
                ],
              ),
            ),
            
            // Exit Button (X) to return to normal reading
            if (_isTasmeeMode)
              Positioned(
                top: 20.h,
                left: 20.w,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isTasmeeMode = false;
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                  tooltip: 'إلغاء التسميع',
                ),
              ),

             // Hefz Save Button (Only in Reading Mode)
             if (!widget.enableTasmee)
              Positioned(
                top: 20.h,
                left: 20.w,
                child: IconButton(
                  onPressed: _showSaveConfirmDialog,
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.red,
                    size: 30.sp,
                  ),
                  tooltip: 'حفظ الوصول',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
