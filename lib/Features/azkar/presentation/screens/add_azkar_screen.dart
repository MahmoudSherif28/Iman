import 'package:flutter/material.dart';
import '../../data/services/custom_azkar_service.dart';

class AddAzkarScreen extends StatefulWidget {
  const AddAzkarScreen({Key? key}) : super(key: key);

  @override
  State<AddAzkarScreen> createState() => _AddAzkarScreenState();
}

class _AddAzkarScreenState extends State<AddAzkarScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _countController = TextEditingController(text: '100');
  final CustomAzkarService _customAzkarService = CustomAzkarService();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _countController.dispose();
    super.dispose();
  }

  Future<void> _saveAzkar() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال نص الذكر'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final count = int.tryParse(_countController.text) ?? 100;
    final success = await _customAzkarService.saveCustomAzkar(
      _textController.text.trim(),
      count,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الذكر بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true); // إرجاع true للإشارة إلى نجاح الحفظ
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء حفظ الذكر'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة ذكر جديد'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'نص الذكر',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 5,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'اكتب الذكر هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1B5E20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'عدد التكرار',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _countController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '100',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1B5E20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveAzkar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'حفظ الذكر',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}