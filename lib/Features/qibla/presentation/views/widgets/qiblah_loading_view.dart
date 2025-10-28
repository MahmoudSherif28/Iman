import 'package:flutter/material.dart';

class QiblahLoadingView extends StatelessWidget {
  const QiblahLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
          ),
          const SizedBox(height: 24),
          Text(
            'جارٍ تحديد موقعك...',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          Text(
            'تأكد من تفعيل GPS',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}