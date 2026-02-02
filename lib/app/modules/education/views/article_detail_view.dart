import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/app_colors.dart';
import '../../../data/models/educational_content_model.dart';
import '../../../data/repositories/education_repository.dart';

class ArticleDetailView extends StatefulWidget {
  const ArticleDetailView({super.key});

  @override
  State<ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {
  final EducationRepository _repository = EducationRepository();
  EducationalContentModel? article;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadArticle();
  }

  Future<void> _loadArticle() async {
    final id = Get.parameters['id'];
    if (id == null) {
      setState(() {
        error = 'ID artikel tidak ditemukan';
        isLoading = false;
      });
      return;
    }

    try {
      final data = await _repository.getContentDetails(int.parse(id));
      if (mounted) {
        setState(() {
          article = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Gagal memuat artikel: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Center(child: Text(error!))
            : article == null
            ? const Center(child: Text('Artikel tidak ditemukan'))
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(child: _buildContent()),
                ],
              ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250.h,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Iconsax.arrow_left, color: Colors.white),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: article!.thumbnailUrl != null
            ? Image.network(
                article!.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildPlaceholderImage(),
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Center(
        child: Icon(
          Iconsax.book5,
          size: 64.sp,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              article!.categoryText,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          Text(
            article!.title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          SizedBox(height: 16.h),

          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: article!.author?.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          article!.author!.avatarUrl!,
                          width: 36.r,
                          height: 36.r,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Iconsax.user, size: 18.sp, color: AppColors.primary),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article!.author?.name ?? 'Tim Irtiqa',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    article!.publishedAt != null
                        ? DateFormat(
                            'dd MMM yyyy',
                          ).format(article!.publishedAt!)
                        : DateFormat('dd MMM yyyy').format(article!.createdAt),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Iconsax.eye, size: 16.sp, color: AppColors.textMuted),
                  SizedBox(width: 4.w),
                  Text(
                    '${article!.viewsCount}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          const Divider(),
          SizedBox(height: 24.h),

          MarkdownBody(
            data: article!.content,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textSecondary,
                height: 1.7,
              ),
              h1: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              h2: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              h3: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

