import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman/Core/services/getit_service.dart';
import 'package:iman/Core/utils/app_text_style.dart';
import 'package:iman/Features/quran_audio/data/models/reciter_model.dart';
import 'package:iman/Features/quran_audio/data/repo/quran_audio_repo.dart';
import 'package:iman/Features/quran_audio/data/services/favorite_service.dart';
import 'package:iman/Features/quran_audio/presentation/cubit/quran_audio_cubit.dart';
import 'package:iman/Features/quran_audio/presentation/cubit/quran_audio_states.dart';
import 'package:iman/Features/quran_audio/presentation/views/reciter_details_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecitersListView extends StatelessWidget {
  const RecitersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuranAudioCubit(getIt<QuranAudioRepo>())
        ..getAllReciters(),
      child: const _RecitersListViewBody(),
    );
  }
}

class _RecitersListViewBody extends StatefulWidget {
  const _RecitersListViewBody();

  @override
  State<_RecitersListViewBody> createState() => _RecitersListViewState();
}

class _RecitersListViewState extends State<_RecitersListViewBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<QuranAudioCubit>().getAllReciters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('سماع القرآن'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Column(
        children: [
          // صندوق البحث
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن قارئ أو رواية...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<QuranAudioCubit>().searchReciters('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                context.read<QuranAudioCubit>().searchReciters(value);
              },
            ),
          ),
          // قائمة القراء
          Expanded(
            child: BlocBuilder<QuranAudioCubit, QuranAudioStates>(
              builder: (context, state) {
                if (state is QuranAudioLoading) {
                  return _buildLoadingList();
                } else if (state is QuranAudioError) {
                  return _buildErrorView(state.errorMessage);
                } else if (state is QuranAudioLoaded) {
                  if (state.filteredReciters.isEmpty) {
                    return _buildEmptyView();
                  }
                  return _buildRecitersList(state.filteredReciters);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 80.h,
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorView(String errorMessage) {
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
              context.read<QuranAudioCubit>().getAllReciters();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            'لا توجد نتائج',
            style: AppTextStyles.semiBold18,
          ),
          SizedBox(height: 8.h),
          Text(
            'حاول البحث بكلمات مختلفة',
            style: AppTextStyles.regular14,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecitersList(List<ReciterModel> reciters) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<QuranAudioCubit>().refreshReciters();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: reciters.length,
        itemBuilder: (context, index) {
          final reciter = reciters[index];
          return _buildReciterCard(reciter);
        },
      ),
    );
  }

  Widget _buildReciterCard(ReciterModel reciter) {
    final isFavorite = FavoriteService.isFavorite(reciter.id);

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          radius: 30.r,
          backgroundColor: Colors.grey[200],
          backgroundImage: reciter.image != null
              ? CachedNetworkImageProvider(reciter.image!)
              : null,
          child: reciter.image == null
              ? Icon(Icons.person, size: 30.sp, color: Colors.grey[600])
              : null,
        ),
        title: Text(
          reciter.name,
          style: AppTextStyles.semiBold16,
        ),
        subtitle: Text(
          reciter.rewaya,
          style: AppTextStyles.regular14,
        ),
        trailing: FavoriteIconButton(
          reciter: reciter,
          cubit: context.read<QuranAudioCubit>(),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReciterDetailsView(reciterId: reciter.id),
            ),
          );
        },
      ),
    );
  }
}

class FavoriteIconButton extends StatefulWidget {
  final ReciterModel reciter;
  final QuranAudioCubit cubit;

  const FavoriteIconButton({
    super.key,
    required this.reciter,
    required this.cubit,
  });

  @override
  State<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoriteService.isFavorite(widget.reciter.id);
  }

  @override
  void didUpdateWidget(covariant FavoriteIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync if external change happens (though we rely mostly on local state for speed)
    isFavorite = FavoriteService.isFavorite(widget.reciter.id);
  }

  void _toggleFavorite() {
    if (isFavorite) {
      // Remove Logic with Dialog
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('إزالة من المفضلة'),
          content: const Text('هل تريد إزالة هذا القارئ من المفضلة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                setState(() {
                  isFavorite = false;
                });
                widget.cubit.toggleFavorite(widget.reciter.id);
              },
              child: const Text('إزالة', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      // Add Logic with SnackBar
      setState(() {
        isFavorite = true;
      });
      widget.cubit.toggleFavorite(widget.reciter.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white),
              const SizedBox(width: 8),
              const Text('تمت الإضافة للمفضلة'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: _toggleFavorite,
    );
  }
}


