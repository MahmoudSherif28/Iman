import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Features/qibla/data/repos/location_repos/location_repo.dart';
import 'package:iman/Features/qibla/data/repos/qiblah_calculator_repos/qiblah_calculator_repo.dart';
import 'package:iman/Features/qibla/presentation/manager/qiblah/qiblah_cubit.dart';
import 'package:iman/Features/qibla/presentation/views/widgets/qiblah_view_body.dart';

class QiblahView extends StatelessWidget {
  const QiblahView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => QiblahCubit(
            locationRepository: getIt<LocationRepository>(),
            qiblaCalculatorService: getIt<QiblaCalculatorService>(),
          ),
          child: const QiblahViewBody(),
        ),
      ),
    );
  }
}
