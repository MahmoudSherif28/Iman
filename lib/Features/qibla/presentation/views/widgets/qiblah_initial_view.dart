import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Features/qibla/presentation/manager/qiblah/qiblah_cubit.dart';

class QiblahInitialView extends StatelessWidget {
  const QiblahInitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compass_calibration,
            size: 80,
            color: Colors.green.shade700,
          ),
          const SizedBox(height: 24),
          const Text(
            'اكتشف اتجاه القبلة',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'اضغط على الزر لمعرفة اتجاه القبلة من موقعك الحالي',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.read<QiblahCubit>().getQiblaDirection(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'اكتشف اتجاه القبلة',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}