import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Features/qibla/presentation/manager/qiblah/qiblah_cubit.dart';

class QiblahAppBar extends StatelessWidget implements PreferredSizeWidget {
  final QiblahState state;

  const QiblahAppBar({super.key, required this.state});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'اتجاه القبلة',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.green.shade700,
      elevation: 0,
      actions: [
        if (state is! QiblahInitial && state is! QiblahLoading)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<QiblahCubit>().getQiblaDirection(),
            tooltip: 'تحديث الموقع',
          ),
        if (state is QiblaNoCompass)
          IconButton(
            icon: const Icon(Icons.compass_calibration),
            onPressed: () =>
                context.read<QiblahCubit>().restartCompassListening(),
            tooltip: 'إعادة تشغيل البوصلة',
          ),
      ],
    );
  }
}
