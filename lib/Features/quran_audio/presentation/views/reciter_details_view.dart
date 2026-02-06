import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/quran_audio/data/models/moshaf_model.dart';
import 'package:iman/Features/quran_audio/data/models/reciter_model.dart';
import 'package:iman/Features/quran_audio/data/repo/quran_audio_repo.dart';
import 'package:iman/Features/quran_audio/presentation/cubit/quran_audio_cubit.dart';
import 'package:iman/Features/quran_audio/presentation/cubit/quran_audio_states.dart';
import 'package:iman/Features/quran_audio/presentation/views/surahs_list_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReciterDetailsView extends StatelessWidget {
  final int reciterId;

  const ReciterDetailsView({super.key, required this.reciterId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuranAudioCubit(getIt<QuranAudioRepo>())
        ..getReciterById(reciterId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text('تفاصيل القارئ'),
          centerTitle: true,
          backgroundColor: Colors.green.shade700,
          elevation: 0,
        ),
        body: BlocBuilder<QuranAudioCubit, QuranAudioStates>(
          builder: (context, state) {
            if (state is ReciterDetailsLoading) {
              return _buildLoadingView();
            } else if (state is ReciterDetailsError) {
              return _buildErrorView(context, state.errorMessage);
            } else if (state is ReciterDetailsLoaded) {
              return _buildReciterDetails(context, state.reciter);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            errorMessage,
            style: AppTextStyles.regular16,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.read<QuranAudioCubit>().getReciterById(reciterId);
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildReciterDetails(BuildContext context, ReciterModel reciter) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات القارئ
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: reciter.image != null
                        ? CachedNetworkImageProvider(reciter.image!)
                        : null,
                    child: reciter.image == null
                        ? Icon(Icons.person, size: 40.sp, color: Colors.grey[600])
                        : null,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reciter.name,
                          style: AppTextStyles.semiBold20,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          reciter.rewaya,
                          style: AppTextStyles.regular14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          // عنوان المصاحف
          Text(
            'المصاحف المتاحة',
            style: AppTextStyles.semiBold18,
          ),
          SizedBox(height: 16.h),
          // قائمة المصاحف
          if (reciter.moshaf.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32.h),
                child: Text(
                  'لا توجد مصاحف متاحة',
                  style: AppTextStyles.regular16,
                ),
              ),
            )
          else
            ...reciter.moshaf.map<Widget>((moshaf) {
              return _buildMoshafCard(context, moshaf, reciter);
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildMoshafCard(
      BuildContext context, MoshafModel moshaf, reciter) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        title: Text(
          moshaf.name,
          style: AppTextStyles.semiBold16,
        ),
        subtitle: Text(
          'عدد السور: ${moshaf.surahTotal}',
          style: AppTextStyles.regular14,
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahsListView(
                reciterId: reciter.id,
                reciterName: reciter.name,
                moshaf: moshaf,
              ),
            ),
          );
        },
      ),
    );
  }
}

